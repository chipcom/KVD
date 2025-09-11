*******************************************************************************
*          Po_statist() - �������� �-� ���� ����⨪�

#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

Function Po_proverka(k)
	hb_Alert( '�� ॠ��������!', , , 4 )
return nil

Function oplata_vz()
	hb_Alert( '�� ॠ��������!', , , 4 )
return nil

// 27.03.23
Function Po_statist(k)
	Static si1 := 1, si2 := 1, si3 := 1, si4
	Local uch_otd, mas_pmt, mas_msg, mas_fun, j
	Private p_net_otd := .t.
	DEFAULT k TO 1
	
//��������
//Private COUNT_UCH := 1
	do case
		case k == 1
			uch_otd := saveuchotd()
			mas_pmt := {"~��ꥬ ࠡ��",;
						"�� � ~���⠭樮���� ������",;
						"�� ~���ࠢ��襬� ����",;
						"��� � ~����������",;
						"~������⢥��� �����",;
						"~������� ���������",;
						"~��ୠ� �������樨",;
						"����ࠨ����� ��ୠ� ~�������樨",; //21.05.08
						"�� ��� �ਥ�� ~�����";
						}
			mas_msg := {"����⨪� �� ��ꥬ� ࠡ�� ���ᮭ��� (�� ��� ����砭�� ��祭��)",;
						"����⨪� �� ��ꥬ� ࠡ�� (�� ������ ���⠭樮���� ������)",;
						"����⨪� �� ���ࠢ��訬 ��砬",;
						"���-�� � ������ (� ���ᮭ���), ����� ��稫��� (ࠡ�⠫�) �� ��� � ���������.",;
						"������⢥��� �����",;
						"������� ��������� �� ��ꥬ� ࠡ�� ���ᮭ��� [�� �ᥬ ����砬]",;
						"��ୠ� ॣ����樨 ������஢",;
						"����ࠨ����� ��ୠ� �������樨",; //21.05.08
						"�� ��� �ਥ�� �����";
						}
			mas_fun := {"Po_statist(11)",;
						"Po_statist(12)",;
						"Po_statist(13)",;
						"Po_statist(14)",;
						"Po_statist(15)",;
						"Po_statist(16)",;
						"Po_statist(18)",;
						"Po_statist(19)",;
						"Po_statist(17)";
						}
						
			popup_prompt(T_ROW,T_COL-5,si1,mas_pmt,mas_msg,mas_fun)
			restuchotd(uch_otd)
		case k == 11
			Pob_statist()
		case k == 12
			k_statist(1)
		case k == 13
			mas_pmt := {"~��� + ���-�� ������",;
						"��� + ~��㣨"}
			mas_msg := {"����⨪� �� ���ࠢ��訬 ��砬 � �����⮬ ������⢠ ������",;
						"����⨪� �� ���ࠢ��訬 ��砬 � ����஢��� �� ��㣠�"}
			mas_fun := {"Po_statist(31)",;
						"Po_statist(32)"}
			popup_prompt(T_ROW,T_COL-5,si3,mas_pmt,mas_msg,mas_fun)
			
		case k == 14
			mas_pmt := {"~����� �� ��� � �����������",;
						"~����� �� ��� � �����������",;
						"����⭠� ��~�������",;
						"~��� �� ��� � �����������"}
			mas_msg := {"���ଠ�� � ������, ����� ��稫��� �� ��� � �����������",;
						"���ଠ�� � ���⥦�� �� �।���⨩ �� ��� � �����������",;
						"����祭�� ������� �������⥩ �� ��� � �����������",;
						"���ଠ�� � ����, ����� ࠡ�⠫� �� ��� � �����������"}
			mas_fun := {"Po_statist(21)",;
						"Po_statist(22)",;
						"Po_statist(23)",;
						"Po_statist(24)"}
			if is_oplata != 7
				aadd(mas_pmt,"~�������� �� ��� � �����������")
				aadd(mas_pmt,"~�����ન �� ��� � �����������")
				aadd(mas_msg,"���ଠ�� � ��������, ����� ࠡ�⠫� �� ��� � �����������")
				aadd(mas_msg,"���ଠ�� � ᠭ��ઠ�, ����� ࠡ�⠫� �� ��� � �����������")
				aadd(mas_fun,"Po_statist(25)")
				aadd(mas_fun,"Po_statist(26)")
			endif
			
			popup_prompt(T_ROW,T_COL-5,si2,mas_pmt,mas_msg,mas_fun)
		case k == 15
			pl_mnog_poisk()
		case k == 16
			// sv_ved_plat()
			ne_real()
		case k == 17
			pl1_priemden()
		case k == 18
			&& pl_pl_dogovor()
			ReportLogBook()
		case k == 19
			pl_pl_2dogovor()
