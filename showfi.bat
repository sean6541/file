@echo off
set /p ssid="Network SSID: "
netsh wlan show profile name="%ssid%" key=clear > tmp1.out
findstr /c:"Key Content" tmp1.out > tmp2.out
for /f "tokens=4" %%a in (tmp2.out) do set key=%%a
if NOT "%key%" == "" (
	echo Password: %key%
) else (
	echo No network with the name "%ssid%" was found.
)
del tmp1.out
del tmp2.out
pause