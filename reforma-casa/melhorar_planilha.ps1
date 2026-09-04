$ErrorActionPreference = 'Stop'

$sourceFolder = 'C:\Users\Performance\OneDrive\Documentos\VSCODE\reforma-casa'
$inputPath = (Get-ChildItem -LiteralPath $sourceFolder -Filter '*.xlsx' | Where-Object { $_.Name -notlike '*Controle Financeiro*' } | Select-Object -First 1).FullName
$outputPath = Join-Path $sourceFolder 'Controle Financeiro - Reforma Casa 367 - Final.xlsx'

$xlOpenXMLWorkbook = 51
$xlCellValue = 1
$xlExpression = 2
$xlYes = 1
$xlLine = 4
$xlSrcRange = 1
$xlColumns = 2

function Set-HeaderStyle($range, $fillColor) {
    $range.Interior.Color = $fillColor
    $range.Font.Bold = $true
    $range.Font.Color = 16777215
    $range.HorizontalAlignment = -4108
    $range.VerticalAlignment = -4108
}

$excel = $null
$wb = $null
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
    $wb = $excel.Workbooks.Open($inputPath)

    foreach ($sheet in @($wb.Worksheets | Where-Object { $_.Name -eq 'Empréstimos e Pessoal' })) {
        $sheet.Delete()
    }

    $ws = $wb.Worksheets.Add()
    $ws.Name = 'Empréstimos e Pessoal'
    $ws.DisplayPageBreaks = $false
    $ws.Activate()
    $excel.ActiveWindow.DisplayGridlines = $false

    $ws.Range('A1:L1').Merge()
    $ws.Range('A1').Value2 = 'CONTROLE FINANCEIRO — REFORMA CASA 367'
    $ws.Range('A1').Interior.Color = 6579300
    $ws.Range('A1').Font.Color = 16777215
    $ws.Range('A1').Font.Bold = $true
    $ws.Range('A1').Font.Size = 16
    $ws.Range('A1').HorizontalAlignment = -4108
    $ws.Range('A1').VerticalAlignment = -4108
    $ws.Rows.Item(1).RowHeight = 28

    $ws.Range('A3').Value2 = 'Total emprestado'
    $ws.Range('C3').Value2 = 'Parcelas/mês'
    $ws.Range('E3').Value2 = 'Total a pagar'
    $ws.Range('G3').Value2 = 'Prazo máximo'
    $ws.Range('A4').Formula = '=SUM(C8:C10)'
    $ws.Range('C4').Formula = '=SUM(E8:E10)'
    $ws.Range('E4').Formula = '=SUM(F8:F10)'
    $ws.Range('G4').Formula = '=MAX(D8:D10)'
    foreach ($cell in @('A3','C3','E3','G3')) { Set-HeaderStyle $ws.Range($cell) 11776947 }
    foreach ($cell in @('A4','C4','E4','G4')) {
        $ws.Range($cell).Interior.Color = 15132390
        $ws.Range($cell).Font.Bold = $true
        $ws.Range($cell).Font.Size = 13
        $ws.Range($cell).HorizontalAlignment = -4152
    }
    foreach ($cell in @('A4','C4','E4')) { $ws.Range($cell).NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00' }
    $ws.Range('G4').NumberFormatLocal = '0 "meses"'

    $ws.Range('A6:G6').Merge()
    $ws.Range('A6').Value2 = 'EMPRÉSTIMOS CONTRATADOS'
    Set-HeaderStyle $ws.Range('A6:G6') 10040115

    $loanHeaders = @('Empréstimo','Titular','Valor inicial','Parcelas','Valor da parcela','Total a pagar','Encargos estimados')
    for ($c = 1; $c -le $loanHeaders.Count; $c++) { $ws.Cells.Item(7,$c).Value2 = $loanHeaders[$c-1] }
    Set-HeaderStyle $ws.Range('A7:G7') 10040115
    $loans = @(
        @('Reforma Casa Brasil','Você',50000,72,950,'',''),
        @('Reforma Casa Brasil','Namorada',36000,72,705,'',''),
        @('Sicoob Credipéu','Você',80000,48,2531.71,'','')
    )
    for ($r = 0; $r -lt $loans.Count; $r++) { for ($c = 0; $c -lt $loans[$r].Count; $c++) { $ws.Cells.Item(8+$r,1+$c).Value2 = [string]$loans[$r][$c] } }
    $ws.Range('F8').Formula = '=D8*E8'
    $ws.Range('F8:F10').FillDown()
    $ws.Range('G8').Formula = '=F8-C8'
    $ws.Range('G8:G10').FillDown()
    foreach ($rangeAddress in @('C8:C10','E8:G10')) { $ws.Range($rangeAddress).NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00' }
    $ws.Range('C8:E10').Font.Color = 16711680
    $ws.Range('F8:G10').Font.Color = 0
    $ws.Range('A7:G10').Borders.LineStyle = 1
    $ws.Range('A8:G10').Interior.Color = 16448250

    $ws.Range('I6:L6').Merge()
    $ws.Range('I6').Value2 = 'CAMPOS PESSOAIS (EDITE EM AZUL)'
    Set-HeaderStyle $ws.Range('I6:L6') 10040115
    $personalLabels = @('Renda mensal padrão','Gastos pessoais mensais','Reserva pessoal atual','Observação pessoal')
    for ($r = 0; $r -lt $personalLabels.Count; $r++) { $ws.Cells.Item(7+$r,9).Value2 = $personalLabels[$r] }
    $ws.Range('L7').Value2 = 0
    $ws.Range('L8').Value2 = 0
    $ws.Range('L9').Value2 = 0
    $ws.Range('L10').Value2 = ''
    $ws.Range('I7:K10').Merge($true)
    $ws.Range('L7:L9').NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00'
    $ws.Range('L7:L10').Interior.Color = 65535
    $ws.Range('L7:L10').Font.Color = 16711680
    $ws.Range('L7:L10').Font.Bold = $true
    $ws.Range('I7:L10').Borders.LineStyle = 1
    $ws.Range('I11:L11').Merge()
    $ws.Range('I11').Value2 = 'Preencha renda e gastos para acompanhar sua sobra mensal.'
    $ws.Range('I11').Font.Italic = $true
    $ws.Range('I11').Font.Color = 8421504

    $ws.Range('A13:I13').Merge()
    $ws.Range('A13').Value2 = 'ACOMPANHAMENTO MENSAL — parcelas, despesas pessoais e saldo disponível'
    Set-HeaderStyle $ws.Range('A13:I13') 10040115
    $monthlyHeaders = @('Mês','Casa Brasil','Casa Brasil (namorada)','Sicoob Credipéu','Total empréstimos','Renda pessoal','Gastos pessoais','Sobra do mês','Parcelas restantes')
    for ($c = 1; $c -le $monthlyHeaders.Count; $c++) { $ws.Cells.Item(14,$c).Value2 = $monthlyHeaders[$c-1] }
    Set-HeaderStyle $ws.Range('A14:I14') 10040115

    for ($r = 15; $r -le 86; $r++) {
        $monthIndex = $r - 15
        $ws.Cells.Item($r,1).Formula = ('=DATE(2026,{0},1)' -f (8 + $monthIndex))
        $ws.Cells.Item($r,2).Formula = "=IF(ROW()-14<=`$D`$8,`$E`$8,0)"
        $ws.Cells.Item($r,3).Formula = "=IF(ROW()-14<=`$D`$9,`$E`$9,0)"
        $ws.Cells.Item($r,4).Formula = "=IF(ROW()-14<=`$D`$10,`$E`$10,0)"
        $ws.Cells.Item($r,5).Formula = ('=SUM(B{0}:D{0})' -f $r)
        $ws.Cells.Item($r,6).Formula = '=$L$7'
        $ws.Cells.Item($r,7).Formula = '=$L$8'
        $ws.Cells.Item($r,8).Formula = ('=F{0}-G{0}-E{0}' -f $r)
        $ws.Cells.Item($r,9).Formula = "=MAX(0,(`$D`$8-(ROW()-14))*`$E`$8)+MAX(0,(`$D`$9-(ROW()-14))*`$E`$9)+MAX(0,(`$D`$10-(ROW()-14))*`$E`$10)"
    }
    $ws.Range('A15:A86').NumberFormatLocal = 'mmm/aaaa'
    $ws.Range('B15:I86').NumberFormatLocal = 'R$ #.##0,00;[Vermelho]-R$ #.##0,00'
    $ws.Range('A14:I86').Borders.LineStyle = 1
    $ws.Range('A15:I86').Interior.Color = 16777215
    for ($r = 15; $r -le 86; $r += 2) { $ws.Range("A$r:I$r").Interior.Color = 15921906 }

    $ws.Range('A88:I88').Merge()
    $ws.Range('A88').Value2 = 'Nota: “Parcelas restantes” representa a soma das parcelas futuras previstas. O saldo oficial do banco pode diferir por juros, antecipações ou renegociações.'
    $ws.Range('A88').Font.Italic = $true
    $ws.Range('A88').Font.Color = 8421504
    $ws.Range('A88').WrapText = $true
    $ws.Rows.Item(88).RowHeight = 32

    $ws.Range('A7:G10').AutoFilter()
    $ws.Range('A14:I86').AutoFilter()
    $ws.Range('A1:L88').Font.Name = 'Aptos'
    $ws.Columns.Item('A').ColumnWidth = 18
    $ws.Columns.Item('B').ColumnWidth = 15
    $ws.Columns.Item('C').ColumnWidth = 23
    $ws.Columns.Item('D').ColumnWidth = 13
    $ws.Columns.Item('E').ColumnWidth = 18
    $ws.Columns.Item('F').ColumnWidth = 16
    $ws.Columns.Item('G').ColumnWidth = 18
    $ws.Columns.Item('H').ColumnWidth = 17
    $ws.Columns.Item('I').ColumnWidth = 25
    $ws.Columns.Item('J').ColumnWidth = 2
    $ws.Columns.Item('K').ColumnWidth = 2
    $ws.Columns.Item('L').ColumnWidth = 22
    $ws.Range('A1:L88').VerticalAlignment = -4108
    $ws.Range('A7:G10').HorizontalAlignment = -4108
    $ws.Range('B15:I86').HorizontalAlignment = -4152

    $chart = $ws.ChartObjects().Add(720, 290, 520, 250)
    $chart.Chart.SetSourceData($ws.Range('A14:E38'), $xlColumns)
    $chart.Chart.ChartType = $xlLine
    $chart.Chart.HasTitle = $true
    $chart.Chart.ChartTitle.Text = 'Parcelas mensais previstas'
    $chart.Chart.HasLegend = $true
    $chart.Chart.Legend.Position = -4107
    $chart.Chart.Axes(2).TickLabels.NumberFormatLocal = 'R$ #.##0'

    $ws.Activate()
    $excel.ActiveWindow.SplitRow = 14
    $excel.ActiveWindow.FreezePanes = $true

    $wb.SaveAs($outputPath, $xlOpenXMLWorkbook)
}
finally {
    if ($wb) { $wb.Close($false) }
    if ($excel) { $excel.Quit() }
    if ($ws) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($ws) }
    if ($wb) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($wb) }
    if ($excel) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($excel) }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
