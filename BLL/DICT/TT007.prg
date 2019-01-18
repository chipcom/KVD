#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'
#include 'common.ch'
&& #include 'function.ch'
#include 'chip_mo.ch'

********************************
// класс для справочник T007 _mo_t007
CREATE CLASS T_T007	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY ProfilK READ getProfilK WRITE setProfilK
		PROPERTY Profil READ getProfil WRITE setProfil
		PROPERTY Name READ getName WRITE setName								// наименование
		PROPERTY Name1251 READ getName1251								// наименование 1251
  
		METHOD New( nId, lNew, lDeleted )
		&& METHOD listForJSON()
		&& METHOD forJSON()
	HIDDEN:                                      
		DATA FProfilK		INIT 0
		DATA FProfil		INIT 0
		DATA FName		INIT space( 255 )
		
		METHOD getProfilK
		METHOD setProfilK( param )
		METHOD getProfil
		METHOD setProfil( param )
		METHOD getName
		METHOD setName( param )
		METHOD getName1251
ENDCLASS

METHOD FUNCTION getProfilK()				CLASS T_T007
	return ::FProfilK

METHOD PROCEDURE setProfilK( param )		CLASS T_T007

	::FProfilK := param
	return

METHOD FUNCTION getProfil()				CLASS T_T007
	return ::FProfil

METHOD PROCEDURE setProfil( param )		CLASS T_T007

	::FProfil := param
	return

METHOD FUNCTION getName()					CLASS T_T007
	return ::FName

METHOD PROCEDURE setName( param )			CLASS T_T007

	::FName := param
	return

METHOD FUNCTION getName1251()					CLASS T_T007
	return win_OEMToANSI( ::FName )

METHOD New( nId, lNew, lDeleted )		CLASS T_T007
			
	::super:new( nID, lNew, lDeleted )
	return self