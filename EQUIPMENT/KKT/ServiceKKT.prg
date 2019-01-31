* 03.04.18 GetDateTimeKKT() - ������� ���� � �६� �� ���ᮢ��� ������ ��� GET-��	
* 22.06.17 SetupDate( typeKKT, dDate ) - ��⠭���� ���� � ���
* 03.04.18 PrintReport( flag ) - ����� X-���⮢ � Z-���⮢

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'ini.ch'

// ���� �ᯮ��㥬�� ���
#define KKT_NONE 1
#define KKT_OFF 2
#define KKT_SHTRIH 3

static str_Error := '������'
static str_Warning := '�� �����ন������ � ⥪�饩 ���䨣��樨.'

* 03.04.18 �����誠-�������⥫�
function f_empty()
	return nil

function ClearDrvFR()

	hb_kkt_drvFR := nil
	return nil

* 22.06.17 - ������� ���� � �६� �� �������� ��� GET-��	
function GetDateTimePC( get )

	mDateInKKT := Date()
	mTimeInKKT := Time()
	return update_gets()
	
* 02.04.18 - ��६���� ��� ࠡ��� � ���
function loadVariableKKT()

	public hb_kkt := nil									// ��६����� ��� �࠭���� ��뫪� �� �ࠩ��� ���

	public hb_kkt_oKKT := TSettingKKT():New( 'Workplace' )		// ��६����� ��� ����஥� ���
	public hb_kkt_drvFR := nil									// ��६����� ��� �࠭���� ��뫪� �� �ࠩ��� ���
	public hb_kkt_devMetrics := nil
	public hb_kkt_shortECRStatus := nil
	public hb_kkt_ECRStatus := nil
	public hb_kkt_FNStatus := nil
	public hb_kkt_passwordAdmin := 0
	public hb_kkt_lUserSet := .f.
	public hb_kkt_lIsEKLZ := .f.
	public hb_kkt_lIsFN := .f.
	public hb_kkt_lOpenSession := .f.
	public hb_kkt_serialNumber := ''

	return nil

* 03.04.18 - ������ ᢮��⢠ ��
function PropertiesFR()

	getDrvFR():ShowProperties()
	return nil

