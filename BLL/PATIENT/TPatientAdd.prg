#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'chip_mo.ch'
#include 'edit_spr.ch'

CREATE CLASS TPatientAdd	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY CodeTF AS NUMERIC READ getCodeTF WRITE setCodeTF // код по кодировке ТФОМС
		PROPERTY SinglePolicyNumber AS STRING READ getSinglePolicyNumber WRITE setSinglePolicyNumber // ЕНП - единый номер полиса ОМС
		PROPERTY AmbulatoryCard AS STRING READ getAmbulatoryCard WRITE setAmbulatoryCard // собственный номер амбулаторной карты (КМИС/ЛИС)
		PROPERTY AttachmentStatus AS NUMERIC READ getAttachmentStatus WRITE setAttachmentStatus // тип/статус прикрепления 1-из WQ,2-из реестра СП и ТК,3-из файла прикрепления,4-открепление,5-сверка
		PROPERTY MOCodeAttachment AS STRING READ getMOCodeAttachment WRITE setMOCodeAttachment // код МО прикрепления
		PROPERTY DateAttachment AS DATE READ getDateAttachment WRITE setDateAttachment // дата прикрепления
		PROPERTY DoctorSNILS AS STRING READ getDoctorSNILS WRITE setDoctorSNILS // СНИЛС участкового врача
		PROPERTY PC1 AS STRING INDEX 1 READ getPC WRITE setPC // при добавлении:kod_polzovat+c4sys_date+hour_min(seconds())
		PROPERTY PC2 AS STRING INDEX 2 READ getPC WRITE setPC // 0-нет,1-умер по результатам сверки
		PROPERTY PC3 AS STRING INDEX 3 READ getPC WRITE setPC //
		PROPERTY PC4 AS STRING INDEX 4 READ getPC WRITE setPC // дата прикрепления к МО
		PROPERTY PC5 AS STRING INDEX 5 READ getPC WRITE setPC //
		PROPERTY PN1 AS NUMERIC INDEX 1 READ getPN WRITE setPN //
		PROPERTY PN2 AS NUMERIC INDEX 2 READ getPN WRITE setPN //
		PROPERTY PN3 AS NUMERIC INDEX 3 READ getPN WRITE setPN  //
	
		ACCESS setID
		ASSIGN setID( param )	INLINE ::setID( param )

		METHOD New( nID, lNew, lDeleted )
		METHOD AttachmentInformation( param )
	HIDDEN:
		DATA FCodeTF INIT 0
		DATA FSinglePolicyNumber INIT space( 20 )
		DATA FAmbulatoryCard INIT space( 10 )
		DATA FAttachmentStatus INIT 0
		DATA FMOCodeAttachment INIT space( 6 )
		DATA FDateAttachment INIT ctod( '' )
		DATA FDoctorSNILS INIT space( 11 )
		DATA FPC1 INIT space( 10 )
		DATA FPC2 INIT space( 10 )
		DATA FPC3 INIT space( 10 )
		DATA FPC4 INIT space( 10 )
		DATA FPC5 INIT space( 10 )
		DATA FPN1 INIT 0
		DATA FPN2 INIT 0
		DATA FPN3 INIT 0

		METHOD getCodeTF							INLINE ::FCodeTF
		METHOD setCodeTF( param )
		METHOD getSinglePolicyNumber				INLINE ::FSinglePolicyNumber
		METHOD setSinglePolicyNumber( param )
		METHOD getAmbulatoryCard					INLINE ::FAmbulatoryCard
		METHOD setAmbulatoryCard( param )
		METHOD getAttachmentStatus				INLINE ::FAttachmentStatus
		METHOD setAttachmentStatus( param )
		METHOD getMOCodeAttachment				INLINE ::FMOCodeAttachment
		METHOD setMOCodeAttachment( param )
		METHOD getDateAttachment					INLINE ::FDateAttachment
		METHOD setDateAttachment( param )
		METHOD getDoctorSNILS						INLINE ::FDoctorSNILS
		METHOD setDoctorSNILS( param )
		METHOD getPC( nIndex )
		METHOD setPC( nIndex, param )
		METHOD getPN( nIndex )
		METHOD setPN( nIndex, param )
ENDCLASS

