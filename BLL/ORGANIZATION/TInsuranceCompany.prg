#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл 'str_komp.dbf' справочник прочих компаний
CREATE CLASS TInsuranceCompany		INHERIT	TCommittee

	VISIBLE:
		PROPERTY TFOMS AS NUMERIC READ getTFOMS WRITE setTFOMS		// Код ТФОМС
	
		METHOD New( nId, nCode, cName, cFName, cINN, cAddress, cPhone, oBank, ;
					cOKONH, cOKPO, nTFOMS, nParaklinika, nSourceFinance, lNew, lDeleted )
	
		METHOD Clone()
	HIDDEN:
	PROTECTED:
		DATA FTFOMS		INIT 0
		
		METHOD getTFOMS
		METHOD setTFOMS( param )
ENDCLASS

METHOD function getTFOMS()					CLASS TInsuranceCompany
	return ::FTFOMS

METHOD procedure setTFOMS( param )			CLASS TInsuranceCompany
	::FTFOMS := param
	return
	
METHOD Clone()		 CLASS TInsuranceCompany
	local oTarget := nil
	
	oTarget := ::super:TBaseObjectBLL:Clone()
	return oTarget

METHOD New( nId, nCode, cName, cFName, cINN, cAddress, cPhone, oBank, ;
			cOKONH, cOKPO, nTFOMS, nParaklinika, nSourceFinance, lNew, lDeleted )		 CLASS TInsuranceCompany

	::FNew 			:= hb_defaultValue( lNew, .t. )
	::FDeleted		:= hb_defaultValue( lDeleted, .f. )
	::FID			:= hb_defaultValue( nID, 0 )
	
	::FCode			:= hb_defaultvalue( nCode, 0 )
	::FName			:= hb_defaultvalue( cName, space( 30 ) )
	::FFullName		:= hb_defaultvalue( cFName, space( 70 ) )
	::FAddress		:= hb_defaultvalue( cAddress, space( 50 ) )
	::FINN			:= hb_defaultvalue( cINN, space( 20 ) )
	::FPhone		:= hb_defaultvalue( cPhone, space( 8 ) )
	::FBank			:= oBank
	::FOKONH		:= hb_defaultvalue( cOKONH, space( 15 ) )
	::FOKPO			:= hb_defaultvalue( cOKPO, space( 15 ) )
	::FPara			:= hb_defaultvalue( nParaklinika, 0 )
	::FSource		 := hb_defaultvalue( nSourceFinance, 0 )
	::FTFOMS		:= hb_defaultvalue( nTFOMS, 0 )
	return self