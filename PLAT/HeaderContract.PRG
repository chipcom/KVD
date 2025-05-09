* 19.02.19 kart_plat()
* 19.02.19 editListContracts( oBrowse, aObjects, object, nKey ) - �㭪��-��ࠡ��稪 ������ ������ � ᯨ᪥ ������஢
* 13.11.18 editContract( nKey, oContract ) - ।���஢���� ���⭮�� �������
* 10.11.18 valTypePaid( oGet, oldValue, oContract, oContractPayer, lPayment ) -
* 10.11.18 getOtherFieldsPaid( oContract, oContractPayer, lPayment ) - ���� ��⠢���� ����� ����� �������
* 15.10.18 validDateThreatment( get, k ) �஢�ઠ �ࠢ��쭮�� ����� �ப�� ��祭��
* 09.06.17 validICD10( oGet ) - �஢�ઠ ����� �������� ( ����稥 � �ࠢ�筨�� ���-10 )
* 08.06.17 layoutContracts( oBrowse, aList ) - �ନ஢���� ������� ��� �⮡ࠦ���� ᯨ᪠ ������஢

#include 'hbthread.ch'
#include "getexit.ch"
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'
#include 'def_bay.ch'

#define BEGIN_THREATMENT	1
#define END_THREATMENT		2

