#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TDisability	INHERIT	TBaseObjectBLL
	VISIBLE:
		CLASSDATA	aMenuType	AS ARRAY	INIT { { '���', 0 }, ;
												{ '1 ��㯯�', 1 }, ;
												{ '2 ��㯯�', 2 }, ;
												{ '3 ��㯯�', 3 }, ;
												{ '���-��������', 4 } }
		CLASSDATA	aMenuReason	AS ARRAY INIT { { '��饥 �����������', 1 }, ; // ��稭� �����������
					{ '��㤮��� 㢥��', 2 }, ;
					{ '����ᨮ���쭮� �����������', 3 }, ;
					{ '������������ � ����⢠', 4 }, ;
					{ '������������ � ����⢠ �᫥��⢨� ࠭���� (����� ����⢨� � ��ਮ� ���)', 5 }, ;
					{ '������� �ࠢ��', 6 }, ;
					{ '����������� ����祭� � ��ਮ� ������� �㦡�', 7 }, ;
					{ '����������� ࠤ��樮���� (�� �ᯮ������ ������� �㦡�) �� ��୮���᪮� ���', 8 }, ;
					{ '����������� �易�� � ������䮩 �� ��୮���᪮� ���', 9 }, ;
					{ '����������� (��� ��易����� �ᯮ������ ������� �㦡�) �� ��୮���᪮� ���', 10 }, ;
					{ '����������� �易�� � ���ਥ� �� �� "���"', 11 }, ;
					{ '����������� (��� ��易����� �ᯮ������ ������� �㦡�) �� �� "���"', 12 }, ;
					{ '����������� �易�� � ��᫥��⢨ﬨ ࠤ��樮���� �������⢨�', 13 }, ;
					{ '����������� ࠤ��樮���� (�� �ᯮ������ ������� �㦡�) ���ࠧ�.�ᮡ��� �᪠', 14 }, ;
					{ '����������� (࠭����) �� ���㦨������� �/� �� ���� � ��, ������ �� �㡥���', 15 }, ;
					{ '��� ��稭�, ��⠭������� ��������⥫��⢮� ��', 16 } }

		PROPERTY IDPatient AS NUMERIC READ getIDPatient WRITE setIDPatient	// �����䨪�� ��樥�� (����� ����� �� �� kartotek)
		PROPERTY Invalid AS NUMERIC READ getInvalid WRITE setInvalid			// ��㯯� ����������� �� ����� TPatientExt
		PROPERTY DegreeOfDisability AS NUMERIC READ getDegreeOfDisability WRITE setDegreeOfDisability	// �⥯��� ����������� �� ����� TPatientExt
		PROPERTY Date AS DATE READ getDate WRITE setDate						// ��� ��ࢨ筮�� ��⠭������� �����������
		PROPERTY Reason AS NUMERIC READ getReason WRITE setReason			// ��稭� ��ࢨ筮�� ��⠭������� �����������
		PROPERTY Diagnosis AS STRING READ getDiagnosis WRITE setDiagnosis	// 
		PROPERTY AsString READ GetAsString( ... )						// �।�⠢����� ���㬥�� �� ��⠭�������� �ଠ⭮� ��ப�
		PROPERTY Format READ FFormat WRITE SetFormat						// �ଠ⭠� ��ப� �뢮�� �।�⠢����� ���㬥��
		
		&& PROPERTY Patient AS OBJECT WRITE setPatient
		METHOD setPatient( param )	INLINE ( ::FPatient := if( isobject( param ) .and. param:classname == upper( 'TPatient' ), param, nil ) )
	
		METHOD New( nID, lNew, lDeleted )
	HIDDEN:
		DATA FFormat INIT 'GROUP DEGREE DATE'
		DATA FIDPatient INIT 0
		DATA FInvalid INIT 0
		DATA FDegreeOfDisability INIT 0
		DATA FDate INIT ctod( '' )
		DATA FReason INIT 0
		DATA FDiagnosis INIT space( 5 )
		DATA FPatient INIT nil

		METHOD getIDPatient
		METHOD setIDPatient( param )
		METHOD getInvalid
		METHOD setInvalid( param )
		METHOD getDegreeOfDisability
		METHOD setDegreeOfDisability( param )
		METHOD getDate
		METHOD setDate( param )
		METHOD getReason
		METHOD setReason( param )
		METHOD getDiagnosis
		METHOD setDiagnosis( param )
		METHOD GetAsString( format )
		METHOD SetFormat( format ) INLINE ::FFormat := format
		&& METHOD setPatient( param )
