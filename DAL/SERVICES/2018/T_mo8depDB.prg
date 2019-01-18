#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8dep.dbf'
CREATE CLASS T_mo8depDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getByCode ( value )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8depDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getByCode ( value )		CLASS T_mo8depDB
	local cOldArea, uslugi, cShifr
	local ret := nil

	// предварительно проверить что пришло строка
	if isnumber( value )
		cShifr := str( value, 3 )
	elseif ischaracter( value )
		cShifr := substr( value, 1, 3 )
	else
		return ret
	endif
	cShifr := alltrim( cShifr )
	cOldArea := Select( )
	if ::super:RUse()
		uslugi := Select( )
		(uslugi)->(ordSetFocus( 1 ))
		if (uslugi)->(dbSeek( cShifr ) )
			if !empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(uslugi)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret
	
METHOD New() CLASS T_mo8depDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8depDB
	local obj
	
	obj := T_mo8dep():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
		obj:CodeM		:= hbArray[ 'CODEM' ]
		obj:MCode		:= hbArray[ 'MCODE' ]
		obj:Code		:= hbArray[ 'CODE' ]
		obj:Place		:= hbArray[ 'PLACE' ]
		obj:Name		:= hbArray[ 'NAME' ]
		obj:Name_Short	:= hbArray[ 'NAME_SHORT' ]
		obj:Usl_Ok		:= hbArray[ 'USL_OK' ]
		obj:VMP			:= hbArray[ 'VMP' ]
		obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
		obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj