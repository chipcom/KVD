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
		
		METHOD New( logic )
	HIDDEN:
		DATA FBarcodeType	INIT 1
		DATA FPolicyNumber	INIT space( 16 )
		DATA FFirstName		INIT space( 50 )
		DATA FMiddleName	INIT space( 50 )
		DATA FLastName		INIT space( 50 )
		DATA FGender		INIT '�'
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
