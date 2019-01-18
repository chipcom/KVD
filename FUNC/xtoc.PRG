#require 'xhb'
#require 'hbmisc'

#include 'hbdll.ch'

IMPORT static DebugMessageBox( hWnd, cMsg, cText, nFlags ) FROM user32.dll EXPORTED AS MessageBoxA

// Function to convert any type to string.
//  Правила перевода:
// строка - без изменения
// число  - строка
// дата   - строка
// объект - 'объект'
// NIL    - 'пусто!'
// блок кода - строка от результата
// массив    - слияние строк от элементов
// мемо      - значение
// логическое- 'истина' или ' ложь '
function xtoc( parm, len, dec )
	local t := '', ln := 0, i := 0, p := .f., ret
    ret := ''
    t = valtype( parm )
    do case
        case t = 'A'
            ln = len( parm )
            for i = 1 to ln
                ret := ret + xtoc( parm[ i ] )
            next
        case t = 'B'
            ret := xtoc( eval( parm ) )
        case t = 'C'
            ret := parm
        case t = 'D'
            ret := dtoc( parm )
        case t = 'L'
            ret := if( parm, 'TRUE ', 'FALSE' )
        case t = 'M'
            ret := parm
        case t = 'N'
            if !empty( len ) .and. !empty( dec )
               ret := str( parm, len, dec )
			elseif !empty( len )
//               ret:=str(parm,len)
                if len( alltrim( STR( parm ) ) ) > len
					ret := replicate( '*', len )
				else
					ret := padl( str( parm ), len )
				endif
			else
				ret := str( parm )
            endif
            p := .t.
        case t = 'O'
            ret := 'object'
        case t = 'U'
            ret := 'empty!'
        otherwise
            ret := '.?.'
   endcase
return ret

/*
    AsString
*/
function AsString( xVal )

   LOCAL result

   switch ValType( xVal )
   case 'C'
      return xVal
   case 'D'
      // return FDateS( xVal )
      if empty( xVal )
         return '  /   /    '
      endif
      return str( day( xVal ), 2 ) + '/' + left( cmonth( xVal ), 3 ) + '/' + str( year( xVal ), 4 )
   case 'B'
      return '{|| ... }'
   case 'L'
      return iif( xVal, '.T.', '.F.' )
   case 'N'
      return ltrim( str( xVal ) )
   case 'O'
      BEGIN SEQUENCE WITH {| oErr| break( oErr ) }
         if xVal:IsDerivedFrom( 'TTime' )
            result := xVal:AsString
         else
            result := '<Object>: ' + xVal:ClassName
         endif
      RECOVER
         result := '<Object Not Valid>'
      END SEQUENCE
      return result
   case 'A'
      return '<Array>: ' + LTrim( Str( Len( xVal ) ) )
   case 'T'
      return hb_tToC( xVal )
   endswitch
   return ''

function AlertX( param, len, dec )
	
	HB_Default( @len, 0 ) 
	HB_Default( @dec, 0 ) 
	alert( AsString( param ) )
	return nil

function AlertXList( param )
	local item
	
	for each item in param
		alertx(item)
	next
	return nil

function win_AlertX( param )
	
	HB_Default( @param, '' ) 
	hb_threadDetach( hb_threadStart( @DebugMessageBox(),  0, AsString( param ), win_OEMToAnsi( 'Отладка' ) ) )
	return nil