#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// 䠩� '_mo8prices.dbf'
CREATE CLASS T_mo8pricesDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8pricesDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo8pricesDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8pricesDB
	local obj
	
	obj := T_mo8prices():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr		:= hbArray[ 'SHIFR' ]
	obj:Vzros_Reb	:= hbArray[ 'VZROS_REB' ]
	obj:Level		:= hbArray[ 'LEVEL' ]
	obj:Cena		:= hbArray[ 'CENA' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
	obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj