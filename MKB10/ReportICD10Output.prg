#include "inkey.ch"

* ReportICD10Output.prg - ������������ HTML-������� �� ����������� ���-10
*******************************************************************************
* 06.11.18 - printFoundICD( nKey, nInd )
* 06.11.18 - printICDRange( obj ) ������ ������ ���������
*******************************************************************************


* 06.11.18 
function printFoundICD( nKey, nInd )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable, oTH
	local item, s := ''
	local ar := AClone( tmp_mas )
	local rec, i
	
	if nKey == K_F9
		oDoc := CreateReportHTML( '��������� ������ �� �����' )
		
		oNode         := oDoc:body:h1
		oNode         := oNode   + 'center'
		oNode:text    := '��������� ������ �� �����: ' + win_OEMToANSI( mname )
		oNode         := oNode   - 'center'
		HB_SYMBOL_UNUSED( oNode )
		
		oTable        := oDoc:body + 'table'
		oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'

		oTH		:= oTable  + 'tr'
		oTH:attr		:= 'class="head"'
		
		// ������ ������� - ���� ��������
		oCell		:= oTH + 'th'
		oCell:attr	:= 'class="thleft"'
		oParag			:= oCell + 'p'
		oParag:attr		:= 'align="center" class="bodyp"'
		oParag:text		:= '����'
		oParag			:= oParag - 'p'
		oCell		:= oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )

		// ������ ������� - ������������ ��������
		oCell     := oTH + 'th'
		oCell:attr	:= 'class="thleft thright" '
		oParag			:= oCell + 'p'
		oParag:attr		:= 'align="center" class="bodyp"'
		oParag:text		:= '������������ ��������'
		oParag			:= oParag - 'p'
		oCell     := oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
		oRow := oRow - "tr"
		
		HB_SYMBOL_UNUSED( oRow )
		
		for each item in ar
			i := hb_At( ' ', item )
			oRow         := oTable + "tr"
						
			// 1-� �������
			oRow		:= oTable + 'tr'
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text	:= win_OEMToANSI( alltrim( substr( item, 1, i - 1 ) ) )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )

			// 2-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td3" valign="center" align="left"'
			oCell:text	:= win_OEMToANSI( alltrim( substr( item, i + 1 ) ) )
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			oRow := oRow - "tr"
			HB_SYMBOL_UNUSED( oRow )
		next
		
		oTable        := oTable - 'table'
		HB_SYMBOL_UNUSED( oTable )
		ViewHTML( oDoc )
	endif
	return nil


* 06.11.18 - printICDRange( obj ) ������ ������ ���������
function printICDRange( obj )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable, oTH
	local item, s := '', s1 := ''
	local ar := TICD10DB():GetListByShifr( obj:SH_B(), obj:SH_E() )
	local rec, i
	local lObjName := obj:ClassName() == 'TICD10Class'

	if lObjName
		oDoc := CreateReportHTML( '�������� ������ ' + alltrim( obj:Class ) )
	else
		oDoc := CreateReportHTML( '������ ���������' )
	endif
		
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := iif( lObjName, '����� ' + win_OEMToANSI( alltrim( obj:Class ) ), obj:Name1251 )
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	if lObjName
		oNode         := oDoc:body:h2
		oNode         := oNode   + 'center'
		oNode:text    := alltrim( obj:Name1251 )
		oNode         := oNode   - 'center'
		HB_SYMBOL_UNUSED( oNode )
	endif
	
	if lObjName
		oNode         := oDoc:body:h3
	else
		oNode         := oDoc:body:h2
	endif
	oNode         := oNode   + 'center'
	oNode:text    := '( ' + if( obj:SH_B() == obj:SH_E, alltrim( obj:SH_B ), alltrim( obj:SH_B ) + ' - ' + alltrim( obj:SH_E ) ) + ' )'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oNode         := oDoc:body:h4
	oNode         := oNode   + 'center'
	oNode:text    := '( ������ "-" ����� ������ �������� ��������, �� �������� � ��� )'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'

	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'

	oRow          := oTable  + 'tr'
	// ������ ������� - ���� ��������
	// ������ �������� :text
	oCell		:= oRow + 'td'
	oCell:attr	:= 'class="td1" valign="center" align="center"'
	oCell		:= oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	// ������ ������� - ���� ��������
	// ������ �������� :text
	oCell		:= oRow + 'td'
	oCell:attr	:= 'class="td1" valign="center" align="center"'
	oCell		:= oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	// ������ ������� - ������������ ��������
	// ������ �������� :text
	oCell		:= oRow + 'td'
	oCell:attr	:= 'class="td1" valign="center" align="center"'
	oCell		:= oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	oRow := oRow - "tr"
	HB_SYMBOL_UNUSED( oRow )
		
	for each item in ar
		s1 := iif( !empty( item:Gender ), iif( item:Gender() == '�', '<���.>', '<���.>' ), space( 6 ) )
		s += iif( !between_date( item:dBegin, item:dEnd ), '-', ' ' )
		s += padr( item:Shifr, 6 )
		oRow         := oTable + 'tr'
		// 1-� �������
		oCell		:= oRow + 'td'
		oRow:bgColor := iif( !between_date( item:dBegin, item:dEnd ), "lightgrey", "white" )
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= iif( "." $ item:Shifr(), s1, s )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 2-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= iif( "." $ item:Shifr(), s, '' )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 3-� �������
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center" align="left"'
		oCell:text	:= alltrim( item:Name1251 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oRow := oRow - "tr"
		HB_SYMBOL_UNUSED( oRow )
		s := ''
		s1 := ''
	next
	
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	ViewHTML( oDoc )
	return nil