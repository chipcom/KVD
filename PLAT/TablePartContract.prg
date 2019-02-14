* 13.11.18 viewServiceRow( oService ) - �뢮� ���ଠ樮���� ��ப� �� ��㣥
* 13.11.18 editService( oPayService, aObjects, nKey, lPayment, oContract ) - ।���஢���� ��㣨 �室�饩 � ���⭮� �������
* 12.11.18 editListServices( oBrowse, aObjects, oPayService, nKey, oContract ) - �㭪��-��ࠡ��稪 ������ ������ � ᯨ᪥ ���
* 12.11.18 Services( obj ) - ।���஢���� ᯨ᪠ ��� ���⭮�� �������
* 25.10.18 viewTotalSum( oContract ) - �뢮� ���ଠ樮���� ��ப� �� ��饩 �㬬� ���⭮�� �������
* 12.06.17 getService( get, isAdult, treatment, aComplexService ) - ������� ���ଠ�� � ��࠭��� ��㣥
* 15.06.17 validQuantity( get ) - �஢�ઠ � ������ ��饩 �㬬� ��㣨
* 15.06.17 validTotal( get, iRow ) - �஢�ઠ � �⮡ࠦ���� '।���஢�����' �� ���� �㬬� ��㣨

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'def_bay.ch'

* 12.11.18 ।���஢���� ᯨ᪠ ��� ���⭮�� �������
function Services( obj )
	local flag := .f.
	local lPayment := obj:HasCheque
	local blkEditObject
	local aEdit
	local oBox, oBoxMessage, oBoxCheque, oBoxHeader
	local aProperties := {}
	
	private oContract := obj
	private pr_kod_vr := 0, pr_kod_as := 0, ;
		pr_med1 := 0, pr_med2 := 0, pr_med3 := 0, ;
		pr_san1 := 0, pr_san2 := 0, pr_san3 := 0
	// ��ꥪ�� ��� ��ࠡ�⪨
	private oDoctor := nil, oAssistant := nil
	private oNurse1 := nil, oNurse2 := nil, oNurse3 := nil
	private oAidman1 := nil, oAidman2 := nil, oAidman3 := nil

	blkEditObject := { | oBrowse, aObjects, object, nKey | editListServices( oBrowse, aObjects, object, nKey, oContract ) }
	aEdit := if( ! oContract:HasCheque .or. hb_user_curUser:IsAdmin(), { .t., .t., .t., .f. }, { .f., .f., .f., .f. } )
	
	str_sem := '���᮪ ��� ' + lstr( oContract:ID )
	if G_SLock( str_sem )
		// ���� ���ᠭ�� ��������� �࠭� ��� �������
		oBoxHeader := TBox():New( 0, 0, 0, maxcol(), .f. )
		oBoxHeader:Color := color0
		oBoxHeader:Frame := 0
		oBoxHeader:CaptionColor := col_tit_popup
		oBoxHeader:Caption := alltrim( '��㣨 �� �������� ��樥�� < ' + alltrim( obj:Patient:FIO ) + ' >' )
		oBoxHeader:View()

		// ���� �뢮�� ���ଠ樨 � �஡�⮬ 祪�, �� �� ����
		oBoxCheque := TBox():New( 1, 0, 1, maxcol(), .f. )
		oBoxCheque:Frame := 0
		oBoxCheque:View()
		if lPayment
			@ 1, 0 say ' �������� '	color 'G+*/B'
		endif

		// ���� ���ᠭ�� ��㣨 � ���� �뤠� ��饩 �㬬� �������
		oBoxMessage := TBox():New( maxrow() - 4, 0, maxrow() - 1, maxcol(), .f. )
		oBoxMessage:Frame := 0
		oBoxMessage:View()

		@ maxrow() - 3, 0 say '�������������������� ������ ������������ ��㣨 ���������������������� ���� ��͸'
		@ maxrow() - 2, 0 say '�                                                                  �           �'
		@ maxrow() - 1, 0 say '������������������������������������������������������������������������������;'

		if mem_ordusl == 1
			aadd( aProperties, { 'Date_F', '��� ;���', 5 } )
		endif
		aadd( aProperties, { 'Service_F', '   ����;  ��㣨', 10 } )
		if mem_ordusl == 2	// ��� �������� ��㣨
			aadd( aProperties, { 'Date_F', '��� ;���', 5 } )
		endif
		aadd( aProperties, { 'Subdivision_F', '�⤥-;�����', 5 } )
		aadd( aProperties, { 'Service_Name_F', '  ������������;  ��㣨', 16 } )
		aadd( aProperties, { 'Doctor_F', '���;    ', 4 } )
		aadd( aProperties, { 'Assistant_F', '���.;    ', 4 } )
		aadd( aProperties, { 'Quantity_F', '���.;   ', 3 } )
		aadd( aProperties, { 'Total_F', ' �⮣�  ;        ', 8 } )
		
		// ��ᬮ�� � ।���஢���� ᯨ᪠ ��� ������� ��樥��
		oBox := TBox():New( 2, 0, maxrow() - 5, 79, .f. )
		oBox:Caption := f_srok_lech( oContract:BeginTreatment, oContract:EndTreatment )
		oBox:CaptionColor := col_tit_popup
		oBox:Color := color1

		ListObjectsBrowse( 'TContractService', oBox, oContract:Services(), 1, aProperties, ;
										blkEditObject, aEdit, 'viewServiceRow', , 'W+/B,W+/RB,BG+/B,BG+/RB,G+/B,GR+/B' )

		oBox := nil
		oBoxCheque := nil
		oBoxMessage := nil
		oBoxHeader := nil
		TContractDB():Save( oContract )
		G_SUnLock( str_sem )
		flag := .t.
	else
		hb_Alert( err_slock, , , 4 )
	endif
	return flag

