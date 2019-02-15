#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'

CREATE CLASS TPatient	INHERIT	TBaseObjectBLL

	VISIBLE:
		CLASSDATA	aMenuCategory	AS ARRAY	INIT { { 'взрослый', 0 }, ;
													{ 'ребёнок', 1 }, ;
													{ 'подросток', 2 } }
		CLASSDATA	aMenuWorking	AS ARRAY	INIT { { 'работающий', 0 }, ;
													{ 'неработающий', 1 }, ;
													{ 'обучающ.ОЧНО', 2 } }

		PROPERTY Code AS NUMERIC READ getCode WRITE setCode
		PROPERTY FIO AS STRING READ getFIO WRITE setFIO												// Ф.И.О. больного
		PROPERTY Gender AS CHARACTER READ getGender WRITE setGender									// пол
		PROPERTY DOB AS DATE READ getDOB WRITE setDOB													// дата рождения
		PROPERTY AddressReg AS STRING READ getAddress WRITE setAddressReg				// адрес регистрации
		PROPERTY District AS NUMERIC READ getDistrict WRITE setDistrict								// номер участка
		PROPERTY Bukva AS CHARACTER READ getBukva WRITE setBukva										// одна буква
		PROPERTY Kod_VU AS NUMERIC READ getKod_VU WRITE setKod_VU									// код в участке
		PROPERTY Vzros_Reb AS NUMERIC READ getVzros_Reb WRITE setVzros_Reb							// 0-взрослый, 1-ребенок, 2-подросток
		PROPERTY PlaceWork AS STRING READ getPlaceWork WRITE setPlaceWork							// место работы или причина безработности
		PROPERTY Working AS NUMERIC READ getWorking WRITE setWorking									// 0-работающий, 1-неработающий
		PROPERTY Komu AS NUMERIC READ getKomu WRITE setKomu											// от 1 до 5
		PROPERTY Policy AS STRING READ getPolicy WRITE setPolicy										// серия и номер страхового полиса
		PROPERTY PolicyPeriod AS DATE READ getPolicyPeriod WRITE setPolicyPeriod						// срок действия полиса
		PROPERTY InsuranceID AS NUMERIC READ getInsuranceID WRITE setInsuranceID						// код стр.компании, комитета и т.п.
		PROPERTY AttachmentStatus AS NUMERIC READ getAttachmentStatus WRITE setAttachmentStatus		// тип/статус прикрепления 1-из WQ,2-из реестра СП и ТК,3-из файла прикрепления,4-открепление,5-сверка
		PROPERTY SinglePolicyNumber AS STRING READ getSinglePolicyNumber WRITE setSinglePolicyNumber	// ЕНП - единый номер полиса ОМС
		PROPERTY IsDied AS LOGICAL READ getIsDied WRITE setIsDied									// 0-нет,1-умер по результатам сверки
		PROPERTY SNILS AS STRING READ getSNILS WRITE setSNILS										// СНИЛС
		PROPERTY OutpatientCardNumber AS STRING READ getOutpatientCardNumber WRITE setOutpatientCardNumber	// собственный номер амбулаторной карты
		PROPERTY AreaCodeResidence AS NUMERIC READ getAreaCodeResidence WRITE setAreaCodeResidence	// код района места жительства
		PROPERTY FinanceAreaCode AS NUMERIC READ getFinanceAreaCode WRITE setFinanceAreaCode			// код района финансирования
		PROPERTY Mest_Inog AS NUMERIC READ getMest_Inog WRITE setMest_Inog							// 0-нет, 8 - аноним,9-отдельные ФИО
		PROPERTY Mi_Git AS NUMERIC READ getMi_Git WRITE setMi_Git									// 0-нет, 9-рабочее поле KOMU
		PROPERTY ErrorKartotek AS NUMERIC READ getErrorKartotek WRITE setErrorKartotek				// 0-нет, '-8'-полис недействителен, '-9'-ошибки в реквизитах
		PROPERTY TFOMSEncoding AS NUMERIC READ getTFOMSEncoding WRITE setTFOMSEncoding				// код по кодировке ТФОМС
		PROPERTY MO_added AS STRING READ getMO_added WRITE setMO_added								// код МО прикрепления
		PROPERTY Date_added AS STRING READ getDate_added WRITE setDate_added							// дата прикрепления
		PROPERTY SNILSuchastDoctor AS STRING READ getSNILSuchastDoctor WRITE setSNILSuchastDoctor	// СНИЛС участкового врача
		PROPERTY PC1 AS STRING INDEX 1 READ getPC WRITE setPC
		PROPERTY PC2 AS STRING INDEX 2 READ getPC WRITE setPC
		PROPERTY PC3 AS STRING INDEX 3 READ getPC WRITE setPC
		PROPERTY PN1 AS NUMERIC INDEX 1 READ getPN WRITE setPN
		PROPERTY PN2 AS NUMERIC INDEX 2 READ getPN WRITE setPN
		PROPERTY PN3 AS NUMERIC INDEX 3 READ getPN WRITE setPN

		PROPERTY FIO1251 READ getFIO1251
		PROPERTY LastName AS STRING READ getLastName WRITE setLastName
		PROPERTY FirstName AS STRING READ getFirstName WRITE setFirstName
		PROPERTY MiddleName AS STRING READ getMiddleName WRITE setMiddleName
		PROPERTY IsAnonymous AS LOGICAL READ getAnonymous											// анонимный пациент
		PROPERTY IsDubleName AS LOGICAL READ getIsDubleName											// ФИО состоит из двойных слов
		PROPERTY ShortFIO AS STRING READ getShortFIO()												// получить сокращенное Ф.И.О.
		PROPERTY PlaceBorn AS STRING READ getPlaceBorn WRITE setPlaceBorn							// место рождения
		PROPERTY IsAdult AS LOGICAL READ getIsAdult( ... )											// получить совершеннолетний или нет
		PROPERTY Passport AS OBJECT READ getPassport	 WRITE setPassport								// документ удостоверяющий личность
		PROPERTY AddressRegistration AS OBJECT READ getAddressReg WRITE setAddressReg				// адрес регистрации
		PROPERTY AddressStay AS OBJECT READ getAddressStay WRITE setAddressStay						// адрес пребывания
		PROPERTY PolicyOMS AS OBJECT READ getPolicyOMS WRITE setPolicyOMS							// объект описывающий полис ОМС
		PROPERTY Disability AS OBJECT READ getDisability	 WRITE setDisability								// документ об ивалидности
		
		PROPERTY AddInfo AS OBJECT READ getAddINFO WRITE setAddInfo									// объект TPatientAdd ( kartote2.dbf )
		PROPERTY ExtendInfo AS OBJECT READ getExtendInfo WRITE setExtendInfo							// объекта TPatientExt ( kartote_.dbf )

		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )
		
		METHOD New( nID, lNew, lDeleted )
	
		METHOD forJSON()
	HIDDEN:

		DATA FAddInfo	AS OBJECT INIT nil	// для хранения объекта TPatientAdd ( kartote2.dbf )
		DATA FExtendInfo	AS OBJECT INIT nil	// для хранения объекта TPatientExt ( kartote_.dbf )
		DATA FDisability AS OBJECT INIT nil	// для хранения объекта инвалидности
		
		DATA FCode INIT 0
		DATA FAddress INIT space( 50 )
		DATA FFIO INIT space( 50 )
		DATA FLastName INIT space( 40 )
		DATA FFirstName INIT space( 40 )
		DATA FMiddleName INIT space( 40 )
		DATA FDOB INIT ctod( '' )
		DATA FGender INIT 'М'
		DATA FDistrict INIT 0
		DATA FBukva INIT ' '
		DATA FKod_VU INIT 0
		DATA FVzros_Reb INIT 0
		DATA FPlaceWork INIT space( 50 )
		DATA FWorking INIT 0
		DATA FKomu INIT 1
		DATA FPolicy INIT space( 17 )
		DATA FPolicyPeriod INIT ctod( '' )
		DATA FInsuranceID INIT 0
		DATA FAttachmentStatus INIT 0
		DATA FTFOMSEncoding INIT 0
		DATA FSinglePolicyNumber INIT space( 20 )
		DATA FIsDied INIT .f.
		DATA FSNILS INIT space( 11 )
		DATA FOutpatientCardNumber INIT space( 10 )
		DATA FAreaCodeResidence INIT 0
		DATA FFinanceAreaCode INIT 0
		DATA FMest_Inog INIT 0
		DATA FMi_Git INIT 0
		DATA FErrorKartotek INIT 0

		DATA FMOadded INIT space( 6 )
		DATA FDateAdded INIT ctod( '' )
		DATA FSNILSuchastDoctor INIT space( 6 )
		DATA FPC1	INIT space( 10 )
		DATA FPC2	INIT space( 10 )
		DATA FPC3	INIT space( 10 )

		DATA FPN1	INIT 0
		DATA FPN2	INIT 0
		DATA FPN3	INIT 0

		METHOD getAddInfo
		METHOD setAddInfo( param )
		METHOD getExtendInfo
		METHOD setExtendInfo( param )
		
		METHOD getMO_added
		METHOD setMO_added( param )
		METHOD getDate_added
		METHOD setDate_added( param )
		METHOD getSNILSuchastDoctor
		METHOD setSNILSuchastDoctor( param )
		
		METHOD getPC( index )
		METHOD setPC( index, param )
		METHOD getPN( index )
		METHOD setPN( index, param )
		
		METHOD getCode
		METHOD setCode( param )
		METHOD getFIO
		METHOD setFIO( cFIO )
		METHOD getLastName
		METHOD setLastName( cFIO )
		METHOD getFirstName
		METHOD setFirstName( cFIO )
		METHOD getMiddleName
		METHOD setMiddleName( cFIO )
		METHOD getFIO1251
		METHOD getAnonymous
		METHOD getIsDubleName
		METHOD getShortFIO
		METHOD getGender
		METHOD setGender( cGender )
		METHOD getDOB
		METHOD setDOB( dDate )
		METHOD getPlaceBorn
		METHOD setPlaceBorn( param )
		METHOD getIsAdult( dDate )
		METHOD getPassport
		METHOD setPassport( param )
		METHOD getAddressReg
		METHOD getAddress
		METHOD setAddressReg( param )
		METHOD getAddressStay
		METHOD setAddressStay( param )
		METHOD getDistrict
		METHOD setDistrict( nNum )
		METHOD getBukva
		METHOD setBukva( ch )
		METHOD getKod_VU
		METHOD setKod_VU( nNum )
		METHOD getVzros_Reb
		METHOD setVzros_Reb( nNum )
		METHOD getPlaceWork
		METHOD setPlaceWork( cText )
		METHOD getWorking
		METHOD setWorking( nNum )
		METHOD getKomu
		METHOD setKomu( nNum )
		METHOD getPolicy
		METHOD setPolicy( cText )
		METHOD getPolicyPeriod
		METHOD setPolicyPeriod( dDate )
		METHOD getInsuranceID
		METHOD setInsuranceID( nNum )
		METHOD getAttachmentStatus
		METHOD setAttachmentStatus( nNum )
		METHOD getTFOMSEncoding
		METHOD setTFOMSEncoding( nNum )
		METHOD getSinglePolicyNumber
		METHOD setSinglePolicyNumber( cText )
		METHOD getIsDied
		METHOD setIsDied( logic )
		METHOD getSNILS
		METHOD setSNILS( cText )
		METHOD getOutpatientCardNumber
		METHOD setOutpatientCardNumber( cText )
		METHOD getAreaCodeResidence
		METHOD setAreaCodeResidence( nNum )
		METHOD getFinanceAreaCode
		METHOD setFinanceAreaCode( nNum )
		METHOD getMest_Inog
		METHOD setMest_Inog( nNum )
		METHOD getMi_Git
		METHOD setMi_Git( nNum )
		METHOD getErrorKartotek
		METHOD setErrorKartotek( nNum )
		METHOD getPolicyOMS
		METHOD setPolicyOMS( param )
		METHOD getDisability
		METHOD setDisability( param )
		
