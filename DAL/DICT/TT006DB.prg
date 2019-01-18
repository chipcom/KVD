#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник T006 _mo_t006
CREATE CLASS T_T006DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( param )
		&& METHOD getByCode( param )
	HIDDEN:                                      
		METHOD FillFromHash( hbArray )
ENDCLASS

&& METHOD function GetByCode( param )    		CLASS T_T006DB
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

METHOD New()		CLASS T_T006DB
	return self

METHOD GetByID( nID )					CLASS T_T006DB
	local hArray := nil
	local ret := nil
	
	HB_Default( @nID, 0 )
	if ( nID != 0 ) .AND. ! empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD FillFromHash( hbArray )			CLASS T_T006DB
	local obj
	
	obj := T_T006():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:TypeKSG := hbArray[ 'TYPE_KSG' ]
	obj:R0 := hbArray[ 'R0' ]
	obj:R1 := hbArray[ 'R1' ]
	obj:C0 := hbArray[ 'C0' ]
	obj:C8 := hbArray[ 'C8' ]
	obj:C9 := hbArray[ 'C9' ]
	obj:Shifr := hbArray[ 'SHIFR' ]
	obj:Name := hbArray[ 'NAME' ]
	return obj