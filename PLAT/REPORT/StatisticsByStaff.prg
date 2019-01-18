* 29.09.18 StatisticsBySelectedEmployeeAndAllServicesHTML( aHash, aEmployees ) - ����������� ������ �� ������ ����� �� ���������� ����������� � ���� ������� (��� �����)
* 29.09.18 StatisticsBySelectedEmployeeAndAllServices( par ) - ����������� ������ �� ������ ����� �� ���������� ����������� � ���� �������
* 19.09.18 StatisticsByEmployeeAndServicesAndPatients( par ) - ����������� ������ �� ������ ����� �� ���������� �����������, ��������� ������� � ���������
* 19.09.18 StatisticsByEmployeeAndServicesAndPatientsHTML( aHash, oEmployee, aServices ) - ����������� ������ �� ������ ����� �� ���������� �����������, ��������� ������� � ��������� (��� �����)
* 14.09.18 StatisticsByEmployeeAndPatients( par ) - ������ ������� � ��������� ���� ������� �� ������� ����� (�/������, ���������)
* 14.09.18 StatisticsByEmployeeAndPatientsHTML( aHash, typeStaff ) - ������ ������� � ��������� ���� ������� �� ������� ����� (�/������, ���������) (��� �����)
* 13.09.18 StatisticsByEmployee( par ) - ����������� ������ �� ���������� �� ���������
* 13.09.18 StatisticsByEmployeeHTML( aHash ) - ����������� ������ �� ���������� �� ��������� (��� �����)
* 12.09.18 StatisticsByEmployeeAndAllServicesAndPatients( par ) - ����������� ������ �� ������ ����� �� ���������� ���������� � ���� ������� � ���� �������
* 12.09.18 StatisticsByEmployeeAndAllServicesAndPatientsHTML( par ) - ����������� ������ �� ������ ����� �� ���������� ���������� � ���� ������� � ���� ������� (��� �����)
* 12.09.18 StatisticsByEmployeeAndServices( par ) - ����������� ������ �� ������ ����� �� ���������� ���������� � �������
* 12.09.18 StatisticsByEmployeeAndServicesHTML( par ) - ����������� ������ �� ������ ����� �� ���������� ���������� � ������� (��� �����)


#include 'hbthread.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'chip_mo.ch'
#include 'common.ch'

* 26.09.18 ����������� ������ �� ������ ����� �� ���������� �����������, ��������� ������� � ���������
function StatisticsByEmployeeAndServicesAndPatients( par )
	local aHash, oEmployee, aServices

	if ( aHash := QueryDataForTheReport() ) != nil
		// ������� ����������
		oEmployee := SelectEmployee( T_ROW, T_COL-5 )
		if ! isnil( oEmployee )
			aServices := FillArrayServices()
			if ! isnil( aServices )
				hb_hSet(aHash, 'TYPEDATE', par )
				hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByEmployeeAndServicesAndPatientsHTML(), aHash, oEmployee, aServices )
				WaitingReport()
			endif
		endif
	endif
	return nil

