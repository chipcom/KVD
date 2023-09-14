#include 'hbclass.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'

*****
function ListObjectsBrowse( cObjName, oBox, listObjects, nI,;
                      aProperties, bGetFunc, fl_ins_del, ;
                      func_step, cStatusString, oBrowseColorSpec, lSelect, lMultiSelect )
// cObjName - ��� ����� �࠭�饣��� � ᯨ᪥
// oBox - ��ꥪ� ����뢠�騩 ���� �뢮�� ᯨ᪠ ��ꥪ⮢
// listObjects  - ��ᬠ�ਢ���� (।����㥬�) ��㬥�� ���ᨢ
// nI - �� ����� ����� ����� �� �室� � ����
// aProperties - ��㬥�� ���ᨢ �뢮����� ᢮��� ��ꥪ⮢ ����:
//		{{�����⢠1, ����������⮫��1, �����1, ����-��� ��� ���᪨},
//		{ �����⢠2, ����������⮫��2, �����2, ����-��� ��� ���᪨},...}
// bGetFunc - ���� ���� ��� ।���஢���� � �ଥ :
//   bGetFunc := { | bGetFunc, oBrowse, listObjects, object, nKey| TestGet( bGetFunc, oBrowse, listObjects, object, nKey ) }
//   ����� bGetFunc - 㪠��⥫� �� ��ꥪ� TBrowse
//			oBrowse, 
//         listObjects      - 㪠��⥫� �� ᯨ᮪ ��ꥪ⮢
//		   object  - ��࠭�� ��ꥪ�
//         nKey    - ��� ����⮩ ������
//         TestGet - ��� �㭪樨 ।���஢����
// fl_ins_del - ���ᨢ �� ��� �����᪨� ����稭, ࠧ����� ���
//              �������� � ०��� ।���஢����:
//              1) ��⠢�� ��ப,
//              2) 㤠����� ��ப,
//              3) ।���஢���� ��ப�
//              4) ����஢���� ⥪�饣� ��ꥪ�
// func_step  - �㭪��, ��뢠���� �� ������ 蠣� TBrowse (�ᮢ����)
//              � ��� � ��।����� 1 ��ࠬ���:
//              1 - ⥪�騩 ��ꥪ� ᯨ᪠
// cStatusString - ⥪�⮢�� ��ப� � ����᭮� ��ப�
// oBrowseColorSpec - oBrowse:colorSpec
// lSelect - ����祭�� �⡮� ��ꥪ�(��) �� ᯨ᪠
// lMultiSelect - ����祭�� ����������� ������⢥����� �롮� ��ꥪ⮢
//
// ��� ���������� ���᪠ ����� � ᯨ᪥ ����室��� ��⠭����� � tbColumn:cargo ��� ��⮤� ��� �ࠢ�����

	local aViewProperty := {}, aSortProperty := {}, bBlock := ''
	local nTop, nLeft, nBottom, nRight
	local lCont := .T., nKey
	local i, j, NSTR, fl_edit := isblock( bGetFunc ) //( VALTYPE( bGetFunc ) == 'B' )
	local strMessage, oColumn, is_append := .f., fl_rbrd := .t., ;
		color_find, static_find := '', buf_static, len_static,;
		nsec := seconds(), period := 300

	local lengthList
	local locObject
	local tmpObject
	local item, ii, lFind
	local tmp
	local bFuncStep
	
	// arr_Browse - ���ᨢ ��� TBrowse:
	//              1 - oBrowse:headSep
	//              2 - oBrowse:colSep
	//              3 - oBrowse:footSep
	//              4 - oBrowse:colorSpec
	//              5 - ��ப� ᨬ�����, �� ��ࠡ��뢠���� �⠭����� ��ࠧ�� �� ���᪥ �� ��砫�� �㪢��
	local arr_Browse := array( 5 )
	local oBrowse
	local aMessage := { '^<Esc>^-��室', '^<Ins>^-����', ;
						'^<F4>^-�����', '^<Del>^-㤠�.', ;
						'^<Enter>^-।���஢����', '^<Enter>^-।���.', ;
						'^<Enter>^-�롮�', ;
						'^<F3>^-���.'	}
	local counter, aTemp
	local isHeader := .f.
	local cTypeProperty := '', lenProperty := 0
	local ret := nil
	
	local objectTemp := nil
	
	// insert 12/11/18
	if empty( listObjects )
		objectTemp:= &( cObjName )():New()
		aadd( listObjects, objectTemp )
	endif
	// end insert 12/11/18

	&& if ! empty( func_step )
		private parr := listObjects
	&& endif

	HB_Default( @nI, 1 ) 
	HB_Default( @fl_ins_del, { .f., .f., .f., .f. } ) 
	HB_Default( @func_step, '' ) 
	HB_Default( @cStatusString, '' ) 
	hb_default( @aProperties, {} )
	hb_default( @lSelect, .f. )
	hb_default( @lMultiSelect, .f. )
	
	if len( aProperties ) == 0	// �᫨ ���⮩ ���ᨢ �뢮����� ᢮���
		return 0
	endif
	
	if lSelect
		fl_edit := .f.
		bGetFunc := nil
		fl_ins_del := { .f., .f., .f., .f. }
	endif
	for counter := 1 to len( aProperties ) // ����稬 ����� �뢮����� ᢮��� ��ꥪ�
		aadd( aViewProperty, aProperties[ counter, 1 ] )
		aadd( aSortProperty, nil )
	next
	if lSelect .and. lMultiSelect
		for each item in listObjects			// ������塞 �������⥫쭮� ᢮��⢮ 'checked' � ��⮤ toggleChecked
			item := __objAddData( item, 'checked' )
			item:checked := .f.
			item := __objAddMethod( item, 'getChecked', @getChecked() )
			item := __objAddMethod( item, 'toggleChecked', @toggleChecked() )
		next
	endif
	
	nTop	:= oBox:Top
	nLeft	:= oBox:Left
	nBottom	:= oBox:Bottom
	nRight	:= oBox:Right
	
	if oBox:Frame == 1 .or. oBox:Frame == 3
		arr_Browse[ 1 ] := chr( 196 ) + chr( 194 ) + chr( 196 )
		arr_Browse[ 2 ] := ' � '
		arr_Browse[ 3 ] := chr( 196 ) + chr( 193 ) + chr( 196 )
	elseif oBox:Frame == 2 .or. oBox:Frame == 4
		arr_Browse[ 1 ] := '���'
		arr_Browse[ 2 ] := ' � '
		arr_Browse[ 3 ] := '���'
	endif
	if ! isnil( oBrowseColorSpec )
		arr_Browse[ 4 ] := oBrowseColorSpec
	endif
	arr_Browse[ 5 ] := '*+-'

	private last_k := 2
	private nInd := nI

	if ! empty( func_step ) .and. '(' $ func_step
		func_step := beforatnum( '(', func_step )
	endif

	lengthList := len( listObjects )
	// �஢�ਬ ���४⭮��� ��⠭���� �����
	nInd := if( nInd <= 0, 1, iif( nInd > lengthList, lengthList, nInd ) )
	
	if ! oBox:HasMessageLine
		strMessage := aMessage[ 1 ] + ' ' + aMessage[ 8 ]
		if lSelect
			strMessage += iif( lMultiSelect, ' ' + '^<Ins>^ ��⠭�����/���� �⬥��', '' )
			strMessage += iif( lMultiSelect, ' ' + '^<+/->^ ��� ���', '' )
			strMessage += ' ' + aMessage[ 7 ]
		else
			strMessage += iif( fl_ins_del[ 1 ], ' ' + aMessage[ 2 ], '' )
			strMessage += iif( fl_ins_del[ 4 ],  ' ' + aMessage[ 3 ], '' )
			strMessage += iif( fl_ins_del[ 2 ],  ' ' + aMessage[ 4 ], '' )
			if fl_ins_del[ 3 ]
				if len( strMessage ) + len( cStatusString ) < 57
					strMessage += ' ' + aMessage[ 5 ]
				elseif len( strMessage ) + len( cStatusString ) < 64
					strMessage += ' ' + aMessage[ 6 ]
				endif
			endif
			If fl_edit .and. ! empty( cStatusString )
				strMessage += ' ' + alltrim( cStatusString )
			endif
		endif
		oBox:MessageLine := strMessage
	endif
	oBox:View()
	
	oBrowse:= TBrowseNew( nTop + 1, nLeft + 1, nBottom, nRight - 1 )
	oBrowse:headSep := arr_Browse[ 1 ]
	oBrowse:colSep  := arr_Browse[ 2 ]
	oBrowse:footSep := arr_Browse[ 3 ]
	if arr_Browse[ 4 ] != nil
		oBrowse:colorSpec := arr_Browse[ 4 ]
	endif

	&& lRet := eval( bLayoutHeader, oBrowse, listObjects )		// ���������� �⮫�殢
	if !empty( listObjects )
		// �������� tbrowse �⮡ࠦ���묨 ���������
		if ( __objHasData( listObjects[ 1 ], 'checked' ) )		// ������� ��� �⮡ࠦ���� �⬥⪨ '*' �롮� ��ꥪ�
			oColumn := TBColumnNew( '', { | | if( listObjects[ nInd ]:checked, '*', ' ' ) } )
			oColumn:width := 1
			oBrowse:addColumn( oColumn )
		endif
		for counter := 1 to len( aProperties )
			aTemp := aProperties[ counter ]
			if alltrim( aTemp[ 2 ] ) != ''
				isHeader := .t.
			endif
			cTypeProperty := valtype( listObjects[ 1 ]:&( aViewProperty[ counter ] ) )
			lenProperty := aTemp[ 3 ]
			bBlock := createCodeBlock( listObjects, cTypeProperty, lenProperty, aViewProperty, counter )
			&& oColumn := TBColumnNew( center( aTemp[ 2 ], aTemp[ 3 ] ), bBlock )
			oColumn := TBColumnNew( aTemp[ 2 ], bBlock )
			oColumn:width := aTemp[ 3 ]
			
			if len( aTemp ) == 4		// 梥� �������
				oColumn:colorBlock := aTemp[ 4 ]
			endif
			oBrowse:addColumn(oColumn)
		next
	endif
	if isHeader
		if lSelect .and. lMultiSelect
			oBrowse:headSep := '���'
		else
			&& oBrowse:headSep := '���'
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
	
	// ������� ��� ��ப� ���᪠
	color_find := color_find( oBrowse:colorSpec )
	buf_static := save_box( nTop, nLeft, nTop, nRight )
	len_static := nRight - nLeft - 3
	
	if lSelect .and. lMultiSelect		// �᫨ ��࠭ ������⢥��� �⡮� ��३� ���ࠢ� � ����஧�� ���� �⮫���
		oBrowse:right()
		oBrowse:freeze := 1
	endif
	
	NSTR := oBrowse:rowCount
	nTop += nBottom - nTop - NSTR - 1
	
	if oBox:Frame == 1 .or. oBox:Frame == 3
		@ nTop, nLeft  say chr( 195 )
		@ nTop, nRight say chr( 180 )
	elseif oBox:Frame == 2 .or. oBox:Frame == 4
		@ nTop, nLeft  say '�'
		@ nTop, nRight say '�'
	endif
	
	if fl_edit
		fl_rbrd := ( !fl_ins_del[ 1 ] .and. !fl_ins_del[ 2 ] .and. !fl_ins_del[ 3 ] .and. !fl_ins_del[ 4 ] )
	endif
	if fl_rbrd .and. NSTR < lengthList .and. NSTR > 4
		@ nTop + 1, nRight say chr( 30 )
		@ nBottom - 1, nRight say chr( 31 )
		for i := nTop + 2 to nBottom - 2
			@ i, nRight say chr( 176 )
		next
		@ nTop + last_k, nRight say chr( 8 )
	else
		fl_rbrd := .f.
	endif
	
	oBrowse:goTopBlock := { | | nInd := 1, right_side( fl_rbrd, nInd, lengthList, nTop, nRight, NSTR ) }
	oBrowse:goBottomBlock := { | | nInd := lengthList, right_side( fl_rbrd, nInd, lengthList, nTop, nRight, NSTR ) }
	oBrowse:skipBlock := ;
		{ | nSkip, nVar |  nVar := nInd, ;
			nInd := IF( nSkip > 0, MIN( lengthList, nInd + nSkip ), MAX( 1, nInd + nSkip ) ), ;
			right_side( fl_rbrd, nInd, lengthList, nTop, nRight, NSTR ), nInd - nVar }

	if ( i := nInd ) > lengthList - NSTR
		oBrowse:goBottom()
		for tmp := lengthList - 1 TO i STEP -1
			oBrowse:up()
		next
	endif

	// �᫨ ᯨ᮪ ���� � ࠧ�襭� ���������� ����⮢ ��諥� ������� ����������
	&& if empty( listObjects ) .and. ( fl_ins_del[ 1 ] .or. fl_ins_del[ 4 ] ) .and. ! lSelect
	if ( ! isnil( objectTemp ) ) .and. ( fl_ins_del[ 1 ] .or. fl_ins_del[ 4 ] ) .and. ! lSelect
		KEYBOARD CHR( K_INS )
	endif
	
	do while lCont
		if nKey != 0 .and. !empty( listObjects )
			oBrowse:refreshCurrent()  // ��⠭�������� ⥪�饩 ��ப� �⠭����� 梥�
			oBrowse:forcestable()  // �⠡�������
			if !fl_edit .and. oBrowse:colCount > 1
			// �뤥����� 梥⮬ �ᥩ ⥪�饩 ��ப�
				i := 2
				if arr_Browse[ 4 ] != nil
					tmp := ( oBrowse:getColumn( 1 ) ):colorBlock
					i := eval( tmp )
					if valtype( i ) == 'A'
						i := i[ 2 ]
					else
						i := 2
					endif
				endif
				oBrowse:colorRect( { oBrowse:rowPos, 1, oBrowse:rowPos, oBrowse:colCount }, { i, i } )
				oBrowse:forcestable()  // �⠡�������
			endif
			if ! empty( func_step )
				tmp := &( func_step + '( parr[nInd] )' )
			endif
			
		endif
		
		nKey := INKEYTRAP()
		if nKey == 0
			if period > 0 .and. seconds() - nsec > period
				// �᫨ �� �ண��� ���������� [period] ᥪ., � ��� �� �㭪樨
				nKey := K_ESC
			endif
		else
			nsec := seconds()
		endif
		
		if nKey != 0
			tmpObject := oBrowse:getColumn( oBrowse:colPos )
			if ! isnil( tmpObject ) .and. ;
					!( ( ( ( len( static_find ) > 0 .and. nKey == 32 ) .or. between( nKey, 33, 255 ) ) .and. ( ! ( chr( nKey ) $ arr_Browse[ 5 ] ) ) ) .or. ;
					nKey == K_BS )
					// .and. !fl_edit ;
				static_find := ''
				rest_box( buf_static )
			endif
		endif
	
		do case
			case nKey == K_UP .or. nKey == K_SH_TAB
				oBrowse:up()
			case nKey == K_DOWN .or. nKey == K_TAB
				oBrowse:down()
			case nKey == K_RIGHT
				oBrowse:right()
			case nKey == K_LEFT
				// �᫨ ����祭 ������⢥��� �⡮� ��ꥪ⮢ �� ��ன ������� ᯨ᪠ ���室 �� �ࠢ� �� �ந�������
				if !( lSelect .and. lMultiSelect .and. oBrowse:colPos == 2 )
					oBrowse:left()
				endif
			case nKey == K_PGUP
				oBrowse:pageUp()
			case nKey == K_PGDN
				oBrowse:pageDown()
			case nKey == K_HOME .or. nKey == K_CTRL_PGUP .or. nKey == K_CTRL_HOME
				oBrowse:goTop()
			case nKey == K_END .or. nKey == K_CTRL_PGDN .or. nKey == K_CTRL_END
				oBrowse:goBottom()
			case lSelect .and. lMultiSelect .and. nKey == K_INS	// ���⠢��� �⬥�� �� �����
				listObjects[ nInd ]:toggleChecked()
				oBrowse:refreshAll()
			case lSelect .and. lMultiSelect .and. nKey == 43		// "+" - ���⠢��� �⬥�� �� �� ������
				for each item in listObjects
					item:checked := .t.
				next
				oBrowse:refreshAll()
			case lSelect .and. lMultiSelect .and. nKey == 45		// "-" - ���� �⬥�� �롮�
				for each item in listObjects
					item:checked := .f.
				next
				oBrowse:refreshAll()
			case nKey == K_F3						// ���஢�� �� ᢮���� ��ꥪ�
				&& if lMultiSelect
					&& columnPos := oBrowse:ColPos - 1
					&& cPropertyName := aProperties[ oBrowse:ColPos - 1, 1 ]
				&& else
					columnPos := oBrowse:ColPos
					cPropertyName := aProperties[ oBrowse:ColPos, 1 ]
				&& endif
				blk_Sort := createCodeBlockSort( cPropertyName, aSortProperty, columnPos )
				asort( listObjects, , , blk_Sort )
				oBrowse:refreshAll()
			&& case nKey != 0 .and. !empty( oBrowse:getColumn( oBrowse:colPos ):cargo ) .and. ;
					&& ( ( ( ( len( static_find ) > 0 .and. nKey == 32 ) .or. between( nKey, 33, 255 ) ) .and. !( chr( nKey ) $ arr_Browse[ 5 ] ) ) .or. nKey == K_BS ) ;
                    && .and. valtype( xtoc( __objSendMsg( listObjects[ oBrowse:rowPos ], oBrowse:getColumn( oBrowse:colPos ):cargo ) ) ) == 'C' //;
&& //                    .and. !fl_edit
				&& oBrowse:goTop()
				&& if nKey == K_BS
					&& if len( static_find ) > 1
						&& static_find := left( static_find, len( static_find ) - 1 )
					&& else
						&& static_find := ""
					&& endif
				&& else
					&& if len( static_find ) < len_static
						&& static_find += Upper( CHR( nKey ) )
					&& endif
				&& endif
				&& put_static( buf_static, static_find, color_find )
				&& if !empty( static_find )
					&& tmp := len( static_find )
					&& ii := 0
					&& lFind := .f.
					&& for each item in listObjects
						&& ii++
						&& if static_find == upper( left( xtoc( __objSendMsg( item, oBrowse:getColumn( oBrowse:colPos ):cargo ) ), tmp ) )
							&& lFind := .t.
							&& exit
						&& endif
					&& next
					&& if lFind
&& //						if ii < lengthList - NSTR + 1
&& //							oBrowse:goTop()
							&& nInd := ii
							&& oBrowse:refreshAll()
&& //						else
&& //							oBrowse:goBottom()
&& //							for tmp := lengthList - 1 TO i STEP -1
&& //								oBrowse:up()
&& //							next
&& //						endif
					&& else
&& //						oBrowse:goBottom()
						&& KEYBOARD CHR( K_BS )	// 㤠��� ��᫥���� �������� ᨬ���
					&& endif
				&& endif