// 17.01.25
function kart_plat()
	local str_sem
	local aContracts := {}
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	local blcCodeColor
	local oPatient
	
	clear_gets()	// ���⨬ �� ���� �����
	if polikl1_kart() > 0
		str_sem := '�� ������஢���� 祫����� ' + lstr( glob_kartotek )
		if !G_SLock( str_sem )
			hb_Alert( err_slock, , , 4 )
			return .f.
		endif
	
		oPatient := TPatientDB():GetByID( glob_kartotek )
		aContracts := TContractDB():GetListByPatient( glob_kartotek, hb_user_curUser )
		
		blkEditObject := { | oBrowse, aObjects, object, nKey | editListContracts( oBrowse, aObjects, object, nKey, oPatient ) }
		blcCodeColor := { | | iif( empty( parr[ nInd ]:DatePay ), { 5, 6 }, iif( parr[ nInd ]:Total > 0, { 1, 2 }, { 3, 4 } ) ) }
		aEdit := { .t., .t., .t., .f. }
		
		aProperties := { { 'DepartmentShort', '��-���', 5, blcCodeColor }, ;
						{ 'TotalBank_F', ' ', 1, blcCodeColor }, ;
						{ 'FillColumnCheque', 'N 祪', 5, blcCodeColor }, ;
						{ 'BeginTreatment', '��砫� ;��祭��', 10, blcCodeColor }, ;
						{ 'EndTreatment', '����砭��; ��祭�� ', 10, blcCodeColor } ;
						}
		if mem_naprvr == 2	// �⮡ࠦ��� ⠡���� ����� ���ࠢ��襭�� ���
			aadd( aProperties, { 'SendDoctorTabNom', '����.;���', 5, blcCodeColor } )
		endif
		aadd( aProperties, { 'Total_F', '�⮨�����; ��祭�� ', 8, blcCodeColor } )
		aadd( aProperties, { 'BackMoney_F', '������; ����� ', 8, blcCodeColor } )
		aadd( aProperties, { 'DateCloseLU', '  ���  ;�������', 10, blcCodeColor } )
		
		// ��ᬮ�� � ।���஢���� ᯨ᪠ ������஢ ��樥��
		oBox := TBox():New( 8, 0, maxrow() - 2, 79, .t. )
		oBox:Caption := '���᮪ ������஢ ��樥�� < ' + alltrim( oPatient:FIO() ) + ' >'
		oBox:CaptionColor := col_tit_popup
		oBox:Color := color0
		if ! getDrvFR():IsFiscalReg
			oBox:MessageLine := { '^<Ctrl+Enter>^-ᯨ᮪ ��� ^<F9>^-������� ', ;
						'^<Esc>^-��室 ^<Ins>^-��⠢�� ^<Del>^-㤠����� ^<Enter>^-।���.' }
		else
			&& oBox:MessageLine := { '^<Ctrl+Enter>^-��㣨 ^<F8>^-������ ^<F9>^-������� ^<F10>^-祪 ^<F7>^-����� 祪�', ;
			oBox:MessageLine := { '^<Ctrl+Enter>^-��㣨 ^<F8>^-������ ^<F9>^-������� ^<F10>^-祪 ', ;
								'^<Esc>^-��室 ^<Ins>^-��⠢�� ^<Del>^-㤠����� ^<Enter>^-।���.' }
		endif
		
		ListObjectsBrowse( 'TContract', oBox, aContracts, 1, aProperties, ;
											blkEditObject, aEdit, , , 'N/BG, W+/N, B/BG, BG+/B, GR/BG, BG+/GR' )
		G_SUnLock( str_sem )
	endif
	return nil

// 17.10.24 �㭪��-��ࠡ��稪 ������ ������ � ᯨ᪥ ������஢
function editListContracts( oBrowse, aObjects, oContract, nKey, oPatient )
	local fl := .f.
	local err_close := '����� ���� ��� ������. ����� ࠧ�襭 ⮫쪮 ������������ ��⥬�!'
	
	do case
		case nKey == K_INS .or. ( nKey == K_ENTER .and. oContract:Patient != nil )
			if nKey == K_ENTER .and. !empty( oContract:DateCloseLU ) .and. !hb_user_curUser:IsAdmin()
				hb_Alert( err_close, , , 4 )
				return .f.
			endif
			if nKey == K_INS
				colorwin( 7, 0, 7, 79, 'N/N', 'W+/N' )
				colorwin( 7, 0, 7, 79, 'N/N', 'BG+/B' )
			endif
			if oContract:IsNew
				oContract:Patient := oPatient
				oContract:BeginTreatment := date()
				oContract:EndTreatment := date()
				oContract:TypeService := PU_PLAT
			endif
			fl := editContract( nKey, oContract )
		case nKey == K_CTRL_RET .and. oContract:Patient != nil
			if !empty( oContract:DateCloseLU ) .and. !hb_user_curUser:IsAdmin()
				hb_Alert( err_close, , , 4 )
				return .f.
			endif
			fl := Services( oContract )
		// case nKey == K_F5 	// ����� �ࠢ�� ��� ���
		// 	fl := printReferenceToFTS( oPatient, aObjects )
		&& case nKey == K_F7 	// ����� ����� 祪� �த���
			&& fl := printCopyReceipt( oContract )
		case nKey == K_F10 .or. nKey == K_F8 .or. nKey == K_CTRL_F10 .or. nKey == K_CTRL_F8	;
				.or. nKey == K_CTRL_F12// ����� 祪� �த��� ��� ������
			fl := printReceipt( oContract, nKey )
		case nKey == K_F9				// ����� �������
			if empty( oContract:Services() )
				hb_Alert( '� ������� ���������� ��㣨. ����� ������� �� ��������!', , , 4 )
			else
				fl := printContract( oContract )
			endif
		case nKey == K_DEL
			if oContract:HasCheque					// ������� �஡��� 祪
				hb_Alert( '�஡�� 祪.' + chr( 10 ) + '�������� ����������!', , , 4 )
			else
				oContract:deleteAllServices()
				TContractDB():Delete( oContract )
				AuditWrite( glob_task, OPER_LIST, AUDIT_DEL, 1 )
				fl := .t.
			endif
		otherwise
			keyboard ''
	endcase
	return fl

* 13.11.18 - ।���஢���� ���⭮�� �������
function editContract( nKey, oContract )
	local k, pos_read := 0, k_read := 0, count_edit := 0
	local ret := .f.
	local oContractPayer := nil
	local lPayment := if( isnil( oContract ) , .f., oContract:HasCheque )
		
	private r1 := 12
	private mm_da_net := { { '�� ', 1 }, { '���', 2 } }
	
	r1 := r1 - if( mem_plsoput == 2, 1, 0 )
	r1 := r1 - if( mem_naprvr == 2, 1, 0 )
	private oDoctor	:= nil, ;				// ���ࠢ��訩 ���
		mlpu        := glob_uch[ 2 ], ;		// ������������ ��०�����
		m1lpu       := glob_uch[ 1 ], ;		// ��� ��०�����
		motd        := glob_otd[ 2 ], ;		// ������������ �⤥�����
		m1otd       := glob_otd[ 1 ], ;		// ��� �⤥�����
		mtabn_vr := 0, mvrach := space( 35 ), ;
		mtip_usl, m1tip_usl := 0, ;
		mpr_smo := space( 20 ), m1pr_smo := 0
		
	private mMyself, m1Myself := 1				// ���⥫�騪 ᠬ ��� ���
	
	lPayment := if( hb_user_curUser:IsAdmin, .f., lPayment )
	m1lpu       := oContract:IDDepartment		// ��� ��०�����
	m1otd       := oContract:IDSubdivision		// ��� �⤥�����
	oDoctor		:= oContract:SendDoctor
	m1tip_usl   := oContract:TypeService
	if m1tip_usl != PU_PLAT
		m1pr_smo := oContract:IdExternalOrg
	endif
	if oDoctor != nil
		mvrach := padr( oDoctor:ShortFIO, 35 )
		mtabn_vr := oDoctor:TabNom
	endif
	
	m1Myself := if( empty( oContract:PayerFIO ), 1, 2 )
	mMyself := inieditspr(A__MENUVERT, mm_da_net, m1Myself)
	
	mtip_usl := inieditspr( A__MENUVERT, menu_kb, m1tip_usl )
	mlpu := inieditspr( A__MENUVERT, TDepartmentDB():MenuDepartments(), m1lpu )
	motd := inieditspr( A__MENUVERT, TSubdivisionDB():MenuSubdivisions( m1lpu ), m1otd )

	if m1tip_usl == PU_D_SMO
		mpr_smo := inieditspr( A__MENUVERT, TCompanyDMSDB():MenuCompanies(), m1pr_smo )
	elseif m1tip_usl == PU_PR_VZ
		mpr_smo := inieditspr( A__MENUVERT, TCompanyVzaimDB():MenuCompanies(), m1pr_smo )
	endif
	
	oBox := TBox():New( r1, 0, maxrow() - 1, maxcol(), .t. )
	oBox:Caption := '������� �� �������� ��� ��樥���: ' + if( lPayment, '��ᬮ��', if( nKey == K_INS, '����������', '।���஢����' ) )
	oBox:CaptionColor := color8
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - ��室;  ^<PgDn>^ - ������'
	oBox:View()
	
	ShowDiagnosis( 0 )
	*
	do while .t.
		oContractPayer := TContractPayer():New()
		if ( m1tip_usl == PU_PLAT ) .and. ( m1Myself == 2 )	// ����� �����묨 � ���⥫�騪 �� ��樥��
			if ( oContractPayer := TContractPayerDB():GetByIdLU( oContract:ID ) ) == nil
				oContractPayer := TContractPayer():New()
			endif
		elseif ( m1tip_usl == PU_D_SMO ) .or. ( m1tip_usl == PU_PR_VZ )	// ���⥫�騪 ������ �࣠������
			m1pr_smo := oContract:IdExternalOrg
		endif
		
		@ r1 + 1, 1 clear to maxrow() - 2, maxcol() - 1
		@ r1 + 2, 2 say '���' get mlpu ;
			reader { | x | menu_reader( x, { { | k, r, c | fillGetFieldDepAndSub( k, r, c, date(), , X_PLATN ) } }, ;
			A__FUNCTION, , , .f. ) } when !lPayment
		@ r1 + 2, 37 say '�⤥�����' get motd  when !lPayment
		@ r1 + 3, 2 say '���ᮡ ������' get mtip_usl ;
           reader { | x | menu_reader( x, menu_kb, A__MENUVERT, , , .f. ) } ;
            valid {| oGet, oldValue | valTypePaid( oGet, oldValue, oContract, oContractPayer, lPayment ) } ;
            when !lPayment
			
		getOtherFieldsPaid( oContract, oContractPayer, lPayment )  // ��⠫�� Get'�
		
		if nKey == K_ENTER .and. !ver_pub_date( oContract:EndTreatment, .t. )
			keyboard chr( K_ESC )
		endif
		count_edit := myread( , @pos_read, ++k_read )
		if lastkey() != K_ESC
			err_date_diap( oContract:BeginTreatment, '��� ��砫� ��祭��' )
			err_date_diap( oContract:EndTreatment, '��� ����砭�� ��祭��' )
			if f_Esc_Enter( 1 )
				if m1lpu == 0
					hb_Alert( '�� ��࠭� ��祡��� ��०�����!', , , 4 )
					loop
				endif
				if m1otd == 0
					hb_Alert( '�� ��࠭� �⤥�����!', , , 4 )
					loop
				endif
				if empty( oContract:EndTreatment )
					hb_Alert( '�� ������� ��� ����砭�� ��祭��.', , , 4 )
					loop
				endif
				mywait()
				if nKey == K_INS
					if m1tip_usl == PU_PLAT .and. getDrvFR():IsFiscalReg  // �᫨ �� ����������
						oContract:IsCashbox := 2
					endif
				endif
				oContract:Department := m1lpu			// ��� ��०�����
				oContract:Subdivision := m1otd			// ��� �⤥�����
				oContract:SendDoctor := oDoctor
				oContract:TypeService := m1tip_usl
				if m1tip_usl == PU_PLAT
					oContract:IdExternalOrg := 0
					if m1Myself == 1
						oContract:PayerFIO := space( 40 )
						oContract:PayerINN := space( 12 )
					endif
				else
					if m1pr_smo != -1
						oContract:IdExternalOrg := m1pr_smo
					endif
					oContract:IsCashbox := 0
				endif
				if ( ret := ( TContractDB():Save( oContract ) != -1 ) )
					if m1Myself == 2 .and. ( ! empty( oContractPayer:Address ) .or. ! empty( oContractPayer:Passport ) )
						if oContractPayer:IsNew
							oContractPayer:IDLU := oContract:ID
						endif
						TContractPayerDB():Save( oContractPayer )
					else
						if ( oContractPayer := TContractPayerDB():GetByIdLU( oContract:ID() ) ) != nil
							TContractPayerDB():Delete( oContractPayer )
						endif
					endif
					AuditWrite( glob_task, OPER_LIST, iif( nKey == K_INS, AUDIT_INS, AUDIT_EDIT ), 1, count_edit )
				endif
			endif
		endif
		exit
	enddo
	ShowDiagnosis( 2 )
	return ret

* 10.11.18 ���� ��⠢���� ����� ����� �������
function getOtherFieldsPaid( oContract, oContractPayer, lPayment )  // ��⠫�� Get'�
	local j := row() + 1,  pic_diag := '@K@!'
	local bKeyBlock := { | oGet, nKey | transform_mkb10( oGet, nKey ) }

	asize( GetList, 3 )   // ��६ ���� 3 �������
	@ j, 37 clear to j, maxcol() - 1
	if m1tip_usl == PU_D_SMO .or. m1tip_usl == PU_PR_VZ
		if m1tip_usl == PU_D_SMO
			@ --j, 37 say '    '
			@ j, 37 say '���' get mpr_smo reader ;
				{ | x | menu_reader( x, TCompanyDMSDB():MenuCompanies(), A__MENUVERT, , , .f. ) } when !lPayment
		elseif m1tip_usl == PU_PR_VZ
			@ --j, 37 say '�।���⨥' get mpr_smo reader ;
				{ | x | menu_reader( x, TCompanyVzaimDB():MenuCompanies(), A__MENUVERT, , , .f. ) } when !lPayment
		endif
	elseif m1tip_usl == PU_PLAT
		@ --j, 37 say space( 40 )
		@ j,  37 SAY '���⥫�騪, �� ��:'
		@ j, col() say '' get mMyself reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) } ;
			valid checkMyself() when !lPayment
	endif
	@ j + 1, 1 clear to maxrow() - 2, maxcol() - 1
	
	@ ++j, 2 say '���� �᭮����� �����������' get oContract:MainDiagnosis ;
			picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } valid { |oGet| validICD10( oGet ) } ;
			when ShowDiagnosis( 2 ) .and. when_diag()
	if mem_plsoput == 2
		++j
		@ j, 2 say '����� ᮯ������� �����������' get oContract:Diagnosis1 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis2 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis3 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis4 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
		@ row(), col() + 1 say ',' get oContract:Diagnosis5 ;
				picture pic_diag reader { | oGet | MyGetReader( oGet, bKeyBlock ) } when when_diag() valid { |oGet| validICD10( oGet ) }
	endif
	if mem_naprvr == 2
		@ ++j, 2 say '���.� ���ࠢ��襣� ���' get mtabn_vr pict '99999' valid { | g | validEmployer( g, '���', @oDoctor ) }
		@ row(), col() + 1 get mvrach  when .f. color color14
	endif
	@ ++j, 2 say '��砫� ��祭��' get oContract:BeginTreatment valid { | oGet | validDateThreatment( oGet, BEGIN_THREATMENT, oContract:EndTreatment, oContract:Patient:DOB ) } when !lPayment
	@ row(), col() + 2 say '����砭�� ��祭��' get oContract:EndTreatment valid { | oGet | validDateThreatment( oGet, END_THREATMENT, oContract:BeginTreatment, oContract:Patient:DOB ) } when !lPayment
	if empty( oContract:DatePay )
		@ j, 60 say '������� ���������' color 'GR+/R,,,,B/W'
	else
		@ j, 60 say '�����'
		@ j, col() + 1 get oContract:DatePay when .f.
	endif
	if m1tip_usl == PU_D_SMO .or. m1tip_usl == PU_PR_VZ
		@ ++j, 0 say '�' + replicate( '�', 78 ) + '�'
		++j
		@ j, 2 say '�����' get oContract:PolisSMO picture '@!@S20'
		@ j, col() + 1 say '��࠭⨩��� ���쬮 �' get oContract:LetterSMO picture '@!@S14' when !lPayment
		@ j, col() + 1 say '��' get oContract:DateLetterSMO when !lPayment
		++j
		@ j, 29 say '��࠭⨩��� ���쬮 �' get oContract:LetterSMO2 picture '@!@S14' when !lPayment
		@ j, col() + 1 say '��' get oContract:DateLetterSMO2 when !lPayment
		@ ++j, 0 say '�' + replicate( '�', 78 ) + '�'
	elseif m1tip_usl == PU_PLAT
		// ���ଠ�� � ���⥫�騪�
		@ ++j, 0 say '�' + replicate( '�', 78 ) + '�'
		@ ++j, 2 say '���⥫�騪: ���' get oContract:PayerFIO pict '@!@S30' ;
					valid controlPayer( PU_PLAT, oContract:PayerFIO ) when m1Myself == 2
		@ j, col() say ', ���' get oContract:PayerINN picture '999999999999' ;
					when m1Myself == 2
		@ ++j, 2 say '����' get oContractPayer:Address pict '@!@S45' ;
					when m1Myself == 2
		@ j, col() say ', � ���.' get oContractPayer:Passport  pict '@!@S15' ;
					when m1Myself == 2
		@ ++j, 0 say '�' + replicate( '�', 78 ) + '�'
	endif
	@ ++j, 50 say '�⮨����� ��祭�� ' + lstr( oContract:Total, 11, 2 ) color 'GR+/B'
	return nil

