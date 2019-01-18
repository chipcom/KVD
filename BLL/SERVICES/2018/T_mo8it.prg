#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8it.dbf'
CREATE CLASS T_mo8it	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY DS		READ getDS
		PROPERTY IT		READ getIT

		METHOD New( nId, lNew, lDeleted )

	HIDDEN:
		DATA FDS		INIT space( 5 )
		DATA FIT		INIT 0

		METHOD getDS
		METHOD getIT
ENDCLASS

METHOD FUNCTION getDS()		CLASS T_mo8it
	return ::FDS

METHOD FUNCTION getIT()		CLASS T_mo8it
	return ::FIT

METHOD New( nId, lNew, lDeleted ) CLASS T_mo8it
			
	::super:new( nID, lNew, lDeleted )
	return self
