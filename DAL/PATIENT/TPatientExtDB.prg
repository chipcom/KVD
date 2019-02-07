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
		(cAlias)->( dbClearIndex() )			// �⪫�稬 ������� 䠩��
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
	obj:PolicyType := hbArray[ 'VPOLIS' ]	// ��� ����� (�� 1 �� 3);1-����,2-�६.,3-����;�� 㬮�砭�� 1 - ����
	obj:PolicySeries := hbArray[ 'SPOLIS' ]			// ��� �����;;��� ���� - ࠧ������ �� �஡���
	obj:PolicyNumber := hbArray[ 'NPOLIS' ]			// ����� �����;;"��� �����த��� - ����� �� ""k_inog"" � ࠧ������"
	obj:SMO := hbArray[ 'SMO' ]			// ॥��஢� ����� ���;;�८�ࠧ����� �� ����� ����� � ����, ����த��� = 34
	obj:BeginPolicy := c4tod( hbArray[ 'BEG_POLIS' ] )		// ��� ��砫� ����⢨� ����� ;� �ଠ� dtoc4();"���� ""beg_polis"" �� 䠩�� ""k_inog"" ��� �����த���"
	obj:Strana := hbArray[ 'STRANA' ]			// �ࠦ����⢮ ��樥�� (��࠭�);�롮� �� �ࠢ�筨�� ��࠭;"���� ""strana"" �� 䠩�� ""k_inog"" ��� �����த���, ��� ��⠫��� ���� = ��"
	obj:GorodSelo := hbArray[ 'GOROD_SELO' ]		// ��⥫�?;1-��த, 2-ᥫ�, 3-ࠡ�稩 ��ᥫ��
	obj:DocumentType := hbArray[ 'VID_UD' ]	// ��� 㤮�⮢�७�� ��筮��;�� ����஢�� �����
	obj:DocumentSeries := hbArray[ 'SER_UD' ]	// ��� 㤮�⮢�७�� ��筮��
	obj:DocumentNumber := hbArray[ 'NOM_UD' ]	// ����� 㤮�⮢�७�� ��筮��
	obj:IDIssue := hbArray[ 'KEMVYD' ]	// ��� �뤠� ���㬥��;"�ࠢ�筨� ""s_kemvyd"""
	obj:DateIssue := hbArray[ 'KOGDAVYD' ]	// ����� �뤠� ���㬥��
	obj:Category := hbArray[ 'KATEGOR' ]		// ��⥣��� ��樥��
	obj:Category2 := hbArray[ 'KATEGOR2' ]	// ��⥣��� ��樥�� (ᮡ�⢥���� ��� ��)
	obj:PlaceBorn := hbArray[ 'MESTO_R' ]	// ���� ஦�����
	obj:OKATOG := hbArray[ 'OKATOG' ]	// ��� ���� ��⥫��⢠ �� �����;�롮� �� �ࠢ�筨�� �����;��������� ��ନ஢��� ��� ��襩 ������ �� ���� ࠩ���
	obj:OKATOP := hbArray[ 'OKATOP' ]	// ��� ���� �ॡ뢠��� �� �����
	obj:AddressStay := hbArray[ 'ADRESP' ]	// ���� ���� �ॡ뢠���;� �㤥� ������� ���⮪ ���� ���� �ॡ뢠���;
	obj:DMS_SMO :=  hbArray[ 'DMS_SMO' ]	// ��� ��� ���;;
	obj:DMSPolicy := hbArray[ 'DMS_POLIS' ]		// ��� ����� ���;;
	obj:Kvartal := hbArray[ 'KVARTAL' ]		// ����⠫ ��� ����᪮��
	obj:KvartalHouse := hbArray[ 'KVARTAL_D' ]		// ��� � ����⠫� ����᪮��
	obj:HomePhone := hbArray[ 'PHONE_H' ]		// ⥫�䮭 ����譨�
	obj:MobilePhone := hbArray[ 'PHONE_M' ]		// ⥫�䮭 �������;;
	obj:WorkPhone := hbArray[ 'PHONE_W' ]		// ⥫�䮭 ࠡ�稩;;
	obj:CodeLgot := hbArray[ 'KOD_LGOT' ]		// ��� �죮�� �� ���;;
	obj:IsRegistr := if( hbArray[ 'IS_REGISTR' ] == 0, .f., .t. )		// ���� �� � ॣ���� ���;0-���, 1-����
	obj:IsPensioner := if( hbArray[ 'PENSIONER' ] == 0, .f., .t. )		// ���� ���ᨮ��஬?;0-���, 1-��
	obj:Invalid := hbArray[ 'INVALID' ]		// ������������;0-���,1,2,3-�⥯���, 4-������� ����⢠
	obj:DegreeOfDisability := hbArray[ 'INVALID_ST' ]	// �⥯��� �����������;1 ��� 2
	obj:BloodType := hbArray[ 'BLOOD_G' ]		// ��㯯� �஢�;�� 1 �� 4
	obj:RhesusFactor := hbArray[ 'BLOOD_R' ]		// १��-䠪��;"+" ��� "-"
	obj:Weight := hbArray[ 'WEIGHT' ]			// ��� � ��
	obj:Height := hbArray[ 'HEIGHT' ]			// ��� � �
	obj:WhereCard := hbArray[ 'WHERE_KART' ]		// ��� ���㫠�ୠ� ����;0-� ॣ�������, 1-� ���, 2-�� �㪠�
	obj:GroupRisk := hbArray[ 'GR_RISK' ]		// ��㯯� �᪠ �� �⠭����� ��৤ࠢ�;;�᫨ ���� REGI_FL.DBF, � ����� �� ����
	obj:DateLastXRay := c4tod( hbArray[ 'DATE_FL' ] )		// ��� ��᫥���� ��ண�䨨;;�᫨ ���� REGI_FL.DBF, � ����� �� ����
	obj:DateLastMunRecipe := c4tod( hbArray[ 'DATE_MR' ] )		// ��� ��᫥����� �㭨樯��쭮�� �楯�
	obj:DateLastFedRecipe := c4tod( hbArray[ 'DATE_FR' ] )		// ��� ��᫥����� 䥤�ࠫ쭮�� �楯�
	return obj