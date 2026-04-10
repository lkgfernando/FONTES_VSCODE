#Include "Totvs.ch"


/*/{Protheus.doc} zPessoa
    (long_description)
    @author Fernando
    @since 22/10/2025
    @version version
    /*/
Class zPessoa
    Data cNome
    Data dNascimento
    Data nIdade


    Method New() Constructor
    Method MostraIdade()

EndClass


/*/{Protheus.doc} MostraIdade
    (long_description)
    /*/
Method New(cNome,dNascimento) Class zPessoa
    ::cNome             := cNome
    ::dNascimento       := dNascimento
    ::nIdade            := fCalculaIdade(dNascimento)

Return 

/*/{Protheus.doc} MostraIdade
    (long_description)
    @author 
    @since 
    @version 

    /*/
Method MostraIdade() Class zPessoa
    Local cMsg      := ""

    cMsg := "A <b>pessoa</b> "+ ::cNome + " tem " + cValToChar(::nIdade) + " anos!"
    MsgInfo(cMsg,"Aten")

Return 


/*/{Protheus.doc} fCalculaIdade
    (long_description)
    @type  Static Function
    @author Fernando Rdorigues
    @since 22/10/2025
/*/
Static Function fCalculaIdade(dNascimento)
    Local nIdade := 0

    nIdade := DateDiffYear(dDataBase, dNascimento) 

Return nIdade
