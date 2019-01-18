#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

// ��䨪�� ����
// c - ��ப�
// n - �᫮
// l - �����᪮�
// b - ���� ����
// a - ���ᨢ
// h - ���-���ᨢ
// o - ��ꥪ�
//***
 
// �࠭���� � 䠩�� 'Base1.dbf'
CREATE CLASS TUser	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY FIO WRITE setFIO INIT space( 20 )					//	{"P1", "C", 20, 0},; // �.�.�.
		PROPERTY Access WRITE setAccess INIT 0						//	{"P2", "N",  1, 0},; // ⨯ ����㯠
		PROPERTY Password WRITE setPassword INIT space( 10 )			//	{"P3", "C", 10, 0},; // ��஫�
		PROPERTY Position WRITE setPosition INIT space( 20 )			//	{"P5", "C", 20, 0},; // ���������
		PROPERTY KEK WRITE setKEK INIT 0							//	{"P6", "N",  1, 0},; // ��㯯� ��� (1-3)
		PROPERTY PasswordFR WRITE setPasswordFR INIT 0				//	{"P7", "C", 10, 0},; // ��஫�1 ��� �᪠�쭮�� ॣ������
		PROPERTY PasswordFRSuper WRITE setPasswordFRSuper INIT 0	//	{"P8", "C", 10, 0};  // ��஫�2 ��� �᪠�쭮�� ॣ������
		PROPERTY INN AS STRING READ getINN WRITE setINN
		PROPERTY IDRole WRITE setIDRole INIT 0						//	{"IDROLE", "N",  4, 0},; // ID ��㯯� ���짮��⥫��
		
		PROPERTY Name READ getName WRITE setFIO
		PROPERTY Name1251 READ getName1251
		PROPERTY FIO1251 READ getName1251
		PROPERTY Department READ getDepartment
		PROPERTY Position1251 READ getPosition1251
		
		PROPERTY DepShortName READ getDepShortName
		PROPERTY Type_F READ getTypeFormat
	
		CLASSDATA	aMenuType	AS ARRAY	INIT { { '�������������',  0 }, ;
													{ '��������     ', 1 }, ;
													{ '���������    ', 3 } }
										
		METHOD IsAdmin()					INLINE iif(( ::FAccess + 1 ) == 1, .t., .f. )
		METHOD IsOperator()				INLINE iif(( ::FAccess + 1 ) == 2, .t., .f. )
		METHOD IsKontroler()				INLINE iif(( ::FAccess + 1 ) == 3, .t., .f. )
					
		METHOD IsAllowedDepartment( nSub )
		METHOD IsAllowedTask( nTask )
		METHOD IDDepartment( Param )
		
		METHOD New( nID, cFIO, nAccess, cPassword, cDepartment, cPosition, nKEK, ;
					cPasswordFR, cPasswordFRSuper, nIdRole, lNew, lDeleted )
	HIDDEN:
		CLASSDATA	aType	AS ARRAY	INIT { '�������������', ;
										   '��������     ', ;
										   '             ', ;
										   '���������    ' }
		DATA FDepartment		INIT nil
		DATA FRole				INIT nil
		DATA FACLDep 			INIT space( 255 )	//	����� � ��०�����, �� 㬮�砭�� '*' ��
		DATA FACLTask			INIT space( 255 )	//	����� � ����砬, �� 㬮�砭�� '*' ��
		DATA FINN				INIT space( 12 )
		
		VAR _department	 		AS CHARACTER	INIT chr( 0 )		//	{"P4", "C",  1, 0},; // ��� �⤥����� [ chr(kod) ]
		
		METHOD setFIO( cText )
		METHOD setAccess( nAccess )
		METHOD setPassword( cText )
		METHOD setPosition( cText )
		METHOD setKEK( nKEK )
		METHOD setPasswordFR( nPassword )
		METHOD setPasswordFRSuper( nPassword )
		METHOD setIDRole( nID )
		METHOD getName
		METHOD getName1251
		METHOD getPosition1251
		METHOD getDepartment
		METHOD getINN
		METHOD setINN( param )
		
		METHOD getDepShortName
		METHOD getTypeFormat
END CLASS

METHOD function getINN()			CLASS TUser
	return ::FINN

METHOD procedure setINN( param )	CLASS TUser

	if ischaracter( param )
		::FINN := param
	endif
	return

METHOD FUNCTION getTypeFormat()	CLASS TUser
	return ::aType[ ::FAccess + 1 ]

METHOD FUNCTION getDepShortName()	CLASS TUser
	local ret := ''
	
	if ! isnil( ::FDepartment )
		ret := ::FDepartment:ShortName
	endif
	return ret

METHOD FUNCTION getDepartment()	CLASS TUser
	&& return TDepartmentDB():getById( asc( ::_department ) )
	return ::FDepartment

METHOD FUNCTION getName()	CLASS TUser
	return ::FFIO

METHOD FUNCTION getName1251()	CLASS TUser
	return win_OEMToANSI( ::FFIO )

METHOD FUNCTION getPosition1251()	CLASS TUser
	return win_OEMToANSI( ::FPosition )

METHOD PROCEDURE setIDRole( nID )	CLASS TUser
	::FIDRole := nID
	return

METHOD PROCEDURE setFIO( cText )	CLASS TUser
	::FFIO := left( cText, 20 )
	return

METHOD PROCEDURE setAccess( nAccess )	CLASS TUser
	::FAccess := nAccess
	return

METHOD PROCEDURE setPassword( cText )	CLASS TUser
	::FPassword := left( cText, 10 )
	return

METHOD PROCEDURE setKEK( nKEK )	CLASS TUser
	::FKEK := nKEK
	return

METHOD PROCEDURE setPasswordFR( nPassword )	CLASS TUser
	::FPasswordFR := nPassword
	return

METHOD PROCEDURE setPasswordFRSuper( nPassword )	CLASS TUser
	::FPasswordFRSuper := nPassword
	return

METHOD PROCEDURE setPosition( cText )	CLASS TUser
	::FPosition := left( cText, 20 )
	return
	
***********************************
* ������� ���� ��ꥪ� TUser
METHOD New( nID, cFIO, nAccess, cPassword, cDepartment, cPosition, nKEK, ;
			cPasswordFR, cPasswordFRSuper, nIdRole, lNew, lDeleted ) CLASS TUser
	local cRegEx := '[-+]?[0-9]*[.,]?[0-9]+'			// �����⨬� ⮫쪮 ��஢� ᨬ����
	local tmpPassFR, tmpPassFRSuper
	
	::super:new( nID, lNew, lDeleted )

	::FFIO			:= HB_DefaultValue( cFIO, space( 20 ) )		// ���
	::FAccess		:= hb_DefaultValue( nAccess, 0 )			// ⨯ ����㯠
	::FPassword		:= HB_DefaultValue( cPassword, space( 10 ) )	// ��஫�
	::_department	:= HB_DefaultValue( cDepartment, ' ' )		// ��� �⤥����� [ chr(kod) ]
	::FPosition		:= HB_DefaultValue( cPosition, space( 20 ) ) // ���������
	::FKEK			:= hb_DefaultValue( nKek, 0 )				// ��㯯� ��� (1-3)
	
	tmpPassFR		:= alltrim( HB_DefaultValue( cPasswordFR, space( 10 ) ) )
	tmpPassFRSuper	:= alltrim( HB_DefaultValue( cPasswordFRSuper, space( 10 ) ) )
	
	::FDepartment := TDepartmentDB():getById( asc( ::_department ) )
	::FIDRole		:= hb_DefaultValue( nIdRole, 0 )
	::FRole := TRoleUserDB():GetByID( ::FIDRole )
	
	if !empty( cPasswordFR ) .and. hb_RegexLike( cRegEx, tmpPassFR )
		::FPasswordFR		:= iif( ::FNew, cPasswordFR, int( val( tmpPassFR ) ) )			// ��஫�1 ��� �᪠�쭮�� ॣ������
	endif
	if !empty( cPasswordFRSuper ) .and. hb_RegexLike( cRegEx, tmpPassFRSuper )
		::FPasswordFRSuper	:= iif( ::FNew, cPasswordFRSuper, int( val( tmpPassFRSuper ) ) )	// ��஫�2 ��� �᪠�쭮�� ॣ������
	endif
	
	if ! isnil( ::FRole )
		::FACLTask	:= ::FRole:ACLTask
		::FACLDep	:= ::FRole:ACLDep
	endif
	if ! ( ::FNew ) .and. ( ::FID == 0 )		// �㦥��� ���짮��⥫� � ᯥ� ��஫��
		return ret
	endif
	return self                  

METHOD IDDepartment( Param )		 CLASS TUser
	local ret := 0
	
	if pcount() > 0
		::_department := chr( param )
		::FDepartment := TDepartmentDB():getById( param )
	else
		ret := asc( ::_department )
	endif
	return ret

***********************************
* �஢�ઠ �����⨬��� ࠡ��� � �⤥������
* ��ࠬ����:
* 	nSub - ��� �⤥����� ( Subdivision )
* ������:
*	.t. - ࠡ�� �����⨬�, .f. - ࠡ�� �� �����⨬�
METHOD IsAllowedDepartment( nSub ) CLASS TUser
	local ret := .f., k
	local ch

	if !::IsAdmin()
		if empty( ::FACLDep )
			return .t.
		endif
		ret := HasNumberInString( nSub, ::FACLDep )
	else
		ret := .t.
	endif
	return ret

***********************************
* �஢�ઠ �����⨬��� ࠡ��� � ����祩
* ��ࠬ����:
* 	nTask - ��� ����� ( Subdivision )
* ������:
*	.t. - ࠡ�� � ����� �����⨬�, .f. - ࠡ�� � ����� �� �����⨬�
METHOD IsAllowedTask( nTask ) CLASS TUser
	local ret := .F., k

	if !::IsAdmin()
		if empty( ::FACLTask )
			return .t.
		endif
		ret := HasNumberInString( nTask, ::FACLTask )
	else
		ret := .t.
	endif
	return ret