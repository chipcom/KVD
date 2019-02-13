#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'

// класс описывающий информацию раскодированную со штрих-кода полис ОМС единого образца
CREATE CLASS TBARCODE_OMS
	VISIBLE:
		PROPERTY BarcodeType AS NUMERIC READ getBarcodeType		// Тип структуры штрих-кода
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber	// номер полиса
		PROPERTY FirstName AS STRING READ getFirstName		// Имя
		PROPERTY MiddleName AS STRING READ getMiddleName		// Отчество
		PROPERTY LastName AS STRING READ getLastName			// Фамилия
		PROPERTY Gender AS CHARACTER READ getGender			// Пол
		PROPERTY DOB AS DATE READ getDOB						// Дата рождения
		PROPERTY ExpireDate AS DATE READ getExpireDate		// Срок действия полиса. Если значение равно 1900-01-01, то срок действия полиса не установлен
		&& PROPERTY OKATO AS STRING READ getOKATO				// ОКАТО страховой компании
		&& PROPERTY OGRN AS STRING READ getOGRN					// ОГРН страховой компании
		&& PROPERTY EDS AS STRING READ getEDS					// электронная подпись
		PROPERTY IsEmpty READ getIsEmpty
		PROPERTY FIO READ getFIO
		
		METHOD New()
		METHOD Fill( aData )
		METHOD Clear()
	HIDDEN:
		DATA FBarcodeType	INIT 1
		DATA FPolicyNumber	INIT ''
		DATA FFirstName		INIT ''
		DATA FMiddleName	INIT ''
		DATA FLastName		INIT ''
		DATA FGender		INIT 'М'
		DATA FDOB			INIT ctod( '' )
		DATA FExpireDate	INIT ctod( '' )
		&& DATA FOKATO			INIT ''
		&& DATA FOGRN			INIT ''
		&& DATA FEDS			INIT ''
		
		METHOD getBarcodeType	INLINE ::FBarcodeType
		METHOD getPolicyNumber	INLINE ::FPolicyNumber
		METHOD getFirstName		INLINE ::FFirstName
		METHOD getMiddleName		INLINE ::FMiddleName
		METHOD getLastName		INLINE ::FLastName
		METHOD getGender			INLINE ::FGender
		METHOD getDOB			INLINE ::FDOB
		METHOD getExpireDate		INLINE ::FExpireDate
		&& METHOD getOKATO			INLINE ::FOKATO
		&& METHOD getOGRN			INLINE ::FOGRN
		&& METHOD getEDS			INLINE ::FEDS
		METHOD getIsEmpty		INLINE empty( ::FPolicyNumber )
		METHOD getFIO		INLINE ::FLastName + ' ' + ::FFirstName + ' ' + ::FMiddleName
ENDCLASS

METHOD New() CLASS TBARCODE_OMS
	
	return self

METHOD Fill( aData ) CLASS TBARCODE_OMS
	
	::FBarcodeType := aData[ 1 ]
	::FPolicyNumber := aData[ 2 ]
	::FLastName := upper( hb_Translate( aData[ 3 ], 'cp1251', 'cp866' ) )
	::FFirstName := upper( hb_Translate( aData[ 4 ], 'cp1251', 'cp866' ) )
	::FMiddleName := upper( hb_Translate( aData[ 5 ], 'cp1251', 'cp866' ) )
	::FGender := hb_Translate( aData[ 6 ], 'cp1251', 'cp866' )
	
	::FDOB := ctod( aData[ 7 ] )
	::FExpireDate := ctod( aData[ 8 ] )
	&& ::FOGRN := alltrim( cNote )
	&& ::FOKATO := alltrim( cNote )
	&& ::FEDS := alltrim( cNote )
	return nil

METHOD Clear() CLASS TBARCODE_OMS
	
	::FBarcodeType := 1
	::FPolicyNumber := ''
	::FLastName := ''
	::FFirstName := ''
	::FMiddleName := ''
	::FGender := 'М'
	
	::FDOB := ctod( '' )
	::FExpireDate := ctod( '' )
	&& ::FOGRN := alltrim( cNote )
	&& ::FOKATO := alltrim( cNote )
	&& ::FEDS := alltrim( cNote )
	return nil
