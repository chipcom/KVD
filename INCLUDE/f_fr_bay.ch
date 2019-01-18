// виды используемых ККМ
#DEFINE KKT_NONE 1
#DEFINE KKT_OFF 2
#DEFINE KKT_SHTRIH 3

// Для Фискального регистратора "Штрих-М"
//
// описание массива состояния ФР полученный при вызове команды GetECRStatus
&& #define ECR_OPERATORNUMBER     			    1
&& #define ECR_ECRSOFTVERSION				        2
&& #define ECR_ECRBUILD						          3
&& #define ECR_ECRSOFTDATE					        4
&& #define ECR_LOGICALNUMBER				        5
&& #define ECR_OPENDOCUMENTNUMBER			      6
&& #define ECR_ECRFLAGS						          7
&& #define ECR_RECEIPTRIBBONISPRESENT		    8
&& #define ECR_JOURNALRIBBONISPRESENT		    9
&& #define ECR_SLIPDOCUMENTISPRESENT		    10
&& #define ECR_SLIPDOCUMENTISMOVING			    11
&& #define ECR_POINTPOSITION				        12
&& #define ECR_EKLZISPRESENT				        13
&& #define ECR_JOURNALRIBBONOPTICALSENSOR	  14
&& #define ECR_RECEIPTRIBBONOPTICALSENSOR	  15
&& #define ECR_JOURNALRIBBONLEVER			      16
&& #define ECR_RECEIPTRIBBONLEVER			      17
&& #define ECR_LIDPOSITIONSENSOR			      18
&& #define ECR_ISPRINTERLEFTSENSORFAILURE	  19
&& #define ECR_ISPRINTERRIGHTSENSORFAILURE  20
&& #define ECR_ISDRAWEROPEN					        21
&& #define ECR_ISEKLZOVERFLOW				        22
&& #define ECR_QUANTITYPOINTPOSITION		    23
&& #define ECR_ECRMODE						          24
&& #define ECR_ECRMODEDESCRIPTION			      25
&& #define ECR_ECRMODE8STATUS				        26
&& #define ECR_ECRMODESTATUS				        27
&& #define ECR_ECRADVANCEDMODE				      28
&& #define ECR_ECRADVANCEDMODEDESCRIPTION	  29
&& #define ECR_PORTNUMBER					          30
&& #define ECR_FMSOFTVERSION				        31
&& #define ECR_FMBUILD						          32
&& #define ECR_FMSOFTDATE					          33
&& #define ECR_DATE							            34
&& #define ECR_TIME							            35
&& #define ECR_TIMESTR						          36
&& #define ECR_FMFLAGS						          37
&& #define ECR_FM1ISPRESENT					        38
&& #define ECR_FM2ISPRESENT					        39
&& #define ECR_LICENSEISPRESENT				      40
&& #define ECR_FMOVERFLOW					          41
&& #define ECR_ISBATTERYLOW					        42
&& #define ECR_ISLASTFMRECORDCORRUPTED		  43
&& #define ECR_ISFMSESSIONOPEN				      44
&& #define ECR_ISFM24HOURSOVER				      45
&& #define ECR_SERIALNUMBER					        46
&& #define ECR_SESSIONNUMBER				        47
&& #define ECR_FREERECORDINFM				        48
&& #define ECR_REGISTRATIONNUMBER			      49
&& #define ECR_FREEREGISTRATION				      50
&& #define ECR_INN							            51
&& #define	ECR_SKNOSTATUS					52					// добавлено в драйве v. 4.13

&& #define ECR_LEN_ARRAY					          52		// общая длина массива

