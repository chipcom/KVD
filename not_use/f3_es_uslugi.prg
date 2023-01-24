* 13.04.18 f3_es_uslugi( nKey ) - редактирование услуги

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'set.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

***** 13.04.18
function f3_es_uslugi( nKey )
	static menu_nul := { { 'нет', .f. }, { 'да', .t. } }
	static menu_VAT := { { 'Без НДС', 0 }, { 'НДС 10%', 10 }, { 'НДС 18%', 18 } }
	local tmp_help := chm_help_code, buf := savescreen(), r, r1 := maxrow() - 11, ;
		k, tmp_color := setcolor(), ret := usl->(recno()), old_m1otd, s, is_full
		
	private mkod, mname, mpcena, mpcena_d, mshifr, mshifr1, mcena, mcena_d, ;
		m1shifr1, m1PROFIL, mPROFIL, ;
		mpnds, m1pnds, mpnds_d, m1pnds_d, ;
		mzf, m1zf, ;
		mdms_cena, m1is_nul, mis_nul, motdel := space( 10 ), m1otdel := '', ;
		mname1 := '', mslugba, m1slugba, gl_area, ;
		m1is_nulp, mis_nulp, yes_tfoms := .f., pifin := 0, pifinr, pifinc

	if ( is_full := ( is_task( X_ORTO ) .or. is_task( X_KASSA ) .or. is_task( X_PLATN ) ) )
		r1 -= 4 
	endif
	gl_area := { r1 + 1, 0, 23, 79, 0 }
//
	select TMP_USL1
	zap
