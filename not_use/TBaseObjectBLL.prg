#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'

// ����뢠�� ����� TBaseObjectBLL
CREATE CLASS TBaseObjectBLL
	VISIBLE:
		
		PROPERTY ID AS NUMERIC READ getID WRITE setID
		PROPERTY IDUser AS NUMERIC READ getIDUser WRITE setIDUser
		PROPERTY IsDeleted AS LOGICAL READ getIsDeleted WRITE setIsDeleted
		PROPERTY IsNew AS LOGICAL READ getIsNew WRITE setIsNew
		
		METHOD Equal( obj )
		METHOD DeepEqual( obj )
		METHOD Clone()
		METHOD forJSON()				VIRTUAL
	
	PROTECTED:
		DATA FID		INIT 0
		DATA FIDUser	INIT 0
		DATA FDeleted	INIT .f.
		DATA FNew		INIT .t.
		
		METHOD new( nID, lNew, lDeleted )
		METHOD getID
		METHOD setID( value )
		METHOD getIDUser
		METHOD setIDUser( value )
		METHOD getIsDeleted
		METHOD setIsDeleted( value )
		METHOD getIsNew
		METHOD setIsNew( value )
	
ENDCLASS

METHOD function getID()	CLASS TBaseObjectBLL
	return ::FID

METHOD procedure setID( value )	CLASS TBaseObjectBLL
	::FID := value
	return

METHOD function getIDUser()	CLASS TBaseObjectBLL
	return ::FIDUser

METHOD procedure setIDUser( value )	CLASS TBaseObjectBLL
	::FIDUser := value
	return

METHOD function getIsDeleted()	CLASS TBaseObjectBLL
	return ::FDeleted

METHOD procedure setIsDeleted( value )	CLASS TBaseObjectBLL
	::FDeleted := value
	return

METHOD function getIsNew()	CLASS TBaseObjectBLL
	return ::FNew

METHOD procedure setIsNew( value )	CLASS TBaseObjectBLL
	::FNew := value
	return

METHOD New( nID, lNew, lDeleted )	CLASS TBaseObjectBLL

	::FID			:= hb_DefaultValue( nID, 0 )
	::FNew			:= hb_DefaultValue( lNew, .t. )
	::FDeleted		:= hb_DefaultValue( lDeleted, .f. )
	return self

METHOD Clone()		 CLASS TBaseObjectBLL
	local oTarget := nil

	oTarget := __objClone( self )
	oTarget:ID := 0
	oTarget:IsNew := .t.
	oTarget:IsDeleted := .f.
	oTarget:IDUser := 0
	return oTarget
	
******** �ࠢ���� ��ꥪ� � ��।����
* �஢�ઠ �ந�室�� �� �᭮����� ᮢ������� �����䨪��஢ �����
*
* ������ 	.T. - ��ꥪ�� �������⥭�
*			.F. - ��ꥪ�� �� �������⥭�
METHOD Equal( obj )		 CLASS TBaseObjectBLL
	local ret := .f.
	
	if upper( alltrim( ::ClassName() ) ) == upper( alltrim( obj:ClassName() ) )	// ��।��塞, �� ���� � �� �� �����
		ret := ( ::FID == obj:ID )
	endif
	return ret

******** ��������� �ࠢ���� ��ꥪ� � ��।���� ( ���뢠� �� ���� )
* �஢�ઠ �ந�室�� �� �᭮����� ᮢ������� ��� ����� ��� ���� �����䨪��஢ �����
*
* ������ 	.t. - ��ꥪ�� �������⥭�
*			.f. - ��ꥪ�� �� �������⥭�
METHOD DeepEqual( obj )		 CLASS TBaseObjectBLL
	local ret := .f.
	
	if upper( alltrim( ::ClassName() ) ) == upper( alltrim( obj:ClassName() ) )	// ��।��塞, �� ���� � �� �� �����
		// TODO
		&& ret := ( ::FID == obj:ID )
	endif
	return ret