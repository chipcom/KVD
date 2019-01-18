#ifndef _INI_CH
#define _INI_CH

#xcommand INI <oIni> ;
             [ <file: FILENAME, FILE, DISK> <cIniFile> ] ;
       => ;
          <oIni> := TIniFile():New( <cIniFile> )

#xcommand GET <uVar> ;
             [ SECTION <cSection> ] ;
             [ ENTRY <cEntry> ] ;
             [ DEFAULT <uDefault> ] ;
             [ <of: OF, INI> <oIni> ] ;
       => ;
          <uVar> := <oIni>:Get( <cSection>, <cEntry>, <uDefault>, <uVar> )

#xcommand SET [ SECTION <cSection> ] ;
              [ ENTRY <cEntry> ] ;
              [ TO <uVal> ] ;
              [ <of: OF, INI> <oIni> ] ;
       => ;
          <oIni>:Set( <cSection>, <cEntry>, <uVal> )

#xcommand GET SECTIONS TO <uVal> ;
             [ <of: OF, INI> <oIni> ] ;
       => ;
          <uVal> := <oIni>:ReadSections()

//#xcommand GET SECTION <cSection> TO <uVal> ;
//             [ <of: OF, INI> <oIni> ] ;
//       => ;
//          <uVal> := <oIni>:ReadSection( <cSection> )
		  
#xcommand ENDINI =>

#endif