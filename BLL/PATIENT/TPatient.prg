#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatient	INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY FIO AS STRING READ getFIO WRITE setFIO												// Ф.И.О. больного
		PROPERTY FIO1251 READ getFIO1251
		PROPERTY IsAnonymous AS LOGICAL READ getAnonymous											// анонимный пациент
		PROPERTY Gender AS CHARACTER READ getGender WRITE setGender									// пол
		PROPERTY ShortFIO AS STRING READ getShortFIO()												// получить сокращенное Ф.И.О.
		PROPERTY DOB AS DATE READ getDOB WRITE setDOB													// дата рождения
		PROPERTY IsAdult AS LOGICAL READ getIsAdult( ... )											// получить совершеннолетний или нет
		PROPERTY Passport AS OBJECT READ getPassport													// документ удостоверяющий личность
		PROPERTY AddressRegistration AS OBJECT READ getAddressReg									// адрес регистрации
		PROPERTY AddressStay AS OBJECT READ getAddressStay											// адрес пребывания
		PROPERTY District AS NUMERIC READ getDistrict WRITE setDistrict								// номер участка
		PROPERTY Bukva AS CHARACTER READ getBukva WRITE setBukva										// одна буква
		PROPERTY Kod_VU AS NUMERIC READ getKod_VU WRITE setKod_VU									// код в участке
		PROPERTY Vzros_Reb AS NUMERIC READ getVzros_Reb WRITE setVzros_Reb							// 0-взрослый, 1-ребенок, 2-подросток
		PROPERTY PlaceWork AS STRING READ getPlaceWork WRITE setPlaceWork							// место работы или причина безработности
		PROPERTY Working AS NUMERIC READ getWorking WRITE setWorking									// 0-работающий, 1-неработающий
		PROPERTY Komu AS NUMERIC READ getKomu WRITE setKomu											// от 1 до 5
		PROPERTY Policy AS STRING READ getPolicy WRITE setPolicy										// серия и номер страхового полиса
		PROPERTY PolicyPeriod AS DATE READ getPolicyPeriod WRITE setPolicyPeriod						// срок действия полиса
		PROPERTY InsurenceID AS NUMERIC READ getInsuranceID WRITE setInsuranceID						// код стр.компании, комитета и т.п.
		PROPERTY AttachmentStatus AS NUMERIC READ getAttachmentStatus WRITE setAttachmentStatus		// тип/статус прикрепления 1-из WQ,2-из реестра СП и ТК,3-из файла прикрепления,4-открепление,5-сверка
		PROPERTY TFOMSEncoding AS NUMERIC READ getTFOMSEncoding WRITE setTFOMSEncoding				// код по кодировке ТФОМС
		PROPERTY SinglePolicyNumber AS STRING READ getSinglePolicyNumber WRITE setSinglePolicyNumber	// ЕНП - единый номер полиса ОМС
		PROPERTY IsDied AS LOGICAL READ getIsDied WRITE setIsDied									// 0-нет,1-умер по результатам сверки
		PROPERTY SNILS AS STRING READ getSNILS WRITE setSNILS										// СНИЛС
		PROPERTY OutpatientCardNumber AS STRING READ getOutpatientCardNumber WRITE setOutpatientCardNumber	// собственный номер амбулаторной карты
		PROPERTY AreaCodeResidence AS NUMERIC READ getAreaCodeResidence WRITE setAreaCodeResidence	// код района места жительства
		PROPERTY FinanceAreaCode AS NUMERIC READ getFinanceAreaCode WRITE setFinanceAreaCode			// код района финансирования
		PROPERTY Mest_Inog AS NUMERIC READ getMest_Inog WRITE setMest_Inog							// 0-нет, 8 - аноним,9-отдельные ФИО
		PROPERTY Mi_Git AS NUMERIC READ getMi_Git WRITE setMi_Git									// 0-нет, 9-рабочее поле KOMU
		PROPERTY Za_Smo AS NUMERIC READ getZa_Smo WRITE setZa_Smo									// 0-нет, '-8'-полис недействителен, '-9'-ошибки в реквизитах
		
		PROPERTY MO_added AS STRING READ getMO_added WRITE setMO_added								// код МО прикрепления
		PROPERTY Date_added AS STRING READ getDate_added WRITE setDate_added							// дата прикрепления
		PROPERTY SNILSuchastDoctor AS STRING READ getSNILSuchastDoctor WRITE setSNILSuchastDoctor	// СНИЛС участкового врача
		PROPERTY PC1 AS STRING INDEX 1 READ getPC WRITE setPC
		PROPERTY PC2 AS STRING INDEX 2 READ getPC WRITE setPC
		PROPERTY PC3 AS STRING INDEX 3 READ getPC WRITE setPC
		PROPERTY PN1 AS NUMERIC INDEX 1 READ getPN WRITE setPN
		PROPERTY PN1 AS NUMERIC INDEX 2 READ getPN WRITE setPN
		PROPERTY PN1 AS NUMERIC INDEX 3 READ getPN WRITE setPN

		METHOD New( nID, cFIO, cGender, dBOB, cAddress, nDistrict, cBukva, nKod_vu, lNew, lDeleted )
	
		METHOD AddInfo( param )		INLINE iif( param == nil, ::_oAddInfo, ::_oAddInfo := param )
		METHOD forJSON()
	HIDDEN:

		VAR _oAddInfo			AS OBJECT	INIT nil				// для хранения объекта TPatientAdd ( kartote2.dbf )
		VAR _oAddExt			AS OBJECT	INIT nil				// для хранения объекта TPatientExt ( kartote_.dbf )
		
		DATA FKod INIT 0
		DATA FAddress INIT space( 50 )
		DATA FFIO INIT space( 50 )
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
		DATA FZa_Smo INIT 0

		DATA FMOadded INIT space( 6 )
		DATA FDateAdded INIT ctod( '' )
		DATA FSNILSuchastDoctor INIT space( 6 )
		DATA FPC1	INIT space( 10 )
		DATA FPC2	INIT space( 10 )
		DATA FPC3	INIT space( 10 )

		DATA FPN1	INIT 0
		DATA FPN2	INIT 0
		DATA FPN3	INIT 0

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
		
		METHOD getFIO()
		METHOD setFIO( cFIO )
		METHOD getFIO1251
		METHOD getAnonymous()
		METHOD getShortFIO()
		METHOD getGender()
		METHOD setGender( cGender )
		METHOD getDOB()
		METHOD setDOB( dDate )
		METHOD getIsAdult( dDate )
		METHOD getPassport()
		METHOD getAddressReg()
		METHOD getAddressStay()
		METHOD getDistrict()
		METHOD setDistrict( nNum )
		METHOD getBukva()
		METHOD setBukva( ch )
		METHOD getKod_VU()
		METHOD setKod_VU( nNum )
		METHOD getVzros_Reb()
		METHOD setVzros_Reb( nNum )
		METHOD getPlaceWork()
		METHOD setPlaceWork( cText )
		METHOD getWorking()
		METHOD setWorking( nNum )
		METHOD getKomu()
		METHOD setKomu( nNum )
		METHOD getPolicy()
		METHOD setPolicy( cText )
		METHOD getPolicyPeriod()
		METHOD setPolicyPeriod( dDate )
		METHOD getInsuranceID()
		METHOD setInsuranceID( nNum )
		METHOD getAttachmentStatus()
		METHOD setAttachmentStatus( nNum )
		METHOD getTFOMSEncoding()
		METHOD setTFOMSEncoding( nNum )
		METHOD getSinglePolicyNumber()
		METHOD setSinglePolicyNumber( cText )
		METHOD getIsDied()
		METHOD setIsDied( logic )
		METHOD getSNILS()
		METHOD setSNILS( cText )
		METHOD getOutpatientCardNumber()
		METHOD setOutpatientCardNumber( cText )
		METHOD getAreaCodeResidence()
		METHOD setAreaCodeResidence( nNum )
		METHOD getFinanceAreaCode()
		METHOD setFinanceAreaCode( nNum )
		METHOD getMest_Inog()
		METHOD setMest_Inog( nNum )
		METHOD getMi_Git()
		METHOD setMi_Git( nNum )
		METHOD getZa_Smo()
		METHOD setZa_Smo( nNum )
