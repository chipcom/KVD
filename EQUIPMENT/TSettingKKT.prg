#include 'hbclass.ch'
#include 'ini.ch'
#include 'property.ch'

CREATE CLASS TSettingKKT

	VISIBLE:
		METHOD New( file )
		METHOD Save()
		
		PROPERTY TypeKKT READ getTypeKKT WRITE setTypeKKT					// тип ККМ
		PROPERTY FRNumber READ getFRNumber WRITE setFRNumber					// заводской номер ККМ
		PROPERTY AdminPass READ getAdminPass WRITE setAdminPass				// пароль администратора ККМ
		PROPERTY NumPOS READ getNumPOS WRITE setNumPOS						// номер кассового аппарата
		PROPERTY NamePOS READ getNamePOS WRITE setNamePOS					// название кассы
		PROPERTY OpenADrawer READ getOpenDrawer WRITE setOpenDrawer			// открыть денежный ящик
		PROPERTY PrintDoctor READ getPrintDoctor WRITE setPrintDoctor		// печать врача в чеке
		PROPERTY PrintPatient READ getPrintPatient WRITE setPrintPatient		// печать пациента в чеке
		PROPERTY ChangeEnable READ getChangeEnable WRITE setChangeEnable		// подсчет сдачи
		PROPERTY ChangePrint READ getChangePrint WRITE setChangePrint		// печать вносимой суммы и сдачи
		PROPERTY PrintCodeUsl READ getPrintCodeUsl WRITE setPrintCodeUsl		// печать шифра услуги
		PROPERTY PrintNameUsl READ getPrintNameUsl WRITE setPrintNameUsl		// печать наименования услуги
		PROPERTY EnableTypePay2 READ getEnableTypePay2 WRITE setEnableTypePay2	// разрешить вид оплаты 2
		PROPERTY NameTypePay2 READ getNameTypePay2 WRITE setNameTypePay2			// название вида оплаты 2
		PROPERTY EnableTypePay3 READ getEnableTypePay3 WRITE setEnableTypePay3	// разрешить вид оплаты 3
		PROPERTY NameTypePay3 READ getNameTypePay3 WRITE setNameTypePay3				// название вида оплаты 3
		PROPERTY EnableTypePay4 READ getEnableTypePay4 WRITE setEnableTypePay4	// разрешить вид оплаты 4
		PROPERTY NameTypePay4 READ getNameTypePay4 WRITE setNameTypePay4				// название вида оплаты 4
		PROPERTY AutoPKO READ getAutoPKO WRITE setAutoPKO					// автоматически формировать ПКО при снятии Z-отчета
		
		PROPERTY LogError READ FLogError WRITE SetLogError
		PROPERTY NameFileLogError READ FNameLogFile WRITE SetLogNameError
		PROPERTY SizeFileLogError READ FSizeLogFile WRITE SetSizeLogError
		
		METHOD OtherTypePay()		INLINE	( ::FEnableTypePay2 .or. ::FEnableTypePay3 .or. ::FEnableTypePay4 )	
	HIDDEN:
		VAR _objINI
		DATA FTypeKKT			INIT 1
		DATA FFRNumber			INIT space( 16 )
		DATA FAdminPass			INIT '30'
		DATA FNumPOS			INIT 1
		DATA FNamePOS			INIT space( 24 )
		DATA FOpenADrawer		INIT .f.
		DATA FPrintDoctor		INIT .f.
		DATA FPrintPatient		INIT .f.
		DATA FChangeEnable		INIT .f.
		DATA FPrintChange		INIT .f.
		DATA FPrintCodeUsl		INIT .f.
		DATA FPrintNameUsl		INIT .f.
		DATA FEnableTypePay2	INIT .f.
		DATA FNameTypePay2		INIT space( 24 )
		DATA FEnableTypePay3	INIT .f.
		DATA FNameTypePay3		INIT space( 24 )
		DATA FEnableTypePay4	INIT .f.
		DATA FNameTypePay4		INIT space( 24 )
		DATA FAutoPKO			INIT .f.
		
		DATA cFabricNumber		AS CHARACTER	INIT space( 16 )		// заводской номер ККМ
		
		DATA FLogError					INIT .f.					// вести лог-файл ошибок кассы или нет
		DATA FNameLogFile				INIT space( 20 )				// имя файла для логирования ошибок ККТ, располагается в каталоге запуска задачи
		DATA FSizeLogFile				INIT 10000000				// размер файла для логирования ошибок ККТ, 10Мб
		METHOD SetLogError( log ) 		INLINE ::FLogError := log
		METHOD SetLogNameError( cFile )	INLINE ::FNameLogFile := alltrim( cFile )
		METHOD SetSizeLogError( size )	INLINE ::FLogError := size

		METHOD getAutoPKO
		METHOD setAutoPKO( param )
		METHOD getNameTypePay4
		METHOD setNameTypePay4( param )
		METHOD getEnableTypePay4
		METHOD setEnableTypePay4( param )
		METHOD getNameTypePay3
		METHOD setNameTypePay3( param )
		METHOD getEnableTypePay3
		METHOD setEnableTypePay3( param )
		METHOD getNameTypePay2
		METHOD setNameTypePay2( param )
		METHOD getEnableTypePay2
		METHOD setEnableTypePay2( param )
		METHOD getPrintNameUsl
		METHOD setPrintNameUsl( param )
		METHOD getPrintCodeUsl
		METHOD setPrintCodeUsl( param )
		METHOD getChangePrint
		METHOD setChangePrint( param )
		METHOD getChangeEnable
		METHOD setChangeEnable( param )
		METHOD getPrintPatient
		METHOD setPrintPatient( param )
		METHOD getPrintDoctor
		METHOD setPrintDoctor( param )
		METHOD getOpenDrawer
		METHOD setOpenDrawer( param )
		METHOD getNumPOS
		METHOD setNumPOS( param )
		METHOD getNamePOS
		METHOD setNamePOS( param )
		METHOD getAdminPass
		METHOD setAdminPass( param )
		METHOD getTypeKKT
		METHOD setTypeKKT( param )
		METHOD getFRNumber
		METHOD setFRNumber( param )

