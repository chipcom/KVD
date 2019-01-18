*************************************
*
*************************************

#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'def_bay.ch'

* 15.11.18
function edit_kartotek( mkod, _top_r, _bot_r, fl_oms, _Human_kod )
	local ar := GetIniVar( tmp_ini, { { 'RAB_MESTO', 'kart_polis', '1' } } )

	private p_edit_kartoteka := .f., p_find_polis := int( val( ar[ 1 ] ) )

	mkod := edit_kartotek_( mkod, _top_r, _bot_r, fl_oms, _Human_kod )
	if p_edit_kartoteka
		glob_kartotek := mkod
		p_edit_kartoteka := .f.
		mkod := edit_kartotek_( mkod, _top_r, _bot_r, fl_oms, _Human_kod )
	endif
	return mkod

* 21.12.18 �㭪�� ।���஢���� ��ꥪ� ��樥��
function edit_kartotek_( mkod, _top_r, _bot_r, fl_oms, _Human_kod )
	static mm_kart_error := { { '��� ����砭��', 0 }, { '����� ������⢨⥫��', -8 }, { '�訡�� � ४������', -9 } }
	static mm_invalid := { { '���', 0 }, { '1 ��㯯�', 1 }, { '2 ��㯯�', 2 }, ;
			{ '3 ��㯯�', 3 }, { '���-��������', 4 } }
	static mm_where_kart := { { '� ॣ�������', 0 }, { '� ���', 1 }, { '�� �㪠�', 2 } }
	static st_rab_nerab := 0

	local tmp_help := chm_help_code
	local flag_DVN, pos_read := 0, k_read := 0, count_edit := 0, ;
		count_row := 0, title_top
	local mkod_AK := space( 6 )

	local is_smp, fl_mr_dol := .f.
	local mmo_pr := ''
	local oPatient, oPassport, oPolicyOMS, oAddInfo, oExtendInfo
	local oForeignCitizen, item, tmpObject, oPrim1, aRepresentative := {}
	local oAddressRegistration, oAddressStay, oDubleName, oInogSMO, oHuman, oMo_hismo
	local oBox, oBoxAttach
	local flagError := .f.
	local fl := .f.
	local arrError := {}
	local fl_nameismo := .f.
    local m1mest_inog := 0, newmest_inog := 0
	local rec_inogSMO := 0, i
	local tmpArray
	&& local sPassport := space( 60 )
	&& local sPolicyOMS := space( 60 )
	local sDisability := space( 60 )

	private m1Passport := 1, mPassport := space( 60 )
	private m1PolicyOMS := 1, mPolicyOMS := space( 60 )
	private m1novor := 0 // ��।����� ����� ���祭�� � "�����" ��஥
	private is_talon := TDepartmentDB():IsTalon
	private mkart_error, m1kart_error := 0, ;
		manonim, m1anonim := 0, ;
		mpol := '�', ;
		madres := space( 50 ), ; // ���� ���쭮��
		mokatog := padr( alltrim( okato_umolch ), 11, '0' ), ;
		mokatop := space( 11 ), madresp := space( 50 ), ;
		m1adres_reg := 1, madres_reg, ;
		m1adres_pre := 1, madres_pre, ;
		mvzros_reb, m1vzros_reb := 0, ;
		mrab_nerab, m1rab_nerab := st_rab_nerab, ; // 0-ࠡ���騩, 1 -��ࠡ���騩
		m1gorod_selo := 1, mgorod_selo, ;
		mkategor, m1kategor := atail( stm_kategor )[ 2 ], ;  // �.�. ��稥
		mkategor2, m1kategor2 := 0, ;
		m1pensioner := 0, mpensioner, ;
		m1company := 0, mcompany, mm_company, ;
		m1komu := 0, mkomu, m1str_crb := 0, ;
		s_prim1 := '', ;
		mkol_pred := 0

	DEFAULT fl_oms TO .f., _Human_kod TO 0
	
	change_attr()
	if !( type( '_task_263_' ) == 'L' )
		private _task_263_ := .f.
	endif
	is_smp := fl_oms .and. ( ( type( 'm1usl_ok' ) == 'N' .and. m1usl_ok == 4 ) .or. ;
					( len( glob_otd ) > 2 .and. glob_otd[ 3 ] == 4 ) )
	if isnil( mkod )
		oPatient := TPatient():New()
	elseif isnumber( mkod )
		if mkod == 0
			oPatient := TPatient():New()
		else
			oPatient := TPatientDB():getByID( mkod )
		endif
	elseif isobject( mkod ) .and. mkod:classname == upper( 'TPatient' )
		oPatient := mkod
	else
		return nil
	endif
	
	mpol := oPatient:Gender
	
	oPassport := oPatient:Passport
	oPassport:Format := 'TYPE SSS � NNN �뤠�: DATE'
	if oPassport:DocumentType == 0
		mPassport := padr( '����� ����� �� 㤮�⮢�७�� ��筮��', 60 )
		&& sPassport := padr( '����� ����� �� 㤮�⮢�७�� ��筮��', 60 )
	else
		mPassport := padr( oPassport:AsString, 60 )
		&& sPassport := padr( oPassport:AsString, 60 )
	endif
	
	oAddressRegistration := oPatient:AddressRegistration
	oAddressStay := oPatient:AddressStay
	mokatog     := oAddressRegistration:OKATO       // ��� ���� ��⥫��⢠ �� �����
	madres      := oPatient:AddressReg
	mokatop		:= oAddressStay:OKATO
	madresp		:= oAddressStay:Address
			
	m1kart_error := oPatient:ErrorKartotek

	if oPatient:Mi_Git == 9
		m1komu    := oPatient:Komu
		m1str_crb := oPatient:InsuranceID
	endif
	if oPatient:IsAnonymous // �.�. ������
		if eq_any( glob_task, X_PLATN, X_KASSA ) .and. mem_anonim == 1
			m1anonim := 1
		endif
	elseif oPatient:Mest_Inog == 9 // �.�. �⤥�쭮 ����ᥭ� �.�.�.
		m1mest_inog := oPatient:Mest_Inog
	endif
	if is_uchastok > 0
		mbukva  := oPatient:Bukva
		muchast := oPatient:District
		mkod_vu := oPatient:Kod_VU
	endif
	oAddInfo := oPatient:AddInfo
	if ! oAddInfo:IsNew
		if is_uchastok == 3
			mkod_AK := left( oAddInfo:AmbulatoryCard, 6 )
		endif
		mmo_pr := oAddInfo:AttachmentInformation( glob_mo )
	endif
	
	oPolicyOMS	:= oPatient:PolicyOMS
	
	oPolicyOMS:Format := 'ISSUE TYPE SSS � NNN'
	if empty( oPolicyOMS:PolicyNumber )
		&& sPolicyOMS := padr( '����� ����� � ����� ���', 65 )
		mPolicyOMS := padr( '����� ����� � ����� ���', 65 )
	else
		&& sPolicyOMS := padr( oPolicyOMS:AsString, 65 )
		mPolicyOMS := padr( oPolicyOMS:AsString, 65 )
	endif
	
	m1gorod_selo:= oPatient:ExtendInfo:GorodSelo // ��⥫�?;1-��த, 2-ᥫ�, 3-ࠡ�稩 ��ᥫ��
	m1kategor   := oPatient:ExtendInfo:Category  // ��⥣��� ��樥��
	m1kategor2  := oPatient:ExtendInfo:Category2 // ��⥣��� ��樥�� (ᮡ�⢥���� ��� ��)
	m1kod_lgot  := oPatient:ExtendInfo:CodeLgot     // ��� �죮�� �� ���;;
	m1pensioner := if( oPatient:ExtendInfo:IsPensioner, 1, 0 )    // ���� ���ᨮ��஬?;0-���, 1-��;
	
	m1where_kart:= oPatient:ExtendInfo:WhereCard   // ��� ���㫠�ୠ� ����;0-� ॣ�������, 1-� ���, 2-�� �㪠�;

	// ����稬 ���ଠ�� �� �����������
	oPatient:Disability:Format := 'GROUP ��� �����祭��: DATE'
	if oPatient:Disability:Invalid == 0
		sDisability := padr( '����� ����� �� �����������', 60 )
	else
		sDisability := padr( oPatient:Disability:AsString, 60 )
	endif

	
	s_prim1 := TK_prim1DB():getByPatient( oPatient )
	
	oForeignCitizen := TForeignCitizenDB():getByPatient( oPatient )
	if isnil( oForeignCitizen )
		oForeignCitizen := TForeignCitizen():New()
	endif
	
	for each item in TRepresentativeDB():getByPatient( oPatient )
		if item:Number == 1
			++mkol_pred
			m1is_uhod_pr1 := if( item:IsCare, 1, 0 )
			m1is_food_pr1 := if( item:HasFood, 1, 0 )
			mFIO_PR1 := item:FIO
			mDATE_R_PR1 := item:DOB
			m1status_PR1 := item:Status
			mADRES_PR1 := item:Address
			mMR_DOL_PR1 := item:PlaceOfWork
			mphone_PR1 := item:Phone
			mpasport_PR1 := item:Passport
			mpolis_PR1 := item:Policy
		elseif item:Number == 2
			++mkol_pred
			m1is_uhod_pr2 := if( item:IsCare, 1, 0 )
			m1is_food_pr2 := if( item:HasFood, 1, 0 )
			mFIO_PR2 := item:FIO
			mDATE_R_PR2 := item:DOB
			m1status_PR2 := item:Status
			mADRES_PR2 := item:Address
			mMR_DOL_PR2 := item:PlaceOfWork
			mphone_PR2 := item:Phone
			mpasport_PR2 := item:Passport
			mpolis_PR2 := item:Policy
		endif
	next

	&& fv_date_r()
	mkart_error := inieditspr( A__MENUVERT, mm_kart_error, m1kart_error )
	mwhere_kart := inieditspr( A__MENUVERT, mm_where_kart, m1where_kart )
	
	mgorod_selo := inieditspr( A__MENUVERT, mm_gorod_selo, m1gorod_selo )
	manonim := inieditspr( A__MENUVERT, mm_danet, m1anonim )
	mpensioner := inieditspr( A__MENUVERT, mm_danet, m1pensioner )
	
	mvzros_reb := inieditspr( A__MENUVERT, menu_vzros, m1vzros_reb )
	mrab_nerab := inieditspr( A__MENUVERT, menu_rab, m1rab_nerab )
	mkategor   := inieditspr( A__MENUVERT, stm_kategor, m1kategor )
	mkategor2  := inieditspr( A__MENUVERT, stm_kategor2, m1kategor2 )
	mkod_lgot  := inieditspr( A__MENUVERT, glob_katl, m1kod_lgot )
	mkomu      := inieditspr( A__MENUVERT, mm_komu, m1komu )

	madres_reg := ini_adres_bay( 1 )
	madres_pre := ini_adres_bay( 2 )
	
	f_valid_komu_bay( , -1 )	
	if eq_any( m1komu, 1, 3 )
		m1company := m1str_crb
	endif
	mcompany := inieditspr( A__MENUVERT, mm_company, m1company )
