#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8deppr.dbf'
CREATE CLASS T_mo8depprDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8depprDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo8depprDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8depprDB
	local obj
	
	obj := T_mo8deppr():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
		obj:CodeM		:= hbArray[ 'CODEM' ]
		obj:MCode		:= hbArray[ 'MCODE' ]
		obj:Code		:= hbArray[ 'CODE' ]
		obj:Place		:= hbArray[ 'PLACE' ]
		obj:Pr_Berth	:= hbArray[ 'PR_BERTH' ]
		obj:Pr_MP		:= hbArray[ 'PR_MP' ]
		obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
		obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj