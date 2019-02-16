#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

// класс для плановой трудоемкости по персоналу
CREATE CLASS TPlannedMonthlyStaff	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY IDPerson READ getIDPerson WRITE setIDPerson
		PROPERTY Year READ getYear WRITE setYear
		PROPERTY Month READ getMonth WRITE setMonth
		PROPERTY PlannedMonthly READ getPlannedMonthly WRITE setPlannedMonthly
		PROPERTY FIO READ getFIO WRITE setFIO
		PROPERTY FIO1251 READ getFIO1251
		PROPERTY TabNom READ getTabNom WRITE setTabNom

		METHOD New( nId, nIdPerson, nYear, nMonth, nPlannedMonthly, cEmployee, nTabNom, lNew, lDeleted )
	HIDDEN:
		DATA FIDPerson			INIT 0
		DATA FYear				INIT 0
		DATA FMonth				INIT 0
		DATA FPlannedMonthly	INIT 0
		DATA FFIO				INIT ''
		DATA FTabNom			INIT 0

		METHOD getIDPerson				INLINE ::FIDPerson
		METHOD setIDPerson( nVal )
		METHOD getYear					INLINE ::FYear
		METHOD setYear( nVal )
		METHOD getMonth					INLINE ::FMonth
		METHOD setMonth( nVal )
		METHOD getPlannedMonthly			INLINE ::FPlannedMonthly
		METHOD setPlannedMonthly( nVal )
		METHOD getFIO					INLINE ::FFIO
		METHOD setFIO( cVal )
		METHOD getFIO1251				INLINE win_OEMToANSI( ::FFIO )
		METHOD getTabNom					INLINE ::FTabNom
		METHOD setTabNom( nVal )
ENDCLASS

METHOD PROCEDURE setIDPerson( nVal )	CLASS TPlannedMonthlyStaff

	::FIDPerson := nVal
	return

METHOD PROCEDURE setYear( nVal )	CLASS TPlannedMonthlyStaff

	::FYear := nVal
	return

METHOD PROCEDURE setMonth( nVal )	CLASS TPlannedMonthlyStaff

	::FMonth := nVal
	return

METHOD PROCEDURE setPlannedMonthly( nVal )	CLASS TPlannedMonthlyStaff

	::FPlannedMonthly := nVal
	return

METHOD PROCEDURE setTabNom( nVal )	CLASS TPlannedMonthlyStaff

	::FTabNom := nVal
	return

METHOD PROCEDURE setFIO( cVal )	CLASS TPlannedMonthlyStaff

	::FFIO := cVal
	return

METHOD New( nId, nIdPerson, nYear, nMonth, nPlannedMonthly, cEmployee, nTabNom, lNew, lDeleted )  CLASS TPlannedMonthlyStaff

	::super:new( nID, lNew, lDeleted )
			  
	::FIDPerson			:= HB_DefaultValue( nIdPerson, 0 )
	::FYear				:= HB_DefaultValue( nYear, 0 )
	::FMonth			:= HB_DefaultValue( nMonth, 0 )
	::FPlannedMonthly	:= HB_DefaultValue( nPlannedMonthly, 0 )
	::FFIO				:= HB_DefaultValue( cEmployee, '' )
	::FTabNom			:= HB_DefaultValue( nTabNom, 0 )
	return self