* PaidServices.prg - �����⥬� ࠡ�� � ����묨 ��㣠��
*******************************************************************************
// 19.02.19 printReferenceToFTS( oPatient, aObjects ) - ����� �ࠢ�� ��� ��������� �㦡�
* 13.11.18 printReceipt( oContract, nKey ) - ����� 祪� �� ���
* 13.11.18 printContract( oContract ) - ����� �������
* 13.11.18 printCopyReceipt( oContract ) - ����� ����� 祪�, �᫨ ����
* 05.11.18 controlPayer( nType, cName )
* 15.06.17 begin_task_plat() - ���樠������ ������ ���
* 24.06.17 checkMyself() - �஢�ਬ ���⥫�騪� ᠬ ����� ( ���⨬ ���� ����� ), ��� ���
* 26.06.17 f_usl_date() - �-�� �����誠 ��� ᮢ���⨬���
* 27.06.17 TransformPhone( address ) - �८�ࠧ������ ⥫�䮭���� ����� � ��ଠ��� �ଠ� ��� ���
* 03.11.17 IncomeCashBayerPay( oCheck, nStartRow, cBorderColor, cBoxColor ) - �뢮� ᮮ�饭�� � ����祭��� �������� �।�⢠�	
* 03.11.17 RecalcCheck( get, oCheck, lBank ) - ������ ����� ����� � ���⥦�
* 27.06.17 ControlAddress( get, address ) - �஢�ઠ ���� ��� ⥫�䮭� �� �����⨬���� ��� ���
* 27.06.17 BankGet( oCheck, buf, sizeFrame, sizeFrameBank ) - �ନ஢���� ����� ��� ����� ������᪨� ���⥦��
* 27.06.17 controlSizeBox( g, old, oCheck, sizeFrame, sizeFrameBank, buf ) - �ࠢ����� ࠧ��஬ ������ ��� ����� ������᪨� ���⥦��
* 03.11.17 yes_chek( oCheck, rm ) - ����� �� ���� ���ଠ樨 � ���⥦� � 祪�
*******************************************************************************

#include 'set.ch'
#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

static emailTemplate := '^[-._a-z0-9]+@(?:[a-z0-9][-a-z0-9]+\.)+[a-z]{2,6}$'
static phoneTemplate := '^(\s*)?(\+)?([- _():=+]?\d[- _():=+]?){10,14}(\s*)?$'

* 15.06.17 - ���樠������ ������ ���
function begin_task_plat()
	static n_zapusk := 0
	local ret := .t.

	loadVariableKKT()
	// ���樠�����㥬 �ࠩ���
	InitDriverFR()
	if n_zapusk == 0
		++n_zapusk
		public menu_kb := { { '�����', PU_PLAT }, ;
							{ '���    ', PU_D_SMO }, ;
							{ '�/����', PU_PR_VZ } }
		public count_otd := 1
		public count_uch := 1
		public gmenu_kateg := TEmployee():aMenuCategory
	endif
	if copy_Tools_Ini()
		Tools_Ini_OMS( 1, 0, 0 )
		Tools_Ini_Platn( 1, 0, 0 )
	else
		ret := .f.
	endif
	return ret

function fillColumnCheque( obj )
	local ret := '     '
	
	if obj != nil
		if( obj:TypeService == PU_PLAT )
			ret := { '     ', str( obj:ReceiptNumber, 5 ), '' }[ obj:IsCashbox + 1 ]
		elseif( obj:TypeService == PU_PR_VZ )
			ret := '�/� '
		elseif( obj:TypeService == PU_D_SMO )
			ret := '�/� '
		endif
	endif
	return ret
	
