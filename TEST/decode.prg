// http://myshinobi.ru/dekodirovanie-rasshifrovka-shtrih-koda-polisa-oms-chast-1/

#require "xhb"
#require "hbmisc"

#include "hbdll.ch"

procedure main( ... )
	// данные для отладки
	local aBarcode := {}, item
	local barcode_data_V1 := '010016E959AF0F3A6C53E684D37771CEEF39DF38711DE4FCD27685DF35419C03000000000000000000000000000000000000000271D3000000EF4A04BDB800F618017DDE3F6B9C4B4592FB28EB75EF1E0D2274BD0F57377284F02469698A8CAC4A912FE74D773AF6FC0C8D71515CB88176EC04A414B179AD00AC548295033972DC82'
	local barcode_data_V2 := '0200000000363D804E9DB3A17503BF84E869B9C3BF39C3A175AA5341C3800000000000000000000000000000000000000000000000000000000000000283EB0000015CEA680D9CDDEF0209E9F91FFEA628328CD157144B634204BAC30F573FF2E1021BDC2A28B2DD50A2761E4CF75FFCDBFBA71EAFC548AD07D38DC82A7D674BD09A'
	local decoded
	local test1, test2
	local sRet := space( 200 )
	

	REQUEST HB_CODEPAGE_RU866
	HB_CDPSELECT( 'RU866' )
	REQUEST HB_LANG_RU866
	HB_LANGSELECT( 'RU866' )

	&& fio := substr( barcode_data_V2, 11, 50 )
	&& ? hb_BLen( fio )
	&& ? fio
	&& decode( fio )
	?
	? hb_Translate( myfunc(barcode_data_V2), 'cp1251', 'cp866' )
	? 
	?
	
	&& ?'Нажмите любую клавишу...'
	inkey(0)
	return

#pragma BEGINDUMP
	#include "hbapi.h"
	#include <windows.h>
	#include <locale.h>
//	#include "hbwapi.h"
	#include "pcbcode.h"
//	#include <math.h>
	
	HB_FUNC( MYFUNC )
	{
		const char * szText    = hb_parcx( 1 );
		setlocale( LC_ALL, "Russian" );
		BYTE bar_code_data_V1[]  = 
		{
			0x01, 0x00, 0x16, 0xE9, 0x59, 0xAF, 0x0F, 0x3A, 
			0x6C, 0x53, 0xE6, 0x84, 0xD3, 0x77, 0x71, 0xCE, 
			0xEF, 0x39, 0xDF, 0x38, 0x71, 0x1D, 0xE4, 0xFC, 
			0xD2, 0x76, 0x85, 0xDF, 0x35, 0x41, 0x9C, 0x03, 
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
			0x00, 0x00, 0x00, 0x02, 0x71, 0xD3, 0x00, 0x00, 
			0x00, 0xEF, 0x4A, 0x04, 0xBD, 0xB8, 0x00, 0xF6, 
			0x18, 0x01, 0x7D, 0xDE, 0x3F, 0x6B, 0x9C, 0x4B, 
			0x45, 0x92, 0xFB, 0x28, 0xEB, 0x75, 0xEF, 0x1E, 
			0x0D, 0x22, 0x74, 0xBD, 0x0F, 0x57, 0x37, 0x72, 
			0x84, 0xF0, 0x24, 0x69, 0x69, 0x8A, 0x8C, 0xAC, 
			0x4A, 0x91, 0x2F, 0xE7, 0x4D, 0x77, 0x3A, 0xF6, 
			0xFC, 0x0C, 0x8D, 0x71, 0x51, 0x5C, 0xB8, 0x81, 
			0x76, 0xEC, 0x04, 0xA4, 0x14, 0xB1, 0x79, 0xAD, 
			0x00, 0xAC, 0x54, 0x82, 0x95, 0x03, 0x39, 0x72, 
			0xDC, 0x82 
		};
		
		DWORD dwLength	= 130;
		BARCODE_T1 T1   = {0};
		
		DWORD dwError		= DecomposeBarcode(&bar_code_data_V1[0], dwLength, &T1);
		
		//Вывод на консоль
		printf("Тип штрих-кода:         %d\r\n", T1.Header.BarcodeType);
		printf("Номер полиса ОМС:       %016I64d\r\n", T1.Body.PolicyNumber);
		printf("Фамилия:                %s\r\n", T1.Body.LastName);
		printf("Имя:                    %s\r\n", T1.Body.FirstName);
		printf("Отчество:               %s\r\n", T1.Body.Patronymic);
		printf("Дата рождения:          %02d.%02d.%04d\r\n", T1.Body.BirthDate.wDay,T1.Body.BirthDate.wMonth,T1.Body.BirthDate.wYear);
		printf("Срок действия полиса    %02d.%02d.%04d\r\n", T1.Body.ExpireDate.wDay,T1.Body.ExpireDate.wMonth,T1.Body.ExpireDate.wYear);
		printf("Пол                     %s\r\n", T1.Body.Sex == 1 ? "Мужской":"Женский");
		if( dwError != 0 ) {
			ErrorExit("DecomposeBarcode");
		}
		hb_retc( T1.Body.LastName );
	}
	
	void ErrorExit(LPTSTR lpszFunction) 
	{ 
		CHAR szBuf[80]={0}; 
		LPVOID lpMsgBuf;
		DWORD dw = GetLastError(); 
		DWORD ch_count = FormatMessage(
			FORMAT_MESSAGE_ALLOCATE_BUFFER | 
			FORMAT_MESSAGE_FROM_HMODULE,
			GetModuleHandle("pcbcode.dll"),
			dw,
			MAKELANGID(LANG_RUSSIAN, SUBLANG_DEFAULT),
			(LPTSTR) &lpMsgBuf,
			0, NULL );
		if( ch_count == 0 )
		{
			FormatMessage(
					FORMAT_MESSAGE_ALLOCATE_BUFFER | 
					FORMAT_MESSAGE_FROM_SYSTEM,
					NULL,
					dw,
					MAKELANGID(LANG_RUSSIAN, SUBLANG_DEFAULT),
					(LPTSTR) &lpMsgBuf,
					0, NULL );
		}
		sprintf(szBuf, 
			"%s failed with error %d: %s", 
			lpszFunction, dw, lpMsgBuf); 
		printf(szBuf);
		//MessageBox(NULL, szBuf, "Error", MB_OK); 
		LocalFree(lpMsgBuf);
		ExitProcess(dw); 
	}	