ENDCLASS

METHOD procedure setID( param )	CLASS TPatient

	if isnumber( param ) .and. param != 0
		::FID := param
		if ! isnil( ::FExtendInfo )
			// оповестим класс TExtendInfo
			if __objHasMsgAssigned( ::FExtendInfo, 'setID' )
				__objSendMsg( ::FExtendInfo, 'setID', param )
			endif
		endif
		if ! isnil( ::FAddInfo )
			// оповестим класс TAddInfo
			if __objHasMsgAssigned( ::FAddInfo, 'setID' )
				__objSendMsg( ::FAddInfo, 'setID', param )
			endif
		endif
	endif
	return

METHOD function getAddInfo()	CLASS TPatient
	
	if isnil( ::FAddInfo )
		if ::IsNew
			::FAddInfo := TPatientAdd():New()
		else
			::FAddInfo := TPatientAddDB():GetByID( ::ID )			// получим объект дополнительной информации о пациенте
		endif
	endif
	return ::FAddInfo

METHOD procedure setAddInfo( param )	CLASS TPatient

	if isobject( param ) .and. param:classname == upper( 'TPatientAdd' )
		::FAddInfo := param
	endif
	return

METHOD function getExtendInfo()	CLASS TPatient
	
	if isnil( ::FExtendInfo )
		if ::IsNew
			::FExtendInfo := TPatientExt():New()
		else
			::FExtendInfo := TPatientExtDB():GetByID( ::ID )			// получим объект дополнительной информации о пациенте
		endif
	endif
	return ::FExtendInfo

