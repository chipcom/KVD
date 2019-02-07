* CommonView.prg - работа со общими справочниками
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 23.11.18 выбор объекта из списка организаций выдавший документ
function getPublisher( k, r, c )
	local r1, r2
	local oBox
	local aProperties
	local selObject
	local ret

	if ( r1 := r + 1 ) > maxrow() / 2
		r2 := r-1
		r1 := 2
	else
		r2 := maxrow() - 2
	endif

	oBox := TBox():New( r1, 4, r2, 77, .t. )
	oBox:Color := color5
	oBox:Caption := 'Наименование организаций, выдающих документы'
	aProperties := { { 'Name', 'Место выдачи документа', 70 } }
	// выбор объекта из списка
	selObject := ListObjectsBrowse( 'TPublisher', oBox, TPublisherDB():GetList(), 1, aProperties, ;
										, , , , , .t. )
	if isnil( selObject )
		ret := { 0, space( 57 ) }
	else
		ret := { selObject:ID, left( selObject:Name, 57 ) }
	endif
	return ret

***** 23.11.18 редактирование списка издателей документов
Function viewPublisher()
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	local cMessage := ''
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editPublisher( oBrowse, aObjects, object, nKey ) }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .f., .t., .t. }, { .f., .f., .f., .f. } )

	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 76, .t. )
	oBox:Color := color5
	oBox:Caption := 'Место выдачи документа'
	aProperties := { { 'Name', 'Место выдачи документа', 70 } }
	cMessage := ' ^<F2>^ - Удаление дубликатов '
	// просмотр и редактирование списка
	ListObjectsBrowse( 'TPublisher', oBox, TPublisherDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , cMessage, )
	return nil

* 22.10.18 редактирование объекта справочника издателя
static function editPublisher( oBrowse, aObjects, oCommon, nKey )
	local fl := .f.

	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 2, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление', 'Редактирование' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ k + 1, 7 say 'Строка для записи' get oCommon:Name picture '@S50'
		myread()
		if lastkey() != K_ESC .and. !empty( oCommon:Name ) .and. f_Esc_Enter( 1 )
			TPublisherDB():Save( oCommon )
			fl := .t.
		endif
	elseif ( hb_user_curUser:IsAdmin() ) .and. ( nKey == K_F2 )
		removeDublicateTPublisher()
		oBrowse:refreshAll()
		fl := .t.
	endif
	return fl