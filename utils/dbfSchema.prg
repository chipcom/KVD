#include 'dbstruct.ch'

#define K_DIR_ARG    '--dir='
#define K_OUT_ARG    '--out='
#define K_VERBOSE_ARG    '--verbose'
#define K_LIST_ARG    '--list='
#define K_INGOREREAD_ARG    '--ignore-read-error'

#require 'hbmxml'

#xtranslate _ENCODE( <xData> ) => ( hb_base64Encode( hb_Serialize( mxmlGetCustom( <xData> ) ) ) )

memvar dirs,schemaDir,verbose,prefixes,indexes,ignoreReadError

procedure main(...)
	local args := HB_AParams()
	local item, itemField
	local dir
	local xmlName := 'orm.xml'
	
    ParseArguments( args )

	&& if ! hb_FileExists( xmlName )
		create_xml( xmlName )
	&& endif

	for each dir in dirs
		if verbose
			OutStd( 'Checking:', HB_PathNormalize( HB_PS() + CurDir() + HB_PS() + dir ), HB_EOL() )
		endif
		
		for each item in collectionDBFFile()
			?'File: ' + item
			for each itemField in collectionFieldDBFFile( item )
				?'  Field: ' + itemField[ DBS_NAME ] + ', ' + itemField[ DBS_TYPE ] + ', ' + alltrim ( str( itemField[ DBS_LEN ] ) ) + ', ' + alltrim( str( itemField[ DBS_DEC ] ) )
			next
			?''
		next
	next
	?'end'
	quit

function collectionDBFFile()
	local aName := {}
	local nLen := ADir( '*.dbf' )

	if nLen > 0
		aName := Array( nLen )
		ADir( '*.dbf', aName )
	endif
	return aName

function collectionFieldDBFFile( cFile )
	local aField
	
	use (cFile) READONLY
	aField := dbStruct()
	close database
	return aField

function CheckArgFlag ( arg, flag )
    return Lower( Left( arg, Len( flag ) ) ) == flag

function ParseFlag ( arg, flag )
    return SubStr( arg, len( flag ) + 1 )

procedure ParseArguments( args )
    local tmp	//, preFilePath

    public dirs := {}
    public schemaDir := 'schema'
    public verbose := .f.    
    public prefixes := {}
    public indexes := { { '.NT*', 'DBFNTX' } /*,{'.ND*', 'DBFNDX'}, {'.CD*', 'DBFCDX'},{'.MD*','DBFMDX'}*/}
    public ignoreReadError := .f.

    for each tmp in args
        do case
        case CheckArgFlag( tmp, K_DIR_ARG )
            AAdd( dirs, ParseFlag( tmp, K_DIR_ARG ) )
        && case CheckArgFlag( tmp, K_OUT_ARG )
            && schemaDir := ParseFlag( tmp, K_OUT_ARG )
        case CheckArgFlag( tmp, K_VERBOSE_ARG )
            verbose := .t.
            OutStd( 'Verbose', HB_EOL() )
        && case CheckArgFlag( tmp, K_INGOREREAD_ARG )
            && ignoreReadError := .t.
        && case CheckArgFlag( tmp, K_LIST_ARG )
            && preFilePath := ParseFlag( tmp, K_LIST_ARG )
            && HB_FUse( preFilePath )
            && do while !HB_FEOF()
                && AAdd( prefixes, alltrim( HB_FReadAndSkip() ) )
            && enddo
            && HB_FUse()
        && otherwise
            && AAdd( prefixes, tmp )
        endcase
    next

    if empty( dirs )
      AAdd( dirs, '' )
    end if

    if verbose
        AEval( dirs, { | d | OutStd( 'Dir:' , d, HB_EOL() ) } )
        && AEval( prefixes, { | p | OutStd( 'Prefix:' , p, HB_EOL() ) } )
        && OutStd( 'Ignore Read errors:', ignoreReadError, HB_EOL() )
    endif
    return

static procedure create_xml( fileName )
	local tree, group, element, node
	local hData := { => }
	
	hData[ 'Today' ] := hb_TSToStr( hb_DateTime() )
	/* etc. */
	
	tree    := mxmlNewXML()
	group   := mxmlNewElement( tree, "group" )
	element := mxmlNewElement( group, "hash" )
	node    := mxmlNewCustom( element, hData )
	
	mxmlElementSetAttr( element, 'type', 'custom' )
	mxmlElementSetAttr( element, 'checksum', hb_MD5( _ENCODE( node ) ) )
	
	mxmlSaveFile( tree, fileName, @whitespace_cb() )
	
	return

function whitespace_cb( node, where )
	local parent        /* Parent node */
	local nLevel := -1  /* Indentation level */
	local name          /* Name of element */
	
	name := mxmlGetElement( node )
	
	if Left( name, 4 ) == '?xml'
		if where == MXML_WS_AFTER_OPEN
			return hb_eol()
		else
			return nil
		endif
	
	elseif where == MXML_WS_BEFORE_OPEN .or. ;
			( ( name == 'choice' .or. name == 'option' ) .and. ;
			where == MXML_WS_BEFORE_CLOSE )
		parent := mxmlGetParent( node )
		do while ! empty( parent )
			nLevel++
			parent := mxmlGetParent( parent )
		enddo
	
		if nLevel > 8
			nLevel := 8
		elseif nLevel < 0
			nLevel := 0
		endif
	
		return replicate( Chr( 9 ), nLevel )
	
	elseif where == MXML_WS_AFTER_CLOSE .or. ;
			( ( name == 'group' .or. name == 'option' .or. name == 'choice' ) .and. ;
			where == MXML_WS_AFTER_OPEN )
		return hb_eol()
	
	elseif where == MXML_WS_AFTER_OPEN .and. empty( mxmlGetFirstChild( node ) )
		return hb_eol()
	endif
	
	return nil /* Return NIL for no added whitespace... */

