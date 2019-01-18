// Author: Klas Engwall
// https://groups.google.com/forum/#!topic/harbour-users/K-gT12M3jtg

#include "hbclass.ch"

#include "common.ch"
#include "fileio.ch"
#include "directry.ch"

create class tIPLogLocal from tIPLog

   method Init( cFileName )
   method Add( cMsg )
   method InsertDivider()
   method BuildFileName()
   method Close()

   exported:
   var lLogCredentials    init .t.
   var lLogAdditive       init .f.
   var nLogFileMaxSize    init 10000000
   var cFileName          init ''

   protected:
   var fHnd
//   var lUserFound         init .f.
//   var lPassFound         init .f.
   var lLoggingStarted    init .f.
   var cUserName          init ''

endclass



method Init( cFileName ) class tIPLogLocal
   ::super:New( cFileName )
   ::cFileName := cFileName
   return self



method Add( cMsg ) class tIPLogLocal

   local nPos, nPos2, nLen, cString
   if Empty( ::fHnd ) .or. ::fHnd == F_ERROR
      ::BuildFileName()
      if hb_fileexists( ::cFileName ) .and. ::lLogAdditive
         ::fHnd := fopen( ::cFileName, FO_READWRITE + FO_SHARED )
         fseek( ::fHnd, 0, FS_END )
      else
         ::fHnd := fcreate( ::cFileName, FC_NORMAL )    // It is created shared
      endif
   endif
   //
   if !::lLogCredentials // .and. !( ::lUserFound .and. ::lPassFound )
      cString := space( 1 ) + 'USER' + space( 1 )
      nPos := at( cString, cMsg )
      if nPos > 0
//         ::lUserFound := .t.

         ::cUserName := alltrim( substr( cMsg, nPos + 5 ) )
         nPos2 := at( '<', ::cUserName )
         ::cUserName := alltrim( left( ::cUserName, nPos2 - 1 ) )


      else
         cString := space( 1 ) + 'PASS' + space( 1 )
         nPos := at( cString, cMsg )
         if nPos > 0
//            ::lPassFound := .t.
         endif
      endif
      if nPos > 0
         nPos := nPos + len( cString )
         nLen := at( '<', substr( cMsg, nPos ) ) - 1    // Look for <cr><lf>
         cMsg := stuff( cMsg, nPos, nLen, replicate( '*', 8 ) + space( 1 ) )



      else
         if '>> 331' $ cMsg .or. '>> 230' $ cMsg
            if !empty( ::cUserName )
               cMsg := strtran( cMsg, ::cUserName, replicate( '*', 8 ) )
            endif
         endif




      endif
   endif
   //
   if ! Empty( ::fHnd ) .and. ::fHnd != F_ERROR
      return FWrite( ::fHnd, cMsg ) == Len( cMsg )
   endif

   return .f.



method InsertDivider() class tIPLogLocal

   && local cMsg := space( 1 ) + dtos( date() ) + '-' + time() + space( 1 )
   local cMsg := space( 1 ) + dtoc( date() ) + '-' + time() + space( 1 )
   local cNewLine := hb_eol()
   local nWritten

   cMsg := padc( cMsg, 80, '=' ) + cNewLine + cNewLine

   ::BuildFileName()

   if hb_fileexists( ::cFileName ) .and. ::lLogAdditive
      ::fHnd := fopen( ::cFileName, FO_READWRITE + FO_SHARED )
      fseek( ::fHnd, 0, FS_END )
   else
      ::fHnd := fcreate( ::cFileName, FC_NORMAL )    // It is created shared
      ::lLogAdditive := .t.   // We must keep logging to the same file after the divider
   endif

   if ! Empty( ::fHnd ) .and. ::fHnd != F_ERROR
      nWritten := FWrite( ::fHnd, cMsg )
      ::Close()
      return nWritten == Len( cMsg )
   endif

   ::Close()
   return .f.



method BuildFileName() class tIPLogLocal

   local cDir, cName, cExt, aLogFiles, i, n, cTemp, nFileSize := 0

   if ::lLoggingStarted
      return .f.
   endif

   if Empty( ::fHnd ) .or. ::fHnd == F_ERROR
      hb_FNameSplit( ::cFileName, @cDir, @cName, @cExt )
      if empty( cExt )
         cExt := '.log'
         ::cFileName := hb_FNameMerge( cDir + cName + cExt )  // Use if not <::lLogAdditive>
      endif
      //
      if ::lLogAdditive


/*
         aLogFiles := directory( ::cFileName )
         if !empty( aLogFiles )
            nFileSize := aLogFiles[ 1, F_SIZE ]
         endif
         if nFileSize > ::nLogFileMaxSize
*/


            aLogFiles := directory( hb_FNameMerge( cDir + cName + '*' + cExt ) )
            if !empty( aLogFiles )
               for i := 1 to len( aLogFiles )
                  cTemp := strtran( aLogFiles[ i, F_NAME ], cExt, '' )  // Remove the <cExt> part
                  cTemp := substr( cTemp, len( cName ) + 1 )            // Remove the <cName> part
                  cTemp := padl( cTemp, 8 )                             // Left pad the number part of the filename
                  aLogFiles[ i, F_NAME ] := cTemp                       // The <cName> part still removed
               next
               asort( aLogFiles, , , { |x, y| x[ F_NAME ] < y[ F_NAME ] } )  // Sort the number parts ascending
               i := len( aLogFiles )                                    // Get the last <cName> in the array
               cTemp := ltrim( aLogfiles[ i, F_NAME ] )
               if empty( cTemp )                                        // If it has no number
                  n := 0
               else                                                     // If it has a number
                  n := val( cTemp )
               endif
               if aLogfiles[ i, F_SIZE ] < ::nLogFileMaxSize            // If the file is not too large already
                  cName += cTemp
               else                                                     // Create a new numbered file
                  cName += ltrim( str( n + 1, 8, 0 ) )
               endif
               ::cFileName := hb_FNameMerge( cDir + cName + cExt )
            endif


/*
         endif
*/


      endif
   endif

   ::lLoggingStarted := .t.

   return .f.



method Close() class tIPLogLocal

   local lRetVal

   if ! Empty( ::fHnd ) .and. ::fHnd != F_ERROR
      lRetVal := FClose( ::fHnd )
      ::fHnd := NIL
      return lRetVal
   endif

   return .f.

//
