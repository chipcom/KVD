#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// ����� ��� �ࠢ�筨� ��㯯� ��� ��� ᯮᮡ� ������ = 5 䠩� u_usl_5.dbf
CREATE CLASS TServiceWoDoctor	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Shifr READ getShifr WRITE setShifr						// ��� ��㣨
		PROPERTY Shifr1251 READ getShifr1251
		PROPERTY IsDoctor READ getIsDoctor WRITE setIsDoctor				// �� ������� ��� ��� ?
		PROPERTY IsAssistant READ getIsAssistant WRITE setIsAssistant	// �� ������� ��� ����⥭� ?
		PROPERTY IsSenderDoctor READ getIsSenderDoctor WRITE setIsSenderDoctor
		PROPERTY IsSenderAssistant READ getIsSenderAssistant WRITE setIsSenderAssistant
		
		PROPERTY IsDoctor_F READ getIsDoctorFormat
		PROPERTY IsAssistant_F READ getIsAssistantFormat
		
		
		METHOD New( nID, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FShifr				INIT space( 10 )
		DATA FIsDoctor			INIT .f.
		DATA FIsAssistant		INIT .f.
		DATA FSenderDoctor		INIT .f.
		DATA FSenderAssistant	INIT .f.
		
		METHOD getShifr
		METHOD getShifr1251
		METHOD setShifr( cVal )
		METHOD getIsDoctor
		METHOD setIsDoctor( lVal )
		METHOD getIsAssistant
		METHOD setIsAssistant( lVal )
		METHOD getIsSenderDoctor
		METHOD setIsSenderDoctor( lVal )
		METHOD getIsSenderAssistant
		METHOD setIsSenderAssistant( lVal )

		METHOD getIsDoctorFormat
		METHOD getIsAssistantFormat
ENDCLASS

METHOD FUNCTION getIsDoctorFormat()		CLASS TServiceWoDoctor
	local ret := ''
	if ::FIsDoctor
		ret := '    ���   '
	else
		ret := '    ��    '
	endif
	return ret

METHOD FUNCTION getIsAssistantFormat()	CLASS TServiceWoDoctor
	local ret := ''
	if ::FIsAssistant
		ret := '    ���   '
	else
		ret := '    ��    '
	endif
	return ret

METHOD FUNCTION getShifr()				CLASS TServiceWoDoctor
	return ::FShifr

METHOD FUNCTION getShifr1251()			CLASS TServiceWoDoctor
	return win_OEMToANSI( ::FShifr )

METHOD PROCEDURE setShifr( cVal )	CLASS TServiceWoDoctor
	::FShifr := cVal
	return

METHOD FUNCTION getIsDoctor()				CLASS TServiceWoDoctor
	return ::FIsDoctor

METHOD PROCEDURE setIsDoctor( lVal )	CLASS TServiceWoDoctor
	::FIsDoctor := lVal
	return

METHOD FUNCTION getIsAssistant()				CLASS TServiceWoDoctor
	return ::FIsAssistant

METHOD PROCEDURE setIsAssistant( lVal )	CLASS TServiceWoDoctor
	::FIsAssistant := lVal
	return

METHOD FUNCTION getIsSenderDoctor()				CLASS TServiceWoDoctor
	return ::FSenderDoctor

METHOD PROCEDURE setIsSenderDoctor( lVal )	CLASS TServiceWoDoctor
	::FSenderDoctor := lVal
	return

METHOD FUNCTION getIsSenderAssistant()				CLASS TServiceWoDoctor
	return ::FSenderAssistant

METHOD PROCEDURE setIsSenderAssistant( lVal )	CLASS TServiceWoDoctor
	::FSenderAssistant := lVal
	return

METHOD Clone()		 CLASS TServiceWoDoctor
	local oTarget := nil
	
	oTarget := ::super:Clone()
	return oTarget

METHOD New( nID, cShifr, lDoctor, lAssistant, lDoctorSender, lAssistantSender, lNew, lDeleted )	CLASS TServiceWoDoctor
	
	::super:new( nID, lNew, lDeleted )
	return self