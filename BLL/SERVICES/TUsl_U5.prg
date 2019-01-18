#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'property.ch'

********************************
// класс для справочник группы услуг для способа оплаты = 5 файл u_usl_5.dbf
CREATE CLASS TUsl_U5	INHERIT	TBaseObjectBLL
	VISIBLE:
		PROPERTY Type READ getType WRITE setType				//  1-врач(ОМС), 2-асс.(ОМС), 3-врач(пл.), 4-асс.(пл.), 5-м/с(пл.), 6-сан.(пл.)
		PROPERTY Razryad READ getRazryad WRITE setRazryad	//  разряд (м.б. = 0)
		PROPERTY Otdal READ getOtdal WRITE setOtdal			//  признак отдаленности (м.б. = 1)
		PROPERTY Percent READ getPercent WRITE setPercent	//  процент оплаты
		PROPERTY Percent2 READ getPercent2 WRITE setPercent2 //  процент для оплаты без медсестры (м.б. = 0)
		PROPERTY Trans1 READ getTrans1 WRITE setTrans1		//  преобразованный шифр начальной услуги
		PROPERTY Trans1_1251 READ getTrans1_1251
		PROPERTY Trans2 READ getTrans2 WRITE setTrans2       //  преобразованный шифр конечной услуги
		PROPERTY Trans2_1251 READ getTrans2_1251
		PROPERTY Service1 READ getService1 WRITE setService1	//  шифр начальной услуги
		PROPERTY Service1_1251 READ getService1_1251
		PROPERTY Service2 READ getService2 WRITE setService2 //  шифр конечной услуги
		PROPERTY Service2_1251 READ getService2_1251

		PROPERTY Razryad_F READ getRazryadFormat
		PROPERTY Otdal_F READ getOtdalFormat
		PROPERTY Percent_F READ getPercentFormat
		
		METHOD New( nID, lNew, lDeleted )
		METHOD Clone()
	HIDDEN:
		DATA FType		INIT 0
		DATA FService1	INIT space( 10 )
		DATA FService2	INIT space( 10 )
		DATA FTrans1	INIT space( 20 )
		DATA FTrans2	INIT space( 20 )
		DATA FOtdal		INIT .f.
		DATA FRazryad	INIT 0
		DATA FPercent	INIT 0
		DATA FPercent2	INIT 0
		
		METHOD getType
		METHOD setType( nVal )
		METHOD getService1
		METHOD getService1_1251
		METHOD setService1( cVal )
		METHOD getService2
		METHOD getService2_1251
		METHOD setService2( cVal )
		METHOD getTrans1
		METHOD getTrans1_1251
		METHOD setTrans1( cVal )
		METHOD getTrans2
		METHOD getTrans2_1251
		METHOD setTrans2( cVal )
		METHOD getRazryad
		METHOD setRazryad( nVal )
		METHOD getOtdal
		METHOD setOtdal( lVal )
		METHOD getPercent
		METHOD setPercent( nVal )
		METHOD getPercent2
		METHOD setPercent2( nVal )

		METHOD getRazryadFormat
		METHOD getOtdalFormat
		METHOD getPercentFormat

ENDCLASS

METHOD FUNCTION getPercentFormat() CLASS TUsl_U5
	local ret := ft_opl_51( ::FPercent, ::FPercent2, 10 )
	
	return ret

METHOD FUNCTION getOtdalFormat() CLASS TUsl_U5
	local ret := padc( iif( ::FOtdal, '√',''), 9 )
	
	return ret

METHOD FUNCTION getRazryadFormat() CLASS TUsl_U5
	local ret := put_val( ::FRazryad, 2 )
	
	return ret

METHOD FUNCTION getType() CLASS TUsl_U5
	return ::FType
	
METHOD PROCEDURE setType( nVal ) CLASS TUsl_U5
	::FType := nVal
	return

METHOD FUNCTION getService1() CLASS TUsl_U5
	return ::FService1
	
METHOD FUNCTION getService1_1251() CLASS TUsl_U5
	return win_OEMToANSI( ::FService1 )
	
METHOD PROCEDURE setService1( cVal ) CLASS TUsl_U5
	::FService1 := cVal
	return

METHOD FUNCTION getService2() CLASS TUsl_U5
	return ::FService2
	
METHOD FUNCTION getService2_1251() CLASS TUsl_U5
	return win_OEMToANSI( ::FService2 )
	
METHOD PROCEDURE setService2( cVal ) CLASS TUsl_U5
	::FService2 := cVal
	return

METHOD FUNCTION getTrans1() CLASS TUsl_U5
	return ::FTrans1
	
METHOD FUNCTION getTrans1_1251() CLASS TUsl_U5
	return win_OEMToANSI( ::FTrans1 )
	
METHOD PROCEDURE setTrans1( cVal ) CLASS TUsl_U5
	::FTrans1 := cVal
	return

METHOD FUNCTION getTrans2() CLASS TUsl_U5
	return ::FTrans2
	
METHOD FUNCTION getTrans2_1251() CLASS TUsl_U5
	return win_OEMToANSI( ::FTrans2 )
	
METHOD PROCEDURE setTrans2( cVal ) CLASS TUsl_U5
	::FTrans2 := cVal
	return

METHOD FUNCTION getRazryad() CLASS TUsl_U5
	return ::FRazryad
	
METHOD PROCEDURE setRazryad( nVal ) CLASS TUsl_U5
	::FRazryad := nVal
	return

METHOD FUNCTION getOtdal() CLASS TUsl_U5
	return ::FOtdal
	
METHOD PROCEDURE setOtdal( lVal ) CLASS TUsl_U5
	::FOtdal := lVal
	return

METHOD FUNCTION getPercent() CLASS TUsl_U5
	return ::FPercent
	
METHOD PROCEDURE setPercent( nVal ) CLASS TUsl_U5
	::FPercent := nVal
	return

METHOD FUNCTION getPercent2() CLASS TUsl_U5
	return ::FPercent2
	
METHOD PROCEDURE setPercent2( nVal ) CLASS TUsl_U5
	::FPercent2 := nVal
	return

METHOD Clone()		 CLASS TUsl_U5
	local oTarget := nil
	
	oTarget := ::Super:Clone()
	oTarget:Code( 0 )
	return oTarget

METHOD New( nID, lNew, lDeleted )  CLASS TUsl_U5

	::super:new( nID, lNew, lDeleted )
	return self