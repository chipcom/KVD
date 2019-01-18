#include "hbclass.ch"
#include "hbhash.ch" 
#include 'property.ch'

// класс образовательных учреждений
CREATE CLASS TSchool		INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName				//
		PROPERTY Name1251 READ getName1251								//
		PROPERTY FullName AS STRING READ getFullName WRITE setFullName	//
		PROPERTY FullName1251 READ getFullName1251						//
		PROPERTY Address AS STRING READ getAddress WRITE setAddress		// 
		PROPERTY Address1251 READ getAddress1251							//
		PROPERTY Type AS NUMERIC READ getType WRITE setType				// 0-школы,1-детсады,2-ПТУ
		PROPERTY Fed_kod AS NUMERIC READ getFed_kod WRITE setFed_kod		// код по фед.справочнику
		
		PROPERTY Type_F READ getTypeFormat
	
		CLASSDATA	aMenuTypeSchool		AS ARRAY	INIT { ;
															{ 'дошкольные учреждения', 1 }, ;
															{ 'общие образовательные', 0 }, ;
															{ 'професс., специальные', 2 } }
	
		METHOD New( nId, cName, cFullName, cAddress, nType, nFed_kod, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FName			INIT space( 30 )
		DATA FFullName		INIT space( 250 )
		DATA FAddress		INIT space( 250 )
		DATA FType			INIT 0
		DATA FFed_kod		INIT 0
		
		CLASSDATA	aTypeSchool		AS ARRAY	INIT { ;
												'общие образовательные', ;
												'дошкольные учреждения', ;
												'професс., специальные' }
	
		METHOD getName
		METHOD getName1251
		METHOD setName( param )
		METHOD getFullName
		METHOD getFullName1251
		METHOD setFullName( param )
		METHOD getAddress
		METHOD getAddress1251
		METHOD setAddress( param )
		METHOD getType
		METHOD setType( param )
		METHOD getFed_kod
		METHOD setFed_kod( param )
		
		METHOD getTypeFormat
ENDCLASS

METHOD function getTypeFormat()					CLASS TSchool
	return ::aTypeSchool[ ::FType + 1 ]

METHOD function getName()					CLASS TSchool
	return ::FName

METHOD FUNCTION getName1251()				CLASS TSchool
	return win_OEMToANSI( ::FName )

METHOD procedure setName( param )		CLASS TSchool
	::FName := param
	return

METHOD function getFullName()				CLASS TSchool
	return ::FFullName

METHOD FUNCTION getFullName1251()			CLASS TSchool
	return win_OEMToANSI( ::FFullName )

METHOD procedure setFullName( param )	CLASS TSchool
	::FFullName := param
	return

METHOD function getAddress()				CLASS TSchool
	return ::FAddress

METHOD FUNCTION getAddress1251()			CLASS TSchool
	return win_OEMToANSI( ::FAddress )

METHOD procedure setAddress( param )		CLASS TSchool
	::FAddress := param
	return

METHOD function getType()					CLASS TSchool
	return ::FType

METHOD procedure setType( param )		CLASS TSchool
	::FType := param
	return

METHOD function getFed_kod()				CLASS TSchool
	return ::FFed_kod

METHOD procedure setFed_kod( param )		CLASS TSchool
	::FFed_kod := param
	return

METHOD Clone()		 CLASS TSchool
	local oTarget := nil
	
	oTarget := ::Super:Clone()
	return oTarget


METHOD New( nId, cName, cFullName, cAddress, nType, nFed_kod, lNew, lDeleted ) CLASS TSchool
			  
	HB_Default( @nID, 0 ) 
	HB_Default( @cName, Space( 30 ) ) 
	HB_Default( @cFullName, Space( 30 ) ) 
	HB_Default( @cAddress, Space( 250 ) ) 
	HB_Default( @nType, 0 ) 
	HB_Default( @nFed_kod, 0 ) 
	HB_Default( @lDeleted, .F. ) 
	HB_Default( @lNew, .T. ) 
			  
	::FID			:= nID
	::FName			:= cName
	::FFullName		:= cFullName
	::FAddress		:= cAddress
	::FType			:= nType
	::FFed_kod		:= nFed_kod
			  
	::FNew 			:= lNew
	::FDeleted		:= lDeleted
	return self