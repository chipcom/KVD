#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// файл "p_pr_vz.dbf"
CREATE CLASS TCompanyVzaimDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New( oCompany )
		METHOD Save()
		METHOD GetByID( nID )
		METHOD GetList()
		METHOD MenuCompanies( lReverse )
	HIDDEN:
		
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TCompanyVzaimDB
	return self

METHOD GetByID( nID )    CLASS TCompanyVzaimDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .AND. !Empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD GetList()    CLASS TCompanyVzaimDB
	local aReturn := {}
	local oRow := nil
	
	for each oRow in ::super:GetList( )
		aadd( aReturn, ::FillFromHash( oRow ) )
	next
	return aReturn

METHOD MenuCompanies( lReverse )		 CLASS TCompanyVzaimDB
	local aCompany := {}
	local oRow := nil

	hb_Default( @lReverse, .t. )
	for each oRow in ::GetList()
		if lReverse
			aadd( aCompany, { oRow:Name, oRow:ID } )
		else
			aadd( aCompany, { oRow:ID, oRow:Name } )
		endif
	next
	return aCompany

METHOD Save( oCompany ) CLASS TCompanyVzaimDB
	local ret := .f.
	local aHash := nil
	
	if upper( oCompany:classname() ) == upper( 'TCompanyVzaim' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'NAME',		oCompany:Name )
		hb_hSet(aHash, 'FNAME',		oCompany:FullName )
		hb_hSet(aHash, 'INN',		oCompany:INN )
		hb_hSet(aHash, 'ADRES',		oCompany:Address )
		hb_hSet(aHash, 'TELEFON',	oCompany:Phone )
		if oCompany:Bank == nil
			hb_hSet(aHash, 'BANK',		'' )
			hb_hSet(aHash, 'SMFO',		'' )
			hb_hSet(aHash, 'R_SCHET',	'' )
			hb_hSet(aHash, 'K_SCHET',	'' )
		else
			hb_hSet(aHash, 'BANK',		oCompany:Bank:Name )
			hb_hSet(aHash, 'SMFO',		padr( oCompany:Bank:BIK, 10 ) )
			hb_hSet(aHash, 'R_SCHET',	padr( oCompany:Bank:RSchet, 20 ) )
			hb_hSet(aHash, 'K_SCHET',	padr( oCompany:Bank:KSchet, 20 ) )
		endif
		hb_hSet(aHash, 'N_DOG',		oCompany:Dogovor )
		hb_hSet(aHash, 'D_DOG',		oCompany:Date )
		hb_hSet(aHash, 'ID',		oCompany:ID )
		hb_hSet(aHash, 'REC_NEW',	oCompany:IsNew )
		hb_hSet(aHash, 'DELETED',	oCompany:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oCompany:ID := ret
			oCompany:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TCompanyVzaimDB
	local obj, oBank

	oBank := TBank():New( hbArray[ 'BANK' ], hbArray[ 'R_SCHET' ], hbArray[ 'K_SCHET' ], hbArray[ 'SMFO' ] )
	obj := TCompanyVzaim():New( hbArray[ 'ID' ], ;
			hbArray[ 'NAME' ], ;
			hbArray[ 'FNAME' ], ;
			hbArray[ 'INN' ], ;
			hbArray[ 'ADRES' ], ;
			hbArray[ 'TELEFON' ], ;
			oBank, ;
			hbArray[ 'N_DOG' ], ;
			hbArray[ 'D_DOG' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	return obj