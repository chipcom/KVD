#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл "p_pr_vz.dbf"
CREATE CLASS TCompanyVzaim	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName				// Наименование организации
		PROPERTY Name1251 READ getName1251								// Наименование организации в кодировке 1251
		PROPERTY FullName AS STRING READ getFullName WRITE setFullName	// Полное наименование организации
		PROPERTY FullName1251 READ getFullName1251						// Полное наименование организации в кодировке 1251
		PROPERTY INN AS STRING READ getINN WRITE setINN					// �?НН/КПП
		PROPERTY Address AS STRING READ getAddress WRITE setAddress		// Адрес
		PROPERTY Phone AS STRING READ getPhone WRITE setPhone			// Телефон
		PROPERTY Bank AS OBJECT READ getBank WRITE setBank				// объект банка контрагента
		PROPERTY Dogovor AS STRING READ getDogovor WRITE setDogovor		// Номер договора
		PROPERTY Date AS DATE READ getDate WRITE setDate					// Дата договора

		METHOD New( nId, cName, cFname, cINN, cAddress, cPhone, oBank, cN_dog, dD_dog, lNew, lDeleted )
	HIDDEN:
		DATA FName		INIT space( 30 )
		DATA FFullName	INIT space( 70 )
		DATA FINN		INIT space( 20 )
		DATA FAddress	INIT space( 100 )
		DATA FPhone		INIT space( 8 )
		DATA FDogovor	INIT space( 30 )
		DATA FDate		INIT ctod( '' )
		DATA FBank		INIT nil
		
		METHOD getName
		METHOD setName( cValue )
		METHOD getName1251
		METHOD getFullName
		METHOD setFullName( cValue )
		METHOD getFullName1251
		METHOD getINN
		METHOD setINN( cValue )
		METHOD getAddress
		METHOD setAddress( cValue )
		METHOD getPhone
		METHOD setPhone( cValue )
		METHOD getDogovor
		METHOD setDogovor( cValue )
		METHOD getDate
		METHOD setDate( dValue )
		METHOD getBank
		METHOD setBank( param )
ENDCLASS

METHOD function getName()					CLASS TCompanyVzaim
	return ::FName

METHOD function getName1251()				CLASS TCompanyVzaim
	return win_OEMToANSI( ::FName )

METHOD procedure setName( cValue )		CLASS TCompanyVzaim
	::FName := cValue
	return

METHOD function getFullName()				CLASS TCompanyVzaim
	return ::FFullName

METHOD function getFullName1251()			CLASS TCompanyVzaim
	return win_OEMToANSI( ::FFullName )

METHOD procedure setFullName( cValue )	CLASS TCompanyVzaim
	::FFullName := cValue
	return

METHOD function getINN()					CLASS TCompanyVzaim
	return ::FINN

METHOD procedure setINN( cValue )		CLASS TCompanyVzaim
	::FINN := cValue
	return

METHOD function getAddress()				CLASS TCompanyVzaim
	return ::FAddress

METHOD procedure setAddress( cValue )	CLASS TCompanyVzaim
	::FAddress := cValue
	return

METHOD function getPhone()					CLASS TCompanyVzaim
	return ::FPhone

METHOD procedure setPhone( cValue )		CLASS TCompanyVzaim
	::FPhone := cValue
	return

METHOD function getDogovor()				CLASS TCompanyVzaim
	return ::FDogovor

METHOD procedure setDogovor( cValue )		CLASS TCompanyVzaim
	::FDogovor := cValue
	return

METHOD function getDate()					CLASS TCompanyVzaim
	return ::FDate

METHOD procedure setDate( dValue )		CLASS TCompanyVzaim
	::FDate := dValue
	return

METHOD function getBank()					CLASS TCompanyVzaim
	return ::FBank

METHOD procedure setBank( param )		CLASS TCompanyVzaim
	::FBank := param
	return

METHOD New( nId, cName, cFname, cINN, cAddress, cPhone, oBank, cN_dog, dD_dog, lNew, lDeleted ) CLASS TCompanyVzaim

	::FNew 			:= hb_defaultValue( lNew, .t. )
	::FDeleted		:= hb_defaultValue( lDeleted, .f. )
	::FID			:= hb_defaultValue( nID, 0 )
	
	::FName			:= hb_defaultValue( cName, space( 30 ) )
	::FFullName		:= hb_defaultValue( cFname, space( 70 ) )
	::FINN			:= hb_defaultValue( cINN, space( 10 ) )
	::FAddress		:= hb_defaultValue( cAddress, space( 100 ) )
	::FPhone		:= hb_defaultValue( cPhone, space( 8 ) )
	::FBank		:= oBank
	::FDogovor		:= hb_defaultValue( cN_dog, space( 30 ) )
	::FDate			:= hb_defaultValue( dD_dog, ctod( '' ) )
	return self
