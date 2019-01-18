#include 'hbclass.ch'
#include 'hbhash.ch' 
#include 'property.ch'

// файл 'slugba.dbf'
CREATE CLASS TSlugbaDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oSlugba )
		METHOD getByID ( nID )
		METHOD getByShifr ( cShifr )
		METHOD getList( )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()	CLASS TSlugbaDB
	return self
	
METHOD getByID ( nID )				CLASS TSlugbaDB
	local hArray := nil
	local ret := nil
	
	If ( nID != 0 ) .and. !Empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getByShifr( cShifr )			CLASS TSlugbaDB
	local cOldArea, slg, cFind
	local ret := nil
	
	// предварительно проверить что пришло число или строка из 3-ти цифр,
	// если число преобразовать STR( nCode, 3 )
	if ValType( cShifr ) == 'N'
		cFind := STR( cShifr, 3 )
	elseif ValType( cShifr ) == 'C'
		cFind := cShifr
	else
		return ret
	endif
	cOldArea := Select()
	if ::super:RUse()
		slg := Select()
		if (slg)->(dbSeek( cFind ))
			hArray := ::super:currentRecord()
			if !empty( hArray )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(slg)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret
	
	
*******************
METHOD GetList( )					CLASS TSlugbaDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
*****************	
	
METHOD Save( oSlugba )						CLASS TSlugbaDB
	local ret := .f.
	local aHash := nil
	
	if upper( oSlugba:classname() ) == upper( 'TSlugba' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'SHIFR',		oSlugba:Shifr )
		hb_hSet(aHash, 'NAME',		oSlugba:Name )
		hb_hSet(aHash, 'ID',		oSlugba:ID )
		hb_hSet(aHash, 'REC_NEW',	oSlugba:IsNew )
		hb_hSet(aHash, 'DELETED',	oSlugba:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oSlugba:ID := ret
			oSlugba:IsNew := .f.
		endif
	endif
	return ret
	
	
METHOD FillFromHash( hbArray )		CLASS TSlugbaDB
	local obj
	
	obj := TSlugba():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr	:= hbArray[ 'SHIFR' ]
	obj:Name	:= hbArray[ 'NAME' ]
	return obj