* 19.09.18 ����������� ������ �� ������ ����� �� ���������� �����������, ��������� ������� � ��������� (��� �����)
function	StatisticsByEmployeeAndServicesAndPatientsHTML( aHash, oEmployee, listServices )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '������ ���������, ������� ���� ������� ������', alltrim( oEmployee:Name1251 ) + ' (' + lstr( oEmployee:TabNom ) + ')' }
	local aContracts := {}, aSubdivisions := {}, aServices := {}, aPatients := {}
	local itemContract, itemSubdivision, itemService, itemPatient, item
	local stSubdivision := '', counterSubdivision := 0
	local stService := '', counterService := 0
	local stPatient := '', counterPatient := 0
	local strClass, strClass1
	local rowspanSubdivision := '1'
	local rowspanService := '1'
	local flagSubdivision := .f.
	local flagService := .f.
	local iRowPatient := 0
	
	oDoc := CreateReportHTML( '������ ���������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-�, 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� ��������� �������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 2-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each itemContract in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )

			if isnil( itemContract:Patient )
				loop
			endif
			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				if hb_ascan( listServices, { | x | alltrim( upper( x[ 1 ] ) ) == alltrim( upper( itemService:Service:Shifr ) ) } ) == 0
					loop
				endif
				if ! itemService:IsParticipant( oEmployee )
					loop
				endif
				
				stSubdivision := alltrim( itemService:Subdivision:Name1251 )
				if ( counterSubdivision := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSubdivision } ) ) == 0
					// ������ aDepartments {��������, ������ �����, ���������� ���������}
					aadd( aSubdivisions, { stSubdivision, {}, 0 } )
					counterSubdivision := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSubdivision } )
				endif
				
				aServices := aSubdivisions[ counterSubdivision, 2 ]
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// ������ aServices {����, ��������, ���������� , ����� �����, ������ ���������, ���������� ���������}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0, {}, 0 } )
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
				
				aPatients := aServices[ counterService, 5 ]
				stPatient := alltrim( itemContract:Patient:FIO1251 )
				// ������ aPatients {��������, ����� �����, ���� ��������� �������}
				aadd( aPatients, { stPatient, itemService:Total, itemContract:EndTreatment } )
				aServices[ counterService, 6 ] += 1
				aSubdivisions[ counterSubdivision, 3 ] += 1
				
				aServices[ counterService, 5 ] := aPatients
				aServices[ counterService, 3 ] += itemService:Quantity
				aServices[ counterService, 4 ] += itemService:Total
				aSubdivisions[ counterSubdivision, 2 ] := aServices
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemSubdivision in aSubdivisions
		aServices := itemSubdivision[ 2 ]
		flagSubdivision := .f.
		rowspanSubdivision := lstr( itemSubdivision[ 3 ] + len( aServices ) )
		
		for each itemService in aServices
			aPatients := itemService[ 5 ]
			flagService := .f.
			rowspanService := lstr( itemService[ 6 ] )
			
			iRowPatient := 0
			for each itemPatient in aPatients
				iRowPatient += 1
				if iRowPatient == len( aPatients )
					strClass := 'class="td1"'
					strClass1 := 'class="td3"'
				else
					strClass := 'class="td11"'
					strClass1 := 'class="td31"'
				endif
				oRow       := oTable + 'tr'
				if ! flagSubdivision
					// 1-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
					oCell:text := itemSubdivision[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagSubdivision := .t.
				endif
				if ! flagService
					// 2-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanService + '"'
					oCell:text := itemService[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					
					// 3-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanService + '"'
					oCell:text := itemService[ 2 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagService := .t.
				endif
				// 4-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="left"'
				oCell:text := itemPatient[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 5-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="center"'
				oCell:text := itemPatient[ 3 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 6-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass1 + ' valign="center" align="right"'
				oCell:text := put_kopE( itemPatient[ 2 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			next
			// ������� �� ������
			oRow	:= oTable + 'tr'
			// 2-�, 3-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1 total" valign="center" align="left" colspan="2"'
			oCell:text := '���-�� ���������: ' + lstr( itemService[ 6 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1 total" valign="center" align="left"'
			oCell:text := '���-�� �����: ' + lstr( itemService[ 3 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td1 total" valign="center" align="right"'
			oCell:text := '�����: '
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= 'class="td3 total" valign="center" align="right"'
			oCell:text := put_kopE( itemService[ 4 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 29.09.18 ����������� ������ �� ������ ����� �� ���������� ����������� � ���� �������
function StatisticsBySelectedEmployeeAndAllServices( par )
	local aHash, aEmployees

	if ( aHash := QueryDataForTheReport() ) != nil
		// �������� �����������
		aEmployees := FillArrayEmployees()
		if ! isnil( aEmployees )
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsBySelectedEmployeeAndAllServicesHTML(), aHash, aEmployees )
			WaitingReport()
		endif
	endif
	return nil

* 26.09.18 ������ ������� � ��������� ���� ������� �� ������� ����� (�/������, ���������)
function StatisticsByEmployeeAndPatients( par )
	local svr_as := 1, mas_pmt := { win_ANSIToOEM( '~�����' ), win_ANSIToOEM( '~����������' ), win_ANSIToOEM( '~���������' ), win_ANSIToOEM( '~���������' ) }
	local vr_as
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		if ( vr_as := popup_prompt( T_ROW, T_COL - 5, svr_as, mas_pmt ) ) != 0
			svr_as := vr_as
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByEmployeeAndPatientsHTML(), aHash, svr_as )
			WaitingReport()
		endif
	endif
	return nil

* 26.09.18 ����������� ������ �� ���������� �� ���������
function StatisticsByEmployee( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByEmployeeHTML(), aHash )
		WaitingReport()
	endif
	return nil

* 26.09.18 ����������� ������ �� ������ ����� �� ���������� ���������� � ���� ������� � ���� �������
function StatisticsByEmployeeAndAllServicesAndPatients( par )
	local aHash, oEmployee

	if ( aHash := QueryDataForTheReport() ) != nil
		// ������� ����������
		oEmployee := SelectEmployee( T_ROW, T_COL-5 )
		if ! isnil( oEmployee )
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByEmployeeAndAllServicesAndPatientsHTML(), aHash, oEmployee )
			WaitingReport()
		endif
	endif
	return nil

* 26.09.18 ����������� ������ �� ������ ����� �� ���������� ���������� � �������
function StatisticsByEmployeeAndServices( par )
	local aHash, oEmployee

	if ( aHash := QueryDataForTheReport() ) != nil
		// ������� ����������
		oEmployee := SelectEmployee( T_ROW, T_COL-5 )
		if ! isnil( oEmployee )
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByEmployeeAndServicesHTML(), aHash, oEmployee )
			WaitingReport()
		endif
	endif
	return nil

* 29.09.18 ����������� ������ �� ������ ����� �� ���������� ����������� � ���� ������� (��� �����)
function StatisticsBySelectedEmployeeAndAllServicesHTML( aHash, aStaff )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oParag
	local aTitle := { '���������� �� ��������� �������' }
	local aContracts := {}, aEmployees := {}, aServices := {}, aPatients := {}
	local itemContract, itemEmployee, itemService
	local oEmployee := nil
	local iStaff := 0
	local stEmployee := '', counterEmployee := 0
	local stService := '', counterService := 0
	local stPatient := '', counterPatient := 0
	local stVid := ''
	local flagEmployee := .f.
	local rowspanEmployee := '1'
	local iRowEmployee := 0
	local item
	
	oDoc := CreateReportHTML( '���������� �� ��������� �������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	&& // 2-� �������
	&& oCell		:= oTH + 'th'
	&& oCell:attr	:= 'class="thleft" rowspan="2"'
	&& oParag			:= oCell + 'p'
	&& oParag:attr		:= 'align="center" class="bodyp"'
	&& oParag:text		:= '���'
	&& oParag			:= oParag - 'p'
	&& oCell		:= oCell - 'th'
	&& HB_SYMBOL_UNUSED( oCell )
	&& // 3-� �������
	&& oCell		:= oTH + 'th'
	&& oCell:attr	:= 'class="thleft" rowspan="2"'
	&& oParag			:= oCell + 'p'
	&& oParag:attr		:= 'align="center" class="bodyp"'
	&& oParag:text		:= '���-�� �����'
	&& oParag			:= oParag - 'p'
	&& oCell		:= oCell - 'th'
	&& HB_SYMBOL_UNUSED( oCell )
	&& // 4-� �������
	&& oCell		:= oTH + 'th'
	&& oCell:attr	:= 'class="thleft" rowspan="2"'
	&& oParag			:= oCell + 'p'
	&& oParag:attr		:= 'align="center" class="bodyp"'
	&& oParag:text		:= '��������� �����'
	&& oParag			:= oParag - 'p'
	&& oCell		:= oCell - 'th'
	&& HB_SYMBOL_UNUSED( oCell )
	// 5-�, 6-�, 7-�, 8-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom thright" colspan="4"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 5-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 7-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 8-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	
	for each itemContract in aContracts
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )
			
			if ! isnil( itemContract:Patient )
				stPatient := itemContract:Patient:FIO1251
			else
				stPatient := '����������� �������'
			endif
			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				oEmployee := nil
				for each item in aStaff
					if itemService:IsParticipant( item[ 3 ] )
						oEmployee := TEmployeeDB():getByTabNom( item[ 3 ] )
						exit
					endif
				next
				if ! isnil( oEmployee )		// ��������� ������
					stEmployee := alltrim( oEmployee:FIO1251 )
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						// ������ aEmployees {���, ���������� , �����, ������ �����, ����� ������ �����, ������ ����������, ������ ���������}
						aadd( aEmployees, { stEmployee, 0, 0, {}, 0, oEmployee, {} } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
					endif
					aPatients := aEmployees[ counterEmployee, 7 ]
					if ( counterPatient := hb_ascan( aPatients, { | x | x == stPatient } ) ) == 0
						// ������ aEmployees {���, ���������� , �����, ������ �����, ����� ������ �����, ������ ����������, ������ ���������}
						aadd( aPatients, stPatient )
						aEmployees[ counterEmployee, 7 ] := aPatients
					endif
					aServices := aEmployees[ counterEmployee, 4 ]
					stService := alltrim( itemService:Service:Shifr1251 )
					if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
						// ������ aServices {����, ������������, ���������� , �����}
						aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0 } )
						counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
						aEmployees[ counterEmployee, 5 ] += 1
					endif
					aServices[ counterService, 3 ] += itemService:Quantity
					aServices[ counterService, 4 ] += itemService:Total
					
					asort( aServices, , , {| x, y | x[ 1 ] < y[ 1 ] } )
					aEmployees[ counterEmployee, 4 ] := aServices
					aEmployees[ counterEmployee, 2 ] += itemService:Quantity
					aEmployees[ counterEmployee, 3 ] += itemService:Total
				endif
			next
		endif
	next
	
	for each itemEmployee in aEmployees
		rowspanEmployee := lstr( itemEmployee[ 5 ] )
		flagEmployee := .f.
		aServices := itemEmployee[ 4 ]
		stVid := ''
		if itemEmployee[ 6 ]:IsDoctor
			stVid := '����'
		elseif itemEmployee[ 6 ]:IsNurse
			stVid := '�-�'
		elseif itemEmployee[ 6 ]:IsAidman
			stVid := '���.'
		else
			stVid := '������'
		endif
		
		iRowEmployee := 0
		for each itemService in aServices
			iRowEmployee += 1
			if iRowEmployee == len( aServices )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagEmployee
				// 1-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanEmployee + '"'
				&& oCell:text := itemEmployee[ 1 ]
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p1"'
				oParag:text	:= itemEmployee[ 1 ]
				oParag		:= oParag - 'p'

				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p1"'
				oParag:text	:= '( ' + stVid + ' )'
				oParag		:= oParag - 'p'

				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= '���������: ' + lstr( len( itemEmployee[ 7 ] ) ) + ' ���.'
				oParag		:= oParag - 'p'
				
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= '�����: ' + lstr( itemEmployee[ 2 ] ) + ' ��.'
				oParag		:= oParag - 'p'
				
				oParag		:= oCell + 'p'
				oParag:attr	:= 'class="p2"'
				oParag:text	:= '���������: ' + put_kopE( itemEmployee[ 3 ], 15 ) + ' ���.'
				oParag		:= oParag - 'p'
				
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				&& // 2-� �������
				&& oCell      := oRow + 'td'
				&& oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanEmployee + '"'
				&& oCell:text := stVid
				&& oCell      := oCell - 'td'
				&& HB_SYMBOL_UNUSED( oCell )
			
				&& // 3-� �������
				&& oCell      := oRow + 'td'
				&& oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanEmployee + '"'
				&& oCell:text := lstr( itemEmployee[ 2 ] )
				&& oCell      := oCell - 'td'
				&& HB_SYMBOL_UNUSED( oCell )
			
				&& // 4-� �������
				&& oCell      := oRow + 'td'
				&& oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanEmployee + '"'
				&& oCell:text := put_kopE( itemEmployee[ 3 ], 15 )
				&& oCell      := oCell - 'td'
				&& HB_SYMBOL_UNUSED( oCell )
			
				flagEmployee := .t.
			endif
			
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemService[ 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 6-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemService[ 2 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 7-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := lstr( itemService[ 3 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 7-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass1 + ' valign="center" align="right"'
			oCell:text := put_kopE( itemService[ 4 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil
	
* 14.09.18 ������ ������� � ��������� ���� ������� �� ������� ����� (�/������, ���������) (��� �����)
function StatisticsByEmployeeAndPatientsHTML( aHash, typeStaff )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '���������� �� ������ ���������' }
	local aContracts := {}, aDepartments := {}, aSubdivisions := {}, aPatients  := {}, aEmployees := {}, aServices := {}
	local itemContract, itemService, itemDepartment, itemSubdivision, itemPatient, itemEmployee
	local stDepartment := '', currentDepartment := 0
	local stSubdivision := '', currentSubdivision := 0
	local stPatient := '', currentPatient := 0
	local stEmployee := '', currentEmployee := 0
	local aTypeStaff := { '����', '���������', '���������', '���������' }	
	local oEmployee := nil
	local rowspanDepartment := '1', flagDepartment := .f.
	local rowspanSubdivision := '1',	flagSubdivision := .f.
	local rowspanPatient := '1', flagPatient := .f.
	local strClass, strClass1, iRowEmployee := 0
	
	oDoc := CreateReportHTML( '���������� �� ������ ���������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-�, 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 4-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= aTypeStaff[ typeStaff ]
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each itemContract in aContracts
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )
			if isnil( itemContract:Department )
				loop
			endif
			if isnil( itemContract:Patient )
				loop
			endif
			stDepartment := alltrim( itemContract:Department:Name1251 )
			if ( counterDepartment := hb_ascan( aDepartments, { | x | x[ 1 ] == stDepartment } ) ) == 0
				// ������ aDepartments {��������, ������ ���������, ���������� �����������}
				aadd( aDepartments, { stDepartment, {}, 0 } )
				counterDepartment := hb_ascan( aDepartments, { | x | x[ 1 ] == stDepartment } )
			endif
			stPatient := alltrim( itemContract:Patient:FIO1251 )
			
			for each itemService in itemContract:Services()
				oEmployee := nil
				if isnil( itemService:Subdivision )
					loop
				endif
				if isnil( itemService:Service )
					loop
				endif
				if isnil( itemService:Doctor ) .and. ( typeStaff == 1 )
					loop
				endif
				if typeStaff == 1
					oEmployee := itemService:Doctor
				endif
				if isnil( itemService:Assistant ) .and. ( typeStaff == 2 )
					loop
				endif
				if typeStaff == 2
					oEmployee := itemService:Assistant
				endif
				if isnil( itemService:Nurse1 ) .and. isnil( itemService:Nurse2 ) .and. isnil( itemService:Nurse3 ) .and. ( typeStaff == 3 )
					loop
				endif
				if typeStaff == 3
					oEmployee := itemService:Nurse1
				endif
				if isnil( itemService:Aidman1 ) .and. isnil( itemService:Aidman2 ) .and. isnil( itemService:Aidman3 ) .and. ( typeStaff == 4 )
					loop
				endif
				if typeStaff == 4
					oEmployee := itemService:Aidman1
				endif
				
				aSubdivisions := aDepartments[ counterDepartment, 2 ]
				stSubdivision := itemService:Subdivision:Name1251
				if ( counterSubdivision := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSubdivision } ) ) == 0
					// ������ aSubdivisions {��������, ������ ���������, ���������� �����������}
					aadd( aSubdivisions, { stSubdivision, {}, 0 } )
					counterSubdivision := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSubdivision } )
				endif
				
				aPatients := aSubdivisions[ counterSubdivision, 2 ]
				if ( counterPatient := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } ) ) == 0
					// ������ aPatients {��������, ������ �����������, ���-�� ����������}
					aadd( aPatients, { stPatient, {}, 0 } )
					counterPatient := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } )
				endif
				
				aEmployees := aPatients[ counterPatient, 2 ]
				if ! isnil( oEmployee )
					stEmployee := alltrim( oEmployee:ShortFIO1251 )
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						aadd( aEmployees, { stEmployee, 0, oEmployee:TabNom } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aPatients[ counterPatient, 3 ] += 1
						aSubdivisions[ counterSubdivision, 3 ] += 1
						aDepartments[ counterDepartment, 3 ] += 1
					endif
					aEmployees[ counterEmployee, 2 ] += itemService:Total
					aPatients[ counterPatient, 2 ] := aEmployees
				endif
				
				if ( itemService:Nurse2 != nil ) .and. ( typeStaff == 3 )
					stEmployee := alltrim( itemService:Nurse2:ShortFIO1251 )
					aEmployees := aPatients[ counterPatient, 2 ]
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						aadd( aEmployees, { stEmployee, 0, itemService:Nurse2:TabNom } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aPatients[ counterPatient, 3 ] += 1
						aSubdivisions[ counterSubdivision, 3 ] += 1
						aDepartments[ counterDepartment, 3 ] += 1
					endif
					aEmployees[ counterEmployee, 2 ] += itemService:Total
					aPatients[ counterPatient, 2 ] := aEmployees
				endif
				
				if ( itemService:Nurse3 != nil ) .and. ( typeStaff == 3 )
					stEmployee := alltrim( itemService:Nurse3:ShortFIO1251 )
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						aadd( aEmployees, { stEmployee, 0, itemService:Nurse3:TabNom } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aPatients[ counterPatient, 3 ] += 1
						aSubdivisions[ counterSubdivision, 3 ] += 1
						aDepartments[ counterDepartment, 3 ] += 1
					endif
					aEmployees[ counterEmployee, 2 ] += itemService:Total
					aPatients[ counterPatient, 2 ] := aEmployees
				endif
				
				if ( itemService:Aidman2 != nil ) .and. ( typeStaff == 4 )
					stEmployee := alltrim( itemService:Aidman2:ShortFIO1251 )
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						aadd( aEmployees, { stEmployee, 0, itemService:Aidman2:TabNom } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aPatients[ counterPatient, 3 ] += 1
						aSubdivisions[ counterSubdivision, 3 ] += 1
						aDepartments[ counterDepartment, 3 ] += 1
					endif
					aEmployees[ counterEmployee, 2 ] += itemService:Total
					aPatients[ counterPatient, 2 ] := aEmployees
				endif
				if ( itemService:Aidman3 != nil ) .and. ( typeStaff == 4 )
					stEmployee := alltrim( itemService:Aidman3:ShortFIO1251 )
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						aadd( aEmployees, { stEmployee, 0, itemService:Aidman3:TabNom } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aPatients[ counterPatient, 3 ] += 1
						aSubdivisions[ counterSubdivision, 3 ] += 1
						aDepartments[ counterDepartment, 3 ] += 1
					endif
					aEmployees[ counterEmployee, 2 ] += itemService:Total
					aPatients[ counterPatient, 2 ] := aEmployees
				endif
				// ����������� ���������
				asort( aPatients, , , {| x, y | x[ 1 ] < y[ 1 ] } )
				aSubdivisions[ counterSubdivision, 2 ] := aPatients
				aDepartments[ counterDepartment, 2 ] := aSubdivisions
			next
		endif
	next
	asort( aDepartments, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each itemDepartment in aDepartments
		rowspanDepartment := lstr( itemDepartment[ 3 ] )
		flagDepartment := .f.
		aSubdivisions := itemDepartment[ 2 ]
		
		for each itemSubdivision in aSubdivisions
			rowspanSubdivision := lstr( itemSubdivision[ 3 ] )
			flagSubdivision := .f.
			aPatients := itemSubdivision[ 2 ]
			
			for each itemPatient in aPatients
				rowspanPatient := lstr( itemPatient[ 3 ] )
				flagPatient := .f.
				aEmployees := itemPatient[ 2 ]

				iRowEmployee := 0
				for each itemEmployee in aEmployees
					iRowEmployee += 1
					oRow       := oTable + 'tr'
					if ! flagDepartment
						// 1-� �������
						oCell      := oRow + 'td'
						oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanDepartment + '"'
						oCell:text := itemDepartment[ 1 ]
						oCell      := oCell - 'td'
						HB_SYMBOL_UNUSED( oCell )
						flagDepartment := .t.
					endif
					if ! flagSubdivision
						// 2-� �������
						oCell      := oRow + 'td'
						oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
						oCell:text := itemSubdivision[ 1 ]
						oCell      := oCell - 'td'
						HB_SYMBOL_UNUSED( oCell )
						flagSubdivision := .t.
					endif
					if ! flagPatient
						// 3-� �������
						oCell      := oRow + 'td'
						oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanPatient + '"'
						oCell:text := itemPatient[ 1 ]
						oCell      := oCell - 'td'
						HB_SYMBOL_UNUSED( oCell )
						flagPatient := .t.
					endif
					
					if iRowEmployee == len( aEmployees )
						strClass := 'class="td1"'
						strClass1 := 'class="td3"'
					else
						strClass := 'class="td11"'
						strClass1 := 'class="td31"'
					endif
					// 3-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= strClass + ' valign="center" align="center"'
					oCell:text := itemEmployee[ 3 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					// 4-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= strClass + ' valign="center" align="left"'
					oCell:text := itemEmployee[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
						
					// 5-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= strClass1 + ' valign="center" align="right"'
					oCell:text := put_kopE( itemEmployee[ 2 ], 15 )
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
				next
			next
		next
	next
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 13.09.18 ����������� ������ �� ���������� �� ��������� (��� �����)
function StatisticsByEmployeeHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '���������� �� ������ ���������' }
	local aContracts := {}, aEmployees := {}, aServices := {}, oEmployee := nil
	local itemContract, itemService, itemEmployee
	local stEmployee := '', counterEmployee := 0
	local svNom, tbNom
	local isDoctor := .f.
	local quantity := { 0, 0 },	total := { 0, 0 }
	
	oDoc := CreateReportHTML( '���������� �� ������ ���������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-�, 2-�, 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="3"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 1-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�. �. �.'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each itemContract in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )

			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				if ! isnil( itemService:Doctor ) .and. ! isnil( itemService:Assistant )
					loop
				endif
				if ! isnil( itemService:Doctor )
					isDoctor := .t.
					oEmployee := itemService:Doctor
				else
					if ! isnil( itemService:Assistant )
						isDoctor := .f.
						oEmployee := itemService:Assistant
					endif
				endif
				stEmployee := alltrim( oEmployee:FIO1251 )
				tbNom := oEmployee:TabNom			// ��������� ����� ����������
				svNom := oEmployee:SvodNom			// ������� ��������� ����� ����������
				if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
					// ������ aEmployees {��������, ���������� , ����� �����, ���. �����, isDoctor}
					aadd( aEmployees, { stEmployee, 0, 0, oEmployee:TabNom, isDoctor, oEmployee:SvodNom } )
					counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
				endif
				
				aEmployees[ counterEmployee, 2 ] += itemService:Quantity
				aEmployees[ counterEmployee, 3 ] += itemService:Total
				if isDoctor
					quantity[ 1 ] += itemService:Quantity
					total[ 1 ] += itemService:Total
				else
					quantity[ 2 ] += itemService:Quantity
					total[ 2 ] += itemService:Total
				endif
				
				if ! isnil( itemService:Doctor ) .and. ! isnil( itemService:Assistant )		// ������������ � ������ � ���������
					oEmployee := itemService:Assistant
					stEmployee := alltrim( oEmployee:FIO1251 )
					isDoctor := .f.
					
					tbNom := oEmployee:TabNom			// ��������� ����� ����������
					svNom := oEmployee:SvodNom			// ������� ��������� ����� ����������
					if ( counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						// ������ aEmployees {��������, ���������� , ����� �����, ���. �����, isDoctor}
						aadd( aEmployees, { stEmployee, 0, 0, oEmployee:TabNom, isDoctor, oEmployee:SvodNom } )
						counterEmployee := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
					endif
				
					aEmployees[ counterEmployee, 2 ] += itemService:Quantity
					aEmployees[ counterEmployee, 3 ] += itemService:Total
					quantity[ 2 ] += itemService:Quantity
					total[ 2 ] += itemService:Total
				endif
			next
		endif
	next
	asort( aEmployees, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemEmployee in aEmployees
	
		oRow       := oTable + 'tr'
		// 1-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text := lstr( iif( itemEmployee[ 6 ] == 0, itemEmployee[ 4 ], itemEmployee[ 6 ] ) ) + iif( itemEmployee[ 6 ] != 0, '*', '' )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		// 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text := itemEmployee[ 1 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text := iif( itemEmployee[ 5 ], '����', '���.' )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text := lstr( itemEmployee[ 2 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		// 5-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center" align="right"'
		oCell:text := put_kopE( itemEmployee[ 3 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	next
	// ������ ������
	oRow	:= oTable + 'tr'
	// 2-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="3"'
	oCell:text := '�����:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( quantity[ 1 ] )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( total[ 1 ], 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )

	oRow	:= oTable + 'tr'
	// 2-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="3"'
	oCell:text := '����������:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( quantity[ 2 ] )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( total[ 2 ], 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	
	oRow	:= oTable + 'tr'
	// 2-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="3"'
	oCell:text := '� � � � �:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( quantity[ 1 ] + quantity[ 2 ] )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( total[ 1 ] + total[ 2 ], 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 12.09.18 ����������� ������ �� ������ ����� �� ���������� ���������� � ���� ������� � ���� ������� (��� �����)
function StatisticsByEmployeeAndAllServicesAndPatientsHTML( aHash, oEmployee )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '������ ���������, ������� ���� ������� ������', alltrim( oEmployee:Name1251 ) + ' (' + lstr( oEmployee:TabNom ) + ')' }
	local aContracts := {}, aServices := {}, aPatients := {}
	local itemContract, itemService, itemPatient
	local stService := '', counterService := 0
	local stPatient := '', counterPatient := 0
	local strClass, strClass1
	local rowspanPatient := '1'
	local flagService := .f.
	local iRowPatient := 0
	
	oDoc := CreateReportHTML( '������ ���������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-�, 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� ��������� �������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 1-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each itemContract in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )

			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				if ! isnil( itemService:Doctor )
					if itemService:Doctor:ID != oEmployee:ID
						loop
					endif
				else
					if ! isnil( itemService:Assistant )
						if itemService:Assistant:ID != oEmployee:ID
							loop
						endif
					endif
				endif
				stService := alltrim( itemService:Service:Shifr1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// ������ aServices {����, ��������, ���������� , ����� �����, ������ ���������, ���������� ���������}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0, {}, 0 } )
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
				endif
				
				aPatients := aServices[ counterService, 5 ]
				stPatient := alltrim( itemContract:Patient:FIO1251 )
				// ������ aPatients {��������, ����� �����, ���� ��������� �������}
				aadd( aPatients, { stPatient, itemService:Total, itemContract:EndTreatment } )
				aServices[ counterService, 6 ] += 1
				
				aServices[ counterService, 5 ] := aPatients
				aServices[ counterService, 3 ] += itemService:Quantity
				aServices[ counterService, 4 ] += itemService:Total
			next
		endif
	next
	asort( aServices, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each itemService in aServices
		aPatients := itemService[ 5 ]
		flagService := .f.
		rowspanPatient := lstr( itemService[ 6 ] )
	
		iRowPatient := 0
		for each itemPatient in aPatients
			iRowPatient += 1
			if iRowPatient == len( aPatients )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagService
				// 1-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanPatient + '"'
				oCell:text := itemService[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 2-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanPatient + '"'
				oCell:text := itemService[ 2 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			
				flagService := .t.
			endif
			
			// 3-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemPatient[ 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := itemPatient[ 3 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass1 + ' valign="center" align="right"'
			oCell:text := put_kopE( itemPatient[ 2 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
		
		// ������� �� ������
		oRow	:= oTable + 'tr'
		// 1-�, 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1 total" valign="center" align="left" colspan="2"'
		oCell:text := '���-�� ���������: ' + lstr( itemService[ 6 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1 total" valign="center" align="left"'
		oCell:text := '���-�� �����: ' + lstr( itemService[ 3 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1 total" valign="center" align="right"'
		oCell:text := '�����: '
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 5-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3 total" valign="center" align="right"'
		oCell:text := put_kopE( itemService[ 4 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	next
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 12.09.18 ����������� ������ �� ������ ����� �� ���������� ���������� � ������� (��� �����)
function StatisticsByEmployeeAndServicesHTML( aHash, oEmployee )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '���������� �� ��������� �������', alltrim( oEmployee:Name1251 ) + ' (' + lstr( oEmployee:TabNom ) + ')' }
	local aContracts := {}, aServices := {}
	local itemContract, itemService
	local stService := '', stServiceAdd := '', counterService := 0
	local isDoctor := .f.
	local totalQuantity := 0, totalSumm := 0
	
	oDoc := CreateReportHTML( '���������� �� ��������� �������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-�, 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '&nbsp;'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	oTH				:= oTable + 'tr'
	oTH:attr		:= 'class="head"'

	// 1-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each itemContract in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], itemContract:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], itemContract:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], itemContract:Subdivision:ID ) )

			for each itemService in itemContract:Services()
				if isnil( itemService:Service )
					loop
				endif
				if ! isnil( itemService:Doctor )
					if itemService:Doctor:ID == oEmployee:ID
						isDoctor := .t.
					else
						loop
					endif
				else
					if ! isnil( itemService:Assistant )
						if itemService:Assistant:ID == oEmployee:ID
							isDoctor := .f.
						else
							loop
						endif
					endif
				endif
				stService := alltrim( itemService:Service:Shifr1251 )
				stServiceAdd := stService + if( isDoctor, 'Doctor', 'Assistant' )
				if ( counterService := hb_ascan( aServices, { | x | x[ 6 ] == stServiceAdd } ) ) == 0
					// ������ aServices {����, ��������, ���������� , ����� �����, isDoctor, stServiceAdd}
					aadd( aServices, { stService, alltrim( itemService:Service:Name1251 ), 0, 0, isDoctor, stServiceAdd } )
					counterService := hb_ascan( aServices, { | x | x[ 6 ] == stServiceAdd } )
				endif
					
				aServices[ counterService, 3 ] += itemService:Quantity
				aServices[ counterService, 4 ] += itemService:Total
				totalQuantity += itemService:Quantity
				totalSumm += itemService:Total
			next
		endif
	next
	asort( aServices, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemService in aServices
	
		// ������� ������ �������
		oRow       := oTable + 'tr'
		
		// 1-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text := itemService[ 1 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left"'
		oCell:text := itemService[ 2 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text := iif( itemService[ 5 ], '����', '���.' )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="center"'
		oCell:text := lstr( itemService[ 3 ] )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	
		// 5-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3" valign="center" align="right"'
		oCell:text := put_kopE( itemService[ 4 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
	next
	
	// ������ ������
	oRow	:= oTable + 'tr'
	// 1-�, 2-�, 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="3"'
	oCell:text := '� � � � �:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( totalQuantity )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( totalSumm, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil
