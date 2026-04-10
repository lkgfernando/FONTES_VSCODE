#Include "Totvs.ch"


/*/{Protheus.doc} 03Dialog
(long_description)
@type user function
@author Fernando Rodrigues
@since 04/11/2025
/*/
User Function 03Dialog()
    Local aArea := fwGetArea()

    fDialogMs()
    fDialogT()
    fDialogFw()

    fwRestArea(aArea)
Return 


/*/{Protheus.doc} fDialogMs
    (long_description)

/*/
Static Function fDialogMs()
    Local oDlgAux
    Local nJanAltu       := 200
    Local nJanLarg      := 400
    Local cJanTitulo    := 'Tela usando MsDialog'

    DEFINE MSDIALOG oDlgAux TITLE cJanTitulo FROM 000,000 TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

    ACTIVATE MSDIALOG oDlgAux CENTERED

Return


/*/{Protheus.doc} fDialogT
    (long_description)

/*/
Static Function fDialogT()
    Local oDlgAux
    Local nJanAltu      := 200
    Local nJanLarg      := 400
    Local lDimPixel     := .T.
    Local lCentraliz    := .T.
    Local bBlocoIni     := {||}
    Local cJanTitulo    := "Tela usando TDialog"

    oDlgAux := TDialog():New(0, 0, nJanAltu, nJanLarg, cJanTitulo, , , , , ,/*nCordeFundo*/, , , lDimPixel)

    oDlgAux:Activate(, , , lCentraliz, , ,bBlocoIni)

Return 

/*/{Protheus.doc} fDialogFW
    (long_description)
/*/
Static Function fDialogFW()
    Local oDlgAux
    Local nJanAltu      := 100
    Local nJanLarg      := 200
    Local bBlocoTst     := {||fwAlertInfo("Clicou no botao escrito 'Teste'", "Botao Teste")}
    Local cJanTitulo    := "Tela usando fwDialogModal"

    oDlgAux     := fwDialogModal():New()
    oDlgAux:SetTitle(cJanTitulo)
    oDlgAux:SetSize(nJanAltu, nJanLarg)
    oDlgAux:EnableFormBar(.T.)
    oDlgAux:CreateDialog()
    oDlgAux:CreateFormBar()
    oDlgAux:AddButton("Teste", bBlocoTst, "Teste", , .T., .F., .T.,)

    oDlgAux:Activate()

Return 
