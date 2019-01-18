* PlaceOfWork.prg - работа со справочником строк мест работы
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 28.11.18 ввод фразы для места работы из списка
function v_vvod_mr_bay()
	local k, nrow := row(), ncol := col(), fl := .f., tmp_keys, tmp_gets
	local item

	tmp_keys := my_savekey()
	if ( get := get_pointer( 'oPatient:PlaceWork' ) ) != nil .and. get:hasFocus
		save gets to tmp_gets
		setcursor( 0 )
		if !empty( k := input_s_mr_bay() )
			fl := .t.
		else
			@ nrow, ncol say ''
		endif
		restore gets from tmp_gets
		if fl
			keyboard ( alltrim( k ) )
		endif
		setcursor()
	endif
	my_restkey( tmp_keys )
	return nil

* 28,11,18 выбор фразы для места работы
function input_s_mr_bay()
	local blkEditObject
	local oBox
	local aProperties
	local selObject
	local ret := ''
	local cMessage := ''

	oBox := TBox():New( 2, 26, maxrow() - 2, 79, .t. )
	oBox:Color := color0
	oBox:Caption := 'Места работы'
	aProperties := { { 'Name', 'Список фраз для места работы', 50 } }
	aEdit := { .t., .f., .f., .t. }
	blkEditObject := { | oBrowse, aObjects, object, nKey | editPlaceOfWork( oBrowse, aObjects, object, nKey ) }
	cMessage := '   ^<F2>^ - поиск'

	// выбор объекта из списка
	selObject := ListObjectsBrowse( 'TPlaceOfWork', oBox, asort( TPlaceOfWorkDB():GetList(), , , { | x, y | x:Name < y:Name } ), 1, aProperties, ;
										blkEditObject, aEdit, , cMessage, , .t. )
	if ! isnil( selObject )
		ret := alltrim( selObject:Name )
	endif
	return ret

* 24.11.18 выбор объекта из списка общих справочников
function getPlaceOfWork( k, r, c )
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
	oBox:Caption := 'Места работы'
	aProperties := { { 'Name', 'Подстрока места работы', 50 } }
	// выбор объекта из списка
	selObject := ListObjectsBrowse( 'TPlaceOfWork', oBox, asort( TPlaceOfWorkDB():GetList(), , , { | x, y | x:Name < y:Name } ), 1, aProperties, ;
										, , , , , .t. )
	if isnil( selObject )
		ret := { 0, space( 10 ) }
	else
		ret := { selObject:ID, left( selObject:Name, 10 ) }
	endif
	return ret

***** 24.11.18 редактирование списка общих справочников
Function viewPlaceOfWork()
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editPlaceOfWork( oBrowse, aObjects, object, nKey ) }
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .f., .t., .t. }, { .f., .f., .f., .f. } )

	oBox := TBox():New( T_ROW, 2, maxrow() - 2, 76, .t. )
	oBox:Color := color5
	oBox:Caption := 'Места работы'
	aProperties := { { 'Name', 'Подстрока места работы', 50 } }
	// просмотр и редактирование списка
	ListObjectsBrowse( 'TPlaceOfWork', oBox, asort( TPlaceOfWorkDB():GetList(), , , { | x, y | x:Name < y:Name } ), 1, aProperties, ;
										blkEditObject, aEdit, , )
	return nil

* 30.11.18 редактирование объекта справочника мест работы
static function editPlaceOfWork( oBrowse, aObjects, oCommon, nKey )
	local k
	local fl := .f.
	local i

	if nKey == K_INS .OR. nKey == K_ENTER .or. nKey == K_F4
		k := maxrow() - 7
		
		oBox := TBox():New( k, 5, k + 2, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, 'Добавление', 'Редактирование' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:View()
		
		@ k + 1, 7 say 'Строка для записи' get oCommon:Name picture '@S50'
		myread()
		if lastkey() != K_ESC .and. !empty( oCommon:Name ) .and. f_Esc_Enter( 1 )
			TPlaceOfWorkDB():Save( oCommon )
			fl := .t.
		endif
	elseif nKey == K_F2
		if ( i := findElementInListObjects( aObjects, 'Name' ) ) > 0
			nInd := i // приватная переменная функции ListObjectsBrowse
		endif
	endif
	return fl