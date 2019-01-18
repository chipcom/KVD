#include 'hbclass.ch'
#include 'hbhash.ch' 
#include 'property.ch'

// файл '_mo_mkbg.dbf' - МКБ-10
CREATE CLASS TICD10GroupDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getList()
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

***********************************
* Создать новый объект TICD10GroupDB
METHOD New() CLASS TICD10GroupDB
	return self

***** получить диагноз по ID
*
METHOD getByID ( nID )		 CLASS TICD10GroupDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
****** получить список групп диагнозов
*	
METHOD getList() CLASS TICD10GroupDB
	Local aReturn := {}
	Local oRow := nil
	local tVar := ''
	local tVar1 := ''
	local tID, tSH_B, tSH_E, tName, tRec_new, tDeleteted	
	local lFirst := .t., obj
	
	for each oRow in ::Super:GetList()
		if lFirst
			lFirst := .f.
			tVar := oRow[ 'SH_B' ]
			tVar1 := oRow[ 'SH_E' ]
		endif
		if ( tVar != oRow[ 'SH_B' ] ) .and. ( tVar1 != oRow[ 'SH_E' ] )
			obj := TICD10Group():New( tID, tSH_B, tSH_E, tName, tRec_new, tDeleteted )
			aadd( aReturn, obj )
			tID			:= oRow[ 'ID' ]
			tSH_B		:= oRow[ 'SH_B' ]
			tSH_E		:= oRow[ 'SH_E' ]
			tName		:= alltrim( oRow[ 'NAME' ] )
			tRec_new	:= oRow[ 'REC_NEW' ]
			tDeleteted	:= oRow[ 'DELETED' ]
			
			tVar := oRow[ 'SH_B' ]
			tVar1 := oRow[ 'SH_E' ]
		elseif ( tVar == oRow[ 'SH_B' ] ) .and. ( tVar1 == oRow[ 'SH_E' ] ) .and. ( oRow[ 'KS' ] == 0 )
			tID			:= oRow[ 'ID' ]
			tSH_B		:= oRow[ 'SH_B' ]
			tSH_E		:= oRow[ 'SH_E' ]
			tName		:= alltrim( oRow[ 'NAME' ] )
			tRec_new	:= oRow[ 'REC_NEW' ]
			tDeleteted	:= oRow[ 'DELETED' ]
		elseif ( tVar == oRow[ 'SH_B' ] ) .and. ( tVar1 == oRow[ 'SH_E' ] ) .and. ( oRow[ 'KS' ] > 0 )
			tName		:= tName + ' ' + alltrim( oRow[ 'NAME' ] )
		endif
	next
	obj := TICD10Group():New( tID, tSH_B, tSH_E, tName, tRec_new, tDeleteted )
	aadd( aReturn, obj )
	return aReturn

METHOD FillFromHash( hbArray )     CLASS TICD10GroupDB
	local obj

	obj := TICD10Group():New( hbArray[ 'ID' ], ;
			hbArray[ 'SH_B' ], ;
			hbArray[ 'SH_E' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	return obj
	