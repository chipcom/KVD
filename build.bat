@echo off

set "MO_PATH=d:\_mo\_kvd"
set "MO_PATH_TEMP=d:\_mo\temp\kvd"

rmdir "%MO_PATH_TEMP%" /s /q

c:\Harbour\bin\hbmk2 chip_mo_bay.hbp -comp=mingw

if errorlevel 1 (
    echo Ошибка построения проекта для КВД.
    exit /b 1
)

copy chip_mo.exe d:\_mo\chip\exe
copy chip.css d:\_mo\chip\exe
copy chip_mo.css d:\_mo\chip\exe
copy chip_mo.js d:\_mo\chip\exe
copy _dogovor.shb d:\_mo\chip\exe
copy list_uch.shb d:\_mo\chip\exe
rem copy ReferenceToFTS.shb d:\_mo\chip\exe
C:\"Program Files"\WinRAR\Rar.exe a -ep d:\_mo\_build\KVD\chip_mo @my_chip_mo.lst