// описание массива состояния ФР полученный при вызове команды GetShortECRStatus
&& #define SHORTECR_OPERATORNUMBER     			    1		//Порядковый номер оператора, чей пароль был введен.
&& #define SHORTECR_ECRFLAGS					          2		//Признаки (флаги) ККМ (раскладывается в следующее битовое поле)
&& #define SHORTECR_RECEIPTRIBBONISPRESENT		  3		//Признак наличия в ККМ рулона чековой ленты. FALSE - рулона чековой ленты нет, TRUE - рулон чековой ленты есть.
&& #define SHORTECR_JOURNALRIBBONISPRESENT		  4		//Признак наличия в ККМ рулона операционного журнала. FALSE - рулона операционного журнала нет, TRUE - рулон есть
&& #define SHORTECR_SLIPDOCUMENTISPRESENT		    5		//Признак наличия в ККМ подкладного документа. FALSE - подкладного документа нет, TRUE - подкладной документ есть.
&& #define SHORTECR_SLIPDOCUMENTISMOVING		    6		//Признак прохождения подкладного документа под датчиком контроля подкладного документа. FALSE - подкладной документ отсутствует под датчиком контроля подкладного документа, TRUE - подкладной документ проходит под датчиком.
&& #define SHORTECR_POINTPOSITION				        7		//Признак положения десятичной точки. FALSE - десятичная точка отделяет 0 разрядов, TRUE - десятичная точка отделяет 2 разряда.
&& #define SHORTECR_EKLZISPRESENT				        8		//Признак наличия в ККМ ЭКЛЗ. FALSE - ЭКЛЗ нет, TRUE - ЭКЛЗ есть.
&& #define SHORTECR_JOURNALRIBBONOPTICALSENSOR	9		//Признак прохождения чековой ленты под оптическим датчиком чековой ленты. FALSE - чековой ленты нет под оптическим датчиком; TRUE - чековая лента проходит под оптическим датчиком.
&& #define SHORTECR_RECEIPTRIBBONOPTICALSENSOR	10		//Признак прохождения чековой ленты под оптическим датчиком чековой ленты. FALSE - чековой ленты нет под оптическим датчиком; TRUE - чековая лента проходит под оптическим датчиком.
&& #define SHORTECR_JOURNALRIBBONLEVER			    11		//Признак положения рычага термоголовки ленты операционного журнала TRUE - рычаг термоголовки ленты операционного журнала поднят; FALSE - рычаг термоголовки ленты опущен.
&& #define SHORTECR_RECEIPTRIBBONLEVER			    12		//Признак положения рычага термоголовки чековой ленты. TRUE - рычаг термоголовки чековой ленты поднят; FALSE - рычаг термоголовки чековой ленты опущен.
&& #define SHORTECR_LIDPOSITIONSENSOR			      13		//Признак положения крышки корпуса. TRUE - крышка корпуса не установлена; FALSE - крышка корпуса установлена.
&& #define SHORTECR_ISPRINTERLEFTSENSORFAILURE	14		//Признак отказа левого датчика печатающего механизма. FALSE - отказа датчика нет, TRUE - имеет место отказ датчика.
&& #define SHORTECR_ISPRINTERRIGHTSENSORFAILURE	15		//Признак отказа правого датчика печатающего механизма. FALSE - отказа датчика нет, TRUE - имеет место отказ датчика.
&& #define SHORTECR_ISDRAWEROPEN				        16		//Признак состояния денежного ящика. TRUE - денежный ящик открыт; FALSE - денежный ящик закрыт
&& #define SHORTECR_ISEKLZOVERFLOW				      17		//Признак состояния ЭКЛЗ. TRUE - ЭКЛЗ близка к переполнению, FALSE - ЭКЛЗ ещ? не близка к переполнению
&& #define SHORTECR_QUANTITYPOINTPOSITION		    18		//Признак положения десятичной точки в количестве товара. TRUE - 3 знака после запятой; FALSE - 6 знаков.
&& #define SHORTECR_ECRMODE						          19		//Режим ККМ, т.е. одно из состояний ККМ, в котором она может находиться (расшифровку режимов смотри в описании свойства)
&& #define SHORTECR_ECRMODEDESCRIPTION			    20		//Свойство содержит строку с описанием на русском языке режима ККМ (см. столбец <Описание режима ККМ> в свойстве ECRMode).
&& #define SHORTECR_ECRMODE8STATUS				      21		//Одно из состояний, когда ККМ находится в режиме 8:
&& #define SHORTECR_ECRMODESTATUS				        22		//Одно из состояний, когда ККМ находится в режимах 13 и 14.
&& #define SHORTECR_ECRADVANCEDMODE				      23		//Подрежим ККМ - одно из подсостояний ККМ, в котором она может находиться. Подрежимы предназначены для корректного завершения операций при печати документов в случае нештатных ситуаций.
&& #define SHORTECR_ECRADVANCEDMODEDESCRIPTION	24		//Свойство содержит строку с описанием на русском языке подрежима ККМ (см. столбец <Описание подрежима ККМ> в свойстве ECRAdvancedMode).
&& #define SHORTECR_QUANTITYOFOPERATIONS		    25		//Количество выполненных операций регистрации (продаж, покупок, возвратов продаж или возвратов покупок) в чеке.
&& #define SHORTECR_BATTERYVOLTAGE				      26		//Напряжение резервной батареи.
&& #define SHORTECR_POWERSOURCEVOLTAGE			    27		//Напряжение источника питания.
&& #define SHORTECR_FMRESULTCODE				        28		//Код ошибки ФП.
&& #define SHORTECR_EKLZRESULTCODE				      29		//Код ошибки ЭКЛЗ.
&& #define SHORTECR_LEN_ARRAY					          29		// общая длина массива

// описание массива состояния ФН полученный ппи вызове команды FNGetStatus
&& #define FN_FNLIFESTATE				   		1	// ФНСостояниеЖизни
&& #define FN_FNCURRENTDOCUMENT				2	// ФНТекущийДокумент
&& #define FN_FNDOCUMENTDATA					3	// Данные документа
&& #define FN_FNSESSIONSTATE					4	// Состояние смены
&& #define FN_FNWARNINGFLAGS					5	// Флаги предупреждения
&& #define FN_DATE								6	// Дата
&& #define FN_TIME								7	// Время
&& #define FN_SERIALNUMBER						8	// Заводской номер ФН
&& #define FN_DOCUMENTNUMBER					9	// Номер ФД
&& #define FN_LEN_ARRAY						9	// общая длина массива

// описание массива параметров устройства полученный при вызове команды GetDeviceMetrics
&& #define METRICS_UMAJORPROTOCOLVERSION 	      1		// Версия протокола связи с ПК, используемая устройством
&& #define METRICS_UMINORPROTOCOLVERSION	      2		// Подверсия протокола связи с ПК, используемая устройством
&& #define METRICS_UMAJORTYPE				            3		// Тип запрашиваемого устройства.
&& #define METRICS_UMINORTYPE				            4		// Подтип запрашиваемого устройства.
&& #define METRICS_UMODEL					              5		// Модель запрашиваемого устройства.
&& #define METRICS_UCODEPAGE				            6		// Кодовая страница, используемая устройством (0 - русский язык).
&& #define METRICS_UDESCRIPTION				          7		// Название устройства - строка символов таблицы WIN1251.
&& #define METRICS_CAPGETSHORTECRSTATUS		      8		// Команда GetShortECRStatus поддерживается.
&& #define METRICS_LEN_ARRAY				            8		// общая длина массива

// Режимы работы ККМ
#define ECRMODE_WORK				0	// Принтер в рабочем режиме
#define ECRMODE_SEND_DATA			1	// Выдача данных
#define ECRMODE_OPEN				2	// Открытая смена, 24 часа не кончились
#define ECRMODE_OPEN24				3	// Открытая смена, 24 часа кончились
#define ECRMODE_CLOSE				4	// Закрытая смена
#define ECRMODE_BLOCKNALOG			5	// Блокировка по неправильному паролю налогового инспектора
#define ECRMODE_WAITDATE			6	// Ожидание подтверждения ввода даты
#define ECRMODE_ENABLEDECIMALPOINT	7	// Разрешение изменения положения десятичной точки
#define ECRMODE_OPENDOC				8	// Открытый документ
#define ECRMODE_ENABLETEHNULL		9	// Режим разрешения технологического обнуления
#define ECRMODE_TESTGO				10	// Тестовый прогон
#define ECRMODE_FULLFISCALREPORT	11	// Печать полного фискального отчета
#define ECRMODE_FULLEKLZREPORT		12	// Печать длинного отчета ЭКЛЗ
#define ECRMODE_WORKAUXDOC			13	// Работа с фискальным подкладным документом
#define ECRMODE_PRINTAUXDOC			14	// Печать подкладного документа
#define ECRMODE_AUXDOCREADY			15	// Фискальный подкладной документ сформирован

// коды ошибок регистратора
#define FR_SUCCESS			        0
#define ERR_NOT_CONNECT				-1	// не правильный порт в драйвере
#define ERR_COM_NOT					-2	// основная ошибка
#define ERR_COM_USED_OTHER			-3
#define ERR_NOT_CONNECT_1			-4
#define ERR_NOT_CONNECT_2			-5
#define ERR_NOT_CONNECT_3			-6
#define ERR_INVALID_DATE			34
#define ERR_INVALID_PASSWORD		79
#define ERR_WAIT_CONTINUE_PRINT		88
#define ERR_DOC_OPEN_OTHER_OPER		89
#define ERR_NO_CHECK_RIBBON			107
#define ERR_NO_CONTROL_RIBBON		108

&& #define OPER_CHECK_SALE			148
&& #define OPER_CHECK_RETURN		150
&& #define OPER_REPORT_X			158
&& #define OPER_REPORT_Z			159

// накопления за смену оплата наличными
#define CASH_SALE_CASH				193			// накопление по виду оплат наличными операции продажа за смену
#define CASH_BAY_CASH				194			// накопление по виду оплат наличными операции покупка за смену
#define CASH_RETURN_SALE_CASH		195			// накопление по виду оплат наличными операции возврат продажи за смену
#define CASH_RETURN_BAY_CASH		196			// накопление по виду оплат наличными операции возврат покупки за смену

// накопления за смену оплата вид 2
#define CASH_SALE_2					197		// накопление по виду оплат 2 операции продажа за смену
#define CASH_BAY_2					198		// накопление по виду оплат 2 операции покупка за смену
#define CASH_RETURN_SALE_2			199		// накопление по виду оплат 2 операции возврат продажи за смену
#define CASH_RETURN_BAY_2			200		// накопление по виду оплат 2 операции возврат покупки за смену

// накопления за смену оплата вид 3
#define CASH_SALE_3					201		// накопление по виду оплат 3 операции продажа за смену
#define CASH_BAY_3					202		// накопление по виду оплат 3 операции покупка за смену
#define CASH_RETURN_SALE_3			203		// накопление по виду оплат 3 операции возврат продажи за смену
#define CASH_RETURN_BAY_3			204		// накопление по виду оплат 3 операции возврат покупки за смену

// накопления за смену оплата банковской картой
#define CASH_SALE_CARD				205		// накопление по виду оплат банковской картой операции продажа за смену
#define CASH_BAY_CARD				206		// накопление по виду оплат банковской картой операции покупка за смену
#define CASH_RETURN_SALE_CARD		207		// накопление по виду оплат банковской картой операции возврат продажи за смену
#define CASH_RETURN_BAY_CARD		208		// накопление по виду оплат банковской картой операции возврат покупки за смену

#define CASH_CASH					241		// накопление наличности в кассе
#define CASH_INCOME					242		// внесенные суммы за смену
#define CASH_OUTCOME				243		// выплаченные суммы за смену
#define CASH_SALE_EKLZ				245		// сумма продаж в смене из ЭКЛЗ