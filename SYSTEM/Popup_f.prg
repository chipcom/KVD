#include "edit_spr.ch"
#include "function.ch"
#include "inkey.ch"

***** ���⨪��쭮� ���� (� ��࠭����� � ����⠭�������� �࠭�)
&& FUNCTION popup_SCR(nTop, nLeft, nBottom, nRight, aArray, nInd, defineColor,;
                   && fl_shadow, n_func, regim, titul, titul_color, ;
                   && mfunction, blk_color)
&& Local k, buf := savescreen()
&& k := popup(nTop, nLeft, nBottom, nRight, aArray, nInd, defineColor,;
           && fl_shadow, n_func, regim, titul, titul_color, ;
           && mfunction, blk_color)
&& restscreen(buf)
&& return k

***** ���⨪��쭮� ���� �롮� ����⮢
function popup_obj( nTop, nLeft, nBottom, nRight, ;	// nTop,nLeft,nBottom,nRight - ࠧ���� ����
		aArray, ;									// aArray - ���ᨢ ��ꥪ⮢
		aProperties, ;								// aProperties - ��㬥�� ���ᨢ �뢮����� ᢮��� ��ꥪ⮢ ����:
		lMultiSelect, ;								// lMultiSelect - �����᪮� ��६����� �����뢠��� �������� �� �⡮� ����⮢ ���ᨢ�
		nI, ;										// nI - ⥪�騩 �����
		defineColor, ;								// defineColor - 梥� (��ப� ��� �����)
		fl_shadow, ;								// fl_shadow - ���� ⥭� ��� ���
		strTitul, titul_color, ;						// titul, titul_color - ��������� � ��� 梥�
		blk_color )									// blk_color - �᫨ .t. � ��ப� ��࠭�, �⮡ࠦ��� ࠧ�묨 梥⠬�
	local oBox := nil
	local aReturn := {}
	local bufferScreen := savescreen()

	oBox := TBox():New( nTop, nLeft, nBottom, nRight, fl_shadow )
	oBox:Caption := strTitul
	oBox:CaptionColor := titul_color
	oBox:Shadow := fl_shadow
	oBox:View()
	
	aReturn := __browseListObjects( oBox, aArray, aProperties, .t., lMultiSelect, ;
		nI, defineColor, , , , blk_color )
	
	restscreen( bufferScreen )
	oBox := nil
	
	return aReturn
	
