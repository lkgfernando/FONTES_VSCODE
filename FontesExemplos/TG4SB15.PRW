#include "protheus.ch"
#include "totvs.ch"
#include "topconn.ch"
#include "fileio.ch"

User Function TG4SB15()
    Local cDiret      := ""
    Local cTitulo     := "Importação de Atualizações SB1 + SB5"
    Local aTexto      := {}
    Local aBotoes     := {}
    Local nContinua   := 0
    Local nLinha      := 0
    Local nAtualSB1   := 0
    Local nAtualSB5   := 0
    Local nIgnSB1     := 0
    Local nIgnSB5     := 0
    Local cLinha      := ""
    Local aCampos     := {}
    Local aDados      := {}
    Local cCodProd := AllTrim(aDados[nLinha,1])

    aAdd(aTexto, "Esta rotina atualiza dados das tabelas SB1 e SB5 com base em um arquivo CSV (.csv). Deseja continuar?")
    aAdd(aBotoes, {1, .T., {|| nContinua := 1, FechaBatch()} })
    aAdd(aBotoes, {2, .T., {|| nContinua := 2, FechaBatch()} })
    FormBatch(cTitulo, aTexto, aBotoes)

    If nContinua == 2
        Return
    EndIf

    // Seleciona o CSV
    cDiret := TFileDialog('*.csv','Selecione o arquivo CSV',0,'C:\TOTVS\',.F.,nOR(GETF_LOCALHARD, GETF_NETWORKDRIVE))

    If Empty(cDiret)
        ApMsgStop("Nenhum arquivo selecionado.", "Aviso")
        Return
    EndIf

    // Abre o arquivo CSV
    FT_FUSE(cDiret)
    FT_FGOTOP()

    // Lê cabeçalho
    If !FT_FEOF()
        cLinha := FT_FREADLN()
        aCampos := Separa(cLinha,";",.T.)
    EndIf

    // Lê as linhas de dados
    While !FT_FEOF()
        cLinha := FT_FREADLN()
        If !Empty(AllTrim(cLinha))
            AAdd(aDados, Separa(cLinha,";",.T.))
        EndIf
    EndDo
    FT_FUSE() // fecha

    // Inicia transação
    Begin Transaction
        ProcRegua(Len(aDados))
        For nLinha := 1 To Len(aDados)
            IncProc("Processando linha " + cValToChar(nLinha) + " de " + cValToChar(Len(aDados)))

            // Campos SB1
           
            If Empty(cCodProd)
                Loop
            EndIf

            // --- Atualiza SB1 ---
            dbSelectArea("SB1")
            dbSetOrder(1) 
            If SB1->(DbSeek(xFilial("SB1") + cCodProd))
                Reclock("SB1", .F.)
                SB1->B1_DESC     := AllTrim(aDados[nLinha,2])
                SB1->B1_ESPECIF  := AllTrim(aDados[nLinha,3])
                SB1->B1_XAKAFLE  := AllTrim(aDados[nLinha,4])
                SB1->B1_TIPO     := AllTrim(aDados[nLinha,5])
                SB1->B1_UM       := AllTrim(aDados[nLinha,6])
                SB1->B1_LOCPAD   := AllTrim(aDados[nLinha,7])
                SB1->B1_GRUPO    := AllTrim(aDados[nLinha,8])
                SB1->B1_SEGUM    := AllTrim(aDados[nLinha,9])
                SB1->B1_CONV     := Val(aDados[nLinha,10])
                SB1->B1_TIPCONV  := AllTrim(aDados[nLinha,11])
                SB1->B1_PESO     := Val(aDados[nLinha,12])
                SB1->B1_PESBRU   := Val(aDados[nLinha,13])
                SB1->B1_RASTRO   := AllTrim(aDados[nLinha,14])
                SB1->B1_LOCALIZ  := AllTrim(aDados[nLinha,15])
                SB1->B1_SOBERD   := AllTrim(aDados[nLinha,16])
                SB1->(MsUnlock())
                nAtualSB1++
            Else
                nIgnSB1++
            EndIf

            // --- Atualiza SB5 ---
            dbSelectArea("SB5")
            dbSetOrder(1) // B5_FILIAL + B5_COD
            If SB5->(DbSeek(xFilial("SB5") + cCodProd))
                Reclock("SB5", .F.)
                SB5->B5_CEME     := AllTrim(aDados[nLinha,17])
                SB5->B5_XCONV    := Val(aDados[nLinha,18])
                SB5->B5_XESPEC   := AllTrim(aDados[nLinha,19])
                SB5->B5_ESPESS   := Val(aDados[nLinha,20])
                SB5->B5_LARG     := Val(aDados[nLinha,21])
                SB5->B5_COMPR    := Val(aDados[nLinha,22])
                SB5->B5_XCOR     := AllTrim(aDados[nLinha,23])
                SB5->B5_XBRILHO  := AllTrim(aDados[nLinha,24])
                SB5->B5_XTPACAB  := AllTrim(aDados[nLinha,25])
                SB5->(MsUnlock())
                nAtualSB5++
            Else
                nIgnSB5++
            EndIf
        Next nLinha
    End Transaction

    // Mostra resumo final
    ApMsgInfo( ;
        "Processo concluído com sucesso!" + CRLF + ;
        "Produtos SB1 atualizados: " + cValToChar(nAtualSB1) + CRLF + ;
        "Produtos SB1 ignorados: " + cValToChar(nIgnSB1) + CRLF + ;
        "Produtos SB5 atualizados: " + cValToChar(nAtualSB5) + CRLF + ;
        "Produtos SB5 ignorados: " + cValToChar(nIgnSB5), ;
        "Resumo da Importação" )

Return
