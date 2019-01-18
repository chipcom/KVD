#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл "komitet.dbf" комитеты
CREATE CLASS TCommittee		INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Code AS NUMERIC READ getCode WRITE setCode				// служебный
		PROPERTY Name AS STRING READ getName WRITE setName				// Название
		PROPERTY Name1251 READ getName1251								//
		PROPERTY FullName AS STRING READ getFullName WRITE setFullName	// Полное наименование
		PROPERTY FullName1251 READ getFullName1251						//
		PROPERTY Address AS STRING READ getAddress WRITE setAddress		// Адрес
		PROPERTY Address1251 READ getAddress1251							//
		PROPERTY INN AS STRING READ getINN WRITE setINN					// ИНН/КПП
		PROPERTY Phone AS STRING READ getPhone WRITE setPhone			// Телефон
		PROPERTY OKONH AS STRING READ getOKONH WRITE setOKONH			// Код по ОКОНХ
		PROPERTY OKPO AS STRING READ getOKPO WRITE setOKPO				// Код по ОКПО
		PROPERTY Paraclinika AS NUMERIC READ getPara WRITE setPara		// Включать ПАРАКЛИНИКУ в сумму счета по данной компании
		PROPERTY SourceFinance AS NUMERIC READ getSource WRITE setSource	// Источник финансирования
		PROPERTY Bank AS OBJECT READ getBank WRITE setBank				// объект банка контрагента

		METHOD New( nId, lNew, lDeleted )
		METHOD Clone()
	PROTECTED:
		DATA FCode			INIT 0				//
		DATA FName			INIT space( 30 )
		DATA FFullName		INIT space( 70 )
		DATA FAddress		INIT space( 50 )
		DATA FINN			INIT space( 20 )
		DATA FPhone			INIT space( 8 )
		DATA FOKONH			INIT space( 15 )
		DATA FOKPO			INIT space( 15 )
		DATA FPara			INIT 0
		DATA FSource		INIT 0
		DATA FBank			INIT nil
		
		METHOD getName
		METHOD getName1251
		METHOD setName( param )
		METHOD getFullName
		METHOD getFullName1251
		METHOD setFullName( param )
		METHOD getAddress
		METHOD getAddress1251
		METHOD setAddress( param )
		METHOD getINN
		METHOD setINN( param )
		METHOD getPhone
		METHOD setPhone( param )
		METHOD getOKONH
		METHOD setOKONH( param )
		METHOD getOKPO
		METHOD setOKPO( param )
		METHOD getPara
		METHOD setPara( param )
		METHOD getSource
		METHOD setSource( param )
		METHOD getBank
		METHOD setBank( param )
		METHOD getCode
		METHOD setCode( param )
ENDCLASS

METHOD function getName()					CLASS TCommittee
	return ::FName

METHOD FUNCTION getName1251()				CLASS TCommittee
	return win_OEMToANSI( ::FName )

METHOD procedure setName( param )		CLASS TCommittee
	::FName := param
	return

METHOD function getFullName()				CLASS TCommittee
	return ::FFullName

METHOD FUNCTION getFullName1251()			CLASS TCommittee
	return win_OEMToANSI( ::FFullName )

METHOD procedure setFullName( param )	CLASS TCommittee
	::FFullName := param
	return

METHOD function getAddress()				CLASS TCommittee
	return ::FAddress

METHOD FUNCTION getAddress1251()			CLASS TCommittee
	return win_OEMToANSI( ::FAddress )

METHOD procedure setAddress( param )		CLASS TCommittee
	::FAddress := param
	return

METHOD function getINN()					CLASS TCommittee
	return ::FINN

METHOD procedure setINN( param )			CLASS TCommittee
	::FINN := param
	return

METHOD function getPhone()					CLASS TCommittee
	return ::FPhone

METHOD procedure setPhone( param )		CLASS TCommittee
	::FPhone := param
	return

METHOD function getOKONH()					CLASS TCommittee
	return ::FOKONH

METHOD procedure setOKONH( param )		CLASS TCommittee
	::FOKONH := param
	return

METHOD function getOKPO()					CLASS TCommittee
	return ::FOKPO

METHOD procedure setOKPO( param )		CLASS TCommittee
	::FOKPO := param
	return

METHOD function getPara()					CLASS TCommittee
	return ::FPara

METHOD procedure setPara( param )		CLASS TCommittee
	::FPara := param
	return

METHOD function getSource()				CLASS TCommittee
	return ::FSource

METHOD procedure setSource( param )		CLASS TCommittee
	::FSource := param
	return

METHOD function getBank()					CLASS TCommittee
	return ::FBank

METHOD procedure setBank( param )		CLASS TCommittee
	::FBank := param
	return

METHOD function getCode()					CLASS TCommittee
	return ::FCode

METHOD procedure setCode( param )		CLASS TCommittee
	::FCode := param
	return

METHOD Clone()		 CLASS TCommittee
	local oTarget := nil
	
	oTarget := ::super:Clone()
	return oTarget

METHOD New( nId, lNew, lDeleted )		 CLASS TCommittee

	::super:new( nID, lNew, lDeleted )
	return self