#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS T_okatooDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD GetList()
		METHOD getListByRegion( param )
		METHOD getByOKATO( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS T_okatooDB
	return self

METHOD GetList()   						CLASS T_okatooDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::Super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
	
METHOD getListByRegion( param )		 CLASS T_okatooDB
	local hArray := nil
	local oRow
	local aReturn := {}
	
	for each oRow in ::Super:GetList( )
		if substr( oRow[ 'OKATO' ], 1, 2 ) == param
			aadd( aReturn, ::FillFromHash( oRow ) )
		endif
	next
	return aReturn

METHOD getByID( nID )		 CLASS T_okatooDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByOKATO( param ) CLASS T_okatooDB
	local cOldArea, cAlias, cFind
	local ret := nil
	
	if ischaracter( param )
		cFind := left( param, 5 )
		
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

METHOD FillFromHash( hbArray )     CLASS T_okatooDB
	local obj
	
	obj := T_okatoo():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:OKATO := hbArray[ 'OKATO' ]
	obj:Name  := hbArray[ 'NAME' ]
	obj:Vybor := hbArray[ 'FL_VIBOR' ]
	obj:Zagol := hbArray[ 'FL_ZAGOL' ]
	obj:Tip := hbArray[ '  TIP' ]
	obj:Selo := hbArray[ ' SELO' ]	
	return obj
