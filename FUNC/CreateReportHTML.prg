*****************************************************************
* 06.11.18 ViewHTML( oDoc ) - ���������� �����
* 03.10.18 CreateReportHTML( cTitle ) - ������������ ��������� HTML ������� ����������� ���������
* 29.06.18 CreateHeaderHTMLReport( oDoc, cTitle, aHash ) - ������������ ��������� ������
*****************************************************************


#include 'hbthread.ch'
#include 'inkey.ch'
#include 'function.ch'

#require 'hbtip'

* 03.10.18 ������������ ��������� HTML ������� ����������� ���������
function CreateReportHTML( cTitle )
	local oDoc, oNode, oForm, oButton
	local item, cFile, tmpDir
	local aFiles := { 'chip.css', 'chip_mo.js', 'jquery-3.2.1.min.js' }

	tmpDir := hb_DirTemp()
	// ������� ������� ����������� ����� �� ��������� �������
	for each item in aFiles
		cFile := dir_exe + item
		if file( cFile )
			__CopyFile( cFile, tmpDir + item )
		endif
	next
	
	// ��������� HTML-��������
	oDoc          := THtmlDocument():new()
	/* Operator "+" creates a new node */
	oNode         := oDoc:head + 'meta'
	oNode:name    := 'Generator'
	oNode:content := 'text/html; charset=windows-1251'
	oNode         := oDoc:head   + 'title'
	oNode:text    := alltrim( cTitle )
	
	// ��������� ������� ������ �� ��������
	oNode		:= oDoc:head   + 'link'
	oNode:type	:= 'text/css'
	oNode:rel	:= 'stylesheet'
	oNode:href	:= 'chip.css'

	// ��������� ������ ������
	oForm			:= oDoc:body:form
	oForm:id		:= 'print'
	oButton			:= oForm + 'input type="submit"'
	oButton:value	:= '������ ������'
	oButton			:= oButton - 'input'
	HB_SYMBOL_UNUSED( oForm )

	oDoc:body:attr	:= 'style="width:700px"'
	// ��������� ������
	oNode			:= oDoc:body + 'script'
	oNode:text		:= SourceScript()
    && oNode:src		:= 'chip_mo.js'
	return oDoc

function SourceScript()

	return hb_eol() + "document.getElementById('print').onsubmit = function() {" + hb_eol() + ;
						"window.print();" + hb_eol() + 'return false;' + hb_eol() + '};' + hb_eol()
	
* 29.06.18 ������������ ��������� ������
function CreateHeaderHTMLReport( oDoc, aTitle, aHash )
	local i := len( aTitle ), j := 1
	local strTypeDate

	oNode		:= oDoc:body:h1
	oNode		:= oNode + 'center'
	oNode:attr	:= 'style="font-size:large;"'
	oNode:text	:= aTitle[ 1 ]
	oNode		:= oNode - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	oNode		:= oDoc:body:h2
	oNode		:= oNode + 'center'
	oNode:attr	:= 'style="font-size:medium;"'
	oNode:text	:= win_OEMToANSI( aHash[ 'SELECTEDPERIOD' ][ 4 ] )
	oNode		:= oNode - 'center'
	HB_SYMBOL_UNUSED( oNode )
	
	if aHash[ 'STRINGFORPRINT' ] != nil
		oNode		:= oDoc:body:h2
		oNode		:= oNode   + 'center'
		oNode:attr	:= 'style="font-size:medium;"'
		oNode:text	:= aHash[ 'STRINGFORPRINT' ]
		oNode		:= oNode - 'center'
		HB_SYMBOL_UNUSED( oNode )
	endif
	
	if aHash[ 'TYPEDATE' ] != nil
		if aHash[ 'TYPEDATE' ] == 1
			strTypeDate := '[�� ���� �������]'
		elseif aHash[ 'TYPEDATE' ] == 2
			strTypeDate := '[�� ���� ��������� �������]'
		elseif aHash[ 'TYPEDATE' ] == 3
			strTypeDate := '[�� ���� �������� �/�����]'
		endif
		oNode		:= oDoc:body:h2
		oNode		:= oNode   + 'center'
		oNode:attr	:= 'style="font-size:medium;"'
		oNode:text	:= strTypeDate
		oNode		:= oNode - 'center'
		HB_SYMBOL_UNUSED( oNode )
	endif
	
	if aHash[ 'SELECTEDSUBDIVISION' ] == nil
		oNode		:= oDoc:body:h3
		oNode		:= oNode + 'center'
		oNode:attr	:= 'style="font-size:small;"'
		oNode:text	:= titleDepartmentForHTML( aHash[ 'SELECTEDDEPARTMENT' ], aHash[ 'SELECTEDPERIOD' ] )
		oNode		:= oNode - 'center'
		HB_SYMBOL_UNUSED( oNode )
	else
		oNode		:= oDoc:body:h3
		oNode		:= oNode + 'center'
		oNode:attr	:= 'style="font-size:small;"'
		oNode:text	:= titleSubdivisionForHTML( aHash[ 'SELECTEDSUBDIVISION' ] )
		oNode		:= oNode - 'center'
		HB_SYMBOL_UNUSED( oNode )
	endif

	do while i > 1
		i--
		oNode		:= oDoc:body:h4
		oNode		:= oNode + 'center'
		oNode:attr	:= 'style="font-size:medium;"'
		oNode:text	:= aTitle[ ++j ]
		oNode		:= oNode - 'center'
		HB_SYMBOL_UNUSED( oNode )
	enddo
	return nil
	
* 06.11.18 ���������� �����
function ViewHTML( oDoc )
	local cName := ''

	hb_FTempCreateEx( @cName, , , 'html', SetFCreate() )
	cName := cName + '.html'
	if oDoc:writeFile( cName )
		MyRun( '"' + cName + '"' )
	endif
	return nil
