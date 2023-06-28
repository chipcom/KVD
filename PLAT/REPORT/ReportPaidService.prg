* ReportPlat.prg - ࠡ�� � ���⠬� ������ ���
*******************************************************************************
* 04.10.18 CashierReport() - ������ �����
* 02.10.18 ReportLogBook() ��⠢����� ��ୠ�� ॣ����樨
* 02.10.18 ReportDispatchersAndPatients() - ��⠢����� ��ୠ�� ���ࠢ���� ����஢ � ��樥�⠬�
* 02.10.18 ReportDispatchersAndServices() - ��⠢����� ��ୠ�� ���ࠢ���� ����஢ � ��㣠��
* 02.10.18 f1_inf_fr( flag ) - ����祭�� ���ଠ樨 �� �த���� ���ᮢ��� ������
*
* 08.05.17 MethodOfPaymentForServices( nRow, nColumn, ret_arr ) - ����� ᯮᮡ� ������ ���
***************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'chip_mo.ch'

* 02.10.2018 ��⠢����� ��ୠ�� ॣ����樨
function ReportLogBook()
	local aHash
	local mas2_pmt := { '���᮪ ������஢', '���� ��� ����' }
	local row := T_ROW, col := T_COL-5
	
	if ( aHash := QueryDataForTheReport() ) != nil
		&& if ( ret := popup_prompt( row, col, 1, mas2_pmt ) ) == 1
			&& ViewListContract( aHash )
		&& elseif ret == 2
			hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @ReportLogBookThread(), aHash )
			WaitingReport()
		&& endif
	endif
	return nil

* 02.10.2018 ��⠢����� ��ୠ�� ���ࠢ���� ����஢ � ��樥�⠬�
function ReportDispatchersAndPatients()
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @ReportPaidSenderDoctorPatients(), aHash )
		WaitingReport()
	endif
	return nil
	
* 02.10.2018 ��⠢����� ��ୠ�� ���ࠢ���� ����஢ � ��㣠��
function ReportDispatchersAndServices()
	local aHash

	if ( aHash := QueryDataForTheReport() ) != nil
		hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @ReportPaidSenderDoctorServices(), aHash )
		WaitingReport()
	endif
	return nil

function ViewListContract( aHash )
	local aContracts := {}
	local blkEditObject
	local oBox, aEdit := {}
	local aProperties
	local blcCodeColor := { | | iif( parr[nInd]:IsCashbox == 2, { 5, 6 }, ;
		iif( parr[nInd]:Total > 0, { 1, 2 }, { 3, 4 } ) ) }	
	
	blkEditObject := { | oBrowse, aObjects, object, nKey | editListContracts( oBrowse, aObjects, object, nKey ) }
	
	aContracts := asort( TContractDB():getListByCondition( aHash ), , , { | x, y | x:BeginTreatment > y:BeginTreatment } )

	if Len( aContracts ) != 0
		
		if hb_user_curUser:IsAdmin()
			aEdit := { .t., .t., .t., .t. }
		else
			aEdit := { .f., .f., .f., .f. }
		endif
		
		aProperties := { { 'DepartmentShort', '��-���', 5, blcCodeColor }, { 'Patient', '��樥��', 15, blcCodeColor }, ;
						{ 'FillColumnCheque', 'N 祪', 5, blcCodeColor }, { 'TotalBank_F', '', 2, blcCodeColor }, ;
						{ 'BeginTreatment', '  ���  ', 10, blcCodeColor } }
		if mem_naprvr == 2	// �⮡ࠦ��� ⠡���� ����� ���ࠢ��襭�� ���
			aadd( aProperties, { { 'SendDoctorTabNom', '����.', 5 } } )
		endif
		aadd( aProperties, { { 'Total_F', '  �㬬� ', 5 } } )
		
		oBox := TBox():New( 8, 0, maxrow() - 2, 79, .t. )
		oBox:Caption := '���᮪ ������஢ ' + aHash[ 'SELECTEDPERIOD' ][ 4 ]
		oBox:CaptionColor := color0

		ListObjectsBrowse( 'TContract', oBox, aContracts, 1, aProperties, ;
										blkEditObject, aEdit, , , )
	endif
	return nil
	
* 02.10.18 ����祭�� ���ଠ樨 �� �த���� ���ᮢ��� ������
function f1_inf_fr( type )

	hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @CashRegisterStatus(), getDrvFR(), type )
	WaitingReport()
	return nil
	
***** 04.10.18 ������ �����
function CashierReport( lOrthopedics )
	local mas_op1 := {}, mas_op2 := {}
	local oEmpl
	local aHash
	local aContracts, item

	hb_default( @lOrthopedics, .f. )
	if ( aHash := QueryDataForTheReport( .t., .t., .f. ) ) == nil
		return nil
	endif
	
	//
	mywait()
	aContracts := TContractDB():getListContractByDatePayment( aHash[ 'SELECTEDPERIOD' ][ 7 ], aHash[ 'SELECTEDPERIOD' ][ 8 ], hb_user_curUser )
	
	for each item in aContracts
		if hb_ascan( mas_op1, { | x | x == item:Cashier:ID } ) == 0
			aadd( mas_op1, item:Cashier:ID )
			aadd( mas_op2, item:Cashier:FIO )
		endif
	next
	// ����� �� �����ࠬ
	if len( mas_op1 ) == 0
		bkol_oper := 0
		hwg_MsgInfoBay( "��� ���ଠ樨 " + aHash[ 'SELECTEDPERIOD' ][ 4 ], "����饭��" )
	elseif len( mas_op1 ) == 1
		bkol_oper := 1
	else
		bkol_oper := popup_prompt( T_ROW, T_COL + 5, 1, mas_op2 )
	endif
	if bkol_oper > 0
		CashierReportRep( aContracts, bkol_oper, aHash, mas_op1, mas_op2, lOrthopedics )
	endif
	return nil
	