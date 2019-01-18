#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

*****
function f_10diag_bay( k )
	local buf := savescreen(), i := 1, c1 := 1, c2 := 77, msh_b, msh_e, arr_t, s, s1

	change_attr()
	do case
		case k == 1
			mywait()
			viewICD10()
		case k == 2
			viewICD10Class()
		case k == 3
			viewICD10Group()
	endcase
	restscreen(buf)
	return nil
