'================================================================================
' PONTO DE ENTRADA: Main_BNATF
' Orquestra as correções textuais básicas não-AI no documento informado.
'================================================================================
Public Sub Main_BNATF(doc As Document)
    On Error GoTo ErrorHandler

    ReplaceLastWordFirstLine doc ' Substituição da última palavra da primeira linha
'    ApplyStandardReplacements doc ' Substituições padrão

    Exit Sub

ErrorHandler:
    MsgBox "Erro ao executar as correções textuais: " & Err.Description, vbCritical, "Erro"
End Sub

'--------------------------------------------------------------------------------
' SUBROTINA: ReplaceLastWordFirstLine
' Finalidade: Substitui a última palavra da primeira linha por "$NUMERO$/$ANO$".
'--------------------------------------------------------------------------------
Private Sub ReplaceLastWordFirstLine(doc As Document)
    On Error Resume Next

    If doc.Paragraphs.Count = 0 Then Exit Sub

    Dim para As Paragraph
    Set para = doc.Paragraphs(1)
    Dim paraText As String
    paraText = Trim(Replace(para.Range.Text, vbCr, ""))

    If Len(paraText) = 0 Then Exit Sub

    Dim words() As String
    words = Split(paraText, " ")

    If UBound(words) >= 0 Then
        words(UBound(words)) = "$NUMERO$/$ANO$"
        paraText = Join(words, " ")
        para.Range.Text = paraText & vbCr
    End If
End Sub

'--------------------------------------------------------------------------------
' SUBROTINA: ApplyStandardReplacements
' Realiza substituições de texto no documento com base em padrões predefinidos.
'--------------------------------------------------------------------------------
Private Sub ApplyStandardReplacements(doc As Document)
    On Error Resume Next

    Dim replacements As Variant
    replacements = Array( _
        Array("[Dd][´`][Oo]este", "d'Oeste", True) _
        )

    Dim i As Integer
    For i = LBound(replacements) To UBound(replacements)
        With doc.Content.Find
            .ClearFormatting
            .Replacement.ClearFormatting
            .Text = replacements(i)(0)
            .Replacement.Text = replacements(i)(1)
            .MatchWildcards = replacements(i)(2)
            .Execute Replace:=wdReplaceAll
        End With
    Next i
End Sub

'--------------------------------------------------------------------------------
' SUBROTINA: FormatJustificativaLine
' Formata qualquer linha que contenha unicamente "justificativa" (qualquer caixa).
'--------------------------------------------------------------------------------
Private Sub FormatJustificativaLine(doc As Document)
    On Error Resume Next

    Dim para As Paragraph
    Dim paraText As String

    For Each para In doc.Paragraphs
        paraText = Trim(para.Range.Text)
        If LCase(paraText) = "justificativa" Or LCase(paraText) = "justificativas" Then
            With para.Range
                .Font.Bold = True
                .ParagraphFormat.Alignment = wdAlignParagraphCenter
                .ParagraphFormat.LeftIndent = 0
                .ParagraphFormat.RightIndent = 0
                .ParagraphFormat.FirstLineIndent = 0
            End With
        End If
    Next para
End Sub

'--------------------------------------------------------------------------------
' SUBROTINA: FormatAnexoLine
' Formata qualquer linha que contenha unicamente "anexo" ou "anexos" (qualquer caixa).
'--------------------------------------------------------------------------------
Private Sub FormatAnexoLine(doc As Document)
    On Error Resume Next

    Dim para As Paragraph
    Dim paraText As String

    For Each para In doc.Paragraphs
        paraText = Trim(para.Range.Text)
        If LCase(paraText) = "anexo" Or LCase(paraText) = "anexos" Then
            With para.Range
                .Font.Bold = True
                .ParagraphFormat.LeftIndent = 0
                .ParagraphFormat.RightIndent = 0
                .ParagraphFormat.FirstLineIndent = 0
            End With
        End If
    Next para
End Sub

