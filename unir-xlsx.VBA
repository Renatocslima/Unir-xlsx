Sub lsUnificarPlanilhas()
    On Error GoTo Sair

  Dim lUltimaColunaAtiva As Long
  Dim lUltimaLinhaAtiva As Long
  Dim lRng As Range
  Dim sPath As String
  Dim fName As String
  Dim lNomeWB As String
  Dim lIPlan As Integer
  Dim lUltimaLinhaPlanDestino As Long
   
  PlanilhaDestino = ThisWorkbook.Name
 
  sPath = Localizar_Caminho
 
  sName = Dir(sPath & "\*.xl*")
 
  Application.ScreenUpdating = False
  Application.EnableEvents = False
  Application.Calculation = xlCalculationManual
   
  Do While sName <> ""
        fName = sPath & "\" & sName
        Workbooks.Open Filename:=fName, UpdateLinks:=False
        
        lNomeWB = ActiveWorkbook.Name
        
        For lIPlan = 1 To ActiveWorkbook.Sheets.Count
            Workbooks(lNomeWB).Worksheets(lIPlan).Activate
        
            lUltimaLinhaAtiva = Cells(Rows.Count, 1).End(xlUp).Row
            lUltimaColunaAtiva = ActiveSheet.Cells(1, 5000).End(xlToLeft).Column
            
            Set lRng = Range(Cells(1, lUltimaColunaAtiva).Address)
            
            Range("A" & 1 & ":" & gfLetraColuna(lRng) & lUltimaLinhaAtiva).Select
            Selection.Copy
            
            Workbooks(PlanilhaDestino).Worksheets(1).Activate
            
            lUltimaLinhaPlanDestino = Cells(Rows.Count, 1).End(xlUp).Row
            
            If lUltimaLinhaPlanDestino > 1 Then
                lUltimaLinhaPlanDestino = Cells(Rows.Count, 1).End(xlUp).Row + 1
            End If
            
            Range("A" & lUltimaLinhaPlanDestino).Select
            
            ActiveSheet.Paste
            Application.CutCopyMode = False
        Next lIPlan
        
        Workbooks(lNomeWB).Close SaveChanges:=False
        sName = Dir()
  Loop
  
  MsgBox "Planilhas unificadas!"

Sair:
  Application.ScreenUpdating = True
  Application.EnableEvents = True
  Application.Calculation = xlCalculationAutomatic
End Sub

Function gfLetraColuna(ByVal rng As Range) As String
    Dim lTexto() As String
    
    lTexto = Split(rng.Address, "$")
    
    gfLetraColuna = lTexto(1)
End Function

Public Function Localizar_Caminho() As String

    Dim strCaminho As String
    
    With Application.FileDialog(msoFileDialogFolderPicker)
        
        'Permitir mais de uma pasta
        .AllowMultiSelect = False
        
        'Mostrar janela
        .Show
        
        If .SelectedItems.Count > 0 Then
            strCaminho = .SelectedItems(1)
        End If
    
    End With
    
    'Atribuir caminho a variável
    Localizar_Caminho = strCaminho

End Function
