#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

function settingsWorkPlace( r, c )
	local mas_pmt := { '~������砥��� ����㤮�����', ;
			'~����ன�� ���祭�� �� 㬮�砭��' }
	local mas_msg := { '����ன�� ������砥���� ����㤮�����', ;
			'����ன�� ���祭�� �� 㬮�砭�� �� ࠡ�祬 ����' }
	local mas_fun := { 'addedEquipment()', ;
			'nastr_rab_mesto()' }
			
	local sItem
	
	&& DEFAULT r TO T_ROW, c TO T_COL + 5
	&& DEFAULT r TO T_ROW, c TO T_COL - 20
	HB_Default( @r, T_ROW ) 
	HB_Default( @c, T_COL - 20 ) 

	sItem := popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
alertx(sItem)
	return nil

* 29.01.19
function addedEquipment()
	static cgreen := 'G+/B'											// 梥� ��� ��⮪
	static group_ini := 'RAB_MESTO'
	
	local ar, sr
	local hb_kkt_Equipment := TSettingEquipment():New( 'Workplace' )		// ��६����� ��� ����஥� ����㤮�����
	local iFind := 0, iCount := 0, item, oBox
	local mmComPort := {}, i := 0
	
	private mComPort, m1ComPort, cComPort := hb_kkt_Equipment:ComPort	// ()
	private mm_reader := { { '���', space( 50 ) }, { '���������', '1' } }, m1m_reader
	
	for each item in getListCOMPorts()
		aadd( mmComPort, { item, ++i } )
	next
	
	ar := GetIniSect( tmp_ini, group_ini )
	sr := a2default( ar, 'sc_reader' )
	if ! empty( sr )
		mm_reader[ 2, 1 ] := sr
		mm_reader[ 2, 2 ] := padr( sr, 50 )
	endif
	
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
	
	ix := 2
	// �롮� ��᫥����⥫쭮�� ���� � ���஬� ������祭 ᪠��� ����-����
	@ ix, 2 SAY '������ ����-����:' color cgreen
	@ ++ix, 2 say '����: ' get mComPort ;
		reader { | x | menu_reader( x, mmComPort, A__MENUVERT ) }
	@ ++ix, 2 SAY '���ன�⢮ �⥭�� ᬠ��-����:' color cgreen
	@ ++ix, 2 say '���: ' get mm_reader ;
		reader { | x | menu_reader( x, mm_reader, A__MENUVERT ) }

	myread()
	&& read
	&& if lastkey() != K_ESC .and. f_Esc_Enter( 1 )
	if f_Esc_Enter( 1 )
		hb_kkt_Equipment:ComPort := mmComPort[ m1ComPort, 1 ]
		hb_kkt_Equipment:Save()
	endif
	return nil

