#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл "mo_stdds.dbf" стационары, из которых проходит диспансеризация детей-сирот
CREATE CLASS TStddsDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oStdds )
		METHOD getByID ( nID )
		METHOD GetList( )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TStddsDB
	return self

METHOD getByID ( nID )		 CLASS TStddsDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !Empty( hArray := ::super:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD GetList( nType )   CLASS TStddsDB
	local areturn := {}
	local oRow := nil
	
	for each oRow in ::super:GetList( )
		aadd( areturn, ::FillFromHash( oRow ) )		// все
	next
	return areturn
	
* Сохранить объект TStddsDB
*
METHOD Save( oStdds ) CLASS TStddsDB
	local ret := .f.
	local aHash := nil
	
	if upper( oStdds:classname() ) == upper( 'TStdds' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',			oStdds:Name )
		hb_hSet(aHash, 'ADRES',			oStdds:Address )
		hb_hSet(aHash, 'VEDOM',			oStdds:Vedom )
		hb_hSet(aHash, 'FED_KOD',		oStdds:Fed_kod )
		hb_hSet(aHash, 'ID',			oStdds:ID )
		hb_hSet(aHash, 'REC_NEW',		oStdds:IsNew )
		hb_hSet(aHash, 'DELETED',		oStdds:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oStdds:ID := ret
			oStdds:IsNew := .f.
		endif
	endif
	return ret


METHOD FillFromHash( hbArray )     CLASS TStddsDB
	local obj
	
	obj := TStdds():New( hbArray[ 'ID' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'ADRES' ], ;
			hbArray[ 'VEDOM' ], ;
			hbArray[ 'FED_KOD' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj