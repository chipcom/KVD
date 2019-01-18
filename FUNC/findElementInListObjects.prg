#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 29.11.18 ���� ����⮢ � ᯨ᪥ ��ꥪ⮢ ��� ��������� ���祭�� � ��।������� ᢮��⢥
function findElementInListObjects( aObjects, nameProperty )
	static stmp1 := '', stmp2 := ''
	local oBox, oBoxCheck
	local strSearch
	local t_len := 0, i
	local aSearch := {}, aIndex := {}
	local ret := 0
	local strFind
	local bBlock := ''
	
	oBox := TBox():New( 8, 4, 14, maxcol() - 4, .t. )
	oBox:Caption := '���� �� �����'
	oBox:CaptionColor := cDataCSay
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - �⪠� �� �����'
	oBox:View()
	@ 10, 6 say center( '������ ���祢�� ᫮��', maxcol() - 6 )
	do while .t.
		strSearch := padr( stmp1, maxcol() - 11 )
		@ 11, 6 get strSearch picture '@K@!'
		myread()
		if lastkey() != K_ESC .and. !empty( strSearch )
			strSearch := alltrim( strSearch )
			bBlock := createCodeBlock( strSearch, aSearch, aIndex, nameProperty )
			aeval( aObjects, bBlock )
			if ( t_len := len( aSearch ) ) == 0
				hb_alert( '��㤠�� ����!', , , 3 )
				loop
			endif
			oBoxCheck := TBox():New( 3, 4, 15, maxcol() - 4, .t. )
			oBoxCheck:Color := 'B/BG'
			oBoxCheck:MessageLine := '^<Esc>^ - �⪠� �� �롮�'
			oBoxCheck:View()
			@ 4, 5 say '����: ' + strSearch
			@ 5, 6 say padc( '��������� ������⢮ - ' + lstr( t_len ), maxcol() - 10 )
			if ( i := popup( 6, 5, 14, maxcol() - 5, aSearch, 1, 0 ) ) > 0
				ret := aIndex[ i ]
			endif
		endif
		oBoxCheck := nil
		exit
	enddo
	oBox := nil
	return ret

***** �ନ஢���� ��������� ��� ����஥��� ��ப� ���᪠
static function createCodeBlock( strSearch, aSearch, aIndex, nameProperty )
	local bCode
	bcode := { | obj, n |
		return if( strSearch $ upper( obj:&nameProperty ), ( aadd( aSearch, obj:&nameProperty ), aadd( aIndex, n ) ), '' )
	}
	return bCode