*******************************************************************************
* mo_kas_p.prg
*******************************************************************************
* 05.02.14 prn_k_fr(k)
* 18.11.14 prn_k_svod() - ᢮� �� ᬥ��
* 14.08.14 prn_k_svod_period() - �뢮� ᢮�� �� ��ਮ� �६��� (�� �ᥬ ᬥ���)
*          prn_k_plat()
*          prn_k_ort(k)
*          prn_rees_ort()
*          prn_nez_nar()
*          f1p_nez_nar()
*******************************************************************************
#include "inkey.ch"
#include "function.ch"
#include "edit_spr.ch"
#include "chip_mo.ch"


***** 05.02.14
Function prn_k_fr(k)
	Static si1 := 1, si2 := 1
	Local mas_pmt, mas_msg, mas_fun, j
	DEFAULT k TO 1
	
	do case
		case k == 1
			mas_pmt := {"���ଠ�� �� ~����",;
				"���� �� ~ᬥ��",;
                "���� �� ~��ਮ�"}
			mas_msg := {"����祭�� ���ଠ樨 �� ���ﭨ� ���ᮢ��� ������",;
				"�뢮� ᢮�� �� ᬥ��",;
                "�뢮� ᢮�� �� ��ਮ� �६��� (�� �ᥬ ᬥ���)"}
			mas_fun := {"prn_k_fr(11)",;
                "prn_k_fr(12)",;
                "prn_k_fr(13)"}
				
			popup_prompt(T_ROW,T_COL-5,si1,mas_pmt,mas_msg,mas_fun)
			
		case k == 11
			f1_inf_fr(3)
		case k == 12
			prn_k_svod()
		case k == 13
			prn_k_svod_period()
	endcase
	if k > 10
		j := int(val(right(lstr(k),1)))
		if between(k,11,19)
			si1 := j
		endif
	endif
	return NIL

***** 18.11.14 ᢮� �� ᬥ��
Function prn_k_svod()
	Local arr_m, buf, i, k, arr, n_file := "smena.txt", sh := 64, ;
		kol_pl := 0, sum_pl := 0, kol_or := 0, sum_or := 0,;
		kol_pl_b := 0, sum_pl_b := 0, kol_or_b := 0, sum_or_b := 0
		
	if (arr_m := year_month(T_ROW,T_COL+5,,1)) == NIL
		return NIL
	endif
	buf := save_row(maxrow())
	mywait()
	dbcreate("tmp", {{"n_chek","N", 8,0},; // ����� 祪�
					{"pl_ort","N", 1,0},; // 1-�����, 2-��⮯����
					{"stoim", "N",10,2}}) // �㬬� 祪�
	use tmp
	index on str(n_chek,8) to tmp
	R_Use(dir_server+"kas_pl",dir_server+"kas_pl2","KPL")
	find (dtos(arr_m[5]))
	
	do while kpl->k_data == arr_m[5] .and. !eof()
		if kpl->smena == glob_smena
			select TMP
			find (str(kpl->n_chek,8))
			if !found()
				append blank
				tmp->n_chek := kpl->n_chek
				tmp->pl_ort := 1
				tmp->stoim := kpl->cena
				kol_pl ++
				sum_pl += kpl->cena
				if !empty(kpl->sbank) //18.11.14
					kol_pl_b ++
					sum_pl_b += kpl->sbank
				endif
			endif
		endif
		select KPL
		skip
	enddo
	
	R_Use(dir_server+"kas_ort",dir_server+"kas_ort2","KOR")
	find (dtos(arr_m[5]))
	do while kor->k_data == arr_m[5] .and. !eof()
		if kor->smena == glob_smena .and. kor->n_chek > 0
			select TMP
			find (str(kor->n_chek,8))
			if !found()
				append blank
				tmp->n_chek := kor->n_chek
				tmp->pl_ort := 2
				tmp->stoim := kor->cena
				kol_or ++
				sum_or += kor->cena
				if !empty(kor->sbank)  //18.11.14
					kol_or_b ++
					sum_or_b += kor->sbank
				endif
			endif
		endif
		select KOR
		skip
	enddo
	select TMP
	go top
	arr := {{tmp->n_chek,tmp->n_chek}} ; i := 1
	do while !eof()
		if tmp->n_chek - arr[i,2] > 1
			aadd(arr, {tmp->n_chek,tmp->n_chek}) ; ++i
		else
			arr[i,2] := tmp->n_chek
		endif
		skip
	enddo
	close databases
	fp := fcreate(n_file) ; tek_stroke := 0 ; n_list := 1
	add_string("")
	add_string(center("���� �� ᬥ�� � "+lstr(glob_smena),sh))
	add_string(center(arr_m[4],sh))
	add_string(center("�����: "+alltrim(fio_polzovat),sh))
	add_string("")
	for i := 1 to len(arr)
		if arr[i,1] == arr[i,2]
			add_string("��� � "+lstr(arr[i,1]))
		else
			add_string("���� � � "+lstr(arr[i,1])+" �� � "+lstr(arr[i,2]))
		endif
	next
	add_string(replicate("�",sh))
	if kol_pl > 0
		add_string("������� ������   : "+lstr(kol_pl)+" 祪�� �� �㬬� "+lput_kop(sum_pl,.t.)+" ��.")
		if kol_pl_b > 0
			add_string(" � �.�. �����묨: "+lstr(kol_pl-kol_pl_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl-sum_pl_b,.t.)+" ��.")
			add_string("         �� ����: "+lstr(kol_pl_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl_b,.t.)+" ��.")
		endif
		add_string(replicate("�",sh))
	endif
	if kol_or > 0
		add_string("���������        : "+lstr(kol_or)+" 祪�� �� �㬬� "+lput_kop(sum_or,.t.)+" ��.")
		if kol_or_b > 0
			add_string(" � �.�. �����묨: "+lstr(kol_or-kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_or-sum_or_b,.t.)+" ��.")
			add_string("         �� ����: "+lstr(kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_or_b,.t.)+" ��.")
		endif
		add_string(replicate("�",sh))
	endif
	add_string("�_�_�_�_�        : "+lstr(kol_pl+kol_or)+" 祪�� �� �㬬� "+lput_kop(sum_pl+sum_or,.t.)+" ��.")
	if kol_pl_b > 0 .or. kol_or > 0
		add_string(" � �.�. �����묨: "+lstr(kol_pl-kol_pl_b+kol_or-kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl-sum_pl_b+sum_or-sum_or_b,.t.)+" ��.")
		add_string("         �� ����: "+lstr(kol_pl_b+kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl_b+sum_or_b,.t.)+" ��.")
	endif
	add_string(replicate("�",sh))
	for i := 1 to perenos(arr,"�㬬� �ய����:  "+srub_kop(sum_pl+sum_or,.t.),sh)
		add_string(arr[i])
	next
	add_string("")
	add_string("")
	add_string(center("�������: ________________",sh))
	fclose(fp)
	rest_box(buf)
	viewtext(n_file)
	
	return NIL


