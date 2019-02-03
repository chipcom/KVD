#include 'set.ch'
#include 'getexit.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'common.ch'

#include 'hbthread.ch'

***** 03.02.19 возврат кода по картотеке
function polikl1_kart()
	static sesc := '^<Esc>^ выход  '
	static senter := '^<Enter>^ ввод  '
	static sF10p := '^<F10>^ поиск по полису  '
	static sF10f := '^<F10>^ поиск по ФИО  '
	static sF10s := '^<F10>^ поиск по СНИЛС  '
	static sF11 := '^<F11>^ читать электронный полис'
	static s_regim := 1, s_shablon := '', s_polis := '', s_snils := ''
	
	local tmp1, tmp_help := chm_help_code, mkod := -1, i, fl_number := .t., ;
		k1 := 0, k2 := 1, str_sem, mbukva := '', tmp_color, buf, buf24, ar, s
	
	local oSetEquipment := TSettingEquipment():New( 'Equipment' )
	local oScanner := TComDescription():New( oSetEquipment:ScannerPort )
	local oWinPort
	local pThID
	
	chm_help_code := 1//HK_shablon_fio
	// обмен информацией с программой Smart Delta Systems
	import_kart_from_sds()
	/////////////////////////////////////////////////////
	private tmp, name_reader := ''
	ar := GetIniVar( tmp_ini, { { 'polikl1'  , 's_regim'  , '1' }, ;
							{ 'polikl1'  , 's_shablon', '' }, ;
							{ 'polikl1'  , 's_polis'  , '' }, ;
							{ 'polikl1'  , 's_snils'  ,'' }, ;
							{ 'RAB_MESTO', 'sc_reader', '' } } )
	if ! eq_any( s_regim := int( val( ar[ 1 ] ) ), 1, 2, 3 )
		s_regim := 1
	endif
	s_shablon := ar[ 2 ]
	s_polis   := ar[ 3 ]
	s_snils   := ar[ 4 ]
	name_reader := ar[ 5 ]

	if lower( alltrim( oScanner:PortName ) ) != 'нет'
		// откроем COM-порт на котором подключен сканер
		oWinPort := win_com():Init( oScanner:PortName, WIN_CBR_9600, WIN_ODDPARITY, 7, WIN_ONESTOPBIT )
		if oWinPort:Open()
			// запустим новый поток для управления сканером штрих-кода
			pThID := hb_threadStart( HB_THREAD_MEMVARS_COPY, @readBarcode(), oWinPort )
		endif
	endif
	
	do while .t.	// главный цикл ввода
		buf24 := save_maxrow()
		if s_regim == 1
			if empty( s_shablon )
				s_shablon := '*'
			endif
			tmp := padr( s_shablon, 20 )
			tmp_color := setcolor( color1 )
			buf := box_shadow( 18, 9, 20, 70 )
			@ 19,11 say 'Введите шаблон для поиска в картотеке' get tmp pict '@K@!'
			s := sesc + senter + sF10p
			if ! empty( name_reader )
				s += sF11
			endif
			status_key( alltrim( s ) )
		elseif s_regim == 2
			tmp := padr( s_polis, 17 )
			tmp_color := setcolor( color8 )
			buf := box_shadow( 18, 9, 20, 70 )
			@ 19,13 say 'Введите ПОЛИС для поиска в картотеке' get tmp pict '@K@!'
			s := sesc + senter + sF10s
			if ! empty( name_reader )
				s += sF11
			endif
			status_key( alltrim( s ) )
		else
			tmp := padr( s_snils, 11 )
			tmp_color := setcolor( color14 )
			buf := box_shadow( 18, 9, 20, 70 )
			@ 19,14 say 'Введите СНИЛС для поиска в картотеке' get tmp pict '@K' + picture_pf valid val_snils( tmp, 1 )
			s := sesc + senter + sF10f
			if ! empty( name_reader )
				s += sF11
			endif
			status_key( alltrim( s ) )
		endif
		set key K_F10 TO clear_gets
		if ! empty( name_reader )
			set key K_F11 TO clear_gets
		endif
		myread( { 'confirm' } )
		set key K_F11 TO
		set key K_F10 TO
		setcolor( tmp_color )
		rest_box( buf24 )
		rest_box( buf )
		
		if ! isnil( pThID )
			// выключим поток для управления сканером штрих-кода
			hb_threadQuitRequest( pThID )
			oWinPort:Close()
		endif
		
		if lastkey() == K_F10
			s_regim := iif( ++s_regim == 4, 1, s_regim )
		elseif lastkey() == K_F11 .and. ! empty( name_reader )
			if mo_read_el_polis()
				mkod := glob_kartotek
				exit
			endif
		else
			if lastkey() == K_ESC
				tmp := nil
			else
				if s_regim == 1
					s_shablon := alltrim( tmp )
				elseif s_regim == 2
					s_polis := tmp
				else
					s_snils := tmp
				endif
			endif
			exit
		endif
	enddo

	chm_help_code := tmp_help
	if tmp == nil .or. mkod > 0
		if tmp == nil // нажали ESC
			mkod := 0
		endif
	elseif s_regim == 1
		s_shablon := alltrim( tmp )
		if empty( tmp := alltrim( tmp ) )
			mkod := 0
		elseif tmp == '*'
			if view_kart( 0, T_ROW )
				mkod := glob_kartotek
			else
				mkod := 0
			endif
		else
			if is_uchastok == 1
				tmp1 := tmp
				if ! ( left( tmp, 1 ) $ '0123456789' )
					mbukva := left( tmp1, 1 )
					tmp1 := substr( tmp1, 2 )  // отбросить первую букву
				endif
				for i := 1 to len( tmp1 )
					if ! ( substr( tmp1, i, 1 ) $ '0123456789/' )
						fl_number := .f.
						exit
					endif
				next
				if fl_number
					if ( i := at( '/', tmp1 ) ) == 0
						fl_number := .f.
					else
						tmp := padl( alltrim( substr( tmp1, 1, i - 1 ) ), 2, '0' ) + ;
								padl( alltrim( substr( tmp1, i + 1 ) ), 5, '0' )
					endif
				endif
			else
				for i := 1 to len( tmp )
					if ! ( substr( tmp, i, 1 ) $ '0123456789' )
						fl_number := .f.
						exit
					endif
				next
			endif
			if ! fl_number
				if ! ( '*' $ tmp )
					tmp += '*'
				endif
			endif
			if fvalid_fio( 1, tmp, fl_number, mbukva )
				mkod := glob_kartotek
			else
				fl_bad_shablon := .t.
			endif
		endif
	elseif eq_any( s_regim, 2, 3 )  // поиск по полису/по СНИЛС
		if empty( tmp )
			mkod := 0
		else
			if fvalid_fio( s_regim, tmp, fl_number, mbukva )
				mkod := glob_kartotek
			else
				fl_bad_shablon := .t.
			endif
		endif
	endif
	SetIniSect( tmp_ini, 'polikl1', { { 's_regim'  ,lstr( s_regim ) }, ;
									{ 's_shablon', s_shablon    }, ;
									{ 's_polis'  , s_polis      }, ;
									{ 's_snils'  , s_snils      } } )
	return mkod

