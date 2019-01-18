#include 'property.ch'
#include "hbclass.ch"

//
// Class TCloseCheck
//
CLASS TCloseCheck
	EXPORTED:
		PROPERTY Summ1 INDEX 1 READ getSumm WRITE setSumm						// Сумма типа оплаты 1
		PROPERTY Summ2 INDEX 2 READ getSumm WRITE setSumm						// Сумма типа оплаты 2
		PROPERTY Summ3 INDEX 3 READ getSumm WRITE setSumm						// Сумма типа оплаты 3
		PROPERTY Summ4 INDEX 4 READ getSumm WRITE setSumm						// Сумма типа оплаты 4
		PROPERTY Summ5 INDEX 5 READ getSumm WRITE setSumm						// Сумма типа оплаты 5
		PROPERTY Summ6 INDEX 6 READ getSumm WRITE setSumm						// Сумма типа оплаты 6
		PROPERTY Summ7 INDEX 7 READ getSumm WRITE setSumm						// Сумма типа оплаты 7
		PROPERTY Summ8 INDEX 8 READ getSumm WRITE setSumm						// Сумма типа оплаты 8
		PROPERTY Summ9 INDEX 9 READ getSumm WRITE setSumm						// Сумма типа оплаты 9
		PROPERTY Summ10 INDEX 10 READ getSumm WRITE setSumm					// Сумма типа оплаты 10
		PROPERTY Summ11 INDEX 11 READ getSumm WRITE setSumm					// Сумма типа оплаты 11
		PROPERTY Summ12 INDEX 12 READ getSumm WRITE setSumm					// Сумма типа оплаты 12
		PROPERTY Summ13 INDEX 13 READ getSumm WRITE setSumm					// Сумма типа оплаты 13
		PROPERTY Summ14 INDEX 14 READ getSumm WRITE setSumm					// Свойство для указания суммы предварительной оплаты (аванс)
		PROPERTY Summ15 INDEX 15 READ getSumm WRITE setSumm					// Свойство для указания суммы последующей оплаты (кредит)
		PROPERTY Summ16 INDEX 16 READ getSumm WRITE setSumm					// Свойство для указания суммы иной формы оплаты (оплата встречным предоставлением)
		PROPERTY RoundingSumm READ getRoundingSumm WRITE setRoundingSumm		// Округление до рубля в копейках
		PROPERTY TaxValue1 INDEX 1 READ getTaxValue WRITE setTaxValue			// Сумма налога 1
		PROPERTY TaxValue2 INDEX 2 READ getTaxValue WRITE setTaxValue			// Сумма налога 2
		PROPERTY TaxValue3 INDEX 3 READ getTaxValue WRITE setTaxValue			// Сумма налога 3
		PROPERTY TaxValue4 INDEX 4 READ getTaxValue WRITE setTaxValue			// Сумма налога 4
		PROPERTY TaxValue5 INDEX 5 READ getTaxValue WRITE setTaxValue			// Сумма налога 5
		PROPERTY TaxValue6 INDEX 6 READ getTaxValue WRITE setTaxValue			// Сумма налога 6
		PROPERTY TaxType READ getTaxType WRITE setTaxType					// Код применяемой системы налогооблажения
		PROPERTY StringForPrinting READ getStringForPrinting WRITE setStringForPrinting	// Текст
		PROPERTY CustomerEmail READ getCustomerEmail WRITE setCustomerEmail	//
		
		METHOD New()
	HIDDEN:
		DATA FSumm1 INIT 0.0
		DATA FSumm2 INIT 0.0
		DATA FSumm3 INIT 0.0
		DATA FSumm4 INIT 0.0
		DATA FSumm5 INIT 0.0
		DATA FSumm6 INIT 0.0
		DATA FSumm7 INIT 0.0
		DATA FSumm8 INIT 0.0
		DATA FSumm9 INIT 0.0
		DATA FSumm10 INIT 0.0
		DATA FSumm11 INIT 0.0
		DATA FSumm12 INIT 0.0
		DATA FSumm13 INIT 0.0
		DATA FSumm14 INIT 0.0
		DATA FSumm15 INIT 0.0
		DATA FSumm16 INIT 0.0
		DATA FTaxValue1 INIT 0
		DATA FTaxValue2 INIT 0
		DATA FTaxValue3 INIT 0
		DATA FTaxValue4 INIT 0
		DATA FTaxValue5 INIT 0
		DATA FTaxValue6 INIT 0
		DATA FRoundingSumm INIT 0
		DATA FTaxType INIT 0
		DATA FStringForPrinting INIT ''
		DATA FCustomerEmail INIT ''

		METHOD getSumm( index )
		METHOD setSumm( index, param )
		METHOD getTaxValue( index )
		METHOD setTaxValue( index, param )
		METHOD getTaxType
		METHOD setTaxType( param )
		METHOD getRoundingSumm
		METHOD setRoundingSumm( param )
		METHOD getStringForPrinting
		METHOD setStringForPrinting( param )
		METHOD getCustomerEmail
		METHOD setCustomerEmail( param )
		
