#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл 'usl_otd.dbf'
CREATE CLASS TServiceBySubdivision	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDService READ getIDService WRITE setIDService						// ID записи в файле uslugi.dbf
		PROPERTY AllowSubdivision READ getAllowSubdivision WRITE setAllowSubdivision	// разрешенные отделения
		
		METHOD New( nId, lNew, lDeleted )
	HIDDEN:
		DATA FIDService			INIT 0
		DATA FAllowSubdivision	INIT space( 255 )
		
		METHOD getIDService
		METHOD setIDService( nVal )
		METHOD getAllowSubdivision
		METHOD setAllowSubdivision( cVal )
ENDCLASS

METHOD FUNCTION getIDService() CLASS TServiceBySubdivision
	return ::FIDService

METHOD PROCEDURE setIDService( nVal ) CLASS TServiceBySubdivision

	::FIDService := nVal
	return
	
METHOD FUNCTION getAllowSubdivision()				CLASS TServiceBySubdivision
	return ::FAllowSubdivision

METHOD PROCEDURE setAllowSubdivision( cVal )		CLASS TServiceBySubdivision

	::FAllowSubdivision := cVal
	return

METHOD New( nID, lNew, lDeleted ) CLASS TServiceBySubdivision

	::super:new( nID, lNew, lDeleted )
	return self