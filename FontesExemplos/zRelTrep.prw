#Include 'Protheus.ch'
#Include 'Report.ch'

/*/{Protheus.doc} RPRODTR
Relatório de Produtos com Query SQL, TRCell e Linhas Tracejadas
@author Gemini
@since  01/04/2026
/*/
User Function RPRODTR()
    Local oReport
    Local oSection1
    Local cAlias := "TRBPROD"

    // 1. Criação do Objeto TReport
    oReport := TReport():New( ;
        "RPRODTR", ;
        "Relatório de Produtos", ;
        "RPRODTR", ;
        {|oRpt| ReportPrint(oRpt)}, ;
        "Relatório de Produtos Customizado" ;
    )

    // 2. Criação da Seção
    // O segundo parâmetro é o TÍTULO da seção; recuperamos pelo índice numérico depois
    oSection1 := TRSection():New(oReport, "Produtos", {cAlias})

    // 3. Habilitar linha separadora entre registros
    // SetLine(.T.) ativa a linha tracejada automática na seção
    oSection1:SetLine(.T.)

    // 4. Definição das Células (TRCell)
    TRCell():New(oSection1, "B1_COD"   , cAlias, "Código")
    TRCell():New(oSection1, "B1_DESC"  , cAlias, "Descrição")
    TRCell():New(oSection1, "B1_UM"    , cAlias, "UN")
    TRCell():New(oSection1, "B1_PESO"  , cAlias, "Peso")
    TRCell():New(oSection1, "B1_TIPO"  , cAlias, "Tipo")
    TRCell():New(oSection1, "B1_GRUPO" , cAlias, "Grupo")

    // 5. Chama a interface de impressão
    oReport:PrintDialog()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportPrint
Função de processamento da impressão do relatório
/*/
Static Function ReportPrint(oReport)
    // Recupera a seção pelo índice numérico (1 = primeira seção)
    Local oSection1 := oReport:Section(1)
    Local cAlias    := "TRBPROD"

    If oSection1 == Nil
        MsgStop("Erro: A seção 1 não foi encontrada no objeto do relatório.")
        Return
    EndIf

    // Abre a query apenas se ainda não estiver aberta
    // Correção: precedência de operador estava errada com !Select() > 0
    If Select(cAlias) == 0
        U_MontaSql(cAlias)
    EndIf

    // Início da Seção
    oSection1:Begin()

    dbSelectArea(cAlias)
    (cAlias)->(dbGoTop())

    While !(cAlias)->(Eof())

        If oReport:Cancelled()
            Break
        EndIf

        // Imprime os dados da linha atual
        // A linha tracejada é desenhada automaticamente pelo SetLine(.T.) acima
        oSection1:PrintLine()

        (cAlias)->(dbSkip())
    EndDo

    // Finaliza a Seção
    oSection1:End()

    // Fecha a query para liberar memória
    If Select(cAlias) > 0
        (cAlias)->(dbCloseArea())
    EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MontaSql
Monta e abre a query de produtos
/*/
User Function MontaSql(cAlias)
    Local cSql := ""

    cSql := " SELECT B1_COD, B1_DESC, B1_UM, B1_PESO, B1_TIPO, B1_GRUPO "
    cSql += " FROM " + RetSqlName("SB1") + " SB1 "
    cSql += " WHERE SB1.D_E_L_E_T_ = ' ' "

    MPSysOpenQuery(cSql, cAlias)

Return
