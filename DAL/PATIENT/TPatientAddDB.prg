#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS TPatientAddDB	INHERIT	TBaseObjectDB
	VISIBLE:
		METHOD New()
		METHOD getByID ( nID )
		METHOD Save( oAdd )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS TPatientAddDB
	return self
	
METHOD getByID ( nID )		 CLASS TPatientAddDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( oAdd ) CLASS TPatientAddDB
	local ret := .f.
	local aHash := nil

	&& if upper( oAdd:classname() ) == upper( 'TPatientAdd' )
		&& aHash := hb_Hash()
		&& hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )
		&& hb_hSet( aHash, 'KOD_TF', oAdd:CodeTF )
		&& hb_hSet( aHash, 'KOD_MIS', oAdd:SinglePolicyNumber )
		&& hb_hSet( aHash, 'KOD_AK', oAdd:AmbulatoryCard )
		&& hb_hSet( aHash, 'TIP_PR', oAdd:AttachmentStatus )
		&& hb_hSet( aHash, 'MO_PR', oAdd:MOCodeAttachment )
		&& hb_hSet( aHash, 'DATE_PR', oAdd:DateAttachment )
		&& hb_hSet( aHash, 'SNILS_VR', oAdd:DoctorSNILS )
		&& hb_hSet( aHash, 'PC1', oAdd:PC1 )
		&& hb_hSet( aHash, 'PC2', oAdd:PC2 )
		&& hb_hSet( aHash, 'PC3', oAdd:PC3 )
		&& hb_hSet( aHash, 'PC4', oAdd:PC4 )
		&& hb_hSet( aHash, 'PC5', oAdd:PC5 )
		&& hb_hSet( aHash, 'PN1', oAdd:PN1 )
		&& hb_hSet( aHash, 'PN2', oAdd:PN2 )
		&& hb_hSet( aHash, 'PN3', oAdd:PN3 )
		&& if ( ret := ::super:Save( aHash ) ) != -1
			&& oAdd:ID := ret
			&& oAdd:IsNew := .f.
		&& endif
	&& endif
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
