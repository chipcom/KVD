#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'property.ch'

// класс для сотрудников учреждения файл MO_PERS.DBF
CREATE CLASS TEmployee	INHERIT	TBaseObjectBLL
	VISIBLE:
		CLASSDATA	aMenuCategory	AS ARRAY	INIT { { 'врач', 1 }, ;
													{ 'средний мед.персонал', 2 }, ;
													{ 'младший мед.персонал', 3 }, ;
													{ 'прочие', 4 } }

		CLASSDATA	aMenuDoctorCat	AS ARRAY	INIT { {'без категории   ', 0 }, ;
														{ '2-ая категория  ', 1 }, ;
														{ '1-ая категория  ', 2 }, ;
														{ 'высшая категория', 3 } }
											
		CLASSDATA	aMenuTypeJob	AS ARRAY	INIT { { 'основная работа', 0 }, ;
														{ 'совмещение     ', 1 } }
		
		PROPERTY Code READ getCode WRITE setCode									// код
		PROPERTY FIO READ getName WRITE setName									// ФИО
		PROPERTY ShortFIO READ getShortFIO										// ФИО кратко
		PROPERTY FIO1251 READ getName1251										// ФИО кодировка 1251
		PROPERTY ShortFIO1251 READ getShortFIO1251								// ФИО кратко 1251
		PROPERTY Name READ getName WRITE setName									// ФИО
		PROPERTY Name1251 READ getName1251										// ФИО
		PROPERTY Department READ getDepartment WRITE setDepartment				// код учреждения
		PROPERTY Subdivision READ getSubdivision WRITE setSubdivision			// код отделения
		PROPERTY Position READ getPosition WRITE setPosition						// наименование должности
		PROPERTY Position1251 READ getPosition1251
		PROPERTY Category READ getCategory WRITE setCategory						// код категории
		PROPERTY Category_F READ getCategoryFormat
		PROPERTY Stavka READ getStavka WRITE setStavka							// ставка
		PROPERTY Vid READ getVid WRITE setVid									// вид работы;0-основной, 1-совмещение
		PROPERTY DoctorCategory READ getDoctorCategory WRITE setDoctorCategory	// код врачебной категории
		PROPERTY DoctorCategory_F READ getDoctorCategoryFormat
		PROPERTY DoljCategory READ getDoljCategory WRITE setDoljCategory			// наименование должности по категории
		PROPERTY DoljCategory1251 READ getDoljCategory1251
														
		PROPERTY Profil READ getProfil WRITE setProfil							// профиль специальности по справочнику V002

		PROPERTY Dcategory READ getDcategory WRITE setDcategory
		PROPERTY IsSertif READ getIsSertif WRITE setIsSertif
		PROPERTY Dsertif READ getDsertif WRITE setDsertif
		PROPERTY PRVS READ getPRVS WRITE setPRVS
		PROPERTY PRVSNEW READ getPRVSNew WRITE setPRVSNew
		
		PROPERTY PRVS_F READ getPRVSFormat
		
		PROPERTY TabNom READ getTabNom WRITE setTabNom							// табельный номер
		PROPERTY SvodNom READ getSvodNom WRITE setSvodNom						// сводный табельный номер
		PROPERTY KodDLO READ getKodDLO WRITE setKodDLO   						// код врача для выписки рецептов по ДЛО
		PROPERTY Uroven READ getUroven WRITE setUroven   						// уровень оплаты;от 1 до 99
		PROPERTY Uroven_F READ getUrovenFormat
		PROPERTY Otdal READ getOtdal WRITE setOtdal      						// признак отдаленности;.f.-нет, .t.-да
		PROPERTY Otdal_F READ getOtdalFormat
		PROPERTY SNILS READ getSNILS WRITE setSNILS								// СНИЛС врача
		PROPERTY SNILS_F READ getSNILSformat										// СНИЛС врача отформатированный
		PROPERTY DBegin READ getDBegin WRITE setDBegin							// дата начала действия;;поставить 01.01.1993
		PROPERTY DEnd READ getDEnd WRITE setDEnd									// дата окончания действия
		
		// Категории сотрудников
		PROPERTY IsDoctor READ getIsDoctor										// сотрудник доктор
		PROPERTY IsNurse READ getIsNurse											// сотрудник медсестра
		PROPERTY IsAidman READ getIsAidman										// сотрудник санитар
		PROPERTY IsOther READ getIsOther											// сотрудник прочий персонал
											
		METHOD New( nId, lNew, lDeleted  )
	
		METHOD Clone()

		&& METHOD listForJSON()
		METHOD forJSON()
	HIDDEN:
		CLASSDATA	aShortCat		AS ARRAY INIT { '   ', 'вр.', 'ср.', 'мл.', 'пр.' }
		CLASSDATA	aShortCatDoctor	AS ARRAY INIT { ' без', '2-ая', '1-ая', 'высш' }
		
		
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

		METHOD getSNILS
		METHOD getSNILSformat
		METHOD setSNILS( cSNILS )
		METHOD getDBegin
		METHOD setDBegin( date )
		METHOD getDEnd
		METHOD setDEnd( date )
		METHOD getProfil
		METHOD setProfil( nVal )

		METHOD getName1251
		METHOD getPosition1251
		METHOD getDoljCategory1251
		METHOD getCode
		METHOD setCode( nVal )
		METHOD getName
		METHOD setName( cValue )
		METHOD getShortFIO
		METHOD getShortFIO1251
		METHOD getDepartment
		METHOD setDepartment( nVal )
		METHOD getSubdivision
		METHOD setSubdivision( nVal )
		METHOD getPosition
		METHOD setPosition( cVal )
		METHOD getCategory
		METHOD getCategoryFormat
		METHOD setCategory( nVal )
		METHOD getStavka
		METHOD setStavka( nVal )
		METHOD getVid
		METHOD setVid( nVal )
		METHOD getDoctorCategory
		METHOD getDoctorCategoryFormat
		METHOD setDoctorCategory( nVal )
		METHOD getDoljCategory
		METHOD setDoljCategory( cVal )
		
		METHOD getDcategory
		METHOD setDcategory( date )
		METHOD getIsSertif
		METHOD setIsSertif( lVal )
		METHOD getDsertif
		METHOD setDsertif( date )
		METHOD getPRVS
		METHOD getPRVSFormat
		METHOD setPRVS( nVal )
		METHOD getPRVSNew
		METHOD setPRVSNew( nVal )
		
		METHOD getTabNom
		METHOD setTabNom( nVal )
		METHOD getSvodNom
		METHOD setSvodNom( nVal )
		METHOD getKodDLO
		METHOD setKodDLO( nVal )
		METHOD getUroven
		METHOD getUrovenFormat
		METHOD setUroven( nVal )
		METHOD getOtdal
		METHOD getOtdalFormat
		METHOD setOtdal( lVal )
		
		METHOD getIsDoctor()				INLINE ( ::FCategory == 1 )
		METHOD getIsNurse()				INLINE ( ::FCategory == 2 )
		METHOD getIsAidman()				INLINE ( ::FCategory == 3 )
		METHOD getIsOther()				INLINE ( ::FCategory == 4 )
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
		&& hb_HSet( hItems, 'Сотрудник-' + ltrim( str( obj:ID ) ), hItem )
	&& next
	&& h[ 'СправочникСотрудников' ] := hItems
	&& return h

