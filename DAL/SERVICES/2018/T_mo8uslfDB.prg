#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8uslf.dbf'
CREATE CLASS T_mo8uslfDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getByShifr ( cShifr )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8uslfDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD getByShifr ( cShifr )		CLASS T_mo8uslfDB
	local cOldArea, uslugi, cFind
	local ret := nil

	// предварительно проверить что пришло строка
	if ValType( cShifr ) != 'C'
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
	
METHOD New() CLASS T_mo8uslfDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8uslfDB
	local obj
	
	obj := T_mo8uslf():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr		:= hbArray[ 'SHIFR' ]
	obj:Name		:= hbArray[ 'NAME' ]
	obj:Tip			:= hbArray[ 'TIP' ]
	obj:Grp			:= hbArray[ 'GRP' ]
	obj:ONKO_NAPR	:= hbArray[ 'ONKO_NAPR' ]
	obj:ONKO_KSG	:= hbArray[ 'ONKO_KSG' ] 
	obj:UETV		:= hbArray[ 'UETV' ]
	obj:UETD		:= hbArray[ 'UETD' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ]
	obj:DATEEND		:= hbArray[ 'DATEEND' ]
	return obj