ENDCLASS

&& METHOD procedure setPatient( param )		CLASS TDisability

	&& if isobject( param ) .and. param:classname == upper( 'TPatient' )
		&& ::FPatient := param
	&& endif
	&& return

METHOD function getIDPatient()		CLASS TDisability
	return ::FIDPatient

METHOD procedure setIDPatient( param )		CLASS TDisability
	
	if isnumber( param )
		::FIDPatient := param
	endif
	return

METHOD function getInvalid()		CLASS TDisability
	return ::FInvalid

METHOD procedure setInvalid( param )		CLASS TDisability
	
	if isnumber( param )
		::FInvalid := param
		// ������⨬ ����� TPatient
		if __objHasMsgAssigned( ::FPatient:ExtendInfo, 'setInvalid' )
			__objSendMsg( ::FPatient:ExtendInfo, 'setInvalid', param )
		endif
	endif
	return

METHOD function getDegreeOfDisability()		CLASS TDisability
	return ::FDegreeOfDisability

METHOD procedure setDegreeOfDisability( param )		CLASS TDisability
	
	if isnumber( param )
		::FDegreeOfDisability := param
	endif
	return

METHOD function getDate()		CLASS TDisability
	return ::FDate

METHOD procedure setDate( param )		CLASS TDisability
	
	if isdate( param )
		::FDate := param
	endif
	return

METHOD function getReason()		CLASS TDisability
	return ::FReason

METHOD procedure setReason( param )		CLASS TDisability
	
	if isnumber( param )
		::FReason := param
	endif
	return

METHOD function getDiagnosis()		CLASS TDisability
	return ::FDiagnosis

METHOD procedure setDiagnosis( param )		CLASS TDisability
	
	if ischaracter( param )
		::FDiagnosis := param
	endif
	return

METHOD New( nID, lNew, lDeleted )		CLASS TDisability

	::super:new( nID, lNew, lDeleted )
	return self

METHOD FUNCTION GetAsString( format ) CLASS TDisability
	local asString := ''
	local numToken
	local i
	local j := 0
	local s
	local tk
	local tkSep
	local itm
	local len
	local oPublisher := nil
	local ch
	
	if empty( format )
		format := ::FFormat
	endif
	&& numToken := NumToken( format, ' ' )
	numToken := NumToken( format )
	for i := 1 to numToken
		&& tk := Token( format, ' ', i )
		tk := Token( format, , i )
		ch := alltrim( TokenSep( .t. ) )
		tkSep := ' '
		itm := upper( tk )
		len := len( itm )
		do case
		case alltrim( itm ) == 'GROUP'
			if ( j := ascan( ::aMenuType, { | x | x[ 2 ] == ::FInvalid } ) ) > 0
				s := alltrim( ::aMenuType[ j, 1 ] )
			endif
		case alltrim( itm ) == 'DEGREE'
			s := str( ::FDegreeOfDisability )
		case alltrim( itm ) == 'DATE'
			s := dtoc( ::FDate )
		otherwise
			s := alltrim( tk )	// ���� ��७�ᨬ ⥪��
		endcase
		s += ch
		if s != nil
			asString += iif( i = 1, '', tkSep ) + s
        endif
	next
	return asString