#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник T006 _mo_t006
CREATE CLASS T_T006	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY TypeKSG READ getTypeKSG WRITE setTypeKSG
		PROPERTY R0 READ getR0 WRITE setR0
		PROPERTY R1 READ getR1 WRITE setR1
		PROPERTY C0 READ getC0 WRITE setC0
		PROPERTY C8 READ getC8 WRITE setC8
		PROPERTY C9 READ getC9 WRITE setC9
		PROPERTY Shifr READ getShifr WRITE setShifr
		PROPERTY Name READ getName WRITE setName								// наименование
		PROPERTY Name1251 READ getName1251								// наименование 1251
  
		METHOD New( nId, lNew, lDeleted )
		&& METHOD listForJSON()
		&& METHOD forJSON()
	HIDDEN:                                      
		DATA FTypeKSG		INIT 0
		DATA FR0			INIT 0
		DATA FR1			INIT 0
		DATA FC0			INIT 0
		DATA FC8			INIT 0
		DATA FC9			INIT 0
		DATA FShifr			INIT space( 3 )
		DATA FName			INIT space( 15 )
		
		METHOD getTypeKSG
		METHOD setTypeKSG( param )
		METHOD getR0
		METHOD setR0( param )
		METHOD getR1
		METHOD setR1( param )
		METHOD getC0
		METHOD setC0( param )
		METHOD getC8
		METHOD setC8( param )
		METHOD getC9
		METHOD setC9( param )
		METHOD getShifr
		METHOD setShifr( param )
		METHOD getName
		METHOD setName( param )
		METHOD getName1251
ENDCLASS

METHOD FUNCTION getTypeKSG()				CLASS T_T006
	return ::FTypeKSG

METHOD PROCEDURE setTypeKSG( param )		CLASS T_T006

	::FTypeKSG := param
	return

METHOD FUNCTION getR0()				CLASS T_T006
	return ::FR0

METHOD PROCEDURE setR0( param )		CLASS T_T006

	::FR0 := param
	return

METHOD FUNCTION getR1()				CLASS T_T006
	return ::FR1

METHOD PROCEDURE setR1( param )		CLASS T_T006

	::FR1 := param
	return

METHOD FUNCTION getC0()				CLASS T_T006
	return ::FC0

METHOD PROCEDURE setC0( param )		CLASS T_T006

	::FC0 := param
	return

METHOD FUNCTION getC8()				CLASS T_T006
	return ::FC8

METHOD PROCEDURE setC8( param )		CLASS T_T006

	::FC8 := param
	return

METHOD FUNCTION getC9()				CLASS T_T006
	return ::FC9

METHOD PROCEDURE setC9( param )		CLASS T_T006

	::FC9 := param
	return

METHOD FUNCTION getShifr()					CLASS T_T006
	return ::FShifr

METHOD PROCEDURE setShifr( param )			CLASS T_T006

	::FShifr := param
	return

METHOD FUNCTION getName()					CLASS T_T006
	return ::FName

METHOD PROCEDURE setName( param )			CLASS T_T006

	::FName := param
	return

METHOD FUNCTION getName1251()					CLASS T_T006
	return win_OEMToANSI( ::FName )

METHOD New( nId, lNew, lDeleted )		CLASS T_T006
			
	::super:new( nID, lNew, lDeleted )
	return self