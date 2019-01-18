#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'common.ch'

// файл 'uslugi.dbf'
CREATE CLASS TService	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Code READ getCode WRITE setCode
		PROPERTY CodeUp READ getCodeUp WRITE setCodeUp
		PROPERTY Name READ getName WRITE setName
		PROPERTY Name1251 READ getName1251
		PROPERTY Slugba AS OBJECT READ getSlugba WRITE setSlugba						// объект службы
		PROPERTY Gruppa READ getGruppa WRITE setGruppa
		PROPERTY DentalFormula READ getDentalFormula WRITE setDentalFormula
		PROPERTY Profil READ getProfil WRITE setProfil
		
		PROPERTY FullName READ getFullName WRITE setFullName
		PROPERTY FullName1251 READ getFullName1251
		PROPERTY NameToPOS READ getNameToPOS
		
		PROPERTY Shifr READ getShifr WRITE setShifr
		PROPERTY Shifr1251 READ getShifr1251
		PROPERTY Shifr1 READ getShifr1 WRITE setShifr1
		PROPERTY Shifr1_1251 READ getShifr1_1251
		PROPERTY AllowNull READ getAllowNull WRITE setAllowNull
		PROPERTY AllowNullPaid READ getAllowNullPaid WRITE setAllowNullPaid
		PROPERTY PercentVAT READ getPercentVAT WRITE setPercentVAT					// процент НДС для взрослых
		PROPERTY PercentVATChild READ getPercentVATChild WRITE setPercentVATChild    // процент НДС для детей
		PROPERTY PriceDMS READ getPriceDMS WRITE setPriceDMS
		
		PROPERTY WithDoctor READ getWithDoctor
		PROPERTY WithAssistant READ getWithAssistant
		
		METHOD New( nId, lNew, lDeleted )
		METHOD Price( param, nTask )
		METHOD PriceChild( param, nTask )
		METHOD CalculatePrice( lAdult, lDMS )
		METHOD CalculateNDS( lAdult, lDMS )
		METHOD IsAllowedSubdivision( nSub )
	HIDDEN:
		DATA FCode			INIT 0
		DATA FCodeUp		INIT 0
		DATA FName			INIT space( 65 )
		DATA FFullName		INIT space( 255 )
		DATA FShifr			INIT space( 10 )
		DATA FShifr1		INIT space( 10 )
		DATA FAllowNull		INIT .f.
		DATA FAllowNullPaid	INIT .f.
		DATA FPercentVAT	INIT 0
		DATA FPercentVATChild	INIT 0
		DATA FGruppa		INIT 0
		DATA FDentalFormula	INIT 0
		DATA FIdProfil		INIT 0
		DATA FIdSlugba		INIT nil
		DATA FPriceDMS		INIT 0
		DATA FPrice			INIT 0
		DATA FPriceChild	INIT 0
		DATA FPricePaid		INIT 0
		DATA FPriceChildPaid		INIT 0
		DATA FWithDoctor	INIT nil
		DATA FWithAssistant	INIT nil
		
		METHOD getCode
		METHOD setCode( nVal )
		METHOD getCodeUp
		METHOD setCodeUp( nVal )
		METHOD getName
		METHOD getName1251
		METHOD setName( cVal )
		METHOD getFullName
		METHOD getFullName1251
		METHOD setFullName( cVal )
		METHOD getNameToPOS
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cVal )
		METHOD getShifr1
		METHOD getShifr1_1251
		METHOD setShifr1( cVal )
		METHOD getAllowNull
		METHOD setAllowNull( lVal )
		METHOD getAllowNullPaid
		METHOD setAllowNullPaid( lVal )
		METHOD getPercentVAT
		METHOD setPercentVAT( nVal )
		METHOD getPercentVATChild
		METHOD setPercentVATChild( nVal )
		METHOD getPriceDMS
		METHOD setPriceDMS( nVal )
		METHOD getWithDoctor
		METHOD getWithAssistant
		METHOD getSlugba
		METHOD setSlugba( param )
		METHOD getGruppa
		METHOD setGruppa( nVal )
		METHOD getDentalFormula
		METHOD setDentalFormula( nVal )
		METHOD getProfil
		METHOD setProfil( nVal )
ENDCLASS

