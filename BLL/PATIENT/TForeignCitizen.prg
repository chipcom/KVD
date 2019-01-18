#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TForeignCitizen	INHERIT	TBaseObjectBLL
	VISIBLE:
		CLASSDATA	aMenuBaseOfStay	AS ARRAY	INIT { ; // Основания пребывания в РФ
												{ 'ВЖ (вид на жительство)', 1 }, ;
												{ 'РВП (разрешение на временнное пребывание)', 0 }, ;
												{ 'Миграционная карта', 2 }, ;
												{ 'Туристическая виза', 3 }, ;
												{ 'Медицинская виза', 4 }, ; 
												{ 'Гостевая виза', 5 }, ;
												{ 'Деловая виза', 6 }, ;
												{ 'Транзитная виза', 7 }, ;
												{ 'Студенческая виза', 8 }, ;
												{ 'Рабочая виза', 9 }, ;
												{ 'Другая виза', 10 } }

		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient
		PROPERTY BaseOfStay AS NUMERIC READ getBaseOfStay WRITE setBaseOfStay	// основание пребывания в РФ
		PROPERTY AddressRegistration AS STRING READ getAddressRegistration WRITE setAddressRegistration	// адрес проживания в Волг.обл.
		PROPERTY MigrationCard AS STRING READ getMigrationCard WRITE setMigrationCard	// данные миграционной карты
		PROPERTY DateBorderCrossing AS DATE READ getDateBorderCrossing WRITE setDateBorderCrossing	// дата пересечения границы
		PROPERTY DateRegistration AS DATE READ getDateRegistration WRITE setDateRegistration	// дата регистрации в МВД

		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDPatient INIT 0
		DATA FBaseOfStay INIT 0
		DATA FAddressRegistration INIT space( 60 )
		DATA FMigrationCard INIT space( 20 )
		DATA FDateBorderCrossing INIT ctod( '' )
		DATA FDateRegistration INIT ctod( '' )

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getBaseOfStay
		METHOD setBaseOfStay( param )
		METHOD getAddressRegistration
		METHOD setAddressRegistration( param )
		METHOD getMigrationCard
		METHOD setMigrationCard( param )
		METHOD getDateBorderCrossing
		METHOD setDateBorderCrossing( param )
		METHOD getDateRegistration
		METHOD setDateRegistration( param )
ENDCLASS

METHOD function getIDPatient()		CLASS TForeignCitizen
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TForeignCitizen
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getBaseOfStay()		CLASS TForeignCitizen
	return ::FBaseOfStay

METHOD procedure setBaseOfStay( param )		CLASS TForeignCitizen
	
	if isnumber( param )
		::FBaseOfStay := param
	endif
	return

METHOD function getAddressRegistration()		CLASS TForeignCitizen
	return ::FAddressRegistration

METHOD procedure setAddressRegistration( param )		CLASS TForeignCitizen
	
	if ischaracter( param )
		::FAddressRegistration := param
	endif
	return

METHOD function getMigrationCard()		CLASS TForeignCitizen
	return ::FMigrationCard

METHOD procedure setMigrationCard( param )		CLASS TForeignCitizen
	
	if ischaracter( param )
		::FMigrationCard := param
	endif
	return

METHOD function getDateBorderCrossing()		CLASS TForeignCitizen
	return ::FDateBorderCrossing

METHOD procedure setDateBorderCrossing( param )		CLASS TForeignCitizen
	
	if isdate( param )
		::FDateBorderCrossing := param
	endif
	return

METHOD function getDateRegistration()		CLASS TForeignCitizen
	return ::FDateRegistration

METHOD procedure setDateRegistration( param )		CLASS TForeignCitizen
	
	if isdate( param )
		::FDateRegistration := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TForeignCitizen

	::super:new( nID, lNew, lDeleted )
	return self
