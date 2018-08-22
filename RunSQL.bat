@ECHO OFF
if not exist "C:\Temp\ExtractionToSQL\" mkdir C:\Temp\ExtractionToSQL
pushd %~dp0
cscript ConvertsExcelFileToTxtFiles.vbs
CLS
start sqlcmd -U "sa" -P "Intactix1" -S IN1-1023497LT -v DatabaseName = CKB_END_TO_END -i "C:\Temp\ExtractionToSQL\Extracting_To_SQL.sql"
PAUSE