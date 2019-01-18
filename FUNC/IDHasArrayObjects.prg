*****
&& function f_is_uch_bay( aObjects, ID )
function IDHasArrayObjects( aObjects, ID )

	return ascan( aObjects, { | x | ID == x:ID() } ) > 0