//
	chm_help_code := 3001
	// ������ ���-�� ��ப
	if eq_any( glob_task, X_PLATN, X_KASSA ) .and. oPatient:IsAnonymous
		++count_row // ������
	endif
	if ! oPatient:IsNew .and. hb_user_curUser:IsAdmin .and. mem_kart_error == 1
		++count_row
	endif
	if glob_task != X_PPOKOJ .and. ( is_uchastok > 0 .or. ! empty( mmo_pr ) ) .and. ! is_smp
		++count_row
	endif
	count_row += 2 // �.�.�.
	++count_row // ��� ஦�����
	++count_row // ����⮢�७�� ��筮��: ���, ��� � �����
	if ! is_smp
		++count_row // ���� ஦�����
	endif
	if eq_any( glob_task, X_REGIST, X_PLATN, X_ORTO, X_KASSA, X_PPOKOJ, X_MO )
		++count_row // ��� � ����� �뤠��
	endif
	++count_row // ���� ॣ����樨
	if ! is_smp
		++count_row // ���� �ॡ뢠���
	endif
	++count_row // ����� ���: ���
	++count_row // ���
	if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_PLATN, X_ORTO )
		++count_row // �ਭ���������� ����
	endif
	flag_DVN := ( type( 'oms_sluch_DVN' ) == 'L' .and. oms_sluch_DVN )
	if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_MO ) .or. flag_DVN
		if is_talon .or. flag_DVN
			++count_row // ��⥣��� �� ���.⠫���
		endif
		if !empty( stm_kategor2 )
			++count_row // ��⥣��� ��
		endif
		++count_row // ������騩?
	endif
	if eq_any( glob_task, X_REGIST, X_PLATN, X_ORTO, X_KASSA, X_PPOKOJ, X_MO )
		++count_row // ���� ࠡ���, ���������
	endif
	++count_row // ⥫�䮭�
	if !eq_any( glob_task, X_PLATN, X_ORTO, X_KASSA, X_MO )
		++count_row // ������������
	endif
	if eq_any( glob_task, X_MO )
		++count_row // �죮� �� ���
	endif
	++count_row // ��⥫�:��த/ᥫ� + �ࠦ����� ��?
	if eq_any( glob_task, X_PPOKOJ )
		++count_row // ��� � ���
	endif
	if ( title_top := isnil( _top_r ) )
		DEFAULT _bot_r TO maxrow() - 1
		if ( _top_r := _bot_r - count_row - 1 ) < 0
			_top_r := 0
		endif
	else
		if ( _bot_r := _top_r + count_row + 1 ) > maxrow() - 1
			_bot_r := maxrow() - 1
			_top_r := _bot_r - count_row - 1
		endif
	endif

	oBox := TBox():New( _top_r, 0, _bot_r, maxcol(), .t. )
	oBox:CaptionColor := 'B/B*'
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - ��室;  ^<PgDn>^ - ���⢥ত���� �����'
	if title_top
		oBox:Caption := padc( iif( oPatient:IsNew, '���������� � ����⥪�', '������஢���� ����⥪�' ), 80 )
	else
		oBox:Caption := padc( '��������� ४����⮢ ��樥�� � ����⥪�', 80 )
		@ _bot_r, 0 say replicate( ' ', 80 ) color "B/B*"
	endif
	oBox:View()
	
	do while .t.
		
		ix := _top_r
		if ! oPatient:IsNew .and. hb_user_curUser:IsAdmin .and. mem_kart_error == 1
			@ ++ix, 1 say '�����' get mkart_error ;
					reader { | x | menu_reader( x, mm_kart_error, A__MENUVERT, , , .f. ) }
			keyboard chr( K_TAB )
		elseif m1kart_error < 0
			n_message( { '��������!', ;
					'��� ����窨 ��樥�� ��⠭����� �����', ;
					'" ' + upper( mkart_error ) + ' "' }, , 'GR+/R', 'W+/R', ix + 2, , 'G+/R' )
		endif
		if eq_any( glob_task, X_PLATN, X_KASSA ) .and. mem_anonim == 1
			if ix == _top_r
				++ix
			endif
			@ ix, 50 say '������?' get manonim ;
					reader { | x | menu_reader( x, mm_danet, A__MENUVERT, , , .f. ) }
			keyboard chr( K_TAB )
		endif

		if glob_task != X_PPOKOJ .and. ( is_uchastok > 0 .or. !empty( mmo_pr ) ) .and. !is_smp
			++ix
			if is_uchastok > 0
				@ ix, 1 say '���' get oPatient:Bukva pict '@!' when m1anonim == 0
				@ ix, col() + 3 say '���⮪' get oPatient:District pict '99' ;
								valid { | oGet | checkDistrict( oGet, oPatient ) } ;
								when m1anonim == 0
				if is_uchastok == 1
					@ ix, col() + 3 say '��� � ���⪥' get oPatient:Kod_VU pict '99999' ;
								when m1anonim == 0 .and. findKod_VU( oPatient )
				elseif is_uchastok == 3
					@ ix, col() + 3 say '����� �� ���' get mkod_AK pict '999999' when m1anonim == 0
				endif
			endif
			if !empty( mmo_pr )
				oBoxAttach := TBox():New( _top_r - 3, maxcol() - len( mmo_pr ) - 4, _top_r - 1, maxcol() )
				oBoxAttach:Frame := 1
				oBoxAttach:Color := cDataCGet
				oBoxAttach:View()
				@ _top_r - 2, maxcol() - len( mmo_pr ) - 2 say mmo_pr color if( '�_�_�_�' $ lower( mmo_pr ), 'R+/B', color8 )
			endif
		endif
		@ ++ix, 1 say '�������' get oPatient:LastName pict '@S33' ;
					valid { | oGet | lastkey() == K_UP .or. m1anonim == 1 .or. checkGetFIO( oGet, 1 ) }
		@ row(), col() + 1 say '���' get oPatient:FirstName pict '@S32' ;
					valid { | oGet | m1anonim == 1 .or. checkGetFIO( oGet, 2 ) }
		@ ++ix, 1 say '����⢮' get oPatient:MiddleName ;
					valid { | oGet | m1anonim == 1 .or. checkGetFIO( oGet, 3 ) }
		if mem_pol == 1
			@ row(), 70 say '���' get mpol ;
						reader { | x | menu_reader( x, menupol, A__MENUVERT, , , .f. ) }
		else
			@ row(), 70 say '���' get mpol pict '@!' valid { | oGet | oGet:buffer $ '��' }
		endif
		@ ++ix, 1 say '��� ஦�����' get oPatient:DOB valid { | oGet | roCheckDOB( oGet, oPatient ) }
		@ row(), 30 say '==>' get mvzros_reb := inieditspr_bay( A__MENUVERT, TPatient():aMenuCategory, oPatient:Vzros_Reb ) when .f. color cDataCSay
		@ row(), 50 say '�����' get oPatient:SNILS pict picture_pf valid { | oGet | roCheckSNILS( oGet, oPatient ) } when m1anonim == 0
		
		&& @ ++ix, 1 say '��-�� ��筮��:' get sPassport ;
		@ ++ix, 1 say '��-�� ��筮��:' get mPassport ;
					color if( oPassport:DocumentType == 0, 'GR+/B, W+/R', 'W/B, W+/R' ) ;
					reader { | x | menu_reader( x, { { | k, r, c | inputPassport( oPatient, oPassport, oForeignCitizen ) } }, A__FUNCTION, , , .f. ) } ;
					when m1anonim == 0
					&& valid { | | ( inputPassport( oPatient, oPassport, oForeignCitizen, @sPassport ), update_gets() ) } ;
		
		@ ++ix, 1 say '���� ॣ����樨' get madres_reg ;
					reader { | x | menu_reader( x, { { | k, r, c | getAddressPatient( 1, k, r, c ) } }, A__FUNCTION, , , .f. ) } ;
					when m1anonim == 0
		if ! is_smp
			@ ++ix, 1 say '���� �ॡ뢠���' get madres_pre ;
					reader { | x | menu_reader( x, { { | k, r, c | getAddressPatient( 2, k, r, c ) } }, A__FUNCTION, , , .f. ) } ;
					when m1anonim == 0

		endif
		// TODO ࠧ������� �� ���� � �ਭ�����������
		if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_PLATN, X_ORTO )
			@ ++ix, 1 SAY '�ਭ���������� ���' GET mkomu ;
						reader { | x | menu_reader( x, mm_komu, A__MENUVERT, , , .f. ) } ;
						valid { | oGet, o | f_valid_komu_bay( oGet, o ) } ;
						when m1anonim == 0
			@ row(), col() + 1 say '==>' get mcompany ;
						reader { | x | menu_reader( x, mm_company, A__MENUVERT, , , .f. ) } ;
						when eq_any( m1komu, 1, 3 )
		endif
		&& @ ++ix, 1 say '����� ���:' get sPolicyOMS ;
		@ ++ix, 1 say '����� ���:' get mPolicyOMS ;
					color if( empty( oPolicyOMS:PolicyNumber ), 'GR+/B, W+/R', 'W/B, W+/R' ) ;
					reader { | x | menu_reader( x, { { | k, r, c | inputPolicyOMS( oPolicyOMS, oPatient ) } }, A__FUNCTION, , , .f. ) } ;
					when m1anonim == 0
					&& valid { | | ( inputPolicyOMS( oPolicyOMS, oPatient, @sPolicyOMS ), update_gets() ) } ;
					
		if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ, X_MO ) .or. flag_DVN
			if is_talon .or. flag_DVN
				@ ++ix, 1 say '��� ��⥣�ਨ �죮��'
				c := col() + 1
				if .t.//mem_st_kat == 1
					@ ix, c get mkategor ;
							reader { | x | menu_reader( x, mo_cut_menu( stm_kategor ), A__MENUVERT, , , .f. ) } when m1anonim == 0
					c += 24
				else
					@ ix, c get m1kategor pict '99' ;
							valid { | g | val_st_kat( g ) }
					@ row(), col() + 3 get mkategor color color14 when .f.
					c += 27
				endif
			endif
			if !empty( stm_kategor2 )
				@ ++ix, c say '��⥣��� ��' get mkategor2 ;
					reader { | x | menu_reader( x, stm_kategor2, A__MENUVERT, , , .f. ) } when m1anonim == 0
			endif
			@ ++ix, 1 say '������騩?' get mrab_nerab ;
					reader { | x | menu_reader( x, menu_rab, A__MENUVERT, , , .f. ) } ;
					when m1anonim == 0
			@ row(), col() + 5 say '���ᨮ���?' get mpensioner ;
					reader { | x | menu_reader( x, mm_danet, A__MENUVERT, , , .f. ) } ;
					when m1anonim == 0
		endif
		if eq_any( glob_task, X_REGIST, X_PLATN, X_ORTO, X_KASSA, X_PPOKOJ, X_MO )
			fl_mr_dol := .t.
			@ ++ix, 1 say '���� ࠡ���, ���������' get oPatient:PlaceWork when m1anonim == 0
		endif
		@ ++ix, 1 say '����䮭�: ����譨�' get oPatient:ExtendInfo:HomePhone valid { | oGet | valid_phone_bay( oGet ) } when m1anonim == 0
		@ row(), col() + 1 say ', �������' get oPatient:ExtendInfo:MobilePhone valid { | oGet | valid_phone_bay( oGet, .t. ) } when m1anonim == 0
		@ row(), col() + 1 say ', ࠡ�稩' get oPatient:ExtendInfo:WorkPhone valid { | oGet | valid_phone_bay( oGet ) } when m1anonim == 0
		
		// ������������
		if ! eq_any( glob_task, X_PLATN, X_ORTO, X_KASSA )
			@ ++ix, 1 SAY '������������' GET sDisability ;
						color if( oPatient:Disability:Invalid == 0, 'GR+/B, W+/R', 'W/B, W+/R' ) ;
						valid { | | ( inputDisability( ix, oPatient, @sDisability ), update_gets() ) } ;
						when m1anonim == 0
		endif
		if eq_any( glob_task, X_MO )
			@ ++ix, 1 say '�죮� �� ���' get mKOD_LGOT ;
						reader { | x | menu_reader( x, glob_katl, A__MENUVERT, , , .f. ) } when m1anonim == 0
		endif
		@ ++ix, 1 say '��⥫�:' GET mgorod_selo ;
						reader { | x | menu_reader( x, mm_gorod_selo, A__MENUVERT, , , .f. ) } when m1anonim == 0

		if eq_any( glob_task, X_PPOKOJ )
			@ ++ix, 1 SAY '����' GET oPatient:ExtendInfo:Height pict '999'
			@ ix, col() + 1 SAY '�,  ���' GET oPatient:ExtendInfo:Weight pict '999' when m1anonim == 0
			@ ix, col() + 1 SAY '��'
			@ ix, col() + 5 SAY '������⢮ �।�⠢�⥫��' GET mkol_pred pict '9' ;
					valid { | | between( mkol_pred, 0, 2 ) .and. f_kart_valid_pred( ix ) } ;
					when m1anonim == 0
		endif
		if ! oPatient:IsNew
			// �뢥��� ����� ���짮��⥫� ��᫥���� ।���஢��訩 ��樥��
			@ ++ix, 1 SAY '�������: ' ;
					+ alltrim( TUserDB():getByID( asc( substr( oAddInfo:PC1, 1, 1 ) ) ):FIO ) ;
					+ ', ' + dtoc( c4tod( substr( oAddInfo:PC1, 2, 4 ) ) ) ;
					+ ' ' + substr( oAddInfo:PC1, 6 ) ;
					color 'R/B, W+/R'
		endif

		if pos_read > 0
			if lower( GetList[ pos_read ]:name ) == 'mgorod_selo'
				--pos_read
			endif
		endif
		// ��⠭���� ��ࠡ��稪�� ������ ������
		set key K_F2 TO f_prim1
		if fl_mr_dol
			set key K_F4 TO v_vvod_mr_bay
		endif

		count_edit := myread( , @pos_read, ++k_read )
		if fl_mr_dol
			set key K_F4 TO
		endif
		set key K_F2 TO
		if p_edit_kartoteka // �� ���������� ��諨 � ����⥪� ⠪��� ��樥��
			exit 
		endif
		if lastkey() != K_ESC
		
			// ᭠砫� �஢���� �஢��� �� ��������� �㦭� ����
			arrError := {}
			aadd( arrError, '�����㦥�� ᫥���騥 �訡��:' )
			flagError := .f.
			if empty( rtrim( oPatient:LastName ) + ' ' + rtrim( oPatient:FirstName ) + ' ' + rtrim( oPatient:MiddleName ) )
				flagError := .t.
				aadd( arrError, '��������� �.�.�.' )
			endif
			if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ ) .and. m1komu == 0
				if empty( oPatient:DOB )
					flagError := .t.
					aadd( arrError, '��������� ��� ஦�����' )
				endif
				if m1anonim != 1 .and. empty( oPolicyOMS:PolicyNumber ) .and. ! _task_263_
					flagError := .t.
					aadd( arrError, '��������� ����� �����' )
				endif
			endif
			if flagError
				hb_Alert( arrError, , , 4 )
				loop
			endif
			if m1anonim != 1
				validNumberPolicyOMS( oPolicyOMS, between( m1namesmo, 34001, 34007 ) )
			endif

			if f_Esc_Enter( 1 )
				if m1anonim == 1
					newmest_inog := 8
				elseif TwoWordFamImOt( oPatient:LastName ) .or. TwoWordFamImOt( oPatient:FirstName ) .or. TwoWordFamImOt( oPatient:MiddleName )
					newmest_inog := 9
				endif
				fl_write_kartoteka := .t.
				st_rab_nerab := m1rab_nerab
				
				oPatient:ErrorKartotek := m1kart_error
				oPatient:Gender := mpol
				// ���㬥�� 㤮�⮢����騩 ��筮���
				oPatient:Passport := oPassport
				// ᮡ�ࠥ� ���� ॣ����樨
				oAddressRegistration:Address := madres
				oAddressRegistration:OKATO := mokatog
				oPatient:AddressReg := oAddressRegistration
				// ᮡ�ࠥ� ���� �ॡ뢠���
				oAddressStay:Address := madresp
				oAddressStay:OKATO := mokatop
				oPatient:AddressStay := oAddressStay
				// ᮡ�ࠥ� ����� ���
				oPatient:PolicyOMS := oPolicyOMS
				if eq_any( glob_task, X_REGIST, X_OMS, X_PPOKOJ )
					oPatient:Komu := m1komu
					oPatient:InsuranceID := iif( m1komu == 0, 0, m1company ) //m1str_crb
					oPatient:Mi_Git := 9
				endif
				oPatient:Mest_Inog := newmest_inog
				oAddInfo:PC1 := chr( hb_user_curUser:ID ) + c4sys_date + hour_min( seconds() )
				if is_uchastok == 3
					oAddInfo:AmbulatoryCard := mkod_AK
				endif

				oPatient:ExtendInfo:CodeLgot := m1kod_lgot		// ��� �죮�� �� ���
				oPatient:ExtendInfo:GorodSelo := m1gorod_selo	// ��⥫�?;1-��த, 2-ᥫ�, 3-ࠡ�稩 ��ᥫ��
				oPatient:ExtendInfo:Category := m1kategor		// ��⥣��� ��樥��
				oPatient:ExtendInfo:Category2 := m1kategor2		// ��⥣��� ��樥�� (ᮡ�⢥���� ��� ��)
				oPatient:ExtendInfo:IsPensioner := if( m1pensioner == 1, .t., .f. )   // ���� ���ᨮ��஬?;0-���, 1-��;

				oPatient:ExtendInfo:WhereCard := m1WHERE_KART   // ��� ���㫠�ୠ� ����;0-� ॣ�������, 1-� ���, 2-�� �㪠�;

				// ��࠭塞 ��ꥪ��
				if TPatientDB():Save( oPatient ) != -1	// �����뢠���� 䠩�� kartotek.dbf, kartote_.dbf � kartote2.dbf
					oExtendInfo := oPatient:ExtendInfo
					// ��࠭�� ���ଠ�� � ��樥�� �����࠭�
					if oPatient:ExtendInfo:Strana == '' .or. oPatient:ExtendInfo:Strana == '643'
						tmpObject := TForeignCitizenDB():getByPatient( oPatient )
						if ! isnil( tmpObject )
							TForeignCitizenDB():Delete( tmpObject )
							tmpObject := nil
						endif
					else
						if oForeignCitizen:IsNew
							oForeignCitizen:IDPatient := oPatient:ID
						endif
						TForeignCitizenDB():Save( oForeignCitizen )
					endif
					// ��࠭�� ���ଠ�� �� ����������� ��樥��
					if oPatient:Disability:Invalid == 0
						tmpObject := TDisabilityDB():getByPatient( oPatient )
						if ! isnil( tmpObject )
							TDisabilityDB():Delete( tmpObject )
							tmpObject := nil
						endif
					else
						if oPatient:Disability:IsNew
							oPatient:Disability:IDPatient := oPatient:ID
						endif
						TDisabilityDB():Save( oPatient:Disability )
					endif
					// ��࠭�� ���ଠ�� � ������� 䠬�����, ������ ��樥��
					if m1mest_inog == 9 .or. newmest_inog == 9
						oDubleName := TDubleFIODB():getByPatient( oPatient )
						if ! isnil( oDubleName )
							if newmest_inog == 9
								oDubleName:LastName := oPatient:LastName
								oDubleName:FirstName := oPatient:FirstName
								oDubleName:MiddleName := oPatient:MiddleName
								TDubleFIODB():Save( oDubleName )
							else
								TDubleFIODB():Delete( oDubleName )
							endif
						else
							if newmest_inog == 9
								oDubleName := TDubleFIO():New()
								oDubleName:IDPatient := oPatient:ID
								oDubleName:LastName := oPatient:LastName
								oDubleName:FirstName := oPatient:FirstName
								oDubleName:MiddleName := oPatient:MiddleName
								TDubleFIODB():Save( oDubleName )
							endif
						endif
					endif
					// ���ଠ�� � �����த��� ���客�� ��������
					if oPolicyOMS:IsInogSMO
						oInogSMO := TMo_kismoDB():getByPatient( oPatient )
						if ! isnil( oInogSMO )
							if oPolicyOMS:IsInogSMO
								oInogSMO:Name := oPolicyOMS:NameInogSMO
								TMo_kismoDB():Save( oInogSMO )
							else
								TMo_kismoDB():Delete( oInogSMO )
							endif
						else
							if oPolicyOMS:IsInogSMO
								oInogSMO := TMo_kismo():New()
								oInogSMO:IDPatient := oPatient:ID
								oInogSMO:Name := oPolicyOMS:NameInogSMO
								TMo_kismoDB():Save( oInogSMO )
							endif
						endif
					endif
					// �������⥫�� �ਬ�砭�� � ��樥���
					TK_prim1DB():Delete( oPatient )
					if ! empty( s_prim1 )
						for i := 1 to mlcount( s_prim1, 100 )
							oPrim1 := TK_prim1():New()
							oPrim1:IDPatient := oPatient:ID
							oPrim1:Stroke := if( i < 10, i, 9 )
							oPrim1:Name := rtrim( memoline( s_prim1, 100, i ) )
							TK_prim1DB():Save( oPrim1 )
						next
					endif
					// ��࠭�� �।�⠢�⥫��, �᫨ ����
					if mkol_pred > 1
						if empty( mFIO_PR2 )
							mkol_pred := 1
						endif
					endif
					if mkol_pred > 0
						if empty( mFIO_PR1 )
							mkol_pred := 0
						endif
					endif
					aRepresentative := TRepresentativeDB():getByPatient( oPatient )
					asort( aRepresentative, , , { | x, y | x:Number < y:Number } )
					fl := .f.
