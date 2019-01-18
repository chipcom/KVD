#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'

// класс описания списка объектов
CREATE CLASS TListObjects
	VISIBLE:
		METHOD New( className )
		METHOD Class					INLINE ::FClassName
		METHOD Add( param )
	HIDDEN:
		DATA FClassName	INIT ''
		DATA FList		INIT {}
END CLASS

METHOD New( className )  CLASS TListObjects

	if pcount() == 0 .or. ( ! ischaracter( className ) .and. ! isobject( className ) )
		return nil
	endif
	if ischaracter( className )
		::FClassName := upper( alltrim( className ) )
	endif
	if isobject( className )
		::FClassName := className:className
	endif
	return self

METHOD Add( param )  CLASS TListObjects

	if param:className != ::FClassName
		return nil
	endif
	return aadd( ::FList, param )