* 10.11.18
function valTypePaid( oGet, oldValue, oContract, oContractPayer, lPayment )
	local fl := .t.
	
	if oldValue != nil .and. oldValue != m1tip_usl
		if m1tip_usl == PU_PLAT
			oContract:IsCashbox := 2
		else
			oContract:IsCashbox := 0
		endif
		m1pr_smo := 0 ; mpr_smo := space( 25 )
		oContract:PolisSMO := space( 25 )
		oContract:LetterSMO := space( 16 )
		oContract:DateLetterSMO := ctod( '' )
		oContract:LetterSMO2 := space( 16 )
		oContract:DateLetterSMO2 := ctod( '' )
		getOtherFieldsPaid( oContract, oContractPayer, lPayment )
	endif
	return fl

* 09.06.17 �஢�ઠ ����� �������� ( ����稥 � �ࠢ�筨�� ���-10 )
function validICD10( oGet )
	local fl := .t., mshifr, c_plus := ' ', i, ;
		m1, s, mshifr6
	local oICD10 := nil, toICD10 := nil

	mshifr := alltrim( oGet:buffer )
	mshifr6 := padr( mshifr, 6 )
	mshifr := padr( mshifr, 5 )
	if empty( mshifr )
		ShowDiagnosis( 2 )
	else
		mshifr := mshifr6
		if ( oICD10 := TICD10DB():GetByShifr( mshifr ) ) != nil
			if mem_diag4 == 2 .and. !( '.' $ mshifr ) // �᫨ ��� ��姭���
				m1 := alltrim( mshifr ) + '.'
				// ⥯��� �஢�ਬ �� ����稥 ��� ����姭�筮�� ���
				if ( toICD10 := TICD10DB():GetByShifr( m1 ) ) != nil
					s := ''
					for i := 0 to 9
						if ( toICD10 := TICD10DB():GetByShifr( m1 + str( i, 1 ) ) ) != nil
							s += alltrim( toICD10:Shifr ) + ','
						endif
					next
					s := substr( s, 1, len( s ) - 1 )
					oGet:varPut( padr( m1, 5 ) + c_plus )
					hb_Alert( '����㯭� ����: ' + s, , , 4 )
					fl := .f.
				endif
			endif
		else
			if '.' $ mshifr  // �᫨ ��� ����姭���
				m1 := beforatnum( '.', mshifr )
				// ᭠砫� �஢�ਬ �� ����稥 ��姭�筮�� ���
				if ( toICD10 := TICD10DB():GetByShifr( m1 ) ) != nil
					// ⥯��� �஢�ਬ �� ����稥 ��� ����姭�筮�� ���
					if ( toICD10 := TICD10DB():GetByShifr( m1 + '.' ) ) != nil
						s := ''
						for i := 0 to 9
							if ( toICD10 := TICD10DB():GetByShifr( m1 + '.' + str( i, 1 ) ) ) != nil
								s += alltrim( toICD10:Shifr ) + ','
							endif
						next
						s := substr( s, 1, len( s ) - 1 )
						oGet:varPut( padr( m1 + '.', 5 ) + c_plus )
						hb_Alert( '����㯭� ����: ' + s, , , 4 )
						fl := .f.
					else
						oGet:varPut( padr( m1, 5 ) + c_plus )
						hb_Alert( '����� ������� ��������� ⮫쪮 � ���� �������筮�� ���!', , , 4 )
						fl := .f.
					endif
				endif
			endif
			if fl
				oGet:varPut( space( 5 ) )
				hb_Alert( '������� � ��஬: ' + alltrim( mshifr ) + ' �� ������!', , , 4 )
				fl := .f.
			endif
		endif
	endif
	if fl
		if right( mshifr6, 1 ) != ' '
			oGet:varPut( mshifr6 )
		else
			oGet:varPut( padr( mshifr, 5 ) + c_plus )
		endif
	endif
	return fl

