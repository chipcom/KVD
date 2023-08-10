#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TForeignCitizen	INHERIT	TBaseObjectBLL
	VISIBLE:
		CLASSDATA	aMenuBaseOfStay	AS ARRAY	INIT { ; // �᭮����� �ॡ뢠��� � ��
												{ '�� (��� �� ��⥫��⢮)', 1 }, ;
												{ '��� (ࠧ�襭�� �� �६������ �ॡ뢠���)', 0 }, ;
												{ '����樮���� ����', 2 }, ;
												{ '������᪠� ����', 3 }, ;
												{ '����樭᪠� ����', 4 }, ; 
												{ '���⥢�� ����', 5 }, ;
												{ '������� ����', 6 }, ;
												{ '�࠭��⭠� ����', 7 }, ;
												{ '��㤥��᪠� ����', 8 }, ;
												{ '������ ����', 9 }, ;
												{ '��㣠� ����', 10 } }

		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient
		PROPERTY BaseOfStay AS NUMERIC READ getBaseOfStay WRITE setBaseOfStay	// �᭮����� �ॡ뢠��� � ��
		PROPERTY AddressRegistration AS STRING READ getAddressRegistration WRITE setAddressRegistration	// ���� �஦������ � ����.���.
		PROPERTY MigrationCard AS STRING READ getMigrationCard WRITE setMigrationCard	// ����� ����樮���� �����
		PROPERTY DateBorderCrossing AS DATE READ getDateBorderCrossing WRITE setDateBorderCrossing	// ��� ����祭�� �࠭���
		PROPERTY DateRegistration AS DATE READ getDateRegistration WRITE setDateRegistration	// ��� ॣ����樨 � ���

		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FIDPatient INIT 0
		DATA FBaseOfStay INIT 0
		DATA FAddressRegistration INIT space( 60 )
		DATA FMigrationCard INIT space( 20 )
		DATA FDateBorderCrossing INIT ctod( '' )
		DATA FDateRegistration INIT ctod( '' )

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getBaseOfStay
		METHOD setBaseOfStay( param )
		METHOD getAddressRegistration
		METHOD setAddressRegistration( param )
		METHOD getMigrationCard
		METHOD setMigrationCard( param )
		METHOD getDateBorderCrossing
		METHOD setDateBorderCrossing( param )
		METHOD getDateRegistration
		METHOD setDateRegistration( param )
ENDCLASS

METHOD function getIDPatient()		CLASS TForeignCitizen
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TForeignCitizen
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getBaseOfStay()		CLASS TForeignCitizen
	return ::FBaseOfStay

METHOD procedure setBaseOfStay( param )		CLASS TForeignCitizen
	
	if isnumber( param )
		::FBaseOfStay := param
	endif
	return

METHOD function getAddressRegistration()		CLASS TForeignCitizen
	return ::FAddressRegistration

METHOD procedure setAddressRegistration( param )		CLASS TForeignCitizen
	
	if ischaracter( param )
		::FAddressRegistration := param
	endif
	return

METHOD function getMigrationCard()		CLASS TForeignCitizen
	return ::FMigrationCard

METHOD procedure setMigrationCard( param )		CLASS TForeignCitizen
	
	if ischaracter( param )
		::FMigrationCard := param
	endif
	return

METHOD function getDateBorderCrossing()		CLASS TForeignCitizen
	return ::FDateBorderCrossing

METHOD procedure setDateBorderCrossing( param )		CLASS TForeignCitizen
	
	if isdate( param )
		::FDateBorderCrossing := param
	endif
	return

METHOD function getDateRegistration()		CLASS TForeignCitizen
	return ::FDateRegistration

METHOD procedure setDateRegistration( param )		CLASS TForeignCitizen
	
	if isdate( param )
		::FDateRegistration := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TForeignCitizen

	::super:new( nID, lNew, lDeleted )
	return self
