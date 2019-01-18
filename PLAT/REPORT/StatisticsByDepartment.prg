* 26.09.18 StatisticsByDepartmentAndDoctorAndService() - ����������� ������ �� ������ ����� �� ����������, ������ � �������
* 26.09.18 StatisticsByDepartmentAndDoctorHTML( aHash ) - ����������� ������ �� ������ ����� �� ���������� � �����������
* 26.09.18 StatisticsByDepartmentAndDoctorAndServiceHTML( aHash ) - ����������� ������ �� ������ ����� �� ����������, ������ � �������
* 08.09.18 SelectContractsForStatistic( type, dateBegin, dateEnd ) - ������� ��������� �� ��
* 07.09.18 StatisticsByDepartmentMainHTML( aHash) - ����������� ������ �� ������ ����� �� ���������� (��� �����)
* 06.09.18 StatisticsByDepartmentAndPatient() - ����������� ������ �� ������� � ������� ������� � ������ �� ���������
* 06.09.18 StatisticsByDepartmentAndPatientHTML( aHash ) - ����� �� ������� � ������� ������� � ������ �� ���������
* 05.09.18 StatisticsByDepartmentAndPatientAndServices() - ����������� ������ �� ������ ����� �� ������� � ��������
* 05.09.18 StatisticsByDepartmentAndPatientAndServicesHTML( aHash ) - ����� �� ������ ����� �� ������� � ��������
* 05.09.18 StatisticsByDepartmentAndEmployeeAndPatients() - ����������� ������ �� ������ ����� �� ����������, ���������� � �������
* 05.09.18 StatisticsByDepartmentAndEmployeeAndPatientsHTML( aHash, oEmployee ) - ����� �� ������ ����� �� ����������, ���������� � �������
* 06.09.18 StatisticsByDepartmentAndServiceAndPatients() - ����������� ������ �� ������ ����� �� ����������, ������ � �������
* 06.09.18 StatisticsByDepartmentAndServiceAndPatientsHTML( aHash ) - ����� �� ������ ����� �� ����������, ������ � �������
* 21.08.18 StatisticsByDepartmentAndDoctor() - ����������� ������ �� ������ ����� �� ���������� � �����������
* 21.08.18 StatisticsByDepartmentMain() - ����������� ������ �� ������ ����� �� ����������
* 21.08.18 StatisticsByDepartmentAndService() - ����������� ������ �� ������ ����� �� ���������� � �������
* 21.08.18 StatisticsByDepartmentAndServiceHTML( aHash ) - ����������� ������ �� ������ ����� �� ���������� � �������

#include 'hbthread.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'function.ch'
#include 'chip_mo.ch'

* 02.09.18 ����������� ������ �� ������� � ������� ������� � ������ �� ���������
function StatisticsByDepartmentAndPatient( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndPatientHTML(), aHash )
		WaitingReport()
	endif
	return nil
	
* 26.09.18 ����������� ������ �� ������ ����� �� ������� � ��������
function StatisticsByDepartmentAndPatientAndServices( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndPatientAndServicesHTML(), aHash )
		WaitingReport()
	endif
	return nil
	
* 26.09.18 ����������� ������ �� ������ ����� �� ����������, ���������� � �������
function StatisticsByDepartmentAndEmployeeAndPatients( par )
	local aHash, oEmployee

	if ( aHash := QueryDataForTheReport() ) != nil
		// ������� ����������
		if ( oEmployee := SelectEmployee( T_ROW, T_COL-5 ) ) != nil
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndEmployeeAndPatientsHTML(), aHash, oEmployee )
			WaitingReport()
		endif
	endif
	return nil
	
* 26.09.18 ����������� ������ �� ������ ����� �� ����������, ������ � �������
function StatisticsByDepartmentAndServiceAndPatients( par )
	local aHash, oService

	if ( aHash := QueryDataForTheReport() ) != nil
		// ������� ������
		if ( oService := SelectService( T_ROW, T_COL-5 ) ) != nil
			hb_hSet(aHash, 'TYPEDATE', par )
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndServiceAndPatientsHTML(), aHash, oService )
			WaitingReport()
		endif
	endif
	return nil
	
* 26.08.18 ����������� ������ �� ������ ����� �� ���������� � �����������
function StatisticsByDepartmentAndDoctor( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndDoctorHTML(), aHash )
		WaitingReport()
	endif
	return nil

* 26.08.18 ����������� ������ �� ������ ����� �� ����������
function StatisticsByDepartmentMain( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentMainHTML(), aHash )
		WaitingReport()
	endif
	return nil

* 26.08.18 ����������� ������ �� ������ ����� �� ���������� � �������
function StatisticsByDepartmentAndService( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndServiceHTML(), aHash )
		WaitingReport()
	endif
	return nil
	