* 15.10.18 �஢�ઠ �ࠢ��쭮�� ����� �ப�� ��祭��
function validDateThreatment( oGet, typeDate, dateField, DOB )
// typeDate = 1 - ��� ��砫� ��祭��
// typeDate = 2 - ��� ����砭�� ��祭��

	// �६����
	if ( typeDate == BEGIN_THREATMENT )
		if empty( ctod( oGet:buffer ) )
			return func_error( 4, '�訡��! �� ������� ��� ��砫� ��祭��.' )
		endif
		if ( DOB >= ctod( oGet:buffer ) )
			return func_error( 4, '�訡��! ��� ��砫� ��祭�� ࠭�� ���� ஦����� ��樥��.' )
		endif
		if ! empty( ctod( oGet:buffer ) ) .and. ( ctod( oGet:buffer ) > dateField )
			dateField := oGet:original
			return func_error( 4, '�訡��! ��� ��砫� ��祭�� ����� ���� ����砭�� ��祭��.' )
		endif
	endif
	if ( typeDate == END_THREATMENT )
		if empty( ctod( oGet:buffer ) )
			oGet:buffer := oGet:original
			return func_error( 4, '�訡��! �� ������� ��� ����砭�� ��祭��.' )
		endif
		if ! ( year( dateField ) == year( sys_date ) .or. year( dateField ) == year( sys_date ) - 1 )
			dateField := oGet:original
			return func_error( 4, '�訡��! � ��� ����砭�� ��祭�� ����୮ ������ ���.' )
		endif
		if ! empty( ctod( oGet:buffer ) ) .and. ( ctod( oGet:buffer ) < dateField )
			dateField := oGet:original
			return func_error( 4, '�訡��! ��� ��砫� ��祭�� ����� ���� ����砭�� ��祭��.' )
		endif
	endif
	return .t.

***** ����� ���᪨� �㪢� �� ��⨭᪨� �� ����� ��������
function transform_mkb10( oGet, nKey, fl_F7 )
	local cKey
	
	if between( nKey, 32, 255 )
		cKey := CHR( nKey )
		************** ���� ��� �㪢�, ������ �� ��������� ⠬ ��, ��� � ���
		if oGet:pos < 4  // ����� � ��砫�
			cKey := kb_rus_lat( ckey )  // �᫨ ���᪠� �㪢�
		endif
		if cKey == ","
			cKey := "." // ������� ������� �� ��� (��஢�� ��������� ��� Windows)
		endif
		**************
		if ( SET( _SET_INSERT ) )
			oGet:insert( cKey )
		else
			oGet:overstrike( cKey )
		endif
		if ( oGet:typeOut )
			if ( SET( _SET_BELL ) )
				?? CHR(7)
			endif
			if ( !SET( _SET_CONFIRM ) )
				oGet:exitState := GE_ENTER
			endif
		endif
	endif
	return nil