* ReportServicesOutput.prg - ������������ HTML-������� �� ������������ ����� �����������
*******************************************************************************
* 06.11.18 PrintCompositionIncompServices() - ������ ������ ������������� �����
* 06.11.18 PrintPaymentTable() - ������ ������� ������� ������
*******************************************************************************

#include "chip_mo.ch"

* 06.11.18 ������ ������ ������������� �����
function PrintCompositionIncompServices()
	Local oDoc, oNode, oTable, oRow, oCell, oTH
	Local item, itemService
	local ar := TCompostionIncompServiceDB():GetList()
	
	oDoc := CreateReportHTML( '������������� ������' )
	
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := '������, �� ����������� �� ����'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'

	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '&nbsp;'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '&nbsp;'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '&nbsp;'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	for each item in ar
		oRow         := oTable + 'tr'

		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"  colspan="3"'
		oCell:text	:= item:Name
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
		
		if !item:IsEmptyServices()
			for each itemService in item:IncompatibleServices()
				oRow         := oTable + "tr"
				
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left"'
				oCell:text	:= '&nbsp;'
				oCell		:= oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left"'
				oCell:text	:= itemService:Shifr
				oCell		:= oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )

				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td3" valign="center" align="left"'
				oCell:text	:= win_OEMToANSI( TServiceDB():GetByShifr( itemService:Shifr ):Name )
				oCell		:= oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				oRow := oRow - 'tr'
				HB_SYMBOL_UNUSED( oRow )
			next
		endif
	next
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	ViewHTML( oDoc )
	return nil
	
* 06.11.18 ������ ������� ������� ������
function PrintPaymentTable()
	Local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	Local item
	local ar := TUsl_U5DB():GetList()
	local aTemp := {}, aRow := {}, i := 0
	
	oDoc := CreateReportHTML( '�������� ������' )
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := '�������� ������ ���������'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := '�� ' + win_OEMToANSI( date_month( sys_date, .t. ) )
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� ������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ��������� �������
	// ����� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '% ������ �� ���'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	if is_task( X_PLATN ) // ��� ������� �����
		oCell		:= oTH + 'th'
		oCell:attr	:= 'class="thleft" ' + iif( is_oplata == 7 , 'colspan="4"', 'colspan="3"' )
		oParag			:= oCell + 'p'
		oParag:attr		:= 'align="center" class="bodyp"'
		oParag:text		:= '% ������ �� ��.���.'
		oParag			:= oParag - 'p'
		oCell		:= oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
	endif
	
	oTH		:= oTH  - 'tr'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	// �������� � ������� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ��������� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ����� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// ������ �������
	if is_task( X_PLATN ) // ��� ������� �����
		oCell		:= oTH + 'th'
		oCell:attr	:= 'class="thleft"'
		oParag			:= oCell + 'p'
		oParag:attr		:= 'align="center" class="bodyp"'
		oParag:text		:= '����'
		oParag			:= oParag - 'p'
		oCell		:= oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
		
		oCell		:= oTH + 'th'
		oCell:attr	:= 'class="thleft"'
		oParag			:= oCell + 'p'
		oParag:attr		:= 'align="center" class="bodyp"'
		oParag:text		:= '���������'
		oParag			:= oParag - 'p'
		oCell		:= oCell - 'th'
		HB_SYMBOL_UNUSED( oCell )
		if is_oplata == 7
			oCell		:= oTH + 'th'
			oCell:attr	:= 'class="thleft"'
			oParag			:= oCell + 'p'
			oParag:attr		:= 'align="center" class="bodyp"'
			oParag:text		:= '��.���'
			oParag			:= oParag - 'p'
			oCell		:= oCell - 'th'
			HB_SYMBOL_UNUSED( oCell )
			
			oCell		:= oTH + 'th'
			oCell:attr	:= 'class="thleft"'
			oParag			:= oCell + 'p'
			oParag:attr		:= 'align="center" class="bodyp"'
			oParag:text		:= '������'
			oParag			:= oParag - 'p'
			oCell		:= oCell - 'th'
			HB_SYMBOL_UNUSED( oCell )
		else
			oCell		:= oTH + 'th'
			oCell:attr	:= 'class="thleft"'
			oParag			:= oCell + 'p'
			oParag:attr		:= 'align="center" class="bodyp"'
			oParag:text		:= '������'
			oParag			:= oParag - 'p'
			oCell		:= oCell - 'th'
			HB_SYMBOL_UNUSED( oCell )
		endif
	endif
	
	oRow := oTH - 'tr'
	HB_SYMBOL_UNUSED( oRow )
		
	oBTable			:= oTable + 'tbody'

	for each item in ar
		if ( i := ascan( aTemp, { | x | x[ 1 ] == item:Razryad() .and. ;
							x[ 2 ] == item:Otdal() .and. x[ 3 ] == item:Service1 .and. x[ 4 ] == item:Service2 } ) ) == 0
			aRow := {}
			aadd( aRow, item:Razryad() )
			aadd( aRow, item:Otdal() )
			aadd( aRow, item:Service1() )
			aadd( aRow, item:Service2() )
			aadd( aRow, iif( item:Type() == O5_VR_OMS, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aRow, iif( item:Type() == O5_AS_OMS, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aRow, iif( item:Type() == O5_VR_PLAT, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aRow, iif( item:Type() == O5_AS_PLAT, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aRow, iif( item:Type() == O5_VR_NAPR, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aRow, iif( item:Type() == O5_VR_DMS, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aRow, iif( item:Type() == O5_AS_DMS, ft_opl_51( item:Percent(), item:Percent2(), 10 ), '' ) )
			aadd( aTemp, aRow )
		else
			do case
				case item:Type() == O5_VR_OMS
					aTemp[ i, 5 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
				case item:Type() == O5_AS_OMS
					aTemp[ i, 6 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
				case item:Type() == O5_VR_PLAT
					aTemp[ i, 7 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
				case item:Type() == O5_AS_PLAT
					aTemp[ i, 8 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
				case item:Type() == O5_VR_NAPR
					aTemp[ i, 9 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
				case item:Type() == O5_VR_DMS
					aTemp[ i, 10 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
				case item:Type() == O5_AS_DMS
					aTemp[ i, 11 ] := ft_opl_51( item:Percent(), item:Percent2(), 10 )
			endcase
		endif
	next
	for each item in aTemp
		oRow         := oTable + 'tr'

		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= put_val( item[ 1 ], 4 )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text	:= iif( item[ 2 ], '��', '���' )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text	:= item[ 3 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= iif( empty( item[ 4 ] ), item[ 3 ], item[ 4 ] )
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text	:= item[ 5 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		oCell		:= oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text	:= item[ 6 ]
		oCell		:= oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		if is_task( X_PLATN ) // ��� ������� �����
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text	:= item[ 7 ]
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			oCell		:= oRow + 'td'
			oCell:attr	:= 'class="td1" valign="center" align="center"'
			oCell:text	:= item[ 8 ]
			oCell		:= oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			if is_oplata == 7
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center"'
				oCell:text	:= item[ 10 ]
				oCell		:= oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center"'
				oCell:text	:= item[ 11 ]
				oCell		:= oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			else
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center"'
				oCell:text	:= item[ 9 ]
				oCell		:= oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			endif
		endif
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	next
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	ViewHTML( oDoc )
	return nil
