#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'property.ch'

// ����� ��� ���㤭���� ��०����� 䠩� MO_PERS.DBF
CREATE CLASS TEmployee	INHERIT	TBaseObjectBLL
	VISIBLE:
		CLASSDATA	aMenuCategory	AS ARRAY	INIT { { '���', 1 }, ;
													{ '�।��� ���.���ᮭ��', 2 }, ;
													{ '����訩 ���.���ᮭ��', 3 }, ;
													{ '��稥', 4 } }

		CLASSDATA	aMenuDoctorCat	AS ARRAY	INIT { {'��� ��⥣�ਨ   ', 0 }, ;
														{ '2-�� ��⥣���  ', 1 }, ;
														{ '1-�� ��⥣���  ', 2 }, ;
														{ '����� ��⥣���', 3 } }
											
		CLASSDATA	aMenuTypeJob	AS ARRAY	INIT { { '�᭮���� ࠡ��', 0 }, ;
														{ 'ᮢ��饭��     ', 1 } }
		
		PROPERTY Code READ getCode WRITE setCode									// ���
		PROPERTY FIO READ getName WRITE setName									// ���
		PROPERTY ShortFIO READ getShortFIO										// ��� ��⪮
		PROPERTY FIO1251 READ getName1251										// ��� ����஢�� 1251
		PROPERTY ShortFIO1251 READ getShortFIO1251								// ��� ��⪮ 1251
		PROPERTY Name READ getName WRITE setName									// ���
		PROPERTY Name1251 READ getName1251										// ���
		PROPERTY Department READ getDepartment WRITE setDepartment				// ��� ��०�����
		PROPERTY Subdivision READ getSubdivision WRITE setSubdivision			// ��� �⤥�����
		PROPERTY Position READ getPosition WRITE setPosition						// ������������ ��������
		PROPERTY Position1251 READ getPosition1251
		PROPERTY Category READ getCategory WRITE setCategory						// ��� ��⥣�ਨ
		PROPERTY Category_F READ getCategoryFormat
		PROPERTY Stavka READ getStavka WRITE setStavka							// �⠢��
		PROPERTY Vid READ getVid WRITE setVid									// ��� ࠡ���;0-�᭮����, 1-ᮢ��饭��
		PROPERTY DoctorCategory READ getDoctorCategory WRITE setDoctorCategory	// ��� ��祡��� ��⥣�ਨ
		PROPERTY DoctorCategory_F READ getDoctorCategoryFormat
		PROPERTY DoljCategory READ getDoljCategory WRITE setDoljCategory			// ������������ �������� �� ��⥣�ਨ
		PROPERTY DoljCategory1251 READ getDoljCategory1251
														
		PROPERTY Profil READ getProfil WRITE setProfil							// ��䨫� ᯥ樠�쭮�� �� �ࠢ�筨�� V002

		PROPERTY Dcategory READ getDcategory WRITE setDcategory
		PROPERTY IsSertif READ getIsSertif WRITE setIsSertif
		PROPERTY Dsertif READ getDsertif WRITE setDsertif
		PROPERTY PRVS READ getPRVS WRITE setPRVS
		PROPERTY PRVSNEW READ getPRVSNew WRITE setPRVSNew
		
		PROPERTY PRVS_F READ getPRVSFormat
		
		PROPERTY TabNom READ getTabNom WRITE setTabNom							// ⠡���� �����
		PROPERTY SvodNom READ getSvodNom WRITE setSvodNom						// ᢮��� ⠡���� �����
		PROPERTY KodDLO READ getKodDLO WRITE setKodDLO   						// ��� ��� ��� �믨᪨ �楯⮢ �� ���
		PROPERTY Uroven READ getUroven WRITE setUroven   						// �஢��� ������;�� 1 �� 99
		PROPERTY Uroven_F READ getUrovenFormat
		PROPERTY Otdal READ getOtdal WRITE setOtdal      						// �ਧ��� �⤠�������;.f.-���, .t.-��
		PROPERTY Otdal_F READ getOtdalFormat
		PROPERTY SNILS READ getSNILS WRITE setSNILS								// ����� ���
		PROPERTY SNILS_F READ getSNILSformat										// ����� ��� ���ଠ�஢����
		PROPERTY DBegin READ getDBegin WRITE setDBegin							// ��� ��砫� ����⢨�;;���⠢��� 01.01.1993
		PROPERTY DEnd READ getDEnd WRITE setDEnd									// ��� ����砭�� ����⢨�
		
		// ��⥣�ਨ ���㤭����
		PROPERTY IsDoctor READ getIsDoctor										// ���㤭�� �����
		PROPERTY IsNurse READ getIsNurse											// ���㤭�� �������
		PROPERTY IsAidman READ getIsAidman										// ���㤭�� ᠭ���
		PROPERTY IsOther READ getIsOther											// ���㤭�� ��稩 ���ᮭ��
											
		METHOD New( nId, lNew, lDeleted  )
	
		METHOD Clone()

		&& METHOD listForJSON()
		METHOD forJSON()
	HIDDEN:
		CLASSDATA	aShortCat		AS ARRAY INIT { '   ', '��.', '��.', '��.', '��.' }
		CLASSDATA	aShortCatDoctor	AS ARRAY INIT { ' ���', '2-��', '1-��', '����' }
		
		
		DATA FCode		INIT 0
		DATA FDepartment INIT 0
		DATA FSubdivision INIT 0
		DATA FPosition	INIT space( 30 )
		DATA FCategory	INIT 0
		DATA FName		INIT space( 50 )
		DATA FStavka	INIT 0
		DATA FVid		INIT 0
		DATA FDoctorCategory	INIT 0
		DATA FDoljCategory	INIT space( 15 )
		
		DATA FDcategory	INIT ctod( '' )
		DATA FIsSertif	INIT .f.
		DATA FDsertif	INIT ctod( '' )
		DATA FPRVS		INIT 0
		DATA FPRVSNEW	INIT 0
		
		DATA FSNILS		INIT space( 11 )
		DATA FDBegin	INIT ctod( '' )
		DATA FDEnd		INIT ctod( '' )
		DATA FProfil	INIT 0
		DATA FTabNom	INIT 0
		DATA FSvodNom	INIT 0
		DATA FKodDLO	INIT 0
		DATA FUroven	INIT 0
		DATA FOtdal		INIT .f.

		METHOD getSNILS				INLINE ::FSNILS
		METHOD getSNILSformat		INLINE transform( ::FSNILS, picture_pf )
		METHOD setSNILS( cSNILS )
		METHOD getDBegin				INLINE ::FDBegin
		METHOD setDBegin( date )
		METHOD getDEnd				INLINE ::FDEnd
		METHOD setDEnd( date )
		METHOD getProfil				INLINE ::FProfil
		METHOD setProfil( nVal )

		METHOD getName1251			INLINE win_OEMToANSI( ::FName )
		METHOD getPosition1251		INLINE win_OEMToANSI( ::FPosition )
		METHOD getDoljCategory1251	INLINE win_OEMToANSI( ::FDoljCategory )
		METHOD getCode				INLINE ::FCode
		METHOD setCode( nVal )
		METHOD getName				INLINE ::FName
		METHOD setName( cValue )
		METHOD getShortFIO
		METHOD getShortFIO1251		INLINE win_OEMToANSI( ::getShortFIO() )
		METHOD getDepartment			INLINE ::FDepartment
		METHOD setDepartment( nVal )
		METHOD getSubdivision		INLINE ::FSubdivision
		METHOD setSubdivision( nVal )
		METHOD getPosition			INLINE ::FPosition
		METHOD setPosition( cVal )
		METHOD getCategory			INLINE ::FCategory
		METHOD getCategoryFormat		INLINE ::aShortCat[ ::FCategory + 1 ]
		METHOD setCategory( nVal )
		METHOD getStavka				INLINE ::FStavka
		METHOD setStavka( nVal )
		METHOD getVid				INLINE ::FVid
		METHOD setVid( nVal )
		METHOD getDoctorCategory		INLINE ::FDoctorCategory
		METHOD getDoctorCategoryFormat	INLINE padr( ::aShortCatDoctor[ ::FDoctorCategory + 1 ], 4 )
		METHOD setDoctorCategory( nVal )
		METHOD getDoljCategory		INLINE ::FDoljCategory
		METHOD setDoljCategory( cVal )
		
		METHOD getDcategory			INLINE ::FDcategory
		METHOD setDcategory( date )
		METHOD getIsSertif			INLINE ::FIsSertif
		METHOD setIsSertif( lVal )
		METHOD getDsertif			INLINE ::FDsertif
		METHOD setDsertif( date )
		METHOD getPRVS				INLINE ::FPRVS
		METHOD getPRVSFormat			INLINE ret_tmp_prvs( ::FPRVS, ::FPRVSNEW )
		METHOD setPRVS( nVal )
		METHOD getPRVSNew			INLINE ::FPRVSNEW
		METHOD setPRVSNew( nVal )
		
		METHOD getTabNom				INLINE ::FTabNom
		METHOD setTabNom( nVal )
		METHOD getSvodNom			INLINE ::FSvodNom
		METHOD setSvodNom( nVal )
		METHOD getKodDLO				INLINE ::FKodDLO
		METHOD setKodDLO( nVal )
		METHOD getUroven				INLINE ::FUroven
		METHOD getUrovenFormat		INLINE put_val( ::FUroven, 2 )
		METHOD setUroven( nVal )
		METHOD getOtdal				INLINE ::FOtdal
		METHOD getOtdalFormat		INLINE padc( iif( ::FOtdal, '�', '' ), 9 )
		METHOD setOtdal( lVal )
		
		METHOD getIsDoctor()			INLINE ( ::FCategory == 1 )
		METHOD getIsNurse()			INLINE ( ::FCategory == 2 )
		METHOD getIsAidman()			INLINE ( ::FCategory == 3 )
		METHOD getIsOther()			INLINE ( ::FCategory == 4 )
