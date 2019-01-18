#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник услуг ФФОМС 2015-2016 _mo5uslf.dbf
CREATE CLASS TServiceFFOMS5	INHERIT	TServiceFFOMS
	VISIBLE:
		PROPERTY Type READ getType WRITE setType
		PROPERTY Group READ getGroup WRITE setGroup
		PROPERTY UETAdult READ getAdultUET WRITE setAdultUET
		PROPERTY UETChild READ getChildUET WRITE setChildUET

		METHOD New( nID, lNew, lDeleted )
	PROTECTED:
		DATA FType		INIT 0
		DATA FGroup		INIT 0
		DATA FAdultUET	INIT 0
		DATA FChildUET	INIT 0
		
		METHOD getType
		METHOD setType( nVal )
		METHOD getGroup
		METHOD setGroup( nVal )
		METHOD getAdultUET
		METHOD setAdultUET( nVal )
		METHOD getChildUET
		METHOD setChildUET( nVal )
ENDCLASS

METHOD FUNCTION getType() CLASS TServiceFFOMS5
	return ::FType
	
METHOD PROCEDURE setType( nVal ) CLASS TServiceFFOMS5
	::FType := nVal
	return
	
METHOD FUNCTION getGroup() CLASS TServiceFFOMS5
	return ::FGroup

METHOD PROCEDURE setGroup( nVal ) CLASS TServiceFFOMS5
	::FGroup := nVal
	return

METHOD FUNCTION getAdultUET() CLASS TServiceFFOMS5
	return ::FAdultUET

METHOD PROCEDURE setAdultUET( nVal ) CLASS TServiceFFOMS5
	::FAdultUET := nVal
	return

METHOD FUNCTION getChildUET() CLASS TServiceFFOMS5
	return ::FChildUET

METHOD PROCEDURE setChildUET( nVal ) CLASS TServiceFFOMS5
	::FChildUET := nVal
	return

METHOD New( nID, lNew, lDeleted ) CLASS TServiceFFOMS5

	::super:new( nID, lNew, lDeleted )
	return self