// TODO �� ࠧ �஢����
					i := 0
					for each item in aRepresentative
						++i
						if mkol_pred <= 0
							TRepresentativeDB():Delete( item )
						else
							item:IDPatient := oPatient:ID
							item:Number := i
							if i == 1
								item:IsCare := m1is_uhod_pr1
								item:HasFood := m1is_food_pr1
								item:FIO     := mFIO_PR1
								item:DOB  := mDATE_R_PR1
								item:Status  := m1status_PR1
								item:Address   := mADRES_PR1
								item:PlaceOfWork  := mMR_DOL_PR1
								item:Phone   := mphone_PR1
								item:Passport := mpasport_PR1
								item:Policy   := mpolis_PR1
							else
								item:FIO     := mFIO_PR2
								item:DOB  := mDATE_R_PR2
								item:Status  := m1status_PR2
								item:Address := mADRES_PR2
								item:PlaceOfWork  := mMR_DOL_PR2
								item:Phone   := mphone_PR2
								item:Passport := mpasport_PR2
								item:Policy   := mpolis_PR2
							endif
						endif
					next
					
					AuditWrite( glob_task, OPER_KART, iif( oPatient:IsNew, AUDIT_INS, AUDIT_EDIT ), 1, count_edit )
					// �᫨ ��室���� � ����� '���' � ।����㥬 ������ ��樥��
					if glob_task == X_OMS .and. ! oPatient:IsNew
						tmpArray := {}
						tmpArray := THumanDB():getListCaseNotReestrbyPatient( oPatient, _Human_kod )
						if ( i := len( tmpArray ) ) > 0
							keyboard ''
							if f_alert( { '�� ��樥��� "' + alltrim( oPatient:FIO ) + '" �������', ;
										'���⮢ ����, �� ������� � ॥���: ' + lstr( i ) + '.', ;
										'��� �।�������� ��१������ ��।���஢����', ;
										'४������ ��樥�� � ����� ����� ����', ;
										'', ;
										'�롥�� ����⢨�:' }, ;
										{ ' �⪠� ',' ��१������ ' }, ;
										2, 'GR+/R', 'W+/R', _top_r + 1, , 'GR+/R,N/BG' ) == 2
								for i := 1 to len( tmpArray )
									oHuman := THumanDB():getByID( tmpArray[ i ] )
									if ! isnil( oHuman )
										oHuman:FIO := oPatient:FIO
										oHuman:Gender := oPatient:Gender
										oHuman:DOB := oPatient:DOB
										oHuman:Vzros_Reb := oPatient:Vzros_Reb		// 0-�����, 1-ॡ����, 2-�����⮪
										oHuman:AddressReg := oPatient:AddressReg
										oHuman:PlaceWork := oPatient:PlaceWork
										oHuman:Working := oPatient:Working
										oHuman:Komu := oPatient:Komu
										oPolicyOMS := oPatient:PolicyOMS
										oHuman:Komu := oPatient:Komu
										oHuman:Policy := oPatient:Policy
										if ! isnil( oPolicyOMS )
											oHuman:PolicyOMS := oPolicyOMS
										endif
										if THumanDB():Save( oHuman ) != -1
											// ���ଠ�� � �����த��� ���客�� ��������
											if oPolicyOMS:IsInogSMO
												oInogSMO := TMo_hismoDB():getByHuman( oHuman )
												if ! isnil( oInogSMO )
													if oPolicyOMS:IsInogSMO
														oInogSMO:Name := oPolicyOMS:NameInogSMO
														TMo_hismoDB():Save( oInogSMO )
													else
														TMo_hismoDB():Delete( oInogSMO )
													endif
												else
													if oPolicyOMS:IsInogSMO
														oInogSMO := TMo_hismo():New()
														oInogSMO:IDPatient := oHuman:ID
														oInogSMO:Name := oPolicyOMS:NameInogSMO
														TMo_hismoDB():Save( oInogSMO )
													endif
												endif
											endif
										endif
									endif
								next
							&& m1novor := human_->NOVOR
							&& fv_date_r(human->N_DATA)
								stat_msg( '������ �����襭�!' )
							endif
						endif
					endif
				endif
			endif
		endif
		exit
	enddo
	chm_help_code := tmp_help
	
	if !empty( mmo_pr )
		oBoxAttach := nil
	endif
	oBox := nil
	return oPatient:ID

* ����᪨� �㭪樨 ��� edit_kartotek()

* 20.11.18
function checkDistrict( oGet, oPatient )

	if is_uchastok == 1 .and. val( oGet:buffer ) != oGet:original
		oPatient:Kod_VU := 0
		update_gets()
	endif
	return .t.

* 20.11.18
function findKod_VU( oPatient )
	local t_kod_vu := 0

	if oPatient:District > 0 .and. oPatient:Kod_VU == 0
		if ( t_kod_vu := TPatientDB():NextKod_VU( oPatient:District ) ) > 0
			oPatient:Kod_VU := t_kod_vu
			update_gets()
		endif
	endif
	return .t.

* 15.11.18
function val_st_kat( get )
	local i, fl := .t.

	if ( i := ascan( stm_kategor, { | x | x[ 2 ] == m1kategor } ) ) > 0
		mkategor := padr( stm_kategor[ i, 1 ], 38 )
		update_get( 'mkategor' )
	else
		fl := func_error( 4, '�������⨬� ��� ��⥣�ਨ' )
		m1kategor := get:original
	endif
	return fl