METHOD procedure setExtendInfo( param )	CLASS TPatient

	if isobject( param ) .and. param:classname == upper( 'TPatientExt' )
		::FExtendInfo := param
	endif
	return

METHOD function getCode()	CLASS TPatient
	return ::FCode
	
METHOD procedure setCode( param )	CLASS TPatient

	if isnumber( param )
		::FCode := param
	endif
	return
	
METHOD function getMO_added()	CLASS TPatient
	return ::FMOadded
	
METHOD procedure setMO_added( param )	CLASS TPatient
	::FMOadded := param
	return
	
METHOD function getDate_added()	CLASS TPatient
	return ::FDateAdded
	
METHOD procedure setDate_added( param )	CLASS TPatient
	::FDateAdded := param
	return
	
METHOD function getSNILSuchastDoctor()	CLASS TPatient
	return ::FSNILSuchastDoctor
	
METHOD procedure setSNILSuchastDoctor( param )		CLASS TPatient
	::FSNILSuchastDoctor := param
	return

METHOD function getPC( index )				CLASS TPatient
	local ret
	
	switch index
		case 1
			ret := ::FPC1
			exit
		case 2
			ret := ::FPC2
			exit
		case 3
			ret := ::FPC3
			exit
	endswitch
	return ret

METHOD procedure setPC( index, param )		CLASS TPatient

	switch index
		case 1
			::FPC1 := param
			exit
		case 2
			::FPC2 := param
			exit
		case 3
			::FPC3 := param
			exit
	endswitch
	return

METHOD function getPN( index )				CLASS TPatient
	local ret
	
	switch index
		case 1
			ret := ::FPN1
			exit
		case 2
			ret := ::FPN2
			exit
		case 3
			ret := ::FPN3
			exit
	endswitch
	return ret

METHOD procedure setPN( index, param )		CLASS TPatient

	switch index
		case 1
			::FPN1 := param
			exit
		case 2
			::FPN2 := param
			exit
		case 3
			::FPN3 := param
			exit
	endswitch
	return

METHOD function forJSON()    CLASS TPatient
	local oRow := nil, obj := nil
	local hItems, hItem, h

	h := { => }
	hItems := { => }
	hItem := { => }
	hb_HSet( hItem, 'FIO', alltrim( ::FIO ) )
	hb_HSet( hItem, 'Gender', alltrim( ::Gender ) )
	hb_HSet( hItem, 'DOB', dtoc( ::DOB ) )
	hb_HSet( hItem, 'SNILS', alltrim( transform( ::SNILS, picture_pf ) ) )
	&& if ::Passport != nil
		&& hb_HSet( hItem, 'Passport', ::Passport:forJSON() )
	&& endif
	&& if ::AddressRegistration != nil
		&& hb_HSet( hItem, 'AddressRegistration', ::AddressRegistration:forJSON() )
	&& endif
	&& if ::AddressStay != nil
		&& hb_HSet( hItem, 'AddressStay', ::AddressStay:forJSON() )
	&& endif
	return hItem

METHOD FUNCTION getFIO1251()		CLASS TPatient
	return win_OEMToANSI( ::getFIO )

