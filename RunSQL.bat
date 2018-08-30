@ECHO OFF
if not exist "C:\Temp\ExtractionToSQL\" mkdir C:\Temp\ExtractionToSQL
pushd %~dp0
cscript ConvertsExcelFileToTxtFiles.vbs
CLS
start sqlcmd -U "Login" -P "Password" -S Server_Name -v DatabaseName = Data1 -i "C:\Temp\ExtractionToSQL\Extracting_To_SQL.sql"
PAUSE
