#include 'hbclass.ch'
#include 'property.ch'
#include 'hbhash.ch' 
#include 'common.ch'
#include 'function.ch'

// класс для строки состава услуг по платному договору файл hum_p_u.dbf
CREATE CLASS TContractService	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDLU AS NUMERIC READ getIDLU WRITE setIDLU						// идентификатор листа учета из hum_p.dbf
		PROPERTY Date AS DATE READ getDate WRITE setDate							// дата оказания услуги
		PROPERTY Price AS NUMERIC READ getPrice WRITE setPrice
		PROPERTY Coefficient AS NUMERIC READ getCoefficient WRITE setCoefficient	// коэф-т индексации услуги
		PROPERTY Quantity AS NUMERIC READ getQuantity WRITE setQuantity			// количество услуг
		PROPERTY Total AS NUMERIC READ getTotal WRITE setTotal					// итоговая стоимость услуги
		PROPERTY IsEdit AS LOGICAL READ getIsEdit WRITE setIsEdit				// признак редактирования суммы
		PROPERTY Service AS OBJECT READ getService WRITE setService				// оказанная услуга
		PROPERTY Subdivision AS OBJECT READ getSubdivision WRITE setSubdivision	// отделение где проводили услугу
		PROPERTY IDSubdivision AS NUMERIC READ getIDSubdivision	// ID отделение где проводили услугу
		PROPERTY Doctor AS OBJECT INDEX 1 READ getExecutor WRITE setExecutor		// доктор проводивший услугу
		PROPERTY IDDoctor AS NUMERIC INDEX 1 READ getIDExecutor					// ID доктор проводивший услугу
		PROPERTY Assistant AS OBJECT INDEX 2 READ getExecutor WRITE setExecutor	// ассистент проводивший услугу
		PROPERTY IDAssistant AS NUMERIC INDEX 2 READ getIDExecutor	// ID ассистент проводивший услугу
		PROPERTY Nurse1 AS OBJECT INDEX 3 READ getExecutor WRITE setExecutor		// сестра 1 участвовавшая в оказании услуги
		PROPERTY Nurse2 AS OBJECT INDEX 4 READ getExecutor WRITE setExecutor		// сестра 2 участвовавшая в оказании услуги
		PROPERTY Nurse3 AS OBJECT INDEX 5 READ getExecutor WRITE setExecutor		// сестра 3 участвовавшая в оказании услуги
		PROPERTY Aidman1 AS OBJECT INDEX 6 READ getExecutor WRITE setExecutor		// санитар 1 участвовавший в оказании услуги
		PROPERTY Aidman2 AS OBJECT INDEX 7 READ getExecutor WRITE setExecutor		// санитар 2 участвовавший в оказании услуги
		PROPERTY Aidman3 AS OBJECT INDEX 8 READ getExecutor WRITE setExecutor		// санитар 3 участвовавший в оказании услуги
		PROPERTY IDNurse1 AS NUMERIC INDEX 3 READ getIDExecutor 		// ID сестра 1 участвовавшая в оказании услуги
		PROPERTY IDNurse2 AS NUMERIC INDEX 4 READ getIDExecutor 		// ID сестра 2 участвовавшая в оказании услуги
		PROPERTY IDNurse3 AS NUMERIC INDEX 5 READ getIDExecutor 		// ID сестра 3 участвовавшая в оказании услуги
		PROPERTY IDAidman1 AS NUMERIC INDEX 6 READ getIDExecutor		// ID санитар 1 участвовавший в оказании услуги
		PROPERTY IDAidman2 AS NUMERIC INDEX 7 READ getIDExecutor		// ID санитар 2 участвовавший в оказании услуги
		PROPERTY IDAidman3 AS NUMERIC INDEX 8 READ getIDExecutor		// ID санитар 3 участвовавший в оказании услуги
		PROPERTY ExecuterFIO READ getExecuterFIO

		PROPERTY Date_F READ getDateFormat
		PROPERTY Service_F READ getServiceFormat
		PROPERTY Subdivision_F READ getSubdivisionFormat
		PROPERTY Service_Name_F READ getServiceNameFormat
		PROPERTY Doctor_F READ getDoctorFormat
		PROPERTY Assistant_F READ getAssistantFormat
		PROPERTY Quantity_F AS STRING READ getQuantityFormat
		PROPERTY Total_F AS STRING READ getTotalFormat
		
		METHOD New( nID, lNew, lDeleted )
		METHOD forJSON()
		METHOD IsParticipant( param )								// сотрудник участвовал в оказании услуги
	HIDDEN:
		DATA FIDLU			INIT 0
		DATA FDate			INIT ctod( '' )
		DATA FPrice			INIT 0.0
		DATA FCoefficient	INIT 0.0
		DATA FQuantity		INIT 0.0
		DATA FTotal			INIT 0.0
		DATA FIsEdit		INIT .f.
		DATA FService		INIT nil
		DATA FSubdivision	INIT nil
		DATA FIDSubdivision	INIT 0
		DATA FExecutor		INIT { nil, nil, nil, nil, nil, nil, nil, nil }
		DATA FIDExecutor	INIT { 0, 0, 0, 0, 0, 0, 0, 0 }
		
		METHOD getIDLU
		METHOD setIDLU( param )
		METHOD getDate
		METHOD setDate( param )
		METHOD getPrice
		METHOD setPrice( param )
		METHOD getCoefficient
		METHOD setCoefficient( param )
		METHOD getQuantity
		METHOD setQuantity( param )
		METHOD getTotal
		METHOD setTotal( param )
		METHOD getIsEdit
		METHOD setIsEdit( lValue )
		METHOD getService
		METHOD setService( param )
		METHOD getSubdivision
		METHOD setSubdivision( param )
		METHOD getIDSubdivision
		METHOD getExecutor( nIndex )
		METHOD getIDExecutor( nIndex )
		METHOD setExecutor( nIndex, param )
		METHOD getExecuterFIO
		
		METHOD getDateFormat
		METHOD getServiceFormat
		METHOD getServiceNameFormat
		METHOD getSubdivisionFormat
		METHOD getDoctorFormat
		METHOD getAssistantFormat
		METHOD getQuantityFormat
		METHOD getTotalFormat
