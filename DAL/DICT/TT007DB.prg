#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник T007 _mo_t007
CREATE CLASS T_T007DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( param )
		&& METHOD getByCode( param )
	HIDDEN:                                      
		METHOD FillFromHash( hbArray )
ENDCLASS

&& METHOD function GetByCode( param )    		CLASS T_T007DB
	&& local hArray := nil, ret := nil
	&& local cOldArea
	&& local cAlias
	&& local cFind
		
	&& // получим строку поиска
	&& cFind := str( param, 3 )
	&& cOldArea := Select( )
	&& if ::super:RUse()
		&& cAlias := Select( )
		&& (cAlias)->(dbSetOrder( 1 ))
		&& if (cAlias)->( dbSeek( cFind ) )
			&& if ! empty( hArray := ::super:currentRecord() )
				&& ret := ::FillFromHash( hArray )
			&& endif
		&& endif
		&& (cAlias)->( dbCloseArea() )
		&& dbSelectArea( cOldArea )
	&& endif
	&& return ret

METHOD New()		CLASS T_T007DB
	return self

METHOD GetByID( nID )					CLASS T_T007DB
	local hArray := nil
	local ret := nil
	
	HB_Default( @nID, 0 )
	if ( nID != 0 ) .AND. ! empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD FillFromHash( hbArray )			CLASS T_T007DB
	local obj
	
	obj := T_T007():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:ProfilK := hbArray[ 'PROFIL_K' ]
	obj:Profil := hbArray[ 'PROFIL' ]
	obj:Name := hbArray[ 'NAME' ]
	return obj