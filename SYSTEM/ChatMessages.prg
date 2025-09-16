/*
 * Модуль для отправки и получение сообщений используя протокол UDP
 *
 * Серверная часть модуля использует
 * потоки, поэтому он должен быть скомпилирован в режиме MT.
 *
 * Функции сервера:
 * udpServerStart ( cUser ) -> hServer - запуск сервера UDP
 * udpServerStop ( hServer, cUser ) - останов сервера UDP
 *
 * Клиентская функция:
 * udpSendMessage ( cType, cSender, cText )
 *
 */

#require 'xhb'
#require 'hbmisc'

#include 'hbdll.ch'
#include 'hbsocket.ch'
#include 'hbhash.ch'
#include 'inkey.ch'
#include 'setcurs.ch'

#include 'Memoedit.ch'
#include 'function.ch'

static hb_sendMessage_activeTask			// Hash-массив зарегистрированных задач
static mutexActiveTask					// мьютекс для массива ActiveTask
static st_Sender							// идентификатор отправителя - текущая задача
static st_EnterDate						// дата запуска в задачи
static st_EnterTime						// время запуска задачи
static MSG_PORT //:= 39999					// порт UDP для приема/отправки сообщений
static nTimeDelay //:= 1000 * 60 * 2		// время задержки 2 минуты отправки широковещательных пакетов WHO (кто зарегистрирован)
static st_hMutex							// mutex для синхронизации

IMPORT static MessageBox( hWnd, cMsg, cText, nFlags ) FROM user32.dll EXPORTED AS MessageBoxA

procedure SendMessage()
	local nTop, nLeft, nBottom, nRight
	local tmp_color, buf := save_maxrow(), buf1
	local cText := space( 1900 ), cText1251
	local aSelectedUsers := {}
	local item
	
	nTop := 5
	nLeft := 5
	nBottom := 15
	nRight := 75
	if ( len( aSelectedUsers := MultipleSelectedReceiver( 5, 5 ) ) ) > 0
		tmp_color := setcolor( cDataCGet )
		buf1 := box_shadow( nTop, nLeft, nBottom, nRight, , ;
				win_AnsiToOEM( 'Текст сообщения (не более 1900 символов)' ), color8 )
		setcolor(cDataCGet)
		status_key( win_AnsiToOEM( '^<Esc>^ - выход без отправки;  ^<Ctrl-W>^ - отправить' ) )
		cText = MemoEdit( cText, nTop + 1, nLeft + 1, nBottom - 1, nRight - 1, .t. )
		cText := TabExpand( cText, 4 )
		cText := StrTran( cText, hb_BChar( 141 ), hb_BChar( 32 ) ) //пропадает русская 'Н'
		cText := StrTran( cText, hb_BChar( 13 ), hb_BChar( 32 ) )
		cText := StrTran( cText, hb_BChar( 10 ), hb_BChar( 32 ) )
		rest_box( buf )
		rest_box( buf1 )
		if !empty( cText := ( alltrim( cText ) ) )
			cText1251 := win_OEMToAnsi( cText )
			for each item in aSelectedUsers
				udpSendMessage( 'MSG', item:IDTask, hb_user_curUser:Name1251, cText1251 ) // отправить всем
			next
		endif
	endif
	return
	
/* Server */

function udpServerStart( cUser, cFileINI )
	local hSocket
	local oIniSystem := TSettingSystem():New( cFileINI ) 

	MSG_PORT := oIniSystem:PortUDP					// порт UDP для приема/отправки сообщений
	nTimeDelay := 1000 * 60 * oIniSystem:TimeDelay		// время задержки 2 минуты отправки широковещательных пакетов WHO (кто зарегистрирован)
	
	hb_sendMessage_activeTask := hb_Hash()
	hb_HAutoAdd( hb_sendMessage_activeTask, HB_HAUTOADD_ALWAYS )
	// назначим идентификатор отправителя - как время в миллисекундах
	st_Sender := str( hb_MilliSeconds(), 15, 0 )
	st_EnterDate := date()
	st_EnterTime := time()
	//
	if ! Empty( hSocket := hb_socketOpen( , HB_SOCKET_PT_DGRAM ) )
		if hb_socketBind( hSocket, { HB_SOCKET_AF_INET, '0.0.0.0', MSG_PORT } )
			hb_threadDetach( hb_threadStart( @ListenerUDP(), hSocket, st_Sender, cUser ) )
			st_hMutex := hb_mutexCreate()
			&& hb_threadDetach( hb_threadStart( @WhoIsHere(), cUser ) )		// запуск опроса активных пользователей в отдельном потоке
			udpSendMessage( 'HEL', 'ALL', cUser, '' )
			millisec( 100 )		// задержка на 100 миллисекунд
			udpSendMessage( 'WHO', 'ALL', cUser, '' )
			return hSocket
		endif
		hb_socketClose( hSocket )
	endif
   return nil