//
	mkod      := if( nKey == K_INS, 0, usl->kod)
	mname     := if( nKey == K_INS, SPACE( 65 ), usl->name )
	mfull_name:= if( nKey == K_INS, SPACE( 255 ),usl->full_name )
	mshifr    := if( nKey == K_INS, space( 10 ), usl->shifr )
	mshifr1   := if( nKey == K_INS, space( 10 ), usl->shifr1 )
	m1PROFIL  := if( nKey == K_INS, 0, usl->profil )
	mPROFIL   := inieditspr( A__MENUVERT, getV002(), m1PROFIL )
	mcena     := if( nKey == K_INS, 0, usl->cena )
	mcena_d   := if( nKey == K_INS, 0, usl->cena_d )
	mpcena    := if( nKey == K_INS, 0, usl->pcena )
	mpcena_d  := if( nKey == K_INS, 0, usl->pcena_d )
	
	m1pnds    := if( nKey == K_INS, 0, usl->pnds )
	&& mpnds     := if( nKey == K_INS, 0, usl->pnds )
	mpnds     := inieditspr( A__MENUVERT, menu_VAT, m1pnds )
	m1pnds_d  := if( nKey == K_INS, 0, usl->pnds_d )
	&& mpnds_d   := if( nKey == K_INS, 0, usl->pnds_d )
	mpnds_d   := inieditspr( A__MENUVERT, menu_VAT, m1pnds_d )
	
	mdms_cena := if( nKey == K_INS, 0, usl->dms_cena )
	m1slugba  := if( nKey == K_INS, -1, usl->slugba )
	m1zf      := if( nKey == K_INS, .f., ( usl->zf == 1 ) )
	mzf       := inieditspr( A__MENUVERT, menu_nul, m1zf )
	m1is_nul  := if( nKey== K_INS, .f., usl->is_nul )
	mis_nul   := inieditspr( A__MENUVERT, menu_nul, m1is_nul )
	m1is_nulp := if( nKey == K_INS, .f., usl->is_nulp )
	mis_nulp  := inieditspr( A__MENUVERT, menu_nul, m1is_nulp )
	if m1slugba >= 0
		select SL
		find ( str( m1slugba, 3 ) )
		mslugba := lstr( sl->shifr ) + '. ' + alltrim( sl->name )
	else
		mslugba := space( 10 )
	endif
	if nKey == K_ENTER // редактирование
		if ! empty( s := f0_e_uslugi1( mkod, , .t. ) )
			mshifr1 := s
		endif
		select UO
		find ( str( mkod, 4 ) )
		if found()
			k := atnum( chr( 0 ), uo->otdel, 1 )
			motdel := '= ' + lstr( k - 1 ) + 'отд. ='
			m1otdel := left( uo->otdel, k - 1 )
		endif
	endif
	m1shifr1 := mshifr1
	old_m1otd := m1otdel
	chm_help_code := 1//H_Edit_uslugi
	//
	setcolor( color8 )
	scroll( r1, 0, maxrow() - 1, maxcol() )
	@ r1, 0 to r1, maxcol()
	status_key( '^<Esc>^ - выход без записи;  ^<PgDn>^ - запись' )
	if nKey == K_INS
		str_center( r1, ' Добавление услуги ' )
	else
		str_center( r1, ' Редактирование ' )
	endif
	f4_es_uslugi( 0 )
	do while .t.
		setcolor( cDataCGet )
		if !m1is_nul
			keyboard chr( K_TAB )
		endif
		r := r1
		@ ++r, 1 say 'Разрешается ввод данной услуги по НУЛЕВОЙ цене в задаче ОМС?' ;
			get mis_nul reader { | x | menu_reader( x, menu_nul, A__MENUVERT, , , .f. ) }
		@ ++r, 1 say 'Наименование услуги по справочнику ТФОМС'
		@ ++r, 3 get mname1 when .f. color color14
		@ ++r, 1 say 'Шифр МО' get mshifr picture '@!' valid f4_es_uslugi( 1, .t., nKey )
		@ row(), col() + 5 say 'шифр ТФОМС' get mshifr1 ;
			reader { | x | menu_reader( x, { { | k, r, c | f1_e_uslugi1( k, r, c ) } }, A__FUNCTION, , , .f. ) } ;
			valid f4_es_uslugi( 0 ) ;
			color 'R/W'
		if is_zf_stomat == 1
			@ row(), col() + 5 say 'Ввод зубной формулы' get mzf ;
				reader { | x | menu_reader( x, menu_nul, A__MENUVERT, , , .f. ) }
		endif
		@ ++r, 1 say 'Наименование услуги' get mname picture '@S59'
		if is_full
			@ ++r, 1 say 'Наименование/платные' get mfull_name picture '@S58'
		endif
		@ ++r, 1 say 'Цена услуги ОМС: для взрослого' get mcena picture pict_cena when !yes_tfoms color color14
		@ row(), col() say ', для ребенка' get mcena_d picture pict_cena when !yes_tfoms color color14
		@ ++r, 1 say 'Профиль' get MPROFIL ;
			reader { | x | menu_reader( x, tmp_V002, A__MENUVERT_SPACE, , , .f. ) }
		if is_full
			@ ++r, 1 say 'Разрешается ввод ПЛАТНОЙ услуги по НУЛЕВОЙ цене?' ;
				get mis_nulp reader { | x | menu_reader( x, menu_nul, A__MENUVERT, , , .f. ) }
			@ ++r, 1 say 'Цена ПЛАТНОЙ услуги: для взрослого' get mpcena picture pict_cena
			&& @ row(), col() say ' (в т.ч. НДС' get mpnds picture pict_cena
			@ row(), col() say ' ( в т.ч. НДС' ;
				get mpnds  reader { | x | menu_reader( x, menu_VAT, A__MENUVERT, , , .f. ) }
			@ row(), col() say ' )'
			@ ++r, 1 say '   для ребенка' get mpcena_d picture pict_cena
			&& @ row(), col() say ' (в т.ч. НДС' get mpnds_d picture pict_cena
			@ row(), col() say ' ( в т.ч. НДС' ;
				get mpnds_d reader { | x | menu_reader( x, menu_VAT, A__MENUVERT, , , .f. ) }
			@ row(), col() say ' ); цена по ДМС' get mdms_cena picture pict_cena
		endif
		@ ++r, 1 say 'Служба' get mslugba ;
			reader { | x | menu_reader( x, { { | k, r, c | fget_slugba( k, r, c ) } }, A__FUNCTION, , , .f. ) } ;
			color 'R/W'
		@ ++r, 1 say 'В каких отделениях разрешается ввод услуги' get motdel ;
			reader { | x | menu_reader( x, { { | k, r, c | inp_bit_otd( k, r, c ) } }, A__FUNCTION, , , .f. ) }
		myread()
		if lastkey() != K_ESC
			fl := .t.
			if empty( mname )
				fl := func_error( 'Не введено название услуги. Нет записи.' )
			elseif empty( mshifr )
				fl := func_error( 'Не введен шифр услуги. Нет записи.' )
			endif
			if fl
				mywait()
				select USL
				SET ORDER TO 2
				if nKey == K_INS
					FIND ( str( -1, 4 ) )
					if found()
						G_RLock( forever )
					else
						AddRec( 4 )
					endif
					mkod := recno()
					usl->kod := mkod
				else
					FIND ( str( mkod, 4 ) )
					G_RLock( forever )
				endif
				usl->name     := mname
				usl->full_name:= mfull_name
				usl->shifr    := mshifr
				usl->shifr1   := mshifr1
				usl->PROFIL   := m1PROFIL
				usl->zf       := iif( m1zf, 1, 0 )
				usl->is_nul   := m1is_nul
				usl->is_nulp  := m1is_nulp
				usl->slugba   := m1slugba
				if valtype( mcena ) == 'C'
					usl->cena   := val( mcena )
					usl->cena_d := val( mcena_d )
				else
					usl->cena   := mcena
					usl->cena_d := mcena_d
				endif
				usl->pcena    := mpcena
				usl->pcena_d  := mpcena_d
				usl->dms_cena := mdms_cena
				&& usl->pnds     := mpnds
				&& usl->pnds_d   := mpnds_d
				usl->pnds     := m1pnds
				usl->pnds_d   := m1pnds_d
				//
				select USL1
				do while .t.
					find ( str( mkod, 4 ) )
					if !found() ; exit ; endif
					DeleteRec( .t. )
				enddo
				select TMP_USL1
				go top
				do while !eof()
					select USL1
					AddRec( 4 )
					usl1->kod    := mkod
					usl1->shifr1 := tmp_usl1->shifr1
					usl1->date_b := tmp_usl1->date_b
					select TMP_USL1
					skip
				enddo
				//
				if !( old_m1otd == m1otdel )
					select UO
					if len( m1otdel ) == 0
						find ( str( mkod, 4 ) )
						if found()
							DeleteRec( .t. )
						endif
					else
						find ( str( mkod, 4 ) )
						if found()
							G_RLock( forever )
						else
							AddRec( 4 )
							uo->kod := mkod
						endif
						uo->otdel := padr( m1otdel, 255, chr( 0 ) )
					endif
				endif
				UNLOCK ALL
				COMMIT
				ret := mkod
			else
				loop
			endif
		endif
		exit
	enddo
	chm_help_code := tmp_help
	restscreen( buf )
	setcolor( tmp_color )
	select USL
	set order to 1
	return ret

