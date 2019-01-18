************************************
* 14.11.18 viewDuplicateRecords() - ¯®¨áª § ¯¨á¥©-¤ã¡«¨ª â®¢ ¢ ª àâ®â¥ª¥
************************************

#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 14.11.18 - ¯®¨áª § ¯¨á¥©-¤ã¡«¨ª â®¢ ¢ ª àâ®â¥ª¥
function viewDuplicateRecords()
	static si := 1
	local hGauge, sh, HH := 77, name_file := 'dubl_zap' + stxt, j1, ;
		fl := .t., sfio, old_fio, k := 0, rec1, curr := 0, buf,;
		mfio, mdate_r, mpolis, arr_title, reg_print := 4, ;
		arr := { ' ® ~”ˆ+¤ â  à®¦¤. ', ' ® ~¯®«¨áã ', ' ® ~‘ˆ‹‘ ', ' ® ~… ' }

	if ( i := f_alert( { '‚ë¡¥à¨â¥, ª ª¨¬ ®¡à §®¬ ¡ã¤¥â ®áãé¥áâ¢«ïâìáï ¯®¨áª ¤ã¡«¨ª â®¢ § ¯¨á¥©:', ;
				'' }, ;
				arr, ;
				si, 'N+/BG', 'R/BG', 15, , col1menu ) ) == 0
		return nil
	endif
	
	si := i
	
	if ! myFileDeleted(cur_dir + 'tmp' + sdbf )
		return nil
	endif
	if ! myFileDeleted( cur_dir + 'tmpitg' + sdbf )
		return nil
	endif
	dbcreate( cur_dir + 'tmpitg', { ;
			{ 'ID', 'N', 8, 0 }, ;
			{ 'fio', 'C', 50, 0 }, ;
			{ 'DATE_R', 'D', 8, 0 }, ;
			{ 'kod_kart', 'N', 8, 0 }, ;
			{ 'kod_tf', 'N', 10, 0 }, ;
			{ 'kod_mis', 'C', 20, 0 }, ;
			{ 'adres', 'C', 50, 0 }, ;
			{ 'fio', 'C', 50, 0 }, ;
			{ 'pol', 'C', 1, 0 }, ;
			{ 'polis', 'C', 17, 0 }, ;
			{ 'uchast', 'N', 2, 0 }, ;
			{ 'KOD_VU', 'N', 5, 0 }, ; // ª®¤ ¢ ãç áâª¥
			{ 'snils', 'C', 17, 0 }, ;
			{ 'DATE_PR', 'D', 8, 0 }, ;
			{ 'MO_PR', 'C', 6, 0 } ;
	} )
	use ( cur_dir + 'tmpitg' ) new
	R_Use( dir_server + 'kartote2', , 'KART2' )
