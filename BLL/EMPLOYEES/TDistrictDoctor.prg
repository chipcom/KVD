#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'function.ch'
#include 'property.ch'

********************************
// класс для справочник привязка участковых врачей к участкам файл mo_uchvr.dbf
CREATE CLASS TDistrictDoctor	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY District READ getDistrict WRITE setDistrict						// номер участка
		PROPERTY IS READ getIS WRITE setIS										//
		PROPERTY IDDoctor READ getIDDoctor WRITE setIDDoctor						// табельный номер врача
		PROPERTY IDDoctorAdult READ getIDDoctorAdult WRITE setIDDoctorAdult		// табельный номер взрослого врача
		PROPERTY IDDoctorChild READ getIDDoctorChild WRITE setIDDoctorChild		// табельный номер детского врача
	
		METHOD New( nID, nDistrict, nIs, nIdDoctor, nIdDoctorAdult, nIdDoctorChild, lNew, lDeleted )
		METHOD View()
	HIDDEN:
		DATA FDistrict		INIT 0
		DATA FIS			INIT 0
		DATA FIDDoctor		INIT 0
		DATA FIDDoctorAdult	INIT 0
		DATA FIDDoctorChild	INIT 0

		METHOD getDistrict
		METHOD setDistrict( nVal )
		METHOD getIS
		METHOD setIS( nVal )
		METHOD getIDDoctor
		METHOD setIDDoctor( nVal )
		METHOD getIDDoctorAdult
		METHOD setIDDoctorAdult( nVal )
		METHOD getIDDoctorChild
		METHOD setIDDoctorChild( nVal )
ENDCLASS

METHOD FUNCTION getDistrict()	CLASS TDistrictDoctor
	return ::FDistrict

METHOD PROCEDURE setDistrict( nVal )	CLASS TDistrictDoctor

	::FDistrict := nVal
	return

METHOD FUNCTION getIS()	CLASS TDistrictDoctor
	return ::FIS

METHOD PROCEDURE setIS( nVal )	CLASS TDistrictDoctor

	::FIS := nVal
	return

METHOD FUNCTION getIDDoctor()	CLASS TDistrictDoctor
	return ::FIDDoctor

METHOD PROCEDURE setIDDoctor( nVal )	CLASS TDistrictDoctor

	::FIDDoctor := nVal
	return

METHOD FUNCTION getIDDoctorAdult()	CLASS TDistrictDoctor
	return ::FIDDoctorAdult

METHOD PROCEDURE setIDDoctorAdult( nVal )	CLASS TDistrictDoctor

	::FIDDoctorAdult := nVal
	return

METHOD FUNCTION getIDDoctorChild()	CLASS TDistrictDoctor
	return ::FIDDoctorChild

METHOD PROCEDURE setIDDoctorChild( nVal )	CLASS TDistrictDoctor

	::FIDDoctorChild := nVal
	return

METHOD New( nID, nDistrict, nIs, nIdDoctor, nIdDoctorAdult, nIdDoctorChild, lNew, lDeleted )  CLASS TDistrictDoctor

	&& HB_Default( @nDistrict, 0 ) 
	&& HB_Default( @nIs, 0 )
	&& HB_Default( @nIdDoctor, 0 ) 
	&& HB_Default( @nIdDoctorAdult, 0 )
	&& HB_Default( @nIdDoctorChild, 0 ) 

	::super:new( nID, lNew, lDeleted )
	
	::FDistrict			:= HB_DefaultValue( nDistrict, 0 )
	::FIS				:= HB_DefaultValue( nIs, 0 )
	::FIDDoctor	 		:= HB_DefaultValue( nIdDoctor, 0 )
	::FIDDoctorAdult	:= HB_DefaultValue( nIdDoctorAdult, 0 )
	::FIDDoctorChild	:= HB_DefaultValue( nIdDoctorChild, 0 )
	return self

METHOD View()    CLASS TDistrictDoctor
	local oEmployee := nil
	local ret := ''
	local sNotFound := 'врач не найден'
	
	if ::FIDDoctor > 0
		if ( oEmployee := TEmployeeDB():getByID( ::FIDDoctor ) ) != nil
			ret := alltrim( oEmployee:FIO ) + ' (' + left( TEmployee():aMenuCategory[ oEmployee:Category, 1], 2 ) + '.)'
			ret += ' [' + lstr( oEmployee:TabNom ) + ']'
		else
			ret := sNotFound
		endif
	elseif ::FIDDoctorAdult > 0
		if ::FIDDoctorChild > 0
			if ( oEmployee := TEmployeeDB():getByID( ::FIDDoctorAdult ) ) != nil
				ret := 'взр.: ' + alltrim( oEmployee:ShortFIO ) + ' (' + left( TEmployee():aMenuCategory[ oEmployee:Category, 1], 2 ) + '.)'
				ret += ' [' + lstr( oEmployee:TabNom ) + ']'
			else
				ret := sNotFound
			endif
			if ( oEmployee := TEmployeeDB():getByID( ::FIDDoctorChild ) ) != nil
				ret +=  ', дети: ' + alltrim( oEmployee:ShortFIO ) + ' (' + left( TEmployeeDB():aMenuCategory[ oEmployee:Category, 1], 2 ) + '.)'
				ret += ' [' + lstr( oEmployee:TabNom ) + ']'
			else
				ret += sNotFound
			endif
		else
			if ( oEmployee := TEmployeeDB():getByID( ::FIDDoctorAdult ) ) != nil
				ret := alltrim( oEmployee:FIO ) + ' (' + left( TEmployee():aMenuCategory[ oEmployee:Category, 1], 2 ) + '.)'
				ret += ' [' + lstr( oEmployee:TabNom ) + ']'
			else
				ret := sNotFound
			endif
		endif
	elseif ::FIDDoctorChild > 0
		if ( oEmployee := TEmployeeDB():getByID( ::FIDDoctorChild ) ) != nil
			ret =  alltrim( oEmployee:FIO ) + ' (' + left( TEmployee():aMenuCategory[ oEmployee:Category, 1], 2 ) + '.)'
			ret += ' [' + lstr( oEmployee:TabNom ) + ']'
		else
			ret := sNotFound
		endif
	endif
	return ret