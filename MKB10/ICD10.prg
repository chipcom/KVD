* ICD10.prg - ࠡ�� � �ࠢ�筨��� ���-10
*******************************************************************************
* 04.11.18 viewICD10() - �⮡ࠦ���� ᯨ᪠ ���-10
* 04.11.18 viewICD10Class()
* 04.11.18 viewICD10Group()
* 30.03.17 layoutICD10( oBrow, aList ) �ନ஢���� ������� ��� �⮡ࠦ���� ���-10
* 09.06.17 ShowDiagnosis( k, cDiagnosis ) - �뢥�� ������������ �������� �� ����� ����
* 09.06.17 validICD10( fl_search, fl_plus, fl_screen, ldate, lpol ) - �஢�ઠ ����� �������� � ��砥 ���
*******************************************************************************

#include 'inkey.ch'
#include 'function.ch'

* 04.11.18 �⮡ࠦ���� ᯨ᪠ ���-10
function viewICD10()
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	local blcCodeColor := { | | iif( !between_date( parr[ nInd ]:Dbegin, parr[ nInd ]:Dend ), { 3, 4 }, ;
				iif( !empty( parr[ nInd ]:Gender ), { 5, 6 }, { 1, 2 } ) ) }
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editICD10( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Shifr_Gen', '����', 7, blcCodeColor }, { 'Name', '������������ ��������� �����������', 65, blcCodeColor } }
	
	aEdit := { .f., .f., .f., .f. }
				
	oBox := TBox():New( 2, 1, maxrow() - 2, 77, .t. )
	oBox:Color := color0
	// ��ᬮ�� � ।���஢���� ᯨ᪠ ���������
	ListObjectsBrowse( 'TICD10', oBox, TICD10DB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , , 'N/BG, W+/N, B/BG, BG+/B, GR/BG, BG+/GR' )
	return nil

function editICD10( oBrowse, aObjects, object, nKey )
	static sshifr := '     ', sname := ''
	local buf, buf24, s, k := -1, bg := { | o, k | get_MKB10( o, k ) }
	local fl := .f., lFound := .f.
	local item
	local i := j := 0, t_len
	local r1 := 2, c1 := 1, r2 := maxrow() - 2, c2 := 77
	local k1 := r1 + 3, k2 := r2 - 1
	private mshifr := space( 5 )
	private mname := padr( alltrim( sname ), 30 )
	private tmp_mas := {}, tmp_id := {}

	if nKey == K_F8
		if ( j := f_alert( { padc( '�롥�� ���冷� ���஢��', 60, '.' ) }, ;
				{ ' �� ���� ', ' �� ������������ ' }, ;
				1, 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N,N/BG' ) ) != 0
			if j == 1
				asort( aObjects, , , { | x, y | x:Shifr < y:Shifr } )
			elseif j == 2
				asort( aObjects, , , { | x, y | x:Name < y:Name } )
			endif
			oBrowse:refreshAll()
		endif
	elseif nKey == K_F2
		buf := save_box( 18, 0, 24, 79 )
		box_shadow( 18, 20, 20, 59, color8 )
		@ 19,32 say '������ ���' color color1 ;
                get mshifr picture '@K@!' ;
                reader { | o | MyGetReader( o, bg ) } ;
                valid val1_10diag( .f. ) color color1
		status_key( '^<Esc>^ - �⪠� �� �����; ^<Enter>^ - ���⢥ত���� �����' )
		myread( { 'confirm' } )
		if lastkey() != K_ESC .and. !empty( mshifr )
			lFound := .f.
			mshifr := alltrim( mshifr )
			t_len := len( mshifr )
			i := 0
			for each item in aObjects
				++i
				if left( item:Shifr, t_len ) == mshifr
					lFound := .t.
					nInd := i
					exit
				endif
			next
		endif
		rest_box( buf )
		if lFound
			oBrowse:refreshAll()
		elseif !lFound .and. !empty( mshifr )
			hb_Alert( '������� � ��஬ <' + mshifr + '> �� ������!', , , 4 )
		endif
	elseif nKey == K_F3
		if ( mname := input_value( 18, 4, 20, 75, color8, ;
						'������ �����ப� ��� ���᪠ ��������', ;
						mname, '@K@!' ) ) != NIL .and. !empty( mname )
			mname := alltrim( mname )
			
			buf24 := save_maxrow()
			i := 0
			lFound := .f.
			for each item in aObjects
				++i
				if mname $ upper( item:Name )
					aadd( tmp_mas, item:Shifr + ' ' + item:Name )
					aadd( tmp_id, i )
				endif
			next
			rest_box( buf24 )
			if ( t_len := len( tmp_id ) ) != 0
				sname := mname
				buf := box_shadow( r1, c1, r2, c2, color0 )
				buf24 := save_maxrow()
				@ r1 + 1, c1 + 1 say '�����ப� ���᪠: ' + mname color 'B/BG'
				SETCOLOR( color0 )
				if t_len < k2 - k1 - 1
					k2 := k1 + t_len + 2
				endif
				@ k1, c1 + 1 say padc( '���-�� ��������� ��ப - ' + lstr( t_len ), c2 - c1 - 1 )
				i := 0
				status_key( '^<Esc>^ - �⪠� �� �롮�;  ^<Enter>^ - �롮�; ^<F9>^ - �����' )
				if ( i := popup( k1 + 1, c1 + 1, k2, c2 - 1, tmp_mas, i, color0, .t., 'printFoundICD' ) ) > 0
					lFound := .t.
					nInd := tmp_id[ i ]
				endif
				rest_box( buf )
				rest_box( buf24 )
			else
				func_error( 3, '��㤠�� ����!' )
			endif
		endif
		if lFound
			oBrowse:refreshAll()
		endif
	endif
	return fl

* 04.11.18	
function viewICD10Class()
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editICDRange( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Class', '�����', 5 }, { 'SH_B', '', 4 }, { 'SH_E', '', 4 }, { 'Name', '������������ ����� �����������', 60 } }
	
	aEdit := { .f., .f., .f., .f. }
				
	oBox := TBox():New( 2, 0, maxrow() - 2, 79, .t. )
	oBox:Caption := '���᮪ ����ᮢ �� ���-10'
	oBox:Color := color0
	// ��ᬮ�� ᯨ᪠ ��㯯 ���-10
	ListObjectsBrowse( 'TICD10Class', oBox, TICD10ClassDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , '^<F9>^-����� �����', 'N/BG, W+/N, B/BG, BG+/B' )
	return nil

function editICDRange( oBrowse, aObjects, object, nKey )
	local fl := .f.

	if nKey == K_F9
		printICDRange( object )
	endif
	return fl

* 04.11.18	
function viewICD10Group()
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editICDRange( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'SH_B', '', 4 }, { 'SH_E', '', 4 }, { 'Name', '������������ ��㯯� �����������', 68 } }
	
	aEdit := { .f., .f., .f., .f. }
				
	oBox := TBox():New( 2, 0, maxrow() - 2, 79, .t. )
	oBox:Caption := '���᮪ ��㯯 �� ���-10'
	oBox:Color := color0
	// ��ᬮ�� ᯨ᪠ ��㯯 ���-10
	ListObjectsBrowse( 'TICD10GroupDB', oBox, TICD10GroupDB():GetList(), 1, aProperties, ;
										blkEditObject, aEdit, , '^<F9>^-����� �����㯯�', 'N/BG, W+/N, B/BG, BG+/B' )
	return nil
	
* 09.06.17 �뢥�� ������������ �������� �� ����� ����
function ShowDiagnosis( k, cDiagnosis )
	static buf_d
	local i, lc, r := 12
	
	if type( 'row_diag_screen' ) == 'N' .and. row_diag_screen > 0
		r := row_diag_screen
	endif
	if k == 0 // ���㫨�� ����
		buf_d := nil
	elseif k == 1 // �᫨ ����, ���ᮢ��� ��אַ㣮�쭨�, � �뢥�� �������
		if buf_d == nil
			buf_d := box_shadow( r, 3, r + 5, 76, 'N/RB', '�������', 'W/RB' )
		endif
		&& for i := 1 to len( arr_d )
			lc := if( '� ���' $ cDiagnosis .or. '�� ����' $ cDiagnosis, 'GR+/RB', 'W+/RB' )
			@ r + i,5 say padr( cDiagnosis, 71 ) color lc
		&& next
	elseif k == 2 // ����⠭����� �࠭  � ���㫨�� ����
		if buf_d != nil
			rest_box( buf_d )
		endif
		buf_d := nil
	endif
	return .t.
	
&& * 09.06.17 �஢�ઠ ����� �������� � ��砥 ���
&& function validICD10( fl_search, fl_plus, fl_screen, ldate, lpol )
&& // fl_search - �᪠�� ������ ������� � �ࠢ�筨��
&& // fl_plus   - ����᪠���� �� ���� ��ࢨ筮(+)/����୮(-) � ���� ��������
&& // fl_screen - �뢮���� �� �� �࠭ ������������ ��������
&& // ldate     - ���, �� ���ன �஢������ ������� �� ���
&& // lpol      - ��� ��� �஢�ન �����⨬��� ����� �������� �� ����
	&& local fl := .t., mshifr, c_plus := ' ', i, arr,;
		&& lis_talon := .f., jt, m1, s, mshifr6, fl_4
	&& local tmp_select := select()
	&& local oICD10 := nil, toICD10 := nil

	&& HB_Default( @fl_search, .t. ) 
	&& HB_Default( @fl_plus, .f. ) 
	&& HB_Default( @fl_screen, .f. ) 
	&& HB_Default( @ldate, sys_date ) 
	&& if type( 'is_talon' ) == 'L' .and. is_talon
		&& lis_talon := .t.
	&& endif
	&& private mvar := upper( readvar() )
	&& mshifr := alltrim( &mvar )
	&& if lis_talon
		&& arr := { 'MKOD_DIAG', ;
			&& 'MKOD_DIAG2', ;
			&& 'MKOD_DIAG3', ;
			&& 'MKOD_DIAG4', ;
			&& 'MSOPUT_B1', ;
			&& 'MSOPUT_B2', ;
			&& 'MSOPUT_B3', ;
			&& 'MSOPUT_B4' }
		&& if ( jt := ascan( arr, mvar ) ) == 0
			&& lis_talon := .f.
		&& endif
	&& endif
	&& if fl_plus
		&& if ( c_plus := right( mshifr, 1 ) ) $ yes_d_plus  // '+-'
			&& mshifr := alltrim( left( mshifr, len( mshifr ) - 1 ) )
		&& else
			&& c_plus := ' '
		&& endif
	&& endif
	&& mshifr6 := padr( mshifr, 6 )
	&& mshifr := padr( mshifr, 5 )
	&& if empty( mshifr )
		&& ShowDiagnosis( 2 )
	&& elseif fl_search
		&& mshifr := mshifr6
		&& if ( oICD10 := TICD10():GetByShifr( mshifr ) ) != nil
			&& fl_4 := .f.
			&& if !empty( ldate ) .and. !between_date( oICD10:dBegin, oICD10:dEnd, ldate )
				&& fl_4 := .t.  // ������� �� �室�� � ���
			&& endif
			&& if fl_4 .and. mem_diag4 == 2 .and. !( '.' $ mshifr ) // �᫨ ��� ��姭���
				&& m1 := alltrim( mshifr ) + '.'
				&& // ⥯��� �஢�ਬ �� ����稥 ��� ����姭�筮�� ���
				&& if ( toICD10 := TICD10():GetByShifr( m1 ) ) != nil
					&& s := ''
					&& for i := 0 to 9
						&& if ( toICD10 := TICD10():GetByShifr( m1 + str( i, 1 ) ) ) != nil
							&& s += alltrim( toICD10:Shifr ) + ','
						&& endif
					&& next
					&& s := substr( s, 1, len( s ) - 1 )
					&& &mvar := padr( m1, 5 ) + c_plus
					&& hb_Alert( '����㯭� ����: ' + s, , , 4 )
					&& fl := .t.
				&& endif
			&& endif
			&& if fl .and. fl_screen .and. mem_diagno == 2
				&& s := ''
				&& if !empty( ldate ) .and. !between_date( oICD10:dBegin, oICD10:dEnd, ldate )
					&& s := '������� �� �室�� � ���'
				&& endif
				&& if !empty( lpol ) .and. !empty( oICD10:Gender ) .and. !( oICD10:Gender == lpol )
					&& if empty( s )
						&& s := '�'
					&& else
						&& s += ', �'
					&& endif
					&& s += '�ᮢ���⨬���� �������� �� ����'
				&& endif
				&& if !empty( s )
					&& s := padc( alltrim( s ) + '!', 71 )
					&& mybell()
				&& endif
				&& ShowDiagnosis( 1, s )
			&& endif
		&& else
			&& if '.' $ mshifr  // �᫨ ��� ����姭���
				&& m1 := beforatnum( '.', mshifr )
				&& // ᭠砫� �஢�ਬ �� ����稥 ��姭�筮�� ���
				&& if ( toICD10 := TICD10():GetByShifr( m1 ) ) != nil
					&& // ⥯��� �஢�ਬ �� ����稥 ��� ����姭�筮�� ���
					&& if ( toICD10 := TICD10():GetByShifr( m1 + '.' ) ) != nil
						&& s := ''
						&& for i := 0 to 9
							&& if ( toICD10 := TICD10():GetByShifr( m1 + '.' + str( i, 1 ) ) ) != nil
								&& s += alltrim( toICD10:Shifr ) + ','
							&& endif
						&& next
						&& s := substr( s, 1, len( s ) - 1 )
						&& &mvar := padr( m1 + '.', 5 ) + c_plus
						&& hb_Alert( '����㯭� ����: ' + s, , , 4 )
						&& fl := .f.
					&& else
						&& &mvar := padr( m1, 5 ) + c_plus
						&& hb_Alert( '����� ������� ��������� ⮫쪮 � ���� �������筮�� ���!', , , 4 )
						&& fl := .f.
					&& endif
				&& endif
			&& endif
			&& if fl
				&& &mvar := space( if( fl_plus, 6, 5 ) )
				&& hb_Alert( '������� � ��஬: ' + alltrim( mshifr ) + ' �� ������!', , , 4 )
				&& fl := .f.
			&& endif
		&& endif
		&& if tmp_select > 0
			&& select ( tmp_select )
		&& endif
	&& endif
	&& if fl
		&& if right( mshifr6, 1 ) != ' '
			&& &mvar := mshifr6
		&& else
			&& &mvar := padr( mshifr, 5 ) + c_plus
		&& endif
	&& endif
	&& if lis_talon .and. type( 'adiag_talon' ) == 'A'
		&& if empty( &mvar )  // �᫨ ���⮩ ������� -> ����塞 ������� � ����
			&& for i := jt * 2 - 1 to jt * 2
				&& adiag_talon[ i ] := 0
			&& next
		&& endif
		&& put_dop_diag()
	&& endif
	&& return fl	
