#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TPatientAddDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD getDublicateSinglePolicyNumber()
		METHOD Save( param )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TPatientAddDB
	return self
	
METHOD getDublicateSinglePolicyNumber()		CLASS TPatientAddDB
	local ret := {}
	local listID := {}
	local cOldArea, cAlias
	local mis, i
	local j := 0
	local atmp, rec

	cOldArea := Select()
	if ::super:RUse()
		cAlias := Select()
		(cAlias)->( dbGoTop() )
		do while ! (cAlias)->( eof() )
			if ! empty( (cAlias)->KOD_MIS )
				mis := alltrim( (cAlias)->KOD_MIS )
				rec := (cAlias)->( recno() )
				if ( i := hb_ascan( listID, { | x | x[ 1 ] == mis } ) ) == 0
					atmp := {}
					aadd( atmp, rec )
					aadd( listID, { mis, atmp } )
				else
					atmp := listID[ i, 2 ]
					aadd( atmp, rec )
					listID[ i, 2 ] := atmp
				endif
			endif
			(cAlias)->(dbSkip())
		enddo
		(cAlias)->( dbCloseArea() )
		dbSelectArea( cOldArea )
		if len( listID ) > 0
			for i := 1 to len( listID )
				if len( listID[ i, 2 ] ) > 1
					j++
				endif
			next
		endif
	endif
	return ret
	
METHOD getByID ( nID )		 CLASS TPatientAddDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( param ) CLASS TPatientAddDB
	local ret := .f.
	local aHash := nil

	if upper( param:classname() ) == upper( 'TPatientAdd' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		hb_hSet( aHash, 'KOD_TF',	param:CodeTF )
		hb_hSet( aHash, 'KOD_MIS',	param:SinglePolicyNumber )
		hb_hSet( aHash, 'KOD_AK',	param:AmbulatoryCard )
		hb_hSet( aHash, 'TIP_PR',	param:AttachmentStatus )
		hb_hSet( aHash, 'MO_PR',	param:MOCodeAttachment )
		hb_hSet( aHash, 'DATE_PR',	param:DateAttachment )
		hb_hSet( aHash, 'SNILS_VR',	param:DoctorSNILS )
		hb_hSet( aHash, 'PC1',		param:PC1 )
		hb_hSet( aHash, 'PC2',		param:PC2 )
		hb_hSet( aHash, 'PC3',		param:PC3 )
		hb_hSet( aHash, 'PC4',		param:PC4 )
		hb_hSet( aHash, 'PC5',		param:PC5 )
		hb_hSet( aHash, 'PN1',		param:PN1 )
		hb_hSet( aHash, 'PN2',		param:PN2 )
		hb_hSet( aHash, 'PN3',		param:PN3 )
		
		hb_hSet(aHash, 'ID',			param:ID )
		hb_hSet(aHash, 'REC_NEW',		param:IsNew )
		hb_hSet(aHash, 'DELETED',		param:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			param:ID := ret
			param:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS TPatientAddDB
	local obj
	
	obj := TPatientAdd():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:CodeTF := hbArray[ 'KOD_TF' ] // код по кодировке ТФОМС
	obj:SinglePolicyNumber := hbArray[ 'KOD_MIS' ] // ЕНП - единый номер полиса ОМС
	obj:AmbulatoryCard := hbArray[ 'KOD_AK' ] // собственный номер амбулаторной карты (КМИС/ЛИС)
	obj:AttachmentStatus := hbArray[ 'TIP_PR' ] // тип/статус прикрепления 1-из WQ,2-из реестра СП и ТК,3-из файла прикрепления,4-открепление,5-сверка
	obj:MOCodeAttachment := hbArray[ 'MO_PR' ] // код МО прикрепления
	obj:DateAttachment := hbArray[ 'DATE_PR' ] // дата прикрепления
	obj:DoctorSNILS := hbArray[ 'SNILS_VR' ] // СНИЛС участкового врача
	obj:PC1 := hbArray[ 'PC1' ] // при добавлении:kod_polzovat+c4sys_date+hour_min(seconds())
	obj:PC2 := hbArray[ 'PC2' ] // 0-нет,1-умер по результатам сверки
	obj:PC3 := hbArray[ 'PC3' ] //
	obj:PC4 := hbArray[ 'PC4' ] // дата прикрепления к МО
	obj:PC5 := hbArray[ 'PC5' ] //
	obj:PN1 := hbArray[ 'PN1' ] //
	obj:PN2 := hbArray[ 'PN2' ] //
	obj:PN3 := hbArray[ 'PN3' ]  //
	return obj
