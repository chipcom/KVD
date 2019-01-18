#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
&& #include 'f_fr.ch'
#include 'f_fr_bay.ch'

#define _KO_K_OPL      6  // итого к оплате по всему наряду
#define _KO_OPL        7  // уже оплачено
#define _KO_DOPL       8  // доплатить
#define _KO_SUMMA      9  // платная сумма наряда
#define _KO_O_SUMMA   10  // общая сумма за день
#define _KO_CENA      11  // сумма оплаты
#define _KO_SUMMA_NAR 12  // общая сумма наряда
#define _KO_LEN       12

***** 11.05.14
function yes_o_chek( /*@*/vsum, /*@*/vsd, /*@*/s, /*@*/vbank )
	local fl := .f., tmp_color, buf := savescreen(), r := 14, a[ 3 ], ;
		j, spict := '999999.99'
		
	change_attr()
	
	if GetSetKKT():EnableTypePay2()
	
		tmp_color := setcolor( cDataCGet )
		private vnos_summa := 0, bank_summa := 0
		p_summa := s[_KO_DOPL]
		do while .t.
		
			buf := box_shadow( r, 6, r + 8, 73 )
			buf24 := save_maxrow()
			@ r + 1, 8 say 'Итоговая сумма наряда ' get s[ _KO_K_OPL ] picture spict when .f.
			@ r + 2, 8 say 'Сумма предыдущих оплат' get s[ _KO_OPL ] picture spict when .f.
			@ r + 3, 8 say 'Следует доплатить     ' get s[ _KO_DOPL ] picture spict when .f. color 'G+/B'
			@ r + 4, 8 say 'Сумма оплаты          ' get p_summa picture spict ;
				valid iif( s[ _KO_DOPL ] > 0, p_summa > 0 .and. p_summa <= s[ _KO_DOPL ], .t. )
				
			@ r + 5, 8 say '-------------------------------------------------------------'
			@ r + 6, 8 say 'Введите вносимую сумму (для подсчета сдачи)       ' ;
				get vnos_summa picture spict ;
				valid { | g | val_y_chek( g, .F. ) }
			@ r + 7,8 say 'Сумма, вносимая безналичными (по банковской карте)' ;
				get bank_summa picture spict ;
				valid { | g | val_y_chek( g, .T. ) } ;
				when round_5( vnos_summa, 2 ) < p_summa
				
			status_key( '^<Esc>^ - выход без записи чека;  ^<PgDn>^ - запись чека' )
			myread()
			
			j := f_alert( { padc( 'Выберите действие', 60, '.' ) }, ;
                { ' Выход без записи ', ' Печать чека ', ' Возврат в редактирование ' }, ;
                iif( lastkey() == K_ESC, 1, 2 ), 'W+/N', 'N+/N', maxrow() - 2, , 'W+/N, N/BG' )
				
			if j == 1
				exit
			elseif j == 3
				loop
			endif
			
			if round_5( bank_summa, 2 ) > 0 .and. lastkey() != K_ESC .and. !f_Esc_Enter( 'оплаты по карте' )
				rest_box( buf )
				rest_box( buf24 )
				loop
			endif
			
			rest_box( buf )
			rest_box( buf24 )
			s[ _KO_CENA ] := p_summa
			
			if vnos_summa >= p_summa
				a[ 1 ] := vnos_summa
				a[ 2 ] := p_summa
				a[ 3 ] := round_5( vnos_summa - p_summa, 2 )
				IncomeCashBayer( a )
				fl_sdacha := .t.
				vsum := a[ 1 ] ; vsd := a[ 3 ] ; vbank := 0
			else
				a[ 1 ] := vnos_summa
				a[ 2 ] := bank_summa
				a[ 3 ] := p_summa
				IncomeCashBayer( a, .T. )
				fl_sdacha := .f.
				vsum := vnos_summa ; vsd := 0 ; vbank := bank_summa
			endif
			
			fl := .t.
			exit
			
		enddo
		setcolor( tmp_color )
	else
		tmp_color := setcolor( cDataCGet )
		buf := box_shadow( r, 6, r + 7,73 )
		buf24 := save_row( maxrow() )
		
		private vnos_summa := 0, mkocena := s[ _KO_DOPL ]
		
		@ r + 1, 8 say 'Итоговая сумма наряда ' get s[ _KO_K_OPL ] picture spict when .f.
		@ r + 2, 8 say 'Сумма предыдущих оплат' get s[ _KO_OPL ] picture spict when .f.
		@ r + 3, 8 say 'Следует доплатить     ' get s[ _KO_DOPL ] picture spict when .f. color 'G+/B'
		@ r + 4, 8 say 'Сумма оплаты          ' get mkocena picture spict ;
			valid iif( s[ _KO_DOPL ] > 0, mkocena > 0 .and. mkocena <= s[ _KO_DOPL ], .t. )
		@ r + 5, 8 say '------------------------------------------------------'
		@ r + 6, 8 say 'Введите вносимую сумму (для подсчета сдачи)' get vnos_summa picture spict ;
			valid iif( empty( vnos_summa ), .t., mkocena <= vnos_summa )
			
		status_key( '^<Esc>^ - выход без записи чека;  ^<Enter>^ - запись и печать чека' )
		myread()
		restscreen()
		setcolor( tmp_color )
		if lastkey() != K_ESC
			s[ _KO_CENA ] := p_summa := mkocena
			if vnos_summa > 0
				a[ 1 ] := vnos_summa
				a[ 2 ] := p_summa
				a[ 3 ] := round_5( vnos_summa - p_summa, 2 )
				IncomeCashBayer( a )
				fl_sdacha := .t.
				vsum := a[ 1 ] ; vsd := a[ 3 ] ; vbank := 0
			endif
			fl := .t.
		endif
	endif
	return fl


function IncomeCashBayer( aMessage, typeMessage, cBorderColor, cBoxColor, nStartRow )
// typeMessage тип сообщения, .F. - без банка, .T. - с банком
// aMessage - массив с данными
// cBorderColor - строка цвета для рамки
// cBoxColor - строка цвета для текста
// nStartRow - верхний ряд рамки (99 - центрировать)

	HB_Default( @typeMessage, .F. ) 
	HB_Default( @cBorderColor, 'W+/RB,W+/N,,,B/W' ) 
	HB_Default( @cBoxColor, 'W+/RB,W+/N,,,B/W' ) 
	HB_Default( @nStartRow, 99 ) 
	
	if typeMessage
		f_message( { 'Сумма наличными: ' + str( aMessage[ 1 ], 10, 2 ), ;
			'Сумма по карте : ' + str( aMessage[ 2 ], 10, 2 ), ;
			'Сумма чека     : ' + str( aMessage[ 3 ], 10, 2 ) }, , ;
			cBorderColor, cBoxColor, nStartRow )
	else
		f_message( { 'Вносимая сумма: ' + str( aMessage[ 1 ], 10, 2 ), ;
			'Сумма чека    : ' + str( aMessage[ 2 ], 10, 2 ), ;
			'──────────────────────────', ;
			'Сумма сдачи   : ' + str( aMessage[ 3 ], 10, 2 ) }, , ;
			cBorderColor, cBoxColor, nStartRow )
	endif
	return nil
	
***** 11.05.14
 function val_y_chek( get, lBank )
// lBank - носимая сумма .T. - банковской картой, .F. - наличными

	if !lBank	 // сумма наличными
		vnos_summa := round_5( vnos_summa, 2 )
		if ( vnos_summa < p_summa )
			bank_summa := round_5( p_summa - vnos_summa, 2 )
		else
			bank_summa := 0
		endif
	else       // сумма безналичными
		bank_summa := round_5( bank_summa, 2 )
		if bank_summa > p_summa
			hwg_MsgInfoBay( 'Сумма, вносимая безналичными, не может быть больше суммы к оплате!', 'ОШИБКА' )
			bank_summa := p_summa
		elseif ( bank_summa > 0 )
			vnos_summa := round_5( p_summa - bank_summa, 2 )
		else
			bank_summa := 0
			if round_5( vnos_summa, 2 ) < p_summa
				vnos_summa := p_summa
			endif
		endif
	endif
	return update_gets()