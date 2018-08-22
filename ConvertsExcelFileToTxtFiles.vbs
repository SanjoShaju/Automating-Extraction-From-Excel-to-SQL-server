Set wShell=CreateObject("WScript.Shell")
Set oExec=wShell.Exec("mshta.exe ""about:<input type=file id=FILE><script>FILE.click();new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).WriteLine(FILE.value);close();resizeTo(0,0);</script>""")
sFileSelected = oExec.StdOut.ReadLine
Dim objExcel
Set objExcel = CreateObject("Excel.Application")
With objExcel
	.Workbooks.Open(sFileSelected)


	.Sheets(2).Select
	.Columns("D:G").Select
    	.Selection.Copy
    	.Sheets(1).Select
	.Columns("O:O").Select
    	.ActiveSheet.Paste 

	.Sheets(1).Select
	.Sheets(1).Columns("A:A").NumberFormat = "0"
	.Sheets(1).Columns("B:B").NumberFormat = "0"
	.Sheets(1).Columns("I:I").NumberFormat = "0.0000000"
	.Sheets(1).Columns("J:J").NumberFormat = "0.0000000"
	.Sheets(1).Columns("K:K").NumberFormat = "0.0000000"	
	.Sheets(1).Columns("O:O").NumberFormat = "0.0000"
	.Sheets(1).Columns("P:P").NumberFormat = "0.0000"
	.Sheets(1).Columns("Q:Q").NumberFormat = "0.0000"
	.Sheets(1).Columns("R:R").NumberFormat = "0.0000"
	.Activeworkbook.SaveAs "C:\Temp\ExtractionToSQL\Products Data.txt",-4158

	.Sheets(3).Select
	.Sheets(3).Columns("A:A").NumberFormat = "0"
	.Activeworkbook.SaveAs "C:\Temp\ExtractionToSQL\Store Data.txt",-4158

	.Activeworkbook.Close SaveChanges=False
	.Quit
End With

