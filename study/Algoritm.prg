procedure main()
	local node, stack
	
	node := Node():New( 200 )
	
	&& stack := Stack():New()
	queue := Queue():New()
	
	&& stack:Push( node )
	queue:Push( node )
	node := Node():New( 500 )
	&& stack:Push( node )
	queue:Push( node )
	&& ?stack:Length
	?queue:Length

	node := nil
	?xtoc( node )
	&& node := stack:Pop()
	node := queue:Pop()
	?node:Value
	&& ?stack:Length
	?queue:Length
	node := nil
	&& node := stack:Pop()
	node := queue:Pop()
	?node:Value
	&& ?stack:Length
	?queue:Length
	&& node := stack:Pop()
	node := queue:Pop()
	?xtoc( node )
	inkey(0)
return