METHOD FUNCTION getFIO()		CLASS TPatient
	&& local ret := '', k := 0
	&& local cFIO := ::FFIO, i, s := '', s1 := '', ret_arr := { '', '', '' }

	&& cFIO := alltrim( cFIO )
	&& if ::getAnonymous
		&& ret := upper( cFIO )
	&& else
		&& for i := 1 to numtoken(	cFIO,	' '	)
			&& s1 := alltrim( token( cFIO, ' ', i ) )
			&& if !empty( s1 )
				&& ++k
				&& if k < 3
					&& ret_arr[ k ] := s1
				&& else
					&& s += s1 + ' '
				&& endif
			&& endif
		&& next
		&& ret_arr[ 3 ] := upper( left( s, 1 ) )  + lower( alltrim( substr( s, 2 ) ) )
		&& ret := upper( left( ret_arr[ 1 ], 1 ) )  + lower( alltrim( substr( ret_arr[ 1 ], 2 ) ) ) + ;
			&& ' ' + upper( left( ret_arr[ 2 ], 1 ) )  + lower( alltrim( substr( ret_arr[ 2 ], 2 ) ) ) + ' ' + ;
			&& if( empty( ret_arr[ 3 ] ), '', upper( left( ret_arr[ 3 ], 1 ) )  + lower( alltrim( substr( ret_arr[ 3 ], 2 ) ) ) )
	&& endif
	&& ret := padr( ret, 50 )
	&& return ret
	return padr( upper( ::FFIO ), 50 )

METHOD FUNCTION getLastName()		CLASS TPatient
	return padr( ::FLastName, 40 )

METHOD FUNCTION getFirstName()		CLASS TPatient
	return padr( ::FFirstName, 40 )

METHOD FUNCTION getMiddleName()	CLASS TPatient
	return padr( ::FMiddleName, 40 )

METHOD PROCEDURE setLastName( cFIO )		CLASS TPatient
	

	cFIO := alltrim( cFIO )
	if cFIO != alltrim( ::FLastName )
		::FLastName := upper( cFIO )
		::FFIO := ::FLastName + ' ' + ::FFirstName + ' ' + ::FMiddleName
	endif
	return

METHOD PROCEDURE setFirstName( cFIO )		CLASS TPatient

	cFIO := alltrim( cFIO )
	if cFIO != alltrim( ::FFirstName )
		::FFirstName := upper( cFIO )
		::FFIO := ::FLastName + ' ' + ::FFirstName + ' ' + ::FMiddleName
	endif
	return

METHOD PROCEDURE setMiddleName( cFIO )		CLASS TPatient

	cFIO := cFIO
	if alltrim( cFIO ) != alltrim( ::FMiddleName )
		::FMiddleName := upper( cFIO )
		::FFIO := ::FLastName + ' ' + ::FFirstName + ' ' + ::FMiddleName
	endif
	return

METHOD FUNCTION getAnonymous()		CLASS TPatient

	return if( ::FMest_Inog == 8, .t., .f.)
	
METHOD FUNCTION getIsDubleName()		CLASS TPatient

	return if( ::FMest_Inog == 9, .t., .f.)
	
METHOD PROCEDURE setFIO( cFIO )		CLASS TPatient
	local i, s := '', s1 := ''
	local k := 0

	cFIO := upper( alltrim( cFIO ) )
	if cFIO != alltrim( ::FFIO )
		::FFIO := cFIO	//upper( cFIO )
		for i := 1 to numtoken(	cFIO,	' '	)
			s1 := alltrim( token( cFIO, ' ', i ) )
			if ! empty( s1 )
				++k
				if k < 4
					if k == 1
						::FLastName := s1
					elseif k == 2
						::FFirstName := s1
					elseif k == 3
						::FMiddleName := s1
					endif
				endif
			endif
		next
	endif
	return

METHOD FUNCTION getGender()		CLASS TPatient
	return ::FGender

METHOD PROCEDURE setGender( cGender )		CLASS TPatient
	local ch := upper( left( cGender, 1 ) )
	
	if ch != ::FGender
		::FGender := cGender
	endif
	return

METHOD FUNCTION getDOB()		CLASS TPatient
	return ::FDOB