***** �㭪�� �।����祭� ��� ��ᬮ�� ᯨ᪠ ��ꥪ⮢ ��� ࠧ����� ����� �������樨 � ����
*
&& function __browseListObjects( nTop, nLeft, nBottom, nRight, ;	// nTop,nLeft,nBottom,nRight - ࠧ���� ����
function __browseListObjects( oBox, ;					// oBox - ��ꥪ� ���� �뢮�� � ��⠭������묨 ࠧ��ࠬ�
		aObject, ;									// aObject - ���ᨢ ��ꥪ⮢
		aProperties, ;								// aProperties - ��㬥�� ���ᨢ �뢮����� ᢮��� ��ꥪ⮢ ����:
		;											// {{�����⢠1, ����������⮫��1, �����1},
		;											// { �����⢠2, ����������⮫��2, �����2},...}
		lSelect, ;									// lSelect - ����祭�� �⡮� ��ꥪ�(��) �� ᯨ᪠
		lMultiSelect, ;								// lMultiSelect - ����祭�� ����������� ������⢥����� �롮� ��ꥪ⮢
		nI, ;										// nI - ⥪�騩 �����
		defineColor, ;								// defineColor - 梥� (��ப� ��� �����)
		n_func, ;									// n_func - ��� �㭪樨 ���짮��⥫� (����⨥ ������)
		regim, ;									// regim - ०�� ��� popup_edit
		mfunction, ;								// mfunction - �㭪��, ��뢠���� �� ������ 蠣� TBrowse (�ᮢ����)
		blk_color )									// blk_color - �᫨ .t. � ��ப� ��࠭�, �⮡ࠦ��� ࠧ�묨 梥⠬�
	local aViewProperty := {}, aSortProperty := {}, bBlock := ''
	local columnPos
	local item, counter, aTemp
	local isHeader := .f.
	local cTypeProperty := '', lenProperty := 0
	local cPropertyName, blk_Sort
	local aReturn := {}				// ���ᨢ ��� �����饭�� ��࠭��� ����⮢

	local oBrowse, oColumn, lCont := .t., cStatus, tmp_color := setcolor(),;
		nKey := 256, fl_rbrd := .f., i, j, fl_mouse, x_mouse := 0, y_mouse := 0, km, ;
		color_find, static_find := '', buf_static, len_static, ;
		nsec := seconds(), period := 300, ;
		nsecRefresh := seconds(), NSTR, COUNT// := len( aArray )
		
	local nTop, nLeft, nBottom, nRight
	local aArray := aclone( aObject )	// ᮧ����� ���� ���ᨢ� ��ꥪ⮢
	
	hb_default( @nI, 1 )
	hb_default( @defineColor, color0 )
	hb_default( @n_func, '' )
	hb_default( @regim, 0 )
	hb_default( @mfunction, '' )
	hb_default( @blk_color, .f. )
	hb_default( @aProperties, {} )
	hb_default( @lSelect, .f. )
	hb_default( @lMultiSelect, .f. )

	private last_k := 2, tmp
	private nInd := nI
	
	COUNT := len( aArray )

	// ����稬 ��ࠬ���� ������� ������
	nTop := oBox:Top
	nLeft := oBox:Left
	nBottom := oBox:Bottom
	nRight := oBox:Right
	
	NSTR := nBottom - nTop - 1
	
	&& if COUNT == 0 .or. len( aProperties ) == 0	// �᫨ ��� ��ꥪ⮢ ��� �⮡ࠦ���� ��� ���⮩ ���ᨢ �뢮����� ᢮���
	if len( aProperties ) == 0	// �᫨ ���⮩ ���ᨢ �뢮����� ᢮���
		return 0
	endif
	for counter := 1 to len( aProperties ) // ����稬 ����� �뢮����� ᮢ��� ��ꥪ�
		aadd( aViewProperty, aProperties[ counter, 1 ] )
		aadd( aSortProperty, nil )
	next
	
	if lSelect .and. lMultiSelect
		for each item in aArray			// ������塞 �������⥫쭮� ᢮��⢮ 'checked' � ��⮤ toggleChecked
			item := __objAddData( item, 'checked' )
			item:checked := .f.
			item := __objAddMethod( item, 'getChecked', @getChecked() )
			item := __objAddMethod( item, 'toggleChecked', @toggleChecked() )
		next
	endif
	nInd := if( nInd <= 0, 1, if( nInd > COUNT, COUNT, nInd ) )
	if valtype( defineColor ) == 'C'
		setcolor( beforatnum( ',', defineColor ) )
	elseif valtype( defineColor ) == 'N'
		tmp := 'color' + LSTR( defineColor )
		setcolor( &tmp )
	endif
	if !empty( n_func ) .and. '(' $ n_func
		n_func := beforatnum( '(', n_func )
	endif
	if !empty( mfunction ) .and. !( '(' $ mfunction )
		mfunction += '()'
	endif
	if NSTR < COUNT .and. NSTR > 4
		fl_rbrd := .t.
		@ nTop + 1, nRight    say chr( 30 )
		@ nBottom - 1, nRight say chr( 31 )
		for i := nTop + 2 to nBottom - 2
			@ i, nRight say chr( 176 )
		next
		@ nTop + last_k, nRight say chr( 8 )
	endif
	setcursor( 0 )
	
	oBrowse:= TBrowseNew( nTop + 1, nLeft + 1, nBottom - 1, nRight - 1 )
	oBrowse:colorSpec := if( valtype( defineColor ) == 'C', defineColor, &( 'color' + LSTR( defineColor ) ) )
	oBrowse:goTopBlock := { | | nInd := 1, right_side( fl_rbrd, nInd, COUNT, nTop, nRight, NSTR ) }
	oBrowse:goBottomBlock := { | | nInd := COUNT, right_side( fl_rbrd, nInd, COUNT, nTop, nRight, NSTR ) }
	oBrowse:skipBlock := ;
		{ | nSkip, nVar | nVar := nInd, ;
			nInd := if( nSkip > 0, min( COUNT, nInd + nSkip ), max( 1, nInd + nSkip ) ), ;
			right_side( fl_rbrd, nInd, COUNT, nTop, nRight, NSTR ), nInd - nVar }
			
	if !empty( aArray )
		// �������� tbrowse �⮡ࠦ���묨 ���������
		if ( __objHasData( aArray[ 1 ], 'checked' ) )		// ������� ��� �⮡ࠦ���� �⬥⪨ '*' �롮� ��ꥪ�
			oColumn := TBColumnNew( '', { | | if( aArray[ nInd ]:checked, '*', ' ' ) } )
			oColumn:width := 1
			oBrowse:addColumn( oColumn )
		endif
		for counter := 1 to len( aProperties )
			aTemp := aProperties[ counter ]
			if alltrim( aTemp[ 2 ] ) != ''
				isHeader := .t.
			endif
			cTypeProperty := valtype( aArray[ 1 ]:&( aViewProperty[ counter ] ) )
			lenProperty := aTemp[ 3 ]
			bBlock := createCodeBlock( aArray, cTypeProperty, lenProperty, aViewProperty, counter )
			oColumn := TBColumnNew( aTemp[ 2 ], bBlock )
			oColumn:width := aTemp[ 3 ]
			//TODO: ࠧ������� � 梥⠬�
			&& if blk_color
				&& oColumn:colorBlock := { | | if( aArray[ nInd ]:checked, { 1, 2 }, { 3, 4 } ) }
			&& endif
			oBrowse:addColumn(oColumn)
		next
	endif
	if isHeader
		if lSelect //.and. lMultiSelect
			oBrowse:headSep := '���'
		else
			oBrowse:headSep := '���'
		endif
		// oBrowse:footSep := '���'
	endif
	if len( aProperties ) > 1
		if lSelect //.and. lMultiSelect
			oBrowse:colSep  := '   '
		else
			oBrowse:colSep  := ' � '
		endif
	endif
	if ( i := nInd ) > COUNT - NSTR
		oBrowse:goBottom()
		for tmp := COUNT - 1 TO i STEP -1
			oBrowse:up()
		next
	endif
	color_find := color_find( oBrowse:colorSpec )
	buf_static := save_box( nTop, nLeft, nTop, nRight )
	len_static := nRight - nLeft - 3
	fl_mouse := SETPOSMOUSE()
	if lSelect .and. lMultiSelect		// �᫨ ��࠭ ������⢥��� �⡮� ��३� ���ࠢ� � ����஧�� ���� �⮫���
		oBrowse:right()
		oBrowse:freeze := 1
	endif
	do while lCont
		if nKey != 0
			oBrowse:forcestable()  // �⠡�������
			if !empty( mfunction ) ; tmp := &mfunction ; endif
				FT_MSHOWCRS( fl_mouse )
			endif
			nKey := 0
		if nKey == 0
			nKey := INKEYTRAP()
		endif
		
		if seconds() - nsecRefresh > 20     // ����� 20 ᥪ.
			aArray := aclone( aObject )	// ����ਬ �����஢���� ���ᨢ�
			COUNT := len( aArray )
			oBrowse:refreshAll()
			nsecRefresh := seconds()
			nKey := 256
			nsecRefresh := seconds()
		endif
		
		if nKey == 0
			if period > 0 .and. seconds() - nsec > period
				// �᫨ �� �ண��� ���������� [period] ᥪ., � ��� �� �㭪樨
				nKey := K_ESC
			endif
		else
			nsec := seconds()
		endif
		if nKey != 0 .and. ;
				!( ( len( static_find ) > 0 .and. nKey == 32 ) .or. between( nKey, 33, 255 ) ;
												.or. nKey == K_BS )
			static_find := '' ; rest_box( buf_static )
		endif
		DO case
			case nKey == K_LEFT
				// �᫨ ����祭 ������⢥��� �⡮� ��ꥪ⮢ �� ��ன ������� ᯨ᪠ ���室 �� �ࠢ� �� �ந�������
				if !( lSelect .and. lMultiSelect .and. oBrowse:colPos == 2 )
					FT_MHIDECRS( fl_mouse ) ; oBrowse:left()
				endif
			case nKey == K_RIGHT
				FT_MHIDECRS( fl_mouse ) ; oBrowse:right()
			case nKey == K_UP .or. nKey == K_SH_TAB
				FT_MHIDECRS( fl_mouse ) ; oBrowse:up()
			case nKey == K_DOWN .or. nKey == K_TAB
				FT_MHIDECRS( fl_mouse ) ; oBrowse:down()
			case nKey == K_PGUP
				FT_MHIDECRS( fl_mouse ) ; oBrowse:pageUp()
			case nKey == K_PGDN
				FT_MHIDECRS( fl_mouse ) ; oBrowse:pageDown()
			case nKey == K_HOME .or. nKey == K_CTRL_PGUP .or. nKey == K_CTRL_HOME
				FT_MHIDECRS( fl_mouse ) ; oBrowse:goTop()
			case nKey == K_END .or. nKey == K_CTRL_PGDN .or. nKey == K_CTRL_END
				FT_MHIDECRS( fl_mouse ) ; oBrowse:goBottom()
			case len( static_find ) == 0 .and. nKey == 32 .and. ;
							eq_any( regim, PE_APP_SPACE, PE_SPACE )  // �஡�� == 32
				lCont := .f.
			case nKey == K_ENTER
				if regim == PE_EDIT  // �맮� �-�� ��� ।���஢����
					FT_MHIDECRS( fl_mouse )
					tmp := n_func + '(' + lstr( nKey ) + ',' + lstr( nInd ) + ')'
					if ( i := &tmp ) == 0         // �㭪�� ������ �������� 0 ���
						oBrowse:refreshAll()      // ���������� TBrowse, ���� -1 (��祣�)
					elseif i == 1                 // ��� 1 ��� ��室� �� popup
						lCont := .f.
					endif
					nKey := 256
				else  // ���� �롮� �� ����
					lCont := .f.
				endif
//
			case lSelect .and. lMultiSelect .and. nKey == K_INS	// ���⠢��� �⬥�� �� �����
				aArray[ nInd ]:toggleChecked()
				oBrowse:refreshAll()
			case lSelect .and. lMultiSelect .and. nKey == 43		// "+" - ���⠢��� �⬥�� �� �� ������
				for each item in aArray
					item:checked := .t.
				next
				oBrowse:refreshAll()
			case lSelect .and. lMultiSelect .and. nKey == 45		// "-" - ���� �⬥�� �롮�
				for each item in aArray
					item:checked := .f.
				next
				oBrowse:refreshAll()
				
			case nKey == K_F8						// ���஢�� �� ᢮���� ��ꥪ�
				if lMultiSelect
					columnPos := oBrowse:ColPos - 1
					cPropertyName := aProperties[ oBrowse:ColPos - 1, 1 ]
				else
					columnPos := oBrowse:ColPos
					cPropertyName := aProperties[ oBrowse:ColPos, 1 ]
				endif
				blk_Sort := createCodeBlockSort( cPropertyName, aSortProperty, columnPos )
				asort( aArray, , , blk_Sort )
				oBrowse:refreshAll()
//
			case nKey == K_ESC
				lCont := .f.
			case ( ( len( static_find ) > 0 .and. nKey == 32 ) ;
							.or. between( nKey, 33, 255 ) .or. nKey == K_BS ) ;
							.and. !equalany( nKey, 43, 45 ) // �� + � -
				FT_MHIDECRS( fl_mouse )
				oBrowse:goTop()
				if nKey == K_BS
					if len( static_find ) > 1
						static_find := left( static_find, len( static_find ) - 1 )
					else
						static_find := ''
					endif
				else
					if len( static_find ) < len_static
						static_find += upper( chr( nKey ) )
					endif
				endif
				put_static( buf_static, static_find, color_find )
				if !empty( static_find )
					tmp := len( static_find )
					&& if ( i := ascan( aArray, { | x | static_find <= searchSubstring( x, tmp ) } ) ) > 0
					if ( i := ascan( aArray, { | x | static_find <= searchSubstring( x:&( if( lMultiSelect, aProperties[ oBrowse:colPos - 1, 1 ], aProperties[ oBrowse:colPos, 1 ] ) ), tmp ) } ) ) > 0
						if i < COUNT-NSTR + 1
							oBrowse:goTop()
							nInd := i
							oBrowse:refreshAll()
							right_side( fl_rbrd, nInd, COUNT, nTop, nRight, NSTR )
						else
							oBrowse:goBottom()
							for tmp := COUNT-1 TO i STEP -1
								oBrowse:up()
							next
						endif
					else
						oBrowse:goBottom()
					endif
				endif
			case nKey != 0 .and. !empty( n_func )
				FT_MHIDECRS( fl_mouse )
				tmp := n_func + '(' + lstr( nKey ) + ',' + lstr( nInd ) + ')'
				if ( i := &tmp ) == 0         // �㭪�� ������ �������� 0 ���
					oBrowse:refreshAll()      // ���������� TBrowse, ���� -1 (��祣�)
				elseif i == 1               // ��� 1 ��� ��室� �� popup
					lCont := .f.
				endif
				nKey := 256
		endcase
	enddo
	if fl_mouse
		clear_mouse()
		FT_MHIDECRS()
	endif
	setcolor( tmp_color )
	if lMultiSelect
		for each item in aArray
			ll := item
			if item:checked
				aadd( aReturn, item )
			endif
		next
		return aReturn
	endif
	return if( nKey == K_ESC, 0, nInd )

***** ��४��祭�� ᢮��⢠ ��࠭���� ��ꥪ�
static procedure toggleChecked()

	if QSelf():checked
		QSelf():checked := .f.
	else
		QSelf():checked := .t.
	endif
	return

static function getChecked()
	local self := QSelf()
	return ::checked

***** �ନ஢���� ��������� ��� ����஥��� ��ꥪ� TColumn
static function createCodeBlock( aArray, cType, nLen, aTemp, nPos )
	local bCode
	if cType == 'N'
		bcode := { |  |
			return str( aArray[ nInd ]:&( aTemp[ nPos ] ), nLen )
		}
	else
		bcode := { |  |
			return aArray[ nInd ]:&( aTemp[ nPos ] )
		}
	endif
	return bCode

***** �ନ஢���� ��������� ��� ���஢�� �� ᢮���� ��ꥪ�
static function createCodeBlockSort( cPropertyName, aSortProperty, columnPos )
	local bCode

	if aSortProperty[ columnPos ] == nil .or. aSortProperty[ columnPos ] == .f.
		aSortProperty[ columnPos ] := .t.
		bcode := { | x, y |
			return ( x:&( cPropertyName ) < y:&( cPropertyName ) )
		}
	else
		aSortProperty[ columnPos ] := .f.
		bcode := { | x, y |
			return ( x:&( cPropertyName ) > y:&( cPropertyName ) )
		}
	endif
	return bCode
	
***** ���� �� ��砫�� �㪢��, �������� �஡��� � '*'
static function searchSubstring( s, k )
local i, j, c, ls

	if valtype( s ) == 'C'
		s := upper( s )
	elseif valtype( s ) == 'N'
		s := str( s )
	elseif valtype( s ) == 'D'
		s := dtos( s )
	endif
	for i := 1 to len( s )
		c := substr( s, i, 1 )
		if !eq_any( c, ' ', '*' )
			j := i ; exit
		endif
	next
	if j == nil
		j := 1
	endif
	ls := substr( s, j, k )
	return padr( ls, k )