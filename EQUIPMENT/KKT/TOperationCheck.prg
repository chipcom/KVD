#include 'property.ch'
#include "hbclass.ch"

//
// Class TOperationCheck
//
CLASS TOperationCheck
	EXPORTED:
		PROPERTY CheckType READ getCheckType WRITE setCheckType						// ⨯ ����樨
		PROPERTY Quantity READ getQuantity WRITE setQuantity							// ������⢮ (�� 6 ������ ��᫥ ����⮩)
		PROPERTY Price READ getPrice WRITE setPrice									// 業�
		PROPERTY Summ1 READ getSumm1 WRITE setSumm1									// �㬬� ����樨
		PROPERTY Summ1Enabled READ getSumm1Enabled WRITE setSumm1Enabled				// �ᯮ�짮���� �㬬� ����樨
		PROPERTY TaxValue READ getTaxValue WRITE setTaxValue							// �㬬� ������
		PROPERTY TaxValueEnabled READ getTaxValueEnabled WRITE setTaxValueEnabled	// �ᯮ�짮���� �㬬� ������
		PROPERTY Tax1 READ getTax1 WRITE setTax1										// ��������� �⠢��
		PROPERTY Department READ getDepartment WRITE setDepartment					// �⤥�
		PROPERTY PaymentTypeSign READ getPaymentTypeSign WRITE setPaymentTypeSign	// �ਧ��� ᯮᮡ� ����
		PROPERTY PaymentItemSign READ getPaymentItemSign WRITE setPaymentItemSign	// �ਧ��� �।��� ����
		PROPERTY StringForPrinting READ getStringForPrinting WRITE setStringForPrinting	// ������������ ⮢��
		
		METHOD New()
	HIDDEN:
		DATA FCheckType INIT 1			// (1 - ��室, 2 - ������ ��室�, 3 - ��室, 4 - ������ ��室�)
		DATA FQuantity INIT 0.0
		DATA FPrice INIT 0.0
		DATA FSumm1 INIT 0.0
		DATA FSumm1Enabled INIT .f.
		DATA FTaxValue INIT 0.0
		DATA FTaxValueEnabled INIT .f.
		DATA FTax1 INIT 0
		DATA FDepartment INIT 1
		DATA FPaymentTypeSign INIT 4	// �ਧ��� ᯮᮡ� ����. �������� ���祭��:
										// 1. �।����� 100%
										// 2. ����筠� �।�����
										// 3. �����
										// 4. ����� ����
										// 5. ������ ���� � �।��
										// 6. ��।�� � �।��
										// 7. ����� �।��
		DATA FPaymentItemSign INIT 4	// �ਧ��� �थ��� ����. �������� ���祭��:
										// 1. �����
										// 2. �����樧�� ⮢��
										// 3. �����
										// 4. ��㣠
										// 5. �⠢�� ����⭮� ����
										// 6. �먣��� ����⭮� ����
										// 7. ���३�� �����
										// 8. �먣��� ���२
										// 9. �।��⠢����� ���
										// 10. ���⥦
										// 11. ���⠢��� �।��� ����
										// 12. ���� �।��� ����
		DATA FStringForPrinting INIT ''
		
		METHOD getCheckType
		METHOD setCheckType( param )
		METHOD getQuantity
		METHOD setQuantity( param )
		METHOD getPrice
		METHOD setPrice( param )
		METHOD getSumm1
		METHOD setSumm1( param )
		METHOD getSumm1Enabled
		METHOD setSumm1Enabled( param )
		METHOD getTaxValue
		METHOD setTaxValue( param )
		METHOD getTaxValueEnabled
		METHOD setTaxValueEnabled( param )
		METHOD getTax1
		METHOD setTax1( param )
		METHOD getDepartment
		METHOD setDepartment( param )
		METHOD getPaymentTypeSign
		METHOD setPaymentTypeSign( param )
		METHOD getPaymentItemSign
		METHOD setPaymentItemSign( param )
		METHOD getStringForPrinting
		METHOD setStringForPrinting( param )
		
ENDCLASS

METHOD New()									CLASS TOperationCheck
	return self

METHOD function getCheckType()					CLASS TOperationCheck
	return ::FCheckType

METHOD procedure setCheckType( param )		CLASS TOperationCheck
	::FCheckType := param
	return

METHOD function getQuantity()					CLASS TOperationCheck
	return ::FQuantity

METHOD procedure setQuantity( param )		CLASS TOperationCheck
	::FQuantity := param
	return

METHOD function getPrice()						CLASS TOperationCheck
	return ::FPrice

METHOD procedure setPrice( param )			CLASS TOperationCheck
	::FPrice := param
	return

METHOD function getSumm1()						CLASS TOperationCheck
	return ::FSumm1

METHOD procedure setSumm1( param )			CLASS TOperationCheck
	::FSumm1 := param
	return

METHOD function getSumm1Enabled()				CLASS TOperationCheck
	return ::FSumm1Enabled

METHOD procedure setSumm1Enabled( param )	CLASS TOperationCheck
	::FSumm1Enabled := param
	return

METHOD function getTaxValue()					CLASS TOperationCheck
	return ::FTaxValue

METHOD procedure setTaxValue( param )		CLASS TOperationCheck
	::FTaxValue := param
	return

METHOD function getTaxValueEnabled()			CLASS TOperationCheck
	return ::FTaxValueEnabled

METHOD procedure setTaxValueEnabled( param )	CLASS TOperationCheck
	::FTaxValueEnabled := param
	return

METHOD function getTax1()						CLASS TOperationCheck
	return ::FTax1

METHOD procedure setTax1( param )			CLASS TOperationCheck
	::FTax1 := param
	return

METHOD function getDepartment()				CLASS TOperationCheck
	return ::FDepartment

METHOD procedure setDepartment( param )		CLASS TOperationCheck
	::FDepartment := param
	return

METHOD function getPaymentTypeSign()			CLASS TOperationCheck
	return ::FPaymentTypeSign

METHOD procedure setPaymentTypeSign( param )	CLASS TOperationCheck
	::FPaymentTypeSign := param
	return

METHOD function getPaymentItemSign()			CLASS TOperationCheck
	return ::FPaymentItemSign

METHOD procedure setPaymentItemSign( param )	CLASS TOperationCheck
	::FPaymentItemSign := param
	return

METHOD function getStringForPrinting()			CLASS TOperationCheck
	return ::FStringForPrinting

METHOD procedure setStringForPrinting( param )	CLASS TOperationCheck
	::FStringForPrinting := param
	return