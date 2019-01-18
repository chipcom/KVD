#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8k006.dbf'
CREATE CLASS T_mo8k006DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8k006DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD New() CLASS T_mo8k006DB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8k006DB
	local obj
	
	obj := T_mo8k006():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr		:= hbArray[ 'SHIFR' ]
	obj:KZ			:= hbArray[ 'KZ' ]
	obj:Profil		:= hbArray[ 'PROFIL' ]
	obj:DS			:= hbArray[ 'DS' ]
	obj:DS1			:= hbArray[ 'DS1' ]
	obj:DS2			:= hbArray[ 'DS2' ]
	obj:SY			:= hbArray[ 'SY' ]
	obj:Age			:= hbArray[ 'AGE' ]
	obj:Sex			:= hbArray[ 'SEX' ]
	obj:LOS			:= hbArray[ 'LOS' ]
	obj:AD_CR		:= hbArray[ 'AD_CR' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
	obj:DATEEND		:= hbArray[ 'DATEEND' ]
	obj:NS			:= hbArray[ 'NS' ]
	return obj