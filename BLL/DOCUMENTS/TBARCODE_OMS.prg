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
		
		METHOD New( logic )
	HIDDEN:
		DATA FBarcodeType	INIT 1
		DATA FPolicyNumber	INIT space( 16 )
		DATA FFirstName		INIT space( 50 )
		DATA FMiddleName	INIT space( 50 )
		DATA FLastName		INIT space( 50 )
		DATA FGender		INIT 'М'
		DATA FDOB			INIT ctod( '' )
		DATA FExpireDate	INIT ctod( '' )
		
		METHOD getBarcodeType	INLINE ::FBarcodeType
		METHOD getPolicyNumber	INLINE ::FPolicyNumber
		METHOD getFirstName		INLINE ::FFirstName
		METHOD getMiddleName		INLINE ::FMiddleName
		METHOD getLastName		INLINE ::FLastNameName
		METHOD getGender			INLINE ::FGender
		METHOD getDOB			INLINE ::FDOB
		METHOD getExpireDate		INLINE ::FExpireDate
ENDCLASS

METHOD New( logic ) CLASS TBARCODE_OMS
	if ! logic
		return nil
	endif
	return self
