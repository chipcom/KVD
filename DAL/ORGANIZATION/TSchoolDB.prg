#include "hbclass.ch"
#include "hbhash.ch" 
#include 'property.ch'

// файл "mo_schoo.dbf" образовательных учреждений
CREATE CLASS TSchoolDB		INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oSchool )
		METHOD getByID ( nID )
		METHOD GetList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TSchoolDB
	return self

METHOD getByID ( nID )		 CLASS TSchoolDB
	Local hArray := Nil
	Local ret := Nil
	
	If ( nID != 0 ) .AND. !Empty( hArray := ::Super:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	EndIf
	Return ret
	
METHOD GetList()   CLASS TSchoolDB
	Local aReturn := {}
	Local oRow := Nil
	
	FOR EACH oRow IN ::Super:GetList( )
		AADD( aReturn, ::FillFromHash( oRow ) )		// все
	NEXT
	Return aReturn

* Сохранить объект TSchoolDB
*
METHOD Save( oSchool ) CLASS TSchoolDB
	Local ret := .f.
	Local aHash := nil
	
	if upper( oSchool:classname() ) == upper( 'TSchool' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',			oSchool:Name )
		hb_hSet(aHash, 'FNAME',			oSchool:FullName )
		hb_hSet(aHash, 'ADRES',			oSchool:Address )
		hb_hSet(aHash, 'TIP',			oSchool:Type )
		hb_hSet(aHash, 'FED_KOD',		oSchool:Fed_kod )
		hb_hSet(aHash, 'ID',			oSchool:ID )
		hb_hSet(aHash, 'REC_NEW',		oSchool:IsNew )
		hb_hSet(aHash, 'DELETED',		oSchool:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oSchool:ID := ret
			oSchool:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TSchoolDB
	Local obj
	
	obj := TSchool():New( hbArray[ 'ID' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'FNAME' ], ;
			hbArray[ 'ADRES' ], ;
			hbArray[ 'TIP' ], ;
			hbArray[ 'FED_KOD' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	Return obj