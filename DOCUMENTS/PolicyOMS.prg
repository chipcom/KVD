#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

* 25.12.18 ввод данных полиса ОМС
&& function inputPolicyOMS( oPolicyOMS, oPatient, /*@*/sPolicyOMS )
function inputPolicyOMS( oPolicyOMS, oPatient )
	local tmp_keys, tmp_gets, buf
	local iRow
	local oBox
	local series := space( 10 )
	local number := space( 20 )
	local dateIssue := ctod( '' )
	local dateEnd := ctod( '' )
	local arrError, flagError := .f.
	local sPicture
	local sPictureSeries
	local picture_number := "@R 9999 9999 9999 9999"
	
	if lastkey() != K_ENTER
		return nil
	endif
	private ;
		mvidpolis := '', ; // вид полиса
		m1vidpolis := 1, ;	// по умолчанию старый полис
		mnamesmo, m1namesmo, msmo := space( 5 ), ;
		mokato, m1okato := '', mismo, m1ismo := '', mnameismo := space( 100 )

	if empty( oPolicyOMS:PolicyNumber )
		mvidpolis := inieditspr( A__MENUVERT, TPolicyOMS():aMenuType, m1vidpolis )		// вид полиса
	else
		m1vidpolis := oPolicyOMS:PolicyType
		mvidpolis := inieditspr( A__MENUVERT, TPolicyOMS():aMenuType, m1vidpolis )		// вид полиса
		series := oPolicyOMS:PolicySeries
		&& if m1vidpolis == 3
			&& number := transform( oPolicyOMS:PolicyNumber, picture_number )
		&& else
			number := oPolicyOMS:PolicyNumber
		&& endif
		dateIssue := oPolicyOMS:BeginPolicy
		dateEnd := oPolicyOMS:PolicyPeriod

		m1okato := oPolicyOMS:OKATOInogSMO
		mokato := inieditspr( A__MENUVERT, glob_array_srf(), m1okato )
		
		msmo        := oPolicyOMS:SMO    // реестровый номер СМО
		if alltrim( msmo ) == '34'
			mnameismo := ret_inogSMO_name_bay(  oPatient, oPolicyOMS )
		elseif left( msmo, 2 ) == '34'
			// Волгоградская область
		elseif !empty( msmo )
			m1ismo := msmo
			msmo := '34'
		endif
		
		mismo := T_mo_smoDB():getBySMO( m1ismo )

		if empty( m1namesmo := int( val( msmo ) ) )
			m1namesmo := glob_arr_smo[ 1, 2 ] // по умолчанию = КапиталЪ Медстрах
		endif
		mnamesmo := inieditspr( A__MENUVERT, glob_arr_smo, m1namesmo )
		if m1namesmo == 34
			if !empty( mismo )
				mnamesmo := padr( mismo, 41 )
			elseif !empty( mnameismo )
				mnamesmo := padr( mnameismo, 41 )
			endif
		endif

	endif

	buf := savescreen()
	change_attr()
	iRow := 10
	tmp_keys := my_savekey()
	save gets to tmp_gets
	
	oBox := TBox():New( iRow, 10, iRow + 5, 70, .t. )
	oBox:CaptionColor := 'B/B*'
	oBox:Color := cDataCGet
	oBox:MessageLine := '^<Esc>^ - выход;  ^<PgDn>^ - подтверждение ввода'
	oBox:Caption := 'Редактирование данных полиса ОМС'
	oBox:View()
	
	sPicture :=  if( eq_any( m1vidpolis, 3 ), picture_number, if( eq_any( m1vidpolis, 3 ), ;
				'@R 9999999999999999999', '@R 999999999' ) )
	do while .t.
		iRow := 10
		@ ++iRow, 12 say 'Вид полиса:' get mvidpolis ;
					reader { | x | menu_reader( x, TPolicyOMS():aMenuType, A__MENUVERT, , , .f. ) } ;
					valid { | oGet | ( ;
					setPolicyOMS( oGet, oPolicyOMS, m1vidpolis ), ;
					sPicture :=  if( eq_any( m1vidpolis, 3 ), picture_number, if( eq_any( m1vidpolis, 3 ), ;
							'@R 9999999999999999999', '@R 999999999' ) ), ;
					update_gets() ) }
					&& sPicture :=  if( eq_any( m1vidpolis, 3 ), picture_number, '@S20' ), ;
					&& number := transform( oPolicyOMS:PolicyNumber, if( eq_any( m1vidpolis, 3 ), picture_number, '@S20' ) ), ;

		@ ++iRow, 12 say 'Серия:' get series when if( m1vidpolis != 1, .f., .t. )
		@ iRow, col() + 1 say 'Номер:' get number ;
					valid { | oGet | roCheckPolicyOMS( oGet, m1vidpolis, oPatient, oPolicyOMS ) } ;
					picture sPicture
					&& picture if( eq_any( m1vidpolis, 3 ), picture_number, '@S20' )
	
		@ ++iRow, 12 say 'Действует с:' get dateIssue
		@ iRow, col() + 1 say 'по:' get dateEnd
		
		@ ++iRow, 12 say 'СМО' get mnamesmo ;
					reader { | x | menu_reader( x, glob_arr_smo, A__MENUVERT, , , .f. ) } ;
					valid { | oGet | func_valid_ismo_bay( oGet, 0, 41, 'namesmo' ) }
					
		myread()
		if lastkey() != K_ESC
		
			validNumberPolicyOMS( oPolicyOMS, between( m1namesmo, 34001, 34007 ) )
				
			oPolicyOMS:PolicyType := m1vidpolis
			oPolicyOMS:PolicySeries := series
			oPolicyOMS:PolicyNumber := alltrim( charrem( ' ', number ) )
			oPolicyOMS:BeginPolicy := dateIssue
			oPolicyOMS:PolicyPeriod := dateEnd
			oPolicyOMS:SMO := lstr( m1namesmo )
			if m1namesmo == 34
				oPolicyOMS:OKATOInogSMO := m1okato		// ОКАТО субъекта РФ территории страхования
				if ! empty( m1ismo )
					if ! empty( mismo )
						oPolicyOMS:IsInogSMO := .t.
						oPolicyOMS:NameInogSMO := mismo
					endif
				else
					oPolicyOMS:SMO := m1ismo  // заменяем "34" на код иногородней СМО
				endif
			endif
			exit
		else
			exit
		endif
	enddo
	if ! isnil( mPolicyOMS ) .and. ! empty( oPolicyOMS:PolicyNumber )
		mPolicyOMS := padr( oPolicyOMS:AsString, 65 )
	endif
	update_gets()
	
	oBox := nil
	restscreen( buf )
	restore gets from tmp_gets
	my_restkey( tmp_keys )
	return nil

* 26.11.18
function func_valid_ismo_bay( oGet, lkomu, sh, name_var )
	local r1, r2, n := 4, buf, tmp_keys, tmp_list, tmp_color
	local oBox

	DEFAULT name_var TO 'company'
	private mvar := 'm1' + name_var
	if lkomu == 0 .and. &mvar == 34
		if oGet:row() > 18
			r2 := oGet:row() - 1
			r1 := r2 - n
		else
			r1 := oGet:row() + 1
			r2 := r1 + n
		endif
		tmp_keys := my_savekey()
		save gets to tmp_list
		private mm_ismo := {}
		
		oBox := TBox():New( r1, 2, r2, 77, .t. )
		oBox:Caption := 'Ввод иногородней СМО'
		oBox:CaptionColor := 'GR/W'
		oBox:Color := 'N/W,W+/N,,,B/W'
		oBox:View()
		
		@ r1 + 1, 4 say 'Субъект РФ' get mokato ;
					reader { | x | menu_reader( x, ;
					{ { | k, r, c | get_srf( k, r, c ) }, 62 }, A__FUNCTION, , , .f. ) } ;
					valid { | g, o | when_ismo( g, o ) }
		@ r1 + 2,4 say 'СМО' get mismo ;
					reader { | x | menu_reader( x, mm_ismo, A__MENUVERT, , , .f. ) } ;
					when { | | len( mm_ismo ) > 0 .and. empty( mnameismo ) } ;
					valid { | | iif( empty( mismo ), , mnameismo := space( 100 ) ), .t. }
		@ r1 + 3,4 say 'Наименование СМО' get mnameismo pict '@S56' ;
					when empty( m1ismo )
		myread()
		restore gets from tmp_list
		my_restkey( tmp_keys )
		if ! emptyall( mismo, mnameismo )
			mvar := 'm' + name_var
			&mvar := padr( iif( emptyall( mismo ), mnameismo, mismo ), sh )
		endif
	endif
	return .t.
