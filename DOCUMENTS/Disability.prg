#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 06.12.18 ввод информации об инвалидности
function inputDisability( row1, oPatient, /*@*/sDisability )
	local c := 2, r1, r2, buf, tmp_help, tmp_list
	local tmp_keys, pic_diag := '@K@!', bg := { | o, k | get_MKB10( o, k, .t. ) }
	local oBox
	local oDisability
	
	if lastkey() != K_ENTER
		return nil
	endif
	
	private minvalid, m1invalid
	private mprich := space( 10 ), m1prich := 0	// причина первичного установления инвалидности
	private mDiagnosis
	
	oDisability := oPatient:Disability
	
	m1invalid := oDisability:Invalid
	minvalid := inieditspr( A__MENUVERT, TDisability():aMenuType, m1invalid )
	m1prich := oDisability:Reason
	mprich := inieditspr( A__MENUVERT, TDisability():aMenuReason, m1prich )
	mDiagnosis := oDisability:Diagnosis
	
	r2 := row1 - 1
	r1 := r2 - 6
	buf := savescreen()
	SAVE GETS TO tmp_list
	tmp_keys := my_savekey()
	change_attr()
	
	oBox := TBox():New( r1, c, r2, 77, .t. )
	oBox:Caption := 'Ввод информации об инвалидности'
	oBox:CaptionColor := 'G+/B+'
	oBox:MessageLine := '^<Esc>^ - выход;  ^<PgDn>^ - запись и переход в карточку пациента'
	oBox:View()

	@ r1 + 1, c + 1 say 'Инвалидность' get minvalid  ;
			reader { | x | menu_reader( x, TDisability():aMenuType, A__MENUVERT, , , .f. ) }
	@ r1 + 2, c + 1 say 'Дата первичного установления инвалидности' get oDisability:Date ;
			valid { | | ! empty( oDisability:Date ) .and. oPatient:DOB < oDisability:Date .and. oDisability:Date < sys_date } ;
			when ( m1invalid != 0 )
	@ r1 + 3, c + 1 say 'Причина первичного установления инвалидности'
	@ r1 + 4, c + 3 get mprich reader { | x | menu_reader( x, TDisability():aMenuReason, A__MENUVERT, , , .f. ) } ;
			valid m1prich > 0 when ( m1invalid != 0 )
	@ r1 + 5, c + 1 say 'Код основного заболевания (п.4 пп."а")' get mDiagnosis picture pic_diag ;
					reader { | o | MyGetReader( o, bg ) } ;
					valid  val1_10diag( .t., .f., .f., oDisability:Date, oPatient:Gender ) ;
					when ( m1invalid != 0 )
	myread()
	if lastkey() != K_ESC
		oDisability:Invalid := m1invalid
		oDisability:Reason := m1prich
		oDisability:Diagnosis := mDiagnosis
		if ! isnil( sDisability ) .and. oDisability:Invalid != 0
			sDisability := padr( oDisability:AsString, 60 )
		elseif oDisability:Invalid == 0
			sDisability := padr( 'Ввести данные об инвалидности', 60 )
		endif
		oPatient:Disability := oDisability
	endif
	oBox := nil
	restscreen( buf )
	my_restkey( tmp_keys )
	RESTORE GETS FROM tmp_list
	return .t.