#include 'hbclass.ch'
#include 'property.ch'
#include 'common.ch'
#include 'def_bay.ch'

#define EVENTS_MESSAGES 1
#define EVENTS_ACTIONS  2

&& static aCustomEvents := { ;
		&& { WM_NOTIFY, WM_PAINT, WM_CTLCOLORSTATIC, WM_CTLCOLOREDIT, WM_CTLCOLORBTN, ;
		&& WM_COMMAND, WM_DRAWITEM, WM_SIZE, WM_DESTROY }, ;
		&& { ;
		&& { |o, w, l| onNotify( o, w, l ) }                                 , ;
		&& { |o, w|   iif( o:bPaint != nil, eval( o:bPaint, o, w ), - 1 ) }  , ;
		&& { |o, w, l| onCtlColor( o, w, l ) }                               , ;
		&& { |o, w, l| onCtlColor( o, w, l ) }                               , ;
		&& { |o, w, l| onCtlColor( o, w, l ) }                               , ;
		&& { |o, w, l| onCommand( o, w ) }                                   , ;
		&& { |o, w, l| onDrawItem( o, w, l ) }                               , ;
		&& { |o, w, l| onSize( o, w, l ) }                                   , ;
		&& { |o|     onDestroy( o ) }                                       ;
		&& } ;
		&& }
static aCustomEvents := { ;
		{ CH_NOTIFY, CH_ATTR_CLASS, CH_COMMAND }, ;
		{ ;
			{ |o, w, l| onNotify( o, w, l ) }			, ;
			{ |o, w, l| onChangeAttribute( o, w, l ) }	, ;
			{ |o, w, l| onCommand( o, w ) }				, ;
		} ;
	}

// Описываем класс TBaseObjectBLL
CREATE CLASS TBaseObjectBLL
	VISIBLE:
		
		PROPERTY ID AS NUMERIC READ getID WRITE setID
		PROPERTY IDUser AS NUMERIC READ getIDUser WRITE setIDUser
		PROPERTY IsDeleted AS LOGICAL READ getIsDeleted WRITE setIsDeleted
		PROPERTY IsNew AS LOGICAL READ getIsNew WRITE setIsNew
		
		METHOD Equal( obj )
		METHOD DeepEqual( obj )
		METHOD Clone()
		METHOD forJSON()				VIRTUAL
	
	PROTECTED:
		DATA FID		INIT 0
		DATA FIDUser	INIT 0
		DATA FDeleted	INIT .f.
		DATA FNew		INIT .t.
		
		METHOD new( nID, lNew, lDeleted )
		METHOD getID
		METHOD setID( value )
		METHOD getIDUser
		METHOD setIDUser( value )
		METHOD getIsDeleted
		METHOD setIsDeleted( value )
		METHOD getIsNew
		METHOD setIsNew( value )
	
		// для обработки событий изменения объекта
		DATA aEvents       INIT {}
		DATA aNotify       INIT {}
		DATA aControls     INIT {}
		DATA bOther
		
		METHOD AddEvent( nEvent, nId, bAction, lNotify ) ;
			INLINE AAdd( iif( lNotify == nil .or. !lNotify, ;
			::aEvents, ::aNotify ), ;
			{ nEvent, nId, bAction } )
		METHOD onEvent( msg, wParam, lParam )
ENDCLASS

METHOD function getID()	CLASS TBaseObjectBLL
	return ::FID

METHOD procedure setID( value )	CLASS TBaseObjectBLL
	::FID := value
	return

METHOD function getIDUser()	CLASS TBaseObjectBLL
	return ::FIDUser

METHOD procedure setIDUser( value )	CLASS TBaseObjectBLL
	::FIDUser := value
	return

METHOD function getIsDeleted()	CLASS TBaseObjectBLL
	return ::FDeleted

METHOD procedure setIsDeleted( value )	CLASS TBaseObjectBLL
	::FDeleted := value
	return

METHOD function getIsNew()	CLASS TBaseObjectBLL
	return ::FNew

METHOD procedure setIsNew( value )	CLASS TBaseObjectBLL
	::FNew := value
	return

METHOD New( nID, lNew, lDeleted )	CLASS TBaseObjectBLL

	::FID			:= hb_DefaultValue( nID, 0 )
	::FNew			:= hb_DefaultValue( lNew, .t. )
	::FDeleted		:= hb_DefaultValue( lDeleted, .f. )
	return self

METHOD Clone()		 CLASS TBaseObjectBLL
	local oTarget := nil

	oTarget := __objClone( self )
	oTarget:ID := 0
	oTarget:IsNew := .t.
	oTarget:IsDeleted := .f.
	oTarget:IDUser := 0
	return oTarget
	
******** сравнить объект с переданным
* проверка происходит на основании совпадения идентификаторов записи
*
* Возврат 	.T. - объекты эквивалентены
*			.F. - объекты не эквивалентены
METHOD Equal( obj )		 CLASS TBaseObjectBLL
	local ret := .f.
	
	if upper( alltrim( ::ClassName() ) ) == upper( alltrim( obj:ClassName() ) )	// определяем, это один и тот же класс
		ret := ( ::FID == obj:ID )
	endif
	return ret

******** полностью сравнить объект с переданным ( учитывая все поля )
* проверка происходит на основании совпадения всех полей без учёта идентификаторов записи
*
* Возврат 	.t. - объекты эквивалентены
*			.f. - объекты не эквивалентены
METHOD DeepEqual( obj )		 CLASS TBaseObjectBLL
	local ret := .f.
	
	if upper( alltrim( ::ClassName() ) ) == upper( alltrim( obj:ClassName() ) )	// определяем, это один и тот же класс
		// TODO
		&& ret := ( ::FID == obj:ID )
	endif
	return ret

METHOD onEvent( msg, wParam, lParam )  CLASS TBaseObjectBLL
	local i
	
	// Writelog( "== "+::Classname()+Str(msg)+IIF(wParam!=NIL,Str(wParam),"NIL")+IIF(lParam!=NIL,Str(lParam),"NIL") )
	
	if ( i := ascan( aCustomEvents[ EVENTS_MESSAGES ], msg ) ) != 0
		return eval( aCustomEvents[ EVENTS_ACTIONS, i ], Self, wParam, lParam )
	elseif ::bOther != nil
		return eval( ::bOther, Self, msg, wParam, lParam )
	endif
	return -1

static function onChangeAttribute( oWnd, wParam, lParam )
	local iItem, oCtrl, nCode, res, n
	
	&& wParam := hwg_PtrToUlong( wParam )
	&& if empty( oCtrl := oWnd:FindControl( wParam ) )
		&& for n := 1 TO len( oWnd:aControls )
			&& oCtrl := oWnd:aControls[ n ]:FindControl( wParam )
			&& if oCtrl != nil
				&& exit
			&& endif
		&& next
	&& endif
	
	&& if oCtrl != nil
	
		&& if __ObjHasMsg( oCtrl, 'NOTIFY' )
			&& return oCtrl:Notify( lParam )
		&& else
			&& nCode := hwg_Getnotifycode( lParam )
			&& if nCode == EN_PROTECTED
				&& return 1
			&& elseif oWnd:aNotify != nil .and. ;
					&& ( iItem := ascan( oWnd:aNotify, { |a| a[ 1 ] == nCode .and. ;
					&& a[ 2 ] == wParam } ) ) > 0
				&& if ( res := eval( oWnd:aNotify[ iItem, 3 ], oWnd, wParam ) ) != nil
					&& return res
				&& endif
			&& endif
		&& endif
	&& endif
	return -1

static function onNotify( oWnd, wParam, lParam )
	local iItem, oCtrl, nCode, res, n
	
	&& wParam := hwg_PtrToUlong( wParam )
	&& if empty( oCtrl := oWnd:FindControl( wParam ) )
		&& for n := 1 TO len( oWnd:aControls )
			&& oCtrl := oWnd:aControls[ n ]:FindControl( wParam )
			&& if oCtrl != nil
				&& exit
			&& endif
		&& next
	&& endif
	
	&& if oCtrl != nil
	
		&& if __ObjHasMsg( oCtrl, 'NOTIFY' )
			&& return oCtrl:Notify( lParam )
		&& else
			&& nCode := hwg_Getnotifycode( lParam )
			&& if nCode == EN_PROTECTED
				&& return 1
			&& elseif oWnd:aNotify != nil .and. ;
					&& ( iItem := ascan( oWnd:aNotify, { |a| a[ 1 ] == nCode .and. ;
					&& a[ 2 ] == wParam } ) ) > 0
				&& if ( res := eval( oWnd:aNotify[ iItem, 3 ], oWnd, wParam ) ) != nil
					&& return res
				&& endif
			&& endif
		&& endif
	&& endif
	return -1

static function onCommand( oWnd, wParam )
	&& local iItem, iParHigh := hwg_Hiword( wParam ), iParLow := hwg_Loword( wParam )
	
	&& if oWnd:aEvents != nil .and. ;
			&& ( iItem := ascan( oWnd:aEvents, { |a| a[ 1 ] == iParHigh .and. ;
			&& a[ 2 ] == iParLow } ) ) > 0
		&& eval( oWnd:aEvents[ iItem, 3 ], oWnd, iParLow )
	&& endif
	return 1

