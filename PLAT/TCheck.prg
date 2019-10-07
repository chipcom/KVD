#include 'hbclass.ch'
#include 'property.ch'
#include 'function.ch'
&& #include 'f_fr_bay.ch'

*************************
CREATE CLASS TCheck
	VISIBLE:
		// свойства для пациента и плательщика
		PROPERTY Patient AS OBJECT READ getPatient WRITE setPatient		// пациент
		PROPERTY PatientCode READ getPatientCode							// 
		PROPERTY PatientFIO READ getPatientFIO							// 
		PROPERTY PatientFIO1251 READ getPatientFIO1251					// 
		PROPERTY Payer AS STRING READ getPayer WRITE setPayer			// плательщик
		PROPERTY Payer1251 READ getPayer1251								// 
		PROPERTY IsExistPayer READ getIsExistPayer						// 
		PROPERTY PayerINN AS STRING READ getPayerINN WRITE setPayerINN	// плательщик, ИНН
		PROPERTY EMail AS STRING READ getEmail WRITE setEmail			// телефон или E-mail для  чека
		// информация из ККТ
		PROPERTY SerialNumberFR AS STRING READ getSerial WRITE setSerial	// заводской номер ККТ
		PROPERTY CheckNumber AS NUMERIC READ getNumber WRITE setNumber	// номер пробитого чека
		PROPERTY DateFR AS DATE READ getDateFR WRITE setDateFR			// дата печати чека
		PROPERTY TimeFR AS NUMERIC READ getTimeFR WRITE setTimeFR		// время печати чека

		PROPERTY Received AS NUMERIC READ getReceived WRITE setReceived	// получено наличными
		PROPERTY Cash AS NUMERIC READ getCash WRITE setCash				// сумма оплачиваемая наличными
		PROPERTY Total AS NUMERIC READ getTotal							// сумма чека 
		PROPERTY TotalBank AS NUMERIC READ getTotalBank					// оплата картами 

		// свойства для видов платежей
		PROPERTY PayType2 AS NUMERIC READ getPayType2 WRITE setPayType2	// сумма оплаты типа 2
		PROPERTY PayType3 AS NUMERIC READ getPayType3 WRITE setPayType3	// сумма оплаты типа 3
		PROPERTY PayType4 AS NUMERIC READ getPayType4 WRITE setPayType4	// сумма оплаты типа 4
		
		METHOD New( oDriver )
		METHOD AddService( param )
		METHOD Count()						INLINE	len( ::_aServices )
		METHOD Services()					INLINE	::_aServices

		METHOD Print()														// печать чека
		// установка вида чека, по умолчанию продажа
		METHOD Sale()						INLINE	::FTypeCheck := .t.
		METHOD Refund()						INLINE	::FTypeCheck := .f.
		METHOD TypeCheck()					INLINE	::FTypeCheck
		
	HIDDEN:
		DATA FPatient		INIT nil
		DATA FPayer			INIT ''
		DATA FPayerINN		INIT ''
		DATA FEmail			INIT space( 25 )
		DATA FSerial		INIT ''
		DATA FDate			INIT ctod( '' )
		DATA FNumber		INIT 0
		DATA FTime			INIT 0
		DATA FReceived		INIT 0.0
		DATA FCash			INIT 0.0
		DATA FTotal			INIT 0.0
		DATA FTotalBank		INIT 0.0
		DATA FPayType2			INIT 0.0
		DATA FPayType3			INIT 0.0
		DATA FPayType4	INIT 0.0
		DATA FTypeCheck				AS LOGICAL	INIT .t.		// тип чека, .t. - продажа, .f. - возврат
		// переменные для хранения информации из ККТ
		DATA FSetKKT		AS OBJECT	INIT nil			// настройки ККТ
		
		DATA FDriver		AS OBJECT	INIT nil
		DATA FTaxValue1		INIT 0.0	// для хранения суммы налога по ставке 18%
		DATA FTaxValue2		INIT 0.0	// для хранения суммы налога по ставке 10%
		DATA FTaxValue3		INIT 0.0	// для хранения суммы налога по ставке 0%
		DATA FTaxValue4		INIT 0.0	// для хранения суммы налога по ставке без НДС
		DATA FTaxValue5		INIT 0.0
		DATA FTaxValue6		INIT 0.0

		
		METHOD getPatient
		METHOD setPatient( oValue )
		METHOD getPatientCode
		METHOD getPatientFIO
		METHOD getPatientFIO1251
		METHOD getPayer
		METHOD setPayer( cValue )
		METHOD getPayer1251
		METHOD getPayerINN
		METHOD setPayerINN( cValue )
		METHOD getEmail
		METHOD setEmail( cValue )
		METHOD getSerial
		METHOD setSerial( cValue )
		METHOD getNumber
		METHOD setNumber( nValue )
		METHOD getDateFR
		METHOD setDateFR( dValue )
		METHOD getTimeFR
		METHOD setTimeFR( nValue )
		METHOD getIsExistPayer
		METHOD getReceived
		METHOD setReceived( nValue )
		METHOD getCash
		METHOD setCash( nValue )
		METHOD getPayType2
		METHOD setPayType2( nValue )
		METHOD getPayType3
		METHOD setPayType3( nValue )
		METHOD getPayType4
		METHOD setPayType4( nValue )
		METHOD getTotal
		METHOD getTotalBank
		//
		// массив объектов услуг для печати в чеке
		VAR _aServices				AS ARRAY	INIT {}				// массив для хранения услуг в чеке
		
		METHOD PrintBayer()			// Печать информации о плательщике
		METHOD PrintUslugi()			// Печать услуг в чеке
		METHOD SalePosition( oService )
		METHOD CloseCheck()
		METHOD AmountOfCashOnCashbox()
		