* 29.01.19
function addedEquipment1()
	static group_ini := "RAB_MESTO"
	&& static mm_wdir := {{'� ����� ࠡ�祣� ��⠫��� "OwnChipArchiv"',0},;
					&& {"� ��㣮� ����",1}}
	&& static mm_wokato := {{'�ᯮ�짮���� ���祭�� �� "���� ����஥�"',0},;
						&& {"᢮� ����ன�� �� ������ ࠡ�祬 ����",1}}
	local ar, sr, mm_tmp := {}
	
	delete file tmp.dbf
	//
	private mm_reader := {{"���",space(50)},{"���������","1"}}
	&& private mm_oms_pole := {"�ப� ��祭��",;    //  1
							&& "���.���",;         //  2
							&& "��.�������",;      //  3
							&& "��䨫�",;          //  4
							&& "१����",;        //  5
							&& "��室",;            //  6
							&& "����� ���饭��",;  //  7
							&& "ᯮᮡ ������"}     //  8
	ar := GetIniSect( tmp_ini, group_ini )
	sr := a2default( ar, 'sc_reader' )
	if ! empty( sr )
		mm_reader[ 2, 1 ] := sr
		mm_reader[ 2, 2 ] := padr( sr, 50 )
	endif
	aadd( mm_tmp, { 'sc_reader', 'C', 50, 0, nil, ;
				{ | x | menu_reader( x, mm_reader, A__MENUVERT ) }, ;
				'', { | x | inieditspr( A__MENUVERT, mm_reader, x ) }, ;
				'���ன�⢮ �⥭�� ᬠ��-���� (��� �.�����)', ;
				{ | | iif( empty( m1sc_reader ), .t., f_read_sc_reader() ) }, ;
				{ | | tip_polzovat == 0 } } )
				
	&& aadd(mm_tmp, {"base_copy","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_danet,A__MENUVERT)},;
				&& 1,{|x|inieditspr(A__MENUVERT,mm_danet,x)},;
				&& '�믮����� ��⮬���᪮� १�ࢭ�� ����஢���� �� ��室� �� �ணࠬ��',,;
				&& {|| tip_polzovat == 0 }})
	&& aadd(mm_tmp, {"wdir","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_wdir,A__MENUVERT)},;
				&& 0,{|x|inieditspr(A__MENUVERT,mm_wdir,x)},;
				&& '�> �㤠 �믮������ ����஢����',;
				&& {|| iif(empty(m1wdir), (mpath_copy:=m1path_copy:=space(100),update_get("mpath_copy")), .t.) },;
				&& {|| tip_polzovat == 0 .and. m1base_copy == 1 }})
	&& aadd(mm_tmp, {"path_copy","C",100,0,NIL,;
				&& {|x| menu_reader(x,{{|k,r,c| mng_dir(k,r,c,"path_copy") }},A__FUNCTION)},;
				&& " ",{|x| x },;
				&& ' �> ��⠫�� ��� ����஢����',,;
				&& {|| tip_polzovat == 0 .and. m1base_copy == 1 .and. m1wdir == 1 }})
	&& aadd(mm_tmp, {"kart_polis","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_danet,A__MENUVERT)},;
				&& 1,{|x|inieditspr(A__MENUVERT,mm_danet,x)},;
				&& '� ०��� ���������� � ����⥪� �ந������� ���� ��樥�� �� ������'})
	&& aadd(mm_tmp, {"e_1","C",1,0,NIL,,"",,;
				&& '����� ���� ���������� � ��७���� � ᫥���騩 ������塞� ��砩 �� �����',,;
				&& {|| .f. }})
	&& aadd(mm_tmp, {"oms_pole","N",15,0,NIL,;
				&& {|x|menu_reader(x,mm_oms_pole,A__MENUBIT)},;
				&& 0,{|x|inieditspr(A__MENUBIT,mm_oms_pole,x)},;
				&& '�/� ���:'})
	&& aadd(mm_tmp, {"wokato","N",1,0,NIL,;
				&& {|x|menu_reader(x,mm_wokato,A__MENUVERT)},;
				&& 0,{|x|inieditspr(A__MENUVERT,mm_wokato,x)},;
				&& '����� ����� �� 㬮�砭�� �ᯮ�짮����',;
				&& {|| iif(empty(m1wokato), (m_okato:=space(70),m1_okato:=space(11),update_get("m_okato")), .t.) }})
	&& aadd(mm_tmp, {"_okato","C",11,0,NIL,;
				&& {|x|menu_reader(x,{{ |k,r,c| get_okato_ulica(k,r,c,{k,m_okato,}) }},A__FUNCTION)},;
				&& space(11),{|x| ret_okato_ulica('',x)},;
				&& '�> ����� �� 㬮�砭��',,;
				&& {|| m1wokato == 1 }})
	&& if is_obmen_sds()
		&& aadd(mm_tmp, {"e_2","C",1,0,NIL,,"",,;
					&& '��⠫��� ��� ������ ���ଠ樥� � �ணࠬ��� Smart Delta Systems:',,;
					&& {|| .f. }})
		&& aadd(mm_tmp, {"path1_sds","C",100,0,NIL,;
					&& {|x| menu_reader(x,{{|k,r,c| mng_dir(k,r,c,"path1_sds") }},A__FUNCTION)},;
					&& " ",{|x| x },;
					&& '==> ��� ������ ����⥪�',,;
					&& {|| tip_polzovat == 0 }})
		&& aadd(mm_tmp, {"path2_sds","C",100,0,NIL,;
					&& {|x| menu_reader(x,{{|k,r,c| mng_dir(k,r,c,"path2_sds") }},A__FUNCTION)},;
					&& " ",{|x| x },;
					&& '==> ��� ��ࠡ�⠭��� 䠩���',,;
					&& {|| tip_polzovat == 0 }})
	&& endif
	init_base( cur_dir + 'tmp', , mm_tmp, 0 )
	use ( cur_dir + 'tmp' ) new
	append blank
	tmp->sc_reader := sr
	&& tmp->base_copy := int( val( a2default( ar, 'base_copy', '1' ) ) )
	&& tmp->path_copy := a2default( ar, 'path_copy', '' )
	&& tmp->wdir := iif( empty( tmp->path_copy ), 0, 1 )
	&& tmp->kart_polis := int( val( a2default( ar, 'kart_polis', '1' ) ) )
	&& tmp->oms_pole := int( val( a2default( ar,'oms_pole', '0' ) ) )
	&& tmp->_okato := a2default( ar, 'okato_umolch', '' )
	&& tmp->wokato := iif( empty( tmp->_okato ), 0, 1 )
	&& if is_obmen_sds()
		&& tmp->path1_sds := a2default( ar, 'path1_sds', '' )
		&& tmp->path2_sds := a2default( ar, 'path2_sds', '' )
	&& endif
	close databases
	if f_edit_spr( A__EDIT, mm_tmp, '����ன�� ࠡ�祣� ����', 'g_use( cur_dir + "tmp", , , .t., .t. )', 0, 1 ) > 0
		use ( cur_dir + 'tmp' ) new
		&& mm_tmp := { ;
				&& { group_ini, 'sc_reader',   tmp->sc_reader }, ;
				&& { group_ini, 'base_copy',   tmp->base_copy }, ;
				&& { group_ini, 'path_copy',   tmp->path_copy }, ;
				&& { group_ini, 'kart_polis',  tmp->kart_polis }, ;
				&& { group_ini, 'oms_pole',    tmp->oms_pole }, ;
				&& { group_ini, 'okato_umolch',tmp->_okato } ;
				&& }
		mm_tmp := { ;
				{ group_ini, 'sc_reader',   tmp->sc_reader } ;
				}
		&& if is_obmen_sds()
			&& aadd( mm_tmp, { group_ini, 'path1_sds', alltrim( tmp->path1_sds ) } )
			&& aadd( mm_tmp, { group_ini, 'path2_sds', alltrim( tmp->path2_sds ) } )
		&& endif
		SetIniVar( tmp_ini, mm_tmp )
	endif
	close databases
	return nil