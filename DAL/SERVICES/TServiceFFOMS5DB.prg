#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник услуг ФФОМС 2015-2016 _mo5uslf.dbf
CREATE CLASS TServiceFFOMS5DB	INHERIT	TServiceFFOMSDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD GetByID( nID )
		METHOD GetList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TServiceFFOMS5DB
	return self

METHOD getByID( nID )    CLASS TServiceFFOMS5DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getList()    CLASS TServiceFFOMS5DB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn
	
METHOD PROCEDURE Save()     CLASS TServiceFFOMS5DB
	return
	
METHOD FillFromHash( hbArray )     CLASS TServiceFFOMS5DB
	local obj
	
	obj := TServiceFFOMS5():New( hbArray[ 'ID' ], ;
			hbArray[ 'SHIFR' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'TIP' ], ;
			hbArray[ 'GRP' ], ;
			hbArray[ 'UETV' ], ;
			hbArray[ 'UETD' ], ;
			hbArray[ 'DATEBEG' ], ;
			hbArray[ 'DATEEND' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Name := hbArray[ 'NAME' ]
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:DateBegin := hbArray[ 'DATEBEG' ]
	obj:DateEnd := hbArray[ 'DATEEND' ]
	obj:Type := hbArray[ 'TIP' ]
	obj:Group := hbArray[ 'GRP' ]
	obj:UETAdult := hbArray[ 'UETV' ]
	obj:UETChild := hbArray[ 'UETD' ]
	return obj