* 07.06.17 **** ������ ��०����� � �⤥����� � GET'�
function fillGetFieldDepAndSub( k, r, c, date1, date2, nTask )
	local ret, n := 1, oDepartment := nil
	
	if k != nil .and. k > 0
		glob_uch[ 1 ] := k
	endif
	if ( oDepartment := SelectDepartment( r, c, date1, date2 ) ) != nil
		if type( 'm1otd' ) == 'N' .and. m1otd > 0
			glob_otd[ 1 ] := m1otd
		endif
		if SelectSubdivision( r, c, oDepartment, date1, date2, nTask ) != nil
			if valtype( motd ) == 'C'
				n := len( motd )
			endif
			m1otd := glob_otd[ 1 ] ; motd := alltrim( glob_otd[ 2 ] )
			if len( motd ) < n
				motd := padr( motd, n )
			endif
			ret := glob_uch
		endif
	endif
	return ret

// 19.02.19 - ����� �ࠢ�� ��� ��������� �㦡�
// function printReferenceToFTS( oPatient, aContracts )
	
// 	private mPatient := oPatient
// 	private mContracts := aContracts
// 	print_shablon( alltrim( dir_exe() + 'ReferenceToFTS.shb' ) )
// 	return nil

* 13.11.18 - ����� �������
function printContract( oContract )
	local oPatient := nil, oPatientExt := nil
	local oContractPayer := nil
	local buf
	
	private moContract := oContract
	private m1vid_ud, mnom, mser, mvid_ud
	private mplat_adres  := space( 50 ),; 			// ���� ���⥫�騪�
			mplat_pasport := space( 15 )  		// ���㬥�� ���⥫�騪�
	private lnomer, l1nomer, muchastok
	//
	buf := savescreen()
	ClrLine( 23, color0 )
	oPatient := moContract:Patient
	//01.12.08 ��砫�
	lnomer := l1nomer := oPatient:ID()
	muchastok := put_val( oPatient:District(), 2 )
	luchast := ''
	if is_uchastok == 1
		if !emptyall( oPatient:Bukva(), oPatient:District(), oPatient:Kod_VU() )
			lnomer := '' + iif( !empty( oPatient:Bukva() ), oPatient:Bukva(), '' ) + lstr( oPatient:District(), 2 ) + iif( oPatient:Kod_VU() > 0, '/' + lstr( oPatient:Kod_VU() ), '' )
			l1nomer := lnomer
		endif
	elseif eq_any( is_uchastok, 2, 3 )
		if !emptyall( oPatient:Bukva(), oPatient:District() )
			luchast := ' [��-� ' + iif( !empty( oPatient:Bukva() ), oPatient:Bukva(), '' ) + lstr( oPatient:District(), 2 ) + '] '
		endif
		if is_uchastok == 3
			if oPatient:AddInfo() != nil
				luchast += alltrim( oPatient:AddInfo():AmbulatoryCard )
			endif
		endif
	endif
	lnomer := expand( lnomer ) + luchast
	if ( oPatientExt := TPatientExtDB():getByID( oPatient:ID() ) ) != nil
		m1vid_ud := oPatientExt:Passport:DocumentType	//TypeDocument()
		mnom     := oPatientExt:Passport:DocumentNumber	//DocumentNumber()
		mser     := oPatientExt:Passport:DocumentSeries	//SeriesOfDocument()
		mvid_ud := ''
		// if ( j := ascan( menu_vidud, { | x | x[ 2 ] == m1vid_ud } ) ) > 0
		// mvid_ud := menu_vidud[ j, 4 ]
		if ( j := ascan( get_Name_Vid_Ud(), { | x | x[ 2 ] == m1vid_ud } ) ) > 0
			mvid_ud := get_Name_Vid_Ud()[ j, 4 ]
		endif
	else
		m1vid_ud := 0
		mvid_ud := ''
		mnom     := ''
		mser     := ''
	endif
	if ( oContractPayer := TContractPayerDB():GetByIdLU( oContract:ID() ) ) != nil
		mplat_adres   := oContractPayer:Address
		mplat_pasport := oContractPayer:Passport
	else
		mplat_adres   := ''
		mplat_pasport := ''
	endif
	if len( alltrim( mem_dogovor ) ) > 3
		print_shablon( alltrim( mem_dogovor ) )
	else
		private file_sh
		if !empty( alltrim( mem_dogovor ) ) .and. ;
				!empty( file_sh := menu_shablon( 3, 3, dir_exe() + '*.' + upper( alltrim( mem_dogovor ) ), ;
					color8, .f. ) )
			f1_pr_shab( file_sh )
		endif
	endif
	flag := 0
	restscreen( buf )
	return .t.

* 05.11.18	
function controlPayer( nType, cName )
	local lst, iRet, mtitle, nPos := 0
	local aProperties
	local oBox
	local oPayer
	
	&& hb_Default( @nType, 0 )
	&& mtitle := "�������� ���⥫�騪�"
	&& lst := TPayer():GetListByName( nType, cName )
	&& if len( lst ) > 0
		&& aProperties := { { 'FIO', '�.�.�.', 49 } }
		&& oBox := TBox():New( T_ROW, 2, T_ROW + 10, 78, .t. )
		&& oBox:Color := color5
		&& oBox:Caption := mtitle
		&& oBox:CaptionColor := col_tit_popup
		&& oPayer := ListObjectsBrowse( 'TPayer', oBox, lst, 1, aProperties, , , , , , .t. )
		&& if ! isnil( oPayer )
			&& mplat_fio := oPayer:FIO()
			&& mplat_inn := oPayer:INN()
			&& mplat_adres := oPayer:Adress()
			&& mplat_pasport := oPayer:Passport()
			&& update_gets()
		&& endif
	&& endif
	return .t.

* 24.06.17 - �஢�ਬ ���⥫�騪� ᠬ ����� ( ���⨬ ���� ����� ), ��� ���
function checkMyself()

	if m1Myself == 1
		mplat_fio := space( 40 )
		mplat_inn := space( 12 )
		mplat_adres := space( 50 )			// ���� ���⥫�騪�
		mplat_pasport := space( 15 )				// ���㬥�� ���⥫�騪�
	endif
	return .t.

* 03.11.17 - ����� �� ���� ���ଠ樨 � ���⥦� � 祪�
function yes_chek( oCheck, rm )
	local bufFull := savescreen()
	local j, fl := .f., tmp_color, buf, buf24, r := 16
	local sizeFrame := 0, sizeFrameBank := 0

	private paymentType2 := 0
	private paymentType3 := 0, paymentType4 := 0
	private maddress := space( 25 )
	private mm_da_net := { { '�� ', 1 }, { '���', 2 } }
	private mBank, m1Bank := 2				// ���� �� ���⥦ �� ����
	private vnos_summa := oCheck:Total
	
	mBank := inieditspr( A__MENUVERT, mm_da_net, m1Bank )
	tmp_color := setcolor( cDataCGet )
	buf24 := save_row( maxrow() )
	do while .t.
		do while .t.
			r := 16
			sizeFrame := 0
			sizeFrameBank := 0
			// �஢�ਬ, �᫨ ��� ��譨� ����ᮢ, ��室�� �� 横��
			if !getDrvFR():OtherTypePay() .and. !getDrvFR():Change
				fl := f_Esc_Enter( '���� ����' )
				exit
			endif
			sizeFrame := 1 + iif( getDrvFR():Change , 1, 0 ) + iif( getDrvFR():IsFiscalReg(), 1, 0 ) // �� ����稨 ����� ᤠ� � ������⢨� ��
			if getDrvFR():OtherTypePay()
				sizeFrame := ++sizeFrame			// ��� ����� � �����
				if m1Bank == 1						// ���� ���� � �� ��࠭
					sizeFrameBank := sizeFrame + iif( getDrvFR():EnableTypePay2, 1, 0 ) + ;	// �� 2 ��� ������
										iif( getDrvFR():EnableTypePay3, 1, 0 ) + ;	// �� 3 ��� ������
										iif( getDrvFR():EnableTypePay4, 1, 0 )		// �� 4 ��� ������
					buf := box_shadow( r, 5, r + sizeFrameBank, 74 )
				else
					buf := box_shadow( r, 5, r + sizeFrame, 74 )
				endif
			endif
			
			BankGet( oCheck, @buf, sizeFrame, sizeFrameBank )
			myread()
			if lastkey() == K_ESC .or. lastkey() == K_PGDN
				exit
			endif
		enddo
		if !fl
			j := f_alert( { padc( '�롥�� ����⢨�', 60, '.' ) }, ;
				{ ' ��室 ��� ����� ',' ����� 祪� ', ' ������ � ।���஢���� ' }, ;
				iif( lastkey() == K_ESC, 1, 2 ), 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N,N/BG' )
			if j < 2
				exit
			elseif j == 3
				loop
			endif
		endif
		// ��� ��� � �� ��ନ�㥬 ���� ���ࠢ����� 祪�
		if getDrvFR():IsFiscalReg()
			if hb_RegexLike( phoneTemplate, maddress )
				maddress := TransformPhone( maddress )
			else
				maddress := alltrim( maddress )
			endif
			oCheck:EMail := maddress
		endif
		oCheck:Received := vnos_summa - paymentType2 - paymentType3 - paymentType4
		oCheck:Cash := vnos_summa
		oCheck:PayType2 := paymentType2
		oCheck:PayType3 := paymentType3
		oCheck:PayType4 := paymentType4
		IncomeCashBayerPay( oCheck, rm )
		fl := .t.
		exit
	enddo
	rest_box( buf )
	rest_box( buf24 )
	restscreen( bufFull )
	setcolor( tmp_color )
	return fl	
	
* 27.06.17 - �ࠢ����� ࠧ��஬ ������ ��� ����� ������᪨� ���⥦��
function controlSizeBox( g, old, oCheck, sizeFrame, sizeFrameBank, buf )
	local r := 16
	
	if old != NIL .and. old != m1Bank
		rest_box( buf )
		if m1Bank == 1
			buf := box_shadow( r, 5, r + sizeFrameBank, 74 )
		else
			buf := box_shadow( r, 5, r + sizeFrame, 74 )
			vnos_summa := oCheck:Total
		endif
		@ ++r, 7 SAY '���⥦ �� �����:'
		@ ++r, 7 say '�㬬� ��।����� ���⥫�騪�� (��� ������ ᤠ�)'
		BankGet( oCheck, @buf, sizeFrame, sizeFrameBank )
	endif
	return .t.

* 27.06.17 - �ନ஢���� ����� ��� ����� ������᪨� ���⥦��
function BankGet( oCheck, buf, sizeFrame, sizeFrameBank )
	local r := 16

	clear_gets()
	if getDrvFR():OtherTypePay()
		@ ++r, 7 SAY '���⥦ �� �����:' get mBank reader ;
						{ | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) } ;
						valid { | g, o | controlSizeBox( g, o, oCheck, sizeFrame, sizeFrameBank, @buf ) }
	endif
	if getDrvFR():Change
		@ ++r, 7 say '�㬬� ��।����� ���⥫�騪�� (��� ������ ᤠ�)' ;
			get vnos_summa picture pict_cena ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
	endif
	If m1Bank == 1
		if  getDrvFR():EnableTypePay2()
			@ ++r, 7 say '�㬬�, ����� ������ (' +  Padr( getDrvFR():NameTypePay2(), 24 ) + ')' ;
				get paymentType2 picture pict_cena ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
		endif
		if  getDrvFR():EnableTypePay3()
			@ ++r, 7 say '�㬬�, ����� ������ (' +  Padr( getDrvFR():NameTypePay3(), 24 ) + ')' ;
				get paymentType3 picture pict_cena ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
		endif
		if  getDrvFR():EnableTypePay4()
			@ ++r, 7 say '�㬬�, ����� ������ (' +  Padr( getDrvFR():NameTypePay4(), 24 ) + ')' ;
				get paymentType4 picture pict_cena ;
					valid { | g | RecalcCheck( g, oCheck, .t. ) } 
		endif
	endif
	if getDrvFR():IsFiscalReg()
		@ ++r, 7 say 'E-mail ��� ����� ⥫�䮭� � �ଠ� +7XXXXXXXXXX' ;
				get maddress picture 'XXXXXXXXXXXXXXXXX' ;
				valid { | g | ControlAddress( g, maddress ) }
	endif
	status_key( '^<Esc>^ - ��室 ��� ����� 祪�;  ^<PgDn>^ - ������ 祪�' )
	return nil

