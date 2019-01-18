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
	local cTest := space(270)
	

	REQUEST HB_CODEPAGE_RU866
	HB_CDPSELECT( 'RU866' )
	REQUEST HB_LANG_RU866
	HB_LANGSELECT( 'RU866' )

	@ 2, 20 say 'Введите код' get cTest
	read
   
   ?substr( cTest, 1, 3 )
   inkey(0)
   
   && test1 := TBARCODE_OMS():New( barcode_data_V1 )
   test1 := TBARCODE_OMS():New( cTest )
   ?test1:classname
   ??': '
   ??test1:BarcodeType
   ?'Имя: '
   ??test1:FirstName
   ?'Отчество: '
   ??test1:MiddleName
   ?'Фамилия: '
   ??test1:LastName
   ?'Пол::'
   ??test1:Gender
   ?'Дата рождения: '
   ??test1:DOB
   ?'Дата окончания: '
   ??test1:ExpireDate
   ?'ОКАТО: '
   ??test1:OKATO
   ?'ОГРН: '
   ??test1:OGRN
   ?
   test2 := TBARCODE_OMS():New( barcode_data_V2 )
   ?test2:classname
   ??': '
   ??test2:BarcodeType
   ?'Имя: '
   ??test2:FirstName
   ?'Отчество: '
   ??test2:MiddleName
   ?'Фамилия: '
   ??test2:LastName
   ?'Пол::'
   ??test2:Gender
   ?'Дата рождения: '
   ??test2:DOB
   ?'Дата окончания: '
   ??test2:ExpireDate
   ?'ОКАТО: '
   ??test2:OKATO
   ?'ОГРН: '
   ??test2:OGRN
   ?
	
	?'Нажмите любую клавишу...'
	inkey(0)
	return