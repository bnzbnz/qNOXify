function mzp2pdb {
	param ( $AppName )
	Write-Host "$AppName.exe : ";
	.\map2pdb.exe -bind:"$AppName.exe" "$AppName.map"
}
mzp2pdb "..\qNOXify"

pause
