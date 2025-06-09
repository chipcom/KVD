#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

&& ***** 13.01.18 / 10.10.18
&& function input_usluga( arr_tfoms )
	&& local ar, musl, arr_usl, buf, fl_tfoms := ( valtype( arr_tfoms ) == 'A' )
	&& local oService

	&& ar := GetIniSect( tmp_ini, 'uslugi' )
	&& musl := padr( a2default( ar, 'shifr' ), 10 )
	&& if ( musl := input_value( 18, 6, 20, 73, color1, ;
			&& space( 17 ) + 'Введите шифр услуги', musl, '@K' ) ) != nil .and. !empty( musl )
		&& buf := save_maxrow()
		&& mywait()
		&& musl := transform_shifr( musl )
		&& SetIniSect( tmp_ini, 'uslugi', { { 'shifr', musl } } )
		&& // R_Use( dir_server + 'uslugi', dir_server + 'uslugish', 'USL' )
		&& // find ( musl )
		&& // if found()
			&& // susl := musl
			&& // arr_usl := { usl->kod, alltrim( usl->shifr ) + '. ' + alltrim( usl->name ), usl->shifr }
		&& // else
			&& // func_error( 4, 'Услуга с шифром ' + alltrim( musl ) + ' не найдена в нашем справочнике!' )
			&& // if fl_tfoms
				&& // arr_usl := { 0, '', '' }
			&& // endif
		&& // endif
		&& // usl->(dbCloseArea())
		&& oService := TServiceDB():getByShifr( musl )
		&& if isnil( oService )
			&& func_error( 4, 'Услуга с шифром ' + alltrim( musl ) + ' не найдена в нашем справочнике!' )
			&& if fl_tfoms
				&& arr_usl := { 0, '', '' }
			&& endif
		&& else
			&& susl := musl
			&& arr_usl := { oService:Code, alltrim( oService:Shifr ) + '. ' + alltrim( oService:Name ), oService:Shifr }
			&& oService := nil
		&& endif
		&& if fl_tfoms
			&& // use_base( 'lusl' )
			&& // find ( musl )
			&& // if found()
				&& // arr_tfoms[ 1 ] := lusl->(recno())
				&& // arr_tfoms[ 2 ] := alltrim( lusl->shifr ) + '. ' + alltrim( lusl->name )
				&& // arr_tfoms[ 3 ] := lusl->shifr
			&& // endif
			&& // lusl->(dbCloseArea())
			&& // lusl17->(dbCloseArea())
			&& oService := T_mo8usl():getByShifr( musl )
			&& if ! isnil( oService )
				&& arr_tfoms[ 1 ] := oService:ID
				&& arr_tfoms[ 2 ] := alltrim( oService:Shifr ) + '. ' + alltrim( oService:Name )
				&& arr_tfoms[ 3 ] := oService:Shifr
				&& oService := nil
			&& endif
		&& endif
		&& rest_box( buf )
	&& endif
	&& return arr_usl

***** 01.04.14
function ob2_v_usl( is_get, r1, mtitul )
	local t_arr[ BR_LEN ], buf := savescreen(), k, ret
	
	DEFAULT is_get TO .f., r1 TO T_ROW
	if r1 > 14 ; r1 := 14 ; endif
	R_Use( dir_server + 'uslugi', dir_server + 'uslugish', 'USL' )
	use ( cur_dir() + 'tmp' ) index ( cur_dir() + 'tmpk' ), ( cur_dir() + 'tmpn' ) new alias TMP
	set order to 2
	t_arr[ BR_TOP ] := r1
	t_arr[ BR_BOTTOM ] := maxrow()-2
	t_arr[ BR_LEFT ] := 1
	t_arr[ BR_RIGHT ] := 78
	t_arr[ BR_COLOR ] := color0
	t_arr[ BR_TITUL ] := mtitul
	t_arr[ BR_TITUL_COLOR ] := 'B/BG'
	t_arr[ BR_OPEN ] := { | | !eof() }
	t_arr[ BR_ARR_BROWSE ] := { '═', '░', '═', , .t. }
	t_arr[ BR_COLUMN ] := { { '   Шифр', { | | tmp->u_shifr } }, ;
                     { center( 'Наименование услуги', 65 ), { | | left( tmp->u_name, 65 ) } } }
	t_arr[ BR_STAT_MSG ] := { | | ;
					status_key( '^<Esc>^ выход;  ^<Ins>^ добавление;  ^<Del>^ удаление услуги;  ^<F9>^ печать списка' ) }
	t_arr[ BR_EDIT ] := { | nk, ob | ob21v_usl( nk, ob, 'edit', mtitul ) }
	edit_browse( t_arr )
	if is_get
		go top
		k := 0
		dbeval( { | | if( tmp->u_kod > 0, ++k, nil ) } )
		ret := { k, 'Кол-во услуг - ' + lstr( k ) }
	endif
	tmp->(dbCloseArea())
	usl->(dbCloseArea())
	restscreen( buf )
	if !is_get
		WaitStatus( '<Esc> - прервать поиск') ; mark_keys( {'<Esc>' } )
	endif
	return ret

