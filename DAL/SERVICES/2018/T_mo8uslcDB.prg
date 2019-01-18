#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8uslc.dbf'
CREATE CLASS T_mo88uslcDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo88uslcDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo88uslcDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo88uslcDB
	local obj
	
	obj := T_mo88uslc():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:CodeMO		:= hbArray[ 'CODEMO' ]
	obj:Shifr		:= hbArray[ 'SHIFR' ]
	obj:USL_OK		:= hbArray[ 'USL_OK' ]
	obj:DEPART		:= hbArray[ 'DEPART' ]
	obj:Uroven		:= hbArray[ 'UROVEN' ]
	obj:Vzros_Reb	:= hbArray[ 'VZROS_REB' ]
	obj:Cena		:= hbArray[ 'CENA' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
	obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj