#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'

// ����� ����뢠�騩 ���ଠ�� �᪮��஢����� � ����-���� ����� ��� ������� ��ࠧ�
CREATE CLASS TBARCODE_OMS
	VISIBLE:
		PROPERTY BarcodeType AS NUMERIC READ getBarcodeType		// ��� �������� ����-����
		PROPERTY PolicyNumber AS STRING READ getPolicyNumber	// ����� �����
		PROPERTY FirstName AS STRING READ getFirstName		// ���
		PROPERTY MiddleName AS STRING READ getMiddleName		// ����⢮
		PROPERTY LastName AS STRING READ getLastName			// �������
		PROPERTY Gender AS CHARACTER READ getGender			// ���
		PROPERTY DOB AS DATE READ getDOB						// ��� ஦�����
		PROPERTY ExpireDate AS DATE READ getExpireDate		// �ப ����⢨� �����. �᫨ ���祭�� ࠢ�� 1900-01-01, � �ப ����⢨� ����� �� ��⠭�����
		&& PROPERTY OKATO AS STRING READ getOKATO				// ����� ���客�� ��������
		&& PROPERTY OGRN AS STRING READ getOGRN					// ���� ���客�� ��������
		&& PROPERTY EDS AS STRING READ getEDS					// ���஭��� �������
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
		DATA FGender		INIT '�'
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
	::FGender := '�'
	
	::FDOB := ctod( '' )
	::FExpireDate := ctod( '' )
	&& ::FOGRN := alltrim( cNote )
	&& ::FOKATO := alltrim( cNote )
	&& ::FEDS := alltrim( cNote )
	return nil