/*
* 29.11.18 
function when_ismo( get, old )
	local aObjects, item
	local s
	
	if !( m1okato == old ) .and. old != nil
		m1ismo := ''
		mismo := space( len( mismo ) )
	endif
	mm_ismo := {}
	if !empty( m1okato )
		mm_ismo := T_mo_smoDB():getListByOKATO( m1okato )
	endif
	return len( mm_ismo ) > 0
*/

* 17.12.18 вернуть иногороднюю СМО
function ret_inogSMO_name_bay(  oPatient, oPolicyOMS )
	local s := space( 100 )
	local oSmo
	
	if ! oPatient:IsNew
		if oPolicyOMS:Owner:classname == upper( 'TPatient' )
			oSmo := TMo_kismoDB():getByPatient( oPatient )
		elseif oPolicyOMS:Owner:classname == upper( 'THuman' )
			oSmo := TMo_hismoDB():getByHuman( oPatient )
		else
			return s
		endif
		if ! isnil( oSmo )
			s := oSmo:Name
		endif
	endif
	return s

* 26.11.18 действия в ответ на выбор в меню "Принадлежность счёта"
function f_valid_komu_bay( oGet, old )
	local list, item

	if m1komu != old .and. old != nil
		m1company := 0
		mcompany := space( 30 )
		mm_company := {}
		if m1komu == 0 // ОМС
			mm_company := aclone( glob_arr_smo )
		elseif m1komu == 1 // Прочие компании
			for each item in TInsuranceCompanyDB():getList()
				if !between( item:TFOMS, 44, 47 )
					aadd( mm_company, { alltrim( item:Name ), item:ID } )
				endif
			next
		elseif m1komu == 3 // Комитеты/МО
			for each item in TCommitteeDB():getList()
				aadd( mm_company, { alltrim( item:Name ), item:ID } )
			next
		endif
		if eq_any( m1komu, 1, 3 ) .and. empty( mm_company )
			mm_company := { { 'Пустой справочник', 0 } }
		endif
		update_get( 'mcompany' )
	endif
	return .t.

* 26.12.18 проверка номера полиса ОМС
function roCheckPolicyOMS( oGet, m1vidpolis, oPatient, oPolicyOMS )
	local ret := .t., mkod

	oPolicyOMS:PolicyType := m1vidpolis
	oPolicyOMS:PolicyNumber := alltrim( charrem( ' ', oGet:Buffer ) )
	validNumberPolicyOMS( oPolicyOMS )

	if ( findKartoteka_bay( oPatient, 2, @mkod, oPolicyOMS ) )
		update_gets()
	endif
	return ret

* 15.12.18
function setPolicyOMS( oGet, oPolicyOMS, vidpolis )

	if vidpolis != 1
		oPolicyOMS:PolicySeries := space( 10 )
	endif
	return .t.

* 26.12.18
function validNumberPolicyOMS( oPolicyOMS, is_volgograd )
	local a_err := {}
	local CountDigit := 0, s := ''

	if empty( oPolicyOMS:PolicyType )
		aadd( a_err, 'не заполнено поле "Вид полиса"' )
	endif
	if empty( oPolicyOMS:PolicyNumber )
		aadd( a_err, 'не заполнен номер полиса' )
	endif
	if oPolicyOMS:PolicyType == 1
		DEFAULT is_volgograd TO .f.
		if is_volgograd // ТОЛЬКО ДЛЯ ВОЛГОГРАДСКОЙ ОБЛАСТИ
			s := alltrim( oPolicyOMS:PolicySeries ) + alltrim( oPolicyOMS:PolicyNumber )
			CountDigit := len( s )
			s := charrem( ' ', CHARREPL( '0123456789', s, space( 10 ) ) )
			if !empty( s )
				aadd( a_err, 'недопустимые символы в (старом) Волгоградском полисе "' + s + '"' )
			elseif CountDigit != 16
				aadd( a_err, 'в (старом) Волгоградском полисе должно быть 16 цифр' )
			endif
		endif
	else
		if ! empty( oPolicyOMS:PolicySeries )
			aadd( a_err, 'для данного вида СЕРИЯ ПОЛИСА не заполняется' )
		endif
		oPolicyOMS:PolicyNumber := alltrim( oPolicyOMS:PolicyNumber )
		s := charrem( ' ', CHARREPL( '0123456789', oPolicyOMS:PolicyNumber, space( 10 ) ) )
		CountDigit := len( alltrim( oPolicyOMS:PolicyNumber ) )
		if !empty( s )
			aadd( a_err, '"' + s + '" недопустимые символы в НОМЕРЕ ПОЛИСА' )
		elseif oPolicyOMS:PolicyType == 2
			if CountDigit != 9
				aadd( a_err, oPolicyOMS:PolicyNumber + ' - в НОМЕРЕ временного ПОЛИСА должно быть 9 цифр' )
			endif
		elseif oPolicyOMS:PolicyType == 3
			if CountDigit == 16
				if ! checksumPolisOMS( oPolicyOMS:PolicyNumber )
					aadd( a_err, oPolicyOMS:PolicyNumber + ' - неверная контрольная сумма в ПОЛИСЕ единого образца' )
				endif
			else
				aadd( a_err, oPolicyOMS:PolicyNumber + ' - в НОМЕРЕ ПОЛИСА должно быть 16 цифр' )
			endif
		endif
	endif
	if !empty( a_err )
		n_message( a_err, , 'GR+/R', 'W+/R', , , 'G+/R' )
	endif
	return .t.

***** 26.12.18 проверить контрольную сумму в ПОЛИСЕ единого образца
function checksumPolisOMS( cNumber )
	local i, n, s := ''
	// а) Выбираются цифры, стоящие в нечётных позициях, по порядку,
	//    начиная справа, записываются в виде числа.

	cNumber := alltrim( cNumber )
	for i := 15 to 1 step -2
		s += substr( cNumber, i, 1 )
	next
	// Полученное число умножается на 2.
	n := int( val( s ) * 2 )
	// б) Выбираются цифры, стоящие в чётных позициях, по порядку,
	//    начиная справа, записываются в виде числа.
	s := ''
	for i := 14 to 1 step -2
		s += substr( cNumber, i, 1 )
	next
	// Полученное число приписывается слева от числа, полученного в пункте а).
	s += lstr( n )
	// в) Складываются все цифры полученного в пункте б) числа.
	n := 0
	for i := 1 to len( s )
		n += int( val( substr( s, i, 1 ) ) )
	next
	// г) Полученное в пункте в) число вычитается из ближайшего большего
	//    или равного числа, кратного 10.
	n := int( val( right( lstr( n ), 1 ) ) )
	i := 0
	if n > 0
		i := 10 - n
	endif
	// В результате получается искомая контрольная цифра.
	return lstr( i ) == right( cNumber, 1 )