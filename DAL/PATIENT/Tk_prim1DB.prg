#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'
#include 'chip_mo.ch'

CREATE CLASS Tk_prim1DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nID )
		METHOD getByPatient( param )
		METHOD Delete( param )
		METHOD Save( oK_prim1 )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS Tk_prim1DB
	return self

METHOD Delete( param )		CLASS Tk_prim1DB
	local cOldArea, cAlias, cFind
	local hArray, obj, aObject := {}, item

	if isnumber( param )
		cFind := str( param, 7 )
	elseif isobject( param ) .and. param:classname() == upper( 'TPatient' )
		param := param:ID
		cFind := str( param, 7 )
	else
		return
	endif
	// сначала соберем все объекты
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSeek( cFind ) )
		do while (cAlias)->kod == param .and. !(cAlias)->( eof() )
			if !empty( hArray := ::super:currentRecord() )
				obj := ::FillFromHash( hArray )
				aadd( aObject, obj )
				&& ::super:Delete( obj )
			endif
			(cAlias)->( dbSkip() )
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	// удалим объекты
	for each item in aObject
		::super:Delete( item )
	next
	return

METHOD getByPatient( param )		 CLASS Tk_prim1DB
	local cOldArea, cAlias, cFind
	local ret := ''
	
	if isnumber( param )
		cFind := str( param, 7 )
	elseif isobject( param ) .and. param:classname() == upper( 'TPatient' )
		param := param:ID
		cFind := str( param, 7 )
	else
		return ret
	endif
	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->(dbSeek( cFind ) )
		do while (cAlias)->kod == param .and. !(cAlias)->( eof() )
			ret += rtrim( (cAlias)->name ) + eos
			(cAlias)->( dbSkip() )
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByID( nID )		 CLASS Tk_prim1DB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( oK_prim1 ) CLASS Tk_prim1DB
	local ret := .f.
	local aHash := nil

	if upper( oK_prim1:classname() ) == upper( 'Tk_prim1' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD', oK_prim1:IDPatient )
		hb_hSet( aHash, 'STROKE', oK_prim1:Stroke )
		hb_hSet( aHash, 'NAME', oK_prim1:Name )

		hb_hSet(aHash, 'ID',			oK_prim1:ID )
		hb_hSet(aHash, 'REC_NEW',		oK_prim1:IsNew )
		hb_hSet(aHash, 'DELETED',		oK_prim1:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oK_prim1:ID := ret
			oK_prim1:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS Tk_prim1DB
	local obj
	
	obj := Tk_prim1():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:IDPatient := hbArray[ 'KOD' ]
	obj:Stroke  := hbArray[ 'STROKE' ]
	obj:Name  := hbArray[ 'NAME' ]
	return obj
