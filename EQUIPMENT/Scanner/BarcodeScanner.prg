#include 'set.ch'
#include 'getexit.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'
#include 'common.ch'

#include 'hbthread.ch'

* 06.02.19
* функция чтения штрих-кода со сканера подключенного к COM-порту
function readBarcode( oWinPort )//, oBarcodeOMS )
	local cString := space( 132 )
	local lCTSHold, lDSRHold, lDCDHold, lXoffHold, lXoffSent, nInQueue, nOutQueue
	local sResult
	
	do while .t.
		if oWinPort:QueueStatus( @lCTSHold, @lDSRHold, @lDCDHold, @lXoffHold, @lXoffSent, @nInQueue, @nOutQueue )
			if nInQueue == 132
				oWinPort:Read( @cString, 132 )
				cString	:= substr( cString, 1, 130 )
				sResult := decodeBarcodeOMS( cString )
				keyboard chr( K_ENTER )
				oBarcodeOMS:Fill( sResult )
			endif
		else
		endif
		hb_idleSleep( 0.5 )
	enddo
	return nil

* 05.02.19
#pragma BEGINDUMP
	#include "hbapi.h"
	#include "hbapiitm.h"
	#include <windows.h>
	#include "pcbcode.h"

	HB_FUNC( DECODEBARCODEOMS )
	{
		BYTE * szText    = hb_parcx( 1 );
		
		PHB_ITEM pArray = hb_itemArrayNew( 8 );
		DWORD dwLength	= 130;
		BARCODE_T1 T1   = {0};
		
		char strPolicy[ 16 ];
		char strDateDOB[ 10 ];
		char strDateExpire[ 10 ];
		
		DWORD dwError		= DecomposeBarcode( &szText[ 0 ], dwLength, &T1 );
		
		if( dwError != 0 ) {
//			ErrorExit("DecomposeBarcode");
		}
		
		hb_arraySetNI( pArray, 1, T1.Header.BarcodeType );
		sprintf( strPolicy, "%016I64d", T1.Body.PolicyNumber );
		hb_arraySetC( pArray, 2, strPolicy );
		
		hb_arraySetC( pArray, 3, T1.Body.LastName );
		hb_arraySetC( pArray, 4, T1.Body.FirstName );
		hb_arraySetC( pArray, 5, T1.Body.Patronymic );
		hb_arraySetC( pArray, 6, T1.Body.Sex == 1 ? "М":"Ж" );
		
		sprintf( strDateDOB, "%02d.%02d.%04d", T1.Body.BirthDate.wDay,T1.Body.BirthDate.wMonth,T1.Body.BirthDate.wYear );
		hb_arraySetC( pArray, 7, strDateDOB );
		
		sprintf( strDateExpire, "%02d.%02d.%04d", T1.Body.ExpireDate.wDay,T1.Body.ExpireDate.wMonth,T1.Body.ExpireDate.wYear );
		hb_arraySetC( pArray, 8, strDateExpire );
	  
		hb_itemReturnRelease( pArray );
	}
#pragma ENDDUMP