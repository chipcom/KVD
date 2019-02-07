#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TRepresentative	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient	// ID пациента
		PROPERTY Number AS NUMERIC READ getNumber WRITE setNumber			// номер представителя
		PROPERTY FIO AS STRING READ getFIO WRITE setFIO						// Ф.И.О.
		PROPERTY Status AS NUMERIC READ getStatus WRITE setStatus			// Cтатус сопр.лица: 0-прочий,1-родитель,2-опекун
		PROPERTY IsCare AS LOGICAL READ getIsCare WRITE setIsCare			// .f.(0)-нет, .t.(1)-по уходу за больным
		PROPERTY HasFood AS LOGICAL READ getHasFood WRITE setHasFood			// .f.(0)-нет, .t.(1)-с питанием
		PROPERTY DOB AS DATE READ getDOB WRITE setDOB							// дата рождения
		PROPERTY Address AS STRING READ getAddress WRITE setAddress			// адрес
		PROPERTY PlaceOfWork AS STRING READ getPlaceOfWork WRITE setPlaceOfWork	// место работы
		PROPERTY Phone AS STRING READ getPhone WRITE setPhone				// контактный телефон
		PROPERTY Passport AS STRING READ getPassport WRITE setPassport		// паспортные данные
		PROPERTY Policy AS STRING READ getPolicy WRITE setPolicy				// данные о страховом полисе
		
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDPatient INIT 0
		DATA FNumber INIT 0
		DATA FFIO INIT space( 50 )
		DATA FStatus INIT 0
		DATA FIsCare INIT .f.
		DATA FHasFood INIT .f.
		DATA FDOB INIT ctod( '' )
		DATA FAddress INIT space( 50 )
		DATA FPlaceOfWork INIT space( 50 )
		DATA FPhone INIT space( 11 )
		DATA FPassport INIT space( 15 )
		DATA FPolicy INIT space( 25 )

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getNumber
		METHOD setNumber( param )
		METHOD getFIO
		METHOD setFIO( param )
		METHOD getStatus
		METHOD setStatus( param )
		METHOD getIsCare
		METHOD setIsCare( param )
		METHOD getHasFood
		METHOD setHasFood( param )
		METHOD getDOB
		METHOD setDOB( param )
		METHOD getAddress
		METHOD setAddress( param )
		METHOD getPlaceOfWork
		METHOD setPlaceOfWork( param )
		METHOD getPhone
		METHOD setPhone( param )
		METHOD getPassport
		METHOD setPassport( param )
		METHOD getPolicy
		METHOD setPolicy( param )
ENDCLASS

METHOD function getPolicy()		CLASS TRepresentative
	return ::FPolicy

METHOD procedure setPolicy( param )		CLASS TRepresentative
	
	if ischaracter( param )
		::FPolicy := param
	endif
	return

METHOD function getPassport()		CLASS TRepresentative
	return ::FPassport

METHOD procedure setPassport( param )		CLASS TRepresentative
	
	if ischaracter( param )
		::FPassport := param
	endif
	return

METHOD function getPhone()		CLASS TRepresentative
	return ::FPhone

METHOD procedure setPhone( param )		CLASS TRepresentative
	
	if ischaracter( param )
		::FPhone := param
	endif
	return

METHOD function getPlaceOfWork()		CLASS TRepresentative
	return ::FPlaceOfWork

METHOD procedure setPlaceOfWork( param )		CLASS TRepresentative
	
	if ischaracter( param )
		::FPlaceOfWork := param
	endif
	return

METHOD function getAddress()		CLASS TRepresentative
	return ::FAddress

METHOD procedure setAddress( param )		CLASS TRepresentative
	
	if ischaracter( param )
		::FAddress := param
	endif
	return

METHOD function getDOB()		CLASS TRepresentative
	return ::FDOB

METHOD procedure setDOB( param )		CLASS TRepresentative
	
	if isdate( param )
		::FDOB := param
	endif
	return

METHOD function getHasFood()		CLASS TRepresentative
	return ::FHasFood

METHOD procedure setHasFood( param )		CLASS TRepresentative
	
	if islogical( param )
		::FHasFood := param
	endif
	return

METHOD function getIsCare()		CLASS TRepresentative
	return ::FIsCare

METHOD procedure setIsCare( param )		CLASS TRepresentative
	
	if islogical( param )
		::FIsCare := param
	endif
	return

METHOD function getStatus()		CLASS TRepresentative
	return ::FStatus

METHOD procedure setStatus( param )		CLASS TRepresentative
	
	if isnumber( param )
		::FStatus := param
	endif
	return

METHOD function getNumber()		CLASS TRepresentative
	return ::FNumber

METHOD procedure setNumber( param )		CLASS TRepresentative
	
	if isnumber( param )
		::FNumber := param
	endif
	return

METHOD function getIDPatient()		CLASS TRepresentative
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TRepresentative
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getFIO()		CLASS TRepresentative
	return ::FFIO

METHOD procedure setFIO( param )		CLASS TRepresentative
	
	if ischaracter( param )
		::FFIO := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TRepresentative

	::super:new( nID, lNew, lDeleted )
	return self