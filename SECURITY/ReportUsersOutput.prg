* ReportUsersOutput.prg - ������ � �������������� �������
******************
* 06.11.18 printUserList( aList ) - ������ ������ ������������� �������
******************
#include "chip_mo.ch"

#require "hbtip" 

* 06.11.18 - ������ ������ ������������� �������
function printUserList( aList )
	Local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable, oTH
	Local item
	
	oDoc := CreateReportHTML( '������ �������������' )
	/* Operator ":" returns first "h1" from body (creates if not existent) */
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := "������������ ������������������ � �������"
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'

	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ��������� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��� �������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ����� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	if is_task( X_KEK )
		oCell:attr	:= 'class="thleft"'
	else
		oCell:attr	:= 'class="thleft thright"'
	endif
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	if is_task( X_KEK )
		// ������� �������
		oCell		:= oTH + 'th'
		oCell:attr	:= 'class="thleft thright"'
		oParag			:= oCell + 'p'
		oParag:attr		:= 'align="center" class="bodyp"'
		oParag:text		:= '������ ���'
		oParag			:= oParag - 'p'
		oCell		:= oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
	endif
	
	for EACH item IN aList
		oRow         := oTable + 'tr'
		oRow:bgColor := iif( item:IsAdmin(), "yellow", "" )
						
		// 1-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= item:FIO1251
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 2-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= item:INN
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 3-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text	:= iif( empty( item:PasswordFR ), '', '+' )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 4-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text	:= if( item:IsAdmin(), "�������������", if( item:IsOperator(), "��������", "���������" ) )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 5-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= if( TDepartmentDB():GetByID( item:IDDepartment() ) != nil, ;
							TDepartmentDB():GetByID( item:IDDepartment() ):Name1251, '' )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 6-� �������
		oCell		:= oRow + 'td'
		if is_task( X_KEK )
			oCell:attr	:= 'class="td1" valign="center" align="center"'
		else
			oCell:attr	:= 'class="td3" valign="center" align="center"'
		endif
		oCell:text	:= item:Position1251
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		if is_task( X_KEK )
			// 7-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td3" valign="center" align="center"'
			oCell:text	:= item:KEK
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		endIf
		oRow := oRow - "tr"
		HB_SYMBOL_UNUSED( oRow )
	next
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	ViewHTML( oDoc )
	return nil