****************************
		case eq_any(k,21,24,25,26)
			DEFAULT si4 TO glob_close+1
			mas_pmt := {"�� ��� ~����砭�� ��祭��",;
						"�� ��� ~������� �/���"}
			if (j := popup_prompt(T_ROW,T_COL-5,si4,mas_pmt)) > 0
				si4 := j
				Private pi1 := si4+1
				if k == 21
					pl_vzaimozach()
				else
					vr_vzaimozach(k-23)
				endif
			endif
		case k == 22
			pr_opl_vz()
		case k == 23
			ob_ved_vz()
****************************
		case k == 31
			&& pl_napr_vrach()
			ReportDispatchersAndPatients()
		case k == 32
			&& pl_napr2vrach()
			ReportDispatchersAndServices()
	endcase
	if k > 10
		j := int(val(right(lstr(k),1)))
		if between(k,11,19)
			si1 := j
		elseif between(k,21,29)
			si2 := j
		elseif between(k,31,39)
			si3 := j
		endif
	endif
	
	return nil

************************ ��ꥬ ࠡ�� ���ᮭ��� *******************************

*****
Function Pob_statist()
	Static si
	Local mas_pmt := {"��ꥬ ࠡ�� (�� ��� ~��祭��)",;
					"��ꥬ ࠡ�� (�� ��� ~����砭�� ��祭��)",;
					"��ꥬ ࠡ�� (�� ��� ~������� �/���)"}
	Local mas_msg := {"����⨪� �� ��ꥬ� ࠡ�� ���ᮭ��� (�� ��� ��祭��)",;
					"����⨪� �� ��ꥬ� ࠡ�� ���ᮭ��� (�� ��� ����砭�� ��祭��)",;
					"����⨪� �� ��ꥬ� ࠡ�� ���ᮭ��� (�� ��� ������� ���� ���)"}
	Local mas_fun := {"Pob1_statist(0,1)",;
					"Pob1_statist(0,2)",;
					"Pob1_statist(0,3)"}
	Private pi1 := si, psz
	DEFAULT si TO glob_close+2
	
	popup_prompt(T_ROW,T_COL-5,si,mas_pmt,mas_msg,mas_fun)
	if pi1 != nil ; si := pi1 ; endif
	return nil

***** ��ꥬ ࠡ�� ���ᮭ���
Function Pob1_statist(k,k1)
	Static si0 := 1, si1 := 1, si2 := 1, si3 := 1, si4 := 1, si5 := 1, si_slugba
	Local mas_pmt, mas_msg, mas_fun, j, fl
	
	do case
		case k == 0
			pi1 := k1
			mas_pmt := {"~�⮨����� ��祭��",;
						"~��ࠡ�⭠� ����"}
			mas_msg := {"����⨪� �� ��ꥬ� ࠡ�� � �����⮬ �⮨���� ��祭��",;
						"����⨪� �� ��ꥬ� ࠡ�� � �����⮬ ��ࠡ�⭮� �����"}
			mas_fun := {"Pob1_statist(1,1)",;
						"Pob1_statist(1,2)"} //
						
			popup_prompt(T_ROW,T_COL-5,si0,mas_pmt,mas_msg,mas_fun,color0+",R/BG,GR+/N")
		case k == 1
			psz := si0 := k1
			mas_pmt := {"~�⤥�����",;
					"~��㦡�",;
					"~���ᮭ��",;
					"~��㣨"}
			mas_msg := {"����⨪� �� ࠡ�� ���ᮭ��� � �������� ��㣠� � �⤥������",;
					"������⢮ ��� � �㬬� ��祭�� �� �㦡��",;
					"����⨪� �� ࠡ�� ���ᮭ��� (������ᨬ� �� �⤥�����)",;
					"����⨪� �� �������� �������� ��� (������ᨬ� �� �⤥�����)"}
			mas_fun := {"Pob1_statist(11)",;
					"Pob1_statist(12)",;
					"Pob1_statist(13)",;
					"Pob1_statist(14)"}
					
			popup_prompt(T_ROW-len(mas_pmt)-3,T_COL-5,si1,mas_pmt,mas_msg,mas_fun)
		case k == 11  // �⤥�����
			mas_pmt := {"~���᮪ �⤥�����",;
					"�⤥����� + ~���ᮭ��",;
					"�⤥����� + ~��㣨",;
					"~�⤥����� + ���ᮭ�� + ��㣨",;
					"�⤥����� + ��㣠 + ~�����",;
					"�⤥����� + ~1 祫���� + �����",;
					"�⤥����� + ����� + ��㣨",;
					"����� �� ��~�������"}
			mas_msg := {"������⢮ ��� � �㬬� ��祭�� �� �⤥�����",;
					"����⨪� �� ࠡ�� ���ᮭ��� � �����⭮� �⤥�����",;
					"����⨪� �� ��㣠�, �������� � �����⭮� �⤥�����",;
					"����⨪� �� ࠡ�� ���ᮭ��� (���� �������� ��㣨) � �����⭮� �⤥�����",;
					"����⨪� �� ��������� ��㣥 (���� �����) � �����⭮� �⤥�����",;
					"����⨪� �� ࠡ�� 1 祫����� (���� �����) � �����⭮� �⤥�����",;
					"����⨪� �� ࠡ�� ���ᮭ��� �� ������ �⤥������",;
					"���᮪ ������ � �㬬��� ��祭�� � ������ �� �⤥�����"}
			mas_fun := {"Pob1_statist(21)",;
					"Pob1_statist(22)",;
					"Pob1_statist(23)",;
					"Pob1_statist(24)",;
					"Pob1_statist(25)",;
					"Pob1_statist(26)",;
					"Pob1_statist(27)",;
					"Pob1_statist(28)"}
					
			popup_prompt(T_ROW,T_COL-5,si2,mas_pmt,mas_msg,mas_fun)
		case k == 12  // �㦡�
			mas_pmt := {"��㦡� + ~�⤥�����",;
						"��㦡� + ~��㣨",;
						"��㦡~� + ��㣨"}
			mas_msg := {"������⢮ ��� � �㬬� ��祭�� �� �㦡�� (� ࠧ������ �� �⤥�����)",;
						"����⨪� �� �������� ��㣠� (� ��ꥤ������� �� �㦡��)",;
						"����⨪� �� �������� ��㣠� (�� �����⭮� �㦡�)"}
			mas_fun := {"Pob1_statist(31)",;
						"Pob1_statist(32)",;
						"Pob1_statist(33)"}
			
			popup_prompt(T_ROW,T_COL-5,si3,mas_pmt,mas_msg,mas_fun)
		case k == 13  // ���ᮭ��
			mas_pmt := {"1 祫���� + ~��㣨",;
						"~1 祫���� + ��㣨 + �����",;
						"~���� ���ᮭ��",;
						"~���᮪ ���ᮭ��� + ��㣨",;
						"~����� + ���ᮭ��"}
			mas_msg := {"����⨪� �� ࠡ�� �����⭮�� ࠡ���饣� (���� �������� ��㣨)",;
						"����⨪� �� ࠡ�� �����⭮�� ࠡ���饣� (���� ��㣨 ���� �����)",;
						"������⢮ ��� � �㬬� ��祭�� �� �ᥬ� ᯨ�� ࠡ�����",;
						"����⨪� �� ࠡ�� �������� ࠡ����� (���� �������� ��㣨)",;
						"���᮪ ������ � ࠧ������ �㬬 ��祭�� �� ������� ���� (�/����, ᠭ��થ)"}
			mas_fun := {"Pob1_statist(41)",;
						"Pob1_statist(42)",;
						"Pob1_statist(43)",;
						"Pob1_statist(44)",;
						"Pob1_statist(45)"}
						
			if is_oplata != 7
				aadd(mas_pmt,"~��������")
				aadd(mas_pmt,"�~����ન")
				aadd(mas_msg,"���᮪ ������� � ��ࠡ�⠭�묨 �㬬���")
				aadd(mas_msg,"���᮪ ᠭ��ப � ��ࠡ�⠭�묨 �㬬���")
				aadd(mas_fun,"Pob1_statist(46)")
				aadd(mas_fun,"Pob1_statist(47)")
			endif
			popup_prompt(T_ROW,T_COL-5,si4,mas_pmt,mas_msg,mas_fun)
		case k == 14  // ��㣨
			mas_pmt := {"~���᮪ ���",;
						"�� ~��㣨",;
						"���᮪ ���+~�����"}
			mas_msg := {"����⨪� �� �������� �������� ��� (������ᨬ� �� �⤥�����)",;
						"����⨪� �� �������� ��� ��� (������ᨬ� �� �⤥�����)",;
						"����⨪� �� �������� �������� ��� [� ����묨] (������ᨬ� �� �⤥�����)"}
			mas_fun := {"Pob1_statist(51)",;
						"Pob1_statist(52)",;
						"Pob1_statist(53)"}
						
			popup_prompt(T_ROW,T_COL-5,si5,mas_pmt,mas_msg,mas_fun)
*** �⤥�����
		// � ��६����� PSZ �࠭���� ����: 1- �⮨����� ��� ��� 2 - ��ࠡ�⭠� ����
		case k == 21    // ᯨ᮪ �⤥�����
			// StatisticsByDepartmentMain( pi1 )
			Pob2_statist(1)
		case k == 22    // �⤥����� + ���ᮭ��
			// StatisticsByDepartmentAndDoctor( pi1 )
			Pob2_statist(2)
		case k == 23    // �⤥����� + ��㣨
			// StatisticsByDepartmentAndService( pi1 )
			Pob2_statist(3)
		case k == 24    // �⤥����� + ���ᮭ�� + ��㣨
			// StatisticsByDepartmentAndDoctorAndService( pi1 )
			Pob2_statist(4)
		case k == 25    // �⤥����� + ��㣠 + �����
			// StatisticsByDepartmentAndServiceAndPatients( pi1 )
			Pob2_statist(8)
		case k == 26    // �⤥����� + ���ᮭ�� + �����
			// StatisticsByDepartmentAndEmployeeAndPatients( pi1 )
			Pob2_statist(9)
		case k == 27    // ���᮪ ������ � �㬬��� ��祭�� � ������ �� �⤥�����
			// StatisticsByDepartmentAndPatientAndServices( pi1 )
			st1_plat_fio()
		case k == 28    // ���᮪ ������ � �㬬��� ��祭�� � ������ �� �⤥�����
			// StatisticsByDepartmentAndPatient( pi1 )
			st_plat_fio(1)
*** �㦡�
		case k == 31    // �㦡� + �⤥�����
			// StatisticsBySlugbaAndDepartment( pi1 )
			Pob2_statist(0)
		case k == 32    // �㦡� + ��㣨
			// StatisticsByAllSlugbaAndService( pi1 )
			Pob2_statist(10)
		case k == 33    // �㦡� + ��㣨
			fl := .f.
			G_Use(dir_server+"slugba",dir_server+"slugba","SL")
			if si_slugba == nil
				go top
			else
				find (str(si_slugba,3))
			endif
			if Alpha_Browse(T_ROW,T_COL-5,maxrow()-2,T_COL+45,"f2spr_other",color0)
				fl := .t. ; si_slugba := sl->shifr
				j := { sl->shifr, lstr(sl->shifr)+". "+alltrim(sl->name) }
			endif
			sl->(dbCloseArea())
			if fl
				Pob2_statist(11,j)
			endif
			// StatisticsBySlugbaAndService( pi1 )
