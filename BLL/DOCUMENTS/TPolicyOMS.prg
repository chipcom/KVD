#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// ?« aa ®??ae? ie?© ?®«?a Z?‘, ­? ?a??i§ ­ ? ?®­?a?a­®¬a a ©«a ?„
CREATE CLASS TPolicyOMS
	VISIBLE:
		PROPERTY PolicyType AS NUMERIC READ getPolicyType WRITE setPolicyType		// ??¤ ?®«?a  (®a 1 ¤® 3) 1-aa ae©,2-?a?¬.,3-­®?e©;?® a¬®«c ­?i 1 - aa ae©
		PROPERTY PolicySeries AS STRING READ getPolicySeries WRITE setPolicySeries	// a?a?i ?®«?a , ¤«i ­ e?a - a §¤?«?ai ?® ?a®??«a
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber WRITE setPolicyNumber	// ­®¬?a ?®«?a , '¤«i ?­®?®a®¤­?a - ?e­aai ?§ ""k_inog"" ? a §¤?«?ai'
		PROPERTY SMO AS STRING READ getSMO WRITE setSMO								// a??aaa®?e© ­®¬?a ‘?Z, ?a?®?a §®? ai ?§ aa aea ?®¤®? ? ­®?e?, ?­®?a®¤­?? = 34
		PROPERTY BeginPolicy AS DATE READ getBeginPolicy WRITE setBeginPolicy	// ¤ a  ­ c «  ¤?©aa??i ?®«?a 
		PROPERTY PolicyPeriod AS DATE READ getPolicyPeriod WRITE setPolicyPeriod		// aa®? ¤?©aa??i ?®«?a 
		PROPERTY OKATOInogSMO AS STRING READ getOKATOInogSMO WRITE setOKATOInogSMO		// ZSˆ’Z ?­®?®a®¤­?© aaa a®?®© ?®¬? ­??
		PROPERTY NameInogSMO AS STRING READ getNameInogSMO WRITE setNameInogSMO		// ­ ?¬?­®? ­?? ?­®?®a®¤­?© aaa a®?®© ?®¬? ­??
		PROPERTY IsInogSMO AS LOGICAL READ getIsInogSmo WRITE setIsInogSMO
		PROPERTY Owner AS OBJECT READ getOwner WRITE setOwner
		PROPERTY AsString READ GetAsString( ... )						// ?a?¤aa ?«?­?? ¤®?a¬?­a  ?® aaa ­®?«?­­®© a®a¬ a­®© aaa®??
		PROPERTY Format READ FFormat WRITE SetFormat						// a®a¬ a­ i aaa®?  ?e?®¤  ?a?¤aa ?«?­?i ¤®?a¬?­a 
		
		CLASSDATA	aMenuType	AS ARRAY	INIT { { 'aa ae©', 1 }, ;
												{ '?a?¬. ', 2 }, ;
												{ '­®?e© ', 3 } }

		METHOD New( nType, cSeries, cNumber, cSMO, dBeginPolicy, dPolicyPeriod )
	HIDDEN:
		// a®a¬ a­ i aaa®? : TYPE - a?? ?®«?a , SSS - a?a?i, NNN - ­®¬?a, ISSUE - ?a® ?e¤ «, DATE - ¤ a  ?e¤ c?
		DATA FFormat INIT 'TYPE SSS u NNN'
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
		METHOD getPolicyType
		METHOD setPolicyType( param )
		METHOD getPolicySeries
		METHOD setPolicySeries( param )
		METHOD getPolicyNumber
		METHOD setPolicyNumber( param )
		METHOD getSMO
		METHOD setSMO( param )
		METHOD getBeginPolicy
		METHOD setBeginPolicy( param )
		METHOD getPolicyPeriod
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

METHOD function getPolicyType ()	CLASS TPolicyOMS
	return ::FPolicyType

METHOD PROCEDURE setPolicyType ( param )	CLASS TPolicyOMS

	if isnumber( param )
		::FPolicyType := param
	endif
	return

METHOD function getPolicySeries ()	CLASS TPolicyOMS
	return ::FPolicySeries

METHOD PROCEDURE setPolicySeries( param )	CLASS TPolicyOMS

	if ischaracter( param )
		::FPolicySeries := padr( param, 10 )
	endif
	return

METHOD function getPolicyNumber ()	CLASS TPolicyOMS
	return ::FPolicyNumber

METHOD PROCEDURE setPolicyNumber( param )	CLASS TPolicyOMS

	if ischaracter( param )
		::FPolicyNumber := padr( param, 20 )
	endif
	return

METHOD function getSMO()	CLASS TPolicyOMS
	return ::FSMO

METHOD PROCEDURE setSMO( param )	CLASS TPolicyOMS

	if ischaracter( param )
		::FSMO := padr( param, 5 )
	endif
	return

METHOD function getBeginPolicy() CLASS TPolicyOMS
	return ::FBeginPolicy
	
METHOD procedure setBeginPolicy( param ) CLASS TPolicyOMS

	if isdate( param )
		::FBeginPolicy := param
	endif
	return

METHOD FUNCTION getPolicyPeriod()		CLASS TPolicyOMS
	return ::FPolicyPeriod

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
	local len
	local oPublisher := nil
	local ch
	local mismo, m1ismo := '', mnameismo := space( 100 )
	local mnamesmo, m1namesmo
	local picture_number := "@R 9999 9999 9999 9999"
	
	
	if empty( format )
		format := ::FFormat
	endif
	&& numToken := NumToken( format, ' ' )
	numToken := NumToken( format )
	for i := 1 to numToken
		&& tk := Token( format, ' ', i )
		tk := Token( format, , i )
		ch := alltrim( TokenSep( .t. ) )
		tkSep := ' '
		itm := upper( tk )
		len := len( itm )
		do case
		case alltrim( itm ) == 'TYPE'
			if ( j := ascan( ::aMenuType, { | x | x[ 2 ] == ::FPolicyType } ) ) > 0
				s := alltrim( ::aMenuType[ j, 1 ] )
			endif
		case alltrim( itm ) == 'SSS'
			s := alltrim( ::FPolicySeries )
		case alltrim( itm ) == 'NNN'
			if ::FPolicyType == 3
				s := transform( ::FPolicyNumber, picture_number )
			else
				s := ::FPolicyNumber
			endif
			&& s := alltrim( ::FPolicyNumber )
			s := alltrim( s )
		case alltrim( itm ) == 'ISSUE'
			if alltrim( ::FSMO ) == '34' .and. len( alltrim( ::FSMO ) ) == 2
				mnameismo := ret_inogSMO_name_bay(  ::FOwner, self )
			elseif left( ::FSMO, 2 ) == '34'
				// ‚®«?®?a ¤a? i ®?« aai
			elseif ! empty( ::FSMO )
				m1ismo := ::FSMO
				::FSMO := '34'
			endif
		
			mismo := T_mo_smoDB():getBySMO( m1ismo )
	
			if empty( m1namesmo := int( val( ::FSMO ) ) )
				m1namesmo := glob_arr_smo[ 1, 2 ] // ?® a¬®«c ­?i = S ??a «s ??¤aaa a
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
		
			&& s := alltrim( getNameSMO( self ) )
		case alltrim( itm ) == 'DATE'
			s := dtoc( ::FBeginPolicy )
		otherwise
			s := alltrim( tk )	// ?a®aa® ??a?­®a?¬ a??aa
		endcase
		s += ch
		if s != nil
			asString += iif( i = 1, '', tkSep ) + s
        endif
	next
	return asString