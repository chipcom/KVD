#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// ?л aa о??ae? ie?й ?ол?a Z?С, н? ?a??iз н ? ?он?a?aномa a йлa ?Д
CREATE CLASS TPolicyOMS
	VISIBLE:
		PROPERTY PolicyType AS NUMERIC READ getPolicyType WRITE setPolicyType		// ??д ?ол?a  (оa 1 до 3) 1-aa aeй,2-?a?м.,3-но?eй;?о aмолc н?i 1 - aa aeй
		PROPERTY PolicySeries AS STRING READ getPolicySeries WRITE setPolicySeries	// a?a?i ?ол?a , длi н e?a - a зд?л?ai ?о ?aо??лa
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber WRITE setPolicyNumber	// ном?a ?ол?a , 'длi ?но?оaодн?a - ?eнaai ?з ""k_inog"" ? a зд?л?ai'
		PROPERTY SMO AS STRING READ getSMO WRITE setSMO								// a??aaaо?eй ном?a С?Z, ?a?о?a зо? ai ?з aa aea ?одо? ? но?e?, ?но?aодн?? = 34
		PROPERTY BeginPolicy AS DATE READ getBeginPolicy WRITE setBeginPolicy	// д a  н c л  д?йaa??i ?ол?a 
		PROPERTY PolicyPeriod AS DATE READ getPolicyPeriod WRITE setPolicyPeriod		// aaо? д?йaa??i ?ол?a 
		PROPERTY OKATOInogSMO AS STRING READ getOKATOInogSMO WRITE setOKATOInogSMO		// ZSИТZ ?но?оaодн?й aaa aо?ой ?ом? н??
		PROPERTY NameInogSMO AS STRING READ getNameInogSMO WRITE setNameInogSMO		// н ?м?но? н?? ?но?оaодн?й aaa aо?ой ?ом? н??
		PROPERTY IsInogSMO AS LOGICAL READ getIsInogSmo WRITE setIsInogSMO
		PROPERTY Owner AS OBJECT READ getOwner WRITE setOwner
		PROPERTY AsString READ GetAsString( ... )						// ?a?дaa ?л?н?? до?aм?нa  ?о aaa но?л?нной aоaм aной aaaо??
		PROPERTY Format READ FFormat WRITE SetFormat						// aоaм aн i aaaо?  ?e?од  ?a?дaa ?л?н?i до?aм?нa 
		
		CLASSDATA	aMenuType	AS ARRAY	INIT { { 'старый', 1 }, ;
												{ 'врем. ', 2 }, ;
												{ 'новый ', 3 } }

		METHOD New( nType, cSeries, cNumber, cSMO, dBeginPolicy, dPolicyPeriod )
	HIDDEN:
		// формат по умолчанию : TYPE - тип полиса, SSS - серия, NNN - номер, ISSUE - издатель, DATE - дата выдачи
		DATA FFormat INIT 'TYPE #SSS #NNN'
		DATA FPolicyType	INIT 1
		DATA FPolicySeries	INIT space( 10 )
		DATA FPolicyNumber	INIT space( 20 )
		DATA FSMO			INIT space( 5 )
		DATA FBeginPolicy	INIT ctod( '' )
		DATA FPolicyPeriod	INIT ctod( '' )
		DATA FOKATOInogSMO	INIT space( 5 )
		DATA FNameInogSMO	INIT space( 100 )
		DATA FIsInogSMO		INIT .f.
		DATA FOwner			INIT nil
		
		METHOD setOwner( param )
		METHOD getOwner			INLINE ::FOwner
		METHOD setIsInogSMO( param )
		METHOD getIsInogSmo		INLINE ::FIsInogSMO
		METHOD setNameInogSMO( param )
		METHOD getNameInogSMO	INLINE ::FNameInogSMO
		METHOD setOKATOInogSMO( param )
		METHOD getOKATOInogSMO	INLINE ::FOKATOInogSMO
		METHOD SetFormat( format ) INLINE ::FFormat := format
		METHOD GetAsString( format )
		METHOD getPolicyType		INLINE ::FPolicyType
		METHOD setPolicyType( param )
		METHOD getPolicySeries	INLINE ::FPolicySeries
		METHOD setPolicySeries( param )
		METHOD getPolicyNumber	INLINE ::FPolicyNumber
		METHOD setPolicyNumber( param )
		METHOD getSMO	INLINE ::FSMO
		METHOD setSMO( param )
		METHOD getBeginPolicy	INLINE ::FBeginPolicy
		METHOD setBeginPolicy( param )
		METHOD getPolicyPeriod	INLINE ::FPolicyPeriod
		METHOD setPolicyPeriod( param )
ENDCLASS

METHOD New( nType, cSeries, cNumber, cSMO, dBeginPolicy, dPolicyPeriod ) CLASS TPolicyOMS

	::FPolicyType := hb_defaultvalue( nType, 1 )
	::FPolicySeries := left( hb_defaultvalue( cSeries, space( 10 ) ), 10 )
	::FPolicyNumber := left( hb_defaultvalue( cNumber, space( 20 ) ), 20 )
	::FSMO := left( hb_defaultvalue( cSMO, space( 5 ) ), 5 )
	::FBeginPolicy := hb_defaultvalue( dBeginPolicy, ctod( '' ) )
	::FPolicyPeriod := hb_defaultvalue( dPolicyPeriod, ctod( '' ) )
	return self

