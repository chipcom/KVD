#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatientExtDB	INHERIT	TBaseObjectDB

	HIDDEN:
		METHOD FillFromHash( hbArray )
	VISIBLE:
		METHOD New()
		METHOD Save( oExt )
		METHOD getByID ( nID )
		METHOD ReplaceKemVydan( param1, param2 )
ENDCLASS

METHOD New()		CLASS TPatientExtDB
	return self

METHOD function ReplaceKemVydan( param1, param2 )		 CLASS TPatientExtDB
	local cOldArea
	local cAlias
	local nInd1
	local nInd2
	local ret := .t.
	
	if isnumber( param1 ) .and. param1 != 0
		nInd1 := param1
	elseif isobject( param1 ) .and. param1:ClassName == upper( 'TPublisher' )
		nInd1 := param1:ID
	else
		return
	endif
	if isnumber( param2 ) .and. param2 != 0
		nInd2 := param2
	elseif isobject( param2 ) .and. param2:ClassName == upper( 'TPublisher' )
		nInd2 := param2:ID
	else
		return
	endif
	
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbClearIndex() )			// отключим индексные файлы
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if (cAlias)->KEMVYD == nInd1
				if (cAlias)->( dbRLock() )
					(cAlias)->KEMVYD := nInd2
					(cAlias)->( dbUnLock() )
				else
					ret := .f.
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCommit() )
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
	endif
	return ret

METHOD getByID ( nID )		 CLASS TPatientExtDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret
	
