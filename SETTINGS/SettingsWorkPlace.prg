#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// ���� �ᯮ��㥬�� ���
#define KKT_NONE 1
#define KKT_OFF 2
#define KKT_SHTRIH 3

function settingsWorkPlace()
	local si1 := 1
	local mas_pmt := {}, mas_msg := {}, mas_fun := {}
	
	aadd( mas_pmt, '~������砥��� ����㤮�����' )
	aadd( mas_msg, '����ன�� ������砥���� ����㤮�����' )
	aadd( mas_fun, 'addedEquipment()' )
	//
	aadd( mas_pmt, '~����ன�� ���祭�� �� 㬮�砭��' )
	aadd( mas_msg, '����ன�� ���祭�� �� 㬮�砭�� �� ࠡ�祬 ����' )
	aadd( mas_fun, 'nastr_rab_mesto()' )

	popup_prompt( T_ROW, T_COL - 30, si1, mas_pmt, mas_msg, mas_fun )
	return nil

* 31.01.19 ������祭��� ���譥� ����㤮�����
function addedEquipment()
	local cgreen := 'G+/B'											// 梥� ��� ��⮪
	local mmComPort := {}, i := 0
	local mmSmartCard := {}
	local mmTypeKKT := { { '�� �ᯮ�짮���� ���     ', KKT_NONE }, ;
						{ '��� off-Line            ', KKT_OFF }, ;
						{ '��� ����-�: �ࠩ��� �� ', KKT_SHTRIH } }
	local hb_kkt_Equipment := TSettingEquipment():New( 'Equipment' )		// ��६����� ��� ����஥� ����㤮�����
	local nComBaudRate := hb_kkt_Equipment:ComPortBaudRate
	local nComDataBits := hb_kkt_Equipment:ComPortDataBits
	local cComParity := hb_kkt_Equipment:ComPortParity
	local iFind := 0, iCount := 0, item, oBox
	
	private mnkassa := '����ன��', m1nkassa
	private mComSet := '����ன��', m1ComSet
	private mtypeKKT, m1typeKKT := hb_kkt_Equipment:TypeKKT
	private mComPort, m1ComPort, cComPort := hb_kkt_Equipment:ComPort
	private mSmartCard, m1SmartCard, cSmartCard := hb_kkt_Equipment:SCReader

	for each item in getListCOMPorts()
		aadd( mmComPort, { item, ++i } )
	next
	i := 0 // ���㫨� ���稪
	for each item in getListSmartCards()
		aadd( mmSmartCard, { item, ++i } )
	next
	
	oBox := TBox():New( 1, 0, 22, 78, .t. )
	oBox:Caption := '����ன�� ������砥���� ����㤮�����'
	oBox:CaptionColor := color8
	oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����'
	oBox:Color := cDataCGet
	oBox:View()
	
	for each item in mmComPort
		iCount++
		if alltrim( item[ 1 ] ) == alltrim( cComPort )
			iFind := iCount
			exit
		endif
	next
	m1ComPort := if( iFind == 0, 1, iFind )
	mComPort := inieditspr( A__MENUVERT, mmComPort, m1ComPort )
	
	iFind := 0
	iCount := 0
	for each item in mmSmartCard
		iCount++
		if alltrim( item[ 1 ] ) == alltrim( cSmartCard )
			iFind := iCount
			exit
		endif
	next
	m1SmartCard := if( iFind == 0, 1, iFind )
	mSmartCard := inieditspr( A__MENUVERT, mmSmartCard, m1SmartCard )
	
	mtypeKKT := inieditspr( A__MENUVERT, mmTypeKKT, m1typeKKT )
	// ����㧨� ����ன�� ��� ���
	loadVariableKKT()
	if m1typeKKT != KKT_NONE .and. m1typeKKT != KKT_OFF
		// ���樠�����㥬 �ࠩ���
		InitDriverFR()
	endif
	
	ix := 2
	// �롮� ��᫥����⥫쭮�� ���� � ���஬� ������祭 ᪠��� ����-����
	@ ix, 2 say '������ ����-����:' color cgreen
	@ ++ix, 3 say '����: ' get mComPort ;
		reader { | x | menu_reader( x, mmComPort, A__MENUVERT, , , .f. ) }
	if lower( mComPort ) != '���'
		@ ix, col() + 1 say '����ன�� COM ...' get mComSet ;
			reader { | x | menu_reader( x, { { || SetComPort( @nComBaudRate, @nComDataBits, @cComParity ) } }, A__FUNCTION, , , .f. ) }
	endif
	@ ++ix, 2 say '���ன�⢮ �⥭�� ᬠ��-����:' color cgreen
	@ ++ix, 3 say '���: ' get mSmartCard ;
		reader { | x | menu_reader( x, mmSmartCard, A__MENUVERT, , , .f. ) }
	@ ++ix, 2 say '����஫쭮-���ᮢ�� �孨��:' color cgreen
	@ ++ix, 3 say '��� ���: ' get mtypeKKT ;
		reader { | x | menu_reader( x, mmTypeKKT, A__MENUVERT, , , .f. ) }
	// ����ன�� ���ᮢ��� ������
	if isFiscalReg( m1typeKKT )
		@ ++ix, 3 say '���⥬�� ��ࠬ����:' color cgreen
		@ ++ix, 4 say '�ࠩ��� ��⠭�����:'
		@ ix, col() + 1 SAY if( getDrvFR():Driver != nil, '��', '���' ) color 'R/B+'
		if getDrvFR():Driver != nil
			@ ix, col() + 1 SAY '����� �ࠩ���:'
			if m1typeKKT == KKT_SHTRIH
				@ ix, col() + 1 SAY getDrvFR():Version	color 'R/B+'
			else
			endif
			@ ++ix, 4 say '����ன�� �ࠩ��� ...' get mnkassa ;
				reader { | x | menu_reader( x, { { || PropertiesFR() } }, A__FUNCTION, , , .f. ) }
		endif
	endif
	myread()

	if f_Esc_Enter( 1 )
		hb_kkt_Equipment:TypeKKT := m1typeKKT
		hb_kkt_Equipment:ComPort := mmComPort[ m1ComPort, 1 ]
		hb_kkt_Equipment:ComPortBaudRate := nComBaudRate
		hb_kkt_Equipment:ComPortDataBits := nComDataBits
		hb_kkt_Equipment:ComPortParity := cComParity
		hb_kkt_Equipment:SCReader := mmSmartCard[ m1SmartCard, 1 ]
		hb_kkt_Equipment:Save()
	endif
	 oBox := nil
	return nil
	
