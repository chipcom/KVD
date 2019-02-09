#include 'hbclass.ch'
#include 'property.ch'

// ����� ����뢠�騩 㤮�⮢�७�� ��筮�� 䨧��᪮�� ���, �� �ਢ易� � �����⭮�� 䠩�� ��
CREATE CLASS TPassport
	VISIBLE:
		PROPERTY DocumentType WRITE setDocumentType INIT 0				// ⨯ ���㬥�� 㤮�⮢����饣� ��筮���
		PROPERTY DocumentSeries WRITE setDocumentSeries INIT space( 10 )	// ��� ���㬥��
		PROPERTY DocumentNumber WRITE setDocumentNumber INIT space( 20 )	// ����� ���㬥��
		PROPERTY IDIssue WRITE setDocumentIDIssue INIT 0					// �����䨪��� �࣠����樨 �뤠�襩 ���㬥��
		PROPERTY DateIssue WRITE setDateIssue INIT ctod( '' )			// ��� �뤠�
		PROPERTY AsString READ GetAsString( ... )						// �।�⠢����� ���㬥�� �� ��⠭�������� �ଠ⭮� ��ப�
		PROPERTY Format READ FFormat WRITE SetFormat						// �ଠ⭠� ��ப� �뢮�� �।�⠢����� ���㬥��
		
		CLASSDATA	aMenuType	AS ARRAY	INIT { ;
			{ '��ᯮ�� �ࠦ�.����        ', 1,  1,	'�������',			'R-��',	'999999' }, ;
			{ '���࠭���.�ࠦ�.����     ', 2,  0,	'���������',		'99',	'0999999' }, ;
			{ '����-�� � ஦����� (��)   ', 3,  1,	'��-�� � ���.��',	'R-��',	'999999' }, ;
			{ '��-��� ��筮�� ����   ', 4,  0,	'����� �������',	'��',	'999999' }, ;
			{ '��ࠢ�� �� �᢮��������   ', 5,  1,	'������� �� ���',	'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '��ᯮ�� ������䫮�       ', 6,  0,	'������� ������',	'��',	'999999' }, ;
			{ '������ �����             ', 7,  0,	'������� �����',	'��',	'0999999' }, ;
			{ '����.��ᯮ�� �ࠦ�.��     ', 8,  0,	'���������� ��',	'99',	'9999999' }, ;
			{ '�����࠭�� ��ᯮ��       ', 9,  1,	'������ �������',	'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '�����⥫��⢮...������   ', 10, 0,	'���� �������',		'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '��� �� ��⥫��⢮         ', 11, 1,	'��� �� ������',	'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '�����-�� ������ � ��     ', 12, 1,	'����� �������',	'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '�६.�.���.�ࠦ�.��     ', 13, 1,	'���� �����',		'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '��ᯮ�� �ࠦ�.���ᨨ      ', 14, 1,	'��ᯮ�� ���ᨨ',	'99 99','999999' }, ;
			{ '���࠭���.�ࠦ�.��       ', 15, 1,	'�������� ��',		'99',	'9999999' }, ;
			{ '��ᯮ�� ���猪            ', 16, 0,	'������� ������',	'��',	'0999999' }, ;
			{ '������ ����� ��.�����   ', 17, 0,	'���� ����� ��',	'��',	'0999999' }, ;
			{ '��� ���㬥���            ', 18, 1,	'������',			'',		'SSSSSSSSSSSSSSSSSSSSSSSSS' }, ;
			{ '���-� ����.�ࠦ������     ', 21, 0,	'������ �������',	'',		'' }, ;
			{ '���-� ��� ��� �ࠦ����⢠', 22, 0,	'���� ��� �����',	'',		'' }, ;
			{ '����-�� �� �६.�஦������', 23, 0,	'���� �� ��.��.',	'',		'' }, ;
			{ '����-�� � ஦�.(�� � ��)  ', 24, 0,	'��.� ���.�� ��',	'',		'' } }

// � ��� "������ �ਨ, �����" �ਢ����� ����� ��� ����஫� ���祭�� �ਨ, ����� ���㬥��.
// ������ ��⮨� �� ᨬ����� "R", "�", "9", "0", "S", "-" (��) � " " (�஡��).
// �ᯮ������� ᫥���騥 ������祭��:
// R - �� ���� ������ ᨬ���� R �ᯮ�������� 楫���� ਬ᪮� �᫮, �������� ᨬ������ "I", "V", "X", "L", "C", 
//		���࠭�묨 �� ���孥� ॣ���� ��⨭᪮� ����������; �������� �।�⠢����� ਬ᪨� �ᥫ � ������� 
//		ᨬ����� "1", "�", "�", "�", "�" ᮮ⢥��⢥���, ���࠭��� �� ���孥� ॣ���� ���᪮� ����������;
// 9 - �� �����筠� ��� (��易⥫쭠�);
// 0 - �� �����筠� ��� (����易⥫쭠�, ����� ������⢮����);
// � - �� ���᪠� ��������� �㪢�;
// S - ᨬ��� �� ����஫������ (����� ᮤ�ঠ�� ���� �㪢�, ���� ��� ����� ������⢮����);
// "-" (��) - 㪠�뢠�� �� ��易⥫쭮� ������⢨� ������� ᨬ���� � ����஫��㥬�� ���祭��.
// �஡��� �ᯮ������� ��� ࠧ������� ��㯯 ᨬ�����, � ⠪�� ����� ������ "No" ��� "N" ��� ࠧ������� 
//		�ਨ � ����� ���㬥��.
// ��᫮ �஡���� ����� ����騬� ᨬ������ � ����஫��㥬�� ���祭�� �� ������ �ॢ���� ���.
													
		METHOD New( nType, cSeries, cNumber, nIDIssue, dIssue )
	HIDDEN:
		// �ଠ⭠� ��ப�: TYPE - ⨯ ���㬥��, SSS - ���, NNN - �����, ISSUE - �� �뤠�, DATE - ��� �뤠�
		DATA FFormat INIT 'TYPE #SSS #NNN'
		METHOD setDocumentType( nType )
		METHOD setDocumentSeries( cText )
		METHOD setDocumentNumber( cText )
		METHOD setDocumentIDIssue( nId )
		METHOD setDateIssue( dIssue )
		METHOD GetAsString( format )
		METHOD SetFormat( format ) INLINE ::FFormat := format
ENDCLASS

METHOD New( nType, cSeries, cNumber, nIDIssue, dIssue ) CLASS TPassport
	::FDocumentType := hb_defaultvalue( nType, 0 )
	::FDocumentSeries := left( hb_defaultvalue( cSeries, space( 10 ) ), 10 )
	::FDocumentNumber := left( hb_defaultvalue( cNumber, space( 20 ) ), 20 )
	::FIDIssue := hb_defaultvalue( nIDIssue, 0 )
	::FDateIssue := hb_defaultvalue( dIssue, ctod( '' ) )
	return self

METHOD PROCEDURE setDocumentType ( nType )	CLASS TPassport
	::FDocumentType := nType
	return

METHOD PROCEDURE setDocumentSeries( cText )	CLASS TPassport
	::FDocumentSeries := cText
	return

METHOD PROCEDURE setDocumentNumber( cText )	CLASS TPassport
	::FDocumentNumber := cText
	return

METHOD PROCEDURE setDocumentIDIssue( nId )	CLASS TPassport
	::FIDIssue := nId
	return

METHOD PROCEDURE setDateIssue( dIssue )	CLASS TPassport
	::FDateIssue := dIssue
	return
	
METHOD FUNCTION GetAsString( format ) CLASS TPassport
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
	numToken := NumToken( format, ' ' )	// ࠧ����⥫� �����ப ⮫쪮 '�஡��'
	&& numToken := NumToken( format )
	for i := 1 to numToken
		tk := Token( format, ' ', i )	// ࠧ����⥫� �����ப ⮫쪮 '�஡��'
		&& tk := Token( format, , i )
		ch := alltrim( TokenSep( .t. ) )
		tkSep := ' '
		itm := upper( tk )
		len := len( itm )
		do case
		case alltrim( itm ) == 'TYPE'
			if ( j := ascan( ::aMenuType, { | x | x[ 2 ] == ::FDocumentType } ) ) > 0
				s := alltrim( ::aMenuType[ j, 4 ] )
			endif
		case alltrim( itm ) == 'SSS'
			if ! empty( ::FDocumentSeries )
				s := alltrim( ::FDocumentSeries )
			endif
		case alltrim( itm ) == '#SSS'
			if ! empty( ::FDocumentSeries )
				s := '��� ' + alltrim( ::FDocumentSeries )
			endif
		case alltrim( itm ) == 'NNN'
			if ! empty( ::FDocumentNumber )
				s := alltrim( ::FDocumentNumber )
			endif
		case alltrim( itm ) == '#NNN'
			if ! empty( ::FDocumentNumber )
				s := '� ' + alltrim( ::FDocumentNumber )
			endif
		case alltrim( itm ) == 'ISSUE'
			if ( oPublisher := TPublisherDB():getByID( ::FIDIssue ) ) != nil
				s := alltrim( oPublisher:Name() )
			endif
		case alltrim( itm ) == 'DATE'
			s := dtoc( ::FDateIssue )
		otherwise
			s := alltrim( tk )	// ���� ��७�ᨬ ⥪��
		endcase
		s += ch
		if s != nil
			asString += iif( i = 1, '', tkSep ) + s
        endif
	next
	return asString