METHOD function getSlugba()				CLASS TService
	return ::FIdSlugba

METHOD procedure setSlugba( param )		CLASS TService
	if isnumber( param )
		::FIdSlugba := TSlugbaDB():GetByID( param )
	elseif isobject( param ) .and. param:ClassName() == upper( 'TSlugba' )
		::FIdSlugba := param
	elseif isnil( param )
		::FIdSlugba := nil
	endif
	return

METHOD function getNameToPOS				CLASS TService
	return alltrim( iif( empty( ::FFullName ), ::FName, ::FFullName ) )

METHOD FUNCTION getCode() CLASS TService
	return ::FCode

METHOD PROCEDURE setCode( nVal ) CLASS TService
	::FCode := nVal
	return

METHOD FUNCTION getCodeUp() CLASS TService
	return ::FCodeUp

METHOD PROCEDURE setCodeUp( nVal ) CLASS TService
	::FCodeUp := nVal
	return

METHOD FUNCTION getGruppa() CLASS TService
	return ::FGruppa

METHOD PROCEDURE setGruppa( nVal ) CLASS TService
	::FGruppa := nVal
	return

METHOD FUNCTION getDentalFormula() CLASS TService
	return ::FDentalFormula

METHOD PROCEDURE setDentalFormula( nVal ) CLASS TService
	::FDentalFormula := nVal
	return

METHOD FUNCTION getProfil() CLASS TService
	return ::FIdProfil

METHOD PROCEDURE setProfil( nVal ) CLASS TService
	::FIdProfil := nVal
	return

METHOD FUNCTION getName()				CLASS TService
	return ::FName

METHOD FUNCTION getName1251()			CLASS TService
	return win_OEMToANSI( ::FName )

METHOD PROCEDURE setName( cVal )		CLASS TService
	::FName := cVal
	return

METHOD FUNCTION getFullName()				CLASS TService

	if empty( ::FFullName )
		return ::FName
	else
		return ::FFullName
	endif

METHOD FUNCTION getFullName1251()			CLASS TService
	return win_OEMToANSI( ::getFullName() )

METHOD PROCEDURE setFullName( cVal )		CLASS TService
	::FFullName := cVal
	return
METHOD FUNCTION getShifr()				CLASS TService
	return ::FShifr

METHOD FUNCTION getShifr1251()			CLASS TService
	return win_OEMToANSI( ::FShifr )

METHOD PROCEDURE setShifr( cVal )	CLASS TService
	::FShifr := cVal
	return

METHOD FUNCTION getShifr1()				CLASS TService
	return ::FShifr1

METHOD FUNCTION getShifr1_1251()			CLASS TService
	return win_OEMToANSI( ::FShifr1 )

METHOD PROCEDURE setShifr1( cVal )	CLASS TService
	::FShifr1 := cVal
	return

METHOD FUNCTION getAllowNull()	CLASS TService
	return ::FAllowNull
	
METHOD PROCEDURE setAllowNull( lVal )	CLASS TService
	::FAllowNull := lVal
	return
	
METHOD FUNCTION getAllowNullPaid()	CLASS TService
	return ::FAllowNullPaid

METHOD PROCEDURE setAllowNullPaid( lVal )	CLASS TService
	::FAllowNullPaid := lVal
	return

METHOD FUNCTION getPercentVAT()	CLASS TService
	return ::FPercentVAT
	
METHOD PROCEDURE setPercentVAT( nVal )	CLASS TService
	::FPercentVAT := nVal
	return
	
METHOD FUNCTION getPercentVATChild()	CLASS TService
	return ::FPercentVATChild
	
METHOD PROCEDURE setPercentVATChild( nVal )	CLASS TService
	::FPercentVATChild := nVal

METHOD FUNCTION getPriceDMS()
	return ::FPriceDMS
	
METHOD setPriceDMS( nVal )
	::FPriceDMS := nVal
	return

