* Audit.prg - ࠡ�� � ����묨 ࠡ��� ���짮��⥫ﬨ ��⥬�
*******************************************************************************
* 13.11.18 AuditWrite( task, type, work, quantity, field ) - ������ ���ଠ樨 � 䠩� �㤨�
*******************************************************************************

#include 'hbthread.ch'
#include 'common.ch'
#include 'set.ch'
#include 'inkey.ch'

#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 13.11.18 - ������ ���ଠ樨 � 䠩� �㤨�
function AuditWrite( task, type, work, quantity, field )
	local oAudit

	oAudit := TAuditDB():getByParam( sys_date, hb_user_curUser:ID, task, type, work )
	if isnil( oAudit )
		oAudit := TAudit():New()
		oAudit:Date := sys_date
		oAudit:Operator := hb_user_curUser:ID
		oAudit:Task := task
		oAudit:Type := type
		oAudit:Work := work
	endif
	oAudit:Quantity += hb_defaultValue( quantity, 0 )
	oAudit:Field += hb_defaultValue( field, 0 )
	TAuditDB():Save( oAudit )
	return .t.