
#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

function settingsSystem()
	static mm_da_net := { { 'да ', 1 }, { 'нет', 2 } }
	static cgreen := 'G+/B'											// цвет для меток
	local oBox
	local oIniSystem := TSettingSystem():New( dir_server + 'system' ) 
	
	&& private mtest := 'Отправка', m1test
	private mSSL, m1SSL

	m1SSL := iif( oIniSystem:SSL, 1, 2 )
	mSSL := inieditspr( A__MENUVERT, mm_da_net, m1SSL )
	
	// просмотр и редактирование настроек сообщений
	oBox := TBox():New( 1, 0, 22, 78, .t. )
	&& oBox:Caption := ''
	&& oBox:CaptionColor := 'B+/B'
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - выход без записи;  ^<PgDn>^ - подтверждение ввода'
	oBox:View()

	ix := 2
	@ ix, 2 SAY 'Система обмена сообщениями:' color cgreen
	@ ++ix, 2 say 'Номер порта UDP для обмена сообщениями' get oIniSystem:PortUDP picture '99999'
	@ ++ix, 2 say 'Время задержки отправки широковещательных пакетов WHO в мин.' get oIniSystem:TimeDelay picture '99'
	
	&& ++ix
	&& @ ++ix, 2 SAY 'Электронная почта:' color cgreen
	&& @ ++ix, 2 say 'E-mail' get oIniSystem:EMail picture 'XXXXXXXXXXXXXXXXXXXX'
	&& @ ++ix, 2 say 'Сервер входящей почты (POP3)' get oIniSystem:ServerPOP3 picture 'XXXXXXXXXXXXXXXXXXXX'
	&& @ ++ix, 2 say 'Сервер исходящей почты (SMTP)' get oIniSystem:ServerSMTP picture 'XXXXXXXXXXXXXXXXXXXX'
	&& @ ++ix, 2 say 'Имя пользователя E-mail' get oIniSystem:Login picture 'XXXXXXXXXXXXXXXXXXXX'
	&& @ ++ix, 2 say 'Пароль пользователя E-mail' get oIniSystem:EMailPassword picture 'XXXXXXXXXXXXXXXXXXXX'
	&& @ ++ix, 2 say 'Использовать протокол SSL' get mSSL ;
		&& reader { | x | menu_reader( x, mm_da_net, A__MENUVERT, , ,.f. ) }
	
	// @ ++ix, 2 say 'Проверка почты ...' get mtest ;
		// reader { | x | menu_reader( x, { { || SendFile() } }, A__FUNCTION, , , .f. ) }
	
	myread()
	if f_Esc_Enter( 1 )
		oIniSystem:SSL := iif( m1SSL == 2, .f., .t. )
		oIniSystem:Save()
	endif
	return nil
	
&& function SendFile()
	&& local ret := .f.
	&& local nameZipFile := cur_dir() + "error.zip"
	&& local serverSMTP, body, subject
	&& local lSSL
	&& local oIniSystem := TSettingSystem():New( dir_server + 'system' ) 

	&& if ! tip_SSL()
		&& hb_Alert( 'No SSL' )
		&& return nil
	&& endif

	&& cPassword := oIniSystem:EMailPassword
	&& cFrom := oIniSystem:Email
	&& cTo := 'vbaykin@mail.ru'
	
	&& serverSMTP := oIniSystem:ServerSMTP
	&& body := "Файл ошибок: " + glob_mo[ _MO_FULL_NAME ]
	&& subject := "Учреждение: " + glob_mo[ _MO_KOD_TFOMS ]
	
	&& nameZipFile := dir_server + 'error.txt'
	&& ret := hb_SendMail( ;
		&& serverSMTP, ;
		&& Val( if( lSSL, '465', '25' ) ), ;
		&& cFrom, ;
		&& cTo, ;
		&& nil /* CC */, ;
		&& {} /* BCC */, ;
		&& body, ;
		&& subject, ;
		&& { nameZipFile } /* attachment */, ;
		&& cFrom, ;
		&& cPassword, ;
		&& '', ;
		&& nil /* nPriority */, ;
		&& nil /* lRead */, ;
		&& .f. /* lTrace */, ;
		&& .f., ;
		&& nil /* lNoAuth */, ;
		&& nil /* nTimeOut */, ;
		&& nil /* cReplyTo */, ;
		&& lSSL /* lSSL */, ;
		&& , ;
		&& 'CP866' )
	&& if ret
		&& hb_Alert( 'Отправка прошла успешно' )
	&& else
		&& hb_Alert( 'Отправка завершилась неудачно' )
	&& endif
	&& return nil