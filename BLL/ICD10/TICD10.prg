#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'function.ch'

// 䠩� '_mo_mkb.dbf' - ���-10
CREATE CLASS TICD10	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY SHIFR READ getShifr				// ��� (���) ��������
		PROPERTY Shifr1251 READ getShifr1251		// ��� (���) �������� � ����஢�� 1251
		PROPERTY Name READ getName				// �������� ��������
		PROPERTY Name1251 READ getName1251		// �������� �������� � ����஢�� 1251
		PROPERTY DBegin READ getDBegin			// ��� ��砫� �ᯮ�짮�����
		PROPERTY DEnd READ getDEnd				// ��� ����砭�� �ᯮ�짮�����
		PROPERTY Gender READ getGender			// ��� ��� ���ண� �������� �������
		PROPERTY Gender1251 READ getGender1251	// ��� ��� ���ண� �������� ������� � ����஢�� 1251
		
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
* ������� ���� ��ꥪ� TICD10
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