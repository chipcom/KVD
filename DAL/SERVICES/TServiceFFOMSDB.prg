#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник услуг ФФОМС _mo_uslf.dbf
CREATE CLASS TServiceFFOMSDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD GetByID( nID )
		METHOD GetList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD FUNCTION New() CLASS TServiceFFOMSDB
	return self

METHOD FUNCTION getByID( nID )    CLASS TServiceFFOMSDB
	local hArray := nil
	local ret := nil
	
	If ( nID != 0 ) .AND. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	EndIf
	Return ret

METHOD FUNCTION GetList()    CLASS TServiceFFOMSDB
	local lFlag := .t.
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:getList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn

METHOD PROCEDURE Save( oService )     CLASS TServiceFFOMSDB
	return
	
METHOD FUNCTION FillFromHash( hbArray )     CLASS TServiceFFOMSDB
	local obj
	
	obj := TServiceFFOMS():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Name := hbArray[ 'NAME' ]
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:DateBegin := hbArray[ 'DATEBEG' ]
	obj:DateEnd := hbArray[ 'DATEEND' ]
	return obj