METHOD PROCEDURE setDOB( dDate )		CLASS TPatient
	local cy

	if dDate != ::FDOB
		::FDOB := dDate
		cy := count_years( dDate, sys_date )
		if cy < 14
			::FVzros_Reb := 1	// ребенок
			::FWorking := 1		// неработающий
		elseif cy < 18
			::FVzros_Reb := 2	// подросток
		else
			::FVzros_Reb := 0	// взрослый
		endif
	endif
	return

METHOD function getPlaceBorn()		CLASS TPatient

	if ::FExtendInfo == nil
		::FExtendInfo := TPatientExtDB():getByID( ::ID )
	endif
	return ::FExtendInfo:PlaceBorn

METHOD procedure setPlaceBorn( param )		CLASS TPatient

	if ischaracter( param )
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		::FExtendInfo:PlaceBorn := param
	endif
	return

METHOD FUNCTION getIsAdult( dDate )		CLASS TPatient
	return ( count_years( ::FDOB, hb_defaultValue( dDate, date() ) ) >= 18 )

METHOD getPassport()		CLASS TPatient

	if ::FExtendInfo == nil
		::FExtendInfo := TPatientExtDB():getByID( ::ID )
		if isnil( ::FExtendInfo )
			::FExtendInfo := TPatientExt():New()
		endif
	else
	endif
	return ::FExtendInfo:Passport

METHOD procedure setPassport( param )		CLASS TPatient

	if isobject( param ) .and. param:classname == upper( 'TPassport' )
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		::FExtendInfo:DocumentType := param:DocumentType
		::FExtendInfo:DocumentSeries := param:DocumentSeries
		::FExtendInfo:DocumentNumber := param:DocumentNumber
		::FExtendInfo:IDIssue := param:IDIssue
		::FExtendInfo:DateIssue := param:DateIssue
	endif
	return

METHOD getDisability()		CLASS TPatient
	local obj

	if isnil( ::FDisability )
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		obj := TDisabilityDB():getByPatient( ::ID )
		if isnil( obj )
			obj := TDisability():New()
			obj:IDPatient := ::ID
		endif
		::FDisability := obj
	endif
	::FDisability:setPatient( self )
	::FDisability:Invalid := ::ExtendInfo:Invalid
	::FDisability:DegreeOfDisability := ::ExtendInfo:DegreeOfDisability
	return ::FDisability

METHOD procedure setDisability( param )		CLASS TPatient

	if isobject( param ) .and. param:classname == upper( 'TDisability' )
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		::FExtendInfo:Invalid := param:Invalid
		::FExtendInfo:DegreeOfDisability := param:DegreeOfDisability
		if isnil( ::FDisability )
			::FDisability := TDisability():New()
		endif
		::FDisability:Invalid := param:Invalid
		::FDisability:DegreeOfDisability := param:DegreeOfDisability
	endif
	return

METHOD getAddressReg()		CLASS TPatient

	if ::FExtendInfo == nil
		::FExtendInfo := TPatientExtDB():getByID( ::ID )
	endif
	return TAddressOKATO():New( ::FExtendInfo:OKATOG, ::FAddress )

METHOD getAddress()		CLASS TPatient

	return ::FAddress

METHOD procedure setAddressReg( param )		CLASS TPatient

	if isobject( param ) .and. ( param:classname == upper( 'TAddressOKATO' ) )
		::FAddress := param:Address
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		::FExtendInfo:OKATOG := param:OKATO
	elseif ischaracter( param )
		::FAddress := param
	endif
	return

METHOD function getPolicyOMS()						CLASS TPatient
	local oPolicy

	if ::FExtendInfo == nil
		::FExtendInfo := TPatientExtDB():getByID( ::ID )
	endif
	oPolicy := TPolicyOMS():New( ::FExtendInfo:PolicyType, ::FExtendInfo:PolicySeries, ::FExtendInfo:PolicyNumber, ;
				::FExtendInfo:SMO, ::FExtendInfo:BeginPolicy, ::FPolicyPeriod )
	oPolicy:OKATOInogSMO := ::FExtendInfo:KvartalHouse
	oPolicy:Owner := self
	return oPolicy

