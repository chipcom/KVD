* CommonView.prg - работа со общими справочниками
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

***** 04.11.18 редактирование списка общих справочников
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
		oBox:Caption := 'Адресные строки'
		tName := 'TAddressString'
		aObjects := TAddressStringDB():GetList()
		aProperties := { { 'Name', 'Подстрока адреса', 40 } }
	elseif nType == 2
		oBox:Caption := 'Места работы'
		tName := 'TPlaceOfWork'
		aObjects := asort( TPlaceOfWorkDB():GetList(), , , { | x, y | x:Name < y:Name } )
		aProperties := { { 'Name', 'Подстрока места работы', 50 } }
	elseif nType == 3
		oBox:Caption := 'Место выдачи документа'
		tName := 'TPublisher'
		aObjects := TPublisherDB():GetList()
		aProperties := { { 'Name', 'Место выдачи документа', 70 } }
		cMessage := ' <F2> - Удаление дубликатов '
	else
		return nil
	endif
	// просмотр и редактирование списка
	ListObjectsBrowse( tName, oBox, aObjects, 1, aProperties, ;
										blkEditObject, aEdit, , cMessage, )
	return nil

* 22.10.18 редактирование объекта справочника
static function editCommon( oBrowse, aObjects, oCommon, nKey )
	local fl := .F.

	if nKey == K_INS .OR. nKey == K_ENTER .or. nKey == K_F4
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 2, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление', 'Редактирование' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ k + 1, 7 say 'Строка для записи' get oCommon:Name picture '@S50'
	
		&& status_key("^<Esc>^ - выход без записи;  ^<PgDn>^ - подтверждение ввода")
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
		removeDuplicateTPublisher()
		oBrowse:refreshAll()
		fl := .t.
	endif
	Return fl
