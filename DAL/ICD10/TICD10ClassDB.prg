#include 'hbclass.ch'
#include 'hbhash.ch' 
#include 'property.ch'

// файл '_mo_mkbk.dbf' - классы МКБ-10
CREATE CLASS TICD10ClassDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

***********************************
* Создать новый объект TICD10ClassDB
METHOD New() CLASS TICD10ClassDB
	return self

***** получить класс по ID
*
METHOD getByID ( nID )		 CLASS TICD10ClassDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
****** получить список классов диагнозов
*	
METHOD getList() CLASS TICD10ClassDB
	local aReturn := {}
	local oRow := nil
	local tVar := ''
	local tID, tClass, tSH_B, tSH_E, tName, tRec_new, tDeleteted
	local lFirst := .t., obj
	
	for each oRow in ::super:getList()
		if lFirst
			lFirst := .f.
			tVar := oRow[ 'KLASS' ]
		endif
		if ( tVar != oRow[ 'KLASS' ] )
			obj := TICD10Class():New( tID, tClass, tSH_B, tSH_E, tName, tRec_new, tDeleteted )
			aadd( aReturn, obj )
			tID			:= oRow[ 'ID' ]
			tClass		:= oRow[ 'KLASS' ]
			tSH_B		:= oRow[ 'SH_B' ]
			tSH_E		:= oRow[ 'SH_E' ]
			tName		:= alltrim( oRow[ 'NAME' ] )
			tRec_new	:= oRow[ 'REC_NEW' ]
			tDeleteted	:= oRow[ 'DELETED' ]
			
			tVar := oRow[ 'KLASS' ]
		elseif ( tVar == oRow[ 'KLASS' ] ) .and. ( oRow[ 'KS' ] == 0 )
			tID			:= oRow[ 'ID' ]
			tClass		:= oRow[ 'KLASS' ]
			tSH_B		:= oRow[ 'SH_B' ]
			tSH_E		:= oRow[ 'SH_E' ]
			tName		:= alltrim( oRow[ 'NAME' ] )
			tRec_new	:= oRow[ 'REC_NEW' ]
			tDeleteted	:= oRow[ 'DELETED' ]
		elseif ( tVar == oRow[ 'KLASS' ] ) .and. ( oRow[ 'KS' ] > 0 )
			tName		:= tName + ' ' + alltrim( oRow[ 'NAME' ] )
		endif
	next
	obj := TICD10Class():New( tID, tClass, tSH_B, tSH_E, tName, tRec_new, tDeleteted )
	aadd( aReturn, obj )
	return aReturn

METHOD FillFromHash( hbArray )     CLASS TICD10ClassDB
	local obj
	
	obj := TICD10Class():New( hbArray[ 'ID' ], ;
			hbArray[ 'KLASS' ], ;
			hbArray[ 'SH_B' ], ;
			hbArray[ 'SH_E' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	return obj