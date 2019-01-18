#include 'hbclass.ch'
#include 'common.ch'
#include 'hbhash.ch'
#include 'property.ch'

CREATE CLASS Stack
	VISIBLE:
		PROPERTY Length AS NUMERIC READ getLength
		METHOD New( param )
		
		METHOD Pop
		METHOD Push( param )
	HIDDEN:
		DATA FTop INIT nil
		DATA FLength INIT 0
		
		METHOD getLength
ENDCLASS

METHOD New()		CLASS Stack
	return self

METHOD function getLength()		CLASS Stack
	return ::FLength

METHOD function Pop()		CLASS Stack
	local proxyTop

	&& public Node pop(){
		&& if (top != null) {
			&& Node proxyTop = top;
			&& top = top.next;
			&& return proxyTop;
		&& }
		&& else {
			&& return null;
		&& }
	&& }
	if isnil( ::FTop )
		return nil
	else
		proxyTop := ::FTop
		::FTop := ::FTop:Next
		::FLength--
	endif
	return proxyTop

METHOD procedure Push( param )		CLASS Stack
	local newNode
	local oSuper := Node():New()
	
	&& public void push(Object node) {
		&& if (node == null || !(node instanceof Node))
			&& return;
		&& else {
			&& Node newNode = (Node)node;
			&& newNode.next = top;
			&& top = newNode;
		&& }
	&& }
&& ? __objDerivedFrom( oObject, oSuper )  
	if isobject( param ) .and. param:classname == 'NODE'
		newNode := param
		newNode:Next := ::FTop
		::FTop := newNode
		::FLength++
	endif
	return