#pragma ENDDUMP

&& function decodeOMS( cData )

	&& local fioData := substr( cData, 11, 50 )

	&& return nil

// Сюда передается уже развернутая как надо строка
// На основе примера 39 C4 1D
//
// 00111001 11000100 00011101
// 39       C4       1D
// 001110 011100 010000 011101
// 0E     1C     10     1D
// То бишь нам надо разбить пачку 8ми битных символов на 6ти битные последовательности
&& function decode( s )
	&& local ret
	&& local i, c, t
	&& local ch, ch1
&& function Decode(S: String): String;
&& var
  && I: Byte;
  && C: Byte;
  && T: Word;
&& begin
  && C := 0;
  && I := 0;
 && while (Length(S) > 0) and ((Length(S) > 1) or (I < 1)) do
    && begin
      && case I of
        && 0:
          && begin
            && C := Ord(S[1]) shr 2;
          && end;
        && 1:
          && begin
            && T := Ord(S[1]) * 256 + Ord(S[2]);
            && T := T shl 6;
            && C := Byte(T shr 10);
          && end;
        && 2:
          && begin
            && Delete(S, 1, 1);
            && T := Ord(S[1]) * 256 + Ord(S[2]);
            && T := T shl 4;
            && C := Byte(T shr 10);
          && end;
        && 3:
          && begin
            && Delete(S, 1, 1);
            && C := Byte(Ord(S[1]) shl 2);
            && C := Byte(C shr 2);
            && Delete(S, 1, 1);
          && end;
      && end;
      && I := (I + 1) mod 4;
      && Result := Result + GetCharByCode(C);
    && end;
&& end;
	&& i := 0
	&& c := 0
	&& t := 0
	&& while ( hb_BLen( s ) > 0 ) .and. ( ( hb_BLen( s ) > 1 ) .or. ( i < 1 ) )
&& ? 'I (while):', i
		&& do case
			&& case i == 0
				&& ch := asc( hb_BSubstr( s, 1, 1 ) )
				&& c := hb_bitShift( ch, -2 )
			&& case i == 1
				&& ch := hb_BSubstr( s, 1, 1 )
&& ? 'Char: ', ch
				&& ch1 := hb_BSubstr( s, 2, 1 )
&& ? 'Char: ', ch1
				&& t := asc( ch ) * 256 + asc( ch1 )
				&& t := hb_bitShift( t, 6 )
				&& c := hb_bitShift( t, -10 )
			&& case i == 2
				&& s := hb_BSubstr( s, 2 )
				&& ch := hb_BSubstr( s, 1, 1 )
				&& ch1 := hb_BSubstr( s, 2, 1 )
				&& t := asc( ch ) * 256 + asc( ch1 )
				&& t := hb_bitShift( t, 4 )
				&& c := hb_bitShift( t, -10 )
			&& case i == 3
				&& s := hb_BSubstr( s, 2 )
				&& ch := hb_BSubstr( s, 1, 1 )
				&& c := hb_bitShift( asc( ch ), 2 )
				&& c := hb_bitShift( c, -2 )
				&& s := hb_BSubstr( s, 2 )
		&& endcase
		&& i := ( i + 1 ) % 4
// ? GetCharByCode( c )
		&& ret := ret + GetCharByCode( c )
	&& enddo
	
	&& return ret

&& function GetCharByCode( cByte )
	&& // Таблица соответствия
	&& local AnsiChar := { { " ", ".", "-", "'", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "А", "Б" }, ;
		&& { "В", "Г", "Д", "E", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р" }, ;
		&& { "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ь", "Ъ", "Ы", "Э", "Ю", "Я", "*" }, ;
		&& { "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "|" } }
	&& local i := 0, j := 0

	&& j := ( cByte % 16 )
	&& i := ( ( cByte - j ) / 16 )
&& ? 'cByte = ', cByte
&& ? 'i = ', i
&& ? 'j = ', j
	&& return AnsiChar[ i + 1, j + 1 ]