* 03.02.19
* функция чтения штрих-кода со сканера подключенного к COM-порту
function readBarcode( oWinPort )
	local cString := space( 132 )
	local lCTSHold, lDSRHold, lDCDHold, lXoffHold, lXoffSent, nInQueue, nOutQueue
	local char, cOMScode := '', sResult
	local oCLR, oAssembly, oClass
	
	do while .t.
		if oWinPort:QueueStatus( @lCTSHold, @lDSRHold, @lDCDHold, @lXoffHold, @lXoffSent, @nInQueue, @nOutQueue )
			if nInQueue == 132
				oWinPort:Read( @cString, 132 )
				cString	:= substr( cString, 1, 130 )
				cOMScode := ''
				for each char in cString
					cOMScode += hb_NumToHex( asc( char ), 2 )
				next
				// Creating new CLR runtime (look %WINDIR%\Microsoft.NET\Framework for installed versions)
				oCLR := CLR_RUNTIME():New( 'v4.0.30319' )

				// Loading assembly (DLL)
				oAssembly := oCLR:LoadAssembly( 'Chip.Harbour' )
				// Calling constructor for type 'Chip.Harbour' with different arguments
				oClass := oAssembly:CreateInstance( 'Chip.Harbour.getXMLPolicyOMS' )
				sResult := oClass:Call( 'decodePolicyOMS', cOMScode )
				sResult[ 3 ] := hb_Translate( sResult[ 3 ], 'UTF8', 'cp866' )
				sResult[ 4 ] := hb_Translate( sResult[ 4 ], 'UTF8', 'cp866' )
				sResult[ 5 ] := hb_Translate( sResult[ 5 ], 'UTF8', 'cp866' )
				sResult[ 6 ] := substr( sResult[ 6 ], 1, 10 )
				sResult[ 7 ] := substr( sResult[ 7 ], 1, 10 )
				sResult[ 8 ] := hb_Translate( sResult[ 8 ], 'UTF8', 'cp866' )
				win_alertx( win_OEMToANSI( sResult[ 3 ] + ' ' + sResult[ 4 ] + ' ' + sResult[ 5 ] ) )
			endif
		else
		endif
		hb_idleSleep( 0.5 )
	enddo
	return nil