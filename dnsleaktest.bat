@echo off

for /F "tokens=*" %%g IN ('powershell -command "& { Get-Random -Minimum 1000000 -Maximum 9999999 }"') do (set /a leak_id=%%g)

rem echo %leak_id%

for /L %%g IN (1,1,10) do ping %%g.%leak_id%.bash.ws > nul

powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://bash.ws/dnsleak/test/%leak_id%?txt', '%leak_id%.txt') }"

echo Detected DNS servers:
for /f "tokens=1,2,3,4 delims=|" %%1 in (%leak_id%.txt) do (
    if [%%1] neq [] (
        if [%%3] neq [] (
            if [%%4] neq [] (
                echo %%1 [%%3, %%4]
            ) else (
                echo %%1 [%%3]
            )
        ) else (
            echo %%1
        )
    )
)

del /q %leak_id%.txt