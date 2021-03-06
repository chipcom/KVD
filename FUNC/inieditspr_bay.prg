#include "function.ch"
#include "edit_spr.ch"
#include "inkey.ch"
#include "getexit.ch"

***** �㭪�� ���樠����樨 ��६�����
Function inieditspr_bay( type, arr_name, j )
// type     - ⨯ ���樠����樨
// arr_name - ��㬥�� ��� �������� ���ᨢ (��� ��⮢�� �������樨)
//            ��� ������������ ���� ������ � ��砥 A__POPUP...
// j        - �᫮ ��� ���樠����樨
	Local s := "", k := 0
	
	do case
		case equalany(type,A__MENUHORIZ,A__MENUVERT)
			if ( k := ascan( arr_name, { | x | x[2] == j } ) ) > 0
				s := arr_name[k, 1]
			else
				s := space( 10 )
			endif
		case type == A__MENUBIT
			if valtype( arr_name[1] ) == "A"
				aeval( arr_name, { | x | s += IF( ISBIT( j, x[2] ), alltrim( x[1]) + ", ", "" ) } )
			else
				aeval( arr_name, { | x, i | s += IF( ISBIT( j, i ), alltrim( x ) + ", ", "" ) } )
			endif
			s := if( empty( s ), space( 10 ), substr( s, 1, len( s ) - 2 ) )
		case equalany( type, A__POPUPBASE, A__POPUPBASE1, A__POPUPEDIT, A__POPUPMENU )
			s := retpopupedit_bay( arr_name, j )
	endcase

	return s