***** 25.09.14 �뢮� ᢮�� �� ��ਮ� �६��� (�� �ᥬ ᬥ���)
Function prn_k_svod_period()
	Local arr_m, buf, i, k, arr, n_file := "kassa_sv.txt", sh := 64, ;
		kol_pl := 0, sum_pl := 0, kol_or := 0, sum_or := 0, HH := 60,;
		kol_pl_b := 0, sum_pl_b := 0, kol_or_b := 0, sum_or_b := 0
	
	if (arr_m := year_month(T_ROW,T_COL+5)) == NIL
		return NIL
	endif
	buf := save_row(maxrow())
	mywait()
	R_Use(dir_server+"kas_pl",dir_server+"kas_pl2","KPL")
	dbseek(dtos(arr_m[5]),.t.)
	do while kpl->k_data <= arr_m[6] .and. !eof()
		if kpl->n_chek > 0
			kol_pl ++
			sum_pl += kpl->cena
			if kpl->sbank > 0
				kol_pl_b ++
				sum_pl_b += kpl->sbank
			endif
		endif
		select KPL
		skip
	enddo
	R_Use(dir_server+"kas_ort",dir_server+"kas_ort2","KOR")
	dbseek(dtos(arr_m[5]),.t.)
	do while kor->k_data <= arr_m[6] .and. !eof()
		if kor->n_chek > 0
			kol_or ++
			sum_or += kor->cena
			if kor->sbank > 0
				kol_or_b ++
				sum_or_b += kor->sbank
			endif
		endif
		select KOR
		skip
	enddo
	close databases
	fp := fcreate(n_file) ; tek_stroke := 0 ; n_list := 1
	add_string("")
	add_string(center("���� �� ����",sh))
	add_string(center(arr_m[4],sh))
	add_string("")
	add_string(replicate("�",sh))
	if kol_pl > 0
		add_string("������� ������   : "+lstr(kol_pl)+" 祪�� �� �㬬� "+lput_kop(sum_pl,.t.)+" ��.")
		if kol_pl_b > 0
			add_string(" � �.�. �����묨: "+lstr(kol_pl-kol_pl_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl-sum_pl_b,.t.)+" ��.")
			add_string("         �� ����: "+lstr(kol_pl_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl_b,.t.)+" ��.")
		endif
		add_string(replicate("�",sh))
	endif
	if kol_or > 0
		add_string("���������        : "+lstr(kol_or)+" 祪�� �� �㬬� "+lput_kop(sum_or,.t.)+" ��.")
		if kol_or_b > 0
			add_string(" � �.�. �����묨: "+lstr(kol_or-kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_or-sum_or_b,.t.)+" ��.")
			add_string("         �� ����: "+lstr(kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_or_b,.t.)+" ��.")
		endif
		add_string(replicate("�",sh))
	endif
	add_string("�_�_�_�_�        : "+lstr(kol_pl+kol_or)+" 祪�� �� �㬬� "+lput_kop(sum_pl+sum_or,.t.)+" ��.")
	if kol_pl_b > 0 .or. kol_or > 0
		add_string(" � �.�. �����묨: "+lstr(kol_pl-kol_pl_b+kol_or-kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl-sum_pl_b+sum_or-sum_or_b,.t.)+" ��.")
		add_string("         �� ����: "+lstr(kol_pl_b+kol_or_b)+" 祪�� �� �㬬� "+lput_kop(sum_pl_b+sum_or_b,.t.)+" ��.")
	endif
	add_string(replicate("�",sh))
	fclose(fp)
	rest_box(buf)
	viewtext(n_file)
	return NIL


