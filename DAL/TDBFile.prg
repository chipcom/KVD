<<<<<<< HEAD
#include 'hbclass.ch'
#include 'common.ch'
#include 'property.ch'
#include 'function.ch'
=======
#include "hbclass.ch"
#include "function.ch"
>>>>>>> master

CREATE CLASS TDBFile
	VISIBLE:
		PROPERTY FileName AS STRING READ getFileName WRITE setFileName
		PROPERTY IndexFile AS ARRAY READ getIndexFile WRITE setIndexFile
		PROPERTY AliasFile AS STRING READ getAlias WRITE setAlias
		PROPERTY StructFile AS ARRAY READ getStructure WRITE setStructure
		PROPERTY Description AS STRING READ getDescription
		
		METHOD New( cFileName, aIndexFile, cAlias, cDescription )
	HIDDEN:
		DATA FFileName		AS STRING	INIT ''
		DATA FStructFile	AS ARRAY	INIT {}
		DATA FIndexFile		AS ARRAY	INIT {}
		DATA FAlias			AS STRING	INIT ''
		DATA FDescription	AS STRING	INIT ''
	
		DATA FbBeforeReconstruct    INIT ''	// для дальнейшего
		DATA FbAfterReconstruct     INIT ''	// для дальнейшего
		
		METHOD getFileName
		METHOD setFileName( param )
		METHOD getIndexFile
		METHOD setIndexFile( param )
		METHOD getAlias
		METHOD setAlias( param )
		METHOD getStructure
		METHOD setStructure( param )
		METHOD getDescription
ENDCLASS

METHOD function getFileName		CLASS TDBFile
	return ::FFileName

METHOD procedure setFileName( param )

	if ischaracter( param )
		::FFileName := alltrim( param )
	endif
	return

METHOD function getIndexFile		CLASS TDBFile
	return ::FIndexFile

METHOD procedure setIndexFile( param )

	if isarray( param )
		::FIndexFile := param
	endif
	return

METHOD function getAlias		CLASS TDBFile
	return ::FAlias

METHOD procedure setAlias( param )

	if ischaracter( param )
		::FAlias := alltrim( param )
	endif
	return

METHOD function getStructure		CLASS TDBFile
	return ::FStructFile

METHOD procedure setStructure( param )

	if isarray( param )
		::FStructFile := param
	endif
	return

METHOD function getDescription		CLASS TDBFile
	return ::FDescription

// Конструктор
METHOD New( cFileName, aIndexFile, cAlias, aStructFile, cDescription )		CLASS TDBFile

	HB_Default( @cFileName, '' ) 
	HB_Default( @cAlias, '' ) 
	HB_Default( @cDescription, '' ) 
	HB_Default( @aStructFile, {} ) 
	HB_Default( @aIndexFile, {} ) 

	if empty( cFileName)
		return nil
	endif
	::FFileName	:=	cFileName
	::FStructFile	:=	aStructFile
	::FIndexFile	:=	aIndexFile
	::FAlias		:=	cAlias
	::FDescription	:=	cDescription
	
	return self