* 12.11.18 - �㭪��-��ࠡ��稪 ������ ������ � ᯨ᪥ ���
function editListServices( oBrowse, aObjects, oPayService, nKey, oContract )
	local fl := .f.
	local lPayment := oContract:HasCheque

	lPayment := if( hb_user_curUser:IsAdmin, .f., lPayment )
	do case
		case ( nKey == K_INS .and. lPayment )
			hb_Alert( '�஡�� 祪.' + chr( 10 ) + '���������� ��㣨 ����������!', , , 4 )
			fl := .f.
		case ( nKey == K_INS .and. ! lPayment ) .or. nKey == K_ENTER
			fl := editService( oPayService, aObjects, nKey, lPayment, oContract )
		case ( nKey == K_DEL .and. ! lPayment ) .or. ( nKey == K_DEL .and. hb_user_curUser:IsAdmin )
			TContractServiceDB():Delete( oPayService )
			AuditWrite( glob_task, OPER_USL, AUDIT_DEL, 1 )
			fl := .t.
		otherwise
			keyboard ''
	endcase
	return fl

* 13.11.18 - ।���஢���� ��㣨 �室�饩 � ���⭮� �������
function editService( oPayService, aObjects, nKey, lPayment, oContract )
	local fl := .f.
	local r1 := 13			// ��砫쭠� ��ப� �࠭� �����
	local x
	local lComplex := .f.	// �������᭠� ��㣠
	local pos_read := 0, k_read := 0, count_edit := 0

	local mDateService
	local oService := nil
	local aComplexService := {}
	local item := nil
	local oPatient := oContract:Patient
	local oTmp := nil
	local resultSave := -1
	
	local flagError := .f.
	local arrError := {}
	local oBox
	local oldDateService
	
	// ��ꥪ�� ��� ��ࠡ�⪨
	&& private oDoctor := nil, oAssistant := nil
	&& private oNurse1 := nil, oNurse2 := nil, oNurse3 := nil
	&& private oAidman1 := nil, oAidman2 := nil, oAidman3 := nil
	// ���� �����
	private mtabn_vr := 0, mvrach := space( 35 )
	private mtabn_as := 0, massist := space( 35 )
	private mdoctor, massistant, mNurse_1, mNurse_2, mNurse_3, mAidMan_1, mAidMan_2, mAidMan_3
	
	private mshifr := space( 10 ), mname_u := space( 65 ), mu_cena := 0.0, mQuantity := 0, mTotal := 0
	private mis_nul, mt_edit := 0

	// ᮡ�६ �� ��ꥪ��
	if nKey == K_INS
		oTmp 		:= TService():New()
	else
		oTmp 		:= oPayService:Service
		
		oDoctor		:= oPayService:Doctor
		oAssistant	:= oPayService:Assistant
		oNurse1		:= oPayService:Nurse1
		oNurse2		:= oPayService:Nurse2
		oNurse3		:= oPayService:Nurse3
		oAidman1	:= oPayService:Aidman1
		oAidman2	:= oPayService:Aidman2
		oAidman3	:= oPayService:Aidman3
	endif
	&& oDoctor		:= oPayService:Doctor
	&& oAssistant	:= oPayService:Assistant
	&& oNurse1		:= oPayService:Nurse1
	&& oNurse2		:= oPayService:Nurse2
	&& oNurse3		:= oPayService:Nurse3
	&& oAidman1	:= oPayService:Aidman1
	&& oAidman2	:= oPayService:Aidman2
	&& oAidman3	:= oPayService:Aidman3
	// �������� ����室��� ���� �����
	oldDateService := oPayService:Date
	if empty( oPayService:Date )
		oPayService:Date := oContract:BeginTreatment
	endif
	if ! isnil( oTmp )
		mshifr		:= padr( oTmp:Shifr, 10 )
		mname_u		:= padr( oTmp:Name, 65 )
	endif
	mu_cena		:= oPayService:Price
	mQuantity	:= oPayService:Quantity
	mTotal		:= oPayService:Total
	if ! isnil( oDoctor )
		mvrach	:= padr( oDoctor:ShortFIO, 35 )
		mtabn_vr	:= oDoctor:TabNom
	endif
	if ! isnil( oAssistant )
		massist	:= padr( oAssistant:ShortFIO, 35 )
		mtabn_as	:= oAssistant:TabNom
	endif
	mNurse_1	:= if( oNurse1 != nil, oNurse1:TabNom, 0 )
	mNurse_2	:= if( oNurse2 != nil, oNurse2:TabNom, 0 )
	mNurse_3	:= if( oNurse3 != nil, oNurse3:TabNom, 0 )
	mAidMan_1	:= if( oAidman1 != nil, oAidman1:TabNom, 0 )
	mAidMan_2	:= if( oAidman2 != nil, oAidman2:TabNom, 0 )
	mAidMan_3	:= if( oAidman3 != nil, oAidman3:TabNom, 0 )
	mt_edit		:= if( oPayService != nil .and. oPayService:IsEdit, 1, 0 )

	// ��稭��� � ��ப� 11
	oBox := TBox():New( 11, 0, maxrow() - 1, maxcol(), .f. )
	oBox:Color := cDataCGet
	oBox:Caption := '��㣠: ' + if( lPayment, '��ᬮ��', if( nKey == K_INS, '����������', '।���஢����' ) )
	oBox:CaptionColor := color8
	oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
	oBox:View()
		
	do while .t.
	
		pos_read := 0
		k_read := 0
		count_edit := 0
		
		@ r1, 2 say '��� �������� ��㣨' get oPayService:Date when ! lPayment
		@ ++r1, 2 say '���� ��㣨' get mshifr pict '@!' ;
							valid { | g | getService( g, oPatient:IsAdult( oPayService:Date ), oContract, @aComplexService ) } ;
							when ! lPayment
		@ row(), 40 say '���� ��㣨' get mu_cena pict pict_cena when .f. color color14
		@ ++r1, 2 say '��㣠' get mname_u when .f. color color14
		
		for x := 1 to 3
			if mem_por_vr == x
				@ ++r1, 2 say '���.� ���' get mtabn_vr pict '99999' ;
								valid { | g | validEmployer( g, '���', @oDoctor ) }
				@ row(), col() + 1 get mvrach color color14 when .f.
			endif
			if mem_por_ass == x
				@ ++r1, 2 say '���.� ����⥭�' get mtabn_as pict '99999' ;
								valid { | g | validEmployer( g, '����⥭�', @oAssistant ) }
				@ row(), col() + 1 get massist color color14 when .f.
			endif
			if mem_por_kol == x
				@ ++r1, 2 say '������⢮ ���' get mQuantity pict '999' ;
								valid { | g | validQuantity( g ) } ;
								when ! lPayment
			endif
		next
		@ ++r1, 2 say '���� �⮨����� ��㣨' get mTotal pict pict_cena ;
					valid {| g | validTotal( g, r1 ) } ;
					when { | g | ( mem_edit_s == 2 ) .and. ( len( aComplexService ) == 0 ) .and. !lPayment }
		if mt_edit > 1
			@ r1, 37 say '[ ।���஢����� �⮨����� ��㣨 ]' color color13
		endif
		r1++
		if is_oplata != 7
			@ ++r1, 2 say '���� �������' get mNurse_1 pict '99999' ;
							valid { | g | validEmployer( g, '�������', @oNurse1 ) }
			@ row(), col() say ',' get mNurse_2 pict '99999' ;
							valid { | g | validEmployer( g, '�������', @oNurse2 ) }
			@ row(), col() say ',' get mNurse_3 pict '99999' ;
							valid { | g | validEmployer( g, '�������', @oNurse3 ) }
			@ ++r1, 2 say '���� ᠭ��ப' get mAidMan_1 pict '99999' ;
							valid { | g | validEmployer( g, 'ᠭ��ઠ', @oAidman1 ) }
			@ row(), col() say ',' get mAidMan_2 pict '99999' ;
							valid { | g | validEmployer( g, 'ᠭ��ઠ', @oAidman2 ) }
			@ row(), col() say ',' get mAidMan_3 pict '99999' ;
							valid { | g | validEmployer( g, 'ᠭ��ઠ', @oAidman3 ) }
		endif
		&& myread()
		count_edit := myread( , @pos_read, ++k_read )
		if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
			// ᭠砫� �஢���� �஢��� �� ��������� �㦭� ����
			arrError := {}
			aadd( arrError, '�����㦥�� ᫥���騥 �訡��:' )
			flagError := .f.
			if empty( mshifr )
				flagError := .t.
				aadd( arrError, '�� ��࠭ ��� ��㣨' )
			else
				if ( oService := TServiceDB():getByShifr( mshifr ) ) == nil
					if ( oService := TIntegratedServiceDB():getByShifr( mshifr ) ) == nil
						flagError := .t.
						aadd( arrError, '��㣠 � 㪠����� ��஬ �������' )
					endif
				endif
			endif
			if mQuantity == 0
				flagError := .t.
				aadd( arrError, '�� ��������� ���� ������⢮ ���' )
			endif
			if oService:WithDoctor .and. mtabn_vr == 0
				flagError := .t.
				aadd( arrError, '�� ��࠭ ���' )
			endif
			if !oService:WithDoctor .and. oService:WithAssistant .and. mtabn_as == 0
				flagError := .t.
				aadd( arrError, '�� ��࠭ ����⥭�' )
			endif
			if flagError
				hb_Alert( arrError, , , 4 )
				loop
			endif
			if oService:classname == 'TSERVICE'
				oPayService:IDLU := oContract:ID
				oPayService:Coefficient := 1
				oPayService:Price := mu_cena
				oPayService:Quantity := mQuantity
				oPayService:Total := mTotal
				oPayService:Service := oService
				oPayService:IsEdit := ( mt_edit > 1 )
				oPayService:Subdivision := oContract:IDSubdivision
				
				oPayService:Doctor := oDoctor
				oPayService:Assistant := oAssistant
				oPayService:Nurse1 := oNurse1
				oPayService:Nurse2 := oNurse2
				oPayService:Nurse3 := oNurse3
				oPayService:Aidman1 := oAidman1
				oPayService:Aidman2 := oAidman2
				oPayService:Aidman3 := oAidman3
				resultSave := TContractServiceDB():Save( oPayService )
				fl := .t.
			elseif oService:classname == 'TINTEGRATEDSERVICE'
				mDateService := oPayService:Date
				for each item in oService:Services()
					if lComplex
						oPayService := TContractService():New()
					endif
					oPayService:IDLU := oContract:ID
					oPayService:Date := mDateService
					oPayService:Coefficient := 1
					oPayService:Price( item:Service:CalculatePrice( oPatient:IsAdult( oPayService:Date ) ) )
					oPayService:Quantity := mQuantity
					oPayService:Total := item:Service:CalculatePrice( oPatient:IsAdult( oPayService:Date ) ) * mQuantity
					oPayService:Service := item:Service
					oPayService:IsEdit := .f.
					oPayService:Subdivision := oContract:IDSubdivision
				
					oPayService:Doctor := oDoctor
					oPayService:Assistant := oAssistant
					oPayService:Nurse1 := oNurse1
					oPayService:Nurse2 := oNurse2
					oPayService:Nurse3 := oNurse3
					oPayService:Aidman1 := oAidman1
					oPayService:Aidman2 := oAidman2
					oPayService:Aidman3 := oAidman3
					TContractServiceDB():Save( oPayService )
					if lComplex
						aadd( aObjects, oPayService )
					endif
					lComplex := .t.
				next
				fl := .t.
			endif
			AuditWrite( glob_task, OPER_USL, iif( nKey == K_INS, AUDIT_INS, AUDIT_EDIT ), 1, count_edit )
			
		else
			oPayService:Date := oldDateService		// ����⠭���� ���� ��㣨
		endif
		exit
	enddo
	oBox := nil
	return fl

