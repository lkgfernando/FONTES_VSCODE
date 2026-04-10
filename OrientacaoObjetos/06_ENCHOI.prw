#Include "Totvs.ch"

/*/{Protheus.doc} 06Enchoi
(long_description)
@type user function
@author Fernando Rodrigues
@since 25/11/2025
/*/
User Function 06Enchoi()
    Local nJanAltu      := 200
    Local nJanLarg      := 600
    Local lDimPixels    := .T.
    Local lCentraliz    := .T.
    Local bBlocoOk      := {|| lOk := .T., oDlgAux:End()}
    Local bBlocoCan     := {|| lOk := .F., oDlgAux:End()}
    Local aOutrasAc     := { {"BMP", {|| Alert("Cliquei no 1")}, "Botao 1"}, {"BMP", {|| Alert("Cliquei no 2")}, "Botao 2"} }
    Local bBlocoIni     := {|| EnchoiceBar(oDlgAux, bBlocoOk, bBlocoCan, ,aOutrasAc)}
    Local cJanTitulo    := "Tela usada TDialog com EnchoiceBar"

    Private oDlgAux
    Private lOk         := .F.

    oDlgAux     := tDialog():new(0, 0, nJanAltu, nJanLarg, cJanTitulo, , , , , ,/*nCorFundo*/, , ,lDimPixels)

    oDlgAux:Activate(, , ,lCentraliz, , , bBlocoIni)

    If lOk
        fwAlertSuccess("Foi clicado no botão Confirmar", "OK")
    EndIf   
Return 
