#Include "Totvs.ch"

/*/{Protheus.doc} 02_clPessoa
(long_description)
@type user function
@author Fernando
@since 22/10/2025
/*/
User Function 02_clPessoa()
    Local oPessoa
    Local cNome := "Fernando Rodrigues"
    Local dNascimento := sToD("19850330")

    oPessoa := zPessoa():New(cNome,dNascimento)

    oPessoa:MostraIdade()
Return 
