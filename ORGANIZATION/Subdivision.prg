*
*******************************************************************************
* 05.11.18 editSubdivisions() - ।���஢���� ᯨ᪠ �⤥�����
* 21.10.18 editSubdivision( oBrowse, aObjects, oSubdivision, nKey ) - ।���஢���� ��ꥪ� �⤥�����
* 27.09.18 inputN_otd( r, c, fl_all_uch, fl_all_otd, a_inp_uch, /*@*/c_otd )
* 23.09.18 static function ini_kod_podr( lkod )
* 23.09.18 static function get_kod_podr( k, r, c )
* 07.05.17 SelectSubdivision( r, c, department, dBegin, dEnd, nTask ) - �롮� �⤥�����
* 05.05.17 MultipleSelectedSubdivision( r, c, nTask, dBegin, dEnd, oUser ) - �����頥� ���ᨢ ��࠭��� ��ꥪ⮢ ���ࠧ������� 
* 14.02.17 choiceDivision( r, c, kk, aVar, cName ) -
* get_kod_podr( k, r, c ) -
* titleN_otd( arr_o, lsh, c_otd )
*******************************************************************************
*
#include 'set.ch'
#include 'inkey.ch'
#include 'hbthread.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

static strSubdivision := '�������������� ���������'

* 05.11.18 ।���஢���� ᯨ᪠ �⤥�����
function editSubdivisions()
	local blkEditObject
	local aEdit
	local oBox
	local aProperties
	local blk := { | | iif( between_date( parr[ nInd ]:Dbegin, parr[ nInd ]:Dend ), { 1, 2 }, { 5, 6 } ) }
	
	private oDepartment := nil	// ��� ��।�� � �-�� editSubdivision
	
	private tmp_V002 := create_classif_FFOMS( 1, 'V002' ) // PROFIL
	private tmp_V020 := create_classif_FFOMS( 1, 'V020' ) // PROFIL_K
	private tmp_V006 := create_classif_FFOMS( 1, 'V006' ) // USL_OK
	//private tmp_V008 := create_classif_FFOMS(1,'V008') // VIDPOM
	//private tmp_V010 := create_classif_FFOMS(1,'V010') // IDSP
	private mm_tiplu := {;
		{ '�⠭�����'                          ,0            }, ;  // 1
		{ '᪮�� ������'                        ,TIP_LU_SMP   }, ;  // 2
		{ '���-�� ��⥩-��� � ��樮���'     ,TIP_LU_DDS   }, ;  // 3
		{ '���-�� ��⥩-��� ��� ������'       ,TIP_LU_DDSOP }, ;  // 4
		{ '��䨫��⨪� ��ᮢ�襭����⭨�'       ,TIP_LU_PN    }, ;  // 5
		{ '�।����.�ᬮ��� ��ᮢ�襭����⭨�'  ,TIP_LU_PREDN }, ;  // 6
		{ '��ਮ���.�ᬮ��� ��ᮢ�襭����⭨�'   ,TIP_LU_PERN  }, ;  // 7
		{ '���-��/���ᬮ�� ������'          ,TIP_LU_DVN   }, ;  // 8
		{ '�७�⠫쭠� �������⨪�'             ,TIP_LU_PREND }, ;  // 9
		{ '����������'                           ,TIP_LU_H_DIA }, ;  // 10
		{ '���⮭����� ������'                ,TIP_LU_P_DIA } }   // 11
	private mm1tiplu := aclone( mm_tiplu )
	
	if ascan( glob_klin_diagn, 1 ) > 0
		aadd( mm_tiplu, { '������⭠� �⮫���� ࠪ� 襩�� ��⪨', TIP_LU_G_CIT } )
	elseif ascan(glob_klin_diagn,2) > 0
		aadd( mm_tiplu, { '�७�⠫�� �ਭ��� �����.�����.ࠧ�.', TIP_LU_G_CIT } )
	endif
	
	if ( oDepartment := SelectDepartment( T_ROW - 1, T_COL + 5, sys_date ) ) == nil
		return nil
	endif
	hb_ADel( mm1tiplu, 7 , .t. )
	hb_ADel( mm1tiplu, 6 , .t. )
	
	blkEditObject := { | oBrowse, aObjects, object, nKey, oDep | editSubdivision( oBrowse, aObjects, object, nKey ) }
	aProperties := { { 'Name', '������������ �⤥�����', 30, blk }, { 'ShortName', '����.;����.', 5, blk }, { 'TypeLU_F', '���� ���', 10, blk }, ;
						{ 'Profil_F', '��䨫�', 15, blk } }
	
	aEdit := if( hb_user_curUser:IsAdmin(), { .t., .t., .t., .t. }, { .f., .f., .f., .f. } )

	// ��ᬮ�� � ।���஢���� ᯨ᪠ �⤥�����
	oBox := TBox():New( T_ROW, 2, maxrow() - 1, 78, .t. )
	oBox:Caption := '���᮪ �⤥����� ���ࠧ�������'
	oBox:Color := color5
	ListObjectsBrowse( 'TSubdivision', oBox, TSubdivisionDB():GetList( oDepartment:ID() ), 1, aProperties, ;
										blkEditObject, aEdit, , , )

	return nil