*****
Function prn_k_plat()
	Local buf, i, j, k, arr_m, s, sh, HH := 78, reg_print,;
		arr_title, name_file := "kas_boln.txt",;
		ss := 0, skol := 0, susl := 0
		
	if (arr_m := year_month(T_ROW,T_COL+5,,1)) == NIL
		return NIL
	endif
	buf := save_row(maxrow())
	mywait()
	//
	dbcreate("tmp", {{"kod_k", "N", 7,0},; // ��� ���쭮�� �� ����⥪�
					{"rec_hp","N", 7,0},; // ����� ����� �� ���� "hum_..."
					{"n_chek","N", 8,0},; // ����� 祪�
					{"KOL"   ,"N", 5,0},; // ������⢮ ���
					{"STOIM" ,"N",10,2}}) // �⮣���� �⮨����� ��㣨
	use tmp new
	R_Use(dir_server+"kas_pl_u",dir_server+"kas_pl1u","HPU")
	R_Use(dir_server+"kas_pl",dir_server+"kas_pl2","HP")
	find (dtos(arr_m[5]))
	do while hp->k_data == arr_m[5] .and. !eof()
		if hp->smena == glob_smena
			select TMP
			append blank
			tmp->kod_k  := hp->kod_k
			tmp->n_chek := hp->n_chek
			tmp->rec_hp := hp->(recno())
			select HPU
			find (str(hp->(recno()),7))
			do while hpu->kod == hp->(recno()) .and. !eof()
				tmp->kol += hpu->kol
				tmp->stoim += hpu->stoim
				select HPU
				skip
			enddo
		endif
		select HP
		skip
	enddo
	j := tmp->(lastrec())
	close databases
	rest_box(buf)
	
	if j == 0
		func_error(4,"��� ᢥ����� "+arr_m[4]+", ᬥ�� "+lstr(glob_smena))
	else
		mywait()
		reg_print := 5
		R_Use(dir_server+"mo_pers",,"PERSO")
		R_Use(dir_server+"uslugi",,"USL")
		R_Use(dir_server+"kas_pl_u",dir_server+"kas_pl1u","HPU")
		set relation to u_kod into USL
		R_Use(dir_server+"kas_pl",,"HP")
		R_Use(dir_server+"kartotek",,"KART")
		use tmp new alias TMP
		set relation to kod_k into KART, to rec_hp into HP
		index on str(n_chek,8) to tmp
		arr_title := {;
			"������������������������������������������������������������������������������������",;
			"����� ���.� �.�.�. ���쭮��                                 � N 祪�� ���.��⮨�����",;
			"  �����   ���������������������������������������������������������Ĵ��㣳  ���  ",;
			"          �                                       ���   ���㣨    �     �         ",;
			"������������������������������������������������������������������������������������"}
		sh := len(arr_title[1])
		fp := fcreate(name_file) ; tek_stroke := 0 ; n_list := 1
		add_string("")
		add_string(center("������ ������ ���",sh))
		add_string(center(arr_m[4]+", ᬥ�� "+lstr(glob_smena),sh))
		add_string(center("���ॣ������: "+alltrim(fio_polzovat),sh))
		add_string("")
		aeval(arr_title, {|x| add_string(x) } )
		go top
		do while !eof()
			if verify_FF(HH-1,.t.,sh)
				aeval(arr_title, {|x| add_string(x) } )
			endif
			s := padr(amb_kartaN(),11)+;
				padr(kart->fio,49)+;
				put_val(tmp->n_chek,8)+;
				str(tmp->kol,4)+;
				put_kopE(tmp->stoim,12)
			add_string(s)
			add_string(replicate("-",sh))
			select HPU
			find (str(hp->(recno()),7))
			do while hpu->kod == hp->(recno())
				if verify_FF(HH,.t.,sh)
					aeval(arr_title, {|x| add_string(x) } )
				endif
				s := padl(lstr(ret_tabn(hpu->kod_vr)),54)+;
					space(4)+;
					usl->shifr+;
					str(hpu->kol,4)+;
					put_kopE(hpu->stoim,12)
				add_string(s)
				susl += hpu->kol
				//
				select HPU
				skip
			enddo
			add_string(replicate("=",sh))
			ss += tmp->stoim
			skol ++
			select TMP
			skip
		enddo
		close databases
		add_string(padr("�⮣� : "+lstr(skol)+" 祫.",sh-6-12)+;
             str(susl,6)+put_kopE(ss,12))
			 
		fclose(fp)
		rest_box(buf)
		viewtext(name_file,,,,(sh>80),,,reg_print)
	endif
	return NIL


