#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'
#include 'hbxml.ch'
#include 'set.ch'
#include 'windows.ch'

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
		PROPERTY OKATO AS STRING READ getOKATO				// ОКАТО страховой компании
		PROPERTY OGRN AS STRING READ getOGRN					// ОГРН страховой компании
		PROPERTY EDS AS STRING READ getEDS					// электронная подпись
		
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
		DATA FOKATO			INIT ''
		DATA FOGRN			INIT ''
		DATA FEDS			INIT ''
		
		METHOD getBarcodeType	INLINE ::FBarcodeType
		METHOD getPolicyNumber	INLINE ::FPolicyNumber
		METHOD getFirstName		INLINE ::FFirstName
		METHOD getMiddleName		INLINE ::FMiddleName
		METHOD getLastName		INLINE ::FLastName
		METHOD getGender			INLINE ::FGender
		METHOD getDOB			INLINE ::FDOB
		METHOD getExpireDate		INLINE ::FExpireDate
		METHOD getOKATO			INLINE ::FOKATO
		METHOD getOGRN			INLINE ::FOGRN
		METHOD getEDS			INLINE ::FEDS
ENDCLASS

METHOD New( barcode_data_V1 ) CLASS TBARCODE_OMS
	local myObj
	local cString
	local oDoc, oData, oIterator, oCurrent
	local cNote
	local cSet
	
	if ( myObj := win_oleCreateObject( 'Chip.Shared.Barcode.DecodeBarcodeOMS' ) ) != nil
		
		cString := myObj:getXMLPolicyOMS(barcode_data_V1)
		oDoc := TXMLDocument():New( cString, HBXML_STYLE_NOESCAPE )
		if oDoc:nError != HBXML_ERROR_NONE
			return nil
		endif
		oData := oDoc:findfirst( 'BarcodeData' )
		if oData == nil
			return nil
		endif
		
		do while .t.
			cNote := ''
			oIterator := TXMLIterator():New( oData )
			do while .t.
				oCurrent := oIterator:Next()
				if oCurrent != nil
					cNote := oCurrent:cData
					if lower( oCurrent:cName ) == 'barcodetype'
						&& cNote := oCurrent:cData
						::FBarcodeType := val( cNote )
					elseif lower( oCurrent:cName ) == 'policynumber'
						&& cNote := oCurrent:cData
						::FPolicyNumber := alltrim( cNote )
					elseif lower( oCurrent:cName ) == 'firstname'
						&& cNote := oCurrent:cData
						::FFirstName := alltrim( cNote )
					elseif lower( oCurrent:cName ) == 'lastname'
						&& cNote := oCurrent:cData
						::FLastName := alltrim( cNote )
					elseif lower( oCurrent:cName ) == 'patronymic'
						&& cNote := oCurrent:cData
						::FMiddleName := alltrim( cNote )
					elseif lower( oCurrent:cName ) == 'sex'
						&& cNote := oCurrent:cData
						::FGender := if( cNote == '1', 'М', 'Ж' )
					elseif lower( oCurrent:cName ) == 'birthdate'
						&& cNote := oCurrent:cData
						cSet := set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
						::FDOB := ctod( substr( cNote, 1, 10 ) )
						set( _SET_DATEFORMAT, cSet )
					elseif lower( oCurrent:cName ) == 'expiredate'
						&& cNote := oCurrent:cData
						if substr( cNote, 1, 10 ) != '1900-01-01'
							cSet := set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
							::FExpireDate := ctod( substr( cNote, 1, 10 ) )
							set( _SET_DATEFORMAT, cSet )
						endif
					elseif lower( oCurrent:cName ) == 'ogrn'
						&& cNote := oCurrent:cData
						::FOGRN := alltrim( cNote )
					elseif lower( oCurrent:cName ) == 'okato'
						&& cNote := oCurrent:cData
						::FOKATO := alltrim( cNote )
					elseif lower( oCurrent:cName ) == 'eds'
						::FEDS := alltrim( cNote )
					endif
				else
					exit
				endif
			enddo
			if ( oData := oDoc:findnext() ) == nil
				exit
			endif
		enddo
	else
		return nil
	endif
	return self