METHOD function getShortFIO1251()	CLASS TEmployee
	return win_OEMToANSI( ::getShortFIO() )

METHOD function getName1251()	CLASS TEmployee
	return win_OEMToANSI( ::FName )
	
METHOD function getPosition1251()	CLASS TEmployee
	return win_OEMToANSI( ::FPosition )

METHOD function getDoljCategory1251()	CLASS TEmployee
	return win_OEMToANSI( ::FDoljCategory )

METHOD function getCode()	CLASS TEmployee
	return ::FCode

METHOD PROCEDURE setCode( nVal )	CLASS TEmployee

	::FCode := nVal
	return

METHOD function getName()	CLASS TEmployee
	return ::FName

METHOD PROCEDURE setName( cValue )	CLASS TEmployee

	::FName := cValue
	return

METHOD function getDepartment()	CLASS TEmployee
	return ::FDepartment

METHOD PROCEDURE setDepartment( nVal )	CLASS TEmployee

	::FDepartment := nVal
	return

METHOD function getSubdivision()	CLASS TEmployee
	return ::FSubdivision

METHOD PROCEDURE setSubdivision( nVal )	CLASS TEmployee

	::FSubdivision := nVal
	return

METHOD function getPosition()	CLASS TEmployee
	return ::FPosition

METHOD PROCEDURE setPosition( cVal )	CLASS TEmployee

	::FPosition := cVal
	return

METHOD function getCategory()	CLASS TEmployee
	return ::FCategory

METHOD function getCategoryFormat()	CLASS TEmployee
	return ::aShortCat[ ::FCategory + 1 ]

METHOD PROCEDURE setCategory( nVal )	CLASS TEmployee

	::FCategory := nVal
	return

METHOD function getStavka()	CLASS TEmployee
	return ::FStavka

METHOD PROCEDURE setStavka( nVal )	CLASS TEmployee

	::FStavka := nVal
	return

METHOD function getVid()	CLASS TEmployee
	return ::FVid

METHOD PROCEDURE setVid( nVal )	CLASS TEmployee

	::FVid := nVal
	return

METHOD function getDoctorCategory()	CLASS TEmployee
	return ::FDoctorCategory

METHOD function getDoctorCategoryFormat()	CLASS TEmployee
	return padr( ::aShortCatDoctor[ ::FDoctorCategory + 1 ], 4 )


METHOD PROCEDURE setDoctorCategory( nVal )	CLASS TEmployee

	::FDoctorCategory := nVal
	return

METHOD function getDoljCategory()	CLASS TEmployee
	return ::FDoljCategory

METHOD PROCEDURE setDoljCategory( cVal )	CLASS TEmployee

	::FDoljCategory := cVal
	return

METHOD function getDcategory()	CLASS TEmployee
	return ::FDcategory

METHOD PROCEDURE setDcategory( date )	CLASS TEmployee

	::FDcategory := date
	return

METHOD function getIsSertif()	CLASS TEmployee
	return ::FIsSertif

METHOD PROCEDURE setIsSertif( lVal )	CLASS TEmployee

	::FIsSertif := lVal
	return

METHOD function getDsertif()	CLASS TEmployee
	return ::FDsertif

METHOD PROCEDURE setDsertif( date )	CLASS TEmployee

	::FDsertif := date
	return

METHOD function getPRVS()	CLASS TEmployee
	return ::FPRVS

METHOD function getPRVSFormat()	CLASS TEmployee
	return ret_tmp_prvs( ::FPRVS, ::FPRVSNEW )

METHOD PROCEDURE setPRVS( nVal )

	::FPRVSNEW := nVal
	return

METHOD function getPRVSNew()	CLASS TEmployee
	return ::FPRVSNEW

METHOD PROCEDURE setPRVSNew( nVal )	CLASS TEmployee

	::FPRVSNEW := nVal
	return

METHOD function getTabNom()	CLASS TEmployee
	return ::FTabNom
	
METHOD PROCEDURE setTabNom( nVal )	CLASS TEmployee

	::FTabNom := nVal
	return

METHOD function getSvodNom()	CLASS TEmployee
	return ::FSvodNom
	
METHOD PROCEDURE setSvodNom( nVal )	CLASS TEmployee

	::FSvodNom := nVal
	return

METHOD function getKodDLO()	CLASS TEmployee
	return ::FKodDLO
	
METHOD PROCEDURE setKodDLO( nVal )	CLASS TEmployee

	::FKodDLO := nVal
	return

METHOD function getUroven()	CLASS TEmployee
	return ::FUroven

METHOD function getUrovenFormat()	CLASS TEmployee
	return put_val( ::FUroven, 2 )

METHOD PROCEDURE setUroven( nVal )	CLASS TEmployee

	::FUroven := nVal
	return

METHOD function getOtdal()	CLASS TEmployee
	return ::FOtdal

METHOD function getOtdalFormat()	CLASS TEmployee
	return padc( iif( ::FOtdal, '√', '' ), 9 )

METHOD PROCEDURE setOtdal( lVal )	CLASS TEmployee

	::FOtdal := lVal
	return

METHOD function getDBegin()	CLASS TEmployee
	return ::FDBegin

METHOD PROCEDURE setDBegin( date )	CLASS TEmployee
	
	::FDBegin := date
	return

METHOD function getDEnd()	CLASS TEmployee
	return ::FDEnd

METHOD PROCEDURE setDEnd( date )	CLASS TEmployee
	
	::FDEnd := date
	return

METHOD function getSNILS()	CLASS TEmployee
	return ::FSNILS

METHOD function getSNILSformat()	CLASS TEmployee
	return transform( ::FSNILS, picture_pf )

METHOD PROCEDURE setSNILS( cSNILS )	CLASS TEmployee
	
	::FSNILS := cSNILS
	return

METHOD function getProfil()	CLASS TEmployee
	return ::FProfil

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