ENDCLASS

METHOD New()									CLASS TCloseCheck
	return self

METHOD function getRoundingSumm()				CLASS TCloseCheck
	return ::FRoundingSumm

METHOD procedure setRoundingSumm( param )			CLASS TCloseCheck

	::FRoundingSumm := param
	return

METHOD function getTaxType()					CLASS TCloseCheck
	return ::FTaxType

METHOD procedure setTaxType( param )			CLASS TCloseCheck

	::FTaxType := param
	return

METHOD function getTaxValue( index )			CLASS TCloseCheck
	local ret
	
	switch index
		case 1
			ret := ::FTaxValue1
			exit
		case 2
			ret := ::FTaxValue2
			exit
		case 3
			ret := ::FTaxValue3
			exit
		case 4
			ret := ::FTaxValue4
			exit
		case 5
			ret := ::FTaxValue5
			exit
		case 6
			ret := ::FTaxValue6
			exit
	endswitch
	return ret

METHOD procedure setTaxValue( index, param )		CLASS TCloseCheck

	switch index
		case 1
			::FTaxValue1 := param
			exit
		case 2
			::FTaxValue2 := param
			exit
		case 3
			::FTaxValue3 := param
			exit
		case 4
			::FTaxValue4 := param
			exit
		case 5
			::FTaxValue5 := param
			exit
		case 6
			::FTaxValue6 := param
			exit
	endswitch
	return

METHOD function getSumm( index )				CLASS TCloseCheck
	local ret
	
	switch index
		case 1
			ret := ::FSumm1
			exit
		case 2
			ret := ::FSumm2
			exit
		case 3
			ret := ::FSumm3
			exit
		case 4
			ret := ::FSumm4
			exit
		case 5
			ret := ::FSumm5
			exit
		case 6
			ret := ::FSumm6
			exit
		case 7
			ret := ::FSumm7
			exit
		case 8
			ret := ::FSumm8
			exit
		case 9
			ret := ::FSumm9
			exit
		case 10
			ret := ::FSumm10
			exit
		case 11
			ret := ::FSumm11
			exit
		case 12
			ret := ::FSumm12
			exit
		case 13
			ret := ::FSumm13
			exit
		case 14
			ret := ::FSumm14
			exit
		case 15
			ret := ::FSumm15
			exit
		case 16
			ret := ::FSumm16
			exit
	endswitch
	return ret

METHOD procedure setSumm( index, param )		CLASS TCloseCheck

	switch index
		case 1
			::FSumm1 := param
			exit
		case 2
			::FSumm2 := param
			exit
		case 3
			::FSumm3 := param
			exit
		case 4
			::FSumm4 := param
			exit
		case 5
			::FSumm5 := param
			exit
		case 6
			::FSumm6 := param
			exit
		case 7
			::FSumm7 := param
			exit
		case 8
			::FSumm8 := param
			exit
		case 9
			::FSumm9 := param
			exit
		case 10
			::FSumm10 := param
			exit
		case 11
			::FSumm11 := param
			exit
		case 12
			::FSumm12 := param
			exit
		case 13
			::FSumm13 := param
			exit
		case 14
			::FSumm14 := param
			exit
		case 15
			::FSumm15 := param
			exit
		case 16
			::FSumm16 := param
			exit
	endswitch
	return

METHOD function getStringForPrinting()			CLASS TCloseCheck
	return ::FStringForPrinting

METHOD procedure setStringForPrinting( param )	CLASS TCloseCheck
	::FStringForPrinting := param
	return
	
METHOD function getCustomerEmail()				CLASS TCloseCheck
	return ::FCustomerEmail

METHOD procedure setCustomerEmail( param )	CLASS TCloseCheck
	::FCustomerEmail := param
	return
