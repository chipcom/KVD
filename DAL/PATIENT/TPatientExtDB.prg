#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS TPatientExtDB	INHERIT	TBaseObjectDB

	HIDDEN:
		METHOD FillFromHash( hbArray )
	VISIBLE:
		METHOD New()
		METHOD Save( param )
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
	
	cOldArea := Select()
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
	
METHOD Save( param ) CLASS TPatientExtDB
	local ret := .f.
	local aHash := nil

	if upper( param:classname() ) == upper( 'TPatientExt' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'VPOLIS',		param:PolicyType )
		hb_hSet( aHash, 'SPOLIS',		param:PolicySeries )
		hb_hSet( aHash, 'NPOLIS',		param:PolicyNumber )
		hb_hSet( aHash, 'SMO',			param:SMO )
		hb_hSet( aHash, 'BEG_POLIS',	dtoc4( param:BeginPolicy ) )
		hb_hSet( aHash, 'STRANA',		param:Strana )
		hb_hSet( aHash, 'GOROD_SELO',	param:GorodSelo )
		hb_hSet( aHash, 'VID_UD',		param:DocumentType )
		hb_hSet( aHash, 'SER_UD',		param:DocumentSeries )
		hb_hSet( aHash, 'NOM_UD',		param:DocumentNumber )
		hb_hSet( aHash, 'KEMVYD',		param:IDIssue )
		hb_hSet( aHash, 'KOGDAVYD',		param:DateIssue )
		hb_hSet( aHash, 'KATEGOR',		param:Category )
		hb_hSet( aHash, 'KATEGOR2',		param:Category2 )
		hb_hSet( aHash, 'MESTO_R',		param:PlaceBorn )
		hb_hSet( aHash, 'OKATOG',		param:OKATOG )
		hb_hSet( aHash, 'OKATOP',		param:OKATOP )
		hb_hSet( aHash, 'ADRESP',		param:AddressStay )
		hb_hSet( aHash, 'DMS_SMO',		param:DMS_SMO )
		hb_hSet( aHash, 'DMS_POLIS',	param:DMSPolicy )
		hb_hSet( aHash, 'KVARTAL',		param:Kvartal )
		hb_hSet( aHash, 'KVARTAL_D',	param:KvartalHouse )
		hb_hSet( aHash, 'PHONE_H',		param:HomePhone )
		hb_hSet( aHash, 'PHONE_M',		param:MobilePhone )
		hb_hSet( aHash, 'PHONE_W',		param:WorkPhone )
		hb_hSet( aHash, 'KOD_LGOT',		param:CodeLgot )
		hb_hSet( aHash, 'IS_REGISTR',	if( param:IsRegistr, 1, 0 ) )
		hb_hSet( aHash, 'PENSIONER',	if( param:IsPensioner, 1, 0 ) )
		hb_hSet( aHash, 'INVALID',		param:Invalid )
		hb_hSet( aHash, 'INVALID_ST',	param:DegreeOfDisability )
		hb_hSet( aHash, 'BLOOD_G',		param:BloodType )
		hb_hSet( aHash, 'BLOOD_R',		param:RhesusFactor )
		hb_hSet( aHash, 'WEIGHT',		param:Weight )
		hb_hSet( aHash, 'HEIGHT',		param:Height )
		hb_hSet( aHash, 'WHERE_KART',	param:WhereCard )
		hb_hSet( aHash, 'GR_RISK',		param:GroupRisk )
		hb_hSet( aHash, 'DATE_FL',		dtoc4( param:DateLastXRay ) )
		hb_hSet( aHash, 'DATE_MR',		dtoc4( param:DateLastMunRecipe ) )
		hb_hSet( aHash, 'DATE_FR',		dtoc4( param:DateLastFedRecipe ) )

		hb_hSet(aHash, 'ID',			param:ID )
		hb_hSet(aHash, 'REC_NEW',		param:IsNew )
		hb_hSet(aHash, 'DELETED',		param:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			param:ID := ret
			param:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TPatientExtDB
	local obj := nil, oPassport := nil

	obj := TPatientExt():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ] ;
			)
	obj:PolicyType := hbArray[ 'VPOLIS' ]	// вид полиса (от 1 до 3);1-старый,2-врем.,3-новый;по умолчанию 1 - старый
	obj:PolicySeries := hbArray[ 'SPOLIS' ]			// серия полиса;;для наших - разделить по пробелу
	obj:PolicyNumber := hbArray[ 'NPOLIS' ]			// номер полиса;;"для иногородних - вынуть из ""k_inog"" и разделить"
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
	obj:DateLastXRay := c4tod( hbArray[ 'DATE_FL' ] )		// дата последней флюорогрфии;;если есть REGI_FL.DBF, то взять из него
	obj:DateLastMunRecipe := c4tod( hbArray[ 'DATE_MR' ] )		// дата последнего муниципального рецепта
	obj:DateLastFedRecipe := c4tod( hbArray[ 'DATE_FR' ] )		// дата последнего федерального рецепта
	return obj