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

*****
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
			StatisticsByDepartmentMain( pi1 )
			&& Pob2_statist(1)
		case k == 22    // �⤥����� + ���ᮭ��
			StatisticsByDepartmentAndDoctor( pi1 )
			&& Pob2_statist(2)
		case k == 23    // �⤥����� + ��㣨
			StatisticsByDepartmentAndService( pi1 )
			&& Pob2_statist(3)
		case k == 24    // �⤥����� + ���ᮭ�� + ��㣨
			StatisticsByDepartmentAndDoctorAndService( pi1 )
			&& Pob2_statist(4)
		case k == 25    // �⤥����� + ��㣠 + �����
			StatisticsByDepartmentAndServiceAndPatients( pi1 )
			&& Pob2_statist(8)
		case k == 26    // �⤥����� + ���ᮭ�� + �����
			StatisticsByDepartmentAndEmployeeAndPatients( pi1 )
			&& Pob2_statist(9)
		case k == 27    // ���᮪ ������ � �㬬��� ��祭�� � ������ �� �⤥�����
			StatisticsByDepartmentAndPatientAndServices( pi1 )
			&& st1_plat_fio()
		case k == 28    // ���᮪ ������ � �㬬��� ��祭�� � ������ �� �⤥�����
			StatisticsByDepartmentAndPatient( pi1 )
			&& st_plat_fio(1)
*** �㦡�
		case k == 31    // �㦡� + �⤥�����
			StatisticsBySlugbaAndDepartment( pi1 )
			&& Pob2_statist(0)
		case k == 32    // �㦡� + ��㣨
			StatisticsByAllSlugbaAndService( pi1 )
			&& Pob2_statist(10)
		case k == 33    // �㦡� + ��㣨
			&& fl := .f.
			&& G_Use(dir_server+"slugba",dir_server+"slugba","SL")
			&& if si_slugba == nil
				&& go top
			&& else
				&& find (str(si_slugba,3))
			&& endif
			&& if Alpha_Browse(T_ROW,T_COL-5,maxrow()-2,T_COL+45,"f2spr_other",color0)
				&& fl := .t. ; si_slugba := sl->shifr
				&& j := { sl->shifr, lstr(sl->shifr)+". "+alltrim(sl->name) }
			&& endif
			&& sl->(dbCloseArea())
			&& if fl
				&& Pob2_statist(11,j)
			&& endif
			StatisticsBySlugbaAndService( pi1 )
*** ���ᮭ��
		case k == 41    // ������� ࠡ���騩 + ��㣨
			StatisticsByEmployeeAndServices( pi1 )
			&& Pob2_statist(5)
		case k == 42    // ������� ࠡ���騩 + ��㣨 + �����
			j := popup_prompt( T_ROW, T_COL-5, si5, { '�� ~��㣨', '~���᮪ ���' } )
			if j == 1
				StatisticsByEmployeeAndAllServicesAndPatients( pi1 )
			elseif j == 2
				StatisticsByEmployeeAndServicesAndPatients( pi1 )
				&& Pob2_statist(13,,(j==1))
			endif
			&& if (j := popup_prompt(T_ROW,T_COL-5,si5,;
                       && {"�� ~��㣨","~���᮪ ���"})) > 0
					   
				&& Pob2_statist(13,,(j==1))
			&& endif
		case k == 43    // ᯨ᮪ ���ᮭ��� � ��ꥬ�� ࠡ��
			StatisticsByEmployee( pi1 )
			&& Pob2_statist(7)
		case k == 44    // ᯨ᮪ ࠡ����� + ��㣨
			StatisticsBySelectedEmployeeAndAllServices( pi1 )
			&& Pob2_statist(5,{1})
		case k == 45    // ���᮪ ������ � ࠧ������ �㬬 ��祭�� �� ������� ���� (�/����, ᠭ��થ)
			StatisticsByEmployeeAndPatients( pi1 )
			&& st_plat_fio(2)
		case k == 46    // ���᮪ ������� � ��ࠡ�⠭�묨 �㬬���
			st_plat_ms(1)
		case k == 47    // ���᮪ ᠭ��ப � ��ࠡ�⠭�묨 �㬬���
			st_plat_ms(2)
*** ��㣨
		case k == 51    // ᯨ᮪ ���
			StatisticsBySelectedServices( pi1, .t. )
			&& Pob2_statist(6)
		case k == 52    // �� ��㣨
			StatisticsBySelectedServices( pi1, .f. )
			&& Pob2_statist(12)
		case k == 53    // ᯨ᮪ ��� + �����
			StatisticsByServicesAndPatients( pi1 )
			&& Pob2_statist(14)
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
