#include 'hbclass.ch'
#include 'hbhash.ch'
#include 'common.ch'
#include 'property.ch'

CREATE CLASS THumanAddDB	INHERIT	TBaseObjectDB

	VISIBLE:
		METHOD New()
		METHOD Save( param )
		METHOD getByID ( nID )
	HIDDEN:
		METHOD FillFromHash( hbArray )
ENDCLASS

METHOD New()		CLASS THumanAddDB
	return self

METHOD function getByID ( nID )		 CLASS THumanAddDB
	local hArray := nil
	local ret := nil
	
	if ( nID != 0 ) .and. !empty( hArray := ::super:GetById( nId ) )
		ret := ::FillFromHash( hArray )
	endif
	return ret

METHOD Save( param ) CLASS THumanAddDB
	local ret := .f.
	local aHash := nil

	// разобраться как лучше
	if isobject( param ) .and. ( upper( param:classname() ) == upper( 'THuman' ) )
		param := param:AddInfo
	endif
// доработать	
	if upper( param:classname() ) == upper( 'THumanAdd' )
		aHash := hb_Hash()
		hb_HAutoAdd( aHash, HB_HAUTOADD_ALWAYS )

		hb_hSet(aHash, 'OSL1',		param:DiagnosisComplication1 )
		hb_hSet(aHash, 'OSL2',		param:DiagnosisComplication2 )
		hb_hSet(aHash, 'OSL3',		param:DiagnosisComplication3 )
		hb_hSet(aHash, 'NPR_DATE',	param:DateReferral )
		hb_hSet(aHash, 'PROFIL_K',	param:ProfilK )
		hb_hSet(aHash, 'VMP',		param:VMP )
		hb_hSet(aHash, 'VIDVMP',	param:VidVMP )
		hb_hSet(aHash, 'METVMP',	param:MethodVMP )
		hb_hSet(aHash, 'TAL_NUM',	param:NumberTalon )
		hb_hSet(aHash, 'TAL_D',		param:DateTalon )
		hb_hSet(aHash, 'TAL_P',		param:DatePlanned )
		hb_hSet(aHash, 'P_PER',		param:SignReceipt )
		hb_hSet(aHash, 'VNR',		param:WeightPrematureBaby )
		hb_hSet(aHash, 'VNR1',		param:WeightPrematureBaby1 )
		hb_hSet(aHash, 'VNR2',		param:WeightPrematureBaby2 )
		hb_hSet(aHash, 'VNR3',		param:WeightPrematureBaby3 )
		hb_hSet(aHash, 'PC1',		param:PC1 )
		hb_hSet(aHash, 'PC2',		param:PC2 )
		hb_hSet(aHash, 'PC3',		param:PC3 )
		hb_hSet(aHash, 'PC4',		param:PC4 )
		hb_hSet(aHash, 'PC5',		param:PC5 )
		hb_hSet(aHash, 'PC6',		param:PC6 )
		hb_hSet(aHash, 'PN1',		param:PN1 )
		hb_hSet(aHash, 'PN2',		param:PN2 )
		hb_hSet(aHash, 'PN3',		param:PN3 )
		hb_hSet(aHash, 'PN4',		param:PN3 )
		hb_hSet(aHash, 'PN5',		param:PN3 )
		hb_hSet(aHash, 'PN6',		param:PN3 )

		hb_hSet(aHash, 'ID',		param:ID )
		hb_hSet(aHash, 'REC_NEW',	param:IsNew )
		hb_hSet(aHash, 'DELETED',	param:IsDeleted )
		if ( ret := ::super:Save( aHash ) ) != -1
			param:ID := ret
			param:IsNew := .f.
		endif
	endif
	return ret

METHOD FillFromHash( hbArray )     CLASS THumanAddDB
	local obj
	
	obj := THumanAdd():New( hbArray[ 'ID' ], ;
			hbArray[ 'REC_NEW' ], ;
			hbArray[ 'DELETED' ], ;
			)
	obj:DiagnosisComplication1 := hbArray[ 'OSL1' ]
	obj:DiagnosisComplication2 := hbArray[ 'OSL2' ]
	obj:DiagnosisComplication3 := hbArray[ 'OSL3' ]
	obj:DateReferral :=           hbArray[ 'NPR_DATE' ]
	obj:ProfilK :=                hbArray[ 'PROFIL_K' ]
	obj:VMP :=                    hbArray[ 'VMP' ]
	obj:VidVMP :=                 hbArray[ 'VIDVMP' ]
	obj:MethodVMP :=              hbArray[ 'METVMP' ]
	obj:NumberTalon :=            hbArray[ 'TAL_NUM' ]
	obj:DateTalon :=              hbArray[ 'TAL_D' ]
	obj:DatePlanned :=            hbArray[ 'TAL_P' ]
	obj:SignReceipt :=            hbArray[ 'P_PER' ]
	obj:WeightPrematureBaby :=    hbArray[ 'VNR' ]
	obj:WeightPrematureBaby1 :=   hbArray[ 'VNR1' ]
	obj:WeightPrematureBaby2 :=   hbArray[ 'VNR2' ]
	obj:WeightPrematureBaby3 :=   hbArray[ 'VNR3' ]
	obj:PC1 :=                    hbArray[ 'PC1' ]
	obj:PC2 :=                    hbArray[ 'PC2' ]
	obj:PC3 :=                    hbArray[ 'PC3' ]
	obj:PC4 :=                    hbArray[ 'PC4' ]
	obj:PC5 :=                    hbArray[ 'PC5' ]
	obj:PC6 :=                    hbArray[ 'PC6' ]
	obj:PN1 :=                    hbArray[ 'PN1' ]
	obj:PN2 :=                    hbArray[ 'PN2' ]
	obj:PN3 :=                    hbArray[ 'PN3' ]
	obj:PN3 :=                    hbArray[ 'PN4' ]
	obj:PN3 :=                    hbArray[ 'PN5' ]
	obj:PN3 :=                    hbArray[ 'PN6' ]
	return obj