METHOD procedure setPolicyOMS( param )				CLASS TPatient

	if isobject( param) .and. param:classname == upper( 'TPolicyOMS' )
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		::FPolicy := alltrim( param:PolicySeries ) + ;
				if( ! empty( param:PolicyNumber ), ' ' + alltrim( param:PolicyNumber ), '' )
		::FExtendInfo:PolicyType := param:PolicyType
		::FExtendInfo:PolicySeries := param:PolicySeries
		::FExtendInfo:PolicyNumber := param:PolicyNumber
		::FExtendInfo:SMO := param:SMO
		::FExtendInfo:BeginPolicy := param:BeginPolicy
		::FPolicyPeriod := param:PolicyPeriod
		::FExtendInfo:KvartalHouse := param:OKATOInogSMO
	endif
	return

METHOD getAddressStay()		CLASS TPatient

	if ::FExtendInfo == nil
		::FExtendInfo := TPatientExtDB():getByID( ::ID )
	endif
	return TAddressOKATO():New( ::FExtendInfo:OKATOP, ::FExtendInfo:AddressStay )

METHOD procedure setAddressStay( param )		CLASS TPatient

	if isobject( param ) .and. ( param:classname == upper( 'TAddressOKATO' ) )
		if ::FExtendInfo == nil
			::FExtendInfo := TPatientExtDB():getByID( ::ID )
		endif
		::FExtendInfo:OKATOP := param:OKATO
		::FExtendInfo:AddressStay := param:Address
	endif
	return

METHOD FUNCTION getDistrict()		CLASS TPatient
	return ::FDistrict
	
METHOD PROCEDURE setDistrict( nNum )		CLASS TPatient

	if nNum != ::FDistrict
		::FDistrict := nNum
	endif
	return

METHOD FUNCTION getBukva()		CLASS TPatient
	return ::FBukva
	
METHOD PROCEDURE setBukva( ch )		CLASS TPatient

	if ch != ::FBukva
		::FBukva := ch
	endif
	return

METHOD FUNCTION getKod_VU()		CLASS TPatient
	return ::FKod_VU
	
METHOD PROCEDURE setKod_VU( nNum )		CLASS TPatient

	if nNum != ::FKod_VU
		::FKod_VU := nNum
	endif
	return

METHOD FUNCTION getVzros_Reb()		CLASS TPatient
	return ::FVzros_Reb
	
METHOD PROCEDURE setVzros_Reb( nNum )		CLASS TPatient

	if nNum != ::FVzros_Reb
		::FVzros_Reb := nNum
	endif
	return

METHOD FUNCTION getPlaceWork()		CLASS TPatient
	return ::FPlaceWork

METHOD PROCEDURE setPlaceWork( cText )		CLASS TPatient

	if alltrim( cText ) != alltrim( ::FPlaceWork )
		::FPlaceWork := cText
	endif
	return

METHOD FUNCTION getWorking()		CLASS TPatient
	return ::FWorking
	
METHOD PROCEDURE setWorking( nNum )		CLASS TPatient

	if nNum != ::FWorking
		::FWorking := nNum
	endif
	return

METHOD FUNCTION getKomu()		CLASS TPatient
	return ::FKomu
	
METHOD PROCEDURE setKomu( nNum )		CLASS TPatient

	if nNum != ::FKomu
		::FKomu := nNum
	endif
	return

METHOD FUNCTION getPolicy()		CLASS TPatient
	return ::FPolicy

METHOD PROCEDURE setPolicy( cText )		CLASS TPatient

	if alltrim( cText ) != alltrim( ::FPolicy )
		::FPolicy := cText
	endif
	return

METHOD FUNCTION getPolicyPeriod()		CLASS TPatient
	return ::FPolicyPeriod

METHOD PROCEDURE setPolicyPeriod( param )		CLASS TPatient
	
	if isdate( param )
		::FPolicyPeriod := param
	endif
	return

METHOD FUNCTION getInsuranceID()		CLASS TPatient
	return ::FInsuranceID
	
METHOD PROCEDURE setInsuranceID( nNum )		CLASS TPatient

	if nNum != ::FInsuranceID
		::FInsuranceID := nNum
	endif
	return

METHOD PROCEDURE getAttachmentStatus()		CLASS TPatient
	return ::FAttachmentStatus
	
METHOD FUNCTION setAttachmentStatus( nNum )		CLASS TPatient

	if nNum != ::FAttachmentStatus
		::FAttachmentStatus := nNum
	endif
	return

METHOD PROCEDURE getTFOMSEncoding()		CLASS TPatient
	return ::FTFOMSEncoding
	
