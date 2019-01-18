#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS Queue
	VISIBLE:
		PROPERTY Length AS NUMERIC READ getLength
		METHOD New( param )
		
		METHOD Pop
		METHOD Push( param )
	HIDDEN:
		DATA FFirst INIT nil
		DATA FLast INIT nil
		DATA FLength INIT 0
		
		METHOD getLength
ENDCLASS

METHOD New()		CLASS Queue
	return self

METHOD function getLength()		CLASS Queue
	return ::FLength

METHOD function Pop()		CLASS Queue
	local buf

	&& if (first == null) {
		&& return null;
	&& }
	&& else {
		&& if (first == last) {
			&& return last;
		&& }
		&& else {
			&& Node buf = first;
			&& first = first.next;
			&& return buf;
		&& }
	&& }
	if isnil( ::FFirst )
		return nil
	else
		if ::FFirst == ::FLast
			return ::FLast
		else
			buf := ::FFirst
			::FFirst := ::FFirst:Next
			::FLength--
		endif
	endif
	return buf

METHOD procedure Push( param )		CLASS Queue
	local newNode
	&& local oSuper := Node():New()
	
	&& public void push(Object obj) {
		&& if (obj == null || !(obj instanceof Node))
			&& return;
		&& else {
			&& Node node = (Node)obj;
			&& if (first == null) {
				&& last = node;
				&& first = last;
			&& }
			&& else {
				&& last.next = node;
				&& last = last.next;
			&& }
		&& }
	&& }
	
&& ? __objDerivedFrom( oObject, oSuper )  
	if isobject( param ) .and. param:classname == 'NODE'
		newNode := param
		if isnil( ::FFirst )
			::FLast := newNode
			::FFirst := ::FLast
		else
			::FLast:Next := newNode
			::FLast := ::FLast:Next
		endif
		::FLength++
	endif
	return