*** ���ᮭ��
		case k == 41    // ������� ࠡ���騩 + ��㣨
			// StatisticsByEmployeeAndServices( pi1 )
			Pob2_statist(5)
		case k == 42    // ������� ࠡ���騩 + ��㣨 + �����
			j := popup_prompt( T_ROW, T_COL-5, si5, { '�� ~��㣨', '~���᮪ ���' } )
			if j == 1
				StatisticsByEmployeeAndAllServicesAndPatients( pi1 )
			elseif j == 2
				// StatisticsByEmployeeAndServicesAndPatients( pi1 )
				Pob2_statist(13,,(j==1))
			endif
			if (j := popup_prompt(T_ROW,T_COL-5,si5,;
                       {"�� ~��㣨","~���᮪ ���"})) > 0
					   
				Pob2_statist(13,,(j==1))
			endif
		case k == 43    // ᯨ᮪ ���ᮭ��� � ��ꥬ�� ࠡ��
			// StatisticsByEmployee( pi1 )
			Pob2_statist(7)
		case k == 44    // ᯨ᮪ ࠡ����� + ��㣨
			// StatisticsBySelectedEmployeeAndAllServices( pi1 )
			Pob2_statist(5,{1})
		case k == 45    // ���᮪ ������ � ࠧ������ �㬬 ��祭�� �� ������� ���� (�/����, ᠭ��થ)
			// StatisticsByEmployeeAndPatients( pi1 )
			st_plat_fio(2)
		case k == 46    // ���᮪ ������� � ��ࠡ�⠭�묨 �㬬���
			st_plat_ms(1)
		case k == 47    // ���᮪ ᠭ��ப � ��ࠡ�⠭�묨 �㬬���
			st_plat_ms(2)
*** ��㣨
		case k == 51    // ᯨ᮪ ���
			// StatisticsBySelectedServices( pi1, .t. )
			Pob2_statist(6)
		case k == 52    // �� ��㣨
			// StatisticsBySelectedServices( pi1, .f. )
			Pob2_statist(12)
		case k == 53    // ᯨ᮪ ��� + �����
			// StatisticsByServicesAndPatients( pi1 )
			Pob2_statist(14)
	endcase
	if k > 10
		j := int(val(right(lstr(k),1)))
		if between(k,11,19)
			si1 := j
		elseif between(k,21,29)
			si2 := j
		elseif between(k,31,39)
			si3 := j
		elseif between(k,41,49)
			si4 := j
		elseif between(k,51,59)
			si5 := j
		endif
	endif
	
	return nil