END CLASS

METHOD New( oDriver )

	::FDriver := oDriver
	return self

METHOD AddService( param ) CLASS TCheck
	Local ret := .f.
	
	if pcount() > 0
		// проверим что передан класс TServiceOfCheck
		if ( valtype( param ) != 'O' ) .or. ( param:ClassName != upper( 'TServiceOfCheck' ) )
			return ret
		endif
		aadd( ::_aServices, param )
		::FTotal := ::FTotal + param:Price * param:Quantity
		ret := .t.
	endif
	return ret

METHOD function AmountOfCashOnCashbox()	CLASS TCheck
	local ret := 0

	ret := ::FDriver:GetSaleCash()
	return ret

METHOD Print()							CLASS TCheck
	local ret := .f.
	local res := -1

	if ! ::FDriver:OpenSession
		::FDriver:FNOpenSession()
	endif
	if !::FTypeCheck
		if ::Cash > 0
			// запрашиваем наличие наличности в кассе
			res := ::AmountOfCashOnCashbox()
			if ( ::FTotal > res )
				hb_Alert( 'Недостаточная сумма в кассе', , , 4 )
				return .f.
			endif
		endif
		::FDriver:PrintString( '**** ВОЗВРАТ ****', .t. )
		::FDriver:PrintString( ' ' )
	endif
	::PrintBayer()
	if ( ret := ::PrintUslugi() )
		if ( res := ::CloseCheck() ) != -1
			::FNumber := res
			::FSerial := ::FDriver:SerialNumber
			::FDate := date()
			::FTime := round_5( timetosec( Time() ), 0 )
			if ::FDriver:OpenADrawer
				::FDriver:OpenDrawer()
			endif
			ret := .t.
		else
			ret := .f.
		endif
	endif
	return ret

