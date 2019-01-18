#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// 䠩� "mo_stdds.dbf" ��樮����, �� ������ ��室�� ��ᯠ��ਧ��� ��⥩-���
CREATE CLASS TStdds	INHERIT	TBaseObjectBLL

	VISIBLE:
		PROPERTY Name AS STRING READ getName WRITE setName				//
		PROPERTY Name1251 READ getName1251								//
		PROPERTY Address AS STRING READ getAddress WRITE setAddress		// 
		PROPERTY Address1251 READ getAddress1251							//
		PROPERTY Vedom AS NUMERIC READ getVedom WRITE setVedom			//  ������⢥���� �ਭ����������
		PROPERTY Fed_kod AS NUMERIC READ getFed_kod WRITE setFed_kod		//  ��� �� 䥤.�ࠢ�筨��
		
		CLASSDATA	aMenuVedom	AS ARRAY	INIT { { '�࣠�� ��ࠢ���࠭����', 0 }, ;
													{ '�࣠�� ��ࠧ������', 1 }, ;
													{ '�࣠�� �樠�쭮� �����', 2 }, ;
													{ '��㣮�', 3 } }

		PROPERTY Vedom_F READ getVedomFormat
		
		METHOD New( nId, cName, cAddress, nVedom, nFed_kod, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FName			INIT space( 250 )
		DATA FAddress		INIT space( 250 )
		DATA FVedom			INIT 0
		DATA FFed_kod		INIT 0
		
		CLASSDATA	aVedom	AS ARRAY	INIT { '�࣠�� ��ࠢ���࠭����', ;
										'�࣠�� ��ࠧ������', ;
										'�࣠�� �樠�쭮� �����', ;
										'��㣮�' }
		
		METHOD getName
		METHOD getName1251
		METHOD setName( param )
		METHOD getAddress
		METHOD getAddress1251
		METHOD setAddress( param )
		METHOD getVedom
		METHOD setVedom( param )
		METHOD getFed_kod
		METHOD setFed_kod( param )
		METHOD getVedomFormat
ENDCLASS

METHOD function getVedomFormat()			CLASS TStdds
	return ::aVedom[ ::FVedom + 1 ]

METHOD function getName()					CLASS TStdds
	return ::FName

METHOD FUNCTION getName1251()				CLASS TStdds
	return win_OEMToANSI( ::FName )

METHOD procedure setName( param )		CLASS TStdds
	::FName := param
	return

METHOD function getAddress()				CLASS TStdds
	return ::FAddress

METHOD FUNCTION getAddress1251()			CLASS TStdds
	return win_OEMToANSI( ::FAddress )

METHOD procedure setAddress( param )		CLASS TStdds
	::FAddress := param
	return

METHOD function getVedom()					CLASS TStdds
	return ::FVedom

METHOD procedure setVedom( param )		CLASS TStdds
	::FVedom := param
	return

METHOD function getFed_kod()				CLASS TStdds
	return ::FFed_kod

METHOD procedure setFed_kod( param )		CLASS TStdds
	::FFed_kod := param
	return

METHOD Clone()		 CLASS TStdds
	local oTarget := nil
	
	oTarget := ::super:Clone()
	return oTarget


METHOD New( nId, cName, cAddress, nVedom, nFed_kod, lNew, lDeleted ) CLASS TStdds
			  
	::FID			:= hb_DefaultValue( nID, 0 )
	::FNew 			:= hb_DefaultValue( lNew, .t. )
	::FDeleted		:= hb_DefaultValue( lDeleted, .f. )
	::FName			:= hb_DefaultValue( cName, space( 250 ) )
	::FAddress		:= hb_DefaultValue( cAddress, space( 250 ) )
	::FVedom		:= hb_DefaultValue( nVedom, 0 )
	::FFed_kod		:= hb_DefaultValue( nFed_kod, 0 )
	return self