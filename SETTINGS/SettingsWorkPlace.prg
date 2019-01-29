#include 'inkey.ch'
#include 'setcurs.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

function settingsWorkPlace( r, c )
	local mas_pmt := { '~Подключаемое оборудование', ;
			'~Настройка значений по умолчанию' }
	local mas_msg := { 'Настройка подключаемого оборудования', ;
			'Настройка значений по умолчанию на рабочем месте' }
	local mas_fun := { 'addedEquipment()', ;
			'nastr_rab_mesto()' }
			
	DEFAULT r TO T_ROW, c TO T_COL + 5
	popup_prompt( r, c, 1, mas_pmt, mas_msg, mas_fun )
	return nil

function addedEquipment()
	
	hb_Alert( 'Оборудование' )
	return nil