METHOD Save( oExt ) CLASS TPatientExtDB
	local ret := .f.
	local aHash := nil

	&& if upper( oExt:classname() ) == upper( 'TPatientExt' )
		&& aHash := hb_Hash()
		&& hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		&& hb_hSet( aHash, 'VPOLIS', oExt:VidPolicy )
		&& hb_hSet( aHash, 'SPOLIS', oExt:SeriyaPolicy )
		&& hb_hSet( aHash, 'NPOLIS', oExt:NumberPolicy )
		&& hb_hSet( aHash, 'SMO', oExt:SMO )
		&& hb_hSet( aHash, 'BEG_POLIS', dtoc4( oExt:BeginPolicy ) )
		&& hb_hSet( aHash, 'STRANA', oExt:Strana )
		&& hb_hSet( aHash, 'GOROD_SELO', oExt:GorodSelo )
		&& hb_hSet( aHash, 'VID_UD', oExt:DocumentType )
		&& hb_hSet( aHash, 'SER_UD', oExt:DocumentSeries )
		&& hb_hSet( aHash, 'NOM_UD', oExt:DocumentNumber )
		&& hb_hSet( aHash, 'KEMVYD', oExt:IDIssue )
		&& hb_hSet( aHash, 'KOGDAVYD', oExt:DateIssue )
		&& hb_hSet( aHash, 'KATEGOR', oExt:Category )
		&& hb_hSet( aHash, 'KATEGOR2', oExt:Category2 )
		&& hb_hSet( aHash, 'MESTO_R', oExt:PlaceBorn )
		&& hb_hSet( aHash, 'OKATOG', oExt:OKATOG )
		&& hb_hSet( aHash, 'OKATOP', oExt:OKATOP )
		&& hb_hSet( aHash, 'ADRESP', oExt:AddressStay )
		&& hb_hSet( aHash, 'DMS_SMO', oExt:DMS_SMO )
		&& hb_hSet( aHash, 'DMS_POLIS', oExt:DMSPolicy )
		&& hb_hSet( aHash, 'KVARTAL', oExt:Kvartal )
		&& hb_hSet( aHash, 'KVARTAL_D', oExt:KvartalHouse )
		&& hb_hSet( aHash, 'PHONE_H', oExt:HomePhone )
		&& hb_hSet( aHash, 'PHONE_M', oExt:MobilePhone )
		&& hb_hSet( aHash, 'PHONE_W', oExt:WorkPhone )
		&& hb_hSet( aHash, 'IS_REGISTR', if( oExt:IsRegistr, 1, 0 )
		&& hb_hSet( aHash, 'PENSIONER', if( oExt:IsPensioner, 1, 0 )
		&& hb_hSet( aHash, 'INVALID', oExt:Invalid )
		&& hb_hSet( aHash, 'INVALID_ST', oExt:DegreeOfDisability )
		&& hb_hSet( aHash, 'BLOOD_G', oExt:BloodType )
		&& hb_hSet( aHash, 'BLOOD_R', oExt:RhesusFactor )
		&& hb_hSet( aHash, 'WEIGHT', oExt:Weight )
		&& hb_hSet( aHash, 'HEIGHT', oExt:Height )
		&& hb_hSet( aHash, 'WHERE_KART', oExt:WhereCard )
		&& hb_hSet( aHash, 'GR_RISK', oExt:GroupRisk )
		&& hb_hSet( aHash, 'DATE_FL', oExt:DateLastXRay )
		&& hb_hSet( aHash, 'DATE_MR', oExt:DateLastMunRecipe )
		&& hb_hSet( aHash, 'DATE_FR', oExt:DateLastFedRecipe )
		&& if ( ret := ::super:Save( aHash ) ) != -1
			&& oExt:ID := ret
			&& oExt:IsNew := .f.
		&& endif
	&& endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TPatientExtDB
	local obj := nil, oPassport := nil

	obj := TPatientExt():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:VidPolicy := hbArray[ 'VPOLIS' ]	// вид полиса (от 1 до 3);1-старый,2-врем.,3-новый;по умолчанию 1 - старый
	obj:SeriyaPolicy := hbArray[ 'SPOLIS' ]			// серия полиса;;для наших - разделить по пробелу
	obj:NumberPolicy := hbArray[ 'NPOLIS' ]			// номер полиса;;"для иногородних - вынуть из ""k_inog"" и разделить"
	obj:SMO := hbArray[ 'SMO' ]			// реестровый номер СМО;;преобразовать из старых кодов в новые, иногродние = 34
	obj:BeginPolicy := c4tod( hbArray[ 'BEG_POLIS' ] )		// дата начала действия полиса ;в формате dtoc4();"поле ""beg_polis"" из файла ""k_inog"" для иногородних"
	obj:Strana := hbArray[ 'STRANA' ]			// гражданство пациента (страна);выбор из справочника стран;"поле ""strana"" из файла ""k_inog"" для иногородних, для остальных пусто = РФ"
	obj:GorodSelo := hbArray[ 'GOROD_SELO' ]		// житель?;1-город, 2-село, 3-рабочий поселок
	obj:DocumentType := hbArray[ 'VID_UD' ]	// вид удостоверения личности;по кодировке ФФОМС
	obj:DocumentSeries := hbArray[ 'SER_UD' ]	// серия удостоверения личности
	obj:DocumentNumber := hbArray[ 'NOM_UD' ]	// номер удостоверения личности
	obj:IDIssue := hbArray[ 'KEMVYD' ]	// кем выдан документ;"справочник ""s_kemvyd"""
	obj:DateIssue := hbArray[ 'KOGDAVYD' ]	// когда выдан документ
	obj:Category := hbArray[ 'KATEGOR' ]		// категория пациента
	obj:Category2 := hbArray[ 'KATEGOR2' ]	// категория пациента (собственная для МО)
	obj:PlaceBorn := hbArray[ 'MESTO_R' ]	// место рождения
	obj:OKATOG := hbArray[ 'OKATOG' ]	// код места жительства по ОКАТО;выбор из справочника ОКАТО;попытаться сформировать для нашей области по коду района
	obj:OKATOP := hbArray[ 'OKATOP' ]	// код места пребывания по ОКАТО
	obj:AddressStay := hbArray[ 'ADRESP' ]	// адрес места пребывания;сюда будем заносить остаток адреса места пребывания;
	obj:DMS_SMO :=  hbArray[ 'DMS_SMO' ]	// код СМО ДМС;;
	obj:DMSPolicy := hbArray[ 'DMS_POLIS' ]		// код полиса ДМС;;
	obj:Kvartal := hbArray[ 'KVARTAL' ]		// квартал для Волжского
	obj:KvartalHouse := hbArray[ 'KVARTAL_D' ]		// дом в квартале Волжского
	obj:HomePhone := hbArray[ 'PHONE_H' ]		// телефон домашний
	obj:MobilePhone := hbArray[ 'PHONE_M' ]		// телефон мобильный;;
	obj:WorkPhone := hbArray[ 'PHONE_W' ]		// телефон рабочий;;
	obj:CodeLgot := hbArray[ 'KOD_LGOT' ]		// код льготы по ДЛО;;
	obj:IsRegistr := if( hbArray[ 'IS_REGISTR' ] == 0, .f., .t. )		// есть ли в регистре ДЛО;0-нет, 1-есть
	obj:IsPensioner := if( hbArray[ 'PENSIONER' ] == 0, .f., .t. )		// является пенсионером?;0-нет, 1-да
	obj:Invalid := hbArray[ 'INVALID' ]		// инвалидность;0-нет,1,2,3-степень, 4-инвалид детства
	obj:DegreeOfDisability := hbArray[ 'INVALID_ST' ]	// степень инвалидности;1 или 2
	obj:BloodType := hbArray[ 'BLOOD_G' ]		// группа крови;от 1 до 4
	obj:RhesusFactor := hbArray[ 'BLOOD_R' ]		// резус-фактор;"+" или "-"
	obj:Weight := hbArray[ 'WEIGHT' ]			// вес в кг
	obj:Height := hbArray[ 'HEIGHT' ]			// рост в см
	obj:WhereCard := hbArray[ 'WHERE_KART' ]		// где амбулаторная карта;0-в регистратуре, 1-у врача, 2-на руках
	obj:GroupRisk := hbArray[ 'GR_RISK' ]		// группа риска по стандарту горздрава;;если есть REGI_FL.DBF, то взять из него
	obj:DateLastXRay := hbArray[ 'DATE_FL' ]		// дата последней флюорогрфии;;если есть REGI_FL.DBF, то взять из него
	obj:DateLastMunRecipe := hbArray[ 'DATE_MR' ]		// дата последнего муниципального рецепта
	obj:DateLastFedRecipe := hbArray[ 'DATE_FR' ]		// дата последнего федерального рецепта
	return obj