#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8shema.dbf'
CREATE CLASS T_mo8shemaDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8shemaDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo8shemaDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8shemaDB
	local obj
	
	obj := T_mo8shema():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Kod		:= hbArray[ 'KOD' ]
	obj:Name	:= hbArray[ 'NAME' ]
	obj:DNI		:= hbArray[ 'DNI' ]
	obj:KSG		:= hbArray[ 'KSG' ]
	obj:DATEBEG	:= hbArray[ 'DATEBEG' ]
	obj:DATEEND	:= hbArray[ 'DATEEND' ]
	return obj