* 15.02.20 ।���஢���� ��ꥪ� �⤥�����
function editSubdivision( oBrowse, aObjects, oSubdivision, nKey )
	local fl := .f., _fl := .f.
	local k, i, ii := 1
	local oBox

	private mmtiplu, m1mtiplu
	private mtyppodr, m1typpodr
	private mmprofil, m1mprofil
	private mmprofilK, m1mprofilK
	private mmIDUMP, m1mIDUMP
	private mmkodpodr, m1mkodpodr
	//private mmIDSP, m1mIDSP
	//private mmIDVMP, m1mIDVMP
	&& private mmAdress, m1mAddress
	&& private mm_adres_podr := {}
	private mmCodeSubTFOMS, m1mCodeSubTFOMS

	if nKey == K_F9
	elseif nKey == K_F2
	elseif nKey == K_INS .or. nKey == K_ENTER .or. nKey == K_F4
		if ( isnil( oSubdivision ) )
			return fl
		endif
		// ��� ���� ���
		m1mtiplu 	:= oSubdivision:TypeLU
		mmtiplu		:= inieditspr( A__MENUVERT, mm_tiplu, m1mtiplu )
		
		// ⨯ ���ࠧ�������
		m1typpodr	:= oSubdivision:TypePodr
		mtyppodr	:= inieditspr_bay( A__MENUVERT, mm_danet, m1typpodr )
		
		// ��䨫�
		m1mprofil 	:= oSubdivision:Profil
		mmprofil	:= inieditspr( A__MENUVERT, getV002(), m1mprofil )
		m1mprofilK 	:= oSubdivision:ProfilK
		// mmprofilK	:= inieditspr( A__MENUVERT, glob_V020, m1mprofilK )
		mmprofilK	:= inieditspr( A__MENUVERT, getV020(), m1mprofilK )
		// �᫮��� �������� ����樭᪮� �����
		m1mIDUMP	:= oSubdivision:IDUMP
		// mmIDUMP	:= inieditspr( A__MENUVERT, glob_V006, m1mIDUMP )
		mmIDUMP	:= inieditspr( A__MENUVERT, getV006(), m1mIDUMP )
		// ��� ���ࠧ�������
		mmkodpodr := ini_kod_podr( oSubdivision:KodPodr )

		m1mCodeSubTFOMS := oSubdivision:CodeSubTFOMS
		mmCodeSubTFOMS := inieditspr( A__MENUVERT, mm_otd_dep, m1mCodeSubTFOMS )
		
		if oSubdivision:IDDepartment() == 0
			oSubdivision:IDDepartment := oDepartment:ID()
		endif

		k := maxrow() - 15 - iif( is_task( X_PLATN ), 2, 0 ) - iif( is_task( X_ORTO ), 2, 0 ) - 1
		
