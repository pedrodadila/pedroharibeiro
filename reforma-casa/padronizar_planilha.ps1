$ErrorActionPreference = 'Stop'

$sourceFolder = 'C:\Users\Performance\OneDrive\Documentos\VSCODE\reforma-casa'
$inputPath = Join-Path $sourceFolder 'Controle Financeiro - Reforma Casa 367 - Final.xlsx'
$outputPath = Join-Path $sourceFolder 'Controle Financeiro - Reforma Casa 367 - Padronizada.xlsx'
$xlOpenXMLWorkbook = 51
$xlCenter = -4108
$xlRight = -4152

function Color($r,$g,$b) { return $r + ($g * 256) + ($b * 65536) }
function Border($range) {
    $range.Borders.LineStyle = 1
    $range.Borders.Color = (Color 217 225 242)
    $range.Borders.Weight = 2
}
function Title($range) {
    $range.Interior.Color = (Color 31 78 121)
    $range.Font.Color = 16777215
    $range.Font.Bold = $true
    $range.Font.Size = 16
    $range.HorizontalAlignment = $xlCenter
    $range.VerticalAlignment = $xlCenter
}
function Header($range) {
    $range.Interior.Color = (Color 47 117 181)
    $range.Font.Color = 16777215
    $range.Font.Bold = $true
    $range.HorizontalAlignment = $xlCenter
    $range.VerticalAlignment = $xlCenter
}
function SummaryLabel($range) {
    $range.Interior.Color = (Color 221 235 247)
    $range.Font.Color = (Color 31 78 121)
    $range.Font.Bold = $true
    $range.HorizontalAlignment = $xlCenter
}
function SummaryValue($range) {
    $range.Interior.Color = (Color 242 246 250)
    $range.Font.Color = (Color 31 78 121)
    $range.Font.Bold = $true
    $range.Font.Size = 12
    $range.HorizontalAlignment = $xlCenter
}
function BandRows($ws, $firstRow, $lastRow, $lastColumn) {
    for ($r = $firstRow; $r -le $lastRow; $r++) {
        $rowRange = $ws.Range("A${r}:${lastColumn}${r}")
        if (($r - $firstRow) % 2 -eq 1) { $rowRange.Interior.Color = (Color 248 250 252) }
        else { $rowRange.Interior.Color = 16777215 }
    }
}

