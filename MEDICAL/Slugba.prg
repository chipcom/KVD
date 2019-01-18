#include 'inkey.ch'
#include 'function.ch'
#include 'common.ch'

static strSlugba := 'СПРАВОЧНИК СЛУЖБ'

* 31.10.18 отображение списка служб
function viewSlugba()
	local c1 := T_COL + 10, c2 := 65
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editSlugba( oBrowse, aObjects, object, nKey ) }
	
	aEdit := { .t., .t., .t., .t. }
				
	oBox := TBox():New( 2, c1, maxrow() - 2, c2, .t. )
	oBox:Caption := 'Список служб'
	oBox:Color := color0
	
	aProperties := { { 'Shifr', 'Шифр', 4 }, { 'Name', 'Наименование службы', 40 } }
	// просмотр списка служб
	ListObjectsBrowse( 'TSlugba', oBox, TSlugbaDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , 'N/BG, W+/N, B/BG, BG+/B' )
	return nil

* 31.10.18 редактирование объекта службы	
function editSlugba( oBrowse, aObjects, oSlugba, nKey )
	local fl := .f.
	local oBox
	local k := maxrow() - 19

	if nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		oBox := TBox():New( k - 1, 5, k + 4, 68, .t. )
		oBox:Caption := iif( nKey == K_INS .or. nKey == K_F4, 'Добавление новой службы', 'Редактирование службы' )
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<Enter>^ - подтверждение ввода'
		oBox:Color := cDataCGet
		oBox:View()
		
		@ k + 1, 7 say 'Шифр службы' get oSlugba:Shifr  picture '999' valid { | g | CheckShifr( g, oSlugba, nKey ) }
		@ k + 2, 7 say 'Наименование службы' get oSlugba:Name
	
		myread()
		if lastkey() != K_ESC .and. ! empty( oSlugba:Name ) .and. f_Esc_Enter(1)
			TSlugbaDB():Save( oSlugba )
			fl := .t.
		endif
		oBox := nil
	elseif nKey == K_DEL
		// TODO сделать
	endif
	return fl
	
***** 11.09.18 проверка на допустимость шифра службы
function CheckShifr( get, obj, nKey )
	local ret := .f.
	local fl := .t., id := 0, oFind

	if obj:Shifr > 0 .and. !( obj:Shifr == get:original )
		id := obj:ID()
		if ( oFind := TSlugbaDB():getByShifr( obj:Shifr ) ) != nil
			If nKey == K_ENTER
				if id != oFind:ID()
					fl := .f.
				endif
			elseif ( nKey == K_INS ) .or. ( nKey == K_F4 )
				fl := .f.
			endif
		endif
		if ! fl
			hwg_MsgInfoBay( 'Указанный шифр уже используется в справочнике служб!', strSlugba )
			obj:Shifr := get:original
		endif
	endif
	return fl
	
*****
function get_slugba( k, r, c )
	local ret, r1, r2
	local aSlugba, obj, nId
	local aProperties
	local oBox
	
	nId := 1
	aSlugba := TSlugbaDB():GetList()
	if ( r1 := r + 1 ) > maxrow() / 2
		r2 := r - 1 ; r1 := 2
	else
		r2 := maxrow() - 2
	endif
	aProperties := { { 'Name', 'Наименование службы', 40 } }
	
	oBox := TBox():New( r1, 27, r2, 77, .t. )
	oBox:Caption := 'Список служб'
	oBox:Color := color0
	
	&& if ! isnil( obj := Alpha_BrowseListObject( 'TSlugba', aSlugba, r1, 27, r2, 77, nId, 'layoutSlugba', color0 ) )
		&& ret := mslugba := { obj:Shifr, lstr( obj:Shifr ) + '. ' + alltrim( obj:Name ) }
	&& endif
	obj := ListObjectsBrowse( 'TSlugba', oBox, aSlugba, 1, aProperties, , , , , , .t. )
	if ! isnil( obj )
		ret := mslugba := { obj:Shifr, lstr( obj:Shifr ) + '. ' + alltrim( obj:Name ) }
	endif
	return ret

*****
function selectSlugbaFromMenu( r )
	local r1, r2
	local aSlugba, obj, nId
	local aProperties
	local oBox
	
	nId := 1
	aSlugba := TSlugbaDB():GetList()
	if ( r1 := r + 1 ) > maxrow() / 2
		r2 := r - 1 ; r1 := 2
	else
		r2 := maxrow() - 2
	endif
	aProperties := { { 'Name', 'Наименование службы', 40 } }
	
	oBox := TBox():New( r1, 27, r2, 77, .t. )
	oBox:Caption := 'Список служб'
	oBox:Color := color0
	
	&& obj := Alpha_BrowseListObject( 'TSlugba', aSlugba, r1, 27, r2, 77, nId, 'layoutSlugba', color0 )
	// выбор службы
	obj := ListObjectsBrowse( 'TSlugba', oBox, aSlugba, 1, aProperties, , , , , , .t. )
	return obj