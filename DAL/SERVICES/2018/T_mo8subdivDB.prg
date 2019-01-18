#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8subdiv.dbf'
CREATE CLASS T_mo8subdivDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8subdivDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo8subdivDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8subdivDB
	local obj
	
	obj := T_mo8subdiv():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:CodeM		:= hbArray[ 'CODEM' ]
	obj:MCode		:= hbArray[ 'MCODE' ]
	obj:Code		:= hbArray[ 'CODE' ]
	obj:Name		:= hbArray[ 'NAME' ]
	obj:Flag		:= hbArray[ 'FLAG' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
	obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj