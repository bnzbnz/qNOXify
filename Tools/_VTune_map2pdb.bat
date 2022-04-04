@echo off
echo Generating process debug file (pdb) : qNOXify.exe
.\map2pdb.exe -bind:..\qNOXify.exe ..\qNOXify.map
pause