END CLASS

METHOD function getAutoPKO()					CLASS TSettingKKT
	return ::FAutoPKO

METHOD procedure setAutoPKO( param )			CLASS TSettingKKT

	::FAutoPKO := param
	return

METHOD function getNameTypePay4()				CLASS TSettingKKT
	return ::FNameTypePay4

METHOD procedure setNameTypePay4( param )	CLASS TSettingKKT

	::FNameTypePay4 := param
	return

METHOD function getEnableTypePay4()			CLASS TSettingKKT
	return ::FEnableTypePay4

METHOD procedure setEnableTypePay4( param )	CLASS TSettingKKT

	::FEnableTypePay4 := param
	return

METHOD function getNameTypePay3()				CLASS TSettingKKT
	return ::FNameTypePay3

METHOD procedure setNameTypePay3( param )	CLASS TSettingKKT

	::FNameTypePay3 := param
	return

METHOD function getEnableTypePay3()			CLASS TSettingKKT
	return ::FEnableTypePay3

METHOD procedure setEnableTypePay3( param )	CLASS TSettingKKT

	::FEnableTypePay3 := param
	return

METHOD function getNameTypePay2()				CLASS TSettingKKT
	return ::FNameTypePay2

METHOD procedure setNameTypePay2( param )	CLASS TSettingKKT

	::FNameTypePay2 := param
	return

METHOD function getEnableTypePay2()			CLASS TSettingKKT
	return ::FEnableTypePay2

METHOD procedure setEnableTypePay2( param )	CLASS TSettingKKT

	::FEnableTypePay2 := param
	return

METHOD function getPrintNameUsl()				CLASS TSettingKKT
	return ::FPrintNameUsl

METHOD procedure setPrintNameUsl( param )	CLASS TSettingKKT

	::FPrintNameUsl := param
	return

METHOD function getPrintCodeUsl()				CLASS TSettingKKT
	return ::FPrintCodeUsl

METHOD procedure setPrintCodeUsl( param )	CLASS TSettingKKT

	::FPrintCodeUsl := param
	return

METHOD function getChangePrint()				CLASS TSettingKKT
	return ::FPrintChange

