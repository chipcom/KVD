#include "hbclass.ch"
#include "hbhash.ch" 
#include 'common.ch'
#include 'property.ch'

// файл "s_kemvyd.dbf" органов МВД выдавших документы
CREATE CLASS TPublisherDB		INHERIT	TBaseObjectDB
	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName				// Наименование организации выдавшей документ
	
		METHOD New()
		METHOD Save( oPublisher )
		METHOD getByID ( nID )
		METHOD GetList( )
		METHOD MenuPublisher()
		
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TPublisherDB
	return self

METHOD getByID ( nID )		 			CLASS TPublisherDB
	local hArray := Nil
	local ret := Nil
	
	if ( nID != 0 ) .and. !Empty( hArray := ::Super:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD GetList()   						CLASS TPublisherDB
	local aReturn := {}
	local oRow := Nil
	
	for each oRow in ::Super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn

* Сохранить объект TPublisherDB
*
METHOD Save( oPublisher ) 							CLASS TPublisherDB
	local ret := .f.
	local aHash := nil
	
	if upper( oPublisher:classname() ) == upper( 'TPublisher' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',			oPublisher:Name )
		hb_hSet(aHash, 'ID',			oPublisher:ID )
		hb_hSet(aHash, 'REC_NEW',		oPublisher:IsNew )
		hb_hSet(aHash, 'DELETED',		oPublisher:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oPublisher:ID := ret
			oPublisher:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     		CLASS TPublisherDB
	local obj
	
	obj := TPublisher():New( hbArray[ 'ID' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj

METHOD MenuPublisher()		 			CLASS TPublisherDB
	local aPublisher := {}
	local oRow := nil
	
	for each oRow in ::getList()
		aadd( aPublisher, { oRow:Name(), oRow:ID() } )
	next
	return aPublisher