* 26.09.18 ����������� ������ �� ������ ����� �� ����������, ������ � �������
function StatisticsByDepartmentAndDoctorAndService( par )
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_hSet(aHash, 'TYPEDATE', par )
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @StatisticsByDepartmentAndDoctorAndServiceHTML(), aHash )
		WaitingReport()
	endif
	return nil

* 06.09.18  ����� �� ������� � ������� ������� � ������ �� ���������
function StatisticsByDepartmentAndPatientHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '���������� �� ������ ���������' }
	local aContracts := {}, aDepartments := {}, aSubdivisions := {}, aPatients := {}
	local item, itemSubdivision, itemPatient
	local iRowSubdivision, iRowPatient
	local stDepartment := '', counterDepartment := 0
	local stSubdivision := '', counterSubdivision := 0
	local stPatient := '', counterPatient := 0
	local rowspanDepartment := '1'
	local rowspanSubdivision := '1'
	local flagDepartment := .f., flagSubdivision := .f.
	local strClass := '', strClass1 := ''

	oDoc := CreateReportHTML( '���������� �� ������ ���������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
		if item:Patient == nil
			loop
		endif
		if item:Department == nil
			loop
		endif
		if item:Subdivision == nil
			loop
		endif

		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			stDepartment := alltrim( item:Department:Name1251 )
			stSubdivision := alltrim( item:Subdivision:Name1251 )
			stPatient := alltrim( item:Patient:FIO1251 )

			if ( counterDepartment := hb_ascan( aDepartments, { | x | x[ 1 ] == stDepartment } ) ) == 0
				// ������ aDepartments {��������, ������ ���������, ���������� ���������, ���������� ��������� � ����������}
				aadd( aDepartments, { stDepartment, {}, 0, 0 } )
				counterDepartment := hb_ascan( aDepartments, { | x | x[ 1 ] == stDepartment } )
			endif
			
			aSubdivisions := aDepartments[ counterDepartment, 2 ]
			if ( counterSubdivision := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSubdivision } ) ) == 0
				// ������ aSubdivisions {��������, ������ ���������, ���������� ���������}
				aadd( aSubdivisions, { stSubdivision, {}, 0 } )
				aDepartments[ counterDepartment, 3 ] += 1
				counterSubdivision := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSubdivision } )
			endif
			
			aPatients := aSubdivisions[ counterSubdivision, 2 ]
			// ������ aPatients {���, ���� ���������, ����� �����}
			aadd( aPatients, { stPatient, item:EndTreatment, item:Total } )
			aSubdivisions[ counterSubdivision, 3 ] += 1
			aDepartments[ counterDepartment, 4 ] += 1

			aSubdivisions[ counterSubdivision, 2 ] := aPatients
			aDepartments[ counterDepartment, 2 ] := aSubdivisions
			
		endif
	next
	asort( aDepartments, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each item in aDepartments
		flagDepartment := .f.
		rowspanDepartment := lstr( item[ 4 ] )
		aSubdivisions := item[ 2 ]
		for iRowSubdivision = 1 to item[ 3 ]
			flagSubdivision := .f.
			rowspanSubdivision := lstr( aSubdivisions[ iRowSubdivision, 3 ] )
			aPatients := aSubdivisions[ iRowSubdivision, 2 ]
			for iRowPatient = 1 to len( aPatients )
				
				oRow       := oTable + 'tr'
				if ! flagDepartment
					// 1-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanDepartment + '"'
					oCell:text := item[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagDepartment := .t.
				endif
				if ! flagSubdivision
					// 2-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
					oCell:text := aSubdivisions[ iRowSubdivision, 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagSubdivision := .t.
				endif
				
				if iRowPatient == len( aPatients )
					strClass := 'class="td1"'
					strClass1 := 'class="td3"'
				else
					strClass := 'class="td11"'
					strClass1 := 'class="td31"'
				endif
				// 3-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="left"'
				oCell:text := aPatients[ iRowPatient, 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				// 4-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="center"'
				oCell:text := aPatients[ iRowPatient, 2 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
					
				// 5-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass1 + ' valign="center" align="right"'
				oCell:text := put_kopE( aPatients[ iRowPatient, 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			next
		next
	next

	oTable        := oTable - 'table'
	ViewHTML( oDoc )

	return nil

* 06.09.18  ����� �� ������ ����� �� ������� � ��������
function StatisticsByDepartmentAndPatientAndServicesHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ����� �� ����������, ��������� � �������' }
	local aContracts := {}, aSubdivisions := {}, aPatients := {}, aServices := {}
	local item, itemPatient, itemService, iRow, iRowPatient, iRowService
	local stPatient := '', counter := 0
	local stService := '', counterService := 0
	local stSub := '', counterSub := 0
	local rowspanService := '1'
	local rowspanPatient := '1'
	local flagSub := .f., flagPatient := .f.
	local strClass := '', strClass1 := ''

	oDoc := CreateReportHTML( '����� ����� �� ����������, ��������� � �������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	
	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� �� ���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
		if item:Patient == nil
			loop
		endif
		stPatient := alltrim( item:Patient:FIO1251 )
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			for each itemService in item:Services()
				if itemService:Subdivision == nil
					loop
				endif
				stSub := alltrim( itemService:Subdivision:Name1251 )
				if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
					// ������ aSubdivisions {��������, ����� �����, ������ ���������, ���������� ���������, ���������� �����}
					aadd( aSubdivisions, { stSub, 0, {}, 0, 0 } )
					counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
				endif
					
				aPatients := aSubdivisions[ counterSub, 3 ]
				if ( counter := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } ) ) == 0
					// ������ aPatients {���, ����� �����, ������ �����, ���������� ������������ �����}
					aadd( aPatients, { stPatient, 0, {}, 0 } )
					counter := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } )
					aSubdivisions[ counterSub, 4 ] += 1
				endif
				
				aServices := aPatients[ counter, 3 ]
				stService := alltrim( itemService:Service:Name1251 )
				if ( counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
					// ������ aServices {������������, ����� �����}
					aadd( aServices, { stService, 0 } )
					counterService := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
					aPatients[ counter, 4 ] += 1
					aSubdivisions[ counterSub, 5 ] += 1
				endif
				aServices[ counterService, 2 ] += itemService:Total
				aPatients[ counter, 3 ] := aServices
				aPatients[ counter, 2 ] += itemService:Total
				aSubdivisions[ counterSub, 2 ] += itemService:Total
				aSubdivisions[ counterSub, 3 ] := aPatients
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each item in aSubdivisions
		flagSub := .f.
		rowspanSubdivision := lstr( item[ 5 ] )
		aPatients := item[ 3 ]
		for iRowPatient = 1 to item[ 4 ]
			flagPatient := .f.
			rowspanPatient := lstr( aPatients[ iRowPatient, 4 ] )
			aServices := aPatients[ iRowPatient, 3 ]
			for iRowService = 1 to aPatients[ iRowPatient, 4 ]
				
				oRow       := oTable + 'tr'
				if ! flagSub
					// 1-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
					oCell:text := item[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					// 2-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanSubdivision + '"'
					oCell:text := put_kopE( item[ 2 ], 15 )
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagSub := .t.
				endif
				if ! flagPatient
					// 3-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanPatient + '"'
					oCell:text := aPatients[ iRowPatient, 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					// 4-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanPatient + '"'
					oCell:text := put_kopE( aPatients[ iRowPatient, 2 ], 15 )
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagPatient := .t.
				endif
				if iRowService == aPatients[ iRowPatient, 4 ]
					strClass := 'class="td1"'
					strClass1 := 'class="td3"'
				else
					strClass := 'class="td11"'
					strClass1 := 'class="td31"'
				endif
				// 5-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="left"'
				oCell:text := aServices[ iRowService, 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 6-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass1 + ' valign="center" align="right"'
				oCell:text := put_kopE( aServices[ iRowService, 2 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			next
		next
	next
	
	oTable        := oTable - 'table'
	ViewHTML( oDoc )

	return nil

* 05.09.18  ����� �� ������ ����� �� ����������, ���������� � �������
function StatisticsByDepartmentAndEmployeeAndPatientsHTML( aHash, oEmployee )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ����� �� ����������, ���������� � �������', '������ ���������, ������� ���� ������� ������ �����������:', alltrim( oEmployee:FIO1251 ) + ' (' + lstr( oEmployee:TabNom ) + ')' }
	local aContracts := {}, aSubdivisions := {}, aPatients := {}
	local item, itemService, iRow
	local stPatient := '', counter := 0
	local stSub := '', counterSub := 0
	local quantity := 0,	total := 0, quantityPatient := 0
	local rowspan := '1'
	local strClass := '', strClass1 := ''

	oDoc := CreateReportHTML( '����� ����� �� ����������,���������� � �������' )
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
	
	// 2-� � 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� �� ���������'
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
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
		if item:Patient == nil
			loop
		endif
		stPatient := alltrim( item:Patient:FIO1251 )
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			for each itemService in item:Services()
				if itemService:Doctor != nil .or. itemService:Assistant != nil
					if itemService:Subdivision == nil
						loop
					endif
					if itemService:Doctor != nil
						if itemService:Doctor:ID != oEmployee:ID
							loop
						endif
					else
						if itemService:Assistant != nil
							if itemService:Assistant:ID != oEmployee:ID
								loop
							endif
						endif
					endif
					stSub := alltrim( itemService:Subdivision:Name1251 )
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// ������ aSubdivisions {��������, ����� ����������, ����� �����, ������ ���������, ���������� ���������}
						aadd( aSubdivisions, { stSub, 0, 0, {}, 0 } )
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					
					aPatients := aSubdivisions[ counterSub, 4 ]
					if ( counter := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } ) ) == 0
						// ������ aPatients {���, ����� ����������, ����� �����}
						aadd( aPatients, { stPatient, 0, 0 } )
						counter := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } )
						aSubdivisions[ counterSub, 5 ] += 1
						quantityPatient += 1
					endif
					aPatients[ counter, 2 ] += itemService:Quantity
					aPatients[ counter, 3 ] += itemService:Total
					aSubdivisions[ counterSub, 2 ] += itemService:Quantity
					aSubdivisions[ counterSub, 3 ] += itemService:Total
					aSubdivisions[ counterSub, 4 ] := aPatients
					quantity += itemService:Quantity
					total += itemService:Total
				endif
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each item in aSubdivisions
		aPatients := item[ 4 ]
		rowspan := lstr( item[ 5 ] )
		for iRow = 1 to item[ 5 ]
			if item[ 5 ] == 1 .or. ( iRow == item[ 5 ] )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			
			oRow       := oTable + 'tr'
			if iRow == 1
				// 1-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspan + '"'
				oCell:text := item[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
		
				// 2-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspan + '"'
				oCell:text := item[ 2 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
		
				// 3-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspan + '"'
				oCell:text := put_kopE( item[ 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			endif

			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := aPatients[ iRow, 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := aPatients[ iRow, 2 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 6-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass1 + ' valign="center" align="right"'
			oCell:text := put_kopE( aPatients[ iRow, 3 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
		next
	next
	oRow       := oTable + 'tr'
	// 1-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="left"'
	oCell:text := '�����'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( quantity )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="right"'
	oCell:text := put_kopE( total, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="left" colspan="3"'
	oCell:text := '���������� ��������� - ' + lstr( quantityPatient ) + ' ���.'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )

	return nil
	
* 05.09.18  ����� �� ������ ����� �� ����������, ������ � �������
function StatisticsByDepartmentAndServiceAndPatientsHTML( aHash, oService )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ����� �� ����������, ������ � �������', '������ ���������, ������� ���� ������� ������:', alltrim( oService:Shifr1251 ) + ' ' + alltrim( oService:FullName1251 ) }
	local aContracts := {}, aSubdivisions := {}, aPatients := {}
	local item, itemService, iRow
	local stPatient := '', counter := 0
	local stSub := '', counterSub := 0
	local quantity := 0,	total := 0, quantityPatient := 0
	local rowspan := '1'
	local strClass := '', strClass1 := ''

	oDoc := CreateReportHTML( '����� ����� �� ����������, ������ � �������' )
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
	
	// 2-� � 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� �� ���������'
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
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
		if item:Patient == nil
			loop
		endif
		stPatient := alltrim( item:Patient:FIO1251 )
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			for each itemService in item:Services()
				if itemService:Service != nil
					if itemService:Service:ID != oService:ID
						loop
					endif
					if itemService:Subdivision == nil
						loop
					endif
					stSub := alltrim( itemService:Subdivision:Name1251 )
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// ������ aSubdivisions {��������, ����� ����������, ����� �����, ������ ���������, ���������� ���������}
						aadd( aSubdivisions, { stSub, 0, 0, {}, 0 } )
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					
					aPatients := aSubdivisions[ counterSub, 4 ]
					if ( counter := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } ) ) == 0
						// ������ aPatients {���, ����� ����������, ����� �����}
						aadd( aPatients, { stPatient, 0, 0 } )
						counter := hb_ascan( aPatients, { | x | x[ 1 ] == stPatient } )
						aSubdivisions[ counterSub, 5 ] += 1
						quantityPatient += 1
					endif
					aPatients[ counter, 2 ] += itemService:Quantity
					aPatients[ counter, 3 ] += itemService:Total
					aSubdivisions[ counterSub, 2 ] += itemService:Quantity
					aSubdivisions[ counterSub, 3 ] += itemService:Total
					aSubdivisions[ counterSub, 4 ] := aPatients
					quantity += itemService:Quantity
					total += itemService:Total
				endif
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each item in aSubdivisions
		aPatients := item[ 4 ]
		rowspan := lstr( item[ 5 ] )
		for iRow = 1 to item[ 5 ]
			if item[ 5 ] == 1 .or. ( iRow == item[ 5 ] )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			
			oRow       := oTable + 'tr'
			if iRow == 1
				// 1-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspan + '"'
				oCell:text := item[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
		
				// 2-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspan + '"'
				oCell:text := item[ 2 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
		
				// 3-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspan + '"'
				oCell:text := put_kopE( item[ 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
			endif

			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := aPatients[ iRow, 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := aPatients[ iRow, 2 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 6-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass1 + ' valign="center" align="right"'
			oCell:text := put_kopE( aPatients[ iRow, 3 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
		next
	next
	oRow       := oTable + 'tr'
	// 1-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="left"'
	oCell:text := '�����'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 2-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := lstr( quantity )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="right"'
	oCell:text := put_kopE( total, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="left" colspan="3"'
	oCell:text := '���������� ��������� - ' + lstr( quantityPatient ) + ' ���.'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )

	return nil
	
* 26.09.18 ����������� ������ �� ������ ����� �� ����������, ������ � �������
function StatisticsByDepartmentAndDoctorAndServiceHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ����� �� ����������, ��������� � �������' }
	local aContracts := {}, aServices := {}, aSubdivisions := {}, aEmployees := {}
	local stService := '', counter := 0
	local stSub := '', counterSub := 0
	local stDoctor := '', counterDoc := 0, isDoctor := .t.
	local quantity := { 0, 0 },	total := { 0, 0 }
	local strClass := '', strClass1 := ''
	
	local flagSubdivision := .f., flagEmployee := .f.
	local item, itemSubdivision, itemEmployee, itemService
	local rowspanEmployee := "1", rowspanService := "1"
	local iRowService

	oDoc := CreateReportHTML( '����� ����� �� ����������, ����������� � �������' )
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
	
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-��'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft" rowspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-8-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" colspan="4"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 7-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-��'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 8-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			for each itemService in item:Services()
				if itemService:Subdivision != nil
					stSub := itemService:Subdivision:Name1251
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// ������ aSubdivisions {��������, ����� ����������, ����� �����, ������ �����������, ���������� �����������, ���������� ������������ �����}
						aadd( aSubdivisions, { stSub, 0, 0, {}, 0, 0 } )
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					aEmployees := aSubdivisions[ counterSub, 4 ]
					
					if itemService:Doctor != nil
						stEmployee := '[' + lstr( itemService:Doctor:TabNom ) + '] ' + alltrim( itemService:Doctor:FIO1251 )
						isDoctor := .t.
					elseif itemService:Assistant != nil
						stEmployee := '[' + lstr( itemService:Assistant:TabNom ) + '] ' + alltrim( itemService:Assistant:FIO1251 )
						isDoctor := .f.
					else
						stEmployee := '����������� ���������'
						isDoctor := .f.
						&& loop
					endif
					
					if ( counterDoc := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						// ������ aEmployees {���������, ����� ����������, ����� �����, ������ �����, ����� �����, ������ ����������}
						aadd( aEmployees, { stEmployee, 0, 0, {}, 0, isDoctor } )
						counterDoc := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aSubdivisions[ counterSub, 5 ] += 1
					endif
					aEmployees[ counterDoc, 2 ] += itemService:Quantity
					aEmployees[ counterDoc, 3 ] += itemService:Total
					aServices := aEmployees[ counterDoc, 4 ]
					
					if itemService:Service != nil
						stService := alltrim( itemService:Service:Name1251 )
					else
						loop
					endif
					if ( counter := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
						// ������ aServices {������, ����� ����������, ����� �����, ��� ������}
						aadd( aServices, { stService, 0, 0, itemService:Service:Shifr1251 } )
						counter := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
						aSubdivisions[ counterSub, 6 ] += 1
						aEmployees[ counterDoc, 5 ] += 1
					endif
					aServices[ counter, 2 ] += itemService:Quantity
					aServices[ counter, 3 ] += itemService:Total
					aEmployees[ counterDoc, 4 ] := aServices
					quantity[ iif( isDoctor, 1, 2 ) ] += itemService:Quantity
					total[ iif( isDoctor, 1, 2 ) ] += itemService:Total
					aSubdivisions[ counterSub, 2 ] += itemService:Quantity
					aSubdivisions[ counterSub, 3 ] += itemService:Total

				endif
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	aEmployees := {}
	aServices := {}

	for each itemSubdivision in aSubdivisions
		flagSubdivision := .f.
		rowspanService := lstr( itemSubdivision[ 6 ] + itemSubdivision[ 5 ] )
		aEmployees := itemSubdivision[ 4 ]
		asort( aEmployees, , , {| x, y | x[ 1 ] < y[ 1 ] } )

		for each itemEmployee in aEmployees
			flagEmployee := .f.
			rowspanEmployee := lstr( itemEmployee[ 5 ] )
			aServices := itemEmployee[ 4 ]
			asort( aServices, , , {| x, y | x[ 4 ] < y[ 4 ] } )
			
			iRowService := 0
			for each itemService in aServices
				iRowService += 1
				oRow       := oTable + 'tr'
		
				if ! flagSubdivision
					// 1-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanService + '"'
					oCell:text := itemSubdivision[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					
					// 2-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanService + '"'
					oCell:text := lstr( itemSubdivision[ 2 ] )
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					// 3-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="right" rowspan="' + rowspanService + '"'
					oCell:text := put_kopE( itemSubdivision[ 3 ], 15 )
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					
					flagSubdivision := .t.
				endif
				if ! flagEmployee
					// 4-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanEmployee + '"'
					oCell:text := itemEmployee[ 1 ]
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					flagEmployee := .t.
				endif

				if iRowService == len( aServices )
					strClass := 'class="td1"'
					strClass1 := 'class="td3"'
				else
					strClass := 'class="td11"'
					strClass1 := 'class="td31"'
				endif
				
				// 5-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="left"'
				oCell:text := itemService[ 4 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 6-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="left"'
				oCell:text := itemService[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 7-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass + ' valign="center" align="center"'
				oCell:text := lstr( itemService[ 2 ] ) 
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 8-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= strClass1 + ' valign="center" align="right"'
				oCell:text := put_kopE( itemService[ 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				
				if iRowService == len( aServices )
					oRow       := oTable + 'tr'
					// 6-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1 subtotal" valign="center" align="right" colspan="3"'
					oCell:text := '����� �� ����������:'
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					
					// 7-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td1 subtotal" valign="center" align="center"'
					oCell:text := lstr( itemEmployee[ 2 ] ) 
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
					
					// 8-� �������
					oCell      := oRow + 'td'
					oCell:attr	:= 'class="td3 subtotal" valign="center" align="right"'
					oCell:text := put_kopE( itemEmployee[ 3 ], 15 )
					oCell      := oCell - 'td'
					HB_SYMBOL_UNUSED( oCell )
				endif
			next
			
		next
	next
//
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	
	return nil
	
* 21.08.18 ����������� ������ �� ������ ����� �� ���������� � �������
function StatisticsByDepartmentAndServiceHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ����� �� ���������� � �������' }
	local aContracts := {}, aServices := {}, aSubdivisions := {}
	local item, itemService, iRow
	local stService := '', counter := 0
	local stSub, counterSub := 0
	local quantity := 0,	total := 0

	oDoc := CreateReportHTML( '����� ����� �� ���������� � �������' )
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
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright" colspan="4"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-��'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	HB_SYMBOL_UNUSED( oTH )

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			for each itemService in item:Services()
				if itemService:Subdivision != nil
					stSub := itemService:Subdivision:Name1251
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// ������ aSubdivisions {��������, ����� ����������, ����� �����, ������ �����, ���������� �����}
						aadd( aSubdivisions, { stSub, 0, 0, {}, 0 } )
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					aServices := aSubdivisions[ counterSub, 4 ]
					
					if itemService:Service != nil
						stService := alltrim( itemService:Service:Name1251 )
					endif
					if ( counter := hb_ascan( aServices, { | x | x[ 1 ] == stService } ) ) == 0
						// ������ aServices {������, ����� ����������, ����� �����, ��� ������}
						aadd( aServices, { stService, 0, 0, itemService:Service:Shifr1251 } )
						counter := hb_ascan( aServices, { | x | x[ 1 ] == stService } )
						aSubdivisions[ counterSub, 5 ] += 1
					endif
					aServices[ counter, 2 ] += itemService:Quantity
					aServices[ counter, 3 ] += itemService:Total
					quantity += itemService:Quantity
					total += itemService:Total
					aSubdivisions[ counterSub, 2 ] += itemService:Quantity
					aSubdivisions[ counterSub, 3 ] += itemService:Total
					aSubdivisions[ counterSub, 4 ] := aServices
				endif
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each item in aSubdivisions
		rowspan := lstr( item[ 5 ] )
		
		if item[ 5 ] == 1
			strClass := 'class="td1"'
		else
			strClass := 'class="td11"'
		endif
		// 1-� �������
		oRow       := oTable + 'tr'
		
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspan + '"'
		oCell:text := item[ 1 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="left"'
		oCell:text := item[ 4 ][ 1, 4 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="left"'
		oCell:text := item[ 4 ][ 1, 1 ]
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="center"'
		oCell:text := lstr( item[ 4 ][ 1, 2 ] ) 
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		if item[ 5 ] == 1
			strClass := 'class="td3"'
		else
			strClass := 'class="td31"'
		endif
		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= strClass + ' valign="center" align="right"'
		oCell:text := put_kopE( item[ 4 ][ 1, 3 ], 15 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		for iRow = 2 to item[ 5 ]
			if iRow == item[ 5 ]
				strClass := 'class="td1"'
			else
				strClass := 'class="td11"'
			endif
			oRow		:= oTable + 'tr'

			// 2-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := item[ 4 ][ iRow, 4 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 3-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := item[ 4 ][ iRow, 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := lstr( item[ 4 ][ iRow, 2 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			if item[ 5 ] == iRow
				strClass := 'class="td3"'
			else
				strClass := 'class="td31"'
			endif
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="right"'
			oCell:text := put_kopE( item[ 4 ][ iRow, 3 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next

	next
//
	// ������ ������
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
	oCell:text := lstr( quantity )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( total, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil

* 26.09.18 ����������� ������ �� ������ ����� �� ���������� � �����������
function StatisticsByDepartmentAndDoctorHTML( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ����� �� ���������� � �����������' }
	local aContracts := {}, aEmployees := {}, aSubdivisions := {}
	local item, itemService, iRow
	local stEmployee := '', counter := 0
	local stSub, counterSub := 0
	local quantity := { 0, 0 },	total := { 0, 0 }
	local isDoctor := .t.
	local itemSubdivision, itemEmployee
	local rowspanSubdivision := '1'
	local flagSubdivision := .f.
	local iRowEmployee
	local strClass, strClass1

	oDoc := CreateReportHTML( '����� ����� �� ���������� � �����������' )
	CreateHeaderHTMLReport( oDoc, aTitle, aHash )

	/* Operator ":" returns first "table" from body (creates if not existent) */
	oTable        := oDoc:body + 'table'
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
//
	HB_SYMBOL_UNUSED( oTH )

	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
				
			for each itemService in item:Services()
				if ! isnil( itemService:Subdivision )
					stSub := itemService:Subdivision:Name1251
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// ������ aSubdivisions {��������, ����� ����������, ����� �����, ������ �����������, ���������� �����������}
						aadd( aSubdivisions, { stSub, 0, 0, {}, 0 } )
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					aEmployees := aSubdivisions[ counterSub, 4 ]
					
					if ! isnil( itemService:Doctor )
						stEmployee := '[' + lstr( itemService:Doctor:TabNom ) + '] ' + alltrim( itemService:Doctor:FIO1251 )
						isDoctor := .t.
					elseif ! isnil( itemService:Assistant )
						stEmployee := '[' + lstr( itemService:Assistant:TabNom ) + '] ' + alltrim( itemService:Assistant:FIO1251 )
						isDoctor := .f.
					else
						stEmployee := '����������� ���������'
						isDoctor := .f.
					endif
					if ( counter := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } ) ) == 0
						// ������ aEmployees {���������, ����� ����������, ����� �����}
						aadd( aEmployees, { stEmployee, 0, 0, isDoctor } )
						counter := hb_ascan( aEmployees, { | x | x[ 1 ] == stEmployee } )
						aSubdivisions[ counterSub, 5 ] += 1
					endif
					aEmployees[ counter, 2 ] += itemService:Quantity
					aEmployees[ counter, 3 ] += itemService:Total
					quantity[ iif( isDoctor, 1, 2) ] += itemService:Quantity
					total[ iif( isDoctor, 1, 2) ] += itemService:Total
					aSubdivisions[ counterSub, 2 ] += itemService:Quantity
					aSubdivisions[ counterSub, 3 ] += itemService:Total
					aSubdivisions[ counterSub, 4 ] := aEmployees
				endif
			next
		endif
	next
	asort( aSubdivisions, , , {| x, y | x[ 1 ] < y[ 1 ] } )
	
	for each itemSubdivision in aSubdivisions
		flagSubdivision := .f.
		rowspanSubdivision := lstr( itemSubdivision[ 5 ] )
		aEmployees := itemSubdivision[ 4 ]
		iRowEmployee := 0
		
		for each itemEmployee in aEmployees
			iRowEmployee += 1
			oRow       := oTable + 'tr'
			if iRowEmployee == len( aEmployees )
				strClass := 'class="td1"'
				strClass1 := 'class="td3"'
			else
				strClass := 'class="td11"'
				strClass1 := 'class="td31"'
			endif
			
			if ! flagSubdivision
				// 1-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
				oCell:text := itemSubdivision[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				flagSubdivision := .t.
			endif
			// 2-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemEmployee[ 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 3-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := iif( itemEmployee[ 4 ], '����', '���.' )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := lstr( itemEmployee[ 2 ] ) 
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 5-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass1 + ' valign="center" align="right"'
			oCell:text := put_kopE( itemEmployee[ 3 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		next
	next
//

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

* 07.09.18 ����������� ������ �� ������ ����� �� ���������� (��� �����)
function StatisticsByDepartmentMainHTML( aHash)
	local oDoc, oNode, oTable, oRow, oCell, oHTable
	local aTitle := { '����� ������ �� ����������' }
	local aContracts := {}, aDepartments := {}, aSubdivisions := {}
	local itemDepartment, itemSubdivision
	local rowspanSubdivision := "1"
	local flagDepartment := .f., flagDepartmentAdd := .f.
	local iRowSubdivision
	
	local item, itemService, iRow
	local stDep := '', counter := 0
	local stSub, counterSub := 0
	local totalQuantity := 0, totalSumm := 0
	
	oDoc := CreateReportHTML( '����� ����� �� ����������' )
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
	oParag:text		:= '�������������'
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
	// 3-�, 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� �� ���������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	// 5-�, 6-z �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft-wo-bottom thright" colspan="2"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� �� �����������'
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
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���-�� �����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell     := oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��������� �����'
	oParag			:= oParag - 'p'
	oCell     := oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH				:= oTH - 'tr'
	HB_SYMBOL_UNUSED( oTH )
	
	aContracts := SelectContractsForStatistic( aHash['TYPEDATE'], aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ] )
	for each item in aContracts
	
		if ascan( aHash[ 'PAYMENTMETHODS' ], item:TypeService ) > 0 ;
				.and. if( hb_user_curUser:IsAdmin(), IDHasArrayObjects( aHash[ 'SELECTEDDEPARTMENT' ], item:Department:ID ), ;
				IDHasArrayObjects( aHash[ 'SELECTEDSUBDIVISION' ], item:Subdivision:ID ) )
			if item:Department != nil
				stDep := alltrim( item:Department:Name1251 )
				if ( counter := hb_ascan( aDepartments, { | x | x[ 1 ] == stDep } ) ) == 0
					quantity := 0
					total := 0
					// ������ aDepartments {������������, ����� ����������, ����� �����, ������ �������������, ����� �������������}
					aadd( aDepartments, { stDep, 0, 0, {}, 0 } )
					counter := hb_ascan( aDepartments, { | x | x[ 1 ] == stDep } )
				endif
				quantity := aDepartments[ counter, 2 ]
				total := aDepartments[ counter, 3 ]
				aSubdivisions := aDepartments[ counter, 4 ]
				
				for each itemService in item:Services()
					stSub := alltrim( itemService:Subdivision:Name1251 )
					if ( counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } ) ) == 0
						// ������ aSubdivisions {������������, ����� ����������, ����� �����}
						aadd( aSubdivisions, { stSub, 0, 0 } )
						aDepartments[ counter, 5 ] += 1
						counterSub := hb_ascan( aSubdivisions, { | x | x[ 1 ] == stSub } )
					endif
					aSubdivisions[ counterSub, 2 ] += itemService:Quantity
					aSubdivisions[ counterSub, 3 ] += itemService:Total
					quantity += itemService:Quantity
					total += itemService:Total
				next
				aDepartments[ counter, 2 ] := quantity
				aDepartments[ counter, 3 ] := total
				aDepartments[ counter, 4 ] := aSubdivisions
				
			endif
		endif
	next
	asort( aDepartments, , , {| x, y | x[ 1 ] < y[ 1 ] } )

	for each itemDepartment in aDepartments
		flagDepartment := .f.
		flagDepartmentAdd := .f.
		rowspanSubdivision := lstr( itemDepartment[ 5 ] )
		aSubdivisions := itemDepartment[ 4 ]
		
		iRowSubdivision := 0
		for each itemSubdivision in aSubdivisions
			iRowSubdivision += 1
			if iRowSubdivision == len( aSubdivisions )
				strClass := 'class="td1"'
			else
				strClass := 'class="td11"'
			endif
			oRow       := oTable + 'tr'
			
			if ! flagDepartment
				// 1-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="left" rowspan="' + rowspanSubdivision + '"'
				oCell:text := itemDepartment[ 1 ]
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				flagDepartment := .t.
				totalQuantity += itemDepartment[ 2 ]
				totalSumm += itemDepartment[ 3 ]
			endif
			// 2-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="left"'
			oCell:text := itemSubdivision[ 1 ]
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
		
			// 3-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="center"'
			oCell:text := lstr( itemSubdivision[ 2 ] )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			// 4-� �������
			oCell      := oRow + 'td'
			oCell:attr	:= strClass + ' valign="center" align="right"'
			oCell:text := put_kopE( itemSubdivision[ 3 ], 15 )
			oCell      := oCell - 'td'
			HB_SYMBOL_UNUSED( oCell )
			
			if ! flagDepartmentAdd
				// 5-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td1" valign="center" align="center" rowspan="' + rowspanSubdivision + '"'
				oCell:text := lstr( itemDepartment[ 2 ] )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				
				// 6-� �������
				oCell      := oRow + 'td'
				oCell:attr	:= 'class="td3" valign="center" align="right" rowspan="' + rowspanSubdivision + '"'
				oCell:text := put_kopE( itemDepartment[ 3 ], 15 )
				oCell      := oCell - 'td'
				HB_SYMBOL_UNUSED( oCell )
				flagDepartmentAdd := .t.
			endif
	
		next
	next
	
	// ������ ������
	oRow	:= oTable + 'tr'
	// 2-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="total" valign="center" align="right" colspan="4"'
	oCell:text := '� � � � �:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td1 total" valign="center" align="center"'
	oCell:text := totalQuantity
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell      := oRow + 'td'
	oCell:attr	:= 'class="td3 total" valign="center" align="right"'
	oCell:text := put_kopE( totalSumm, 15 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oTable        := oTable - 'table'
	
	ViewHTML( oDoc )
	return nil
	
* 08.09.18 ������� ��������� �� ��
function SelectContractsForStatistic( type, dateBegin, dateEnd )
	local aContracts := {}

	if type == 1		// �� ���� �������
		aContracts := TContractDB():getListContractByDateService( dateBegin, dateEnd )
	elseif type == 2	// �� ���� ��������� �������
		aContracts := TContractDB():getListContractByEndTreatment( dateBegin, dateEnd )
	elseif type == 3	// �� ���� �������� �/�����
		aContracts := TContractDB():getListContractByDateCloseLU( dateBegin, dateEnd )
	endif
	return aContracts