* 10.04.18 ��ନ஢��� 祪 ���४樨
* type - ��� ࠡ��� ( 0 - �த���, 1 - ���㯪� )
function BuildCorrectionReceipt( type )
	local mmType := { { 'ᠬ����⥫쭮', 1 }, { '�� �।��ᠭ��', 2 } }
	local summ1 := 0.0, summ2 := 0.0, summ3 := 0.0, summ4 := 0.0, summ5 := 0.0, summ6 := 0.0
	local docNum := 0, docDate := date(), docDescription := space( 100 )
	local strIn := '���४������ �㬬� �த���: '
	local strOut := '���४������ �㬬� ���㯪�: '
	local mpicture := '999999.99' , tmpString
	local oCorrection := TCorrectionCheck():New()
	
	local bufFull := savescreen()
	local j, fl := .f., tmp_color, buf, buf24, r := 10
	
	private mCorrectionType, m1CorrectionType := 1				// ���४�஢�� ᠬ����⥫쭮
	
	mCorrectionType := inieditspr( A__MENUVERT, mmType, m1CorrectionType )
	HB_Default( @type, 0 ) 
	
	tmp_color := setcolor( cDataCGet )
	buf24 := save_row( maxrow() )
	
	tmpString := iif( type == 0, strIn, strOut )
	oCorrection:CalculationSign := iif( type == 0, 1, 3 )
	&& buf := box_shadow( r, 5, r + 10, 74, , tmpString, color8 )
	buf := box_shadow( r, 5, r + 7, 74, , tmpString, color8 )
	do while .t.
		r := 10
		@ ++r, 7 SAY '��� ���४樨:' get mCorrectionType reader ;
					{ | x | menu_reader( x, mmType, A__MENUVERT, , , .f. ) }
		&& @ ++r, 7 say '�㬬� �� 祪�' get summ1 picture mpicture
		@ ++r, 7 say '�㬬� �� 祪� �����묨' get summ2 picture mpicture valid ( summ2 >= 0 )
		@ ++r, 7 say '�㬬� �� 祪� ���஭�묨' get summ3 picture mpicture valid ( summ3 >= 0 )
		&& @ ++r, 7 say '�㬬� �� 祪� �।����⮩' get summ4 picture mpicture valid ( summ4 >= 0 )
		&& @ ++r, 7 say '�㬬� �� 祪� ���⮯��⮩' get summ5 picture mpicture valid ( summ5 >= 0 )
		&& @ ++r, 7 say '�㬬� �� 祪� ������ �।�⠢������' get summ6 picture mpicture valid ( summ6 >= 0 )
		@ ++r, 7 say '����� ���㬥�� �᭮�����' get docNum
		@ ++r, 7 say '��� ���㬥�� �᭮�����' get docDate
		@ ++r, 7 say '���ᠭ�� ���㬥�� �᭮�����' get docDescription picture '@S37'
	
		status_key( '^<Esc>^ - ��室 ��� ����� 祪�;  ^<PgDn>^ - ������ 祪�' )
		myread()
		if lastkey() == K_ESC
			exit
		endif
		j := f_alert( { padc( '�롥�� ����⢨�', 60, '.' ) }, ;
			{ ' ��室 ��� ����� ',' ����� 祪� ', ' ������ � ।���஢���� ' }, ;
			iif( lastkey() == K_ESC, 1, 2 ), 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N,N/BG' )
		if j < 2
			exit
		elseif j == 3
			loop
		endif
		oCorrection:CorrectionType := m1CorrectionType - 1
		oCorrection:Summ1 := ( summ2 + summ3 + summ4 + summ5 + summ6 )
		oCorrection:Summ2 := summ2
		oCorrection:Summ3 := summ3
		oCorrection:Summ4 := summ4
		oCorrection:Summ5 := summ5
		oCorrection:Summ6 := summ6
		oCorrection:TaxType := 1
		oCorrection:DocNum := docNum
		oCorrection:DocDate := docDate
		oCorrection:DocDescription := docDescription
		getDrvFR():BuildCorrectionReceipt( oCorrection )
		exit
	enddo
	rest_box( buf )
	rest_box( buf24 )
	restscreen( bufFull )
	setcolor( tmp_color )
	oCorrection := nil
	return nil

* 03.04.18 - ����� X-���⮢ � Z-���⮢
*  flag  - 0 - ���� ��� ��襭��, 1 - ���� � ��襭���
function PrintReport( flag )
	local ret := .f., regim, strTitle := '���⨥ ����', strNone, strCloseReport, strOk
	
	strOk := '���⨥ ���筮�� ���� ' + iif( flag == 0, '��� ��襭�� ', '� ��襭��� ' ) + '�믮�����'
	strNone := '�� �ந��諮 ��⨥ ���筮�� ���� ' + iif( flag == 0, '��� ��襭��', '� ��襭���' )
	strCloseReport := '������� ᬥ��.' + chr( 13 ) + chr( 10 ) + '���⨥ ���� � ��襭��� ����������!'
	if ret_fsytotch( flag )
		if ( iif( flag == 1, getDrvFR():PrintReportWithCleaning(), getDrvFR():PrintReportWithoutCleaning() ) )
			hwg_MsgInfoBay( strOk, strTitle )
		else
			hwg_MsgInfoBay( strNone, strTitle )
		endif
	endif
	return nil

*****
function ret_fsytotch( tip )
	local strTitle := '���⨥ ����', str
	str := 'C��⨥ ���筮�� ����' + if( tip==0, ' ��� ��襭��.', ' � ��襭���.' )
	return if( hwg_MsgNoYesBay( str, strTitle ), .t., .f. )

* 03.04.18 - ������� ���� � �६� �� ���ᮢ��� ������ ��� GET-��	
function GetDateTimeKKT()

	tempDate := getDrvFR():GetDate()
	tempTime := hb_TToC( getDrvFR():GetTime(), '', 'hh:mm:ss' )	// ��ॢ���� �� datetime � string
	return nil

* 22.06.17 - ��⠭���� ���� � ���
function SetupDate( dDate )
	local ret := .f.

	if ( ret := getDrvFR():SetDate( dDate ) )
		hwg_MsgInfoBay( '��� � �� ��������!', '������� �믮�����!' ) 
		getDrvFR():Beep()
	else
		hwg_MsgInfoBay( str_Warning, str_Error )
	endif
	return nil

* 03.04.18 - ��⠭���� �६��� � ���
function SetupTime( cTime )	
	local ret := .f.

	if ( ret := getDrvFR():SetTime( cTime) )
		hwg_MsgInfoBay( '�६� � �� ��������!', '������� �믮�����!' )
		getDrvFR():Beep()
	else
		hwg_MsgInfoBay( str_Warning, str_Error )
	endif
	return nil

function getDrvFR()
	return hb_kkt

* 21.06.17 - ������ ����ன�� ���
function getSetKKT()
	
	return hb_kkt_oKKT

* 02.04.2018 ��ࢨ筠� ���樠������ �ࠩ��� �᪠�쭮�� ॣ������
function InitDriverFR()
	
	checkDriverFR()
	return nil

* 04.04.18 - ᮧ���� (�����頥�) ��ꥪ� �ࠩ��� �᪠�쭮�� ॣ������
function checkDriverFR()
	local exchangeStatus, messageStatus, messageCount, documentNumber, dateDoc, timeDoc
	local strMessage := ''
	local nameKKT := ''
	local typeKKT := GetSetKKT():TypeKKT
	local aDrvDescription := { ;
								{ '', '���', 0, 0, 0, 0 }, ;
								{ '', '���', 0, 0, 0, 0 }, ;
								{ 'AddIn.DrvFr', '�ࠩ��� ����-�', 4, 13, 0, 527 } ;
							}
	local ret := .f.
	local oSettings := nil
	local oKKT := nil, obj := nil
	local aDriver := { ;
						{ TKKT_None(), '', '���' }, ;
						{ TKKT_None(), '', '���' }, ;
						{ TKKT_Shtrih(), 'AddIn.DrvFr', '�ࠩ��� ����-�' } ;
					}

	if getDrvFR() == nil
		oSettings := TSettingKKT():New( 'Workplace' )
		oKKT :=TServiceKKT():New()
		obj := aDriver[ oSettings:TypeKKT, 1 ]:New()
		oKKT:SetKKT( obj )
		oKKT:Init()
		oKKT:Open( oSettings, hb_user_curUser:PasswordFR() )
		oKKT:SetOperatorKKT( hb_user_curUser:PasswordFR, alltrim( hb_user_curUser:FIO ) )
		hb_kkt := oKKT
		hb_kkt:CheckExchangeStatus( .f. )
		ret := .t.
	endif
	return ret

* 22.06.17 - �������� ���� GET ��� ���� � �६���	
function UpdateDateTime( get )

	if tempDate == nil
		return .t.
	else
		mDateInKKT := tempDate
		mTimeInKKT := tempTime
	endif
	return update_gets()

***** ���ᥭ�� � �믫�� �� �����
* type - ��� ࠡ��� (.t. - ���ᥭ��, .f. - �믫��)
function CashInOut( type )
	local summa := 0, strIn := '���ᨬ�� �㬬�: ', strOut := '�㬬� ��� �믫���: '
	local colBegin := 0, colEnd := 0, mpicture := '99999.99' , tmpString
	
	HB_Default( @type, .t. ) 
	tmpString := iif( type, strIn, strOut )
	colBegin := Int( ( 80 - Len( tmpString ) - Len( mpicture ) - 2) / 2 )
	colEnd := colBegin + Len( tmpString ) + 12
	if (summa := input_value( 18, colBegin, 20, colEnd, color1, ;
					tmpString, 0.0, mpicture ) ) != nil .and. summa > 0
		if type
			getDrvFR():CashIncome( summa )
		else
			getDrvFR():CashOutcome( summa )
		endif
	endif
	return nil

* 22.06.17 - �����頥� .t. �᫨ ��।���� ��ࠬ��� 㪠�뢠�� �� �ਬ������ �᪠�쭮�� ॣ������
function isFiscalReg( param )
	return param != KKT_OFF .and. param != KKT_NONE

* 31.01.19 - ����ன�� ���ᮢ��� ������
function SetupKKT()
	static mm_da_net := { { '�� ', 1 }, { '���', 2 } }
	static mmTypeKKT := { { '�� �ᯮ�짮���� ���     ', KKT_NONE }, ;
						{ '��� off-Line            ', KKT_OFF }, ;
						{ '��� ����-�: �ࠩ��� �� ', KKT_SHTRIH } }
	static cgreen := 'G+/B'											// 梥� ��� ��⮪
	local buf
	
	
	***************
	buf := box_shadow( 1, 0, 22, 78, 'B+/B' )
	//	private mtest := '�����', m1test := 0
	private mtypeKKT, m1typeKKT := getSetKKT():TypeKKT	// ()
	private mpassAdmin := getSetKKT():AdminPass
	private mnumPOS := getSetKKT():NumPOS
	private mnamePOS := getSetKKT():NamePOS
	private mFabricNumber := iif( Empty( getSetKKT():FRNumber ), space( 16 ), getSetKKT():FRNumber )
	private mDateInKKT := Date()
	private mTimeInKKT := Time()
	private mnkassa := '�����', m1nkassa
	private mSetDate := '��⠭�����', m1SetDate
	private mSetTime := '��⠭�����', m1SetTime
	private mGetFromKKT := '������� �� ���', m1GetFromKKT
	private mGetFromPC := '������� �� �� ', m1GetFromPC
	private mopenDrawer, m1openDrawer := iif( getSetKKT():OpenADrawer, 1, 2 )
	private mprintDoctor, m1printDoctor := iif( getSetKKT():PrintDoctor, 1, 2 )
	private mprintPatient, m1printPatient := iif( getSetKKT():PrintPatient, 1, 2 )
	private mchangeEnable, m1changeEnable := iif( getSetKKT():ChangeEnable, 1, 2 )
	private mchangePrint, m1changePrint := iif( getSetKKT():ChangePrint, 1, 2 )
	private mshifrUslPrint, m1shifrUslPrint := iif( getSetKKT():PrintCodeUsl, 1, 2 )
	private mnameUslPrint, m1nameUslPrint := iif( getSetKKT():PrintNameUsl, 1, 2 )
	private mvid2Enable, m1vid2Enable := iif( getSetKKT():EnableTypePay2, 1, 2 )
	private mvid3Enable, m1vid3Enable := iif( getSetKKT():EnableTypePay3, 1, 2 )
	private mvid4Enable, m1vid4Enable := iif( getSetKKT():EnableTypePay4, 1, 2 )
	private mnVid2Name := iif( Empty( getSetKKT():NameTypePay2 ), space( 24 ), getSetKKT():NameTypePay2 )
	private mnVid3Name := iif( Empty( getSetKKT():NameTypePay3 ), space( 24 ), getSetKKT():NameTypePay3 )
	private mnVid4Name := iif( Empty( getSetKKT():NameTypePay4 ), space( 24 ), getSetKKT():NameTypePay4 )
	
	mtypeKKT := inieditspr( A__MENUVERT, mmTypeKKT, m1typeKKT )
	mopenDrawer := inieditspr( A__MENUVERT, mm_da_net, m1openDrawer )
	mprintDoctor := inieditspr( A__MENUVERT, mm_da_net, m1printDoctor )
	mprintPatient := inieditspr( A__MENUVERT, mm_da_net, m1printPatient )
	mchangeEnable := inieditspr( A__MENUVERT, mm_da_net, m1changeEnable )
	mchangePrint := inieditspr( A__MENUVERT, mm_da_net, m1changePrint )
	mshifrUslPrint := inieditspr( A__MENUVERT, mm_da_net, m1shifrUslPrint )
	mnameUslPrint := inieditspr( A__MENUVERT, mm_da_net, m1nameUslPrint )
	mvid2Enable := inieditspr( A__MENUVERT, mm_da_net, m1vid2Enable )
	mvid3Enable := inieditspr( A__MENUVERT, mm_da_net, m1vid3Enable )
	mvid4Enable := inieditspr( A__MENUVERT, mm_da_net, m1vid4Enable )
	setcolor(cDataCGet)
	ix := 1
	ClrLines( 1, maxrow() - 1 )
	// �롮� ���� ���ᮢ��� ������
	@ ix, 2 SAY '��騥:' color cgreen
	@ ++ix, 2 say '����� � ���: ' get mtypeKKT ;
		reader { | x | menu_reader( x, mmTypeKKT, A__MENUVERT, , , .f. ) }
	if m1typeKKT != KKT_NONE
		@ ++ix, 2 say '����� �����: ' get mnumPOS  pict '999'
	endif
	if isFiscalReg( m1typeKKT )
		@ ix, 22 say '�������� �����: ' get mnamePOS picture 'XXXXXXXXXXXXXXXXXXXXXXXX' when isFiscalReg( m1typeKKT ) //m1typeKKT == KKT_SHTRIH
	elseif m1typeKKT == KKT_OFF
		@ ix, 22 say '�����᪮� ����� ���: ' get mFabricNumber picture 'XXXXXXXXXXXXXXXX' when m1typeKKT == KKT_OFF
	endif
	// ����ன�� ���ᮢ��� ������
	if isFiscalReg( m1typeKKT )
		@ ++ix, 2 SAY '���⥬�� ��ࠬ����:' color cgreen
	endif
	if isFiscalReg( m1typeKKT )
		@ ++ix, 2 SAY '�ࠩ��� ��⠭�����:'
		@ ix, col() + 1 SAY if( getDrvFR():Driver != nil, '��', '���' ) color 'R/B+'
		if getDrvFR():Driver != nil
			@ ix, col() + 1 SAY '����� �ࠩ���:'
			do case
			case m1typeKKT == KKT_SHTRIH
				@ ix, col() + 1 SAY getDrvFR():Version	color 'R/B+'
			endcase
			@ ++ix, 2 say '����ன�� �ࠩ��� ...' get mnkassa ;
				reader { | x | menu_reader( x, { { || PropertiesFR() } }, A__FUNCTION, , , .f. ) }
		else
			++ix
		endif
		@ ++ix, 2 say '��஫� ��⥬���� �����������: ' get mpassAdmin  pict '99'
		@ ++ix, 2 say '���뢠�� ������� �騪 �� ��砫� ����?' get mopenDrawer ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , ,.f. ) }
		// ��� � �६�
		@ ++ix, 2 SAY '��� � �६�:' color cgreen
		@ ++ix, 2 say '���:  ' get mDateInKKT picture '99.99.9999'
		private tempDate := nil, tempTime := nil			// ��� ���������� GET-��
		if getDrvFR() != nil
			@ ix, 20 say ' ' get mGetFromKKT ;
				reader { | x | menu_reader( x, { { || GetDateTimeKKT() } }, A__FUNCTION, , , .f. ) } ;
				valid { | g | UpdateDateTime( g ) }
			@ ix, 37 say ' ' get mSetDate ;
				reader { | x | menu_reader( x, { { || SetupDate( mDateInKKT ) } }, A__FUNCTION, , , .f. ) }
		endif
		@ ++ix, 2 say '�६�: ' get mTimeInKKT picture '99:99:99' when isFiscalReg( m1typeKKT )
		if getDrvFR() != nil
			@ ix, 20 say ' ' get mGetFromPC ;
				reader { | x | menu_reader(x,{{ || f_empty() } }, A__FUNCTION, , , .f. ) } ;
				valid { | g | GetDateTimePC( g ) }
			@ ix, 37 say ' ' get mSetTime ;
				reader { | x | menu_reader( x, { { || SetupTime( m1typeKKT, mTimeInKKT ) } }, A__FUNCTION, , , .f. ) }
		endif
		// ����� � ������ �����
		@ ++ix, 2 SAY '���� ������:' color cgreen
		@ ++ix, 2 say '������� ��� ������ � 2' get mvid2Enable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ix, 31 say '�������� ���� ������ �2' get mnVid2Name  pict 'XXXXXXXXXXXXXXXXXXXXXXX'
		@ ++ix, 2 say '������� ��� ������ � 3' get mvid3Enable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ix, 31 say '�������� ���� ������ �3' get mnVid3Name  pict 'XXXXXXXXXXXXXXXXXXXXXXX'
		@ ++ix, 2 say '������� ��� ������ � 4' get mvid4Enable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ix, 31 say '�������� ���� ������ �4' get mnVid4Name  pict 'XXXXXXXXXXXXXXXXXXXXXXX'
		// ���譨� ��� 祪� ���		
		@ ++ix, 2 SAY '��� 祪�:' color cgreen
		@ ++ix, 2 say '����� ���ᨬ�� �㬬� � ������� ᤠ�?' get mchangeEnable ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say '����� ���ᨬ�� �㬬� � ᤠ� � 祪�?' get mchangePrint ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) } when m1changeEnable == 1
		@ ++ix, 2 say '����� ��� ��� ������襣� ���� � 祪�?' get mprintDoctor ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say '����� ��� ��樥��/���⥫�騪� � 祪�?' get mprintPatient ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say '����� ��� ��㣨?' get mshifrUslPrint ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
		@ ++ix, 2 say '����� ������������ ��㣨?' get mnameUslPrint ;
			reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , , .f. ) }
	endif
	status_key( '^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����' )
	myread()
	if lastkey() == K_ESC
		rest_box( buf )
		return nil
	endif
	if f_Esc_Enter( 1 )
		getSetKKT():TypeKKT := m1typeKKT
		getSetKKT():NumPOS := mnumPOS
		getSetKKT():NamePOS := mnamePOS
		getSetKKT():AdminPass := mpassAdmin
		getSetKKT():OpenADrawer := iif( m1openDrawer == 2, .f., .t. )
		getSetKKT():PrintDoctor := iif( m1printDoctor == 2, .f., .t. )
		getSetKKT():PrintPatient := iif( m1printPatient == 2, .f., .t. )
		getSetKKT():ChangeEnable := iif( m1changeEnable == 2, .f., .t. )
		getSetKKT():ChangePrint := iif( m1changePrint == 2, .f., .t. )
		getSetKKT():PrintCodeUsl := iif( m1shifrUslPrint == 2, .f., .t. )
		getSetKKT():PrintNameUsl := iif( m1nameUslPrint == 2, .f., .t. )
		
		getSetKKT():EnableTypePay2 := iif( m1vid2Enable == 2, .f., .t. )
		if empty( alltrim( mnVid2Name ) )
			mnVid2Name := '������ ���'
		endif
		getSetKKT():NameTypePay2:= mnVid2Name
		getSetKKT():EnableTypePay3 := iif( m1vid3Enable == 2, .f., .t. )
		getSetKKT():NameTypePay3 := mnVid3Name
		getSetKKT():EnableTypePay4 := iif( m1vid4Enable == 2, .f., .t. )
		getSetKKT():NameTypePay4 := mnVid4Name
		getSetKKT():FRNumber := mFabricNumber
		getSetKKT():Save()
		ClearDrvFR()
		loadVariableKKT()
		InitDriverFR()
	endif
	rest_box( buf )
	return nil

* 28.07.17 - ������� ���ଠ�� �� �訡�� �����
function WriteErrKassa( info )
	local _tmp := ''		//, i, t_arr[ 2 ], ar := { '' }
	// local item:= nil
	local oLog := tIPLogLocal():New( dir_server + GetSetKKT():NameFileLogError )
	local typeKKT := GetSetKKT():TypeKKT
	local numPOS := getSetKKT():NumPOS
	local namePOS := getSetKKT():NamePOS

	if GetSetKKT():LogError
		// bTrace := { |cMsg| iif( pcount() > 0, oLog:Add( cMsg ), oLog:Close() ) }
		oLog:lLogAdditive    := .t.      						// Log to a single file
		oLog:nLogFileMaxSize := GetSetKKT():SizeFileLogError	// Create a new file after 10MB
		oLog:lLogCredentials := .f.								// Do not log username/password
		oLog:InsertDivider()									// A divider between log items
		// aadd( ar, info )
		if typeKKT == KKT_SHTRIH
			_tmp += '�ࠩ��� ����-�, �����:' + alltrim( getDrvFR():DriverVersion ) + chr( 13 ) + chr( 10 )
		else
			_tmp += '�� ������� �ࠩ��� �᪠�쭮�� ॣ������' + chr( 13 ) + chr( 10 )
		endif
		_tmp += '���� � ' + alltrim( str( numPOS ) ) + '. ��������: ' + alltrim( namePOS )
		_tmp += chr( 13 ) + chr( 10 )
		if type( 'fio_polzovat' ) == 'C' .and. !empty( fio_polzovat )
			_tmp += '�����: ' + alltrim( hb_user_curUser:Name )
		endif
		if type( 'p_name_comp' ) == 'C' .and. !empty( p_name_comp )
			_tmp += '. ��ᯮ������� ��: ' + alltrim( p_name_comp )
		endif
		_tmp += chr( 13 ) + chr( 10 )
		// for Each item in ar
			// if !empty( item )
				// _tmp += item + chr( 13 ) + chr( 10 )
			// endif
		// next
		_tmp += info + chr( 13 ) + chr( 10 )
		oLog:Add( _tmp )
		oLog:Close()
	endif
	return nil

***** 04.04.18
function ContinuePrintAfterError()
//  �த������� ����
	local strTitle := '�த������� ����', strOk, strNone
		
	strOk := '������� �믮�����'
	strNone := '�� �ந��諮 �த������� ����'
	if getDrvFR():ContinuePrint()
		hwg_MsgInfoBay( strOk, strTitle )
	else
		hwg_MsgInfoBay( strNone, strTitle )
	endif
	return nil

***** 04.04.18
function CancelCheck()
//  ���㫨஢���� 祪�
	local strTitle := '�⬥�� 祪�', strOk, strNone
		
	strOk := '������� �믮�����'
	strNone := '�� �ந��諮 �⬥�� 祪�'
	if getDrvFR():CancelCheck()
		hwg_MsgInfoBay( strOk, strTitle )
	else
		hwg_MsgInfoBay( strNone, strTitle )
	endif
	return nil
