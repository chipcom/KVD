* Services.prg - ࠡ�� � ��㣠�� �࣠����樨
*******************************************************************************
* 05.11.18 editLevelPayments( nType ) - ।���஢���� �஢��� ������
* 05.11.18 editComponentsIntegratedServices( cShifr, aServices ) - ।���஢���� ���������� ���
* 05.11.18 editIntegratedServices() - ।���஢���� ���������� ���
* 05.11.18 editIncompatibleServices( idService ) - ।���஢���� ᯨ᪠ ��ᮢ������ ���
* 05.11.18 editCompositionIncompServices() - ।���஢���� ������������ ��ᮢ������ ���
* 05.11.18 editServiceWoDoctor( oBrowse, aObjects, oService, nKey ) - ।���஢���� ��ꥪ�  ��㣠 ��� ��祩
* 29.10.18 editComponemtIntegratedService( oBrowse, aObjects, oService, nKey, cShifr ) - ।���஢���� ��ꥪ� �������᭮� ��㣨
* 29.10.18 layoutComponentIntegratedService( oBrow, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� ᯨ᪠ ���������� ���
* 29.10.18 editIntegratedService( oBrowse, aObjects, oService, nKey ) - ।���஢���� ��ꥪ� ���������� ���
* 29.10.18 editIncompatibleService( oBrowse, aObjects, oService, nKey ) - ।���஢���� ��ꥪ� ��ᮢ���⨬�� ��㣠
* 28.10.18 editServicesWoDoctor() - ।���஢���� ��� ��� ��祩
* 28.10.18 editCompositionIncompService( oBrowse, aObjects, oService, nKey ) - ।���஢���� ��ꥪ� ��ᮢ���⨬�� ��㣠

* 20.09.18 valid_shifr_Bay( get, xValue ) - �஢�ઠ �����⨬��� ��� ��㣨
* 20.09.18 inputService( oBrowse, parr, nDim, nElem, nKey ) - ���� ��㣨 � ���ᨢ
* 19.09.18 FillArrayServices() - ���������� ���ᨢ� �⮡࠭�묨 ��㣠��
*
* 27.05.17 checkShifrServiceWoDoctor( get, nKey, arr ) - �஢�ઠ �����⨬��� ��� ��㣨
* 18.04.17 CheckDeleteServiceWoDoctor() - �஢�ઠ �����⨬��� 㤠����� ��� ��� ��祩
* 24.05.17 SelectService( arr_tfoms ) - �롮� ��㣨
*******************************************************************************

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'set.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

static lregim

* 19.09.18 ���������� ���ᨢ� �⮡࠭�묨 ��㣠��
function FillArrayServices()
	local mas1 := {}, buf := savescreen(), i, arr := {}
	local mas2 := { { 1, '����' }, { 2, '������������' } }
	local blk := { | oBrowse, ar, nDim, nElem, nKey | inputService( oBrowse, ar, nDim, nElem, nKey ) }

	if len( mas1 ) == 0
		aadd( mas1, { space( 10 ), space( 50 ), 0 } )
	endif
	change_attr()
	Arrn_Browse( 14, 1, maxrow() - 2, 78, mas1, mas2, 1, , color1, '���� ᯨ᪠ ���', 'G+/B', ;
				.t., , , blk, { .t., .t., .f. } )
	for i := 1 to len( mas1 )
		if ! empty( mas1[ i, 1 ] ) .and. ascan( arr, { | x | x[ 2 ] == mas1[ i, 3 ] } ) == 0
			aadd( arr, { mas1[ i, 1 ], mas1[ i, 3 ] } )
		endif
	next
	if len( arr ) == 0
		arr := nil
	endif
	restscreen( buf )
	return arr

* 20.09.18 �஢�ઠ �����⨬��� ��� ��㣨
function valid_shifr_Bay( get, xValue )
	local cShifr := ''
	local oService := nil
	local flag := .t.
	
	cShifr := transform_shifr( get:buffer )
	oService := TServiceDB():getByShifr( cShifr )
	if isnil( oService )
		hb_Alert( '��㣠 � ��஬ ' + alltrim( cShifr ) + ' ��������� � �ࠢ�筨�� ���!', , , 4 )
		flag := .f.
	endif
	xValue := padr( cShifr, 10 )
	return flag

* 20.09.18 - ���� ��㣨 � ���ᨢ
function inputService( oBrowse, parr, nDim, nElem, nKey )
	local nRow := row(), nCol := col(), flag := .f.		//, mpic := { '99999' }
	local oService := nil
	local cShifr := space( 10 )
	local buf, tmp_color
	local i := 0
	
	do case
		case nKey == K_DOWN
			oBrowse:panHome()
		case nKey == K_INS
			save screen to buf
			tmp_color := setcolor( cDataCScr )
			box_shadow( 19, 7, 21, 72, , '���������� ��㣨', cDataPgDn )
			setcolor( cDataCGet )
	                    
			@ 20, 33 say '���� ��㣨' get cShifr picture '@!' valid { | get | valid_shifr_Bay( get, @cShifr ) }
			status_key( '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����' )
			myread()
			if lastkey() != K_ESC .and. ! empty( cShifr )
				oService := TServiceDB():getByShifr( cShifr )
				if ! isnil( oService )
					if ( i := ascan( parr, { | x | alltrim( x[ 1 ] ) == alltrim( cShifr ) } ) ) != 0
						hb_Alert( '�������� ��� 㦥 ��������� � ᯨ᪥!', , , 4 )
						flag := .f.
					else
						parr[ nElem, 1 ] := cShifr
						parr[ nElem, 2 ] := oService:Name
						parr[ nElem, 3 ] := oService:ID
						flag := .t.
					endif
				endif
			endif
			setcolor( tmp_color )
			restore screen from buf
		otherwise
			flag := .f.
	endcase
	&& @ nRow, nCol say ''
	return flag

* 27.05.17 �஢�ઠ �����⨬��� ��� ��㣨
function checkShifrServiceWoDoctor( get, nKey, arr )
	local fl := .t., rec := 0
	local i := 0
	
	mshifr := transform_shifr( mshifr )
	if mshifr != get:original
		if ( i := ascan( arr, { | x | alltrim( x:Shifr ) == alltrim( mshifr ) } ) ) != 0
			fl := .f.
			hb_Alert( '�������� ��� 㦥 ��������� � ᯨ᪥!', , , 4 )
//		else
//			mshifr := get:original
		endif
		if !fl
			mshifr := get:original
		endif
	endif
	return fl
		
* 05.11.18 ।���஢���� ��� ��� ��祩
function editServicesWoDoctor()
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editServiceWoDoctor( oBrowse, aObjects, object, nKey ) }
	
	aProperties := { { 'Shifr', '����', 10 }, { 'IsDoctor_F', '���', 10 }, { 'IsAssistant_F', '���-�', 10 } }
	
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .t. }
	else
		aEdit := { .f., .f., .f., .f. }
	endif
				
	oBox := TBox():New( T_ROW, T_COL + 5, maxrow() - 2, T_COL + 50, .t. )
	oBox:Caption := '��㣨, ��� �� �������� ��� (���.)'
	oBox:CaptionColor := 'B/BG'
	oBox:Color := color5
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ���짮��⥫��, ������ �㭪樨 �� �������
	ListObjectsBrowse( 'TServiceWoDoctor', oBox, TServiceWoDoctorDB():GetList(), 1, aProperties, ;
									blkEditObject, aEdit, , , )
	return nil