$excel = $null
$wb = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $wb = $excel.Workbooks.Open($inputPath)

    foreach ($ws in $wb.Worksheets) {
        $used = $ws.UsedRange
        $used.Font.Name = 'Aptos'
        $used.Font.Size = 10
        $used.VerticalAlignment = $xlCenter
        $ws.Activate()
        $excel.ActiveWindow.DisplayGridlines = $false
    }

    $ws = $wb.Worksheets.Item('Orçamento Principal')
    $ws.Range('A1:F1').Merge()
    Title $ws.Range('A1:F1')
    $ws.Rows.Item(1).RowHeight = 28
    SummaryLabel $ws.Range('A3:F3')
    SummaryValue $ws.Range('A4:F4')
    $ws.Range('A5:F5').Merge()
    $ws.Range('A5').Interior.Color = (Color 255 242 204)
    $ws.Range('A5').Font.Color = (Color 156 87 0)
    $ws.Range('A5').Font.Bold = $true
    $ws.Range('A5').HorizontalAlignment = $xlCenter
    Header $ws.Range('A6:F6')
    $ws.Rows.Item(6).RowHeight = 22
    BandRows $ws 7 20 'F'
    Border $ws.Range('A6:F20')
    $ws.Range('D7:D20').NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00'
    $ws.Range('E7:E20').HorizontalAlignment = $xlCenter
    for ($r=7; $r -le 20; $r++) {
        if ($ws.Cells.Item($r,5).Text -eq 'Pago') { $ws.Cells.Item($r,5).Interior.Color = (Color 226 239 218); $ws.Cells.Item($r,5).Font.Color = (Color 0 97 0); $ws.Cells.Item($r,5).Font.Bold = $true }
    }
    $ws.Columns.Item('A').ColumnWidth = 13
    $ws.Columns.Item('B').ColumnWidth = 10
    $ws.Columns.Item('C').ColumnWidth = 28
    $ws.Columns.Item('D').ColumnWidth = 15
    $ws.Columns.Item('E').ColumnWidth = 13
    $ws.Columns.Item('F').ColumnWidth = 30
    foreach ($rangeAddress in @('C7:C20','F7:F20')) { $ws.Range($rangeAddress).WrapText = $true }
    $ws.Activate(); $excel.ActiveWindow.SplitRow = 6; $excel.ActiveWindow.FreezePanes = $true

    $ws = $wb.Worksheets.Item('Extras')
    $ws.Range('A1:H1').Merge()
    Title $ws.Range('A1:H1')
    $ws.Rows.Item(1).RowHeight = 28
    SummaryLabel $ws.Range('A3:H3')
    SummaryValue $ws.Range('A4:H4')
    Header $ws.Range('A6:H6')
    $ws.Rows.Item(6).RowHeight = 22
    BandRows $ws 7 50 'H'
    Border $ws.Range('A6:H50')
    $ws.Range('D7:D50').NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00'
    $ws.Range('E7:E50').HorizontalAlignment = $xlCenter
    for ($r=7; $r -le 50; $r++) {
        if ($ws.Cells.Item($r,5).Text -eq 'Pago') { $ws.Cells.Item($r,5).Interior.Color = (Color 226 239 218); $ws.Cells.Item($r,5).Font.Color = (Color 0 97 0); $ws.Cells.Item($r,5).Font.Bold = $true }
    }
    $ws.Columns.Item('A').ColumnWidth = 13
    $ws.Columns.Item('B').ColumnWidth = 31
    $ws.Columns.Item('C').ColumnWidth = 16
    $ws.Columns.Item('D').ColumnWidth = 14
    $ws.Columns.Item('E').ColumnWidth = 13
    $ws.Columns.Item('F').ColumnWidth = 19
    $ws.Columns.Item('G').ColumnWidth = 20
    $ws.Columns.Item('H').ColumnWidth = 42
    foreach ($rangeAddress in @('B7:B50','H7:H50')) { $ws.Range($rangeAddress).WrapText = $true }
    $ws.Activate(); $excel.ActiveWindow.SplitRow = 6; $excel.ActiveWindow.FreezePanes = $true

    $ws = $wb.Worksheets.Item('Empréstimos e Pessoal')
    Title $ws.Range('A1:L1')
    $ws.Rows.Item(1).RowHeight = 30
    SummaryLabel $ws.Range('A3:H3')
    SummaryValue $ws.Range('A4:H4')
    Header $ws.Range('A6:G6')
    Header $ws.Range('I6:L6')
    Header $ws.Range('A7:G7')
    Header $ws.Range('A13:I13')
    Header $ws.Range('A14:I14')
    $ws.Range('A6:L14').Font.Size = 10
    $ws.Range('A8:G10').Interior.Color = (Color 248 250 252)
    $ws.Range('I7:K10').Interior.Color = (Color 248 250 252)
    $ws.Range('L7:L10').Interior.Color = (Color 255 242 204)
    $ws.Range('L7:L10').Font.Color = 16711680
    $ws.Range('L7:L10').Font.Bold = $true
    BandRows $ws 15 86 'I'
    Border $ws.Range('A7:G10')
    Border $ws.Range('I7:L10')
    Border $ws.Range('A14:I86')
    $ws.Range('A14:I14').WrapText = $true
    $ws.Rows.Item(14).RowHeight = 30
    $ws.Range('A15:A86').HorizontalAlignment = $xlCenter
    $ws.Range('B15:I86').HorizontalAlignment = $xlRight
    $ws.Range('A88:I88').Interior.Color = (Color 242 246 250)
    $ws.Range('A88:I88').Font.Color = (Color 89 89 89)
    $ws.Range('A88:I88').Font.Italic = $true
    $ws.Activate(); $excel.ActiveWindow.SplitRow = 14; $excel.ActiveWindow.FreezePanes = $true

    $wb.SaveAs($outputPath, $xlOpenXMLWorkbook)
}
finally {
    if ($wb) { $wb.Close($false) }
    if ($excel) { $excel.Quit() }
    if ($ws) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($ws) }
    if ($wb) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($wb) }
    if ($excel) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($excel) }
    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
}
