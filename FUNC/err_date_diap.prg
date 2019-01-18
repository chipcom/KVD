#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

*****
function err_date_diap( _ld, _ls )
	local fl := .t.
	
	if !empty( _ld )
		if !empty( mem_date_1 ) .and. _ld < mem_date_1
			fl := .f.
		endif
		if !empty( mem_date_2 ) .and. _ld > mem_date_2
			fl := .f.
		endif
		if !fl
			func_error( 4, 'Значение поля "' + _ls + '" выходит за допустимый диапазон времени!' )
		endif
	endif
	return fl
