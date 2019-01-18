#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл '_mo_mkb.dbf' - МКБ-10
CREATE CLASS TICD10DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getList()
		METHOD getListByShifr( cShifr, cSH_E )
		METHOD getByShifr( cShifr )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

***********************************
* Создать новый объект TICD10DB
METHOD New() CLASS TICD10DB
	return self

***** получить диагноз по ID
*
METHOD getByID ( nID )		 CLASS TICD10DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
  return ret
	
****** получить список диагнозов
*	
METHOD getList() CLASS TICD10DB
	local aReturn := {}
	local oRow := nil
	local tVar := ''
	local tID, tShifr, tName, tdBegin, tdEnd, tPol, tRec_new, tDeleteted
	local lFirst := .t., obj
	
	for each oRow in ::super:getList()
		if lFirst
			lFirst := .f.
			tVar := oRow[ 'SHIFR' ]
		endif
		if ( tVar != oRow[ 'SHIFR' ] )
			obj := TICD10():New( tID, tShifr, tName, tdBegin, tdEnd, tPol, tRec_new, tDeleteted )
			aadd( aReturn, obj )
			tID			:= oRow[ 'ID' ]
			tShifr		:= oRow[ 'SHIFR' ]
			tName		:= alltrim( oRow[ 'NAME' ] )
			tdBegin		:= oRow[ 'DBEGIN' ]
			tdEnd		:= oRow[ 'DEND' ]
			tPol		:= oRow[ 'POL' ]
			tRec_new	:= oRow[ 'REC_NEW' ]
			tDeleteted	:= oRow[ 'DELETED' ]
			
			tVar := oRow[ 'SHIFR' ]
		elseif ( tVar == oRow[ 'SHIFR' ] ) .and. ( oRow[ 'KS' ] == 0 )
			tID			:= oRow[ 'ID' ]
			tShifr		:= oRow[ 'SHIFR' ]
			tName		:= alltrim( oRow[ 'NAME' ] )
			tdBegin		:= oRow[ 'DBEGIN' ]
			tdEnd		:= oRow[ 'DEND' ]
			tPol		:= oRow[ 'POL' ]
			tRec_new	:= oRow[ 'REC_NEW' ]
			tDeleteted	:= oRow[ 'DELETED' ]
		elseif ( tVar == oRow[ 'SHIFR' ] ) .and. ( oRow[ 'KS' ] > 0 )
			tName		:= tName + ' ' + alltrim( oRow[ 'NAME' ] )
		endif
	next
	obj := TICD10():New( tID, tShifr, tName, tdBegin, tdEnd, tPol, tRec_new, tDeleteted )
	aadd( aReturn, obj )
	return aReturn

****** получить список диагнозов
*	
METHOD getListByShifr( cSH_B, cSH_E ) CLASS TICD10DB
	local aReturn := {}
	local oRow := nil
	local tVar := ''
	local tID, tShifr, tName, tdBegin, tdEnd, tPol, tRec_new, tDeleteted
	local lFirst := .t., obj
	for each oRow in ::super:getList()
		if ( left( oRow[ 'SHIFR' ], 3 ) >= cSH_B ) .and. ( left( oRow[ 'SHIFR' ], 3 ) <= cSH_E )
			if lFirst
				lFirst := .f.
				tVar := oRow[ 'SHIFR' ]
			endif
			if ( tVar != oRow[ 'SHIFR' ] )
				obj := TICD10():New( tID, tShifr, tName, tdBegin, tdEnd, tPol, tRec_new, tDeleteted )
				aadd( aReturn, obj )
				tID			:= oRow[ 'ID' ]
				tShifr		:= oRow[ 'SHIFR' ]
				tName		:= alltrim( oRow[ 'NAME' ] )
				tdBegin		:= oRow[ 'DBEGIN' ]
				tdEnd		:= oRow[ 'DEND' ]
				tPol		:= oRow[ 'POL' ]
				tRec_new	:= oRow[ 'REC_NEW' ]
				tDeleteted	:= oRow[ 'DELETED' ]
			
				tVar := oRow[ 'SHIFR' ]
			elseif ( tVar == oRow[ 'SHIFR' ] ) .and. ( oRow[ 'KS' ] == 0 )
				tID			:= oRow[ 'ID' ]
				tShifr		:= oRow[ 'SHIFR' ]
				tName		:= alltrim( oRow[ 'NAME' ] )
				tdBegin		:= oRow[ 'DBEGIN' ]
				tdEnd		:= oRow[ 'DEND' ]
				tPol		:= oRow[ 'POL' ]
				tRec_new	:= oRow[ 'REC_NEW' ]
				tDeleteted	:= oRow[ 'DELETED' ]
			elseif ( tVar == oRow[ 'SHIFR' ] ) .and. ( oRow[ 'KS' ] > 0 )
				tName		:= tName + ' ' + alltrim( oRow[ 'NAME' ] )
			endif
		endif
	next
	obj := TICD10():New( tID, tShifr, tName, tdBegin, tdEnd, tPol, tRec_new, tDeleteted )
	aadd( aReturn, obj )
	return aReturn
	
****** получить диагноз по шифру
*	
METHOD getByShifr( cShifr ) CLASS TICD10DB
	local cOldArea, mkb
	local ret := nil
	local hArray
	
	cOldArea := Select()
	if ::super:RUse()
		mkb := Select()
		if (mkb)->(dbSeek( cShifr ))
			hArray := ::super:currentRecord()
			if !empty( hArray )
				ret := ::FillFromHash( hArray )
			endif
			// проверим есть ли продолжение для этого шифра
			do while !( ( hArray := ::super:nextRecord() ) != nil ) .and. ( hArray[ 'SHIFR' ] == cShifr )
				ret:Name := ret:Name + alltrim( hArray[ 'NAME' ] )
			enddo
		endif
		(mkb)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TICD10DB
	local obj
	
	obj := TICD10():New( hbArray[ 'ID' ], ;
			hbArray[ 'SHIFR' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'DBEGIN' ], ;
			hbArray[ 'DEND' ], ;
			hbArray[ 'POL' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	return obj