// для оповещения классом TPatient
METHOD procedure setID( param )

	if isnumber( param )
		::FID := param
	endif
	return

//METHOD function getCodeTF()		CLASS TPatientAdd
//	return ::FCodeTF

METHOD procedure setCodeTF( param )		CLASS TPatientAdd
	
	if isnumber( param )
		::FCodeTF := param
	endif
	return

//METHOD function getSinglePolicyNumber()		CLASS TPatientAdd
//	return ::FSinglePolicyNumber

METHOD procedure setSinglePolicyNumber( param )		CLASS TPatientAdd
	
	if ischaracter( param )
		::FSinglePolicyNumber := param
	endif
	return

//METHOD function getAmbulatoryCard()		CLASS TPatientAdd
//	return ::FAmbulatoryCard

METHOD procedure setAmbulatoryCard( param )		CLASS TPatientAdd
	
	if ischaracter( param )
		::FAmbulatoryCard := param
	endif
	return

//METHOD function getAttachmentStatus()		CLASS TPatientAdd
//	return ::FAttachmentStatus

METHOD procedure setAttachmentStatus( param )		CLASS TPatientAdd
	
	if isnumber( param )
		::FAttachmentStatus := param
	endif
	return

//METHOD function getMOCodeAttachment()		CLASS TPatientAdd
//	return ::FMOCodeAttachment

METHOD procedure setMOCodeAttachment( param )		CLASS TPatientAdd
	
	if ischaracter( param )
		::FMOCodeAttachment := param
	endif
	return

//METHOD function getDateAttachment()		CLASS TPatientAdd
//	return ::FDateAttachment

METHOD procedure setDateAttachment( param )		CLASS TPatientAdd
	
	if isdate( param )
		::FDateAttachment := param
	endif
	return

//METHOD function getDoctorSNILS()		CLASS TPatientAdd
//	return ::FDoctorSNILS

METHOD procedure setDoctorSNILS( param )		CLASS TPatientAdd
	
	if ischaracter( param )
		::FDoctorSNILS := param
	endif
	return

METHOD function getPC( nIndex )		CLASS TPatientAdd
	local ret := ''
	
	switch nIndex
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
	endswitch
	return ret

METHOD procedure setPC( nIndex, param )			CLASS TPatientAdd

	if ischaracter( param )
		switch nIndex
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
		endswitch
	endif
	return

METHOD function getPN( nIndex )		CLASS TPatientAdd
	local ret := 0
	
	switch nIndex
		case 1
			ret := ::FPN1
			exit
		case 2
			ret := ::FPN2
			exit
		case 3
			ret := ::FPN3
			exit
	endswitch
	return ret

METHOD procedure setPN( nIndex, param )			CLASS TPatientAdd

	if isnumber( param )
		switch nIndex
			case 1
				::FPN1 := param
				exit
			case 2
				::FPN2 := param
				exit
			case 3
				::FPN3 := param
				exit
		endswitch
	endif
	return

METHOD AttachmentInformation( param )			CLASS TPatientAdd
	local ret := '', s

	if param[ _MO_IS_UCH ]
		if left( ::FPC2, 1 ) == '1'
				ret := 'По информации из ТФОМС пациент У_М_Е_Р'
		elseif ::FMOCodeAttachment == param[ _MO_KOD_TFOMS ]
			ret := 'Прикреплён '
			if ! empty( ::FPC4 )
				ret += 'с ' + alltrim( ::FPC4 ) + ' '
			elseif ! empty( ::FDateAttachment )
				ret += 'с ' + date_8( ::FDateAttachment ) + ' '
			endif
			ret += 'к нашей МО'
		else
			s := alltrim( inieditspr( A__MENUVERT, glob_arr_mo, ::FMOCodeAttachment ) )
			if empty( s )
				ret := 'Прикрепление --- неизвестно ---'
			else
				ret := ''
				if ! empty( ::FPC4 )
					ret += 'с ' + alltrim( ::FPC4) + ' '
				elseif ! empty( ::FDateAttachment )
					ret += 'с ' + date_8( ::FDateAttachment ) + ' '
				endif
				ret += 'прикреплён к ' + s
			endif
		endif
	endif
	return ret

METHOD New( nID, lNew, lDeleted )		CLASS TPatientAdd

	::super:new( nID, lNew, lDeleted )
	return self