//		oBox := TBox():New( k - 1, 2, maxrow() - 1, 77, .t. )

		oBox := TBox():New( k, 2, maxrow() - 1, 77, .t. )
		oBox:Caption := if( nKey == K_INS .or. nKey == K_F4, '����������', '������஢����' ) + ' ���ଠ樨 �� �⤥�����'
		oBox:CaptionColor := color8
		oBox:MessageLine := '^<Esc>^ - ��室 ��� �����;  ^<Enter>^ - ���⢥ত���� �����'
		oBox:View()

		@ k + ii++, 4 say '������������ �⤥�����' get oSubdivision:Name	//mname
		@ k + ii++, 4 say '����饭��� ������������ �⤥�����' get oSubdivision:ShortName	//mshortname
		@ k + ii++, 4 say '���� �⤥�����' get oSubdivision:Address picture '@S57'
		
		@ k + ii++, 4 say '��� ���� ��� �� ����� ������' get mmtiplu ;
						reader { | x | menu_reader( x, mm_tiplu, A__MENUVERT, , , .f. ) }
						
		@ k + ii++, 4 say '������� ������ �⤥����� ���� ������ ��樮���' get mtyppodr ;
						reader { | x | menu_reader( x, mm_danet, A__MENUVERT, , , .f. ) }
						
		@ k + ii++, 4 say '��䨫� ���.�����' get mmprofil ;
						reader { | x | menu_reader( x, tmp_V002, A__MENUVERT_SPACE, , , .f. ) }
		@ k + ii++, 4 say '��䨫� �����' get mmprofilK ;
						reader { | x | menu_reader( x, tmp_V020, A__MENUVERT_SPACE, , , .f. ) }
		@ k + ii++, 4 say '�᫮��� �������� ����樭᪮� �����' get mmIDUMP ;
						reader { | x | menu_reader( x, tmp_V006, A__MENUVERT, , , .f. ) }
		@ k + ii++, 4 say '��� ���ࠧ������� �� ��ᯮ�� ���' get mmkodpodr ;
						reader { | x | menu_reader( x, { { | k, r, c | get_kod_podr( k, r, c ) } }, A__FUNCTION, , , .f. ) }

/*		@ k + ii++, 4 say '���ᮡ ������' get mmIDSP ;
						// reader { | x | menu_reader( x, tmp_V010, A__MENUVERT, , , .f. ) }
		@ k + ii++, 4 say '��� ���.�����' get mmIDVMP ;
						// reader { | x | menu_reader( x, tmp_V008, A__MENUVERT, , , .f. ) }
*/
						
		@ k + ii++, 4 say '��� ��砫� ࠡ��� � ����� ���' get oSubdivision:DBegin
		@ k + ii++, 9 say '��� ����砭�� ࠡ��� � ����� ���' get oSubdivision:DEnd
		
		if is_otd_dep
			@ k + ii++, 4 say '�� �ࠢ�筨�� �����' get mmCodeSubTFOMS ;
						reader { | x | menu_reader( x, mm_otd_dep, A__MENUVERT_SPACE, , , .f. ) } picture '@S50'
		endif                       
		
		if is_task( X_PLATN )
			@ k + ii++, 4 say '��� ��砫� ࠡ��� � ����� "����� ��㣨"' get oSubdivision:DBeginP
			@ k + ii++, 9 say '��� ����砭�� ࠡ��� � ����� "����� ��㣨"' get oSubdivision:DEndP
		endif
		if is_task( X_ORTO )
			@ k + ii++, 4 say '��� ��砫� ࠡ��� � ����� "��⮯����"' get oSubdivision:DBeginO
			@ k + ii++, 9 say '��� ����砭�� ࠡ��� � ����� "��⮯����"' get oSubdivision:DEndO
		endif
		@ k + ii++, 4 say '���� ��祡��� �ਥ��� �� �����' get oSubdivision:Plan_VP picture '999999'
		@ k + ii++, 4 say '���� ��䨫��⨪ �� �����' get oSubdivision:Plan_PF picture '999999'
		@ k + ii++, 4 say '���� �ਥ��� �� ���� �� �����' get oSubdivision:Plan_PD picture '999999'
		
		myread()
		if lastkey() != K_ESC .and. ! empty( oSubdivision:Name ) .and. f_Esc_Enter( 1 )
			// ��� ���� ���
			oSubdivision:TypeLU := m1mtiplu
			oSubdivision:TypePodr := m1typpodr
			// ��䨫�
			oSubdivision:Profil := m1mprofil
			oSubdivision:ProfilK := m1mprofilK
			// �᫮��� �������� ����樭᪮� �����
			oSubdivision:IDUMP := m1mIDUMP
			// ��� ���ࠧ�������
			oSubdivision:KodPodr := mmkodpodr
			oSubdivision:CodeSubTFOMS := m1mCodeSubTFOMS
			//oSubdivision:IDSP := m1mIDSP
			//oSubdivision:IDVMP := m1mIDVMP
			
/*if is_adres_podr
  if ( i := ascan( glob_adres_podr, { | x | x[ 1 ] == glob_mo[ _MO_KOD_TFOMS ] } ) ) > 0
    for j := 1 to len( glob_adres_podr[ i, 2 ] )
	 aadd( mm_adres_podr, { glob_adres_podr[ i, 2, j, 3 ], glob_adres_podr[ i, 2, j, 2 ] } )
	next
  endif
  Ins_Array(arr[US_EDIT_SPR],7,{"ADRES_PODR","N",2,0,,;
                                {|x|menu_reader(x,mm_adres_podr,A__MENUVERT,,,.f.)},;
                                0,{|x|inieditspr(A__MENUVERT,mm_adres_podr,x)},;
                                "���� 㤠�񭭮�� ���ࠧ������� ��� ��樮���"})
endif                       
if is_adres_podr .and. (i := ascan(glob_adres_podr, {|x| x[1] == glob_mo[_MO_KOD_TFOMS] })) > 0
 G_Use(dir_server+"mo_otd",,"OTD")
 go top
 do while !eof()
    if otd->ADRES_PODR > 0 .and. (j := ascan(glob_adres_podr[i,2], {|x| x[2] == otd->ADRES_PODR })) > 0 ;
                          .and. !(otd->CODE_TFOMS == glob_adres_podr[i,2,j,1])
     G_RLock(forever)
     otd->CODE_TFOMS := glob_adres_podr[i,2,j,1]
     UnLock
   endif
   skip
 enddo
 close databases                      
endif*/
			TSubdivisionDB():Save( oSubdivision )
			fl := .t.
		endif
		oBox := nil	// ���⨬ ��ꥪ� TBox
	elseif nKey == K_DEL
		&& stat_msg( '����! �ந�������� �஢�ઠ �� �����⨬���� 㤠����� �⤥�����' )
		_fl := ! empty( TEmployeeDB():GetListBySubdivision( oSubdivision:ID() ))
		if !_fl
			_fl := ! THumanDB():HasSubdivision( oSubdivision )
		endif
		if _fl
			_fl := ! TContractDB():HasSubdivision( oSubdivision )
		endif
		if _fl
			TSubdivisionDB():Delete( oSubdivision )
			fl := .t.
		else
			hb_Alert( { '������ �⤥����� �ᯮ������.', '�������� ����饭�!' }, , , 4 )
		endif
	endif
	return fl
	
static function ini_kod_podr( lkod )
	local s := space( 10 )
	local obj := nil
	
	obj := T_Mo_podrDB():GetByCodePodr( lkod )
	if ! isnil( obj )
		s := '(' + alltrim( obj:KodOtd ) + ') ' + alltrim( obj:Name )
	endif
	return s

static function get_kod_podr( k, r, c )
	static arr
	local ret, ret_arr, tmp_select
	local aObject, item
	
	if isnil( arr ) // ⮫쪮 �� ��ࢮ� �맮��
		arr := {}
		aObject := T_Mo_podrDB():GetListByCodeTFOMS( glob_mo[ _MO_KOD_TFOMS ] )
		for each item in aObject
			aadd( arr, { '(' + alltrim( item:KodOtd ) + ') ' + alltrim( item:Name ), item:KodOtd } )
		next
	endif
	popup_2array( arr, -r, c, k, 1, @ret_arr, '�롮� �� ��ᯮ�� ���', 'GR+/RB', 'BG+/RB,N/BG' )
	if valtype( ret_arr ) == 'A'
		ret := array( 2 )
		ret[ 1 ] := ret_arr[ 2 ]
		ret[ 2 ] := ret_arr[ 1 ]
	endif
	return ret

* 07.05.17 - �롮� �⤥�����
function SelectSubdivision( r, c, department, dBegin, dEnd, nTask )
	local kk, idDepartment := 0
	local aSubdivisions
	local ret := nil
	
	if valtype( department ) == 'N'
		idDepartment := department
	elseif valtype( department ) == 'O' .and. department:ClassName() == upper( 'TDepartment' )
		idDepartment := department:ID()
	endif
	aSubdivisions := TSubdivisionDB():GetList( idDepartment, hb_user_curUser, hb_defaultValue( nTask, X_OMS ), dBegin, dEnd )
	if ( kk := Len( aSubdivisions ) ) == 0						// �ࠢ�筨� ���⮩
		hb_Alert( '���⮩ �ࠢ�筨� �⤥�����', , , 4 )
	elseif kk == 1												// ⮫쪮 ���� ��ப� � �ࠢ�筨��
		ret := aSubdivisions[ 1 ]
	elseif kk > 1												// �롨ࠥ� �� ��᪮�쪨� ��������� ����⮢
		ret := choiceDivision( r, c, kk, aSubdivisions, '�⤥�����' )
	endif
	if ret != nil
		glob_otd := { ret:ID(), ret:Name() }
		SetIniVar( tmp_ini, { { 'uch_otd', 'otd', glob_otd[ 1 ] } } )
	endif
	return ret
	
* 14.02.17
function choiceDivision( r, c, kk, aVar, cName )
	local item, i, nInd, k, c2
	local aTemp := {}
	local buf := savescreen()
	local ret := nil

	for each item in aVar					// �������� ���ᨢ �롮�
		aadd( aTemp, item:Name() )
	next
	if r < 0 // �.�. GET ��室���� ����� �࠭�
		k := abs( r ) - 2
		if ( r := k - kk - 1 ) < 2
			r := 2
		endif
	else
		if ( k := r + kk + 1 ) > maxrow() - 2
			k := maxrow() - 2
		endif
	endif
	c2 := c + 35 + 1
	if c2 > 77
		c2 := 77 ; c := 76 - 35
	endif
	
	i := 1
	status_key( '^<Esc>^ �⪠�;  ^<Enter>^ �롮�' )
	if ( nInd := popup( r, c, k, c2, aTemp, i, color_uch, .t., 'fmenu_reader', , ;
			cName, col_tit_uch ) ) > 0
		ret := aVar[ nInd ]
	endif
	restscreen( buf )
	return ret
	
* 05.05.17 - �����頥� ���ᨢ ��࠭��� ��ꥪ⮢ ���ࠧ������� 
function MultipleSelectedSubdivision( r, c, nTask, dBegin, dEnd, oUser )
	local aRet := {}, oDep
	local aSubdivisions := {}
	
	if ( oDep := SelectDepartment( r, c, dBegin, dEnd ) ) != nil
		aSubdivisions := TSubdivisionDB():GetList( oDep:ID(), hb_user_curUser, ;
				hb_defaultValue( nTask, X_OMS ), dBegin, dEnd )
		aRet := ChoiceObjectFromArray( r, c, aSubdivisions, .t., '�⤥�����' )
	endif
	return aRet

* 27.09.18
function inputN_otd( r, c, fl_all_uch, fl_all_otd, a_inp_uch, /*@*/c_otd )
	static st_otd := {}
	local i, k
	local mas_o := {}, mas := {}, t_mas, c2
	local buf := savescreen(), l_a_otd
	local aSubdivisions := {}, item
	local selectedDepartmentArray, nDepartment

	if isnil ( a_inp_uch ) // ������� ��०�����
		selectedDepartmentArray := input_uch( r, c, iif( fl_all_uch, , sys_date ) )
	else  // ��०����� 㦥 �뫮 ࠭�� ��࠭�
		selectedDepartmentArray := glob_uch
	endif
	if ! isnil( selectedDepartmentArray )
		mywait()
		nDepartment := selectedDepartmentArray[ 1 ]
		aSubdivisions := TSubdivisionDB():GetList( nDepartment, hb_user_curUser, , sys_date, sys_date )
		for each item in aSubdivisions
			aadd( mas_o, item:Name )
			aadd( mas, item:ID )
		next
		count_otd := c_otd := len( mas )
		if count_otd == 1
			glob_otd := { mas[ 1 ], mas_o[ 1 ] }
			restscreen( buf )
			return { glob_otd }
		endif
		if r < 0 // �.�. GET ��室���� ����� �࠭�
			k := abs( r ) - 2
			if ( r := k - count_otd - 1 ) < 2
				r := 2
			endif
		else
			if ( k := r + count_otd + 1 ) > maxrow() - 2
				k := maxrow() - 2
			endif
		endif
		c2 := c + 35 + 1
		if c2 > 77
			c2 := 77 ; c := 76 - 35
		endif
		t_mas := aclone( mas_o )
		if len( st_otd ) == 0
			if glob_otd[ 1 ] > 0
				aadd( st_otd, glob_otd[ 1 ] )
			else
				aeval( mas, { | x | aadd( st_otd, x ) } )
			endif
		endif
		aeval( t_mas, { | x, i | t_mas[ i ] := if( ascan( st_otd, mas[ i ] ) > 0, ' * ', '   ' ) + t_mas[ i ] } )
		status_key( '^<Esc>^ �⪠�;  ^<Enter>^ ���⢥ত����;  ^<Ins>^ ᬥ�� �ਧ���� �롮� �⤥�����' )
		do while .t.
			l_a_otd := nil
			if popup( r, c, k, c2, t_mas, i, color_uch, .t., 'fmenu_reader', , alltrim( glob_uch[ 2 ] ), col_tit_uch ) > 0
				l_a_otd := {} ; st_otd := {}
				for i := 1 TO len( t_mas )
					if '*' == substr( t_mas[ i ], 2, 1 )
						aadd( l_a_otd, { mas[ i ], mas_o[ i ] } )
						aadd( st_otd, mas[ i ] )
					endif
				next
				if empty( l_a_otd )
					func_error( 4, '����室��� �⬥��� ��� �� ���� �⤥�����!' )
					loop
				else
					if ( k := len( l_a_otd ) ) == 1
						glob_otd := l_a_otd[ 1 ]
					endif
					exit
				endif
			else
				exit
			endif
		enddo
	endif
	restscreen( buf )
	return l_a_otd

*
function titleN_otd( arr_o, lsh, c_otd )
	local i, t_arr[ 2 ], s := ''

	if !( type( 'count_otd' ) == 'N' )
		count_otd := iif( c_otd == nil, 1, c_otd )
	endif
	if count_otd > 1 .and. valtype( arr_o ) == 'A'
		if count_otd == len( arr_o )
			add_string( center( '[ �� �ᥬ �⤥����� ]', lsh ) )
		else
			aeval( arr_o, { | x | s += '"' + alltrim( x[ 2 ] ) + '", ' } )
			s := substr( s, 1, len( s ) - 2 )
			for i := 1 to perenos( t_arr, s, lsh )
				add_string( center( alltrim( t_arr[ i ] ), lsh ) )
			next
		endif
	endif
	return nil
