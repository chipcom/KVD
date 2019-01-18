#include "function.ch"
#include "edit_spr.ch"

***** ������ ������������ (name) 祣�-� �� ���� (kod) � ���� ������
Function retpopupedit_bay
	Local mm := "", tmp_select := select()
	Local oItem := Nil, lExists := .F.
	parameters name_base, mkod
	
	If VALTYPE( name_base ) == "C"
		if R_Use(name_base)  // �� �⥭��
			if fieldnum("KOD") > 0 // �᫨ � ���� ������ ���� ���� "KOD"
				locate for FIELD->kod == mkod
				mm := if(found(), rtrim(FIELD->name), "")
			else  // ���� ࠡ�⠥� �� ������ �����
				goto (mkod)
				mm := if(!eof() .and. !deleted(), rtrim(FIELD->name), "")
			endif
			use
		endif
		if tmp_select > 0
			select(tmp_select)
		endif
	Elseif valtype( name_base ) == "A" .AND. Len( name_base ) >  0
		If VALTYPE( name_base[1] ) == "O"
			lExists := __objHasMethod( name_base[1], "Code" )
			FOR EACH oItem IN name_base
				If lExists
					If oItem:Code() == mkod
						mm := AllTrim( oItem:Name() )
					EndIf
				Else
					If oItem:ID() == mkod
						mm := AllTrim( oItem:Name() )
					EndIf
				EndIf
			NEXT
		ElseIf VALTYPE( name_base[1] ) == "A"
		EndIf
	EndIf
	if empty(mm)
		mm := space(10)
	endif
	
	return mm