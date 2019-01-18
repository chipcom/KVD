* EmployeeCompatible.prg - ࠡ�� � ���㤭����� �࣠����樨 ��� ᮢ���⨬���
*******************************************************************************
* 26.06.17 s_pl_meds( num ) - �-�� �����誠 ��� ᮢ���⨬���
* 17.06.17 put_tab_nom( ltab_nom, lsvod_nom )- �ନ஢���� ��ப� � ⠡���묨 ����ࠬ� ���㤭����
* 17.06.17 st_v_vrach( get, pole_vr, regim ) - ( ��� ᮢ���⨬��� )

#include 'hbthread.ch'
#include 'set.ch'
#include 'inkey.ch'

#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 26.06.17 - �-�� �����誠 ��� ᮢ���⨬���
function s_pl_meds( num )

	return nil

* 17.06.17 - �ନ஢���� ��ப� � ⠡���묨 ����ࠬ� ���㤭����
function put_tab_nom( ltab_nom, lsvod_nom )
	local s := lstr( ltab_nom )

	if !empty( lsvod_nom ) .and. ltab_nom != lsvod_nom
		s := '(' + lstr( lsvod_nom ) + ')' + s
	endif
	return s

* 17.06.17 ( ��� ᮢ���⨬��� )
function st_v_vrach( get, pole_vr, regim )
// regim = 0  - �� �� mo_pers
// regim = 1  - �������� �� �� plat_ms
// regim = 2  - ᠭ��ન �� �� plat_ms
// regim = 3  - �� �� mo_pers �१ VGET
	local lval, lpole, fl := .t.
	
	hb_Default( @regim, 0 )
	if regim == 3
		lval := get:varget()
		lpole := readvar()
	else
		lval := &(readvar())
		lpole := readvar()
	endif
	if lval == 0
		&pole_vr := space( 30 )
	elseif lval > 0
		if equalany( regim, 0, 3 )
			select PERSO
			find ( str( lval, 5 ) )
			if found()
				&pole_vr := padr( fam_i_o( perso->fio ), 30 )
			else
				fl := .f.
			endif
		else   // regim == 1 ��� 2
			select MS
			find ( str( regim, 1 ) + str( lval, 5 ) )
			if found()
				&pole_vr := padr( ms->fio, 30 )
			else
				fl := .f.
			endif
		endif
		if !fl
			//&lpole := get:original
			get:varput( get:original )
			hb_Alert( '����㤭��� � ⠪�� ����� ��� � �ࠢ�筨�� ���ᮭ���!', , , 4 )
			return .f.
		endif
	else
		//&lpole := get:original
		get:varput( get:original )
		hb_Alert( '�������⨬� ������� ����⥫쭮� �᫮!', , , 4 )
		return .f.
	endif
	if regim < 3
		update_get( pole_vr )
	endif
	return .t.