METHOD FUNCTION setTFOMSEncoding( nNum )		CLASS TPatient

	if nNum != ::FTFOMSEncoding
		::FTFOMSEncoding := nNum
	endif
	return

METHOD FUNCTION getSinglePolicyNumber()		CLASS TPatient
	return ::FSinglePolicyNumber

METHOD PROCEDURE setSinglePolicyNumber( cText )		CLASS TPatient

	if alltrim( cText ) != alltrim( ::FSinglePolicyNumber )
		::FSinglePolicyNumber := cText
	endif
	return

METHOD FUNCTION getIsDied()		CLASS TPatient
	return ::FIsDied
	
METHOD PROCEDURE setIsDied( logic )		CLASS TPatient

	if logic != ::IsDied
		::FIsDied := logic
	endif
	return

METHOD FUNCTION getSNILS()		CLASS TPatient
	return ::FSNILS

METHOD PROCEDURE setSNILS( cText )		CLASS TPatient

	if alltrim( cText ) != alltrim( ::FSNILS )
		::FSNILS := cText
	endif
	return

METHOD FUNCTION getOutpatientCardNumber()		CLASS TPatient
	return ::FOutpatientCardNumber
	
METHOD PROCEDURE setOutpatientCardNumber( cText )		CLASS TPatient

	if alltrim( cText ) != alltrim( ::FOutpatientCardNumber )
		::FOutpatientCardNumber := cText
	endif
	return

METHOD FUNCTION getAreaCodeResidence()		CLASS TPatient
	return ::FAreaCodeResidence
	
METHOD PROCEDURE setAreaCodeResidence( nNum )		CLASS TPatient

	if nNum != ::FAreaCodeResidence
		::FAreaCodeResidence := nNum
	endif
	return

METHOD FUNCTION getFinanceAreaCode()		CLASS TPatient
	return ::FFinanceAreaCode
	
METHOD PROCEDURE setFinanceAreaCode( nNum )		CLASS TPatient

	if nNum != ::FFinanceAreaCode
		::FFinanceAreaCode := nNum
	endif
	return

METHOD FUNCTION getMest_Inog()		CLASS TPatient
	return ::FMest_Inog
	
METHOD PROCEDURE setMest_Inog( nNum )		CLASS TPatient

	if nNum != ::FMest_Inog
		::FMest_Inog := nNum
	endif
	return

METHOD FUNCTION getMi_Git()		CLASS TPatient
	return ::FMi_Git
	
METHOD PROCEDURE setMi_Git( nNum )		CLASS TPatient

	if nNum != ::FMi_Git
		::FMi_Git := nNum
	endif
	return

METHOD FUNCTION getErrorKartotek()		CLASS TPatient
	return ::FErrorKartotek
	
METHOD PROCEDURE setErrorKartotek( nNum )		CLASS TPatient

	if isnumber( nNum )
		::FErrorKartotek := nNum
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TPatient

	::super:new( nID, lNew, lDeleted )

	if ::IsNew
		::FAddInfo := TPatientAdd():New()
		::FExtendInfo := TPatientExt():New()
	endif
	return self

METHOD getShortFIO()   CLASS TPatient
	local ret := ''
	&& local cStr, ret := '', k := 0
	&& local cFIO := ::FFIO, i, s := '', s1 := '', ret_arr := { '', '', '' }

	&& cFIO := alltrim( cFIO )
	&& for i := 1 to numtoken(	cFIO,	' '	)
		&& s1 := alltrim( token( cFIO, ' ', i ) )
		&& if !empty( s1 )
			&& ++k
			&& if k < 3
				&& ret_arr[ k ] := s1
			&& else
				&& s += s1 + ' '
			&& endif
		&& endif
	&& next
	&& ret_arr[ 3 ] := alltrim( s )
	&& ret := ret_arr[ 1 ] + ' ' + left( ret_arr[ 2 ], 1 ) + '.' + ;
				&& if( empty( ret_arr[ 3 ] ), '', left( ret_arr[ 3 ], 1 ) + '.' )
	ret := ::FLastName + ' ' + left( ::FFirstName, 1 ) + '.' + ;
				if( empty( ::FMiddleName ), '', left( ::FMiddleName, 1 ) + '.' )
	return ret