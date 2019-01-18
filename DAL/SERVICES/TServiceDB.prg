#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл 'uslugi.dbf'
CREATE CLASS TServiceDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD Save( oService )
		METHOD getByID ( nID )
		METHOD getByCode ( nCode )
		METHOD getByShifr ( cShifr )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New() CLASS TServiceDB
			
	return self

METHOD getByCode ( nCode )		 CLASS TServiceDB
	return ::getByID( nCode )

METHOD getByID ( nID )		 CLASS TServiceDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:getById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
  
METHOD getByShifr ( cShifr )		 CLASS TServiceDB
	local cOldArea, uslugi, cFind
	local ret := nil

	// предварительно проверить что пришло строка
	if ! ischaracter( cShifr )
		return ret
	endif
	cShifr := alltrim( cShifr )
	cOldArea := Select( )
	if ::super:RUse()
		uslugi := Select( )
		(uslugi)->(ordSetFocus( 2 ))
		if (uslugi)->(dbSeek( cShifr ) )
			if !empty( hArray := ::super:currentRecord() )
				ret := ::FillFromHash( hArray )
			endif
		endif
		(uslugi)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret
	
METHOD Save( oService ) CLASS TServiceDB
	local ret := .f.
	local aHash := nil
	
	if upper( oService:classname() ) == upper( 'TService' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet(aHash, 'KOD',		oService:Code )
		hb_hSet(aHash, 'KOD_UP',	oService:CodeUp )
		hb_hSet(aHash, 'NAME',		oService:Name )
		hb_hSet(aHash, 'SHIFR',		oService:Shifr )
		hb_hSet(aHash, 'SHIFR1',	oService:Shifr1 )
		hb_hSet(aHash, 'SLUGBA',	oService:IdSlugba )
		&& hb_hSet(aHash, 'KOD_VR',	if( ! isnil( oService:IdSlugba ), oService:IdSlugba:ID, 0 ) )
		hb_hSet(aHash, 'CENA',		oService:Price )
		hb_hSet(aHash, 'CENA_D',	oService:PriceChild )
		hb_hSet(aHash, 'PCENA',		oService:PricePaid )
		hb_hSet(aHash, 'PCENA_D',	oService:PriceChildPaid )
		hb_hSet(aHash, 'DMS_CENA',	oService:PriceDMS )
		hb_hSet(aHash, 'PNDS',		oService:PercentVAT )
		hb_hSet(aHash, 'PNDS_D',	oService:PercentVATChild )
		hb_hSet(aHash, 'IS_NUL',	oService:AllowNull )
		hb_hSet(aHash, 'IS_NULP',	oService:AllowNullPaid )
		hb_hSet(aHash, 'GRUPPA',	oService:Gruppa )
		hb_hSet(aHash, 'ZF',		oService:DentalFormula )
		hb_hSet(aHash, 'FULL_NAME',	oService:FullName )
		hb_hSet(aHash, 'PROFIL',	oService:IdProfil )
		
		hb_hSet(aHash, 'ID',		oService:ID )
		hb_hSet(aHash, 'REC_NEW',	oService:IsNew )
		hb_hSet(aHash, 'DELETED',	oService:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			oService:ID := ret
			oService:IsNew := .f.
		endif
	endif
	return ret
	
METHOD FillFromHash( hbArray )     CLASS TServiceDB
	local obj
	
	obj := TService():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:Code	:= hbArray[ 'KOD' ]
	obj:CodeUp	:= hbArray[ 'KOD_UP' ]
	obj:FullName := hbArray[ 'FULL_NAME' ]
	obj:Name	:= hbArray[ 'NAME' ]
	obj:Shifr	:= hbArray[ 'SHIFR' ]
	obj:Shifr1	:= hbArray[ 'SHIFR1' ]
	obj:Slugba	:= hbArray[ 'SLUGBA' ]
	obj:Gruppa	:= hbArray[ 'GRUPPA' ]
	obj:DentalFormula	:= hbArray[ 'ZF' ]
	obj:Profil	:= hbArray[ 'PROFIL' ]

	obj:Price( hbArray[ 'CENA' ], X_OMS )
	obj:PriceChild( hbArray[ 'CENA_D' ], X_OMS )
	obj:Price( hbArray[ 'PCENA' ], X_PLATN )
	obj:PriceChild( hbArray[ 'PCENA_D' ], X_PLATN )
	obj:PriceDMS	:= hbArray[ 'DMS_CENA' ]
	obj:PercentVAT	:= hbArray[ 'PNDS' ]
	obj:PercentVATChild	:= hbArray[ 'PNDS_D' ]
	obj:AllowNull		:= hbArray[ 'IS_NUL' ]
	obj:AllowNullPaid	:= hbArray[ 'IS_NULP' ]

	return obj