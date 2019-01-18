#include 'property.ch'
#include "hbclass.ch"

//
// Class TCorrectionCheck
//
CLASS TCorrectionCheck
	EXPORTED:
		PROPERTY CorrectionType READ getCorrectionType WRITE  setCorrectionType		// Тип коррекции
		PROPERTY CalculationSign READ getCalculationSign WRITE setCalculationSign	// Признак расчёта
		PROPERTY Summ1 INDEX 1 READ getSumm WRITE setSumm								// Сумма по чеку
		PROPERTY Summ2 INDEX 2 READ getSumm WRITE setSumm								// Сумма по чеку наличными
		PROPERTY Summ3 INDEX 3 READ getSumm WRITE setSumm								// Сумма по чеку электронными
		PROPERTY Summ4 INDEX 4 READ getSumm WRITE setSumm								// Сумма по чеку предоплатой
		PROPERTY Summ5 INDEX 5 READ getSumm WRITE setSumm								// Сумма по чеку постоплатой
		PROPERTY Summ6 INDEX 6 READ getSumm WRITE setSumm								// Сумма по чеку встречным представлением
		PROPERTY Summ7 INDEX 7 READ getSumm WRITE setSumm								// Сумма НДС 18%
		PROPERTY Summ8 INDEX 8 READ getSumm WRITE setSumm								// Сумма НДС 10%
		PROPERTY Summ9 INDEX 9 READ getSumm WRITE setSumm								// Сумма расчета по ставке 0%
		PROPERTY Summ10 INDEX 10 READ getSumm WRITE setSumm							// Сумма расчета по чеку без НДС
		PROPERTY Summ11 INDEX 11 READ getSumm WRITE setSumm							// Сумма расчета по чеку 18/118
		PROPERTY Summ12 INDEX 12 READ getSumm WRITE setSumm							// Сумма расчета по расч. ставке 10/110
		PROPERTY TaxType READ getTaxType WRITE setTaxType							// Код применяемой системы налогооблажения
		PROPERTY DocNum READ getDocNum WRITE setDocNum								// Номер документа основания
		PROPERTY DocDate READ getDocDate WRITE setDocDate								// Дата документа основания
		PROPERTY DocDescription READ getDocDescription WRITE setDocDescription		// Наименование документа основания
		
		METHOD New()
	HIDDEN:
		DATA FCorrectionType INIT 0
		DATA FCalculationSign INIT 1
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
		DATA FTaxType INIT 0
		DATA FDocNum INIT space( 5 )
		DATA FDocDate INIT ctod( '' )
		DATA FDocDescription INIT space( 100 )
		
		METHOD getCorrectionType
		METHOD setCorrectionType( param )
		METHOD getCalculationSign
		METHOD setCalculationSign( param )
		METHOD getSumm( index )
		METHOD setSumm( index, param )
		METHOD getTaxType
		METHOD setTaxType( param )
		METHOD getDocNum
		METHOD setDocNum( param )
		METHOD getDocDate
		METHOD setDocDate( param )
		METHOD getDocDescription
		METHOD setDocDescription( param )
		
ENDCLASS

METHOD New()									CLASS TCorrectionCheck
	return self

METHOD function getDocNum()						CLASS TCorrectionCheck
	return ::FDocNum

METHOD procedure setDocNum( param )			CLASS TCorrectionCheck
	param := iif( valtype( param ) != 'C', str( param ), param )
	::FDocNum := substr( param, 1, 5 )
	return

METHOD function getDocDate()					CLASS TCorrectionCheck
	return ::FDocDate

METHOD procedure setDocDate( param )			CLASS TCorrectionCheck
	::FDocDate := param
	return

METHOD function getDocDescription()				CLASS TCorrectionCheck
	return ::FDocDescription
	
METHOD procedure setDocDescription( param )	CLASS TCorrectionCheck
	::FDocDescription := substr( param, 1, 100 )
	return

METHOD function getCorrectionType()			CLASS TCorrectionCheck
	return ::FCorrectionType

METHOD procedure setCorrectionType( param )	CLASS TCorrectionCheck

	::FCorrectionType := param
	return

METHOD function getCalculationSign()			CLASS TCorrectionCheck
	return ::FCalculationSign

METHOD procedure setCalculationSign( param )	CLASS TCorrectionCheck

	::FCalculationSign := param
	return

METHOD function getTaxType()					CLASS TCorrectionCheck
	return ::FTaxType

METHOD procedure setTaxType( param )			CLASS TCorrectionCheck

	::FTaxType := param
	return

METHOD function getSumm( index )				CLASS TCorrectionCheck
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
	endswitch
	return ret

METHOD procedure setSumm( index, param )		CLASS TCorrectionCheck

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
	endswitch
	return

