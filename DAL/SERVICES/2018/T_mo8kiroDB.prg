#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8kiro.dbf'
CREATE CLASS T_mo8kiroDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8kiroDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo8kiroDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8kiroDB
	local obj
	
	obj := T_mo8kiro():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Code		:= hbArray[ 'CODE' ]
	obj:Name		:= hbArray[ 'NAME' ]
	obj:Name_F		:= hbArray[ 'NAME_F' ]
	obj:Coef		:= hbArray[ 'COEF' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
	obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj