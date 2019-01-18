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

*****
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
			StatisticsByDepartmentMain( pi1 )
			&& Pob2_statist(1)
		case k == 22    // отделение + персонал
			StatisticsByDepartmentAndDoctor( pi1 )
			&& Pob2_statist(2)
		case k == 23    // отделение + услуги
			StatisticsByDepartmentAndService( pi1 )
			&& Pob2_statist(3)
		case k == 24    // отделение + персонал + услуги
			StatisticsByDepartmentAndDoctorAndService( pi1 )
			&& Pob2_statist(4)
		case k == 25    // отделение + услуга + больные
			StatisticsByDepartmentAndServiceAndPatients( pi1 )
			&& Pob2_statist(8)
		case k == 26    // отделение + персонал + больные
			StatisticsByDepartmentAndEmployeeAndPatients( pi1 )
			&& Pob2_statist(9)
		case k == 27    // Список больных с суммами лечения в каждом из отделений
			StatisticsByDepartmentAndPatientAndServices( pi1 )
			&& st1_plat_fio()
		case k == 28    // Список больных с суммами лечения в каждом из отделений
			StatisticsByDepartmentAndPatient( pi1 )
			&& st_plat_fio(1)
*** службы
		case k == 31    // службы + отделения
			StatisticsBySlugbaAndDepartment( pi1 )
			&& Pob2_statist(0)
		case k == 32    // службы + услуги
			StatisticsByAllSlugbaAndService( pi1 )
			&& Pob2_statist(10)
		case k == 33    // служба + услуги
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
*** персонал
		case k == 41    // конкретный работающий + услуги
			StatisticsByEmployeeAndServices( pi1 )
			&& Pob2_statist(5)
		case k == 42    // конкретный работающий + услуги + больные
			j := popup_prompt( T_ROW, T_COL-5, si5, { 'Все ~услуги', '~Список услуг' } )
			if j == 1
				StatisticsByEmployeeAndAllServicesAndPatients( pi1 )
			elseif j == 2
				StatisticsByEmployeeAndServicesAndPatients( pi1 )
				&& Pob2_statist(13,,(j==1))
			endif
			&& if (j := popup_prompt(T_ROW,T_COL-5,si5,;
                       && {"Все ~услуги","~Список услуг"})) > 0
					   
				&& Pob2_statist(13,,(j==1))
			&& endif
		case k == 43    // список персонала с объемом работ
			StatisticsByEmployee( pi1 )
			&& Pob2_statist(7)
		case k == 44    // список работающих + услуги
			StatisticsBySelectedEmployeeAndAllServices( pi1 )
			&& Pob2_statist(5,{1})
		case k == 45    // Список больных с разбивкой сумм лечения по каждому врачу (м/сестре, санитарке)
			StatisticsByEmployeeAndPatients( pi1 )
			&& st_plat_fio(2)
		case k == 46    // Список медсестер с заработанными суммами
			st_plat_ms(1)
		case k == 47    // Список санитарок с заработанными суммами
			st_plat_ms(2)
*** услуги
		case k == 51    // список услуг
			StatisticsBySelectedServices( pi1, .t. )
			&& Pob2_statist(6)
		case k == 52    // все услуги
			StatisticsBySelectedServices( pi1, .f. )
			&& Pob2_statist(12)
		case k == 53    // список услуг + больные
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
