* ReportPaid.prg - ������ � �������� ������� �����
*******************************************************************************
* 09.10.18 CashRegisterStatus( type ) - ��������� ���������� �� ��������� ��������� ��������
* 08.10.18 PatientsWithoutChecks( aHash ) - �������, � ������� ������� ������, �� �� ������ ���
* 08.10.18 InformationOnRefunds( aHash, lOrthopedics ) - ���������� �� ���������
* 04.10.18 CashierReportRep( aContracts, bkol_oper, aHash, mas_op1, mas_op2 ) - ������ ������� �������� �����
* 10.05.17 ReportPaidSenderDoctorPatients( aHash ) - ���������� �� ����������� ������ � ��������� ���������� �������

* ContractsToJson( aHash, aReport ) - ������������ � ��������� � ���� ������� JSON
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'

* 09.10.18 ��������� ���������� �� ��������� ��������� ��������
function CashRegisterStatus( drvFR, type )
/* type - ���� ��������� ����������,
	1 - ������� �������
	2 - ���������
	3 - ����� ���
*/
	local arr := {}, ;
		c4date := dtoc4(sys_date), ;
		regim := 0, str_regim := '', value := 0, ;
		strNone := '���������� �� ��������� �������� �����������', ;
		strOff := '�� ������� ����� ����������� ���������� ���. ��������� �����: ', ;
		strKassa := '�� �������� ��������� ��������:', ;
		fr_serial_number := ''
	local ostMorning := 0.0, incomeCash := 0.0, saleCash := 0.0, cardCash := 0.0, vozrCash := 0.0, outcomeCash := 0.0, ;
		vozrCard := 0.0
	local oDoc, oNode, oTable, oRow, oCell
	local totalPaid, totalCash, totalRefund
	local aResultWork

	fr_serial_number := drvFR:SerialNumber
	
	aResultWork := TContractDB():getResultWorkShift( sys_date, fr_serial_number ) // ������� ���������� �� ����� �� ��
	totalPaid := aResultWork[ 1 ]
	totalCash := aResultWork[ 2 ]
	totalRefund := aResultWork[ 3 ]

	
	oDoc := CreateReportHTML( '���������� �� �����' )
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := win_OEMToANSI( date_month( sys_date, .t. ) )
	oNode         := oNode   - 'center'


	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := strKassa + str_regim
	oNode         := oNode   - 'div'
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '��������� ����� ���: ' + fr_serial_number
	oNode         := oNode   - 'div'
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '-----------------------------------------------------'
	oNode         := oNode   - 'div'

	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '������� ��������� � �����:              ' + str( drvFR:GetCashReg() )
	oNode         := oNode   - 'div'
	ostMorning := value

	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '����� �����, ��������� � �����:         ' + str( drvFR:GetIncome() )
	oNode         := oNode   - 'div'
	incomeCash := value

	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '�������� ��������� �� �����:            ' + str( drvFR:GetSaleCash() )
	oNode         := oNode   - 'div'
	saleCash := value
		
	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '�������� ����������� ������� �� �����:  ' + str( drvFR:GetSaleCard() )
	oNode         := oNode   - 'div'
	cardCash := value

	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '�������� ��������� �� �����:            ' + str( drvFR:GetReturnSaleCash() )
	oNode         := oNode   - 'div'
	vozrCash := value

	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '������� �� �����:                       ' + str( drvFR:GetOutcome() )
	oNode         := oNode   - 'div'
	outcomeCash := value

	value := 0
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '�������� ����������� ������� �� �����:  ' + str( drvFR:GetReturnSaleCard() )
	oNode         := oNode   - 'div'
	vozrCard := value

	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '-----------------------------------------------------'
	oNode         := oNode   - 'div'

	oNode         := oNode   + 'hr'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h3
	oNode         := oNode   + 'center'
	oNode:text    := '�� �������� ���������:'
	oNode         := oNode   - 'center'
	
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '����� ���������:                      ' + lstr( abs( totalRefund ), 15, 2 )
	oNode         := oNode   - 'div'

	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '����� ������ ����� ����� �� �����:    ' + lstr( totalPaid, 15, 2 )
	oNode         := oNode   - 'div'

	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '����� �������� ����� � ����� ���:     ' + lstr( totalCash, 15, 2 )
	oNode         := oNode   - 'div'
	ViewHTML( oDoc )
	return nil

* 04.10.18 ������ ������� �������� �����
function CashierReportRep( aContracts, bkol_oper, aHash, mas_op1, mas_op2, lOrthopedics )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	local aTitle := { '������ �������' }
	local sm2 := 0, ii, sm_bn := 0
	local menu_opl
	local item
	
	if lOrthopedics
		menu_opl := {	{ '�����               ', 0 }, ;
						{ '������������� ������', 1 }, ;
						{ '���������           ', 2 } }
	else
		menu_opl := {	{ '���������.', 0 }, ;
						{ '��������� ', 1 }, ;
						{ '�/�����   ', 2 } }
	endif

	oDoc := CreateReportHTML( '����������� ����� �� ������' )
	
	/* Operator ":" returns first "h1" from body (creates if not existent) */
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := '� � � � � �'
	oNode         := oNode   - 'center'
	
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := '����������� ����� �� ������ ��������� ����������� ������� ����� ���������'
	oNode         := oNode   - 'center'
	
	oNode         := oDoc:body:h3
	oNode         := oNode   + 'center'
	oNode:text    := win_OEMToANSI( alltrim( hb_main_curOrg:Name() ) )
	oNode         := oNode   - 'center'
	
	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := win_OEMToANSI( aHash[ 'SELECTEDPERIOD' ][ 4 ] )
	oNode         := oNode   - 'center'

	oNode         := oDoc:body:h3
	oNode         := oNode   + 'center'
	oNode:text    := aHash[ 'STRINGFORPRINT' ]
	oNode         := oNode   - 'center'
	
	oNode         := oNode   + 'hr'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body:table
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	//
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= 'N'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�.�.�. ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '��� �'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	// 6-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	//
	&& if hb_defaultValue( lOrthopedics, .f. )
		&& oCell     := oRow + 'th width:10%'
		&& oCell:text := '���'
		&& oCell     := oCell - 'th'
		&& HB_SYMBOL_UNUSED( oCell )
		&& //
		&& oCell     := oRow + 'th width:10%'
		&& oCell:text := '�����'
		&& oCell     := oCell - 'th'
		&& HB_SYMBOL_UNUSED( oCell )
	&& endif
	// 7-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
	sm2 := ii := 0
	
	for each item in aContracts
		if item:Cashier:ID != mas_op1[ bkol_oper ]
			loop
		endif
		oRow       := oTable + 'tr'
		
		// 1-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="right"'
		oCell:text := lstr( ++ii ) 
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="left"'
		oCell:text := alltrim( item:Patient:FIO1251 ) + win_OEMToANSI( iif( item:TotalBank > 1, space( 10 ) + '��', '' ) ) 
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="center"'
		oCell:text := padr( sectotime( item:TimeCashbox ), 5 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="center"'
		oCell:text := padl( lstr( item:ReceiptNumber ), 5 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 5-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="center"'
		oCell:text := padl( lstr( item:Patient:ID ), 6 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 6-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="right"'
		oCell:text := iif( item:TotalBank > 1, put_kope( item:TotalBank, 10 ), put_kope( item:Total, 10 ) )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		//
		&& if hb_defaultValue( lOrthopedics, .f. )
			&& oCell      := oRow + 'td'
			&& oCell:text := padr( alltrim( inieditspr( A__MENUVERT, menu_opl, tmp->tip_op ) ), 3 )
			&& oCell      := oCell - 'td'
			&& HB_SYMBOL_UNUSED( oCell )
			&& oCell      := oRow + 'td'
			&& oCell:text := win_OEMToANSI( padl( lstr( tmp->nar_z ), 5 ) )
			&& oCell      := oCell - 'td'
			&& HB_SYMBOL_UNUSED( oCell )
		&& endif
		//
		// 7-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3-medium" valign="center" align="left"'
		if isnil( item:SendDoctor )
			oCell:text := padr( '&nbsp;', 20 ) + iif( item:DateCashbox != item:BeginTreatment .or. item:DateCashbox != item:EndTreatment, '*', ' ' )
		else
			oCell:text := padr( fam_i_o( item:SendDoctor:ShortFIO1251 ), 20 ) + iif( item:DateCashbox != item:BeginTreatment .or. item:DateCashbox != item:EndTreatment, '*', ' ' )
		endif
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		sm2 += item:Total
		sm_bn += item:TotalBank
	next
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := padR( '�����: ', 61 ) + put_kope( sm2, 12 )
	oNode         := oNode   - 'div'
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '����� �� �����: ' + win_OEMToANSI( srub_kop( sm2, .t. ) )
	oNode         := oNode   - 'div'
	if GetSetKKT():EnableTypePay2()
		oNode         := oDoc:body
		oNode         := oNode   + 'div'
		oNode:text    := '�� ��� � �����: ' + win_OEMToANSI( srub_kop( sm2 - sm_bn, .t. ) )
		oNode         := oNode   - 'div'
	endif
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '���� ���.�����������:                         /' + win_OEMToANSI( alltrim( mas_op2[ bkol_oper ] ) ) + '/'
	oNode         := oNode   - 'div'
	oNode         := oDoc:body
	oNode         := oNode   + 'div'
	oNode:text    := '������ ������:                                /                     /'
	oNode         := oNode   - 'div'
	oTable        := oTable - 'table'
	ViewHTML( oDoc )
	return nil

* 08.10.18 ���������� �� ���������
function InformationOnRefunds( aHash, lOrthopedics )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	local fl := .t., sm := 0, sm_sn := 0, sm_usl := 0, sum_sl := 0
	local oEmpl
	local aTitle := { '������ ��������� ������' }
	local aContracts, item, itemService
	
	hb_default( @lOrthopedics, .f. )
	
	aContracts := TContractDB():getListContractByDatePayment( aHash[ 'SELECTEDPERIOD' ][ 7 ], aHash[ 'SELECTEDPERIOD' ][ 8 ], hb_user_curUser )
	
	oDoc := CreateReportHTML( '������� ������' )
	
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := if( lOrthopedics, '������� ������ �������', '������� ������ �����' )
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := if( lOrthopedics, '(�� ���� ��������)', '(�� ���� ������ �������)' )
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := win_OEMToANSI( aHash[ 'SELECTEDPERIOD' ][ 4 ] )
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := aHash[ 'STRINGFORPRINT' ]
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body:table
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
		
	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'

	for each item in aContracts
		oRow       := oTable + 'tr'
		
		// 1-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="left"'
		oCell:text := iif( isnil( item:Patient ), '������: ����������� �������', alltrim( item:Patient:FIO1251 ) )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		
		// 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="right"'
		oCell:text := put_kope( item:Total, 12 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="center"'
		oCell:text := dtoc( item:DateBackMoney )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="right"'
		oCell:text := put_kope( item:BackMoney, 12 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3-medium" valign="center" align="left"'
		oCell:text := iif( isnil( item:CashierBack ), '������: ����������� ���������', alltrim( item:CashierBack:FIO1251 ) )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		sm_sn += item:BackMoney
		
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	next
	
	oRow       := oTable + 'tr'
	oCell      := oRow + 'td'
	oCell:attr	:= 'valign="center" align="right" colspan="3"'
	oCell:text := '�����:'
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oCell      := oRow + 'td'
	oCell:attr	:= 'valign="center" align="right"'
	oCell:text := put_kope( sm_sn, 12 )
	oCell      := oCell - 'td'
	HB_SYMBOL_UNUSED( oCell )
	
	oRow := oRow - 'tr'
	HB_SYMBOL_UNUSED( oRow )
	
	ViewHTML( oDoc )
	return nil

* 08.10.18 �������, � ������� ������� ������, �� �� ������ ���
function PatientsWithoutChecks( aHash )
	local oDoc, oNode, oTable, oRow, oCell, oHTable, oBTable
	local aTitle := { '������ ��������� ��� �����' }
	local j := 0, item
	local aContracts
	
	aContracts := TContractDB():getListContractByDateWithoutCheck( aHash[ 'SELECTEDPERIOD' ][ 5 ], aHash[ 'SELECTEDPERIOD' ][ 6 ], hb_user_curUser )
	// ��������� HTML-��������

	oDoc := CreateReportHTML( '������ ��������� ��� �����' )
	
	/* Operator ":" returns first "h1" from body (creates if not existent) */
	oNode         := oDoc:body:h1
	oNode         := oNode   + 'center'
	oNode:text    := '������ ��������� ��� �����'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := '(�� ���� ������ �������)'
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := win_OEMToANSI( aHash[ 'SELECTEDPERIOD' ][ 4 ] )
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )

	oNode         := oDoc:body:h2
	oNode         := oNode   + 'center'
	oNode:text    := aHash[ 'STRINGFORPRINT' ]
	oNode         := oNode   - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oTable        := oDoc:body:table
	oTable:attr   := 'border="0" cellspacing="0" cellpadding="0"'
	
	oTH		:= oTable  + 'tr'
	oTH:attr		:= 'class="head"'
	
	// 1-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '� �/�'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )

	// 2-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '�������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 3-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '���� ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 4-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '����� ��������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	// 5-� �������
	oCell		:= oTH + 'th'
	oCell:attr	:= 'class="thleft thright"'
	oParag			:= oCell + 'p'
	oParag:attr		:= 'align="center" class="bodyp"'
	oParag:text		:= '������'
	oParag			:= oParag - 'p'
	oCell		:= oCell - 'th'
	HB_SYMBOL_UNUSED( oCell )
	
	oTH := oTH - 'tr'
	for each item in aContracts
		oRow       := oTable + 'tr'
		// 1-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="center"'
		oCell:text := lstr( ++j )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 2-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="left"'
		oCell:text := iif( isnil( item:Patient ), '������: ����������� �������', alltrim( item:Patient:FIO1251 ) )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 3-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="center"'
		oCell:text := dtoc( item:BeginTreatment )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )

		// 4-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td1-medium" valign="center" align="right"'
		oCell:text := put_kope( item:Total, 12 )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		
		// 5-� �������
		oCell      := oRow + 'td'
		oCell:attr	:= 'class="td3-medium" valign="center" align="left"'
		oCell:text := iif( isnil( item:Cashier ), '������: ����������� ���������', alltrim( item:Cashier:FIO1251 ) )
		oCell      := oCell - 'td'
		HB_SYMBOL_UNUSED( oCell )
		oRow := oRow - 'tr'
		HB_SYMBOL_UNUSED( oRow )
	next
	ViewHTML( oDoc )
	return nil

* ������������ � ��������� � ���� ������� JSON
procedure ContractsToJson( aHash, aReport )
	local oRow := nil, obj := nil
	local hItems, hItem, h

	h := { => }
	hItems := { => }
	hb_HSet( h, 'Period', aHash[ 'SELECTEDPERIOD' ][ 4 ] )
	hb_HSet( h, 'Text', win_ANSIToOEM( aHash[ 'STRINGFORPRINT' ] ) )
	&& if aHash[ 'SELECTEDSUBDIVISION' ] == nil
		&& oNode:text    := titleDepartmentForHTML( aHash[ 'SELECTEDDEPARTMENT' ], aHash[ 'SELECTEDPERIOD' ] )
	&& else
		&& oNode:text    := titleSubdivisionForHTML( aHash[ 'SELECTEDSUBDIVISION' ] )
	&& endif
	
	for each oRow in aReport
		&& hItem := { => }
		
		&& hb_HSet( hItem, 'Contract', oRow:forJSON )
		&& hb_HSet( hItem, 'ShortName', alltrim( obj:ShortName ) )
		&& hb_HSet( hItem, 'Name', alltrim( obj:Name ) )
		&& if obj:Department != nil
			&& hb_HSet( hItem, 'Department', obj:Department:forJSON() )
		&& endif
		&& hb_HSet( hItem, 'CodeTFOMS', alltrim( obj:CodeTFOMS ) )
		&& hb_HSet( hItems, ltrim( str( oRow:ID ) ), hItem )
		hb_HSet( hItems, ltrim( str( oRow:ID ) ), oRow:forJSON )
	next
	h[ 'Contracts' ] := hItems
	MEMOWRIT( 'Contract.json' , hb_jsonencode( h, .t., 'RU1251' ) )
	return