ENDCLASS

METHOD function forJSON()    CLASS TEmployee
	local oRow := nil, obj := nil
	local hItems, hItem, h
	local lSUCCES

	h := { => }
	hItems := { => }
	hItem := { => }
	hb_HSet( hItem, 'ID', ltrim( str( ::ID ) ) )
	hb_HSet( hItem, 'Name', alltrim( ::Name ) )
	hb_HSet( hItem, 'Position', alltrim( ::Position ) )
	hb_HSet( hItem, 'SNILS', alltrim( transform( ::SNILS, picture_pf ) ) )
	hb_HSet( hItem, 'TabNom', alltrim( ltrim( str( ::TabNom ) ) ) )
	return hItem
	
&& METHOD function listForJSON()    CLASS TEmployee
	&& local oRow := nil, obj := nil
	&& local hItems, hItem, h
	&& local lSUCCES

	&& h := { => }
	&& hItems := { => }
	&& for each oRow in ::super:GetList( )
		&& hItem := { => }
		&& obj := ::FillFromHash( oRow )
		&& hb_HSet( hItem, 'ID', ltrim( str( obj:ID ) ) )
		&& hb_HSet( hItem, 'Name', alltrim( obj:Name ) )
		&& hb_HSet( hItem, 'Position', alltrim( obj:Position ) )
		&& hb_HSet( hItem, 'SNILS', alltrim( transform( obj:SNILS, picture_pf ) ) )
		&& hb_HSet( hItem, 'TabNom', alltrim( ltrim( str( obj:TabNom ) ) ) )
		&& hb_HSet( hItems, '����㤭��-' + ltrim( str( obj:ID ) ), hItem )
	&& next
	&& h[ '��ࠢ�筨�����㤭����' ] := hItems
	&& return h

METHOD PROCEDURE setCode( nVal )	CLASS TEmployee

	::FCode := nVal
	return

METHOD PROCEDURE setName( cValue )	CLASS TEmployee

	::FName := cValue
	return

METHOD PROCEDURE setDepartment( nVal )	CLASS TEmployee

	::FDepartment := nVal
	return

METHOD PROCEDURE setSubdivision( nVal )	CLASS TEmployee

	::FSubdivision := nVal
	return

METHOD PROCEDURE setPosition( cVal )	CLASS TEmployee

	::FPosition := cVal
	return

METHOD PROCEDURE setCategory( nVal )	CLASS TEmployee

	::FCategory := nVal
	return

METHOD PROCEDURE setStavka( nVal )	CLASS TEmployee

	::FStavka := nVal
	return

METHOD PROCEDURE setVid( nVal )	CLASS TEmployee

	::FVid := nVal
	return

METHOD PROCEDURE setDoctorCategory( nVal )	CLASS TEmployee

	::FDoctorCategory := nVal
	return

METHOD PROCEDURE setDoljCategory( cVal )	CLASS TEmployee

	::FDoljCategory := cVal
	return

METHOD PROCEDURE setDcategory( date )	CLASS TEmployee

	::FDcategory := date
	return

METHOD PROCEDURE setIsSertif( lVal )	CLASS TEmployee

	::FIsSertif := lVal
	return

METHOD PROCEDURE setDsertif( date )	CLASS TEmployee

	::FDsertif := date
	return

METHOD PROCEDURE setPRVS( nVal )

	::FPRVSNEW := nVal
	return

METHOD PROCEDURE setPRVSNew( nVal )	CLASS TEmployee

	::FPRVSNEW := nVal
	return

METHOD PROCEDURE setTabNom( nVal )	CLASS TEmployee

	::FTabNom := nVal
	return

METHOD PROCEDURE setSvodNom( nVal )	CLASS TEmployee

	::FSvodNom := nVal
	return

METHOD PROCEDURE setKodDLO( nVal )	CLASS TEmployee

	::FKodDLO := nVal
	return

METHOD PROCEDURE setUroven( nVal )	CLASS TEmployee

	::FUroven := nVal
	return

METHOD PROCEDURE setOtdal( lVal )	CLASS TEmployee

	::FOtdal := lVal
	return

METHOD PROCEDURE setDBegin( date )	CLASS TEmployee
	
	::FDBegin := date
	return

METHOD PROCEDURE setDEnd( date )	CLASS TEmployee
	
	::FDEnd := date
	return

METHOD PROCEDURE setSNILS( cSNILS )	CLASS TEmployee
	
	::FSNILS := cSNILS
	return

METHOD PROCEDURE setProfil( nVal )	CLASS TEmployee
	
	::FProfil := nVal
	return

METHOD Clone()		 CLASS TEmployee
	local oTarget := nil
	
	oTarget := ::super:Clone()
	oTarget:Code( 0 )
	oTarget:TabNom( 0 )
	return oTarget

METHOD getShortFIO( )   CLASS TEmployee
	local cStr, ret := '', k := 0
	local cFIO := ::FName, i, s := '', s1 := '', ret_arr := { '', '', '' }

	cFIO := alltrim( cFIO )
	for i := 1 to numtoken(	cFIO,	' '	)
		s1 := alltrim( token( cFIO, ' ', i ) )
		if !empty( s1 )
			++k
			if k < 3
				ret_arr[ k ] := s1
			else
				s += s1 + ' '
			endif
		endif
	next
	ret_arr[3] := alltrim( s )
	ret := ret_arr[1] + ' ' + Left( ret_arr[2], 1 ) + '.' + if( Empty( ret_arr[3] ), '', Left( ret_arr[3], 1 ) + '.' )
	return ret

METHOD New( nId, lNew, lDeleted  ) CLASS TEmployee

	::super:new( nID, lNew, lDeleted )
	return self