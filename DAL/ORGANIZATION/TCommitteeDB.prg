#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл "komitet.dbf" комитеты
CREATE CLASS TCommitteeDB		INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( oCommittee )
	
		METHOD getByID ( nID )
		METHOD getByCode ( nCode )
		METHOD GetList( )
	PROTECTED:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		 CLASS TCommitteeDB
	return self
			
METHOD getByID ( nID )		 CLASS TCommitteeDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !Empty( hArray := ::super:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getByCode ( nCode )		 CLASS TCommitteeDB

	return ::getByID( nCode )

METHOD GetList()   CLASS TCommitteeDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )		// все
	next
	return aReturn
	
* Сохранить объект TCommitteeDB
*
METHOD Save( oCommittee ) CLASS TCommitteeDB
	local ret := .F.
	local aHash := nil
	
	if upper( oCommittee:classname() ) == upper( 'TCommittee' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',			oCommittee:Code )
		hb_hSet(aHash, 'NAME',			oCommittee:Name )
		hb_hSet(aHash, 'FNAME',			oCommittee:FullName )
		hb_hSet(aHash, 'ADRES',			oCommittee:Address )
		hb_hSet(aHash, 'INN',			oCommittee:INN )
		hb_hSet(aHash, 'TELEFON',		oCommittee:Phone )
		if oCommittee:Bank == nil
			hb_hSet(aHash, 'BANK',		'' )
			hb_hSet(aHash, 'SMFO',		'' )
			hb_hSet(aHash, 'R_SCHET',	'' )
			hb_hSet(aHash, 'K_SCHET',	'' )
		else
			hb_hSet(aHash, 'BANK',		oCommittee:Bank:Name )
			hb_hSet(aHash, 'SMFO',		padr( oCommittee:Bank:BIK, 10 ) )
			hb_hSet(aHash, 'R_SCHET',	padr( oCommittee:Bank:RSchet, 20 ) )
			hb_hSet(aHash, 'K_SCHET',	padr( oCommittee:Bank:KSchet, 20 ) )
		endif
		hb_hSet(aHash, 'OKONH',			oCommittee:OKONH )
		hb_hSet(aHash, 'OKPO',			oCommittee:OKPO )
		hb_hSet(aHash, 'PARAKL',		oCommittee:Paraclinika )
		hb_hSet(aHash, 'IST_FIN',		oCommittee:SourceFinance )
		
		hb_hSet(aHash, 'ID',			oCommittee:ID )
		hb_hSet(aHash, 'REC_NEW',		oCommittee:IsNew )
		hb_hSet(aHash, 'DELETED',		oCommittee:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oCommittee:ID := ret
			oCommittee:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TCommitteeDB
	local obj, oBank

	oBank := TBank():New( hbArray[ 'BANK' ], hbArray[ 'R_SCHET' ], hbArray[ 'K_SCHET' ], hbArray[ 'SMFO' ] )
	obj := TCommittee():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Code			:= hbArray[ 'KOD' ]
	obj:Name			:= hbArray[ 'NAME' ]
	obj:FullName		:= hbArray[ 'FNAME' ]
	obj:INN				:= hbArray[ 'INN' ]
	obj:Address			:= hbArray[ 'ADRES' ]
	obj:Phone			:= hbArray[ 'TELEFON' ]
	obj:Bank			:= oBank
	obj:OKONH			:= hbArray[ 'OKONH' ]
	obj:OKPO			:= hbArray[ 'OKPO' ]
	obj:Paraclinika		:= hbArray[ 'PARAKL' ]
	obj:SourceFinance	:= hbArray[ 'IST_FIN' ]

	return obj