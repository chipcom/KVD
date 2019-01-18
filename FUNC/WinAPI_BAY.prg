&& FUNCTION FNFMessage( cFileName )
	&& LOCAL cMessage, aOptions, nChoice

	&& aMessage := { cFileName, 'Not found !' }
	&& aOptions :=  { 'Abort', 'Retry', 'Skip' }
	&& nChoice := HB_Alert( aMessage, aOptions, , 15 )
	&& RETURN nChoice // FNFMessage()

function hwg_MsgInfoBay( str1, str2 )
//	hwg_MsgInfo( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )
	hb_alert( str1 )
	return nil

function hwg_MsgNoYesBay( str1, str2 )
	local ret
	local aOptions :=  { 'Нет', 'Да' }
	
	ret := hb_alert( str1, aOptions )
	&& return hwg_MsgNoYes( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )
	return if( ret == 0, .f., if( ret == 1, .f., .t. ) )

function hwg_MsgRetryCancelBay( str1, str2 )
	local ret
	local aOptions :=  { 'Повторить', 'Отмена' }
	
	ret := hb_alert( str1, aOptions )
	if( ret == 0, 2, ret )
	&& Return hwg_MsgRetryCancel( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )
	return ret

&& function hwg_MsgYesNoBay( str1, str2 )
	&& return hwg_MsgYesNo( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )

&& function hwg_MsgYesNoCancelBay( str1, str2 )
	&& return hwg_MsgYesNoCancel( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )

&& function hwg_MsgStopBay( str1, str2 )
	&& return hwg_MsgStop( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )

&& function hwg_MsgOkCancelBay( str1, str2 )
	&& return hwg_MsgOkCancel( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )

//Function hwg_ExclamationBay( str1, str2 )
//	Return hwg_Exclamation( win_OEMToANSI( str1 ), win_OEMToANSI( str2 ) )
	
	
//Function hwg_MsgGetBay(cTitle, cText, nStyle, x, y, nDlgStyle, cRes)
//	hwg_MsgGet( win_OEMToANSI(cTitle), win_OEMToANSI(cText), nStyle, x, y, nDlgStyle, cRes )
//	RETURN cRes
	
function MyRun( cCommand, lFlag )
	local oShell, nErrorlevel

	hb_Default( @lFlag, .F. )
	oShell      := WIN_OleCreateObject( "WScript.Shell" )
	nErrorlevel := oShell:RUN( GETENV( "COMSPEC" ) + " /c " + cCommand, 0, lFlag )
//	nErrorlevel := oShell:RUN( "%COMSPEC% /c " + cCommand, 0, lFlag )  // 	Optional way
	oShell      := NIL
	return IF( nErrorlevel = 0, .T., .F. )
	