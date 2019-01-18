#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл 'str_komp.dbf' справочник прочих компаний
CREATE CLASS TInsuranceCompanyDB		INHERIT	TCommitteeDB
	VISIBLE:
		METHOD New()
		METHOD Save( oCommittee )
		METHOD getByID ( nID )
		METHOD getByCode ( nCode )
		METHOD GetList( )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		 CLASS TInsuranceCompanyDB
	return self
			
METHOD getByID ( nID )		 CLASS TInsuranceCompanyDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !Empty( hArray := ::super:TBaseObjectDB:GetById( nID ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD getByCode ( nCode )		 CLASS TInsuranceCompanyDB

	return ::getByID( nCode )

METHOD GetList()   CLASS TInsuranceCompanyDB
	local aReturn := {}
	local oRow := nil

	for each oRow in ::super:TBaseObjectDB:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )		// все
	next
	return aReturn
	
* Сохранить объект TInsuranceCompanyDB
*
METHOD Save( oCommittee ) CLASS TInsuranceCompanyDB
	local ret := .F.
	local aHash := nil
	
	if upper( oCommittee:classname() ) == upper( 'TInsuranceCompany' )
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
		hb_hSet(aHash, 'TFOMS',			oCommittee:TFOMS )
		
		hb_hSet(aHash, 'ID',			oCommittee:ID )
		hb_hSet(aHash, 'REC_NEW',		oCommittee:IsNew )
		hb_hSet(aHash, 'DELETED',		oCommittee:IsDeleted )
		if ( ret := ::super:TBaseObjectDB:Save( aHash ) ) != -1
			oCommittee:ID := ret
			oCommittee:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TInsuranceCompanyDB
	local obj, oBank

	oBank := TBank():New( hbArray[ 'BANK' ], hbArray[ 'R_SCHET' ], hbArray[ 'K_SCHET' ], hbArray[ 'SMFO' ] )
	obj := TInsuranceCompany():New( hbArray[ 'ID' ], ;
			hbArray[ 'KOD' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'FNAME' ], ;
			hbArray[ 'INN' ], ;
			hbArray[ 'ADRES' ], ;
			hbArray[ 'TELEFON' ], ;
			oBank, ;
			hbArray[ 'OKONH' ], ;
			hbArray[ 'OKPO' ], ;
			hbArray[ 'TFOMS' ], ;
			hbArray[ 'PARAKL' ], ;
			hbArray[ 'IST_FIN' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj