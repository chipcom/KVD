* ReportFunc.prg - функции для составления отчетов в HTML
*******************************************************************************
* 08.05.17 MethodOfPaymentForServices( nRow, nColumn, ret_arr ) - выбрать способы оплаты услуг
* 08.05.17 HeaderOfSelectedPaymentMethods( k, a_dms ) - собрать строку для вывода по способам оплаты
* 08.05.17 titleSubdivisionForHTML( arr_o ) - сформировать строку вывода отделений в отчет
* 08.05.17 titleDepartmentForHTML( arr_u, arr_m ) - сформировать строку вывода подразделений в отчет
* 26.05.17 QueryDataForTheReport( lMethodPayment, lPeriod, lSelectDepartment, lOnlyDepartment, lOrthopedics ) - 
*									запрос данных для составления отчетов
***************************************************

#include "hbhash.ch" 
#include "hbthread.ch"
#include "inkey.ch"
#include "function.ch"
#include "chip_mo.ch"
#include "set.ch"
#include "edit_spr.ch"

#require "hbtip"

static menu_kb_orto := {	{ 'платный    ', OU_PLAT }, ;
						{ 'бесплатный ', OU_B_PLAT }, ;
						{ 'взаимозачет', OU_PR_VZ }, ;
						{ 'ДМС        ', OU_D_SMO } }
static menu_kb_paid := {	{ 'платный', PU_PLAT }, ;
						{ 'ДМС    ', PU_D_SMO }, ;
						{ 'в/зачет', PU_PR_VZ } }

* 08.05.17 выбрать способы оплаты услуг
* битовый вариант
function MethodOfPaymentForServices( nRow, nColumn, ret_arr, lOrthopedics )
//	static sast := { .t., .f., .f. }
	local i, j, a, out_arr
	local sast := if( lOrthopedics, { .t., .f., .f., .f. }, { .t., .f., .f. } )
	local menu_kb
	
	if lOrthopedics
		menu_kb := aclone( menu_kb_orto )
	else
		menu_kb := aclone( menu_kb_paid )
	endif
	for i := 1 to len( menu_kb )
		menu_kb[ i, 1 ] := win_ANSIToOEM( menu_kb[ i, 1 ] )
	next
	
	HB_Default( @nRow, T_ROW ) 
	HB_Default( @nColumn, T_COL + 5 )
	if ( a := bit_popup( nRow, nColumn, menu_kb, sast ) ) != nil
		out_arr := {} ; afill( sast, .f. )
		for i := 1 to len( a )
			aadd( out_arr, a[ i, 2 ] )
			if ( j := ascan( menu_kb, { | x | x[ 2 ] == a[ i, 2 ] } ) ) > 0
				sast[ j ] := .t.
			endif
		next
		if len( a ) == 1
			if a[ 1, 2 ] == PU_D_SMO  // добр.страхование
				ret_arr := ret_arr_dms( nRow, nColumn )
			elseif a[ 1, 2 ] == PU_PR_VZ  // взаимозачет
				ret_arr := ret_arr_vz( nRow, nColumn )
			endif
		endif
	endif
	return out_arr

*****
* 08.05.17 собрать строку для вывода по способам оплаты
function HeaderOfSelectedPaymentMethods( k, a_dms, lOrthopedics )
	local ret := '', menu_kb
	local i, s

	if lOrthopedics
		menu_kb := menu_kb_orto
	else
		menu_kb := menu_kb_paid
	endif
	s := if( len( k ) > 0, '[ ', '' )
	if len( k ) <= 3
		for i := 1 to len( k )
			s += alltrim( inieditspr( A__MENUVERT, menu_kb, k[ i ] ) ) + ", "
		next
		s := substr( s, 1, len( s ) - 2 ) + " ]"
		if len( k ) == 1 .and. valtype( a_dms ) == "A"
			if k[ 1 ] == PU_D_SMO  // добр.страхование
				if len( a_dms ) == 1
					s := s + 'ДСМО: ' + alltrim( inieditspr( A__POPUPMENU, dir_server + 'p_d_smo', a_dms[ 1 ] ) )
				endif
			elseif k[ 1 ] == PU_PR_VZ  // взаимозачет
				if len( a_dms ) == 1
					s := s + 'Предприятие: ' + alltrim( inieditspr( A__POPUPMENU, dir_server + 'p_pr_vz', a_dms[ 1 ] ) )
				endif
			endif
		endif
	endif
	ret := s
	return ret
	
*****
* сформировать строку вывода отделений в отчет
function titleSubdivisionForHTML( arr_o )
	Local ret := ''
	
	aeval( arr_o, { | x | ret += win_OEMToANSI( alltrim( x:Name() ) + ', ' ) } )
	ret := substr( ret, 1, len( ret ) - 2 )
	return ret

*****
* сформировать строку вывода подразделений в отчет
function titleDepartmentForHTML( arr_u, arr_m )
	Local ret := ''
	local numDepartments := TDepartmentDB():NumberOfDepartments( arr_m[ 5 ], arr_m[ 6 ] )

	if numDepartments > 1
		if numDepartments == len( arr_u )
			ret := '[ по всем учреждениям ]'
		else
			aeval( arr_u, { | x | ret += win_OEMToANSI( alltrim( x:Name() ) + ', ' ) } )
			ret := substr( ret, 1, len( ret ) - 2 )
		endif
	endif
	return ret
	
* 26.05.17 запрос данных для составления отчетов
function QueryDataForTheReport( lMethodPayment, lPeriod, lSelectDepartment, lOnlyDepartment, lOrthopedics )
	local aHash
	local s, arr_dms
	local aSelectedDepartment := nil, aSelectedSubdivision := nil
	local aPaymentMethods
	
	hb_default( @lOrthopedics, .f. )
	aHash := hb_Hash()
	hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
	
	if hb_defaultValue( lMethodPayment, .t. )
		if ( aPaymentMethods := MethodOfPaymentForServices( T_ROW, T_COL - 5, @arr_dms, lOrthopedics ) ) != nil
			hb_hSet(aHash, 'PAYMENTMETHODS', aPaymentMethods )
			s := HeaderOfSelectedPaymentMethods( aPaymentMethods, arr_dms, lOrthopedics )
			hb_hSet(aHash, 'STRINGFORPRINT', s )
		else
			return nil
		endif
	endif
	
	if hb_defaultValue( lPeriod, .t. )
		if ( aSelectedPeriod := year_month() ) == nil
			return nil
		else
			hb_hSet(aHash, 'SELECTEDPERIOD', aSelectedPeriod )
		endif
	endif

	if hb_defaultValue( lSelectDepartment , .t. )
		if hb_defaultValue( lOnlyDepartment , .f. )
			if !empty( aSelectedDepartment := MultipleSelectedDepartment( T_ROW, T_COL - 5, aSelectedPeriod[ 5 ], aSelectedPeriod[ 6 ] ) )
				hb_hSet(aHash, 'SELECTEDDEPARTMENT', aSelectedDepartment )
			else
				return nil
			endif
		else
			if hb_user_curUser:IsAdmin()
				if !empty( aSelectedDepartment := MultipleSelectedDepartment( T_ROW, T_COL - 5, aSelectedPeriod[ 5 ], aSelectedPeriod[ 6 ] ) )
					hb_hSet(aHash, 'SELECTEDDEPARTMENT', aSelectedDepartment )
				else
					return nil
				endif
			else
				if !empty( aSelectedSubdivision := MultipleSelectedSubdivision( T_ROW, T_COL-5, X_PLATN, aSelectedPeriod[ 5 ], aSelectedPeriod[ 6 ] ) )
					hb_hSet(aHash, 'SELECTEDSUBDIVISION', aSelectedSubdivision )
				else
					return nil
				endif
			endif
		endif
	endif
	return aHash