function SetComPort( /*@*/nBaudRate, /*@*/nDataBits, /*@*/cParity )
	local oBox
	&& local mmBaudRate := { ;
						&& { '75    ', 1 }, { '110   ', 2 }, { '134   ', 3 }, { '150   ', 4 }, { '300   ', 5 }, { '300   ', 6 }, ;
						&& { '1200  ', 7 }, { '1800  ', 8 }, { '1800  ', 9 }, { '1800  ', 10 }, { '2400  ', 11 }, { '7200  ', 12 }, ;
						&& { '9600  ', 13 }, { '14400 ', 14 }, { '19200 ', 15 }, { '38400 ', 16 }, { '19200 ', 17 }, { '38400 ', 18 }, ;
						&& { '57600 ', 19 }, { '115200', 20 }, { '128000', 21 } ;
						&& }
	local mmDataBits := { { '4', 1 }, { '5', 2 }, { '6', 3 }, { '7', 4 }, { '8', 5 }	}
	local mmParity := { { '���   ', 1 }, { '���� ', 2 }, { '���  ', 3 }, { '��થ�', 4 }, { '�஡��', 5 }	}
	local iRow := 5
	local iFind, item

	private mBaudRate, m1BaudRate
	private mDataBits, m1DataBits
	private mParity, m1Parity
	
	&& iFind := hb_ascan( mmBaudRate, { | row | alltrim( row[ 1 ] ) == alltrim( str( nBaudRate ) ) } )
	iFind := hb_ascan( TComDescription():aMenuBaudRate, { | row | alltrim( row[ 1 ] ) == alltrim( str( nBaudRate ) ) } )
	m1BaudRate := if( iFind == 0, 13, iFind )
	&& mBaudRate := inieditspr( A__MENUVERT, mmBaudRate, m1BaudRate )
	mBaudRate := inieditspr( A__MENUVERT, TComDescription():aMenuBaudRate, m1BaudRate )

	iFind := hb_ascan( mmDataBits, { | row | alltrim( row[ 1 ] ) == alltrim( str( nDataBits ) ) } )
	m1DataBits := if( iFind == 0, 5, iFind )
	mDataBits := inieditspr( A__MENUVERT, mmDataBits, m1DataBits )

	iFind := hb_ascan( mmParity, { | row | lower( alltrim( row[ 1 ] ) ) == lower( alltrim( str( nDataBits ) ) ) } )
	m1Parity := if( iFind == 0, 3, iFind )
	mParity := inieditspr( A__MENUVERT, mmParity, m1Parity )

	oBox := TBox():New( 5, 10, 15, 68, .t. )
	oBox:Caption := '����ன�� COM ����'
	oBox:CaptionColor := color8
	oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����'
	oBox:Color := cDataCGet
	oBox:View()

	@ ++iRow, 12 say '��� � ᥪ㭤�: ' get mBaudRate ;
		reader { | x | menu_reader( x, TComDescription():aMenuBaudRate, A__MENUVERT, , , .f. ) }
		&& reader { | x | menu_reader( x, mmBaudRate, A__MENUVERT, , , .f. ) }
	@ ++iRow, 12 say '���� ������: ' get mDataBits ;
		reader { | x | menu_reader( x, mmDataBits, A__MENUVERT, , , .f. ) }
	@ ++iRow, 12 say '��⭮���: ' get mParity ;
		reader { | x | menu_reader( x, mmParity, A__MENUVERT, , , .f. ) }
	myread()
	
	if f_Esc_Enter( 1 )
		&& nBaudRate := val( mmBaudRate[ m1BaudRate, 1 ] )
		nBaudRate := val( TComDescription():aMenuBaudRate[ m1BaudRate, 1 ] )
		nDataBits := val( mmDataBits[ m1DataBits, 1 ] )
		cParity := mmParity[ m1Parity, 1 ]
	endif
	return nil