* 15.06.17 - �஢�ઠ � �⮡ࠦ���� '।���஢�����' �� ���� �㬬� ��㣨
function validTotal( get, iRow )
	local fl := .t.
	local blk_sum := { | | mTotal := round_5( mu_cena * mQuantity, 2 ) }
	
	if !( round( mTotal, 2 ) == round_5( mu_cena * mQuantity, 2 ) )
		if mt_edit == 0
			mt_edit := 2
		elseif mt_edit == 1
			mt_edit := 3
		endif
		@ iRow, 37 say '[ ।���஢����� �㬬� ��� ��㣨 ]' color color13
	endif
	return fl

* 15.06.17 - �஢�ઠ � ������ ��饩 �㬬� ��㣨
function validQuantity( get )
	local fl := .t.
	local blk_sum := { | | mTotal := round_5( mu_cena * mQuantity, 2 ) }
	
	if mQuantity != get:original
		eval( blk_sum )
		update_gets()
	endif
	return fl

* 12.06.17 - ������� ���ଠ�� � ��࠭��� ��㣥
function getService( get, isAdult, treatment, aComplexService )
*
* isAdult - �����᪠� ��६����� �����뢠��� .t. - �����, .f. - ॡ����
* subdivision - ��� �⤥�����
* aComplexService - ���ᨢ ᮤ�ঠ騩 ᯨ᮪ ��� ��� �������᭮� ��㣨
*
	local fl := .t.
	local oService := nil
	local item := nil
	local blk_sum := { | | mTotal := round_5( mu_cena * mQuantity, 2 ) }
	
	if !empty( mshifr ) .and. !( mshifr == get:original )
		mshifr := transform_shifr( mshifr )
		
		if ( oService := TServiceDB():getByShifr( mshifr ) ) != nil
			if ! oService:IsAllowedSubdivision( treatment:IDSubdivision )
				hb_Alert( '�� �����⨬�� ��㣠 � ��࠭��� ���ࠧ�������!' )
				mshifr := ''
				return .f.
			endif
			
			mname_u := padr( oService:Name(), 65 )
			mis_nul := oService:AllowNullPaid()
			if mis_nul  // ��㣠 � �㫥��� 業��
				mu_cena := 0 ; mt_edit := 1
			else
				// ��६ 業� ��� ������ ���
				mu_cena := oService:CalculatePrice( isAdult, treatment:TypeService == PU_D_SMO )
				mRateNDS := oService:CalculateNDS( isAdult, treatment:TypeService == PU_D_SMO )
			endif
			mQuantity := 1
			eval( blk_sum )
			update_gets()
		elseif ( oService := TIntegratedServiceDB():getByShifr( mshifr ) ) != nil
			aComplexService := oService:Services()
			for each item in oService:Services()
				if empty( item:CalculatePrice( isAdult, treatment:TypeService == PU_D_SMO ) ) .and. !item:Service:AllowNullPaid()
					hb_Alert( '��� ��㣨 ' + alltrim( item:Shifr1() ) + ' �室�饩 � ���������� ���� �� 㪠���� 業�!', , , 4 )
					fl := .f.
				else
					//&& if !Empty( item:Service():AllowSubdivision() ) .and. !( chr( treatment:Subdivision() ) $ item:Service():AllowSubdivision() )
						//&& hb_Alert( '���� ' + alltrim( item:Shifr() ) + ' ����饭� ������� � ������ �⤥�����!', , , 4 )
						//&& fl := .f.
					//&& endif
				endif
			next
			if fl .and. len( aComplexService ) > 0
				mname_u := oService:Name()
				mQuantity := 1
				mu_cena := oService:CalculatePrice( isAdult, treatment:TypeService == PU_D_SMO )
				eval( blk_sum )
				if !emptyall( oService:Doctor, oService:Assistant )
					mtabn_vr := if( oService:Doctor != nil, oService:Doctor:TabNom(), 0 )
					mvrach := padr( if( oService:Doctor != nil, oService:Doctor:ShortFIO, '' ), 35 )
					mtabn_as := if( oService:Assistant != nil, oService:Assistant:TabNom(), 0 )
					massist := padr( if( oService:Assistant != nil, oService:Assistant:ShortFIO, '' ), 35 )
				endif
				box_shadow( 6, 40, 8, 77, cColorStMsg, ;
						'�������᭠� ��㣠', cColorSt2Msg )
				@ 7, 41 say padc( '������⢮ ��� - ' + lstr( len( aComplexService ) ), 36 ) color cColorStMsg
				fl := update_gets()
			endif
		else
			hb_Alert( '��㣠 �� � 㪠����� ��஬ �������', , , 4 )
			fl := .f.
		endif
	endif
	return fl

* 13.11.18 - �뢮� ���ଠ樮���� ��ப� �� ��㣥
function viewServiceRow( oService )
	
	if ! isnil( oService ) .and. ! isnil( oService:Service )
		@ maxrow() - 2, 2 say oService:Service:Name color cDataCSay
		@ maxrow() - 2, 68 say oService:Service:CalculatePrice( oContract:Patient:IsAdult( oService:Date ), oContract:TypeService == PU_D_SMO )
	else
		@ maxrow() - 2, 2 say space( 65 )
		@ maxrow() - 2, 68 say space( 10 )
	endif
	oContract:Recount()
	@ maxrow() - 4, 50 say padl( '�⮣� �� ��������: ' + lstr( oContract:Total, 11, 2 ), 30 ) //color 'W+/N'
	return nil