//
	status_key( '^<Esc>^ - ¯à¥à¢ âì ¯®¨áª' )
	hGauge := GaugeNew( , , , '®¨áª ¤ã¡«¨àãîé¨åáï § ¯¨á¥©', .t. )
	GaugeDisplay( hGauge )
	
	if i == 1
		arr_title := { 'ÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄ', ;
					' NN ³                   ”.ˆ..                    ³ „ â  à.³Š®«-¢®', ;
					'ÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄ' }
		sh := len( arr_title[ 1 ] )
		fp := fcreate( name_file )
		n_list := 1
		tek_stroke := 0
		add_string( '' )
		add_string( center( '‘¯¨á®ª ¤ã¡«¨àãîé¨åáï § ¯¨á¥© ¢ ª àâ®â¥ª¥', sh ) )
		add_string( center( '(áà ¢­¥­¨¥ ¯® ¯®«î "”.ˆ.." + "„ â  à®¦¤¥­¨ï")', sh ) )
		add_string( '' )
		aeval( arr_title, { | x | add_string( x ) } )
		dbcreate( cur_dir + 'tmp', { { 'fio', 'C', 50, 0 }, { 'DATE_R', 'D', 8, 0 } } )
		use ( cur_dir + 'tmp' ) new
		index on upper( fio ) + dtos( date_r ) to ( cur_dir + 'tmp' )
		R_Use( dir_server + 'kartotek', dir_server + 'kartoten', 'KART' )
		set relation to recno() into KART2
		index on upper( fio ) + dtos( date_r ) to ( cur_dir + 'tmp_kart' ) for kod > 0
		go top
		do while ! eof()
			GaugeUpdate( hGauge, ++curr/lastrec() )
			if inkey() == K_ESC
				add_string( replicate( '*', sh ) )
				add_string( expand( 'ˆ‘Š …‚€' ) )
				stat_msg( '®¨áª ¯à¥à¢ ­!' )
				mybell( 1, OK )
				exit
			endif
			mfio := upper( kart->fio )
			mdate_r := kart->date_r
			rec1 := recno()
			j1 := 0
			find ( mfio + dtos( mdate_r ) )
			do while upper( kart->fio ) == mfio .and. kart->date_r == mdate_r .and. ! eof()
				if kart->(recno()) != rec1
					j1++
				endif
				skip
			enddo
			goto ( rec1 )
			if j1 > 0
				select TMP
				find ( mfio + dtos( mdate_r ) )
				if !found()
				append blank
				tmp->fio := mfio
				tmp->date_r := mdate_r
				if verify_FF( HH, .t., sh )
					aeval( arr_title, { | x | add_string( x ) } )
				endif
				++k
				add_string( put_val( k, 4 ) + '. ' + padr( mfio, 44 ) + ' ' + date_8( mdate_r ) + str( j1 + 1, 5 ) )
				select TMPITG
				append blank
				TMPITG->id       := k
				TMPITG->fio      := kart->fio
				TMPITG->DATE_R   := kart->date_r
				TMPITG->kod_kart := kart->kod
				TMPITG->adres    := kart->adres
				TMPITG->pol      := kart->pol
				TMPITG->polis    := kart->polis
				TMPITG->uchast   := kart->uchast
				TMPITG->kod_vu   := kart->kod_vu
				TMPITG->snils    := transform( kart->snils, picture_pf )
				TMPITG->DATE_PR  := kart2->date_pr
				TMPITG->MO_PR    := kart2->mo_pr
				TMPITG->kod_tf   := kart2->kod_tf
				TMPITG->kod_mis  := kart2->kod_mis
				if lastrec() % 1000 == 0
					commit
				endif
				endif
			endif
			@ maxrow(), 1 say lstr( curr ) color 'W+/R'
			@ row(), col() say '/' color 'W/R'
			@ row(), col() say lstr( 'k' ) color 'G+/R'
			select KART
			skip
		enddo
	elseif i == 2
		mpolis := space(17)
		fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
		arr_title := {;
		"ÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ",;
		" NN ³      ®«¨á      ³ü  ¬¡.ª. ³                      ”.ˆ..                      ³ „ â  à.",;
		"ÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ"}
		sh := len(arr_title[1]) ; reg_print := 5
		add_string("")
		add_string(center("‘¯¨á®ª ¤ã¡«¨àãîé¨åáï § ¯¨á¥© ¢ ª àâ®â¥ª¥",sh))
		add_string(center('(áà ¢­¥­¨¥ ¯® ¯®«î "®«¨á")',sh))
		add_string("")
		aeval(arr_title, {|x| add_string(x) } )
		dbcreate(cur_dir+"tmp",{{"POLIS","C",17,0}})
		use (cur_dir+"tmp") new
		index on polis to (cur_dir+"tmp")
		R_Use(dir_server+"kartotek",dir_server+"kartotep","KART")
		set relation to recno() into KART2
		find ("1")
		do while !eof()
			GaugeUpdate( hGauge, ++curr/lastrec() )
			if inkey() == K_ESC
				add_string(replicate("*",sh))
				add_string(expand("ˆ‘Š …‚€"))
				stat_msg("®¨áª ¯à¥à¢ ­!") ; mybell(1,OK)
				exit
			endif
			if kart->kod > 0 .and. !empty(CHARREPL("*-0",kart->polis,space(3)))
				mpolis := kart->polis ; mfio := kart->fio
				rec1 := recno() ; j1 := 0
				find ("1"+mpolis)
				do while kod > 0 .and. kart->polis == mpolis .and. !eof()
					if recno() != rec1
						j1++
					endif
					skip
				enddo
				goto (rec1)
				if j1 > 0
					select TMP
					find (mpolis)
					if !found()
						append blank
						tmp->polis := mpolis
						++k ; j1 := 0
						select KART
						find ("1"+mpolis)
						do while kod > 0 .and. kart->polis == mpolis .and. !eof()
							if verify_FF(HH,.t.,sh)
								aeval(arr_title, {|x| add_string(x) } )
							endif
							++j1
							s := iif(j1==1, padr(lstr(k)+".",5), space(5))
							add_string(s+mpolis+" "+padr(amb_kartaN(.t.),10)+;
										padr(kart->fio,50)+" "+date_8(kart->date_r))
							select TMPITG
							append blank
							TMPITG->id       := k
							TMPITG->fio      := kart->fio
							TMPITG->DATE_R   := kart->date_r
							TMPITG->kod_kart := kart->kod
							TMPITG->adres    := kart->adres
							TMPITG->pol      := kart->pol
							TMPITG->polis    := kart->polis
							TMPITG->uchast   := kart->uchast
							TMPITG->kod_vu   := kart->kod_vu
							TMPITG->snils    := transform(kart->snils,picture_pf)
							TMPITG->DATE_PR  := kart2->date_pr
							TMPITG->MO_PR    := kart2->mo_pr
							TMPITG->kod_tf   := kart2->kod_tf
							TMPITG->kod_mis  := kart2->kod_mis
							if lastrec() % 1000 == 0
								commit
							endif
							select KART
							skip
						enddo
						goto (rec1)
					endif
					select KART
				endif
			endif
			@ maxrow(),1 say lstr(curr) color "W+/R"
			@ row(),col() say "/" color "W/R"
			@ row(),col() say lstr(k) color "G+/R"
			skip
		enddo
	elseif i == 3
		fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
		arr_title := {;
		"ÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ",;
		" NN ³    ‘ˆ‹‘     ³ü  ¬¡.ª. ³                      ”.ˆ..                      ³ „ â  à.",;
		"ÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ"}
		sh := len(arr_title[1]) ; reg_print := 5
		add_string("")
		add_string(center("‘¯¨á®ª ¤ã¡«¨àãîé¨åáï § ¯¨á¥© ¢ ª àâ®â¥ª¥",sh))
		add_string(center('(áà ¢­¥­¨¥ ¯® ¯®«î "‘ˆ‹‘")',sh))
		add_string("")
		aeval(arr_title, {|x| add_string(x) } )
		dbcreate(cur_dir+"tmp",{{"SnilS","C",11,0}})
		use (cur_dir+"tmp") new
		index on snils to (cur_dir+"tmp")
		R_Use(dir_server+"kartotek",dir_server+"kartotes","KART")
		set relation to recno() into KART2
		find ("1")
alertx(time())
		do while !eof()
			GaugeUpdate( hGauge, ++curr/lastrec() )
			if inkey() == K_ESC
				add_string(replicate("*",sh))
				add_string(expand("ˆ‘Š …‚€"))
				stat_msg("®¨áª ¯à¥à¢ ­!") ; mybell(1,OK)
				exit
			endif
			if kart->kod > 0 .and. !empty(CHARREPL("0",kart->snils," "))
				msnils := kart->snils ; mfio := kart->fio
				rec1 := recno() ; j1 := 0
				find ("1"+msnils)
				do while kod > 0 .and. kart->snils == msnils .and. !eof()
					if recno() != rec1
						j1++
					endif
					skip
				enddo
				goto (rec1)
				if j1 > 0
					select TMP
					find (msnils)
					if !found()
						append blank
						tmp->snils := msnils
						++k ; j1 := 0
						select KART
						find ("1"+msnils)
						do while kod > 0 .and. kart->snils == msnils .and. !eof()
							if verify_FF(HH,.t.,sh)
								aeval(arr_title, {|x| add_string(x) } )
							endif
							++j1
							s := iif(j1==1, padr(lstr(k)+".",5), space(5))
							add_string(s+transform(msnils,picture_pf)+" "+padr(amb_kartaN(.t.),10)+;
										padr(kart->fio,50)+" "+date_8(kart->date_r))
							select TMPITG
							append blank
							TMPITG->id       := k
							TMPITG->fio      := kart->fio
							TMPITG->DATE_R   := kart->date_r
							TMPITG->kod_kart := kart->kod
							TMPITG->adres    := kart->adres
							TMPITG->pol      := kart->pol
							TMPITG->polis    := kart->polis
							TMPITG->uchast   := kart->uchast
							TMPITG->kod_vu   := kart->kod_vu
							TMPITG->snils    := transform(kart->snils,picture_pf)
							TMPITG->DATE_PR  := kart2->date_pr
							TMPITG->MO_PR    := kart2->mo_pr
							TMPITG->kod_tf   := kart2->kod_tf
							TMPITG->kod_mis  := kart2->kod_mis
							if lastrec() % 1000 == 0
								commit
							endif
							select KART
							skip
						enddo
						goto (rec1)
					endif
					select KART
				endif
			endif
			@ maxrow(),1 say lstr(curr) color "W+/R"
			@ row(),col() say "/" color "W/R"
			@ row(),col() say lstr(k) color "G+/R"
			skip
		enddo
alertx(time())
	elseif i == 4
TPatientDB():getDublicateSinglePolicyNumber()
		arr_title := {;
			"ÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ",;
			" NN ³       …      ³ ü  ¬¡.ª.³                     ”.ˆ..                       ³ „ â  à.",;
			"ÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ"}
		sh := len(arr_title[1]) ; reg_print := 5
		fp := fcreate(name_file) ; n_list := 1 ; tek_stroke := 0
		add_string("")
		add_string(center("‘¯¨á®ª ¤ã¡«¨àãîé¨åáï § ¯¨á¥© ¢ ª àâ®â¥ª¥",sh))
		add_string(center('(áà ¢­¥­¨¥ ¯® ¯®«î … "…¤¨­ë© ®¬¥à ®«¨á ")',sh))
		add_string("")
		aeval(arr_title, {|x| add_string(x) } )
		dbcreate(cur_dir+"tmp",{{"kod_mis","C",20,0}})
		use (cur_dir+"tmp") new
		index on kod_mis to (cur_dir+"tmp")
		R_Use(dir_server+"kartote_",,"KART_")
		R_Use(dir_server+"kartotek",,"KART")
		select KART2
		set relation to recno() into KART, to recno() into KART_
		index on kod_mis to (cur_dir+"tmp_kodmis") for !empty(kod_mis) .and. !empty(kart->kod) 
		go top
		do while !eof()
			GaugeUpdate( hGauge, ++curr/lastrec() )
			if inkey() == K_ESC
				add_string(replicate("*",sh))
				add_string(expand("ˆ‘Š …‚€"))
				stat_msg("®¨áª ¯à¥à¢ ­!") ; mybell(1,OK)
				exit
			endif
			mkod_mis := kart2->kod_mis ; mfio := kart->fio
			rec1 := recno() ; j1 := 0
			find (mkod_mis)
			do while kart2->kod_mis == mkod_mis .and. !eof()
				if recno() != rec1
					j1++
				endif
				skip
			enddo
			goto (rec1)
			if j1 > 0
				select TMP
				find (mkod_mis)
				if !found()
					append blank
					tmp->kod_mis := mkod_mis
					++k
					j1 := 0
					select KART2
					find (mkod_mis)
					do while kart2->kod_mis == mkod_mis .and. !eof()
						if verify_FF(HH,.t.,sh)
							aeval(arr_title, {|x| add_string(x) } )
						endif
						++j1
						s := iif(j1==1, padr(lstr(k)+".",5), space(5))
						add_string(s+left(mkod_mis,16)+" "+padr(amb_kartaN(.t.),10)+;
								padr(alltrim(kart->fio)+" ("+alltrim(inieditspr(A__MENUVERT,mm_vid_polis,kart_->VPOLIS))+;
										" ¯®«¨á)",50)+" "+date_8(kart->date_r))
						select TMPITG
						append blank
						TMPITG->id       := k
						TMPITG->fio      := kart->fio
						TMPITG->DATE_R   := kart->date_r
						TMPITG->kod_kart := kart->kod
						TMPITG->adres    := kart->adres
						TMPITG->pol      := kart->pol
						TMPITG->polis    := kart->polis
						TMPITG->uchast   := kart->uchast
						TMPITG->kod_vu   := kart->kod_vu
						TMPITG->snils    := transform(kart->snils,picture_pf)
						TMPITG->DATE_PR  := kart2->date_pr
						TMPITG->MO_PR    := kart2->mo_pr
						TMPITG->kod_tf   := kart2->kod_tf
						TMPITG->kod_mis  := kart2->kod_mis
						if lastrec() % 1000 == 0
							commit
						endif
						select KART2
						skip
					enddo
				endif
			endif
			select KART2
			goto (rec1)
			@ maxrow(),1 say lstr(curr) color "W+/R"
			@ row(),col() say "/" color "W/R"
			@ row(),col() say lstr(k) color "G+/R"
			skip
		enddo
	endif
	close databases
	fclose( fp )
	CloseGauge( hGauge )
	if k == 0
		func_error( 4, '¥ ­ ©¤¥­® ¤ã¡«¨àãîé¨åáï § ¯¨á¥©!' )
	else
		viewtext( name_file, , , , .t., , , reg_print )
	endif
	return nil