procedure udpServerStop( hSocket, cUser )

	udpSendMessage( 'KIL', 'ALL', cUser, '' )
	hb_socketClose( hSocket )
	return

static procedure udpMessageView( cCaption, cBuffer )

	MessageBox( 0, cBuffer, cCaption )	// вывод сообщения
	return

&& static procedure WhoIsHere( cUser )

	&& do while .t.
		&& millisec( nTimeDelay )		// задержка на 2 минуты
		&& udpSendMessage( 'WHO', 'ALL', cUser, '' )
	&& enddo
	&& return
	
static procedure ListenerUDP( hSocket, cIDTask, cUser )
	local cBuffer, nLen, aAddr
	local cText, cMsg, cReciever
	local cSender, cFIO1251, cFIO866
	local cDate, cTime
	local nLen_IDTask := len( cIDTask )
	local lenMessage
	local cUserComp
	local cMessage
	local cCaption

	do while .t.
		cBuffer := space( 2000 )
		begin sequence with {| oErr | break( oErr ) }
			nLen := hb_socketRecvFrom( hSocket, @cBuffer, , , @aAddr, 1000 )
		recover
			nLen := nil
		end sequence
		&& if nLen == nil
			&& exit
		&& endif
		if nLen == -1
			if hb_socketGetError() != HB_SOCKET_ERR_TIMEOUT
				return
			endif
		else
			lenMessage := val( left( cBuffer, 4 ) )
			cSender := substr( cBuffer, 5, nLen_IDTask )
			if cSender != cIDTask
				cReciever := substr( cBuffer, nLen_IDTask + 5, nLen_IDTask )
				if  cReciever == '000000000000000' .or. cReciever == st_Sender
					cFIO1251 := substr( cBuffer, ( nLen_IDTask * 2 ) + 5, 20 )
					cFIO866 := win_AnsiToOEM( cFIO1251 )
					cDate := substr( cBuffer, ( nLen_IDTask * 2 ) + 25, 10 )
					cTime := substr( cBuffer, ( nLen_IDTask * 2 ) + 35, 8 )
					cMsg := substr( cBuffer, ( nLen_IDTask * 2 ) + 43, 3 )
					cUserComp := substr( cBuffer, ( nLen_IDTask * 2 ) + 46, lenMessage - 46 )
					cMessage := substr( cBuffer, lenMessage + 5 )
					switch cMsg
						case 'MSG'
							cCaption := 'Сообщение от: ' + alltrim( cFIO1251 ) + ;
								', дата: ' + cDate + ;
								' (' + cTime + ')'
							hb_threadDetach( hb_threadStart( @udpMessageView(), cCaption, cMessage ) )
							exit
						case 'KIL'
							hb_mutexLock( st_hMutex )
							hb_hDel( hb_sendMessage_activeTask, cSender )
							hb_mutexUnLock( st_hMutex )
							exit
						case 'WHO'
							udpSendMessage( 'ANS', cSender, cUser, '' )
							exit
						case 'ANS'
							hb_mutexLock( st_hMutex )
							if !hb_hHaskey( hb_sendMessage_activeTask, cSender )
								hb_hSet( hb_sendMessage_activeTask, cSender, { cFIO866, cDate, cTime, cUserComp } )
							endif
							hb_mutexUnLock( st_hMutex )
							exit
						case 'HEL'
							hb_mutexLock( st_hMutex )
							hb_hSet( hb_sendMessage_activeTask, cSender, { cFIO866, cDate, cTime, cUserComp } )
							hb_mutexUnLock( st_hMutex )
							exit
						otherwise
					endswitch
				endif
			endif
		endif
	enddo
	return
	
/* Client */

procedure udpSendMessage( cType, cReciever, cSender, cText )
	local hSocket, nEnd, nTime, cBuffer, nLen, aAddr
	local cHeader := ''
	local lenHeader

	hb_defaultValue( cType, 'MSG' )
	if upper( cReciever ) == 'ALL'
		cReciever := '000000000000000'	// отправка для всех
	endif
	cHeader := st_Sender + cReciever + padl( cSender, 20 ) + dtoc( st_EnterDate ) + st_EnterTime + cType + netname() + '\' + hb_Username()
	lenHeader := str( len( cHeader ), 4 )
	cBuffer := lenHeader + cHeader
	switch cType
		case 'MSG'
			cBuffer += alltrim( cText )
			exit	// обязательно, для выхода из переключателя
		otherwise
			exit	// обязательно, для выхода из переключателя
	endswitch
	if !empty( hSocket := hb_socketOpen( , HB_SOCKET_PT_DGRAM ) )
		hb_socketSetBroadcast( hSocket, .t. )
		s_sendBroadcastMessages( hSocket, MSG_PORT, cBuffer )
		hb_socketClose( hSocket )
	endif
	return

static function s_sendBroadcastMessages( hSocket, nPort, cMessage )
	local lResult, cAddr
	lResult := .f.
	for each cAddr in s_getBroadcastAddresses()
		if hb_socketSendTo( hSocket, cMessage, , , ;
				{ HB_SOCKET_AF_INET, cAddr, nPort } ) == hb_BLen( cMessage )
			lResult := .t.
		endif
	next
	return lResult

static function s_getBroadcastAddresses()
	local aIF, cAddr
	local lLo := .f.
	local aAddrs := {}

	for each aIF in hb_socketGetIFaces()
		if empty( cAddr := aIF[ HB_SOCKET_IFINFO_BROADCAST ] )
			if ! lLo .and. aIF[ HB_SOCKET_IFINFO_ADDR ] == '127.0.0.1'
				lLo := .t.
			endif
		elseif hb_AScan( aAddrs, cAddr,,, .t. ) == 0
			aadd( aAddrs, cAddr )
		endif
	next
	if empty( aAddrs )
		aadd( aAddrs, '255.255.255.255' )
	endif
	if lLo
		hb_AIns( aAddrs, 1, '127.0.0.1', .t. )
	endif
	return aAddrs

***** 09.10.17 - возвращает массив выбранных объектов работающих пользователей
function MultipleSelectedReceiver( r, c )
	local aRet := {}
	local c2
	local oBox := nil
	local bufferScreen := savescreen()
	
	if len( hb_sendMessage_activeTask ) > 0
		c2 := c + 30
		if c2 > 77
			c2 := 77 ; c := 76 - 30
		endif

		oBox := TBox():New( r, c, r + 15, c2, .t. )
		oBox:Caption := win_AnsiToOEM( 'Активные пользователи' )
		oBox:CaptionColor := col_tit_uch
		oBox:View()
		status_key( win_AnsiToOEM( '^<Esc>^ отмена;  ^<Enter>^ выбор;  ^<Ins>^ установить/снять отметку' ) )
		
		do while .t.
			if len( aRet := BrowseReceiver( oBox, color_uch ) ) > 0
				if empty( aRet )
					hb_Alert( win_AnsiToOEM( 'Необходимо отметить хотя бы одного пользователя!', , , 4 ) )
					loop
				else
					exit
				endif
			else
				exit
			endif
		enddo
	else
		hb_Alert( win_AnsiToOEM( 'Активные пользователи отсутствуют!', , , 4 ) )
	endif
	oBox := nil
	restscreen( bufferScreen )
	return aRet
	
***** Функция предназачена для просмотра списка объектов для различных видов манипуляции с ними
*
// oBox - объект окна вывода с установленными размерами
// defineColor - цвет (строка или номер)
function BrowseReceiver( oBox, defineColor )
	local item
	local aReturn := {}				// массив для возвращения выбранных элементов

	local oBrowse, oColumn, tmp_color := setcolor()
	local nTop, nLeft, nBottom, nRight
	local aArray := {}
	
	hb_default( @defineColor, color0 )

	private tmp
	private nInd := 1
	private COUNT					// инициализируется в функции fillArrayView
	
	fillArrayView( aArray )	

	// получим параметры оконоой области
	nTop := oBox:Top
	nLeft := oBox:Left
	nBottom := oBox:Bottom
	nRight := oBox:Right
	
	&& if valtype( defineColor ) == 'C'
		&& setcolor( beforatnum( ',', defineColor ) )
	&& elseif valtype( defineColor ) == 'N'
		&& tmp := 'color' + LSTR( defineColor )
		&& setcolor( &tmp )
	&& endif
	setcursor( SC_NONE )
	
	oBrowse:= TBrowseNew( nTop + 1, nLeft + 1, nBottom - 1, nRight - 1 )
	
	oBrowse:goTopBlock := { | | nInd := 1 }
	oBrowse:goBottomBlock := { | | nInd := COUNT }
	oBrowse:SkipBlock     := {| nSkip, nPos | nPos := nInd, ;
		nInd := iif( nSkip > 0, Min( COUNT, nInd + nSkip ), ;
		Max( 1, nInd + nSkip ) ), nInd - nPos }
	&& oBrowse:colorSpec := if( valtype( defineColor ) == 'C', defineColor, &( 'color' + LSTR( defineColor ) ) )
			
	if !empty( aArray )
		// заполним tbrowse отображаемыми колонками
		oColumn := TBColumnNew( '', { | | if( aArray[ nInd ]:checked, '*', ' ' ) } )
		oColumn:width := 1
		oBrowse:addColumn( oColumn )
		
		oColumn := TBColumnNew( '', { | | aArray[ nInd ]:FIO } )
		oColumn:width := 20
		oBrowse:addColumn(oColumn)
		
		oColumn := TBColumnNew( '', { | | aArray[ nInd ]:NameUser } )
		oColumn:width := 50
		oBrowse:addColumn(oColumn)

		oColumn := TBColumnNew( '', { | | aArray[ nInd ]:EnterDate } )
		oColumn:width := 10
		oBrowse:addColumn(oColumn)

		oColumn := TBColumnNew( '', { | | aArray[ nInd ]:EnterTime } )
		oColumn:width := 8
		oBrowse:addColumn(oColumn)
	
	endif
	oBrowse:colSep  := chr( 32 )
	oBrowse:right()
	oBrowse:freeze := 1
	
	while .t.
		oBrowse:forcestable()	// стабилизация
		nKey := INKEY( 10 )		// каждые 10 сек.
		
		fillArrayView( aArray )
		oBrowse:refreshAll()
		oBrowse:Stabilize()
		if ! BrowseMoveCursor( nKey, oBrowse )
			do case
				case nKey == K_INS	// поставить отметку на элемент
					aArray[ oBrowse:RowPos ]:toggleChecked()
				case nKey == 43		// "+" - поставить отметку на все элементы
					for each item in aArray
						item:checked := .t.
					next
				case nKey == 45		// "-" - снять отметку выбора
					for each item in aArray
						item:checked := .f.
					next
				case nKey == K_ESC .or. nKey == K_ENTER		// выход из цикла
					exit
			endcase
		endif
	end
	setcolor( tmp_color )
	if nKey != K_ESC
		for each item in aArray
			if item:checked
				aadd( aReturn, item )
			endif
		next
	endif
	return aReturn
	
static procedure fillArrayView( aArray )
	local item, item2, loc, aLocal := {}, obj
	
	for each item in aArray
		if item:checked
			aadd( aLocal, item )
		endif
	next
	asize( aArray, 0 )
	for each item in hb_hKeys( hb_sendMessage_activeTask )
		loc := hb_hGet( hb_sendMessage_activeTask, item )
		obj := TWorkingUser():New( item, loc[ 1 ], loc[ 2 ], loc[ 3 ], loc[ 4 ] )
		for each item2 in aLocal
			if obj == item2
				obj:checked := .t.
			endif
		next
		aadd( aArray, obj )
	next
	COUNT := len( aArray )
	return

// Cursor Movement Methods
//
static function BrowseMoveCursor( nKey, oBrw )
	local nFound
	static aKeys := ;
		{ K_DOWN    , {|oB| oB:down()     },;
		K_UP        , {|oB| oB:up()       },;
		K_PGDN      , {|oB| oB:pageDown() },;
		K_PGUP      , {|oB| oB:pageUp()   },;
		K_RIGHT     , {|oB| oB:right()    },;
		K_LEFT      , {|oB| if( oB:colPos != 2, oB:left(), ) },;
		K_CTRL_PGUP , {|oB| oB:goTop()    },;
		K_CTRL_PGDN , {|oB| oB:goBottom() },;
		K_HOME      , {|oB| oB:home()     },;
		K_END       , {|oB| oB:end()      },;
		K_CTRL_HOME , {|oB| oB:panHome()  },;
		K_CTRL_END  , {|oB| oB:panEnd()   } }
  
	if ( nFound := ascan( aKeys, nKey ) ) <> 0
		eval( aKeys[ ++nFound ], oBrw )
	endif
	return ( nFound <> 0 )