ENDCLASS

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
	local ret := '', k := 0
	local cFIO := ::FFIO, i, s := '', s1 := '', ret_arr := { '', '', '' }

	cFIO := alltrim( cFIO )
	if ::getAnonymous
		ret := upper( cFIO )
	else
		for i := 1 to numtoken(	cFIO,	' '	)
			s1 := alltrim( token( cFIO, ' ', i ) )
			if !empty( s1 )
				++k
				if k < 3
					ret_arr[ k ] := s1
				else
					s += s1 + ' '
				endif
			endif
		next
		ret_arr[ 3 ] := upper( left( s, 1 ) )  + lower( alltrim( substr( s, 2 ) ) )
		ret := upper( left( ret_arr[ 1 ], 1 ) )  + lower( alltrim( substr( ret_arr[ 1 ], 2 ) ) ) + ;
			' ' + upper( left( ret_arr[ 2 ], 1 ) )  + lower( alltrim( substr( ret_arr[ 2 ], 2 ) ) ) + ' ' + ;
			if( empty( ret_arr[ 3 ] ), '', upper( left( ret_arr[ 3 ], 1 ) )  + lower( alltrim( substr( ret_arr[ 3 ], 2 ) ) ) )
	endif
	return ret

METHOD FUNCTION getAnonymous()		CLASS TPatient

	return if( ::FMest_Inog == 8, .t., .f.)
	