METHOD procedure setOwner( param )		CLASS TPolicyOMS

	if isobject( param )
		::FOwner := param
	endif
	return

METHOD procedure setIsInogSMO( param )		CLASS TPolicyOMS

	if islogical( param )
		::FIsInogSMO := param
	endif
	return

METHOD procedure setNameInogSMO( param )		CLASS TPolicyOMS

	if ischaracter( param )
		::FNameInogSMO := param
	endif
	return

METHOD procedure setOKATOInogSMO( param )		CLASS TPolicyOMS

	if ischaracter( param )
		::FOKATOInogSMO := param
	endif
	return

METHOD PROCEDURE setPolicyType ( param )	CLASS TPolicyOMS

	if isnumber( param )
		::FPolicyType := param
	endif
	return

METHOD PROCEDURE setPolicySeries( param )	CLASS TPolicyOMS

	if ischaracter( param )
		::FPolicySeries := padr( param, 10 )
	endif
	return

METHOD PROCEDURE setPolicyNumber( param )	CLASS TPolicyOMS

	if ischaracter( param )
		::FPolicyNumber := padr( param, 20 )
	endif
	return

METHOD PROCEDURE setSMO( param )	CLASS TPolicyOMS

	if ischaracter( param )
		::FSMO := padr( param, 5 )
	endif
	return

METHOD procedure setBeginPolicy( param ) CLASS TPolicyOMS

	if isdate( param )
		::FBeginPolicy := param
	endif
	return

METHOD PROCEDURE setPolicyPeriod( param )		CLASS TPolicyOMS
	
	if isdate( param )
		::FPolicyPeriod := param
	endif
	return

METHOD FUNCTION GetAsString( format ) CLASS TPolicyOMS
	local asString := ''
	local numToken
	local i
	local j := 0
	local s
	local tk
	local tkSep
	local itm
	local oPublisher := nil
	local ch
	local mismo, m1ismo := '', mnameismo := space( 100 )
	local mnamesmo, m1namesmo
	local picture_number := '@R 9999 9999 9999 9999'
	
	if empty( format )
		format := ::FFormat
	endif
	numToken := NumToken( format, ' ' )	// разделитель подстрок только 'пробел'
	for i := 1 to numToken
		tk := Token( format, ' ', i )	// разделитель подстрок только 'пробел'
		ch := alltrim( TokenSep( .t. ) )
		tkSep := ' '
		itm := upper( alltrim( tk ) )
		do case
		case itm == 'TYPE'
			if ( j := ascan( ::aMenuType, { | x | x[ 2 ] == ::FPolicyType } ) ) > 0
				s := alltrim( ::aMenuType[ j, 1 ] )
			endif
		case itm == 'SSS'
			if ! empty( ::FPolicySeries )
				s := alltrim( ::FPolicySeries )
			endif
		case itm == '#SSS'
			if ! empty( ::FPolicySeries )
				s := 'серия:' + alltrim( ::FPolicySeries )
			endif
		case itm == 'NNN'
			if ! empty( ::FPolicyNumber )
				&& if ::FPolicyType == 3
					&& s := transform( ::FPolicyNumber, picture_number )
				&& else
					&& s := ::FPolicyNumber
				&& endif
				&& s := alltrim( s )
				s := alltrim( if( ::FPolicyType == 3, transform( ::FPolicyNumber, picture_number ), ::FPolicyNumber ) )
			endif
		case itm == '#NNN'
			if ! empty( ::FPolicyNumber )
				&& if ::FPolicyType == 3
					&& s := transform( ::FPolicyNumber, picture_number )
				&& else
					&& s := ::FPolicyNumber
				&& endif
				&& s := '№ ' + alltrim( s )
				s := '№ ' + alltrim( if( ::FPolicyType == 3, transform( ::FPolicyNumber, picture_number ), ::FPolicyNumber ) )
			endif
		case itm == 'ISSUE'
			if alltrim( ::FSMO ) == '34' .and. len( alltrim( ::FSMO ) ) == 2
				mnameismo := ret_inogSMO_name_bay(  ::FOwner, self )
			elseif left( ::FSMO, 2 ) == '34'
				// Волгоград
			elseif ! empty( ::FSMO )
				m1ismo := ::FSMO
				::FSMO := '34'
			endif
		
			mismo := T_mo_smoDB():getBySMO( m1ismo )
	
			if empty( m1namesmo := int( val( ::FSMO ) ) )
				m1namesmo := glob_arr_smo[ 1, 2 ] // ?о aмолc н?i = S ??a лs ??дaaa a
			endif
			mnamesmo := inieditspr( A__MENUVERT, glob_arr_smo, m1namesmo )
			if m1namesmo == 34
				if !empty( mismo )
					mnamesmo := mismo
				elseif !empty( mnameismo )
					mnamesmo := mnameismo
				endif
			endif
			s := alltrim( mnamesmo )
		case itm == 'DATE'
			s := dtoc( ::FBeginPolicy )
		otherwise
			s := alltrim( tk )	// просто переносим текст
		endcase
		s += ch
		if s != nil
			asString += iif( i == 1, '', tkSep ) + s
        endif
	next
	return asString