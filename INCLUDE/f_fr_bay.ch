// ���� �ᯮ��㥬�� ���
#DEFINE KKT_NONE 1
#DEFINE KKT_OFF 2
#DEFINE KKT_SHTRIH 3

// ��� ��᪠�쭮�� ॣ������ "����-�"
//
// ���ᠭ�� ���ᨢ� ���ﭨ� �� ����祭�� �� �맮�� ������� GetECRStatus
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
&& #define	ECR_SKNOSTATUS					52					// ��������� � �ࠩ�� v. 4.13

&& #define ECR_LEN_ARRAY					          52		// ���� ����� ���ᨢ�

// ���ᠭ�� ���ᨢ� ���ﭨ� �� ����祭�� �� �맮�� ������� GetShortECRStatus
&& #define SHORTECR_OPERATORNUMBER     			    1		//���浪��� ����� ������, 祩 ��஫� �� ������.
&& #define SHORTECR_ECRFLAGS					          2		//�ਧ���� (䫠��) ��� (�᪫��뢠���� � ᫥���饥 ��⮢�� ����)
&& #define SHORTECR_RECEIPTRIBBONISPRESENT		  3		//�ਧ��� ������ � ��� �㫮�� 祪���� �����. FALSE - �㫮�� 祪���� ����� ���, TRUE - �㫮� 祪���� ����� ����.
&& #define SHORTECR_JOURNALRIBBONISPRESENT		  4		//�ਧ��� ������ � ��� �㫮�� ����樮����� ��ୠ��. FALSE - �㫮�� ����樮����� ��ୠ�� ���, TRUE - �㫮� ����
&& #define SHORTECR_SLIPDOCUMENTISPRESENT		    5		//�ਧ��� ������ � ��� ����������� ���㬥��. FALSE - ����������� ���㬥�� ���, TRUE - ���������� ���㬥�� ����.
&& #define SHORTECR_SLIPDOCUMENTISMOVING		    6		//�ਧ��� ��宦����� ����������� ���㬥�� ��� ���稪�� ����஫� ����������� ���㬥��. FALSE - ���������� ���㬥�� ��������� ��� ���稪�� ����஫� ����������� ���㬥��, TRUE - ���������� ���㬥�� ��室�� ��� ���稪��.
&& #define SHORTECR_POINTPOSITION				        7		//�ਧ��� ��������� �����筮� �窨. FALSE - �����筠� �窠 �⤥��� 0 ࠧ�冷�, TRUE - �����筠� �窠 �⤥��� 2 ࠧ�鸞.
&& #define SHORTECR_EKLZISPRESENT				        8		//�ਧ��� ������ � ��� ����. FALSE - ���� ���, TRUE - ���� ����.
&& #define SHORTECR_JOURNALRIBBONOPTICALSENSOR	9		//�ਧ��� ��宦����� 祪���� ����� ��� ����᪨� ���稪�� 祪���� �����. FALSE - 祪���� ����� ��� ��� ����᪨� ���稪��; TRUE - 祪���� ���� ��室�� ��� ����᪨� ���稪��.
&& #define SHORTECR_RECEIPTRIBBONOPTICALSENSOR	10		//�ਧ��� ��宦����� 祪���� ����� ��� ����᪨� ���稪�� 祪���� �����. FALSE - 祪���� ����� ��� ��� ����᪨� ���稪��; TRUE - 祪���� ���� ��室�� ��� ����᪨� ���稪��.
&& #define SHORTECR_JOURNALRIBBONLEVER			    11		//�ਧ��� ��������� ��砣� �ମ������� ����� ����樮����� ��ୠ�� TRUE - ��砣 �ମ������� ����� ����樮����� ��ୠ�� ������; FALSE - ��砣 �ମ������� ����� ���饭.
&& #define SHORTECR_RECEIPTRIBBONLEVER			    12		//�ਧ��� ��������� ��砣� �ମ������� 祪���� �����. TRUE - ��砣 �ମ������� 祪���� ����� ������; FALSE - ��砣 �ମ������� 祪���� ����� ���饭.
&& #define SHORTECR_LIDPOSITIONSENSOR			      13		//�ਧ��� ��������� ���誨 �����. TRUE - ���誠 ����� �� ��⠭������; FALSE - ���誠 ����� ��⠭������.
&& #define SHORTECR_ISPRINTERLEFTSENSORFAILURE	14		//�ਧ��� �⪠�� ������ ���稪� �����饣� ��堭����. FALSE - �⪠�� ���稪� ���, TRUE - ����� ���� �⪠� ���稪�.
&& #define SHORTECR_ISPRINTERRIGHTSENSORFAILURE	15		//�ਧ��� �⪠�� �ࠢ��� ���稪� �����饣� ��堭����. FALSE - �⪠�� ���稪� ���, TRUE - ����� ���� �⪠� ���稪�.
&& #define SHORTECR_ISDRAWEROPEN				        16		//�ਧ��� ���ﭨ� ��������� �騪�. TRUE - ������� �騪 �����; FALSE - ������� �騪 ������
&& #define SHORTECR_ISEKLZOVERFLOW				      17		//�ਧ��� ���ﭨ� ����. TRUE - ���� ������ � ��९�������, FALSE - ���� ��? �� ������ � ��९�������
&& #define SHORTECR_QUANTITYPOINTPOSITION		    18		//�ਧ��� ��������� �����筮� �窨 � ������⢥ ⮢��. TRUE - 3 ����� ��᫥ ����⮩; FALSE - 6 ������.
&& #define SHORTECR_ECRMODE						          19		//����� ���, �.�. ���� �� ���ﭨ� ���, � ���஬ ��� ����� ��室����� (����஢�� ०���� ᬮ�� � ���ᠭ�� ᢮��⢠)
&& #define SHORTECR_ECRMODEDESCRIPTION			    20		//�����⢮ ᮤ�ন� ��ப� � ���ᠭ��� �� ���᪮� �몥 ०��� ��� (�. �⮫��� <���ᠭ�� ०��� ���> � ᢮��⢥ ECRMode).
&& #define SHORTECR_ECRMODE8STATUS				      21		//���� �� ���ﭨ�, ����� ��� ��室���� � ०��� 8:
&& #define SHORTECR_ECRMODESTATUS				        22		//���� �� ���ﭨ�, ����� ��� ��室���� � ०���� 13 � 14.
&& #define SHORTECR_ECRADVANCEDMODE				      23		//���०�� ��� - ���� �� ������ﭨ� ���, � ���஬ ��� ����� ��室�����. ���०��� �।�����祭� ��� ���४⭮�� �����襭�� ����権 �� ���� ���㬥�⮢ � ��砥 ������� ���権.
&& #define SHORTECR_ECRADVANCEDMODEDESCRIPTION	24		//�����⢮ ᮤ�ন� ��ப� � ���ᠭ��� �� ���᪮� �몥 ���०��� ��� (�. �⮫��� <���ᠭ�� ���०��� ���> � ᢮��⢥ ECRAdvancedMode).
&& #define SHORTECR_QUANTITYOFOPERATIONS		    25		//������⢮ �믮������� ����権 ॣ����樨 (�த��, ���㯮�, �����⮢ �த�� ��� �����⮢ ���㯮�) � 祪�.
&& #define SHORTECR_BATTERYVOLTAGE				      26		//����殮��� १�ࢭ�� ���२.
&& #define SHORTECR_POWERSOURCEVOLTAGE			    27		//����殮��� ���筨�� ��⠭��.
&& #define SHORTECR_FMRESULTCODE				        28		//��� �訡�� ��.
&& #define SHORTECR_EKLZRESULTCODE				      29		//��� �訡�� ����.
&& #define SHORTECR_LEN_ARRAY					          29		// ���� ����� ���ᨢ�

// ���ᠭ�� ���ᨢ� ���ﭨ� �� ����祭�� ��� �맮�� ������� FNGetStatus
&& #define FN_FNLIFESTATE				   		1	// ������ﭨ������
&& #define FN_FNCURRENTDOCUMENT				2	// ������騩���㬥��
&& #define FN_FNDOCUMENTDATA					3	// ����� ���㬥��
&& #define FN_FNSESSIONSTATE					4	// ����ﭨ� ᬥ��
&& #define FN_FNWARNINGFLAGS					5	// ����� �।�०�����
&& #define FN_DATE								6	// ���
&& #define FN_TIME								7	// �६�
&& #define FN_SERIALNUMBER						8	// �����᪮� ����� ��
&& #define FN_DOCUMENTNUMBER					9	// ����� ��
&& #define FN_LEN_ARRAY						9	// ���� ����� ���ᨢ�

// ���ᠭ�� ���ᨢ� ��ࠬ��஢ ���ன�⢠ ����祭�� �� �맮�� ������� GetDeviceMetrics
&& #define METRICS_UMAJORPROTOCOLVERSION 	      1		// ����� ��⮪��� �裡 � ��, �ᯮ��㥬�� ���ன�⢮�
&& #define METRICS_UMINORPROTOCOLVERSION	      2		// �������� ��⮪��� �裡 � ��, �ᯮ��㥬�� ���ன�⢮�
&& #define METRICS_UMAJORTYPE				            3		// ��� ����訢������ ���ன�⢠.
&& #define METRICS_UMINORTYPE				            4		// ���⨯ ����訢������ ���ன�⢠.
&& #define METRICS_UMODEL					              5		// ������ ����訢������ ���ன�⢠.
&& #define METRICS_UCODEPAGE				            6		// ������� ��࠭��, �ᯮ��㥬�� ���ன�⢮� (0 - ���᪨� ��).
&& #define METRICS_UDESCRIPTION				          7		// �������� ���ன�⢠ - ��ப� ᨬ����� ⠡���� WIN1251.
&& #define METRICS_CAPGETSHORTECRSTATUS		      8		// ������� GetShortECRStatus �����ন������.
&& #define METRICS_LEN_ARRAY				            8		// ���� ����� ���ᨢ�

