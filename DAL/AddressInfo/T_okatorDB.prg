#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS T_okatorDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getList()
		METHOD getByOKATO( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS T_okatorDB
	return self

METHOD getByID( nID )		 CLASS T_okatorDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD GetList()   						CLASS T_okatorDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::Super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
	
METHOD function getByOKATO( param ) CLASS T_okatorDB
	local cOldArea, cAlias, cFind
	local ret := nil
	
	if ischaracter( param )
		cFind := left( param, 2 )
		
		cOldArea := Select()
		if ::super:RUse()
			cAlias := Select()
			(cAlias)->(dbSetOrder( 1 ))
			if (cAlias)->( dbSeek( cFind ) )
				if ! empty( hArray := ::super:currentRecord() )
					ret := ::FillFromHash( hArray )
				endif
			endif
			(cAlias)->( dbCloseArea() )
			dbSelectArea( cOldArea )
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS T_okatorDB
	local obj
	
	obj := T_okator():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:OKATO := hbArray[ 'OKATO' ]
	obj:Name  := hbArray[ 'NAME' ]
	return obj