METHOD procedure setChangePrint( param )		CLASS TSettingKKT

	::FPrintChange := param
	return

METHOD function getChangeEnable()				CLASS TSettingKKT
	return ::FChangeEnable

METHOD procedure setChangeEnable( param )	CLASS TSettingKKT

	::FChangeEnable := param
	return

METHOD function getPrintPatient()				CLASS TSettingKKT
	return ::FPrintPatient

METHOD procedure setPrintPatient( param )	CLASS TSettingKKT

	::FPrintPatient := param
	return

METHOD function getPrintDoctor()				CLASS TSettingKKT
	return ::FPrintDoctor

METHOD procedure setPrintDoctor( param )		CLASS TSettingKKT

	::FPrintDoctor := param
	return

METHOD function getOpenDrawer()				CLASS TSettingKKT
	return ::FOpenADrawer

METHOD procedure setOpenDrawer( param )		CLASS TSettingKKT

	::FOpenADrawer := param
	return

METHOD function getNamePOS()				CLASS TSettingKKT
	return ::FNamePOS

METHOD procedure setNamePOS( param )		CLASS TSettingKKT

	::FNamePOS := param
	return

METHOD function getNumPOS()				CLASS TSettingKKT
	return ::FNumPOS

METHOD procedure setNumPOS( param )		CLASS TSettingKKT

	::FNumPOS := param
	return

METHOD function getAdminPass()			CLASS TSettingKKT
	return ::FAdminPass

METHOD procedure setAdminPass( param )	CLASS TSettingKKT

	::FAdminPass := param
	return

METHOD function getFRNumber()				CLASS TSettingKKT
	return ::FFRNumber

METHOD procedure setFRNumber( param )	CLASS TSettingKKT

	::FFRNumber := param
	return

METHOD function getTypeKKT()				CLASS TSettingKKT
	return ::FTypeKKT

METHOD procedure setTypeKKT( param )		CLASS TSettingKKT

	::FTypeKKT := param
	return

METHOD New( file )						CLASS TSettingKKT
	local tKKT, admPass, opnDrawer, autoPKO, prtDoctor, prtPatient
	local lChange, lPrintChange, nNumPOS, cNamePOS, lPrintCodUsl, lPrintNameUsl
	local lEnableVid2, lEnableVid3, lEnableVid4, cNameVid2, cNameVid3, cNameVid4
	local cFabricNumber
		 
	INI oIni FILE file
		GET tKKT				SECTION 'KKT' ENTRY 'Type'							OF oIni DEFAULT 1
		GET nNumPOS			SECTION 'KKT' ENTRY 'NumberPOS'						OF oIni DEFAULT 1
		GET cNamePOS			SECTION 'KKT' ENTRY 'NamePOS'						OF oIni DEFAULT 'Название ПОС'
		GET admPass			SECTION 'KKT' ENTRY 'PasswordAdmin'					OF oIni DEFAULT '30'
		GET opnDrawer		SECTION 'KKT' ENTRY 'OpenDrawer'					OF oIni DEFAULT .f.
		GET prtDoctor		SECTION 'KKT' ENTRY 'PrintDoctor'					OF oIni DEFAULT .t.
		GET prtPatient		SECTION 'KKT' ENTRY 'PrintPatient'					OF oIni DEFAULT .t.
		GET lChange			SECTION 'KKT' ENTRY 'ChangeEnable'					OF oIni DEFAULT .t.
		GET lPrintChange		SECTION 'KKT' ENTRY 'PrintChange'					OF oIni DEFAULT .t.
		GET lPrintCodUsl		SECTION 'KKT' ENTRY 'PrintShifrUslugi'				OF oIni DEFAULT .t.
		GET lPrintNameUsl	SECTION 'KKT' ENTRY 'PrintNameUslugi'				OF oIni DEFAULT .t.
		GET lEnableVid2		SECTION 'KKT' ENTRY 'EnablePayment_2'				OF oIni DEFAULT .t.
		GET cNameVid2		SECTION 'KKT' ENTRY 'NamePayment_2'					OF oIni DEFAULT 'КАРТОЙ МИР'
		GET lEnableVid3		SECTION 'KKT' ENTRY 'EnablePayment_3'				OF oIni DEFAULT .f.
		GET cNameVid3		SECTION 'KKT' ENTRY 'NamePayment_3'					OF oIni DEFAULT 'КАРТОЙ VISA'
		GET lEnableVid4		SECTION 'KKT' ENTRY 'EnablePayment_4'				OF oIni DEFAULT .f.
		GET cNameVid4		SECTION 'KKT' ENTRY 'NamePayment_4'					OF oIni DEFAULT 'КАРТОЙ MASTERCARD'
		GET cFabricNumber	SECTION 'KKT' ENTRY 'Fabric number'					OF oIni DEFAULT space( 16 )
		GET autoPKO			SECTION 'KKT' ENTRY 'AutoPKO'						OF oIni DEFAULT .f.
		GET ::FLogError		SECTION 'KKT' ENTRY 'Logging error KKT'				OF oIni DEFAULT .f.
		GET ::FNameLogFile	SECTION 'KKT' ENTRY 'Name log-error file KKT'		OF oIni DEFAULT 'ErrorKKT'
		GET ::FSizeLogFile	SECTION 'KKT' ENTRY 'Max size log-error file KKT'	OF oIni DEFAULT 10000000
	ENDINI
	::_objINI := oIni
	::FTypeKKT := tKKT
	::FNumPOS := nNumPOS
	::FNamePOS := PadR( cNamePOS, 24 )
	::FAdminPass := admPass
	::FOpenADrawer := opnDrawer
	::FPrintDoctor := prtDoctor
	::FPrintPatient := prtPatient
	::FChangeEnable := lChange
	::FPrintChange := lPrintChange
	::FPrintCodeUsl := lPrintCodUsl
	::FPrintNameUsl := lPrintNameUsl
	::FEnableTypePay2 := lEnableVid2
	::FEnableTypePay3 := lEnableVid3
	::FEnableTypePay4 := lEnableVid4
	::FNameTypePay2 := PadR( cNameVid2, 24 )
	::FNameTypePay3 := PadR( cNameVid3, 24 )
	::FNameTypePay4 := PadR( cNameVid4, 24 )
	::FFRNumber := cFabricNumber
	::FAutoPKO := autoPKO
	return self

METHOD Save() CLASS TSettingKKT
		 
	SET SECTION 'KKT' ENTRY 'Type'							TO ::FTypeKKT			OF ::_objINI
	SET SECTION 'KKT' ENTRY 'NumberPOS'						TO ::FNumPOS				OF ::_objINI
	SET SECTION 'KKT' ENTRY 'NamePOS'						TO alltrim( ::FNamePOS )	OF ::_objINI
	SET SECTION 'KKT' ENTRY 'PasswordAdmin'					TO ::FAdminPass			OF ::_objINI
	SET SECTION 'KKT' ENTRY 'OpenDrawer'						TO ::FOpenADrawer		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'PrintDoctor'					TO ::FPrintDoctor		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'PrintPatient'					TO ::FPrintPatient		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'ChangeEnable'					TO ::FChangeEnable		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'PrintChange'					TO ::FPrintChange		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'PrintShifrUslugi'				TO ::FPrintCodeUsl		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'PrintNameUslugi'				TO ::FPrintNameUsl		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'EnablePayment_2'				TO ::FEnableTypePay2		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'NamePayment_2'					TO ::FNameTypePay2		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'EnablePayment_3'				TO ::FEnableTypePay3		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'NamePayment_3'					TO ::FNameTypePay3		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'EnablePayment_4'				TO ::FEnableTypePay4		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'NamePayment_4'					TO ::FNameTypePay4		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'Fabric number'					TO ::FFRNumber			OF ::_objINI
	SET SECTION 'KKT' ENTRY 'AutoPKO'						TO ::FAutoPKO			OF ::_objINI
	SET SECTION 'KKT' ENTRY 'Logging error KKT'				TO ::FLogError			OF ::_objINI
	SET SECTION 'KKT' ENTRY 'Name log-error file KKT'		TO ::FNameLogFile		OF ::_objINI
	SET SECTION 'KKT' ENTRY 'Max size log-error file KKT'	TO ::FSizeLogFile		OF ::_objINI
	return nil