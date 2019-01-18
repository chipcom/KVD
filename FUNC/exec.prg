
/*
    AsCodeBlock : Преобразует строку в блок кода
*/
FUNCTION AsCodeBlock( cStr, xDefaultVal )

	if empty( cStr )
		return xDefaultVal
	endif
	return &( '{||' + cStr + '}' )

/*
    Exec : вычисляет строку и возвращает результат
*/
FUNCTION Exec( cStr, xDefaultVal )
	local xRet

	BEGIN SEQUENCE // WITH {|e| ArelErrorHandle(e) }
		if ValType( cStr ) = 'B'
			xRet := Eval( cStr )
		else
			xRet := AsCodeBlock( cStr, xDefaultVal ):Eval()
		endif
	RECOVER
		xRet := xDefaultVal
	END SEQUENCE
	return xRet
