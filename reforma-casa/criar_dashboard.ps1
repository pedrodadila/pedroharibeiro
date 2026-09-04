$ErrorActionPreference = 'Stop'

$sourceFolder = 'C:\Users\Performance\OneDrive\Documentos\VSCODE\reforma-casa'
$inputPath = Join-Path $sourceFolder 'Controle Financeiro - Reforma Casa 367 - Padronizada.xlsx'
$outputPath = Join-Path $sourceFolder 'Controle Financeiro - Reforma Casa 367 - Dashboard Final.xlsx'
$xlOpenXMLWorkbook = 51
$xlCenter = -4108
$xlRight = -4152
$xlLine = 4
$xlDoughnut = -4120
$xlColumns = 2

function Color($r,$g,$b) { return $r + ($g * 256) + ($b * 65536) }
function Title($range) {
    $range.Interior.Color = (Color 31 78 121)
    $range.Font.Color = 16777215
    $range.Font.Bold = $true
    $range.Font.Size = 18
    $range.HorizontalAlignment = $xlCenter
    $range.VerticalAlignment = $xlCenter
}
function Section($range) {
    $range.Interior.Color = (Color 47 117 181)
    $range.Font.Color = 16777215
    $range.Font.Bold = $true
    $range.HorizontalAlignment = $xlCenter
}
function Header($range) {
    $range.Interior.Color = (Color 47 117 181)
    $range.Font.Color = 16777215
    $range.Font.Bold = $true
    $range.HorizontalAlignment = $xlCenter
    $range.VerticalAlignment = $xlCenter
}
function CardLabel($range) {
    $range.Interior.Color = (Color 221 235 247)
    $range.Font.Color = (Color 31 78 121)
    $range.Font.Bold = $true
    $range.HorizontalAlignment = $xlCenter
    $range.WrapText = $true
}
function CardValue($range) {
    $range.Interior.Color = (Color 242 246 250)
    $range.Font.Color = (Color 31 78 121)
    $range.Font.Bold = $true
    $range.Font.Size = 14
    $range.HorizontalAlignment = $xlCenter
}
function Border($range) {
    $range.Borders.LineStyle = 1
    $range.Borders.Color = (Color 217 225 242)
    $range.Borders.Weight = 2
}

