c:\Harbour\bin\hbmk2 chip_mo_bay.hbp -comp=mingw
copy chip_mo.exe d:\_mo\chip\exe
copy chip.css d:\_mo\chip\exe
copy chip_mo.css d:\_mo\chip\exe
copy chip_mo.js d:\_mo\chip\exe
copy _dogovor.shb d:\_mo\chip\exe
copy list_uch.shb d:\_mo\chip\exe
rem copy ReferenceToFTS.shb d:\_mo\chip\exe
rar a -ep d:\_mo\_build\KVD\chip_mo @my_chip_mo.lst
