* 02.10.18 ReportLogBookThread() ������ �����������

#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'common.ch'

#require 'hbtip'

// 24.08.24 ������ �����������
function ReportLogBookThread( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	local totalAmount := 0, totalContract := 0
	local oDepartment := nil, oChief := nil
	local strClass := '', strClass1 := ''
	local aTitle := { '������ �����������', '����� ������� �� �������� ������� ����������� ����� (������)' }
	local aContracts := {}, aPatient := {}, aServices := {}, aLogBook := {}
	local rowLogBook := '1'
	local flagPatient := .f.
	local flagPatientAdd := .f.
	local iRowService := 0
	local stService := '', counterService
	local oPatient
	local itemContract, itemService

		
//ContractsToJson( aHash, aContracts )
	
	oDoc := CreateReportHTML( '������ �����������' )
	
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'
	// ������ �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�. �. �., ����� ���������������'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ������ �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� ���. �����'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ������ - ������� �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft-wo-bottom" colspan="5"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����������� ������'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ������� �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� ������'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	oTH				:= oTH - 'tr'
	
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'
	// ������ �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ��������� �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� (���)'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ����� �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-��'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ������ �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� (���)'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	// ������� �������
	oCell			:= oTH + 'th'
	oCell:attr		:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� ��������'
	oParag			:= oParag - 'p'
	oCell			:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	oTH				:= oTH - 'tr'
//	

	HB_SYMBOL_UNUSED( oTH )

	aContracts := TContractDB():getListByCondition( aHash )
	for each itemContract in aContracts
		oPatient := itemContract:Patient
		if isnil( oPatient )
			loop
		endif
		aServices := {}
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )

			// ������ aPatient {������ ��������, ���� ������, ������ �����, ���-�� �����, ����� �����}
			aPatient := { oPatient, itemContract:DatePay, {}, 0, 0 }
				
			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// ������ aServices {����, ��������, ����, ���������� , ����� �����, ���� ��������}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), itemService:Price, 0, 0, itemService:Date } )
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
				aServices[ counterService, 4 ] += itemService:Quantity
				aServices[ counterService, 5 ] += itemService:Total
				aPatient[ 5 ] += itemService:Total
			next
			aPatient[ 3 ] := aServices
			aPatient[ 4 ] := len( aServices )
			
			aadd( aLogBook, aPatient )
		endif
		
	next
	for each rowLogBook in aLogBook
		rowspanPatient := lstr( rowLogBook[ 4 ] )
		flagPatient := .f.
		flagPatientAdd := .f.
		aServices := rowLogBook[ 3 ]
		++totalContract
		
		iRowService := 0
		for each itemService in aServices
			iRowService += 1
			if iRowService == len( aServices )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagPatient
				// 1-� �������
				oRow		:= oTable + 'tr'
				oRow:attr	:= 'class="row"'
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center"  align="left" rowspan="' + rowspanPatient + '"'
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p1"'
				oParag:text	:= alltrim( rowLogBook[ 1 ]:FIO1251 )
				oParag		:= oParag - 'p'
				if ! rowLogBook[ 1 ]:IsAnonymous	// �������� �� ���������� ��������
					oParag		:= oCell + 'p'
					oParag:attr	:= 'class="p2"'
					oParag:text	:= rowLogBook[ 1 ]:AddressRegistration():AsString( , 'win-1251' )
					oParag		:= oParag - 'p'
				endif
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= '�����: ' + lstr( rowLogBook[ 4 ] ) + ' ��.'
				oParag		:= oParag - 'p'
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= '�����: ' + put_kop( rowLogBook[ 5 ], 15 ) + ' ���.'
				oParag		:= oParag - 'p'
				oCell		:= oCell - 'td'
				// 2-� �������
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td1 p1" valign="center"  align="center" rowspan="' + rowspanPatient + '"'
				oCell:text	:= lstr( rowLogBook[ 1 ]:ID() )
				oCell		:= oCell - 'td'
				flagPatient := .t.
			endif
			// 3-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text	:= itemService[2]
			oCell		:= oCell - 'td'
			// 4-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= put_kop( itemService[ 3 ], 7 )
			oCell		:= oCell - 'td'
			// 5-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= lstr( itemService[ 4 ] )
			oCell		:= oCell - 'td'
			// 5-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= put_kop( itemService[ 5 ], 7 )
			oCell		:= oCell - 'td'
			// 6-� �������
			oCell		:= oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text	:= full_date( itemService[ 6 ] )
			oCell		:= oCell - 'td'
			if ! flagPatientAdd
				// 7-� �������
				oCell		:= oRow + 'td'
				oCell:attr	:= 'class="td3" valign="center" align="center" rowspan="' + rowspanPatient + '"'
				oCell:text	:= full_date( rowLogBook[ 2 ] )
				oCell		:= oCell - 'td'
				flagPatientAdd := .t.
			endif
			totalAmount += itemService[ 5 ]
		next
	next
	
	oTable        := oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	// ������ ������
	oTable		:= oDoc:body + 'table'
	oTable:attr	:= 'id="total" class="tab" cellpadding="0" cellspacing="0" border="0"'

	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="200pt"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="200pt"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= '����� :'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= str( totalAmount, 11, 2 ) + ' ���.'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= '����� ���������:'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613 total" width="200pt" style="font-weight:bold;text-align:left"'
	oNode:text	:= str( totalContract, 11 ) + ' ��.'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	oTable		:= oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )
	
	// �������
	oTable		:= oDoc:body + 'table'
	oTable:attr	:= 'id="sign" cellpadding="0" cellspacing="0" border="0"'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="75"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="50"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="tab" width="100"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'
	oRow		:= oRow - 'tr'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613" width="75" align="left"'
	
	if ( oDepartment := hb_user_curUser:Department ) != nil
		oNode:text	:= iif( ( oChief := oDepartment:Chief() ) != nil, alltrim( oChief:Position1251 ), '������������' )
	else
		oNode:text	:= '������� ����'
	endif
	oNode		:= oNode - 'td'
	
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td111" width="50" align="center"'
	oNode:text	:= '&nbsp;'
	oNode		:= oNode - 'td'

	if oDepartment != nil
		oNode		:= oRow + 'td'
		oNode:attr	:= 'class="td613" width="100" align="left"'
		oNode:text	:= iif( ( oChief := oDepartment:Chief() ) != nil, oChief:ShortFIO1251, '' )
		oNode:text	:= ''
		oNode		:= oNode - 'td'
	endif
	oRow		:= oRow - 'tr'
	
	oRow		:= oTable + 'tr'
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613" width="75" align="left"'
	if ( oDepartment := hb_user_curUser:Department ) != nil
		oNode:text	:= '������'
	else
		oNode:text	:= '������� ���������'
	endif
	oNode		:= oNode - 'td'

	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td111" width="50" align="center"'
	oNode:text	:= space( 5 )
	oNode		:= oNode - 'td'
	
	oNode		:= oRow + 'td'
	oNode:attr	:= 'class="td613" width="100" align="left"'
	oNode:text	:= iif( ( oDepartment := hb_user_curUser:Department ) != nil, hb_user_curUser:FIO1251, '' )
	oNode		:= oNode - 'td'
	
	oRow		:= oRow - 'tr'
	oTable		:= oTable - 'table'
	HB_SYMBOL_UNUSED( oTable )

	ViewHTML( oDoc )
	return nil