// ������ ࠡ��� ���
#define ECRMODE_WORK				0	// �ਭ�� � ࠡ�祬 ०���
#define ECRMODE_SEND_DATA			1	// �뤠� ������
#define ECRMODE_OPEN				2	// ������ ᬥ��, 24 �� �� ���稫���
#define ECRMODE_OPEN24				3	// ������ ᬥ��, 24 �� ���稫���
#define ECRMODE_CLOSE				4	// ������� ᬥ��
#define ECRMODE_BLOCKNALOG			5	// �����஢�� �� ���ࠢ��쭮�� ��஫� ���������� ��ᯥ���
#define ECRMODE_WAITDATE			6	// �������� ���⢥ত���� ����� ����
#define ECRMODE_ENABLEDECIMALPOINT	7	// ����襭�� ��������� ��������� �����筮� �窨
#define ECRMODE_OPENDOC				8	// ������ ���㬥��
#define ECRMODE_ENABLETEHNULL		9	// ����� ࠧ�襭�� �孮�����᪮�� ���㫥���
#define ECRMODE_TESTGO				10	// ���⮢� �ண��
#define ECRMODE_FULLFISCALREPORT	11	// ����� ������� �᪠�쭮�� ����
#define ECRMODE_FULLEKLZREPORT		12	// ����� �������� ���� ����
#define ECRMODE_WORKAUXDOC			13	// ����� � �᪠��� ��������� ���㬥�⮬
#define ECRMODE_PRINTAUXDOC			14	// ����� ����������� ���㬥��
#define ECRMODE_AUXDOCREADY			15	// ��᪠��� ���������� ���㬥�� ��ନ஢��

// ���� �訡�� ॣ������
#define FR_SUCCESS			        0
#define ERR_NOT_CONNECT				-1	// �� �ࠢ���� ���� � �ࠩ���
#define ERR_COM_NOT					-2	// �᭮���� �訡��
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

// ���������� �� ᬥ�� ����� �����묨
#define CASH_SALE_CASH				193			// ���������� �� ���� ����� �����묨 ����樨 �த��� �� ᬥ��
#define CASH_BAY_CASH				194			// ���������� �� ���� ����� �����묨 ����樨 ���㯪� �� ᬥ��
#define CASH_RETURN_SALE_CASH		195			// ���������� �� ���� ����� �����묨 ����樨 ������ �த��� �� ᬥ��
#define CASH_RETURN_BAY_CASH		196			// ���������� �� ���� ����� �����묨 ����樨 ������ ���㯪� �� ᬥ��

// ���������� �� ᬥ�� ����� ��� 2
#define CASH_SALE_2					197		// ���������� �� ���� ����� 2 ����樨 �த��� �� ᬥ��
#define CASH_BAY_2					198		// ���������� �� ���� ����� 2 ����樨 ���㯪� �� ᬥ��
#define CASH_RETURN_SALE_2			199		// ���������� �� ���� ����� 2 ����樨 ������ �த��� �� ᬥ��
#define CASH_RETURN_BAY_2			200		// ���������� �� ���� ����� 2 ����樨 ������ ���㯪� �� ᬥ��

// ���������� �� ᬥ�� ����� ��� 3
#define CASH_SALE_3					201		// ���������� �� ���� ����� 3 ����樨 �த��� �� ᬥ��
#define CASH_BAY_3					202		// ���������� �� ���� ����� 3 ����樨 ���㯪� �� ᬥ��
#define CASH_RETURN_SALE_3			203		// ���������� �� ���� ����� 3 ����樨 ������ �த��� �� ᬥ��
#define CASH_RETURN_BAY_3			204		// ���������� �� ���� ����� 3 ����樨 ������ ���㯪� �� ᬥ��

// ���������� �� ᬥ�� ����� ������᪮� ���⮩
#define CASH_SALE_CARD				205		// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 �த��� �� ᬥ��
#define CASH_BAY_CARD				206		// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ���㯪� �� ᬥ��
#define CASH_RETURN_SALE_CARD		207		// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ �த��� �� ᬥ��
#define CASH_RETURN_BAY_CARD		208		// ���������� �� ���� ����� ������᪮� ���⮩ ����樨 ������ ���㯪� �� ᬥ��

#define CASH_CASH					241		// ���������� ����筮�� � ����
#define CASH_INCOME					242		// ���ᥭ�� �㬬� �� ᬥ��
#define CASH_OUTCOME				243		// �믫�祭�� �㬬� �� ᬥ��
#define CASH_SALE_EKLZ				245		// �㬬� �த�� � ᬥ�� �� ����