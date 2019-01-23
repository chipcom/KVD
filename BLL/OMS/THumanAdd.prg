#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS THumanAdd	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY DiagnosisComplication1 AS STRING INDEX 1 READ getDiagnosis WRITE setDiagnosis	// шифр 1-ого диагноза осложнения заболевания
		PROPERTY DiagnosisComplication2 AS STRING INDEX 2 READ getDiagnosis WRITE setDiagnosis	// шифр 2-ого диагноза осложнения заболевания
		PROPERTY DiagnosisComplication3 AS STRING INDEX 3 READ getDiagnosis WRITE setDiagnosis	// шифр 3-ого диагноза осложнения заболевания
		PROPERTY DateReferral AS DATE READ getDateReferral WRITE setDateReferral		// Дата направления, выданного МО, указанной в NPR_MO
		PROPERTY ProfilK AS NUMERIC READ getProfilK WRITE setProfilK		// профиль койки по справочнику V020 (стационар и дневной стационар)
		PROPERTY VMP AS NUMERIC READ getVMP WRITE setVMP			// 0-нет,1-да ВМП
		PROPERTY VidVMP AS STRING READ getVidVMP WRITE setVidVMP	// вид ВМП по справочнику V018
		PROPERTY MethodVMP AS NUMERIC READ getMethodVMP WRITE setMethodVMP	// метод ВМП по справочнику V019
		PROPERTY NumberTalon AS STRING READ getNumberTalon WRITE setNumberTalon	// Номер талона на ВМП
		PROPERTY DateTalon AS DATE READ getDateTalon WRITE setDateTalon	// Дата выдачи талона на ВМП
		PROPERTY DatePlanned AS DATE READ getDatePlanned WRITE setDatePlanned	// Дата планируемой госпитализации в соответствии с талоном на ВМП
		PROPERTY SignReceipt AS NUMERIC READ getSignReceipt WRITE setSignReceipt	// Признак поступления/перевода 1-4
		PROPERTY WeightPrematureBaby AS NUMERIC INDEX 1 READ getWeight WRITE setWeight	// вес недоношенного ребёнка (лечится ребёнок)
		PROPERTY WeightPrematureBaby1 AS NUMERIC INDEX 2 READ getWeight WRITE setWeight	// вес 1-го недоношенного ребёнка (лечится мать)
		PROPERTY WeightPrematureBaby2 AS NUMERIC INDEX 3 READ getWeight WRITE setWeight	// вес 2-го недоношенного ребёнка (лечится мать)
		PROPERTY WeightPrematureBaby3 AS NUMERIC INDEX 4 READ getWeight WRITE setWeight	// вес 3-го недоношенного ребёнка (лечится мать)
		
		PROPERTY PC1 AS STRING INDEX 1 READ getPC WRITE setPC	// КСЛП (в 2017 - в первом знаке 1-3 - кол-во стентов в коронарных сосудах)
		PROPERTY PC2 AS STRING INDEX 2 READ getPC WRITE setPC	// КИРО
		PROPERTY PC3 AS STRING INDEX 3 READ getPC WRITE setPC	// дополнительный критерий
		PROPERTY PC4 AS STRING INDEX 4 READ getPC WRITE setPC
		PROPERTY PC5 AS STRING INDEX 5 READ getPC WRITE setPC
		PROPERTY PC6 AS STRING INDEX 6 READ getPC WRITE setPC
		PROPERTY PN1 AS NUMERIC INDEX 1 READ getPN WRITE setPN	// для реабилитации пациентов после кохлеарной имплантации
		PROPERTY PN2 AS NUMERIC INDEX 2 READ getPN WRITE setPN	// для абортов
		PROPERTY PN3 AS NUMERIC INDEX 3 READ getPN WRITE setPN	// код согласования с программами SDS/ЛИС
		PROPERTY PN3 AS NUMERIC INDEX 4 READ getPN WRITE setPN
		PROPERTY PN3 AS NUMERIC INDEX 5 READ getPN WRITE setPN
		PROPERTY PN3 AS NUMERIC INDEX 6 READ getPN WRITE setPN

		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )

		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FDiagnosisComplication1	INIT space( 6 )
		DATA FDiagnosisComplication2	INIT space( 6 )
		DATA FDiagnosisComplication3	INIT space( 6 )
		DATA FDateReferral INIT ctod( '' )
		DATA FProfilK INIT 0
		DATA FVMP INIT 0
		DATA FVidVMP INIT space( 12 )
		DATA FMethodVMP INIT 0
		DATA FNumberTalon INIT space( 20 )
		DATA FDateTalon INIT ctod( '' )
		DATA FDatePlanned INIT ctod( '' )
		DATA FSignReceipt INIT 0
		DATA FWeightPrematureBaby INIT 0
		DATA FWeightPrematureBaby1 INIT 0
		DATA FWeightPrematureBaby2 INIT 0
		DATA FWeightPrematureBaby3 INIT 0
		
		DATA FPC1	INIT space( 20 )
		DATA FPC2	INIT space( 10 )
		DATA FPC3	INIT space( 10 )
		DATA FPC4	INIT space( 10 )
		DATA FPC5	INIT space( 10 )
		DATA FPC6	INIT space( 10 )
		DATA FPN1	INIT 0
		DATA FPN2	INIT 0
		DATA FPN3	INIT 0
		DATA FPN4	INIT 0
		DATA FPN5	INIT 0
		DATA FPN6	INIT 0

		METHOD getSignReceipt			INLINE ::FSignReceipt
		METHOD setSignReceipt( param )
		METHOD getDatePlanned			INLINE ::FDatePlanned
		METHOD setDatePlanned( param )
		METHOD getDateTalon				INLINE ::FDateTalon
		METHOD setDateTalon( param )
		METHOD getNumberTalon			INLINE ::FNumberTalon
		METHOD setNumberTalon( param )
		METHOD getMethodVMP				INLINE ::FMethodVMP
		METHOD setMethodVMP( param )
		METHOD getVidVMP					INLINE ::FVidVMP
		METHOD setVidVMP( param )
		METHOD getDateReferral			INLINE ::FDateReferral
		METHOD setDateReferral( param )
		METHOD getProfilK				INLINE ::FProfilK
		METHOD setProfilK( param )
		METHOD getVMP					INLINE ::FVMP
		METHOD setVMP( param )
		METHOD getDiagnosis( index )
		METHOD setDiagnosis( index, param )
		METHOD getWeight( index )
		METHOD setWeight( index, param )
		METHOD getPC( index )
		METHOD setPC( index, param )
		METHOD getPN( index )
		METHOD setPN( index, param )
ENDCLASS

// для оповещения классом THuman
METHOD procedure setID( param )				CLASS THumanAdd

	if isnumber( param )
		::FID := param
	endif
	return

METHOD procedure setSignReceipt( param )		CLASS THumanAdd

	if isnumber( param )
		::FSignReceipt := param
	endif
	return

METHOD procedure setDatePlanned( param )		CLASS THumanAdd

	if isdate( param )
		::FDatePlanned := param
	endif
	return

METHOD procedure setDateTalon( param )		CLASS THumanAdd

	if isdate( param )
		::FDateTalon := param
	endif
	return

METHOD procedure setNumberTalon( param )		CLASS THumanAdd

	if ischaracter( param )
		::FNumberTalon := param
	endif
	return

METHOD procedure setMethodVMP( param )		CLASS THumanAdd

	if isnumber( param )
		::FMethodVMP := param
	endif
	return

METHOD procedure setVidVMP( param )		CLASS THumanAdd

	if ischaracter( param )
		::FVidVMP := param
	endif
	return

METHOD procedure setVMP( param )		CLASS THumanAdd

	if isnumber( param )
		::FVMP := param
	endif
	return

METHOD procedure setDateReferral( param )		CLASS THumanAdd

	if isdate( param )
		::FDateReferral := param
	endif
	return

METHOD function getWeight( index )				CLASS THumanAdd
	local ret
	
	switch index
		case 1
			ret := ::FWeightPrematureBaby
			exit
		case 2
			ret := ::FWeightPrematureBaby1
			exit
		case 3
			ret := ::FWeightPrematureBaby2
			exit
		case 4
			ret := ::FWeightPrematureBaby3
			exit
	endswitch
	return ret

METHOD procedure setWeight( index, param )		CLASS THumanAdd

	switch index
		case 1
			::FWeightPrematureBaby := param
			exit
		case 2
			::FWeightPrematureBaby1 := param
			exit
		case 3
			::FWeightPrematureBaby2 := param
			exit
		case 4
			::FWeightPrematureBaby3 := param
			exit
	endswitch
	return

METHOD function getDiagnosis( index )				CLASS THumanAdd
	local ret
	
	switch index
		case 1
			ret := ::FDiagnosisComplication1
			exit
		case 2
			ret := ::FDiagnosisComplication2
			exit
		case 3
			ret := ::FDiagnosisComplication3
			exit
	endswitch
	return ret

METHOD procedure setDiagnosis( index, param )		CLASS THumanAdd

	switch index
		case 1
			::FDiagnosisComplication1 := param
			exit
		case 2
			::FDiagnosisComplication2 := param
			exit
		case 3
			::FDiagnosisComplication3 := param
			exit
	endswitch
	return

METHOD procedure setProfilK( param )		CLASS THumanAdd

	if isnumber( param )
		::FProfilK := param
	endif
	return

METHOD function getPC( index )				CLASS THumanAdd
	local ret
	
	switch index
		case 1
			ret := ::FPC1
			exit
		case 2
			ret := ::FPC2
			exit
		case 3
			ret := ::FPC3
			exit
		case 4
			ret := ::FPC4
			exit
		case 5
			ret := ::FPC5
			exit
		case 6
			ret := ::FPC6
			exit
	endswitch
	return ret

METHOD procedure setPC( index, param )		CLASS THumanAdd

	if ischaracter( param )
		switch index
			case 1
				::FPC1 := param
				exit
			case 2
				::FPC2 := param
				exit
			case 3
				::FPC3 := param
				exit
			case 4
				::FPC4 := param
				exit
			case 5
				::FPC5 := param
				exit
			case 6
				::FPC6 := param
				exit
		endswitch
	endif
	return

METHOD function getPN( index )				CLASS THumanAdd
	local ret
	
	switch index
		case 1
			ret := ::FPN1
			exit
		case 2
			ret := ::FPN2
			exit
		case 3
			ret := ::FPN3
			exit
		case 4
			ret := ::FPN4
			exit
		case 5
			ret := ::FPN5
			exit
		case 6
			ret := ::FPN6
			exit
	endswitch
	return ret

METHOD procedure setPN( index, param )		CLASS THumanAdd

	switch index
		case 1
			::FPN1 := param
			exit
		case 2
			::FPN2 := param
			exit
		case 3
			::FPN3 := param
			exit
		case 4
			::FPN4 := param
			exit
		case 5
			::FPN5 := param
			exit
		case 6
			::FPN6 := param
			exit
	endswitch
	return

METHOD New( nID, lNew, lDeleted )		CLASS THumanAdd

	::super:new( nID, lNew, lDeleted )
	return self