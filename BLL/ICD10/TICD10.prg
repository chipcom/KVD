#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'

// файл '_mo_mkb.dbf' - МКБ-10
CREATE CLASS TICD10	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY SHIFR READ getShifr				// код (шифр) диагноза
		PROPERTY Shifr1251 READ getShifr1251		// код (шифр) диагноза в кодировке 1251
		PROPERTY Name READ getName				// название диагноза
		PROPERTY Name1251 READ getName1251		// название диагноза в кодировке 1251
		PROPERTY DBegin READ getDBegin			// дата начала использования
		PROPERTY DEnd READ getDEnd				// дата окончания использования
		PROPERTY Gender READ getGender			// пол для которого возможен диагноз
		PROPERTY Gender1251 READ getGender1251	// пол для которого возможен диагноз в кодировке 1251
		
		PROPERTY Shifr_Gen READ getShifrGender

		METHOD New( nID, cShifr, cName, dBegin, dEnd, cGender, ;
					lNew, lDeleted )
	HIDDEN:
		DATA FSHIFR		INIT space( 6 )
		DATA FName		INIT ''
		DATA FDBegin	INIT ctod( '' )
		DATA FDEnd		INIT ctod( '' )
		DATA FGender	INIT ' '
		
		METHOD getShifr
		METHOD getShifr1251
		METHOD getName
		METHOD getName1251
		METHOD getDBegin
		METHOD getDEnd
		METHOD getGender
		METHOD getGender1251
		METHOD getShifrGender
ENDCLASS

METHOD FUNCTION getShifrGender	CLASS TICD10
	return padr( ::FShifr + ::FGender, 7 )

METHOD FUNCTION getShifr()	CLASS TICD10
	return ::FSHIFR

METHOD FUNCTION getShifr1251()	CLASS TICD10
	return win_OEMToANSI( ::FSHIFR )

METHOD FUNCTION getName()	CLASS TICD10
	return ::FName

METHOD FUNCTION getName1251()	CLASS TICD10
	return win_OEMToANSI( ::FName )

METHOD FUNCTION getGender()	CLASS TICD10
	return ::FGender

METHOD FUNCTION getGender1251()	CLASS TICD10
	return win_OEMToANSI( ::FGender )

METHOD FUNCTION getDBegin()	CLASS TICD10
	return ::FDBegin

METHOD FUNCTION getDEnd()	CLASS TICD10
	return ::FDEnd

***********************************
* Создать новый объект TICD10
METHOD New( nID, cShifr, cName, dBegin, dEnd, cGender, lNew, lDeleted ) CLASS TICD10
	
	::FNew 				:= hb_defaultValue( lNew, .t. )
	::FDeleted			:= hb_defaultValue( lDeleted, .f. )
	::FID				:= hb_defaultValue( nID, 0 )
	
	::FSHIFR			:= hb_defaultValue( cShifr, space( 6 ) )
	::FName				:= hb_defaultValue( cName, '' )
	::FDBegin			:= hb_defaultValue( dBegin, ctod( '' ) )
	::FDEnd				:= hb_defaultValue( dEnd, ctod( '' ) )
	::FGender			:= hb_defaultValue( cGender, ' ' )
	return self