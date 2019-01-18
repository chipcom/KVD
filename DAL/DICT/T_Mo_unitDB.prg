#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник учётных единиц объёма _mo_unit.dbf
CREATE CLASS T_Mo_unitDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( param )
		METHOD getByCodeUnit( param )
		&& METHOD getListByCodeTFOMS( param )
	HIDDEN:                                      
		METHOD FillFromHash( hbArray )
ENDCLASS

&& METHOD function GetListByCodeTFOMS( param )    	CLASS T_Mo_unitDB
	&& local hArray := nil, aReturn := {}
	&& local cOldArea
	&& local cAlias
	&& local cFind
		
	&& // получим строку поиска
	&& cFind := param
	&& cOldArea := Select( )
	&& if ::super:RUse()
		&& cAlias := Select( )
		&& (cAlias)->(dbSetOrder( 1 ))
&& //		(cAlias)->(ordSetFocus( 1 ))
		&& if (cAlias)->( dbSeek( cFind ) )
			&& do while (cAlias)->codemo == glob_mo[ _MO_KOD_TFOMS ] .and. !(cAlias)->(eof())
				&& if !empty( hArray := ::super:currentRecord() )
					&& obj := ::FillFromHash( hArray )
					&& aadd( aReturn, obj )
				&& endif
				&& (cAlias)->(dbSkip())
			&& enddo
		&& endif
		&& (cAlias)->( dbCloseArea() )
		&& dbSelectArea( cOldArea )
	&& endif
/*		tmp_select := select()
		R_Use( exe_dir + '_mo_podr', cur_dir + '_mo_podr', 'PODR' )
		find ( glob_mo[ _MO_KOD_TFOMS ] )
		do while podr->codemo == glob_mo[ _MO_KOD_TFOMS ] .and. !eof()
			aadd( arr, { '(' + alltrim( podr->KODOTD ) + ') ' + alltrim( podr->NAMEOTD ), podr->KODOTD } )
			skip
		enddo
*/	
	&& return aReturn

METHOD function GetByCodeUnit( param )    		CLASS T_Mo_unitDB
	local hArray := nil, ret := nil
	local cOldArea
	local cAlias
	local cFind
		
	// получим строку поиска
	cFind := str( param, 3 )
	cOldArea := Select( )
	if ::super:RUse()
		cAlias := Select( )
		(cAlias)->(dbSetOrder( 1 ))
		if (cAlias)->( dbSeek( cFind ) )
			if ! empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD New()		CLASS T_Mo_unitDB
	return self

METHOD GetByID( nID )					CLASS T_Mo_unitDB
	local hArray := nil
	local ret := nil
	
	HB_Default( @nID, 0 )
	if ( nID != 0 ) .AND. ! empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD FillFromHash( hbArray )			CLASS T_Mo_unitDB
	local obj
	
	obj := T_Mo_unit():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Code := hbArray[ 'CODE' ]
	obj:Name := hbArray[ 'NAME' ]
	obj:PZ := hbArray[ 'PZ' ]
	obj:II := hbArray[ 'II' ]
	obj:DateBegin := hbArray[ 'DATEBEG' ]
	obj:DateEnd := hbArray[ 'DATEEND' ]
	return obj