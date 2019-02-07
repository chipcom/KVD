#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
#include 'chip_mo.ch'

********************************
// класс для работы с файлом БД _mo_smo.dbf объектjd иногородних СМО
CREATE CLASS T_mo_smoDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( nCode )
		METHOD getListByOKATO( param )
		METHOD getBySMO( param )
	HIDDEN:                                      
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS T_mo_smoDB
	return self

METHOD function getBySMO( param )    	CLASS T_mo_smoDB
	local hArray := nil, ret := space( 10 )
	local cOldArea
	local cAlias
	local cFind
	local obj
		
	if ! empty( param )
		cFind := padr( param, 5 )
		cOldArea := Select( )
		if ::super:RUse()
			cAlias := Select( )
			(cAlias)->(dbSetOrder( 2 ))
			if (cAlias)->( dbSeek( cFind ) )
				if !empty( hArray := ::super:currentRecord() )
					obj := ::FillFromHash( hArray )
					ret := obj:Name
				endif
			endif
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD function GetListByOKATO( param )    	CLASS T_mo_smoDB
	local hArray := nil, aReturn := {}
	local cOldArea
	local cAlias
	local cFind, strName
	local lengthFind
		
	// получим строку поиска
	cFind := param
	lengthFind := len( param )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 1 ))
		if (cAlias)->( dbSeek( cFind ) )
			do while left( (cAlias)->OKATO, lengthFind ) == cFind .and. !(cAlias)->(eof())
				if !empty( hArray := ::super:currentRecord() )
					obj := ::FillFromHash( hArray )
					strName := alltrim( obj:Name )
					&& if ! empty( obj:EndDate )
						&& strName += ' (до ' + full_date( obj:EndDate ) + ')'
					&& endif
					aadd( aReturn, { strName, obj:SMO } )
				endif
				(cAlias)->(dbSkip())
			enddo
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return aReturn

METHOD GetByID( nID )					CLASS T_mo_smoDB
	local hArray := nil
	local ret := nil
	
	HB_Default( @nID, 0 )
	if ( nID != 0 ) .and. ! empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD FillFromHash( hbArray )			CLASS T_mo_smoDB
	local obj
	
	obj := T_mo_smo():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:OKATO := hbArray[ 'OKATO' ]
	obj:SMO := hbArray[ 'SMO' ]
	obj:Name := hbArray[ 'NAME' ]
	obj:OGRN := hbArray[ 'OGRN' ]
	obj:BeginDate := hbArray[ 'D_BEGIN' ]
	obj:EndDate := hbArray[ 'D_END' ]
	return obj