***********************************
* Проверка допустимости работы с услугой в подразделении
* Параметры:
* 	nSub - код подразделения ( Subdivision )
* Возврат:
*	.t. - работа допустима, .f. - работа не допустима
METHOD IsAllowedSubdivision( nSub ) CLASS TService
	local ret := .f., k
	local obj := TServiceBySubdivisionDB():getByIDService( ::ID )
	local stringAllowSubdivision, ch

	if obj == nil
		return .t.
	else
		ret := HasNumberInString( nSub, obj:AllowSubdivision )
		&& k := 1
		&& stringAllowSubdivision := obj:AllowSubdivision
		&& do while !( ( ch := substr( stringAllowSubdivision, k, 1 ) ) == chr( 0 ) )
			&& if asc( ch ) == nSub
				&& ret := .t.
				&& exit
			&& endif
			&& if ++k > 255
				&& ret := .f.
				&& exit
			&& endif
		&& enddo
	endif
	return ret

METHOD Price( param, nTask ) CLASS TService
	local ret := 0

	if pcount() == 0
		ret := ::FPrice						// получим цену ОМС
	elseif pcount() == 1
		::FPrice := param					// установим цену ОМС
	elseif pcount() == 2
		if empty( param )
			switch nTask
				case X_PLATN
					ret := ::FPricePaid			// получим цену ОМС
				case X_OMS
					ret := ::FPrice		// получим цену платных услуг
			endswitch
		else
			if nTask == nil
				::FPricePaid := param			// установим цену ОМС
			else
				switch nTask
					case X_PLATN
						::FPricePaid := param	// установим цену ОМС
					case X_OMS
						::FPrice := param	// установим цену платных услуг
				endswitch
			endif
		endif
	endif
	return ret

METHOD PriceChild( param, nTask ) CLASS TService
	local ret := 0

	if pcount() == 0
		ret := ::FPriceChild					// получим цену ОМС
	elseif pcount() == 1
		::FPriceChild := param				// установим цену ОМС
	elseif pcount() == 2
		if empty( param )
			switch nTask
				case X_PLATN
					ret := ::FPriceChild		// получим цену ОМС
				case X_OMS
					ret := ::FPriceChildPaid		// получим цену платных услуг
			endswitch
		else
			if nTask == nil
				::FPriceChildPaid := param		// установим цену ОМС
			else
				switch nTask
					case X_PLATN
						::FPriceChild := param	// установим цену ОМС
					case X_OMS
						::FPriceChildPaid := param// установим цену платных услуг
				endswitch
			endif
		endif
	endif
	return ret

METHOD function getWithDoctor()				CLASS TService
	local obj := nil
	
	if ::FWithDoctor == nil
		if ( obj := TServiceWoDoctorDB():getByShifr( ::FShifr ) ) != nil
			::FWithDoctor := !obj:IsDoctor
			::FWithAssistant := !obj:IsAssistant
		else
			::FWithDoctor := .t.
			::FWithAssistant := .t.
		endif
	endif
	return ::FWithDoctor

METHOD function getWithAssistant()			CLASS TService
	local obj := nil
	
	if ::FWithAssistant == nil
		if ( obj := TServiceWoDoctorDB():getByShifr( ::FShifr ) ) != nil
			::FWithDoctor := !obj:IsDoctor
			::FWithAssistant := !obj:IsAssistant
		else
			::FWithDoctor := .t.
			::FWithAssistant := .t.
		endif
	endif
	return ::FWithAssistant

METHOD New( nId, lNew, lDeleted ) CLASS TService
			
	::super:new( nID, lNew, lDeleted )
	return self

METHOD CalculatePrice( lAdult, lDMS )		 CLASS TService
	local ret := 0
	
	// берем цену для платных услуг
	if hb_defaultValue( lDms, .f. )
		// если цена ДМС отсутствует берем цену взрослого
		ret := if( ::FPriceDMS != 0, ::FPriceDMS, ::FPricePaid )
	else
		if hb_defaultValue( lAdult, .t. )
			ret := ::FPricePaid
		else
			if !Empty( ::FPriceChildPaid )
				ret := ::FPriceChildPaid
			else
				ret := ::FPricePaid
			endif
		endif
	endif
	return ret
	
METHOD CalculateNDS( lAdult, lDMS )		 CLASS TService
	local ret := 0
	
	// берем НДС для платных услуг
	if hb_defaultValue( lDms, .f. )
		ret := ::FPercentVAT
	else
		if hb_defaultValue( lAdult, .t. )
			ret := ::FPercentVAT
		else
			ret := ::FPercentVATChild
		endif
	endif
	return ret
