#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

function settingsWorkPlace( r, c )
	local mas_pmt := { '~������砥��� ����㤮�����', ;
			'~����ன�� ���祭�� �� 㬮�砭��' }
	local mas_msg := { '����ன�� ������砥���� ����㤮�����', ;
			'����ன�� ���祭�� �� 㬮�砭�� �� ࠡ�祬 ����' }
	local mas_fun := { 'addedEquipment()', ;
			'nastr_rab_mesto()' }
			
	DEFAULT r TO T_ROW, c TO T_COL + 5
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

function addedEquipment()
	
	hb_Alert( '����㤮�����' )
	return nil