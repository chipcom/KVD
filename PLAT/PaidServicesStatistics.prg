*******************************************************************************
*          Po_statist() - Головная ф-я меню статистики

#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

Function Po_proverka(k)
	hb_Alert( 'Не реализовано!', , , 4 )
return nil

Function oplata_vz()
	hb_Alert( 'Не реализовано!', , , 4 )
return nil

// 27.03.23
Function Po_statist(k)
	Static si1 := 1, si2 := 1, si3 := 1, si4
	Local uch_otd, mas_pmt, mas_msg, mas_fun, j
	Private p_net_otd := .t.
	DEFAULT k TO 1
	
//ВРЕМЕННО
//Private COUNT_UCH := 1
	do case
		case k == 1
			uch_otd := saveuchotd()
			mas_pmt := {"~Объем работ",;
						"По № ~квитанционной книжки",;
						"По ~направившему врачу",;
						"ДМС и ~взаимозачет",;
						"~Множественный запрос",;
						"~Сводная ведомость",;
						"~Журнал Регистрации",;
						"Настраиваемый журнал ~Регистрации",; //21.05.08
						"По дате приема ~денег";
						}
			mas_msg := {"Статистика по объему работ персонала (по дате окончания лечения)",;
						"Статистика по объему работ (по номеру квитанционной книжки)",;
						"Статистика по направившим врачам",;
						"Инф-ия о больных (о персонале), которые лечились (работали) по ДМС и взаимозач.",;
						"Множественный запрос",;
						"Сводная ведомость по объему работ персонала [по всем задачам]",;
						"Журнал регистрации договоров",;
						"Настраиваемый журнал Регистрации",; //21.05.08
						"По дате приема денег";
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
			mas_pmt := {"~Врачи + кол-во больных",;
						"Врачи + ~услуги"}
			mas_msg := {"Статистика по направившим врачам с подсчетом количества больных",;
						"Статистика по направившим врачам с расшифровкой по услугам"}
			mas_fun := {"Po_statist(31)",;
						"Po_statist(32)"}
			popup_prompt(T_ROW,T_COL-5,si3,mas_pmt,mas_msg,mas_fun)
			
		case k == 14
			mas_pmt := {"~Больные по ДМС и взаимозачету",;
						"~Оплата по ДМС и взаимозачету",;
						"Оборотная ве~домость",;
						"~Врачи по ДМС и взаимозачету"}
			mas_msg := {"Информация о больных, которые лечились по ДМС и взаимозачету",;
						"Информация о платежах от предприятий по ДМС и взаимозачету",;
						"Получение оборотных ведомостей по ДМС и взаимозачету",;
						"Информация о врачах, которые работали по ДМС и взаимозачету"}
			mas_fun := {"Po_statist(21)",;
						"Po_statist(22)",;
						"Po_statist(23)",;
						"Po_statist(24)"}
			if is_oplata != 7
				aadd(mas_pmt,"~Медсестры по ДМС и взаимозачету")
				aadd(mas_pmt,"~Санитарки по ДМС и взаимозачету")
				aadd(mas_msg,"Информация о медсестрах, которые работали по ДМС и взаимозачету")
				aadd(mas_msg,"Информация о санитарках, которые работали по ДМС и взаимозачету")
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
			mas_pmt := {"По дате ~окончания лечения",;
						"По дате ~закрытия л/учета"}
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

************************ Объем работ персонала *******************************

*****
Function Pob_statist()
	Static si
	Local mas_pmt := {"Объем работ (по дате ~лечения)",;
					"Объем работ (по дате ~окончания лечения)",;
					"Объем работ (по дате ~закрытия л/учета)"}
	Local mas_msg := {"Статистика по объему работ персонала (по дате лечения)",;
					"Статистика по объему работ персонала (по дате окончания лечения)",;
					"Статистика по объему работ персонала (по дате закрытия листа учета)"}
	Local mas_fun := {"Pob1_statist(0,1)",;
					"Pob1_statist(0,2)",;
					"Pob1_statist(0,3)"}
	Private pi1 := si, psz
	DEFAULT si TO glob_close+2
	
	popup_prompt(T_ROW,T_COL-5,si,mas_pmt,mas_msg,mas_fun)
	if pi1 != nil ; si := pi1 ; endif
	return nil

***** объем работ персонала
Function Pob1_statist(k,k1)
	Static si0 := 1, si1 := 1, si2 := 1, si3 := 1, si4 := 1, si5 := 1, si_slugba
	Local mas_pmt, mas_msg, mas_fun, j, fl
	
	do case
		case k == 0
			pi1 := k1
			mas_pmt := {"~Стоимость лечения",;
						"~Заработная плата"}
			mas_msg := {"Статистика по объему работ с подсчетом стоимости лечения",;
						"Статистика по объему работ с подсчетом заработной платы"}
			mas_fun := {"Pob1_statist(1,1)",;
						"Pob1_statist(1,2)"} //
						
			popup_prompt(T_ROW,T_COL-5,si0,mas_pmt,mas_msg,mas_fun,color0+",R/BG,GR+/N")
		case k == 1
			psz := si0 := k1
			mas_pmt := {"~Отделения",;
					"~Службы",;
					"~Персонал",;
					"~Услуги"}
			mas_msg := {"Статистика по работе персонала и оказанным услугам в отделениях",;
					"Количество услуг и сумма лечения по службам",;
					"Статистика по работе персонала (независимо от отделения)",;
					"Статистика по оказанию конкретных услуг (независимо от отделения)"}
			mas_fun := {"Pob1_statist(11)",;
					"Pob1_statist(12)",;
					"Pob1_statist(13)",;
					"Pob1_statist(14)"}
					
			popup_prompt(T_ROW-len(mas_pmt)-3,T_COL-5,si1,mas_pmt,mas_msg,mas_fun)
		case k == 11  // отделения
			mas_pmt := {"~Список отделений",;
					"Отделение + ~персонал",;
					"Отделение + ~услуги",;
					"~Отделение + персонал + услуги",;
					"Отделение + услуга + ~больные",;
					"Отделение + ~1 человек + больные",;
					"Отделения + больные + услуги",;
					"Больные по от~делениям"}
			mas_msg := {"Количество услуг и сумма лечения по отделениям",;
					"Статистика по работе персонала в конкретном отделении",;
					"Статистика по услугам, оказанным в конкретном отделении",;
					"Статистика по работе персонала (плюс оказанные услуги) в конкретном отделении",;
					"Статистика по оказанной услуге (плюс больные) в конкретном отделении",;
					"Статистика по работе 1 человека (плюс больные) в конкретном отделении",;
					"Статистика по работе персонала во многих отделениях",;
					"Список больных с суммами лечения в каждом из отделений"}
			mas_fun := {"Pob1_statist(21)",;
					"Pob1_statist(22)",;
					"Pob1_statist(23)",;
					"Pob1_statist(24)",;
					"Pob1_statist(25)",;
					"Pob1_statist(26)",;
					"Pob1_statist(27)",;
					"Pob1_statist(28)"}
					
			popup_prompt(T_ROW,T_COL-5,si2,mas_pmt,mas_msg,mas_fun)
		case k == 12  // службы
			mas_pmt := {"Службы + ~отделения",;
						"Службы + ~услуги",;
						"Служб~а + услуги"}
			mas_msg := {"Количество услуг и сумма лечения по службам (с разбивкой по отделениям)",;
						"Статистика по оказанным услугам (с объединением по службам)",;
						"Статистика по оказанным услугам (по конкретной службе)"}
			mas_fun := {"Pob1_statist(31)",;
						"Pob1_statist(32)",;
						"Pob1_statist(33)"}
			
			popup_prompt(T_ROW,T_COL-5,si3,mas_pmt,mas_msg,mas_fun)
		case k == 13  // персонал
			mas_pmt := {"1 человек + ~услуги",;
						"~1 человек + услуги + больные",;
						"~Весь персонал",;
						"~Список персонала + услуги",;
						"~Больные + персонал"}
			mas_msg := {"Статистика по работе конкретного работающего (плюс оказанные услуги)",;
						"Статистика по работе конкретного работающего (плюс услуги плюс больные)",;
						"Количество услуг и сумма лечения по всему списку работающих",;
						"Статистика по работе некоторых работающих (плюс оказанные услуги)",;
						"Список больных с разбивкой сумм лечения по каждому врачу (м/сестре, санитарке)"}
			mas_fun := {"Pob1_statist(41)",;
						"Pob1_statist(42)",;
						"Pob1_statist(43)",;
						"Pob1_statist(44)",;
						"Pob1_statist(45)"}
						
			if is_oplata != 7
				aadd(mas_pmt,"~Медсестры")
				aadd(mas_pmt,"С~анитарки")
				aadd(mas_msg,"Список медсестер с заработанными суммами")
				aadd(mas_msg,"Список санитарок с заработанными суммами")
				aadd(mas_fun,"Pob1_statist(46)")
				aadd(mas_fun,"Pob1_statist(47)")
			endif
			popup_prompt(T_ROW,T_COL-5,si4,mas_pmt,mas_msg,mas_fun)
		case k == 14  // услуги
			mas_pmt := {"~Список услуг",;
						"Все ~услуги",;
						"Список услуг+~больные"}
			mas_msg := {"Статистика по оказанию конкретных услуг (независимо от отделения)",;
						"Статистика по оказанию всех услуг (независимо от отделения)",;
						"Статистика по оказанию конкретных услуг [с больными] (независимо от отделения)"}
			mas_fun := {"Pob1_statist(51)",;
						"Pob1_statist(52)",;
						"Pob1_statist(53)"}
						
			popup_prompt(T_ROW,T_COL-5,si5,mas_pmt,mas_msg,mas_fun)
*** отделения
		// в переменной PSZ хранится ключ: 1- стоимость услуг или 2 - заработная плата
		case k == 21    // список отделений
			// StatisticsByDepartmentMain( pi1 )
			Pob2_statist(1)
		case k == 22    // отделение + персонал
			// StatisticsByDepartmentAndDoctor( pi1 )
			Pob2_statist(2)
		case k == 23    // отделение + услуги
			// StatisticsByDepartmentAndService( pi1 )
			Pob2_statist(3)
		case k == 24    // отделение + персонал + услуги
			// StatisticsByDepartmentAndDoctorAndService( pi1 )
			Pob2_statist(4)
		case k == 25    // отделение + услуга + больные
			// StatisticsByDepartmentAndServiceAndPatients( pi1 )
			Pob2_statist(8)
		case k == 26    // отделение + персонал + больные
			// StatisticsByDepartmentAndEmployeeAndPatients( pi1 )
			Pob2_statist(9)
		case k == 27    // Список больных с суммами лечения в каждом из отделений
			// StatisticsByDepartmentAndPatientAndServices( pi1 )
			st1_plat_fio()
		case k == 28    // Список больных с суммами лечения в каждом из отделений
			// StatisticsByDepartmentAndPatient( pi1 )
			st_plat_fio(1)
*** службы
		case k == 31    // службы + отделения
			// StatisticsBySlugbaAndDepartment( pi1 )
			Pob2_statist(0)
		case k == 32    // службы + услуги
			// StatisticsByAllSlugbaAndService( pi1 )
			Pob2_statist(10)
		case k == 33    // служба + услуги
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
*** персонал
		case k == 41    // конкретный работающий + услуги
			// StatisticsByEmployeeAndServices( pi1 )
			Pob2_statist(5)
		case k == 42    // конкретный работающий + услуги + больные
			j := popup_prompt( T_ROW, T_COL-5, si5, { 'Все ~услуги', '~Список услуг' } )
			if j == 1
				StatisticsByEmployeeAndAllServicesAndPatients( pi1 )
			elseif j == 2
				// StatisticsByEmployeeAndServicesAndPatients( pi1 )
				Pob2_statist(13,,(j==1))
			endif
			if (j := popup_prompt(T_ROW,T_COL-5,si5,;
                       {"Все ~услуги","~Список услуг"})) > 0
					   
				Pob2_statist(13,,(j==1))
			endif
		case k == 43    // список персонала с объемом работ
			// StatisticsByEmployee( pi1 )
			Pob2_statist(7)
		case k == 44    // список работающих + услуги
			// StatisticsBySelectedEmployeeAndAllServices( pi1 )
			Pob2_statist(5,{1})
		case k == 45    // Список больных с разбивкой сумм лечения по каждому врачу (м/сестре, санитарке)
			// StatisticsByEmployeeAndPatients( pi1 )
			st_plat_fio(2)
		case k == 46    // Список медсестер с заработанными суммами
			st_plat_ms(1)
		case k == 47    // Список санитарок с заработанными суммами
			st_plat_ms(2)
*** услуги
		case k == 51    // список услуг
			// StatisticsBySelectedServices( pi1, .t. )
			Pob2_statist(6)
		case k == 52    // все услуги
			// StatisticsBySelectedServices( pi1, .f. )
			Pob2_statist(12)
		case k == 53    // список услуг + больные
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
	adbf := {{"kod",  "N", 7,0},;  // код л/у
					 {"kod_k","N", 7,0},;  // код по картотеке
					 {"kod_p","N", 4,0},;  // код персонала
					 {"otd",  "N", 3,0},;  // код отделения
					 {"summa","N",12,2},;  // общая сумма лечения по данному отделению
					 {"sm_vozvr","N",12,2}; // общая сумма лечения по данному отделению
					}
	dbcreate(cur_dir()+"tmp",adbf)
	use (cur_dir()+"tmp") new
	index on str(kod_k,7)+str(kod,7)+str(otd,3)+str(kod_p,4) to (cur_dir()+"tmp")
	G_Use(dir_server+"hum_p_u",dir_server+"hum_p_u","HU")
	G_Use(dir_server+"hum_p",,"HUMAN")
	if pi1 == 3  // по дате закрытия листа учета
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
	else  // только по дате окончания лечения
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
		func_error(4,"Нет сведений!")
	else
		mywait()
		n := 40
		arr_title := {replicate("─",n),;
									padc("Ф.И.О. больного",n),;
									padc("наименование услуги",n),;
									replicate("─",n)}
		adbf := {{"fio","C",50,0}}
		if reg == 1
			arr_title[1] += "┬──────────"
			arr_title[2] += "│ Окончание"
			arr_title[3] += "│  лечения "
			arr_title[4] += "┴──────────"
			aadd(adbf,{"k_data","C",10,0})
		endif
		if pi1 == 3  // по дате закрытия листа учета
			arr_title[1] += "┬──────────"
			arr_title[2] += "│   Дата   "
			arr_title[3] += "│  оплаты  "
			arr_title[4] += "┴──────────"
			aadd(adbf,{"date_close","C",10,0})
		endif
		if len(st_a_uch) > 1
		 // arr_title[1] += "┬──────────"
		 // arr_title[2] += "│          "
		 // arr_title[3] += "│Учреждение"
		 // arr_title[4] += "┴──────────"
			aadd(adbf,{"uch","C",30,0})
		endif
	 // arr_title[1] += "┬─────"
	 // arr_title[2] += "│Отде-"
	 // arr_title[3] += "│ление"
	 // arr_title[4] += "┴─────"
		aadd(adbf,{"otd","C",50,0})
		nvr := 20
		if reg == 2
			arr_title[1] += "┬"+replicate("─",nvr)
			arr_title[2] += "│"+space(nvr)
			arr_title[3] += "│"+padc({"Врачи","Ассистенты","Медсестры","Санитарки"}[vr_as],nvr)
			arr_title[4] += "┴"+replicate("─",nvr)
			aadd(adbf,{"tab_nom","N",5,0})
			aadd(adbf,{"personal","C",50,0})
		endif
		arr_title[1] += "┬───────────"
		arr_title[2] += "│ Стоимость "
		arr_title[3] += "│  договора "
		arr_title[4] += "┴───────────"
		arr_title[1] += "┬───────────"
		arr_title[2] += "│ Стоимость "
		arr_title[3] += "│   услуг   "
		arr_title[4] += "┴───────────"
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
		add_string("ПЛАТНЫЕ УСЛУГИ")
		add_string(center("Статистика по работе персонала",sh))
		titleN_uch(st_a_uch,sh)
		tit_tip_usl(krvz,arr_dms,sh)
		add_string(center(arr[4],sh))
		add_string("")
		do case
			case pi1 == 1
				s := "[ по дате лечения ]"
			case pi1 == 2
				s := "[ по дате окончания лечения ]"
			case pi1 == 3
				s := "[ по дате закрытия листа учета ]"
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
				add_string(replicate("─",n1))
				add_string(padr(alltrim(old_otdel),n+1)+"    ИТОГО:"+ put_kop(s_otdel,12))
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
			if pi1 == 3  // по дате закрытия листа учета
				s += " "
				if human->date_close > human->k_data
					s += full_date(human->date_close)
				else
					s += padc("аванс",10)
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
				s += "ВОЗВРАТ"
			endif
			add_string(s)
			select HU
			find(str(human->(recno()),7))
			do while human->(recno()) == hu->kod .and. !eof()
				if hu->otd == tmp->otd
					if glob_mo()[_MO_KOD_TFOMS] == '171004' // КБ-4
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
		add_string(replicate("─",n1))
		add_string(padr(alltrim(old_otdel),n+1)+"    ИТОГО:"+ put_kop(s_otdel,12))
		aadd(otdeleni, {old_otdel,s_otdel,s_vozvr,s1vozvr} )
		add_string("")
		verify_FF(2,.t.,sh)
		arr_title := {;
		"───────────────────────────────────────────┬───────────┬───────────┬───────────",;
		"                                           │ Оплачено в│  Возврат  │   Возврат ",;
		"                 Отделения                 │   кассу   │через кассу│ через банк",;
		"───────────────────────────────────────────┴───────────┴───────────┴───────────"}
		sh := len(arr_title[1])
		add_string(center("Итого по отделениям"),sh)
		add_string("")
		do case
			case pi1 == 1
				s := "[ по дате лечения ]"
			case pi1 == 2
				s := "[ по дате окончания лечения ]"
			case pi1 == 3
				s := "[ по дате закрытия листа учета ]"
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
		add_string(replicate("─",sh))
		add_string(padl("ИТОГО: ",44)+put_kope(sm,12)+put_kope(sm1,12)+put_kope(sm2,12))
		fclose(fp)
		close databases
		viewtext(n_file,,,,(sh>80),,,reg_print)
		rest_box(buf)
	endif
	rest_box(buf)
	return NIL
	