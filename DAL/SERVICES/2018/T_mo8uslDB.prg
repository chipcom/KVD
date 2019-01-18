#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл '_mo8usl.dbf'
CREATE CLASS T_mo8uslDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getByShifr ( cShifr )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD getByID ( nID )		 	CLASS T_mo8uslDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD getByShifr ( cShifr )		CLASS T_mo8uslDB
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
	
METHOD New() CLASS T_mo8uslDB
	return self

METHOD FillFromHash( hbArray )     CLASS T_mo8uslDB
	local obj
	
	obj := T_mo8usl():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr		:= hbArray[ 'SHIFR' ]
	obj:Name 		:= hbArray[ 'NAME' ]
	obj:ST			:= hbArray[ 'ST' ]
	obj:USL_OK		:= hbArray[ 'USL_OK' ]
	obj:USL_OKS		:= hbArray[ 'USL_OKS' ]
	obj:UNIT_CODE	:= hbArray[ 'UNIT_CODE' ]
	obj:UNITS		:= hbArray[ 'UNITS' ]
	obj:BUKVA		:= hbArray[ 'BUKVA' ]
	obj:VMP_F		:= hbArray[ 'VMP_F' ]
	obj:VMP_S		:= hbArray[ 'VMP_S' ]
	obj:IDSP		:= hbArray[ 'IDSP' ]
	obj:IDSPS		:= hbArray[ 'IDSPS' ]
	obj:KSLP		:= hbArray[ 'KSLP' ]
	obj:KSLPS		:= hbArray[ 'KSLPS' ]
	obj:KIRO		:= hbArray[ 'KIRO' ]
	obj:KIROS		:= hbArray[ 'KIROS' ]
	obj:UETV		:= hbArray[ 'UETV' ]
	obj:UETD		:= hbArray[ 'UETD' ]
	obj:TYPE_KSG	:= hbArray[ 'TYPE_KSG' ]
	obj:DATEBEG		:= hbArray[ 'DATEBEG' ] 
	obj:DATEEND		:= hbArray[ 'DATEEND' ] 
	return obj