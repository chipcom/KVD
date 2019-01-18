#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник услуг ФФОМС 2017 _mo7uslf.dbf
CREATE CLASS TServiceFFOMS7DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getByID( nID )
		METHOD getList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TServiceFFOMS7DB
	return self

METHOD getByID( nID )    CLASS TServiceFFOMS7DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !empty( hArray := TBaseObjectDB():GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getList()    CLASS TServiceFFOMS7DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in super:getList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
	
METHOD PROCEDURE Save()     CLASS TServiceFFOMS7DB
	return
	
METHOD FillFromHash( hbArray )     CLASS TServiceFFOMS7DB
	local obj
	
	obj := TServiceFFOMS7():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:Name := hbArray[ 'NAME' ]
	obj:Type := hbArray[ 'TIP' ]
	obj:Group := hbArray[ 'GRP' ]
	obj:UETAdult := hbArray[ 'UETV' ]
	obj:UETChild := hbArray[ 'UETD' ]
	obj:DateBegin := hbArray[ 'DATEBEG' ]
	obj:DateEnd := hbArray[ 'DATEEND' ]
	return obj