* 27.06.17 - �஢�ઠ ���� ��� ⥫�䮭� �� �����⨬���� ��� ���
function ControlAddress( get, address )
	local ret := .f.
	
	address := alltrim( address )
	ret := hb_RegexLike( emailTemplate, address ) .or. hb_RegexLike( phoneTemplate, address ) .or. empty( address )
	if !ret
		hb_Alert( '�� ���� �ଠ� ⥫�䮭� ��� E-mail ����!', , , 4 )
	endif
	return ret

* 27.06.17 - �८�ࠧ������ ⥫�䮭���� ����� � ��ଠ��� �ଠ� ��� ���
function TransformPhone( address )

	address := alltrim( address )
	address := AtRepl( '-', address, '' )
	address := AtRepl( ' ', address, '' )
	address := AtRepl( '_', address, '' )
	address := AtRepl( '(', address, '' )
	address := AtRepl( ')', address, '' )
	address := AtRepl( ':', address, '' )
	address := AtRepl( '=', address, '' )
	address := AtRepl( '+', address, '' )
	if len( address ) == 10
		address := '+7' + address
	elseif len( address ) == 11
		if substr( address, 1, 1 ) != '7'
			address := '+7' + substr( address, 2 )
		else
			address := '+' + address
		endif
	else
		address := ''
	endif
	return address
	
* 03.11.17 - ������ ����� ����� � ���⥦�
function RecalcCheck( get, oCheck, lBank )
// lBank - ��ᨬ�� �㬬� .t. - ������᪮� ���⮩, .F. - �����묨

	if !lBank	 // �㬬� �����묨
		vnos_summa := round_5( vnos_summa, 2 )
		if ( vnos_summa < oCheck:Total )
			paymentType2 := round_5( oCheck:Total - vnos_summa - paymentType3 - paymentType4, 2 )
		else
			paymentType2 := 0
		endif
	else       // �㬬� ��������묨
		paymentType2 := round_5( paymentType2, 2 )
		paymentType3 := round_5( paymentType3, 2 )
		paymentType4 := round_5( paymentType4, 2 )
		if paymentType2 + paymentType3 + paymentType4 > oCheck:Total
			hwg_MsgInfoBay( '�㬬�, ���ᨬ�� ��������묨, �� ����� ���� ����� �㬬� � �����!', '�?����' )
			paymentType2 := oCheck:Total
		elseif ( paymentType2 > 0 ) .or. ( paymentType3 > 0 ) .or. ( paymentType4 > 0 )
			vnos_summa := round_5( oCheck:Total - paymentType2 - paymentType3 - paymentType4, 2 )
		else
			paymentType2 := 0
			paymentType3 := 0
			paymentType4 := 0
			if round_5( vnos_summa, 2 ) < oCheck:Total
				vnos_summa := oCheck:Total
			endif
		endif
	endif
	return update_gets()

* 03.11.17 - �뢮� ᮮ�饭�� � ����祭��� �������� �।�⢠�	
function IncomeCashBayerPay( oCheck, nStartRow, cBorderColor, cBoxColor )
// aMessage - ���ᨢ � ����묨
// cBorderColor - ��ப� 梥� ��� ࠬ��
// cBoxColor - ��ப� 梥� ��� ⥪��
// nStartRow - ���孨� �� ࠬ�� (99 - 業��஢���)
	local buf := savescreen()

	if oCheck:TotalBank > 0
		f_message( { '�㬬� �����묨: ' + str( oCheck:Cash, 10, 2 ), ;
			'�㬬� �� ���� : ' + str( oCheck:TotalBank, 10, 2 ), ;
			'�㬬� 祪�     : ' + str( oCheck:Total, 10, 2 ) }, , ;
			HB_DefaultValue( cBorderColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( cBoxColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( nStartRow, 99 ) )
			&& cBorderColor, cBoxColor, nStartRow )
	else
		f_message( { '���ᨬ�� �㬬�: ' + str( oCheck:Received, 10, 2 ), ;
			'�㬬� 祪�    : ' + str( oCheck:Total, 10, 2 ), ;
			'��������������������������', ;
			'�㬬� ᤠ�   : ' + str( Abs( oCheck:Total - oCheck:Received ), 10, 2 ) }, , ;
			HB_DefaultValue( cBorderColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( cBoxColor, 'W+/RB,W+/N,,,B/W' ), ;
			HB_DefaultValue( nStartRow, 99 ) )
			&& cBorderColor, cBoxColor, nStartRow )
	endif
	restscreen( buf )
	return nil

// 17.10.24 - ࠡ�� � 祪��
function printReceipt( oContract, nKey )

	local s := ''
	local strIn := '������ ����� 祪�: '
	local oCheck												// ��ꥪ� ��� 祪�
	local pict_chek := '999999'
	local buf := save_row( maxrow() )
	local item := nil, oService := nil
	local i, r, c, mas_pmt
	

	private ldate_op := date(), ltime_op := space( 5 ), lnchek := 0
	private lsum_voz := 0
	private lsum_voz_bank := 0

	do case
		case nKey == K_CTRL_F10
			if hb_user_curUser:IsAdmin()
				if  oContract:HasCheque .and. oContract:BackMoney > 0
					hb_Alert( '�� 祪� �� ������. ���⪠ ������ 祪� �� ��������!' )
				else
					if hwg_MsgNoYesBay( '���⢥न� ����� ������ �� ����� 祪��' )
						oContract:IsCashbox := 2
						oContract:ReceiptNumber := 0
						oContract:TotalBank := 0.0
						oContract:DateCashbox := ctod( '' )
						oContract:TimeCashBox := 0
						oContract:DatePay := ctod( '' )
						oContract:SerialNumberFR := ''
						oContract:Cashier := nil
						TContractDB():Save( oContract )
						hb_Alert( '������� ���ଠ�� �� ����� 祪��!' )
					endif
				endif
			else
				hb_Alert( '���⪠ ������ 祪� �������� ⮫쪮 ����������஬ ��⥬�!' )
			endif
		case nKey == K_CTRL_F12
			if oContract:HasCheque					// ������� �஡��� 祪
				hb_Alert( '�஡�� 祪.' + chr( 10 ) + '��������� �� ��������!', , , 4 )
			else
				mas_pmt := {}
				aadd( mas_pmt, '����� �����묨' )
				aadd( mas_pmt, '����' )
			
				i := 1
				r := maxrow() - len( mas_pmt ) - 4
				c := int( ( 80 - 3 ) / 2 )
				if ( i := popup_prompt( r, c, i, mas_pmt ) ) == 0
					return .t.
				endif
				oContract:IsCashbox := 1
				oContract:ReceiptNumber := 9999	//	oCheck:CheckNumber
				if i == 2
					oContract:TotalBank := oContract:Total //	 oCheck:TotalBank
				endif
				oContract:DateCashbox := oContract:BeginTreatment	//	oCheck:DateFR
				oContract:TimeCashBox := round_5( timetosec( Time() ), 0 )	//oCheck:TimeFR
				oContract:DatePay := oContract:BeginTreatment	//	oCheck:DateFR
				oContract:SerialNumberFR := 'CTRL_F12'	//	oCheck:SerialNumberFR
				oContract:Cashier := hb_user_curUser
				TContractDB():Save( oContract )
			endif
		case nKey == K_F10
			if oContract:HasCheque
				hb_Alert( '��� 㦥 �஡��', , , 4 )
			elseif empty( oContract:Services() )
				hb_Alert( '��� ��� � �������' )
			elseif !getDrvFR():IsFiscalReg
				hb_Alert( '�� �⮬ ࠡ�祬 ���� ��� �� ������祭�!' )
			elseif getDrvFR():IsFiscalReg .and. !empty( oContract:Services() ) .and. !oContract:HasCheque
				oCheck := TCheck():New( getDrvFR() )				// ��ꥪ� ��� 祪�
				oCheck:Sale()							// ��⠭���� 䫠� �த���
				oCheck:Patient := oContract:Patient			// ��⠭���� ��樥��
				for each item in oContract:Services()
					oService := TServiceOfCheck():New( item:Subdivision:ID, item:Service:Shifr, ;
								item:Service:NameToPOS, ;
								item:ExecuterFIO, ;
								( item:Total / item:Quantity ), item:Quantity, ;
								item:Service():CalculateNDS( oContract:Patient:IsAdult( item:Date )) )
					oCheck:AddService( oService )
				next
				if !empty( oContract:PayerFIO )
					oCheck:Payer := oContract:PayerFIO
					OCheck:PayerINN := oContract:PayerINN
				endif
				if yes_chek( oCheck )
					if oCheck:Print()
						oContract:IsCashbox := 1
						oContract:ReceiptNumber := oCheck:CheckNumber
						oContract:TotalBank := oCheck:TotalBank
						oContract:DateCashbox := oCheck:DateFR
						oContract:TimeCashBox := oCheck:TimeFR
						oContract:DatePay := oCheck:DateFR
						oContract:SerialNumberFR := oCheck:SerialNumberFR
						oContract:Cashier := hb_user_curUser
						TContractDB():Save( oContract )
					endif
				endif
			endif
		case nKey == K_CTRL_F8
			if hb_user_curUser:IsAdmin()
				if  oContract:HasCheque .and. oContract:BackMoney == 0
					hb_Alert( '�� 祪� �� �ந�������� ������ �����. ���⪠ ������ 祪� �� ��������!' )
				elseif  oContract:HasCheque .and. oContract:BackMoney > 0
					if hwg_MsgNoYesBay( '���⢥न� ����� ������ � ������ ������ 祪�' )
						oContract:TypeCashboxMoneyBack := 0
						oContract:DateBackMoney := ctod( '' )
						oContract:DateMoneyBack := ctod( '' )
						oContract:TimeMoneyBack := 0
						oContract:BackMoney := 0
						oContract:SerialNumberFRBack := ''
						oContract:CashierBack := ''
						TContractDB():Save( oContract )
						hb_Alert( '������� ���ଠ�� � ������!' )
					endif
				endif
			else
				hb_Alert( '���⪠ ������ �� 祪� �������� ⮫쪮 ����������஬ ��⥬�!' )
			endif
		case nKey == K_F8
			if oContract:BackMoney > 0
				hb_Alert( '������ ����� 㦥 �ந������!', , , 4 )
			elseif getDrvFR():IsFiscalReg .and. oContract:HasCheque .and. oContract:BackMoney == 0
				lsum_voz := oContract:Total - oContract:TotalBank
				lsum_voz_bank := oContract:TotalBank
				if oContract:TotalBank > 0
					s := ' \' + ;
						'      ���� �⮨����� ��� = ' + lput_kop( oContract:Total, .t. ) + ' ��.\' + ;
						'      ������ ����  ������  @           \' + ;
						'������ �㬬� ������ �� ���� @   \' + ;
						' \'
					DisplBox( s, , ;								// 梥� ���� (㬮��. - cDataCGet)
						{ 'ldate_op', 'lsum_voz_bank' }, ;	// ���ᨢ private-��६����� ��� ।���஢����
						{ , pict_cena }, ;				// ���ᨢ Picture ��� ।���஢����
						17 )
				else
					s := ' \' + ;
						'      ���� �⮨����� ��� = ' + lput_kop( oContract:Total, .t. ) + ' ��.\' + ;
						'      ������ ����  ������  @           \' + ;
						'      ������ �㬬� ������  @           \' + ;
						' \'
					DisplBox( s, , ;								// 梥� ���� (㬮��. - cDataCGet)
						{ 'ldate_op', 'lsum_voz' }, ;	// ���ᨢ private-��६����� ��� ।���஢����
						{ , pict_cena }, ;				// ���ᨢ Picture ��� ।���஢����
						17 )
				endif
				if lastkey() == K_ESC
					//
				elseif round( lsum_voz, 2 ) <= 0 .and. round( lsum_voz_bank, 2 ) <= 0
					mybell()
				elseif lsum_voz > oContract:Total - oContract:TotalBank
					hb_Alert( '�㬬� ������ ����� �⮨���� ���!', , , 4 )
				elseif lsum_voz_bank > oContract:TotalBank
					hb_Alert( '�㬬� ������ �� ���� ����� ������ �� ����', , , 4 )
				elseif f_Esc_Enter( iif( lsum_voz_bank > 0,'������ �� ���� ' + lput_kop( lsum_voz_bank, .t. ) + ' ��.', '������ ' + lput_kop( lsum_voz, .t. ) + ' ��.' ) )
					oCheck := TCheck():New( getDrvFR() )		// ��ꥪ� ��� 祪�
					oCheck:Refund()							// ��⠭���� 䫠� ������
					oCheck:Patient := oContract:Patient
					// ᮡ�६ ���� ������
					oService := TServiceOfCheck():New()
					oService:Name := '�������'
					oService:Section := 1				// ᥪ��
					oService:Quantity := 1
					oService:Price := iif( lsum_voz_bank > 0, lsum_voz_bank, lsum_voz )
					oCheck:AddService( oService )			// ������� ���� � 祪�
					if lsum_voz_bank > 0
						oCheck:PayType2 := lsum_voz_bank
					else
						oCheck:Cash := lsum_voz
					endif
					if oCheck:Print()
						oContract:TypeCashboxMoneyBack := 1
						oContract:DateBackMoney := oCheck:DateFR
						oContract:DateMoneyBack := oCheck:DateFR
						oContract:TimeMoneyBack := oCheck:TimeFR
						oContract:BackMoney := oCheck:Total
						oContract:SerialNumberFRBack := oCheck:SerialNumberFR
						oContract:CashierBack := hb_user_curUser
						TContractDB():Save( oContract )
						hb_Alert( '�㬬� ������ ����ᠭ�!', , , 4 )
					else
						hb_Alert( '�� �����ন������ � ⥪�饩 ���䨣��樨.', , , 4 )
					EndIf
				endif
			endif
		otherwise
	endcase
	return .t.

* 13.11.18 - ����� ����� 祪�, �᫨ ����
function printCopyReceipt( oContract )
	local namePatient := ''

	if ! getDrvFR():IsFiscalReg
		hb_Alert( '�� ࠡ�祬 ���� ��������� ������祭�� �᪠��� ॣ������. ����� ����� 祪� �� ��������!', , , 4 )
	elseif ! oContract:HasCheque
		hb_Alert( '� ������� ��������� 祪 �� �����. ����� ����� 祪� �� ��������!', , , 4 )
	elseif alltrim( oContract:SerialNumberFR ) != alltrim( getDrvFR():SerialNumber )
		hb_Alert( '��� ��� ������� ���⠫�� �� ��㣮� �᪠�쭮� ॣ������. ����� ����� 祪� �� ��������!', , , 4 )
	else
		if ! empty( oContract:PayerFIO )
			namePatient := '��樥��: '
			getDrvFR():FeedDocument( 1, 1 )
			if (ret := getDrvFR():PrintString( '���⥫�騪: ' + fam_i_o( oContract:PayerFIO ), , 1 ) )
				if !empty( oContract:PayerINN )
					ret := getDrvFR():PrintString( '��� ���⥫�騪�: ' + oContract:PayerINN, , 1 )
				endif
			endif
		endif
		namePatient := namePatient + lstr( oContract:Patient:ID ) + '  ' + fam_i_o( oContract:Patient:FIO )
		getDrvFR():FeedDocument( 1, 1 )
		getDrvFR():PrintString( namePatient, len( alltrim( namePatient ) ) < 20 )
		getDrvFR():FeedDocument( 1, 1 )
	
		getDrvFR():PrintCopyReceipt( oContract:ReceiptNumber )
	endif
	return .t.

function close_lu( param )

	hb_Alert( '�� ॠ��������' )
	return nil

* 26.06.17 - �-�� �����誠 ��� ᮢ���⨬���
function f_usl_date()

	hb_Alert( '�������' )
	return nil