$excel = $null
$wb = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $wb = $excel.Workbooks.Open($inputPath)

    foreach ($sheet in @($wb.Worksheets | Where-Object { $_.Name -eq 'Dashboard' })) { $sheet.Delete() }
    $ws = $wb.Worksheets.Add()
    $ws.Name = 'Dashboard'
    $ws.Move($wb.Worksheets.Item(1))
    $ws.Activate()
    $excel.ActiveWindow.DisplayGridlines = $false
    $ws.Range('A1:L1').Merge()
    $ws.Range('A1').Value2 = 'DASHBOARD FINANCEIRO — REFORMA CASA 367'
    Title $ws.Range('A1:L1')
    $ws.Rows.Item(1).RowHeight = 32
    $ws.Range('A2:L2').Merge()
    $ws.Range('A2').Value2 = 'Visão consolidada da obra, empréstimos e capacidade mensal de pagamento'
    $ws.Range('A2').Font.Color = (Color 89 89 89)
    $ws.Range('A2').Font.Italic = $true
    $ws.Range('A2').HorizontalAlignment = $xlCenter

    $labels = @('Orçamento estimado','Limite máximo','Total pago na obra','Saldo da obra','Total emprestado','Total a pagar','Parcelas por mês','Encargos estimados','Extras pagos','Extras pendentes','Renda mensal','Sobra no 1º mês')
    $labelCells = @('A4','D4','G4','J4','A7','D7','G7','J7','A10','D10','G10','J10')
    $valueCells = @('A5','D5','G5','J5','A8','D8','G8','J8','A11','D11','G11','J11')
    $formulas = @(
        "='Orçamento Principal'!A4", "='Orçamento Principal'!C4", "='Orçamento Principal'!D4", "='Orçamento Principal'!F4",
        "='Empréstimos e Pessoal'!A4", "='Empréstimos e Pessoal'!E4", "='Empréstimos e Pessoal'!C4", "=SUM('Empréstimos e Pessoal'!G8:G10)",
        "='Extras'!C4", "='Extras'!E4", "='Empréstimos e Pessoal'!L7", "='Empréstimos e Pessoal'!H15"
    )
    for ($i=0; $i -lt $labels.Count; $i++) {
        $ws.Range($labelCells[$i] + ':' + ([char]([int][char]$labelCells[$i][0]+1)).ToString() + $labelCells[$i].Substring(1)).Merge()
        $ws.Range($valueCells[$i] + ':' + ([char]([int][char]$valueCells[$i][0]+1)).ToString() + $valueCells[$i].Substring(1)).Merge()
        $ws.Range($labelCells[$i]).Value2 = $labels[$i]
        $ws.Range($valueCells[$i]).Formula = $formulas[$i]
        CardLabel $ws.Range($labelCells[$i] + ':' + ([char]([int][char]$labelCells[$i][0]+1)).ToString() + $labelCells[$i].Substring(1))
        CardValue $ws.Range($valueCells[$i] + ':' + ([char]([int][char]$valueCells[$i][0]+1)).ToString() + $valueCells[$i].Substring(1))
    }
    foreach ($cell in $valueCells) { $ws.Range($cell).NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00' }
    Border $ws.Range('A4:K11')
    $ws.Rows.Item(4).RowHeight = 26; $ws.Rows.Item(5).RowHeight = 28
    $ws.Rows.Item(7).RowHeight = 26; $ws.Rows.Item(8).RowHeight = 28
    $ws.Rows.Item(10).RowHeight = 26; $ws.Rows.Item(11).RowHeight = 28

    $ws.Range('A13:F13').Merge(); $ws.Range('A13').Value2 = 'LEITURA RÁPIDA'; Section $ws.Range('A13:F13')
    $quickLabels = @('Comprometimento da renda','Saldo após 12 meses','Menor sobra projetada','Prazo final das parcelas')
    $quickValues = @('=IF(H11=0,"Informe a renda pessoal",H8/H11)',"='Empréstimos e Pessoal'!I26","=MIN('Empréstimos e Pessoal'!H15:H86)","='Empréstimos e Pessoal'!G4")
    for ($i=0; $i -lt 4; $i++) {
        $row = 14 + $i
        $ws.Cells.Item($row,1).Value2 = $quickLabels[$i]
        $ws.Cells.Item($row,2).Formula = $quickValues[$i]
        $ws.Range("A$row:B$row").Interior.Color = (Color 248 250 252)
        $ws.Range("A$row").Font.Bold = $true
        $ws.Range("B$row").Font.Bold = $true
        $ws.Range("B$row").HorizontalAlignment = $xlRight
    }
    $ws.Range('B14').NumberFormatLocal = '0,0%'
    $ws.Range('B15:B16').NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00'
    $ws.Range('B17').NumberFormatLocal = '0 "meses"'
    Border $ws.Range('A14:B17')

    $ws.Range('H13:L13').Merge(); $ws.Range('H13').Value2 = 'COMPOSIÇÃO DOS EMPRÉSTIMOS'; Section $ws.Range('H13:L13')
    $ws.Range('H14').Value2 = 'Contrato'; $ws.Range('I14').Value2 = 'Valor inicial'
    $ws.Range('H15').Value2 = 'Reforma Casa Brasil'
    $ws.Range('H16').Value2 = 'Reforma Casa Brasil (namorada)'
    $ws.Range('H17').Value2 = 'Sicoob Credipéu'
    $ws.Range('I15').Formula = "='Empréstimos e Pessoal'!C8"
    $ws.Range('I16').Formula = "='Empréstimos e Pessoal'!C9"
    $ws.Range('I17').Formula = "='Empréstimos e Pessoal'!C10"
    Header $ws.Range('H14:I14')
    $ws.Range('I15:I17').NumberFormatLocal = 'R$ #.##0,00'
    Border $ws.Range('H14:I17')

    $ws.Range('A20:E20').Value2 = @('Mês','Casa Brasil','Casa Brasil (namorada)','Sicoob Credipéu','Total mensal')
    Header $ws.Range('A20:E20')
    for ($r = 21; $r -le 92; $r++) {
        $sourceRow = $r - 6
        $ws.Cells.Item($r,1).Formula = "='Empréstimos e Pessoal'!A$sourceRow"
        $ws.Cells.Item($r,2).Formula = "='Empréstimos e Pessoal'!B$sourceRow"
        $ws.Cells.Item($r,3).Formula = "='Empréstimos e Pessoal'!C$sourceRow"
        $ws.Cells.Item($r,4).Formula = "='Empréstimos e Pessoal'!D$sourceRow"
        $ws.Cells.Item($r,5).Formula = "='Empréstimos e Pessoal'!E$sourceRow"
    }
    $ws.Range('A21:A92').NumberFormatLocal = 'mmm/aaaa'
    $ws.Range('B21:E92').NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00'
    $ws.Rows('20:92').Hidden = $true

    $lineChart = $ws.ChartObjects().Add(18, 360, 500, 250)
    $lineChart.Chart.SetSourceData($ws.Range('A20:E92'), $xlColumns)
    $lineChart.Chart.ChartType = $xlLine
    $lineChart.Chart.HasTitle = $true
    $lineChart.Chart.ChartTitle.Text = 'Evolução das parcelas mensais'
    $lineChart.Chart.HasLegend = $true
    $lineChart.Chart.Legend.Position = -4107
    $lineChart.Chart.Axes(2).TickLabels.NumberFormatLocal = 'R$ #.##0'
    $lineChart.Chart.PlotVisibleOnly = $false

    $doughnutChart = $ws.ChartObjects().Add(550, 360, 390, 250)
    $doughnutChart.Chart.SetSourceData($ws.Range('H14:I17'), $xlColumns)
    $doughnutChart.Chart.ChartType = $xlDoughnut
    $doughnutChart.Chart.HasTitle = $true
    $doughnutChart.Chart.ChartTitle.Text = 'Distribuição do valor emprestado'
    $doughnutChart.Chart.HasLegend = $true
    $doughnutChart.Chart.Legend.Position = -4107
    $doughnutChart.Chart.PlotVisibleOnly = $false

    $ws.Range('A95:L95').Merge()
    $ws.Range('A95').Value2 = 'Atualize os campos em amarelo na aba “Empréstimos e Pessoal” para refletir sua renda, gastos e reserva. O dashboard será recalculado automaticamente.'
    $ws.Range('A95').Interior.Color = (Color 242 246 250)
    $ws.Range('A95').Font.Color = (Color 89 89 89)
    $ws.Range('A95').Font.Italic = $true
    $ws.Range('A95').WrapText = $true
    $ws.Rows.Item(95).RowHeight = 30

    $ws.Columns.Item('A').ColumnWidth = 20
    $ws.Columns.Item('B').ColumnWidth = 14
    $ws.Columns.Item('C').ColumnWidth = 4
    $ws.Columns.Item('D').ColumnWidth = 20
    $ws.Columns.Item('E').ColumnWidth = 14
    $ws.Columns.Item('F').ColumnWidth = 4
    $ws.Columns.Item('G').ColumnWidth = 20
    $ws.Columns.Item('H').ColumnWidth = 23
    $ws.Columns.Item('I').ColumnWidth = 18
    $ws.Columns.Item('J').ColumnWidth = 20
    $ws.Columns.Item('K').ColumnWidth = 14
    $ws.Columns.Item('L').ColumnWidth = 4
    $ws.Range('A1:L95').Font.Name = 'Aptos'
    $ws.Activate(); $excel.ActiveWindow.SplitRow = 2; $excel.ActiveWindow.FreezePanes = $true
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