* 28.10.18 ।���஢���� ��ꥪ� ��㣠 ��� ��祩
function editServiceWoDoctor( oBrowse, aObjects, oService, nKey )
	local fl := .f.
	local k := maxrow() - 7
	local mm_da_net := { { '�� ', 0 }, { '���', 1 } }

	private mshifr := space( 10 ), mkod_vr := space( 3 ), m1kod_vr := 0, ;
			mkod_as := space( 3 ), m1kod_as := 0
			
	if nKey == K_F9
//		PrintPaymentTable()
	elseif nKey == K_DEL
		TServiceWoDoctorDB():Delete( oService )
		fl := .t.
	elseif nKey == K_INS .or. nKey == K_F4 .or. (nKey == K_ENTER .and. !empty( oService:Shifr ) )
		mshifr	:= if( nkey == K_INS, space( 10 ), oService:Shifr )
		m1kod_vr := if( nkey == K_INS, 0, if( oService:IsDoctor, 1, 0 ) )
		m1kod_as :=  if( nkey == K_INS, 0, if( oService:IsAssistant, 1, 0 ) )
        mkod_vr := inieditspr( A__MENUVERT, mm_da_net, m1kod_vr )
        mkod_as := inieditspr( A__MENUVERT, mm_da_net, m1kod_as )
		
		oBox := TBox():New( k, 20, maxrow() - 3, 59, .t. )
		oBox:Caption := iif( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' )
		oBox:CaptionColor := cDataPgDn
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()
		
		@ k + 1, 22 say '���� ��㣨 (蠡���)' get mshifr ;
	                    valid { | g | checkShifrServiceWoDoctor( g, nKey, aObjects ) }
		@ k + 2, 22 say '�������� ��� ���' get mkod_vr ;
               reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ k + 3, 22 say '�������� ��� ����⥭�' get mkod_as ;
               reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
	
		myread()
		if lastkey() != K_ESC  .and. !empty( mshifr ) .and. f_Esc_Enter( 1 )
				&& .and. ! emptyall( m1kod_vr, m1kod_as )
			oService:Shifr := mshifr
			oService:IsDoctor := if( m1kod_vr == 1, .t., .f. )
			oService:IsAssistant := if( m1kod_as == 1, .t., .f. )
			TServiceWoDoctorDB():Save( oService )
			fl := .t.
		endif
	endif
	return fl

* 24.05.17 �롮� ��㣨
function SelectService( arr_tfoms )
	local ar, musl, arr_usl, buf, fl_tfoms := ( valtype( arr_tfoms ) == 'A' )
	local oService := nil
	local idService := 0
	
	ar := GetIniSect( tmp_ini, 'uslugi' )
	musl := padr( a2default( ar, 'shifr' ), 10 )
	if (musl := input_value( 18, 6, 20, 73, color1, ;
							space( 17 ) + '������ ��� ��㣨', musl, '@K' ) ) != nil .and. !empty( musl )
		buf := save_maxrow()
		mywait()
		musl := transform_shifr( musl )
		SetIniSect( tmp_ini, 'uslugi', { { 'shifr', musl } } )
		
		oService := TServiceDB():getByShifr( musl )
		if oService == nil
			hb_Alert( '��㣠 � ��஬ ' + alltrim( musl ) + ' � �ࠢ�筨�� �� �������!' )
			if fl_tfoms
				arr_usl := { 0, '', '' }
			endif
		endif
		if fl_tfoms
			use_base( 'lusl' )
			find ( musl )
			if found()
				arr_tfoms[ 1 ] := lusl->(recno())
				arr_tfoms[ 2 ] := alltrim( lusl->shifr ) + '. ' + alltrim( lusl->name )
				arr_tfoms[ 3 ] := lusl->shifr
			endif
			lusl->(dbCloseArea())
		endif
		rest_box( buf )
	endif
	return oService

* 05.11.18 ।���஢���� ��ᮢ������ ���
Function editCompositionIncompServices()
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editCompositionIncompService( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Name', '��ᮢ���⨬� ��㣨', 30 } }
	
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .f. }
	else
		aEdit := { .f., .f., .f., .f. }
	endif
				
	oBox := TBox():New( T_ROW, T_COL + 5, maxrow() - 2, T_COL + 50, .t. )
	oBox:Caption := '��ᮢ���⨬� ��㣨'
	oBox:CaptionColor := 'B/BG'
	oBox:Color := color5
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ��ᮢ���⨬�� ���
	ListObjectsBrowse( 'TCompostionIncompService', oBox, TCompostionIncompServiceDB():GetList(), 1, aProperties, ;
									blkEditObject, aEdit, , '^<Ctrl+Enter>^ ��㣨; ^<F9>^ �����',  )
	return nil

* 28.10.18 ।���஢���� ��ꥪ� ��ᮢ���⨬�� ��㣠
function editCompositionIncompService( oBrowse, aObjects, oService, nKey )
	local fl := .f.
	local k := maxrow() - 7
	local lc := T_COL + 5

	if nKey == K_F9
		PrintCompositionIncompServices()
	elseif nKey == K_DEL
		TCompostionIncompServiceDB():Delete( oService )
		fl := .t.
	elseif nKey == K_INS .or. (nKey == K_ENTER .and. !empty( oService:Name ) )
		oBox := TBox():New( k, lc, maxrow() - 4, lc + 33, .t. )
		oBox:Caption := iif( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' )
		oBox:CaptionColor := cDataPgDn
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()

		@ k + 1, lc + 3 say '������������'
		@ k + 2, lc + 3 get oService:Name picture '@S29'
		myread()
		if lastkey() != K_ESC  .and. !empty( oService:Name ) .and. f_Esc_Enter( 1 )
			TCompostionIncompServiceDB():Save( oService )
			fl := .t.
		endif
	elseif nKey == K_CTRL_ENTER .and. !empty( oService:Name )
		editIncompatibleServices( oService:ID )
	endif
	return fl

* 05.11.18 ।���஢���� ��ᮢ������ ���
function editIncompatibleServices( idService )
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	private nIdIncompatible := idService
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editIncompatibleService( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Shifr', '����', 10 }, { 'Name_F', '������������ ��㣨', 60 } }
	
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .f. }
	else
		aEdit := { .f., .f., .f., .f. }
	endif

	oBox := TBox():New( 2, 1, maxrow() - 1, 77, .t. )
	oBox:Caption := '���᮪ ��ᮢ���⨬�� ���'
	oBox:CaptionColor := 'B/BG'
	oBox:Color := color5
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ��ᮢ���⨬�� ���
	ListObjectsBrowse( 'TIncompatibleService', oBox,TIncompatibleServiceDB():GetListComposition( idService ), 1, aProperties, ;
									blkEditObject, aEdit, , , )
	return nil

* 29.10.18 ।���஢���� ��ꥪ� ��ᮢ���⨬�� ��㣠
function editIncompatibleService( oBrowse, aObjects, oService, nKey )
	local fl := .f.
	local k := maxrow() - 10
	local lc := T_COL + 5
	local oBox

	private mname := space( 60 ), mshifr := space( 10 )
	if nKey == K_INS .or. nKey == K_ENTER
		mshifr	:= if( nkey == K_INS, space( 10 ), oService:Shifr )
		mname	:= if( nkey == K_INS, space( 60 ), TServiceDB():getByShifr( mshifr ):Name )
		
		oBox := TBox():New( k, 2, maxrow() - 3, 77, .t. )
		oBox:Caption := iif( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' )
		oBox:CaptionColor := cDataPgDn
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()
		
		@ k + 2, 5 say '���� ��㣨' get mshifr picture '@!' valid checkShifrService()
		@ k + 3, 5 say '������������ ��㣨'
		@ k + 4, 5 get mname when .f.
	
		myread()
		if lastkey() != K_ESC .and. !empty( mshifr ) .and. f_Esc_Enter( 1 )
			oService:Shifr := mshifr
			oService:IDIncompatible := nIdIncompatible
			TIncompatibleServiceDB():Save( oService )
			fl := .t.
		endif
	elseif nKey == K_DEL
		TIncompatibleServiceDB():Delete( oService )
		fl := .t.
	endif
	return fl

*
function checkShifrService()
	local fl := valid_shifr()
	local obj := nil
	
	if fl
		obj := TServiceDB():GetByShifr( mshifr )
		if !isnil( obj )
			mname := obj:Name
		else
			fl := .f.
			hb_Alert( '�������� ��� ��������� � �ࠢ�筨�� ���!', , , 4 )
		endif
	endif
	return fl

// 04.08.23 ।���஢���� ���������� ���
function editIntegratedServices()
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editIntegratedService( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Shifr', '����', 10 }, { 'Name', '������������ �������᭮� ��㣨', 45 }, { 'Doctor_F', '���', 6 }, { 'Assistant_F', '���.', 5 } }
	
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .t. }
	else
		aEdit := { .f., .f., .f., .f. }
	endif

	oBox := TBox():New( 2, 1, maxrow() - 2, 78, .t. )
	oBox:Caption := '������஢���� ���������� ���'
	oBox:CaptionColor := 'B/BG'
	oBox:Color := color5
	ListObjectsBrowse( 'TIntegratedService', oBox, TIntegratedServiceDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 29.10.18 ।���஢���� ��ꥪ� ���������� ���
function editIntegratedService( oBrowse, aObjects, oService, nKey )
	local fl := .f.
	local k := maxrow() - 9
	local oBox
			
    private mshifr, ;
			mshifr1 := space( 10 ), ;		// ��� ᮢ���⨬���
			mname, old_shifr, ;
            mkod_vr := 0, ;
            mkod_as := 0, ;
            mtabn_vr := 0, mtabn_as := 0,;
            mvrach := massist := space(35)
			
	if nKey == K_CTRL_ENTER .and. !empty( oService:Shifr )
		// ���� ��⠢� �������᭮� ��㣨 f3_k_uslugi()
		editComponentsIntegratedServices( oService:Shifr, oService:Services )
	elseif nKey == K_DEL .and. !emptyall( oService:Shifr, oService:Name ).and. f_Esc_Enter(2,.t.)
		mywait()
		TIntegratedServiceDB():Delete( oService )
	elseif nKey == K_INS .or. (nKey == K_ENTER .and. !empty( oService:Shifr ) )
		old_shifr := mshifr	:= if( nkey == K_INS, space( 10 ), oService:Shifr )
		mname := if( nKey == K_INS, space( 60 ), oService:Name() )
		
		mkod_vr := if( oService:HasDoctor, oService:Doctor:ID, 0 )
		mvrach := if( oService:HasDoctor, padr( oService:Doctor:ShortFIO, 35 ), space( 35 ) )
		mtabn_vr := if( oService:HasDoctor, oService:Doctor:TabNom, 0 )
		mkod_as := if( oService:HasAssistant, oService:Assistant:ID, 0 )
		massist := if( oService:HasAssistant, padr( oService:Assistant:ShortFIO, 35 ), space( 35 ) )
		mtabn_as := if( oService:HasAssistant, oService:Assistant:TabNom, 0 )

		oBox := TBox():New( k, 2, maxrow() - 3, 76, .t. )
		oBox:Caption := if( nKey == K_INS, '����������', '������஢����' )
		oBox:CaptionColor := cDataPgDn
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()
		
		@ k + 1, 5 say '���� ��㣨 (蠡���)' get mshifr ;
	                    valid { | g | checkShifrServiceWoDoctor( g, nKey, aObjects ) }
		@ k + 2, 5 say '������������ �������᭮� ��㣨'
		@ k + 3, 10 get mname
		@ k + 4, 5 say '���.� ���' get mtabn_vr pict '99999' valid { | g | CheckDoctorAndAssistant( g, 1 ) }
		@ row(), col() + 3 get mvrach when .f. color color14
		@ k + 5, 5 say '���.� ����⥭�' get mtabn_as pict '99999' valid { | g | CheckDoctorAndAssistant( g, 2 ) }
		@ row(), col() + 3 get massist when .f. color color14
						
		myread()
		if lastkey() != K_ESC .and. !emptyany( mshifr, mname ).and. f_Esc_Enter( 1 )
			oService:Shifr := mshifr
			oService:Name := mname
			oService:Doctor := if( mtabn_vr == 0, nil, TEmployeeDB():getByTabNom( mtabn_vr ) )
			oService:Assistant := if( mtabn_as == 0, nil, TEmployeeDB():getByTabNom( mtabn_as ) )
			TIntegratedServiceDB():Save( oService )
			if nKey == K_ENTER .and. !( old_shifr == mshifr )
				// �஢��� ������ � ���稭����� �ࠢ�筨�� ��⠢� uslugi1k
				oService:ChangeShifr( mshifr )
			endif
			fl := .t.
		endif
	endif
	return fl
	
* 05.11.18 ।���஢���� ���������� ���
function editComponentsIntegratedServices( cShifr, aServices )
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editComponemtIntegratedService( oBrowse, aObjects, object, nKey, cShifr ) }
	aProperties := { { 'Shifr1', '����', 10 }, { 'Shifr1_F', '������������ ��㣨', 60 } }
	
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .f. }
	else
		aEdit := { .f., .f., .f., .f. }
	endif

	oBox := TBox():New( 2, 1, maxrow() - 1, 77, .t. )
	oBox:Caption := '����ঠ��� �������᭮� ��㣨'
	oBox:CaptionColor := 'B/BG'
	oBox:Color := color5
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ��⠢� �������᭮� ��㣨
	ListObjectsBrowse( 'TComponentsIntegratedService', oBox, aServices, 1, aProperties, ;
										blkEditObject, aEdit, , , )
	return nil

* 29.10.18 ।���஢���� ��ꥪ� �������᭮� ��㣨
function editComponemtIntegratedService( oBrowse, aObjects, oService, nKey, cShifr )
	local fl := .f.
	local tmp_color, buf := save_maxrow(), buf1
	local k := maxrow() - 9
	local oBox

	private mshifr := space(10), mname := space(60)
	if nKey == K_INS
		oBox := TBox():New( k, 2, maxrow() - 3, 77, .t. )
		oBox:Caption := if( nKey == K_INS, '����������', '������஢����' )
		oBox:CaptionColor := cDataPgDn
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()

		@ k + 2, 5 say '���� ��㣨' get mshifr picture '@!' ;
                valid checkShifrService()
		@ k + 3, 5 say '������������ ��㣨'
		@ k + 4, 5 get mname when .f.
		myread()
		if lastkey() != K_ESC .and. !empty( mshifr ).and. f_Esc_Enter( 1 )
			oService:Shifr := cShifr
			oService:Shifr1 := mshifr
			TComponentsIntegratedServiceDB():Save( oService )
			fl := .t.
		endif
	elseif nKey == K_DEL
		TComponentsIntegratedServiceDB():Delete( oService )
		fl := .t.
	endif
	return fl
	
* 05.11.18 ।���஢���� �஢��� ������
function editLevelPayments( nType )
	Local mtitle := '% ������ '
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	local blk := { | | if( empty( parr[nInd]:Razryad ), { 3, 4 }, { 1, 2 } ) }
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editLevelPayment( oBrowse, aObjects, object, nKey, lregim ) }
	aProperties := { { 'Razryad_F', '�����;������', 6, blk }, { 'Otdal_F', '�⤠���-;�����', 9, blk }, { 'Service1', '��㣨 �:', 10, blk }, ;
					{ 'Service2', '  ��:', 10, blk }, { 'Percent_F', '  ��業�;  ������', 10, blk } }
	
	if hb_user_curUser:IsAdmin()
		aEdit := { .t., .t., .t., .t. }
	else
		aEdit := { .f., .f., .f., .f. }
	endif

	lregim := nType
	if nType == O5_VR_OMS		// ��砬 (���)
		mtitle := mtitle + '��砬 (���)'
		aList := TUsl_U5DB():GetListDoctorOMS()
	elseif nType == O5_AS_OMS	// ����⥭⠬ (���)
		mtitle := mtitle + '����⥭⠬ (���)'
		aList := TUsl_U5DB():GetListAssistentOMS()
	elseif nType == O5_VR_PLAT	// ��砬 (����� ��㣨)
		mtitle := mtitle + '��砬 (����� ��㣨)'
		aList := TUsl_U5DB():GetListDoctorPlat()
	elseif nType == O5_AS_PLAT	// ����⥭⠬ (����� ��㣨)
		mtitle := mtitle + '����⥭⠬ (����� ��㣨)'
		aList := TUsl_U5DB():GetListAssistentPlat()
	elseif nType == O5_VR_NAPR	// �� ���ࠢ����� �� ����� ��㣨
		mtitle := mtitle + '�� ���ࠢ����� �� ����� ��㣨'
		aList := TUsl_U5DB():GetListSender()
	elseif nType == O5_VR_DMS	// ��砬 (���)
		mtitle := mtitle + '��砬 (���)'
		aList := TUsl_U5DB():GetListDoctorDMS()
	elseif nType == O5_AS_DMS	// ����⥭⠬ (���)
		mtitle := mtitle + '����⥭⠬ (���)'
		aList := TUsl_U5DB():GetListAssistentDMS()
	endif

	oBox := TBox():New( T_ROW, 0, maxrow() - 1, 79, .t. )
	oBox:Caption := mtitle
	oBox:CaptionColor := 'B/BG'
	oBox:Color := color5
	// ��ᬮ�� � ।���஢���� ᯨ᪠ �஢��� ������
	ListObjectsBrowse( 'TUsl_U5', oBox, aList, 1, aProperties, ;
										blkEditObject, aEdit, , '^<F9>^-�����', )
	return nil

* 29.10.18 ।���஢���� ��ꥪ� �஢��� ������
static function editLevelPayment( oBrowse, aObjects, oLevel, nKey, lregim )
	local fl := .f.
	local k := maxrow() - 10
	local oBox

	private motdal
	private bg := { | o, k | get_c_symb( o, k, '�' ) }
			
	if nKey == K_F9
		PrintPaymentTable()
	elseif nKey == K_INS .OR. nKey == K_ENTER .or. nKey == K_F4
		motdal		:= if( nkey == K_INS, ' ', iif(oLevel:Otdal, '�', ' ' ) )
		
		oBox := TBox():New( k, 10, maxrow() - 3, 69, .t. )
		oBox:Caption := if( nKey == K_INS, '����������', '������஢����' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:Color := cDataCGet
		oBox:View()

		@ k + 1, 12 say '����� ������' get oLevel:Razryad picture '99' range 0, 99
		@ k + 2, 12 say '�⤠��������' get motdal  reader { | o | MyGetReader( o, bg ) }
		@ k + 3, 12 say '��㣨 �:' get oLevel:Service1
		@ k + 4, 12 say '      ��:' get oLevel:Service2
		@ k + 5, 12 say '��業� ������' get oLevel:Percent pict '99.99'
        if eq_any( lregim, O5_VR_OMS, O5_VR_PLAT, O5_VR_DMS )
          @ k + 6, 12 say '��業� ������ ���� ��� ����⥭�' get oLevel:Percent2 pict '99.99'
        elseif eq_any( lregim, O5_AS_OMS, O5_AS_PLAT, O5_AS_DMS )
          @ k + 6, 12 say '��業� ������ ����⥭�� ��� ���' get oLevel:Percent2 pict '99.99'
        endif
	
		myread()
		if lastkey() != K_ESC .and. !emptyany( oLevel:Service1, oLevel:Percent ) .and. f_Esc_Enter( 1 )
			oLevel:Type := lregim
			oLevel:Otdal := ( motdal != ' ' )
			TUsl_U5DB():Save( oLevel )
			fl := .t.
		endif
	elseif nKey == K_DEL
		TUsl_U5DB():Delete( oLevel )
		fl := .t.
	endif
	return fl
