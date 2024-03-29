#include 'hbclass.ch'
#include 'property.ch'
#include 'hbhash.ch'
#include 'common.ch'

********************************
// класс для строки дополнений о плательщике платного договора файл hum_plat.dbf
CREATE CLASS TContractPayer	INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY IDLU AS NUMERIC READ getIDLU WRITE setIDLU				// код листа учета (по БД hum_p)
		PROPERTY Address AS STRING READ getAddress WRITE setAddress		// Адрес плательщика
		PROPERTY Passport AS STRING READ getPassport WRITE setPassport	// Паспорт плательщика
		PROPERTY EMail AS STRING READ getEmail WRITE setEmail			// электронная почта
		PROPERTY Phone AS STRING READ getPhone WRITE setPhone			// телефон
		PROPERTY Kemvyd AS NUMERIC READ getKemvyd WRITE setKemvyd			// кем выдан
		PROPERTY Datevyd AS Date READ getDatevyd WRITE setDatevyd			// дата выдачи

		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FIDLU		INIT 0
		DATA FAddress	INIT space( 50 )
		DATA FPassport	INIT space( 15 )
		DATA FEmail		INIT space( 30 )
		DATA FPhone		INIT space( 11 )
		DATA FKemvyd	INIT 0
		DATA FDatevyd INIT ctod('')
		
		METHOD getIDLU
		METHOD setIDLU( nValue )
		METHOD getAddress
		METHOD setAddress( cValue )
		METHOD getPassport
		METHOD setPassport( cValue )
		METHOD getEmail
		METHOD setEmail( cValue )
		METHOD getPhone
		METHOD setPhone( cValue )
		METHOD getKemvyd
		METHOD setKemvyd( nValue )
		METHOD getDatevyd
		METHOD setDatevyd( nValue )
	ENDCLASS

METHOD function getIDLU()					CLASS TContractPayer
	return ::FIDLU

METHOD procedure setIDLU( nValue )		CLASS TContractPayer
	::FIDLU := nValue
	return

METHOD function getAddress()				CLASS TContractPayer
	return ::FAddress

METHOD procedure setAddress( cValue )	CLASS TContractPayer
	::FAddress := cValue
	return

METHOD function getPassport()				CLASS TContractPayer
	return ::FPassport

METHOD procedure setPassport( cValue )	CLASS TContractPayer
	::FPassport := cValue
	return

METHOD function getEmail()				CLASS TContractPayer
	return ::FEmail

METHOD procedure setEmail( cValue )		CLASS TContractPayer
	::FEmail := cValue
	return

METHOD function getPhone()				CLASS TContractPayer
	return ::FPhone

METHOD procedure setPhone( cValue )		CLASS TContractPayer
	::FPhone := cValue
	return

METHOD function getKemvyd()				CLASS TContractPayer
	return ::FKemvyd

METHOD procedure setKemvyd( nValue )		CLASS TContractPayer
	::FKemvyd := nValue
	return

METHOD function getDatevyd()				CLASS TContractPayer
	return ::FDatevyd

METHOD procedure setDatevyd( dValue )		CLASS TContractPayer
	::FDatevyd := dValue
	return

METHOD New( nId, lNew, lDeleted ) 		CLASS TContractPayer
			
	::super:new( nID, lNew, lDeleted )
	return self