********
Function prn_k_ort(k)
	Static si1 := 1, si2 := 1
	Local mas_pmt, mas_msg, mas_fun, j
	DEFAULT k TO 1
	
	do case
		case k == 1
			mas_pmt := {"������ �� ~����",;
					"~��������� �����"}
			mas_msg := {"��ᯥ�⪠ ॥��� ��⮯����᪨� ��� �� ����",;
					"���᮪ ���������� ���冷�"}
			mas_fun := {"prn_k_ort(11)",;
					"prn_k_ort(12)"}
			popup_prompt(T_ROW,T_COL-5,si1,mas_pmt,mas_msg,mas_fun)
		case k == 11
			prn_rees_ort()
		case k == 12
			prn_nez_nar()
	endcase
	if k > 10
		j := int(val(right(lstr(k),1)))
		if between(k,11,19)
			si1 := j
		endif
	endif
	return NIL



*****
Function prn_rees_ort()
	Local buf, i, j, k, arr_m, s, sh, HH := 78, reg_print,;
		arr_title, name_file := "kas_boln.txt",;
		ss[5], skol := 0, susl[5]
		
	if (arr_m := year_month(T_ROW,T_COL+5,,1)) == NIL
		return NIL
	endif
	buf := save_row(maxrow())
	mywait()
	//
	dbcreate("tmp", {{"kod_k", "N", 7,0},; // ��� ���쭮�� �� ����⥪�
					{"rec_hp","N", 7,0},; // ����� ����� �� ���� "hum_..."
					{"nomer_n","N",6,0},; // ����� ���鸞
					{"year_n","N",4,0},;  // ��� ���鸞
					{"n_chek","N", 8,0},; // ����� 祪�
					{"CENA","N",10,2},;   // �㬬� ������
					{"KOD_VR"   ,   "N",     4,     0},; // ��� ���
					{"KOD_TEX"  ,   "N",     4,     0},; // ��� �孨��
					{"KOL"   ,"N", 5,0},; // ������⢮ ���
					{"STOIM" ,"N",10,2}}) // �⮣���� �⮨����� ��㣨
	use tmp new
	R_Use(dir_server+"kas_ortu",dir_server+"kas_or1u","HPU")
	R_Use(dir_server+"kas_ort",dir_server+"kas_ort2","HP")
	find (dtos(arr_m[5]))
	do while hp->k_data == arr_m[5] .and. !eof()
		if hp->smena == glob_smena
			select TMP
			append blank
			tmp->kod_k   := hp->kod_k
			tmp->n_chek  := hp->n_chek
			tmp->cena    := hp->cena
			tmp->nomer_n := hp->nomer_n
			tmp->year_n  := hp->year_n
			tmp->rec_hp  := hp->(recno())
			select HPU
			find (str(hp->(recno()),7))
			do while hpu->kod == hp->(recno()) .and. !eof()
				tmp->kol += hpu->kol
				tmp->stoim += hpu->stoim
				select HPU
				skip
			enddo
		endif
		select HP
		skip
	enddo
	if (j := tmp->(lastrec())) > 0
		select HP
		set index to (dir_server+"kas_ort4")
		select TMP
		go top
		do while !eof()
			select HP
			find (str(tmp->year_n,4)+str(tmp->nomer_n,6))
			do while tmp->year_n==hp->year_n .and. tmp->nomer_n==hp->nomer_n .and. !eof()
				if hp->tip_n > 0
					tmp->KOD_VR  := hp->KOD_VR
					tmp->KOD_TEX := hp->KOD_TEX
				endif
				select HP
				skip
			enddo
			select TMP
			skip
		enddo
	endif
	close databases
	rest_box(buf)
	if j == 0
		func_error(4,"��� ᢥ����� "+arr_m[4]+", ᬥ�� "+lstr(glob_smena))
	else
		mywait()
		reg_print := 5
		R_Use(dir_server+"mo_pers",,"PERSO")
		R_Use(dir_server+"uslugi",,"USL")
		R_Use(dir_server+"kas_ortu",dir_server+"kas_or1u","HPU")
		set relation to u_kod into USL
		R_Use(dir_server+"kas_ort",,"HP")
		R_Use(dir_server+"kartotek",,"KART")
		use tmp new alias TMP
		set relation to kod_k into KART, to rec_hp into HP
		index on str(n_chek,8)+str(nomer_n,6) to tmp
		afill(ss,0) ; afill(susl,0)
		arr_title := {;
			"������������������������������������������������������������������������������������",;
			"����� ���.������ �  �.�.�. ���쭮��                  �     ���      � ���.��⮨�����",;
			"  �����   ����鸞�                                   �   � (�㬬�)  ���㣳  ���  ",;
			"�������������������������������������������������������������������Ĵ     �         ",;
			"                               ��� ���孨��  ��� ��㣨 �  ��㣨  �     �         ",;
			"������������������������������������������������������������������������������������"}
		sh := len(arr_title[1])
		fp := fcreate(name_file) ; tek_stroke := 0 ; n_list := 1
		add_string("")
		add_string(center("������ ��⮯����᪨� ���",sh))
		add_string(center(arr_m[4]+", ᬥ�� "+lstr(glob_smena),sh))
		add_string(center("���ॣ������: "+alltrim(fio_polzovat),sh))
		add_string("")
		aeval(arr_title, {|x| add_string(x) } )
		go top
		do while !eof()
			if verify_FF(HH-1,.t.,sh)
				aeval(arr_title, {|x| add_string(x) } )
			endif
			if tmp->n_chek < 0
				s1 := "-"
			else
				s1 := lstr(tmp->n_chek)+" ("+lstr(tmp->cena,11,2)+")"
			endif
			s := padr(amb_kartaN(),10)+;
				padc(alltrim(lstr(tmp->nomer_n)),8)+;
				padr(kart->fio,34)+" "+;
				padc(s1,16)+;
				str(tmp->kol,3)+;
				put_kopE(tmp->stoim,12)
				
			add_string(s)
			add_string(replicate("-",sh))
			select HPU
			find (str(hp->(recno()),7))
			do while hpu->kod == hp->(recno())
				if verify_FF(HH,.t.,sh)
					aeval(arr_title, {|x| add_string(x) } )
				endif
				s := str(ret_tabn(tmp->kod_vr),36)+;
					put_val(ret_tabn(tmp->kod_tex),7)+;
					padl(alltrim(inieditspr(1,mm_kas_vid,hpu->vid)),14)+;
					" "+usl->shifr+;
					str(hpu->kol,4)+;
					put_kopE(hpu->stoim,12)
				
				add_string(s)
				if between(hpu->vid,1,5)
					ss[hpu->vid] += hpu->stoim
					susl[hpu->vid] += hpu->kol
				endif
				//
				select HPU
				skip
			enddo
			skol ++
			add_string(replicate("=",sh))
			select TMP
			skip
		enddo
		close databases
		arr := {}
		for i := 1 to 5
			if susl[i] > 0
				aadd(arr,padl(mm_kas_vid[i,1],13)+str(susl[i],6)+put_kopE(ss[i],12))
			endif
		next
		if len(arr) > 0
			add_string(padr("�⮣� : "+lstr(skol)+" 祫.",sh-6-12-13)+arr[1])
			for i := 2 to len(arr)
				add_string(padl(arr[i],sh))
			next
		endif
		fclose(fp)
		rest_box(buf)
		viewtext(name_file,,,,(sh>80),,,reg_print)
	endif
	return NIL



*****
Function prn_nez_nar()
	Local buf := save_row(maxrow()), i, s1, s2, sh, HH := 60, reg_print, arr_title,;
		name_file := "nez_nar.txt"
		
	mywait()
	dbcreate("tmp", {{"kod_k", "N", 7,0},; // ��� ���쭮�� �� ����⥪�
					{"rec_hp","N", 7,0},; // ����� ����� �� ���� "hum_..."
					{"nomer_n","N",6,0},; // ����� ���鸞
					{"year_n","N",4,0},;  // ��� ���鸞
					{"summa","N",10,2},;  // �㬬� ���鸞 ��� ��ᯫ���� ���
					{"sum_opl","N",10,2},; // �㬬� ������
					{"KOD_VR","N",4,0}})  // ��� ���
	use tmp new
	use_base("kas_ortu","HU")
	R_Use(dir_server+"kas_ort",,"HUMAN")
	index on iif(tip_n>0,"1","2") to tmphum
	find ("1")
	do while human->tip_n > 0 .and. !eof()
		select TMP
		append blank
		tmp->kod_k   := human->kod_k
		tmp->rec_hp  := human->(recno())
		tmp->nomer_n := human->nomer_n
		tmp->year_n  := human->year_n
		tmp->KOD_VR  := human->kod_vr
		tmp->sum_opl := human->cena
		f1p_nez_nar()
		select HUMAN
		skip
	enddo
	select TMP
	index on str(year_n,4)+str(nomer_n,6) to tmp
	select HUMAN
	find ("2")
	do while human->tip_n == 0 .and. !eof()
		select TMP
		find (str(human->year_n,4)+str(human->nomer_n,6))
		if found()
			tmp->sum_opl += human->cena
			f1p_nez_nar()
		endif
		select HUMAN
		skip
	enddo
	R_Use(dir_server+"mo_pers",,"PERSO")
	arr_title := {;
		"�������������������������������������������������������������������������������������",;
		"                                    �     �  �����  �  �㬬�   �          � ��⠫��� ",;
		"                ���                ����.��  ���鸞 � �� �����  �����  � ������� ",;
		"�������������������������������������������������������������������������������������"}
	reg_print := f_reg_print(arr_title,@sh)
	fp := fcreate(name_file) ; tek_stroke := 0 ; n_list := 1
	add_string("")
	add_string(center("��������� ��⮯����᪨� �����",sh))
	add_string("")
	aeval(arr_title, {|x| add_string(x) } )
	select TMP
	set relation to kod_vr into PERSO
	index on upper(perso->fio)+str(year_n,4)+str(nomer_n,6) to tmp ;
		for !empty(round(summa-sum_opl,2))
		
	i := s1 := s2 := 0
	go top
	do while !eof()
		s := padr(lstr(++i)+". "+perso->fio,36)
		s += put_val(perso->tab_nom,6)
		s += " "+padr(lstr(tmp->nomer_n)+"/"+lstr(tmp->year_n),9)
		s += put_kop(tmp->summa,11)+put_kopE(tmp->sum_opl,11)
		s += put_kop(tmp->summa-tmp->sum_opl,11)
		s1 += tmp->summa
		s2 += tmp->sum_opl
		if verify_FF(HH-1,.t.,sh)
			aeval(arr_title, {|x| add_string(x) } )
		endif
		add_string(s)
		select TMP
		skip
	enddo
	close databases
	add_string(replicate("�",sh))
	add_string(padl("�⮣� : ",sh-11*3)+;
		put_kop(s1,11)+put_kopE(s2,11)+put_kop(s1-s2,11))
	fclose(fp)
	rest_box(buf)
	viewtext(name_file,,,,(sh>80),,,reg_print)
	return NIL

*****
Function f1p_nez_nar()

	select HU
	find (str(human->(recno()),7))
	do while hu->kod == human->(recno()) .and. !eof()
		if hu->vid != LPU_KAS_B_PL
			tmp->summa += hu->stoim
		endif
		if equalany(hu->vid,LPU_KAS_DMS,LPU_KAS_VZ)
			tmp->sum_opl += hu->stoim
		endif
		select HU
		skip
	enddo
	return NIL
