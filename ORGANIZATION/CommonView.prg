* CommonView.prg - ࠡ�� � ��騬� �ࠢ�筨����
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

***** 04.11.18 ।���஢���� ᯨ᪠ ���� �ࠢ�筨���
Function viewCommon( nType )
	local blkEditObject
	local aEdit
	local oBox
	local tName
	local aProperties
	local cMessage
	
	private typeClass := nType
	
	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editCommon( oBrowse, aObjects, object, nKey ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .f., .t., .t. }, { .f., .f., .f., .f. } )

	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 76, .t. )
	oBox:Color := color5
	if nType == 1
		oBox:Caption := '����� ��ப�'
		tName := 'TAddressString'
		aObjects := TAddressStringDB():GetList()
		aProperties := { { 'Name', '�����ப� ����', 40 } }
	elseif nType == 2
		oBox:Caption := '���� ࠡ���'
		tName := 'TPlaceOfWork'
		aObjects := asort( TPlaceOfWorkDB():GetList(), , , { | x, y | x:Name < y:Name } )
		aProperties := { { 'Name', '�����ப� ���� ࠡ���', 50 } }
	elseif nType == 3
		oBox:Caption := '���� �뤠� ���㬥��'
		tName := 'TPublisher'
		aObjects := TPublisherDB():GetList()
		aProperties := { { 'Name', '���� �뤠� ���㬥��', 70 } }
		cMessage := ' <F2> - �������� �㡫���⮢ '
	else
		return nil
	endif
	// ��ᬮ�� � ।���஢���� ᯨ᪠
	ListObjectsBrowse( tName, oBox, aObjects, 1, aProperties, ;
										blkEditObject, aEdit, , cMessage, )
	return nil

* 22.10.18 ।���஢���� ��ꥪ� �ࠢ�筨��
static function editCommon( oBrowse, aObjects, oCommon, nKey )
	local fl := .F.

	if nKey == K_INS .OR. nKey == K_ENTER .or. nKey == K_F4
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 2, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()
		
		@ k + 1, 7 say '��ப� ��� �����' get oCommon:Name picture '@S50'
	
		&& status_key("^<Esc>^ - ��室 ��� �����;  ^<PgDn>^ - ���⢥ত���� �����")
		myread()
		if lastkey() != K_ESC .and. !empty( oCommon:Name ) .and. f_Esc_Enter( 1 )
			if typeClass == 1
				TAddressStringDB():Save( oCommon )
			elseif typeClass == 2
				TPlaceOfWorkDB():Save( oCommon )
			elseif typeClass == 3
				TPublisherDB():Save( oCommon )
			endif
			fl := .t.
		endif
	elseif ( hb_user_curUser:IsAdmin() ) .and. ( nKey == K_F2 ) .and. ( typeClass == 3 )
		removeDublicateTPublisher()
		oBrowse:refreshAll()
		fl := .t.
	endif
	Return fl
	
* 㤠����� �㡫���⮢ �࣠����権, �뤠��� ���㬥���
function removeDublicateTPublisher()
	Static sk
	Local buf, s1, s2, k1, k2, hGauge, r
	local firstSelect, secondSelect
	
	buf := savescreen()
	s1 := s2 := ''
	r := T_ROW
	
	if !hb_user_curUser:IsAdmin()
		return func_error( 4, '������� ����� � ����� ०�� ����饭!' )
	endif
	if !G_SLock1Task( sem_task, sem_vagno )  // ����� ����㯠 �ᥬ
		return func_error( '� ����� ������ �������� ��������� ����饭�. ����⠥� ��㣠� �����.' )
	endif
	n_message( { '����� ०�� �।�����祭 ��� 㤠����� ����� ��ப�', ;
				'"��� �뤠� ���㬥��" � ��७�� �ᥩ �⭮��饩��', ;
				'� ��� ���ଠ樨 ��㣮� ��ப�' }, , ;
				cColorStMsg, cColorStMsg, , , cColorSt2Msg )
	f_message( { '�롥�� 㤠�塞�� ��ப�' }, , color1, color8, 0 )
	
	firstSelect := selectPublisher( r, maxrow() - 2 )
	if ! isnil( firstSelect )
		s1 := alltrim( firstSelect:Name )
		f_message( { '�롥�� ��ப�, �� ������ ��७����� ���ଠ��', ;
					'�� <.. ' + s1 + ' ..>' } , , ;
					color1, color8, 0 )
		secondSelect := selectPublisher( r, maxrow() - 2 )
		if ! isnil( secondSelect ) .and. ! firstSelect:Equal( secondSelect )
			f_message( { '����塞�� ��ப�:', ;
						'"' + alltrim( firstSelect:Name ) + '".', ;
						'��� ���ଠ�� ��७����� � ��ப�:', ;
						'"' + alltrim( secondSelect:Name ) + '".' }, , ;
						color1, color8 )
			if f_Esc_Enter( '㤠�����', .t. )
				mywait()
				if TPatientExtDB():ReplaceKemVydan( firstSelect, secondSelect )
					TPublisherDB():Delete( firstSelect )
				endif
				stat_msg( '������ �����襭�!' )
			endif
		elseif firstSelect:Equal( secondSelect )
			hb_Alert( '��࠭� ���� � � �� �࣠������!', , , 4 )
		endif
		
	endif
	restscreen( buf )
	G_SUnLock( sem_vagno )
	return NIL

function selectPublisher( row1, row2 )
	local oBox
	local aProperties
	local ret
	
	oBox := TBox():New( row1, 4, row2, 77, .t. )
	oBox:Color := color0
	
	oBox:Caption := '�࣠����樨 �뤠�騥 ���㬥���'
	aProperties := { { 'Name', '���� �뤠� ���㬥��', 70 } }
	
	ret := ListObjectsBrowse( 'TPublisher', oBox, TPublisherDB():GetList(), 1, aProperties, , , , , , .t. )
	return ret