// закрыть чек
METHOD function CloseCheck()				CLASS TCheck
	local ret := -1
	local oCloseCheck := TCloseCheck():New()
	
	with object oCloseCheck
		:Summ1 := ::Cash
	    :Summ2 := ::PayType2
	    :Summ3 := ::PayType3
	    :Summ4 := ::PayType4
	    :Summ5 := 0
	    :Summ6 := 0
	    :Summ7 := 0
	    :Summ8 := 0
	    :Summ9 := 0
	    :Summ10 := 0
	    :Summ11 := 0
	    :Summ12 := 0
	    :Summ13 := 0
	    :Summ14 := 0
	    :Summ15 := 0
	    :Summ16 := 0
	    :RoundingSumm := 0
	    :TaxValue1 := ::FTaxValue1
	    :TaxValue2 := ::FTaxValue2
	    :TaxValue3 := ::FTaxValue3
	    :TaxValue4 := ::FTaxValue4
	    :TaxValue5 := ::FTaxValue5
	    :TaxValue6 := ::FTaxValue6
	    :TaxType := 1
	    :StringForPrinting := upper( dos2win( '----------------------------------------' ) )
	    :CustomerEmail := ::EMail
	endwith
	
	ret := ::FDriver:CloseCheck( oCloseCheck )
	return ret

// сформировать позицию чека продажи
METHOD function SalePosition( lType, oService )			CLASS TCheck
/*  oService - объект услуга для чека */
	local ret := .f.
	local oOperationCheck := TOperationCheck():New()
	local VAT := ( oService:Quantity * oService:Price ) * oService:Tax / ( 100 + oService:Tax )

	HB_CDPSELECT( 'RU1251' )
	&& with object oOperationCheck
		oOperationCheck:CheckType := iif( lType, 0, 2 )
		oOperationCheck:Quantity := oService:Quantity
		oOperationCheck:Price := oService:Price
		oOperationCheck:Summ1 := 0
		oOperationCheck:Summ1Enabled := .f.
		if oService:Tax != 0
			oOperationCheck:TaxValue := VAT
			oOperationCheck:TaxValueEnabled := .t.
			oOperationCheck:Tax1 := oService:Tax
			if oService:Tax == 18
				::FTaxValue1 := VAT
			elseif oService:Tax == 10
				::FTaxValue2 := VAT
			endif
		else
			oOperationCheck:TaxValue := 0
			oOperationCheck:TaxValueEnabled := .f.
			oOperationCheck:Tax1 := 0
		endif
		oOperationCheck:Department := 1
		oOperationCheck:PaymentTypeSign := 4 // полный расчет
		oOperationCheck:PaymentItemSign := 4 // услуга
		oOperationCheck:StringForPrinting := alltrim( iif( ::FDriver:PrintCodeService(), alltrim( oService:Shifr() ) + ' ', '' ) ;
					+ iif( ::FDriver:PrintNameService(), oService:Name, '' ) )
	&& endwith
	ret := ::FDriver:Operation( oOperationCheck )
	HB_CDPSELECT( 'RU866' )
	return ret

***** Печать услуг в чеке
METHOD PrintUslugi()								CLASS TCheck
	local ret := .f., name_usl := ''
	local doctor := '', item
	
	if ::Count() > 0
		asort( ::_aServices, , , { | x, y | x:Shifr < y:Shifr } )
        for each item in ::_aServices
			tmpArr := item
			if !( ret := ::SalePosition( ::FTypeCheck, item ) )
				exit
			endif
			if ( doctor != item:Doctor )
				if ( ::FDriver:PrintDoctor ) .and. ( !empty( item:doctor ) )
					::FDriver:PrintString( 'Исполнитель: ' + item:doctor, , 1 )	// печать врача
				endif
				doctor := item:Doctor
			endif
		next
	endif
	return ret

***** Печать информации о плательщике
METHOD PrintBayer() CLASS TCheck
	local ret := .t.
	local namePatient := ''
	
	if ::FDriver:PrintPatient
		if ::IsExistPayer()
			namePatient := 'Пациент: '
			::FDriver:FeedDocument( 1, 1 )
			if (ret := ::FDriver:PrintString( 'Плательщик: ' + fam_i_o( ::FPayer ), , 1 ) )
				if !empty( ::FPayerINN )
					ret := ::FDriver:PrintString( 'ИНН плательщика: ' + ::FPayerINN, , 1 )
				endif
			endif
		endif
		namePatient := namePatient + lstr( ::FPatient:ID ) + '  ' + fam_i_o( ::FPatient:FIO )
	else
		namePatient := namePatient + lstr( ::FPatient:ID )
	endif
	ret := ::FDriver:FeedDocument( 1, 1 )
	::FDriver:PrintString( namePatient, len( alltrim( namePatient ) ) < 20 )
	ret := ::FDriver:FeedDocument( 1, 1 )
	return nil

METHOD function getPatient()						CLASS TCheck
	return ::FPatient

METHOD procedure setPatient( oValue )			CLASS TCheck
	::FPatient := oValue
	return

METHOD function getPatientCode()					CLASS TCheck
	return ::FPatient:ID

METHOD function getPatientFIO()					CLASS TCheck
	return ::FPatient:FIO

METHOD function getPatientFIO1251()				CLASS TCheck
	return win_OEMToANSI( ::FPatient:FIO )

METHOD function getPayer()							CLASS TCheck
	return ::FPayer

METHOD procedure setPayer( cValue )				CLASS TCheck
	::FPayer := cValue
	return

METHOD function getPayer1251()						CLASS TCheck
	return win_OEMToANSI( ::FPayer )

METHOD function getPayerINN()						CLASS TCheck
	return ::FPayerINN

METHOD procedure setPayerINN( cValue )			CLASS TCheck
	::FPayerINN := cValue
	return

METHOD function getEmail()							CLASS TCheck
	return ::FEmail

METHOD procedure setEmail( cValue )				CLASS TCheck
	::FEmail := cValue
	return

METHOD function getSerial()						CLASS TCheck
	return ::FSerial

METHOD procedure setSerial( cValue )				CLASS TCheck
	::FSerial := cValue
	return

METHOD function getNumber()						CLASS TCheck
	return ::FNumber

METHOD procedure setNumber( nValue )				CLASS TCheck
	::FNumber := nValue
	return

METHOD function getDateFR()						CLASS TCheck
	return ::FDate

METHOD procedure setDateFR( dValue )				CLASS TCheck
	::FDate := dValue
	return

METHOD function getTimeFR()						CLASS TCheck
	return ::FTime

METHOD procedure setTimeFR( nValue )				CLASS TCheck
	::FTime := nValue
	return

METHOD function getIsExistPayer()					CLASS TCheck
	return !empty( ::FPayer )

METHOD function getReceived()						CLASS TCheck
	return ::FReceived

METHOD procedure setReceived( nValue )			CLASS TCheck
	::FReceived := nValue
	return

METHOD function getCash()							CLASS TCheck
	return ::FCash

METHOD procedure setCash( nValue )				CLASS TCheck
	::FCash := nValue
	return

METHOD function getTotal()							CLASS TCheck
	return ::FTotal

METHOD function getTotalBank()						CLASS TCheck
	return ::FTotalBank

METHOD function getPayType2()						CLASS TCheck
	return ::FPayType2

METHOD procedure setPayType2( nValue )				CLASS TCheck
	::FPayType2 := nValue
	::FTotalBank := ::FPayType2 + ::FPayType3 + ::FPayType4
	return

METHOD function getPayType3()							CLASS TCheck
	return ::FPayType3

METHOD procedure setPayType3( nValue )				CLASS TCheck
	::FPayType3 := nValue
	::FTotalBank := ::FPayType2 + ::FPayType3 + ::FPayType4
	return

METHOD function getPayType4()					CLASS TCheck
	return ::FPayType4

METHOD procedure setPayType4( nValue )			CLASS TCheck
	::FPayType4 := nValue
	::FTotalBank := ::FPayType2 + ::FPayType3 + ::FPayType4
	return
