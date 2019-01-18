#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// ����� ��� �ࠢ�筨� T005 _mo_t005
CREATE CLASS T_T005DB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID( param )
		METHOD getByCode( param )
	HIDDEN:                                      
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD function GetByCode( param )    		CLASS T_T005DB
	local hArray := nil, ret := nil
	local cOldArea
	local cAlias
	local cFind
		
	// ����稬 ��ப� ���᪠
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

METHOD New()		CLASS T_T005DB
	return self

METHOD GetByID( nID )					CLASS T_T005DB
	local hArray := nil
	local ret := nil
	
	HB_Default( @nID, 0 )
	if ( nID != 0 ) .AND. ! empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD FillFromHash( hbArray )			CLASS T_T005DB
	local obj
	
	obj := T_T005():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Code := hbArray[ 'KOD' ]
	obj:Name := hbArray[ 'NAME' ]
	return obj