ENDCLASS

METHOD function getQuantityFormat CLASS TContractService
	local ret := ''
	
	ret := put_val( ::FQuantity, 3 )
	return ret

METHOD function getTotalFormat CLASS TContractService
	local ret := ''
	
	ret := put_val( ::FTotal, 8 )
	return ret

METHOD function getDoctorFormat CLASS TContractService
	local ret := ''
	
	if ! isnil( ::FExecutor[ 1 ] )
		ret := put_val( ::FExecutor[ 1 ]:TabNom, 6 )
	elseif ::FIDExecutor[ 1 ] > 0
		ret := put_val( ::Doctor:TabNom, 6 )
	endif
	return ret

METHOD function getAssistantFormat CLASS TContractService
	local ret := ''
	
	if ! isnil( ::FExecutor[ 2 ] )
		ret := put_val( ::FExecutor[ 2 ]:TabNom, 4 )
	elseif ::FIDExecutor[ 2 ] > 0
		ret := put_val( ::Assistant:TabNom, 4 )
	endif
	return ret

METHOD function getSubdivisionFormat CLASS TContractService
	local ret := ''
	
	if isnil( ::FSubdivision )
		::FSubdivision := if( ::IDSubdivision == 0, nil, TSubdivisionDB():getByID( ::IDSubdivision ) )
	endif
	return if( isnil( ::FSubdivision ), '', ::FSubdivision:ShortName )

METHOD function getServiceNameFormat CLASS TContractService
	local ret := ''
	
	if ! isnil( ::FService )
		ret := left( ::FService:Name, 16 )
	endif
	return ret

METHOD function getServiceFormat CLASS TContractService
	local ret := ''
	
	if ! isnil( ::FService )
		ret := ::FService:Shifr
	endif
	return ret

METHOD function getDateFormat CLASS TContractService
	return left( dtoc( ::FDate ), 5 )

METHOD function IsParticipant( param )	 			CLASS TContractService
	local ret := .f., nTabNom := 0, item
	
	if isnil( param )
		return ret
	elseif isnumber( param ) .and. param >= 0
		nTabNom := param
	elseif isobject( param ) .and. ( param:ClassName() == upper( 'TEmployee' ) )
		nTabNom := param:TabNom
	endif
	
	for each item in ::FExecutor
		if ! isnil( item ) .and. ( nTabNom == item:TabNom )
			ret := .t.
			exit
		endif
	next
	return ret

METHOD function getIDLU() CLASS TContractService
	return ::FIDLU

METHOD procedure setIDLU( param ) CLASS TContractService
	if param > 0
		::FIDLU := param
	endif
	return
	
METHOD function getDate() CLASS TContractService
	return ::FDate

METHOD procedure setDate( param ) CLASS TContractService

	if isdate( param )
		::FDate := param
	endif
	return
	
METHOD function getPrice() CLASS TContractService
	return ::FPrice

METHOD procedure setPrice( param ) CLASS TContractService
	if param > 0
		::FPrice := param
	endif
	return
	
METHOD function getCoefficient() CLASS TContractService
	return ::FCoefficient

METHOD procedure setCoefficient( param ) CLASS TContractService
	if param > 0
		::FCoefficient := param
	endif
	return
	
