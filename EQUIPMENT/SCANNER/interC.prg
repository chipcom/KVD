
procedure main( ... )
	local hDLL

	&& MY_SIN( 0.5, 1, .t., 'Test 1' )
	&& MY_SIN( 0, 2, .f., 'Test 2' )
	&& MY_SIN( 1, 3, .t., 'Test 3' )
	?
	?C_FUNC()
	
	hDLL := DllLoad( "pcbcode.dll" )
	if hDLL == nil
		?"Don't load"
	endif
	lllDD( hDLL )
	DllUnload( hDLL )

	?'Press any key'
	inkey(0)
	return

#pragma BEGINDUMP
	#include <extend.h>
	#include <math.h>
	#include <stdio.h>
	#include "hbapi.h"
	// #include "hbapiitm.h"
	// #include "hbapierr.h"

	HB_FUNC( MY_SIN )
	{
		double x = hb_parnd(1);
//		int xi = hb_parni(2);
//		HB_BOOL l = hb_parl(3);
		const char * szText = hb_parc( 4 );

		// printf("number - %d, logical - %d", xi, l);
		printf("string - %s", szText);
		hb_retnd( sin( x ) );
	}
	HB_FUNC( C_FUNC )
	{
		hb_retc( "returned from C_FUNC()\n" );
	}
	HB_FUNC( LLLDD )
	{
		const HB_BYTE * pCode = hb_parc(1);
		printf("Move \n");
		;
	}
#pragma ENDDUMP