&& ***** вернуть процент выполнения плана
&& function ret_trudoem( lkod_vr, ltrudoem, kol_mes, arr_m, /*@*/plan )
	&& local i := 0, trd := 0, ltrud, tmp_select := select()

	&& plan := 0
	&& do while i < kol_mes
		&& ltrud := 0
		&& // сначала поиск конкретного месяца
		&& select UCHP
		&& find ( str( lkod_vr, 4 ) + str( arr_m[ 1 ], 4 ) + str( arr_m[ 2 ] + i, 2 ) )
		&& if found()
			&& ltrud := uchp->m_trud
		&& endif
		&& if empty(ltrud)  // если не нашли
			&& // то поиск среднемесячного плана
			&& select UCHP
			&& find ( str( lkod_vr, 4 ) + str( 0, 4 ) + str( 0, 2 ) )
			&& if found()
				&& ltrud := uchp->m_trud
			&& endif
		&& endif
		&& plan += ltrud
		&& ++i
	&& enddo
	&& if plan > 0
		&& trd := ltrudoem / plan * 100
	&& endif
	&& select ( tmp_select )
	&& return trd

*****
function ob21v_usl( nKey, oBrow, regim, mtitul )
	local ret := -1, s
	local buf, fl := .f., rec, rec1, k := 19, tmp_color, n_file, sh := 80, HH := 60
	
	do case
		case regim == 'edit'
			do case
				case nKey == K_F9
					DEFAULT mtitul TO "Список выбранных услуг"
					buf := save_row( maxrow() )
					mywait()
					rec := recno()
					Private reg_print := 2
					n_file := 'ob2_v_us.txt'
					fp := fcreate( n_file ) ; n_list := 1 ; tek_stroke := 0
					add_string( '' )
					add_string( center( mtitul, sh ) )
					add_string( '' )
					go top
					do while !eof()
						verify_FF( HH, .t., sh )
						s := tmp->u_shifr
						select USL
						find ( tmp->u_shifr )
						if found() .and. !empty( usl->shifr1 ) .and. !( tmp->u_shifr == usl->shifr1 )
							s += '(' + alltrim( usl->shifr1 ) + ')'
						endif
						add_string( s + alltrim( tmp->u_name ) )
						select TMP
						skip
					enddo
					goto ( rec )
					fclose( fp )
					rest_box( buf )
					viewtext( n_file, , , , ( .t. ), , , reg_print )
				case nKey == K_INS
					save screen to buf
					private mshifr := space( 10 )
					tmp_color := setcolor( cDataCScr )
					box_shadow( k, pc1 + 1, 21, pc2 - 1, , 'Добавление услуги', cDataPgDn )
					setcolor( cDataCGet )
					@ k + 1, pc1 + 27 say 'Шифр услуги' get mshifr picture '@!' valid valid_shifr()
					status_key( '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода' )
					myread()
					if lastkey() != K_ESC .and. !empty( mshifr )
						if '*' == alltrim( mshifr )
							func_error( 4,'Воспользуйтесь режимом "Все услуги"!' )
						elseif '*' $ mshifr .or. '?' $ mshifr
							mshifr := alltrim( mshifr )
							mywait()
							select USL
							go top
							do while !eof()
								if like( mshifr, usl->shifr ) .or. like( mshifr, usl->shifr1 )
									select TMP
									set order to 1
									fl_found := fl := .t.
									AddRec( 4 )
									ret := 0
									replace tmp->u_shifr with usl->shifr, tmp->u_name with usl->name, ;
											tmp->u_kod with usl->kod
								endif
								select USL
								skip
							enddo
							select TMP
							set order to 2
							if fl
								oBrow:goTop()
							else
								func_error( 4, 'Не найдено услуг по шаблону <' + mshifr + '>.' )
							endif
						else
							select USL
							find ( mshifr )
							fl := found()
							select TMP
							if fl
								set order to 1
								fl_found := .t.
								AddRec( 4 )
								rec := recno()
								replace tmp->u_shifr with mshifr, tmp->u_name with usl->name, ;
										tmp->u_kod with usl->kod
								set order to 2
								oBrow:goTop()
								goto ( rec )
								ret := 0
							else
								func_error( 4, 'Услуги с указанным шифром в справочнике отсутствует!' )
							endif
						endif
					endif
					if !fl_found
						ret := 1
					endif
					setcolor( tmp_color )
					restore screen from buf
				case nKey == K_DEL .and. !empty( tmp->u_kod )
					rec1 := 0
					rec := recno()
					skip
					if !eof()
						rec1 := recno()
					endif
					goto ( rec )
					DeleteRec()
					if rec1 == 0
						oBrow:goBottom()
					else
						goto ( rec1 )
					endif
					ret := 0
					if eof()
						ret := 1
					endif
			endcase
	endcase
	return ret