METHOD function getQuantity() CLASS TContractService
	return ::FQuantity

METHOD procedure setQuantity( param ) CLASS TContractService
	if param > 0
		::FQuantity := param
	endif
	return
	
METHOD function getTotal() CLASS TContractService
	return ::FTotal

METHOD procedure setTotal( param ) CLASS TContractService
	if param > 0
		::FTotal := param
	endif
	return
	
METHOD function getIsEdit() CLASS TContractService
	return ::FIsEdit

METHOD procedure setIsEdit( lValue ) CLASS TContractService
	::FIsEdit := lValue
	return
	
METHOD function getService() CLASS TContractService
	return ::FService

METHOD procedure setService( param ) CLASS TContractService
	
	if isnumber( param ) .and. param >= 0
		::FService := TServiceDB():getByID( param )
	elseif ( isobject( param ) .and. param:ClassName() == upper( 'TService' ) ) .or. isnil( param )
		::FService := param
	endif
	return
	
METHOD function getSubdivision() CLASS TContractService
	
	if isnil( ::FSubdivision )
		::FSubdivision := if( ::IDSubdivision == 0, nil, TSubdivisionDB():getByID( ::IDSubdivision ) )
	endif
	return ::FSubdivision

METHOD procedure setSubdivision( param ) CLASS TContractService
	if isnumber( param ) .and. param >= 0
		::FSubdivision := nil
		::FIDSubdivision := param
	elseif ( isobject( param ) .and. param:ClassName() == upper( 'TSubdivision' ) ) .or. ! isnil( param )
		::FSubdivision := nil
		::FIDSubdivision := param:ID
	elseif isnil( param )
		::FSubdivision := nil
		::FIDSubdivision := 0
	endif
	return

METHOD function getIDSubdivision() CLASS TContractService
	return ::FIDSubdivision

METHOD function getExecutor( nIndex )		 CLASS TContractService
	
	if isnil( ::FExecutor[ nIndex ] ) .and. ( ::FIDExecutor[ nIndex ] > 0 )
		::FExecutor[ nIndex ] := TEmployeeDB():GetByID( ::FIDExecutor[ nIndex ] )
	endif
	return ::FExecutor[ nIndex ]

METHOD function getIDExecutor( nIndex )		 CLASS TContractService
	return ::FIDExecutor[ nIndex ]

METHOD procedure setExecutor( nIndex, param )		 CLASS TContractService
	local obj := nil
	
	&& if isnumber( param ) .and. param >= 0
		&& obj := TEmployeeDB():GetByID( param )
	&& elseif ( isobject( param ) .and. param:ClassName() == upper( 'TEmployee' ) ) .or. isnil( param )
		&& obj := param
	&& else
		&& return
	&& endif
	&& ::FExecutor[ nIndex ] := obj
	if isnumber( param ) .and. param >= 0
		::FIDExecutor[ nIndex ] := param
		::FExecutor[ nIndex ] := nil
	elseif ( isobject( param ) .and. param:ClassName() == upper( 'TEmployee' ) ) .or. ! isnil( param )
		::FIDExecutor[ nIndex ] := param:ID
		::FExecutor[ nIndex ] := nil
		obj := param
	else
		::FIDExecutor[ nIndex ] := 0
		::FExecutor[ nIndex ] := nil
	endif
	return

METHOD function getExecuterFIO			 CLASS TContractService
	local ret := ''
	
	if ::FService:WithDoctor .and. ( ::FExecutor[ 1 ] != nil )
		ret := ::FExecutor[ 1 ]:FIO
	elseif ::FService:WithAssistant .and. ( ::FExecutor[ 2 ] != nil )
		ret := ::FExecutor[ 2 ]:FIO
	endif
	return ret

METHOD New( nID, lNew, lDeleted ) CLASS TContractService

	::super:new( nID, lNew, lDeleted )
	return self

METHOD function forJSON()    CLASS TContractService
	local hItem

	hItem := { => }
	hb_HSet( hItem, 'Date', dtoc( ::Date ) )
	hb_HSet( hItem, 'Service', alltrim( ::Service:Name ) )
	hb_HSet( hItem, 'Price', ltrim( str( ::Price ) ) )
	hb_HSet( hItem, 'Quantity', ltrim( str( ::Quantity ) ) )
	hb_HSet( hItem, 'Total', ltrim( str( ::Total ) ) )
	if ::Subdivision != nil
		hb_HSet( hItem, 'Subdivision', ::Subdivision:forJSON() )
	endif
	if ::Doctor != nil
		hb_HSet( hItem, 'Doctor', ::Doctor:forJSON() )
	endif
	if ::Assistant != nil
		hb_HSet( hItem, 'Assistant', ::Assistant:forJSON() )
	endif
	return hItem