METHOD PROCEDURE setFIO( cFIO )		CLASS TPatient

	if alltrim( cFIO ) != alltrim( ::FFIO )
		::FFIO := upper( cFIO )
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

	if dDate != ::FDOB
		::FDOB := dDate
	endif
	return

METHOD FUNCTION getIsAdult( dDate )		CLASS TPatient
	return ( count_years( ::FDOB, hb_defaultValue( dDate, date() ) ) >= 18 )

METHOD getPassport()		CLASS TPatient

	if ::_oAddExt == nil
		::_oAddExt := TPatientExtDB():getByID( ::ID )
	endif
	return ::_oAddExt:Passport

METHOD getAddressReg()		CLASS TPatient

	if ::_oAddExt == nil
		::_oAddExt := TPatientExtDB():getByID( ::ID )
	endif
	return TAddressOKATO():New( ::_oAddExt:OKATOG, ::FAddress )

METHOD getAddressStay()		CLASS TPatient

	if ::_oAddExt == nil
		::_oAddExt := TPatientExtDB():getByID( ::ID )
	endif
	return TAddressOKATO():New( ::_oAddExt:OKATOP, ::_oAddExt:AddressStay )

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

METHOD PROCEDURE setPolicyPeriod( dDate )		CLASS TPatient
	
	if dDate != ::FPolicyPeriod
		::FPolicyPeriod := dDate
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

METHOD FUNCTION getZa_Smo()		CLASS TPatient
	return ::FZa_Smo
	
METHOD PROCEDURE setZa_Smo( nNum )		CLASS TPatient

	if nNum != ::FZa_Smo
		::FZa_Smo := nNum
	endif
	return

METHOD New( nID, cFIO, cGender, dDOB, cAddress, nDistrict, cBukva, nKod_vu, lNew, lDeleted )		CLASS TPatient

	::super:new( nID, lNew, lDeleted )
	
	::FKod	 			:= hb_defaultValue( nID, 0 )			// nKod
	::FFIO			    := hb_defaultValue( cFIO, space( 50 ) )	// фамилия имя отчество
	::FGender	 		:= hb_defaultValue( cGender, 'М' )		// пол
	::FDOB		 		:= hb_defaultValue( dDOB, ctod( '' ) )	// дата рождения
	::FAddress	 		:= hb_defaultValue( cAddress, space( 50 ) )	// адрес больного
	::FDistrict 		:= hb_defaultValue( nDistrict, 0 )		// участок
	::FBukva			:= hb_defaultValue( cBukva, ' ' )		// буква
	::FKod_VU			:= hb_defaultValue( nKod_vu, 0 )		// код в участке
	::_oAddInfo			:= TPatientAddDB():GetByID( nID )			// получим объект дополнительной информации о пациенте
	return self
	
METHOD getShortFIO( )   CLASS TPatient
	local cStr, ret := '', k := 0
	local cFIO := ::FFIO, i, s := '', s1 := '', ret_arr := { '', '', '' }

	cFIO := alltrim( cFIO )
	for i := 1 to numtoken(	cFIO,	' '	)
		s1 := alltrim( token( cFIO, ' ', i ) )
		if !empty( s1 )
			++k
			if k < 3
				ret_arr[ k ] := s1
			else
				s += s1 + ' '
			endif
		endif
	next
	ret_arr[ 3 ] := alltrim( s )
	ret := ret_arr[ 1 ] + ' ' + left( ret_arr[ 2 ], 1 ) + '.' + ;
				if( empty( ret_arr[ 3 ] ), '', left( ret_arr[ 3 ], 1 ) + '.' )
	return ret