// ����� ��������������
			case ! lSelect .and. nKey == K_INS .and. fl_ins_del[ 1 ] .and. fl_edit // ��⠢�� ��ப�
				If ( locObject:= &( cObjName )():New( ) ) != nil
					lRet := eval( bGetFunc, oBrowse, listObjects, locObject, K_INS )
					if lRet
						if ! isnil( objectTemp )
							listObjects[ 1 ] := locObject
							objectTemp := nil
						else
							aadd( listObjects, locObject )
						endif
						lengthList := len( listObjects )
						if ! empty( func_step )
							parr := listObjects
						endif
					endif
					oBrowse:refreshAll()
				endif
			case nKey == K_F4 .and. fl_ins_del[ 4 ] .and. fl_edit // ����஢���� ��ப�
				if ! empty( listObjects )
					if listObjects[ nInd ] != nil
						If ( locObject:= listObjects[ nInd ]:Clone() ) != nil
							lRet := eval( bGetFunc, oBrowse, listObjects, locObject, K_F4 )
							if lRet
								aadd( listObjects, locObject )
								lengthList := len( listObjects )
								if ! empty( func_step )
									parr := listObjects
								endif
							endif
							oBrowse:refreshAll()
						endif
					endif
				endif
			case lSelect .and. nKey == K_ENTER
				&& if lSelect
					lCont := .f.
			case ! lSelect .and. nKey == K_ENTER
				&& elseif fl_edit .and. fl_ins_del[ 3 ]
				if fl_edit .and. fl_ins_del[ 3 ]
					if ! empty( listObjects )
						locObject := listObjects[ nInd ]
						if ! isnil( locObject )
							lRet := eval( bGetFunc, oBrowse, listObjects, locObject, K_ENTER )
							if ( locObject == objectTemp ) .and. lRet
								objectTemp := nil
							endif
							oBrowse:refreshAll()
						endif
					endif
				endif
			&& case ! lSelect .and. nKey == K_ENTER .and. fl_ins_del[ 3 ] .and. fl_edit // ����஢���� ��ப�
			case ! lSelect .and. nKey == K_DEL .and. fl_ins_del[ 2 ] .and. fl_edit  //  㤠����� ��ப�
				locObject := listObjects[ nInd ]
				lRet := eval( bGetFunc, oBrowse, listObjects, locObject, K_DEL )
				if lRet
					listObjects := hb_adel( listObjects, nInd, .t. )
					// insert 12/11/18
					if empty( listObjects )
						objectTemp:= &( cObjName )():New()
						aadd( listObjects, objectTemp )
					endif
					// end insert 12/11/18
					lengthList := len( listObjects )
					if ! empty( func_step )
						parr := listObjects
					endif
					nInd := iif( nInd > lengthList, lengthList, nInd )
					oBrowse:refreshAll()
				endif
			case nKey == K_ESC
				if ! isnil( objectTemp )
					hb_adel( listObjects, 1, .t. )
					objectTemp := nil
				endif
				lCont := .f.
			case ( ( len( static_find ) > 0 .and. nKey == 32 ) ;
							.or. between( nKey, 33, 255 ) .or. nKey == K_BS ) ;
							.and. !equalany( nKey, 43, 45 ) // �� + � -
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
				if ! empty( static_find )
					if ( i := ascan( listObjects, { | obj | searchSubstring( obj:&( if( lMultiSelect, aProperties[ oBrowse:colPos - 1, 1 ], aProperties[ oBrowse:colPos, 1 ] ) ), len( static_find ) ) >= static_find } ) ) > 0
						if i < lengthList - NSTR + 1
							oBrowse:goTop()
							nInd := i
							oBrowse:refreshAll()
							right_side( fl_rbrd, nInd, lengthList, nTop, nRight, NSTR )
						else
							oBrowse:goBottom()
							for tmp := lengthList-1 TO i STEP -1
								oBrowse:up()
							next
						endif
					else
						oBrowse:goBottom()
					endif
				endif
			case ( nKey == K_SH_F2 .or. nKey == 256 + K_SH_F2 ) .and. fl_edit
			case nKey != 0 .and. fl_edit  // ।���஢���� ����� ���ᨢ�
//				IF between( nKey, 33, 249 ) .and. CHR( nKey ) != ";"
//					KEYBOARD CHR( nKey )
//				endif
////				if eval( bGetFunc, oBrowse, listObjects, oBrowse:colPos, nInd, nKey )
				&& if eval( bGetFunc, oBrowse, listObjects, If( nInd == 0, Nil, listObjects[ nInd ] ), nInd, nKey )
					&& is_append := .f.
				&& endif
				 // �� �� ��砩, �᫨ ��������� ࠧ��� ���ᨢ�
				if len( listObjects ) != 0
					locObject := listObjects[ nInd ]
					eval( bGetFunc, oBrowse, listObjects, locObject, nKey )
				endif
				lengthList := len( listObjects )
		endcase
	enddo
	if lSelect
		if lMultiSelect
			ret := {}
			for each item in listObjects
				if item:checked
					aadd( ret, item )
				endif
			next
		else
			ret := iif( nKey == K_ESC, nil, listObjects[ nInd ] )
		endif
	else
		// �����頥� nil
		ret := nil
	endif
	return ret

***** �ନ஢���� ��������� ��� ����஥��� ��ꥪ� TColumn
static function createCodeBlock( aArray, cType, nLen, aTemp, nPos )
	local bCode
	if isnumber( cType )
		bcode := { |  |
			return str( aArray[ nInd ]:&( aTemp[ nPos ] ), nLen )
		}
	elseif isdate( cType )
		bcode := { |  |
			return dtoc( aArray[ nInd ]:&( aTemp[ nPos ] ) )
		}
	else
		bcode := { |  |
			return aArray[ nInd ]:&( aTemp[ nPos ] )
		}
	endif
	return bCode

* �ନ஢���� ��������� ��� ���஢�� �� ᢮���� ��ꥪ�
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

* ��४��祭�� ᢮��⢠ ��࠭���� ��ꥪ�
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

* ���� �� ��砫�� �㪢��, �������� �஡��� � '*'
static function searchSubstring( valFromList, lengthSearchVal )
	local i, j, char, ls

	if ischaracter( valFromList )
		valFromList := upper( valFromList )
	elseif isnumber( valFromList )
		valFromList := str( valFromList )
	elseif isdate( valFromList )
		valFromList := dtos( valFromList )
	endif
	for i := 1 to len( valFromList )
		char := substr( valFromList, i, 1 )
		if ! eq_any( char, ' ', '*' )
			j := i
			exit
		endif
	next
	if j == nil
		j := 1
	endif
	ls := substr( valFromList, j, lengthSearchVal )
	return padr( ls, lengthSearchVal )