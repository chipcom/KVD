#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TDisability	INHERIT	TBaseObjectBLL
	VISIBLE:
		CLASSDATA	aMenuType	AS ARRAY	INIT { { 'нет', 0 }, ;
												{ '1 группа', 1 }, ;
												{ '2 группа', 2 }, ;
												{ '3 группа', 3 }, ;
												{ 'дети-инвалиды', 4 } }
		CLASSDATA	aMenuReason	AS ARRAY INIT { { 'общее заболевание', 1 }, ; // Причина инвалидности
					{ 'трудовое увечье', 2 }, ;
					{ 'профессиональное заболевание', 3 }, ;
					{ 'инвалидность с детства', 4 }, ;
					{ 'инвалидность с детства вследствие ранения (боевые действия в период ВОВ)', 5 }, ;
					{ 'военная травма', 6 }, ;
					{ 'заболевание получено в период военной службы', 7 }, ;
					{ 'заболевание радиационное (при исполнении военной службы) на Чернобыльской АЭС', 8 }, ;
					{ 'заболевание связано с катастрофой на Чернобыльской АЭС', 9 }, ;
					{ 'заболевание (иные обязанности исполнения военной службы) на Чернобыльской АЭС', 10 }, ;
					{ 'заболевание связано с аварией на ПО "Маяк"', 11 }, ;
					{ 'заболевание (иные обязанности исполнения военной службы) на ПО "Маяк"', 12 }, ;
					{ 'заболевание связано с последствиями радиационных воздействий', 13 }, ;
					{ 'заболевание радиационное (при исполнении военной службы) подразд.особого риска', 14 }, ;
					{ 'заболевание (ранение) при обслуживавании в/ч ВС СССР и РФ, воюющих за рубежом', 15 }, ;
					{ 'иные причины, установленные законодательством РФ', 16 } }

		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient	// идентификато пациента (номер записи по БД kartotek)
		PROPERTY Invalid AS NUMERIC READ getInvalid WRITE setInvalid			// группа инвалидности из класса TPatientExt
		PROPERTY DegreeOfDisability AS NUMERIC READ getDegreeOfDisability WRITE setDegreeOfDisability	// степень инвалидности из класса TPatientExt
		PROPERTY Date AS DATE READ getDate WRITE setDate						// дата первичного установления инвалидности
		PROPERTY Reason AS NUMERIC READ getReason WRITE setReason			// причина первичного установления инвалидности
		PROPERTY Diagnosis AS STRING READ getDiagnosis WRITE setDiagnosis	// 
		PROPERTY AsString READ GetAsString( ... )						// представление документа по установленной форматной строке
		PROPERTY Format READ FFormat WRITE SetFormat						// форматная строка вывода представления документа
		
		&& PROPERTY Patient AS OBJECT WRITE setPatient
		METHOD setPatient( param )	INLINE ( ::FPatient := if( isobject( param ) .and. param:classname == upper( 'TPatient' ), param, nil ) )
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FFormat INIT 'GROUP DEGREE DATE'
		DATA FIDPatient INIT 0
		DATA FInvalid INIT 0
		DATA FDegreeOfDisability INIT 0
		DATA FDate INIT ctod( '' )
		DATA FReason INIT 0
		DATA FDiagnosis INIT space( 5 )
		DATA FPatient INIT nil

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getInvalid
		METHOD setInvalid( param )
		METHOD getDegreeOfDisability
		METHOD setDegreeOfDisability( param )
		METHOD getDate
		METHOD setDate( param )
		METHOD getReason
		METHOD setReason( param )
		METHOD getDiagnosis
		METHOD setDiagnosis( param )
		METHOD GetAsString( format )
		METHOD SetFormat( format ) INLINE ::FFormat := format
		&& METHOD setPatient( param )
ENDCLASS

&& METHOD procedure setPatient( param )		CLASS TDisability

	&& if isobject( param ) .and. param:classname == upper( 'TPatient' )
		&& ::FPatient := param
	&& endif
	&& return

METHOD function getIDPatient()		CLASS TDisability
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TDisability
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getInvalid()		CLASS TDisability
	return ::FInvalid

METHOD procedure setInvalid( param )		CLASS TDisability
	
	if isnumber( param )
		::FInvalid := param
		// оповестим класс TPatient
		if __objHasMsgAssigned( ::FPatient:ExtendInfo, 'setInvalid' )
			__objSendMsg( ::FPatient:ExtendInfo, 'setInvalid', param )
		endif
	endif
	return

METHOD function getDegreeOfDisability()		CLASS TDisability
	return ::FDegreeOfDisability

METHOD procedure setDegreeOfDisability( param )		CLASS TDisability
	
	if isnumber( param )
		::FDegreeOfDisability := param
	endif
	return

METHOD function getDate()		CLASS TDisability
	return ::FDate

METHOD procedure setDate( param )		CLASS TDisability
	
	if isdate( param )
		::FDate := param
	endif
	return

METHOD function getReason()		CLASS TDisability
	return ::FReason

METHOD procedure setReason( param )		CLASS TDisability
	
	if isnumber( param )
		::FReason := param
	endif
	return

METHOD function getDiagnosis()		CLASS TDisability
	return ::FDiagnosis

METHOD procedure setDiagnosis( param )		CLASS TDisability
	
	if ischaracter( param )
		::FDiagnosis := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TDisability

	::super:new( nID, lNew, lDeleted )
	return self

METHOD FUNCTION GetAsString( format ) CLASS TDisability
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
		case alltrim( itm ) == 'GROUP'
			if ( j := ascan( ::aMenuType, { | x | x[ 2 ] == ::FInvalid } ) ) > 0
				s := alltrim( ::aMenuType[ j, 1 ] )
			endif
		case alltrim( itm ) == 'DEGREE'
			s := str( ::FDegreeOfDisability )
		case alltrim( itm ) == 'DATE'
			s := dtoc( ::FDate )
		otherwise
			s := alltrim( tk )	// просто переносим текст
		endcase
		s += ch
		if s != nil
			asString += iif( i = 1, '', tkSep ) + s
        endif
	next
	return asString