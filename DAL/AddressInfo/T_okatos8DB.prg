#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS T_okatos8DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getListByOblast( param )
		METHOD getByOKATO( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS T_okatos8DB
	return self

METHOD getListByOblast( param )		 CLASS T_okatos8DB
	local cOldArea, cAlias
	local hArray := nil
	local aReturn := {}
	
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if substr( (cAlias)->OKATO, 1, 5 ) == param
				if ! empty( hArray := ::super:currentRecord() )
					aadd( aReturn, ::FillFromHash( hArray ) )
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aReturn

METHOD getByID( nID )		 CLASS T_okatos8DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD function getByOKATO( param ) CLASS T_okatos8DB
	local cOldArea, cAlias, cFind
	local ret := nil
	
	if ischaracter( param )
		cFind := left( param, 11 )
		
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

METHOD FillFromHash( hbArray )     CLASS T_okatos8DB
	local obj
	
	obj := T_okatos8():New( hbArray[ 'ID' ], ;
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
