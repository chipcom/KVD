#include "inkey.ch"
#include "..\_mylib_hbt\function.ch"
#include "..\_mylib_hbt\edit_spr.ch"
#include "chip_mo.ch"

***** проверить дату, по которую (включительно) запрещено редактировать данные
function ver_pub_date( ldate, is_msg )
	local is_public_date := .t.

	&& DEFAULT is_msg TO .f.
	if type( 'public_date' ) == 'D' .and. !empty( public_date ) ;
			.and. !empty( ldate ) .and. public_date >= ldate
		is_public_date := .f.
		if hb_DefaultValue( is_msg, .f. )
			func_error( 2, 'По ' + full_date( public_date ) + 'г. включительно данные закрыты для редактирования!' )
		endif
	endif
	return is_public_date

*****
function status_key_Row( nRow, cStr, cColor1, cColor2 )
	local out_str := '', out_arr := {}, i, j := 2, s

	hb_DEFAULT( @nRow, maxrow() )
	hb_DEFAULT( @cColor1, cColorStMsg )
	hb_DEFAULT( @cColor2, cColorSt2Msg )
	cStr := ' ' + cStr
	for i := 1 to numtoken( cStr, '^' )
		s := token( cStr, '^', i )
		if j == 1
			out_str += s ; aadd( out_arr, s ) ; j := 2
		else
			out_str += s ; j := 1
		endif
	next
	out_str := padc( alltrim( out_str ), maxcol() + 1 )
	@ nRow, 0 say out_str color cColor1
	for i := 1 to len( out_arr )
		if ( j := at( out_arr[ i ], out_str ) ) > 0
			@ nRow, j - 1 say out_arr[ i ] color cColor2
		endif
	next
	return nil
	