//  11.09.25
Function st1_plat_fio()
	Local reg := 1
	Local vr_as, adbf, i, j, arr[2], begin_date, end_date, ;
				fl_exit := .f., sh, HH := 57, reg_print, s, xx, n, nvr,;
				arr_otd := {}, n_file := "plat_fio.txt", buf := save_maxrow()
	Private krvz, arr_dms, d_file := "PLAT_FIO"+sdbf(), otdeleni := {}
	if !del_dbf_file(d_file)
		return NIL
	endif
	if (st_a_uch := inputN_uch(T_ROW,T_COL-5)) == NIL
		return NIL
	endif
	if (arr := year_month()) == NIL
		return NIL
	endif
	begin_date := arr[7]
	end_date := arr[8]
	if (krvz := fbp_tip_usl(T_ROW,T_COL-5,@arr_dms)) == NIL
		return NIL
	endif
	mywait()
	R_Use(dir_server+"mo_uch",,"UCH")
	R_Use(dir_server+"mo_otd",,"OTD")
	go top
	do while !eof()
		if f_is_uch(st_a_uch,otd->kod_lpu)
			uch->(dbGoto(otd->kod_lpu))
			aadd(arr_otd,{otd->(recno()),otd->name,otd->kod_lpu,uch->name})
		endif
		skip
	enddo
	close databases
	adbf := {{"kod",  "N", 7,0},;  // ��� �/�
					 {"kod_k","N", 7,0},;  // ��� �� ����⥪�
					 {"kod_p","N", 4,0},;  // ��� ���ᮭ���
					 {"otd",  "N", 3,0},;  // ��� �⤥�����
					 {"summa","N",12,2},;  // ���� �㬬� ��祭�� �� ������� �⤥�����
					 {"sm_vozvr","N",12,2}; // ���� �㬬� ��祭�� �� ������� �⤥�����
					}
	dbcreate(cur_dir()+"tmp",adbf)
	use (cur_dir()+"tmp") new
	index on str(kod_k,7)+str(kod,7)+str(otd,3)+str(kod_p,4) to (cur_dir()+"tmp")
	G_Use(dir_server+"hum_p_u",dir_server+"hum_p_u","HU")
	G_Use(dir_server+"hum_p",,"HUMAN")
	if pi1 == 3  // �� ��� ������� ���� ���
		set index to (dir_server+"hum_pc")
		for xx := 0 to 2
			if ascan(krvz,xx) > 0
				select HUMAN
				dbseek(str(xx,1)+"1"+dtos(arr[5]),.t.)
				do while human->tip_usl==xx .and. human->date_close <= arr[6] .and. !eof()
					UpdateStatus()
					if inkey() == K_ESC
						fl_exit := .t. ; exit
					endif
					if iif(arr_dms == NIL, .t., ascan(arr_dms,human->pr_smo) > 0)
						select HU
						find (str(human->(recno()),7))
						do while hu->kod == human->(recno())
							if ascan(arr_otd, {|x| hu->otd==x[1]}) > 0
								f1_plat_fio(reg,vr_as)
							endif
							select HU
							skip
						enddo
					endif
					select HUMAN
					skip
				enddo
			endif
			if fl_exit ; exit ; endif
		next
	else  // ⮫쪮 �� ��� ����砭�� ��祭��
		set index to (dir_server+"hum_pd")
		dbseek(dtos(arr[5]),.t.)
		do while human->k_data <= arr[6] .and. !eof()
			UpdateStatus()
			if inkey() == K_ESC
				fl_exit := .t. ; exit
			endif
			if ascan(krvz,human->tip_usl) > 0 .and. ;
								iif(arr_dms == NIL, .t., ascan(arr_dms,human->pr_smo) > 0)
				select HU
				find (str(human->(recno()),7))
				do while hu->kod == human->(recno())
					if ascan(arr_otd, {|x| hu->otd==x[1]}) > 0
						f1_plat_fio(reg,vr_as)
					endif
					select HU
					skip
				enddo
			endif
			select HUMAN
			skip
		enddo
	endif
	j := tmp->(lastrec())
	close databases
	if fl_exit ; return NIL ; endif
	if j == 0
		func_error(4,"��� ᢥ�����!")
	else
		mywait()
		n := 40
		arr_title := {replicate("�",n),;
									padc("�.�.�. ���쭮��",n),;
									padc("������������ ��㣨",n),;
									replicate("�",n)}
		adbf := {{"fio","C",50,0}}
		if reg == 1
			arr_title[1] += "�����������"
			arr_title[2] += "� ����砭��"
			arr_title[3] += "�  ��祭�� "
			arr_title[4] += "�����������"
			aadd(adbf,{"k_data","C",10,0})
		endif
		if pi1 == 3  // �� ��� ������� ���� ���
			arr_title[1] += "�����������"
			arr_title[2] += "�   ���   "
			arr_title[3] += "�  ������  "
			arr_title[4] += "�����������"
			aadd(adbf,{"date_close","C",10,0})
		endif
		if len(st_a_uch) > 1
		 // arr_title[1] += "�����������"
		 // arr_title[2] += "�          "
		 // arr_title[3] += "���०�����"
		 // arr_title[4] += "�����������"
			aadd(adbf,{"uch","C",30,0})
		endif
	 // arr_title[1] += "������"
	 // arr_title[2] += "��⤥-"
	 // arr_title[3] += "������"
	 // arr_title[4] += "������"
		aadd(adbf,{"otd","C",50,0})
		nvr := 20
		if reg == 2
			arr_title[1] += "�"+replicate("�",nvr)
			arr_title[2] += "�"+space(nvr)
			arr_title[3] += "�"+padc({"���","����⥭��","��������","�����ન"}[vr_as],nvr)
			arr_title[4] += "�"+replicate("�",nvr)
			aadd(adbf,{"tab_nom","N",5,0})
			aadd(adbf,{"personal","C",50,0})
		endif
		arr_title[1] += "������������"
		arr_title[2] += "� �⮨����� "
		arr_title[3] += "�  ������� "
		arr_title[4] += "������������"
		arr_title[1] += "������������"
		arr_title[2] += "� �⮨����� "
		arr_title[3] += "�   ���   "
		arr_title[4] += "������������"
		aadd(adbf,{"summa","N",12,2})
		dbcreate(d_file,adbf)
		use (d_file) new alias DD
		reg_print := f_reg_print(arr_title,@sh)
		R_Use(dir_server+"mo_uch",,"UCH")
		R_Use(dir_server+"mo_otd",,"OTD")
		set relation to kod_lpu into UCH
		G_Use(dir_server+"kartotek",,"KART")
		G_Use(dir_server+"uslugi",,"USL")
		G_Use(dir_server+"hum_p_u",dir_server+"hum_p_u","HU")
		set relation to u_kod into USL
		G_Use(dir_server+"hum_p",,"HUMAN")
		use (cur_dir()+"tmp") new
		set relation to otd into OTD, to kod_k into KART, to kod into HUMAN
		if reg == 2
			if vr_as < 3
				R_Use(dir_server+"mo_pers",,"PERSO")
				set relation to kod_p into PERSO additive
			else
				G_Use(dir_server+"plat_ms",,"P2")
				select TMP
				set relation to kod_p into P2 additive
			endif
		endif
		index on upper(uch->name)+left(upper(otd->name),20)+left(upper(kart->fio),20)+str(kod_k,7)+dtos(human->k_data) ;
					to (cur_dir()+"tmp")
		fp := fcreate(n_file) ; tek_stroke := 0 ; n_list := 1
		add_string("������� ������")
		add_string(center("����⨪� �� ࠡ�� ���ᮭ���",sh))
		titleN_uch(st_a_uch,sh)
		tit_tip_usl(krvz,arr_dms,sh)
		add_string(center(arr[4],sh))
		add_string("")
		do case
			case pi1 == 1
				s := "[ �� ��� ��祭�� ]"
			case pi1 == 2
				s := "[ �� ��� ����砭�� ��祭�� ]"
			case pi1 == 3
				s := "[ �� ��� ������� ���� ��� ]"
		endcase
		add_string(center(s,sh))
		add_string("")
		old_kart := -999 ; old_lu := 0
		select TMP
		go top
		aeval(arr_title, {|x| add_string(x) } )
		old_otdel := otd->name
		s_otdel   := 0
		s_vozvr   := 0
		s1vozvr   := 0
		do while !eof()
			if verify_FF(HH,.t.,sh)
				aeval(arr_title, {|x| add_string(x) } )
			endif
			If old_otdel != otd->name
				n1 := len(arr_title[1])
				add_string(replicate("�",n1))
				add_string(padr(alltrim(old_otdel),n+1)+"    �����:"+ put_kop(s_otdel,12))
				add_string("")
				aadd(otdeleni, {old_otdel,s_otdel,s_vozvr,s1vozvr} )
				old_otdel := otd->name
				s_otdel := tmp->summa
				if human->date_voz == human->pdate
					s_vozvr := human->sum_voz
					s1vozvr := 0
				else
					s_vozvr := 0
					s1vozvr := human->sum_voz
				endif
			else
				s_otdel += tmp->summa
				if human->date_voz == human->pdate
					s_vozvr += human->sum_voz
				else
					s1vozvr += human->sum_voz
				endif
			endif
			if old_kart==tmp->kod_k .and. old_lu==tmp->kod
				s := space(n)
			else
				s := padr(kart->fio,n)
			endif
			old_kart:=tmp->kod_k
			old_lu:=tmp->kod
			if reg == 1
				s += " "+full_date(human->k_data)
			endif
			if pi1 == 3  // �� ��� ������� ���� ���
				s += " "
				if human->date_close > human->k_data
					s += full_date(human->date_close)
				else
					s += padc("�����",10)
				endif
			endif
			if reg == 2
				s1 := "["
				if vr_as < 3
					if mem_tabnom == 2
						s1 += lstr(tabn->tab_nom)
					else
						s1 += lstr(tmp->kod_p)
					endif
				else
					s1 += lstr(p2->tab_nom)
				endif
				s1 += "] "+fam_i_o(p2->fio)
				s += " "+padr(s1,nvr)
			endif
			s += put_kop(tmp->summa,12)
			if human->sum_voz > 0
				s += "�������"
			endif
			add_string(s)
			select HU
			find(str(human->(recno()),7))
			do while human->(recno()) == hu->kod .and. !eof()
				if hu->otd == tmp->otd
					if glob_mo()[_MO_KOD_TFOMS] == '171004' // ��-4
						add_string("  "+padr(usl->full_name,60)+" "+put_kop(hu->stoim,12))
					else
						add_string("  "+padr(usl->name,60)+" "+put_kop(hu->stoim,12))
					endif
				endif
				if verify_FF(HH,.t.,sh)
					aeval(arr_title, {|x| add_string(x) } )
				endif
				skip
			enddo
			select TMP
			skip
		enddo
		n1 := len(arr_title[1])
		add_string(replicate("�",n1))
		add_string(padr(alltrim(old_otdel),n+1)+"    �����:"+ put_kop(s_otdel,12))
		aadd(otdeleni, {old_otdel,s_otdel,s_vozvr,s1vozvr} )
		add_string("")
		verify_FF(2,.t.,sh)
		arr_title := {;
		"�������������������������������������������������������������������������������",;
		"                                           � ����祭� ��  ������  �   ������ ",;
		"                 �⤥�����                 �   �����   ��१ ����� �१ ����",;
		"�������������������������������������������������������������������������������"}
		sh := len(arr_title[1])
		add_string(center("�⮣� �� �⤥�����"),sh)
		add_string("")
		do case
			case pi1 == 1
				s := "[ �� ��� ��祭�� ]"
			case pi1 == 2
				s := "[ �� ��� ����砭�� ��祭�� ]"
			case pi1 == 3
				s := "[ �� ��� ������� ���� ��� ]"
		endcase
		add_string(center(s,sh))
		add_string(center(arr[4],sh))
		sm  := 0
		sm1 := 0
		sm2 := 0
		aeval(arr_title, {|x| add_string(x) } )
		for i := 1 to len(otdeleni)
			add_string(padr(alltrim(otdeleni[i,1]),44)+ put_kope(otdeleni[i,2],12)+;
								 put_kope(otdeleni[i,3],12)+put_kope(otdeleni[i,4],12))
			sm += otdeleni[i,2]
			sm1 += otdeleni[i,3]
			sm2 += otdeleni[i,4]
			if verify_FF(HH,.t.,sh)
				aeval(arr_title, {|x| add_string(x) } )
			endif
		next
		add_string(replicate("�",sh))
		add_string(padl("�����: ",44)+put_kope(sm,12)+put_kope(sm1,12)+put_kope(sm2,12))
		fclose(fp)
		close databases
		viewtext(n_file,,,,(sh>80),,,reg_print)
		rest_box(buf)
	endif
	rest_box(buf)
	return NIL
	