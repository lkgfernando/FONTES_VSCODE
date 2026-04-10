//Bibliotecas
#Include "Totvs.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY 3 //Opção disponível somente a partir da versão 1.6.2 da TOTVS Printer
#Define IMP_SPOOL   2

//Variável de setup que será acionada na primeira impressão
Static oSetupRel

/*/{Protheus.doc} User Function zEtiPcp
Etiqueta de Materia prima
@author Fernando Jose Rodrigues
@since 30/09/2025
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function zEtiPcp()
	Local aArea := FWGetArea()
	
	//Faz um laço infinito
	While .T.
		DbSelectArea('SC2')
		SC2->(DbSetOrder(1))
		
		//Pede para o usuário informar a chave
		cPesquisa := FWInputBox('Digite a chave de pesquisa da tabela SC2:')
		
		//Se tiver vazia, sai do laço
		If Empty(cPesquisa)
			Exit
			
		//Senão
		Else
			//Tenta posicionar no registro
			If SC2->(MsSeek(FWxFilial('SC2') + cPesquisa))
				fImprEtq()
			Else
				FWAlertError('Não foi encontrado informações com a chave de pesquisa!', 'Falha')
			EndIf
		EndIf
	EndDo
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fImprEtq
Faz a impressão da etiqueta da zEtiPcp
@author Fernando Jose Rodrigues
@since 30/09/2025
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fImprEtq()
	Local aArea         := FWGetArea()
	Local oPrint
	Local nMiliAltur    := 100
	Local nMiliLargu    := 50
	Local nAlturPx		:= nMiliAltur * 2.95
	Local nLarguPx		:= nMiliLargu * 2.95
	Local cLogo         := ''
	Local lNegrito      := .T.
	Local lSublinhado   := .T.
	Local lItalico      := .T.
	Local cNomeFont     := 'Arial'
	Local oFontDadN     := TFont():New(cNomeFont, /*uPar2*/, -15, /*uPar4*/,     lNegrito, /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, ! lSublinhado, ! lItalico)
	Local oFontDad      := TFont():New(cNomeFont, /*uPar2*/, -15, /*uPar4*/,   ! lNegrito, /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, ! lSublinhado, ! lItalico)
	Local oFontMin      := TFont():New(cNomeFont, /*uPar2*/, -11, /*uPar4*/,     lNegrito, /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, ! lSublinhado, ! lItalico)
	Local nCorDestaq    := RGB(11, 1, 1)
	Local nColSepara    := 030
	Local nLinAtu       := 030
	Local nLargurTxt    := nLarguPx - (nColSepara + 3)
	Local cTexto        := ''
	//Dados da empresa
	Local aSM0Data    := FWSM0Util():GetSM0Data(, cFilAnt, {'M0_NOMECOM', 'M0_NOME', 'M0_TEL', 'M0_CGC'})
	Local cEmpNome    := Iif(Empty(aSM0Data[01][2]), Alltrim(aSM0Data[02][2]), Alltrim(aSM0Data[01][2]))
	Local cEmpTel     := aSM0Data[03][2]
	Local cEmpCnpj    := Alltrim(Transform(aSM0Data[04][2],'@R 99.999.999/9999-99'))
	
	//Criando a impressão
	oPrint := FWMSPrinter():New(;
		'ETQ_AUTUMN',;  // cFilePrintert
		,;              // nDevice
		.F.,;           // lAdjustToLegacy
		GetTempPath(),; // cPathInServer
		.T.;            // lDisabeSetup
	)
	
	//Se ainda não tiver configuração de Setup
	While ValType(oSetupRel) == 'U'
		fConfImpr()
	EndDo
	
	//Puxa as definições da impressora
	If oSetupRel:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		oPrint:nDevice := IMP_SPOOL
		oPrint:cPrinter := oSetupRel:aOptions[PD_VALUETYPE]
	Endif
	
	//Inicia a página
	oPrint:StartPage()
	
	//Faz um quadro informando os limites em pixels da etiqueta
	oPrint:Box(0, 0, nAlturPx, nLarguPx)
	
	//Imprime o logo na esquerda e faz uma barra separando
	oPrint:SayBitmap(001, 001, cLogo, 025, 025)
	oPrint:Line(0,        nColSepara, nAlturPx, nColSepara, nCorDestaq, '-2')
	oPrint:Line(nLinAtu,  0,          nLinAtu,  nLarguPx,   nCorDestaq, '-2')
	nLinAtu += 15
	
	//Imprime o título em destaque
	oPrint:SayAlign(007, nColSepara + 3, 'Material da OP', oFontDadN, nLargurTxt, 20, nCorDestaq, PAD_LEFT, /*nAlignVert*/)
	
	//Textos da Esquerda referente a Empresa
	oPrint:Say(nLinAtu, nColSepara - 10, cEmpNome,           oFontMin, /*nWidth*/, nCorDestaq, 90)
	oPrint:Say(nLinAtu, nColSepara - 18, 'Fone: ' + cEmpTel, oFontMin, /*nWidth*/, nCorDestaq, 90)
	oPrint:Say(nLinAtu, nColSepara - 26, cEmpCnpj,           oFontMin, /*nWidth*/, nCorDestaq, 90)
	
	
	//Começa a impressão dos campos
	cTexto  := Alltrim(RetTitle('C2_NUM')) + ': ' + cValToChar(SC2->C2_NUM)
	oPrint:SayAlign(nLinAtu, nColSepara + 3, cTexto, oFontDad, nLargurTxt, 15, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
	nLinAtu += 15
	
	cTexto  := Alltrim(RetTitle('C2_PRODUTO')) + ': ' + cValToChar(SC2->C2_PRODUTO)
	oPrint:SayAlign(nLinAtu, nColSepara + 3, cTexto, oFontDad, nLargurTxt, 15, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
	nLinAtu += 15
	
	cTexto  := Alltrim(RetTitle('C2_QUANT')) + ': ' + cValToChar(SC2->C2_QUANT)
	oPrint:SayAlign(nLinAtu, nColSepara + 3, cTexto, oFontDad, nLargurTxt, 15, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
	nLinAtu += 15
	
	cTexto  := Alltrim(RetTitle('C2_QTSEGUN')) + ': ' + cValToChar(SC2->C2_QTSEGUN)
	oPrint:SayAlign(nLinAtu, nColSepara + 3, cTexto, oFontDad, nLargurTxt, 15, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
	nLinAtu += 15
	
	//Mandando para o spool de impressão
	oPrint:Print()
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fConfImpr
Abre a tela para selecionar a impressora da zEtiPcp
@author Fernando Jose Rodrigues
@since 30/09/2025
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fConfImpr()
	Local aArea         := FWGetArea()
	Local aDevice       := {'DISCO', 'SPOOL', 'EMAIL', 'EXCEL', 'HTML', 'PDF'}
	Local oSetup
	Local cSession  	:= GetPrinterSession()
	Local cDevice     	:= If(Empty(fwGetProfString(cSession,'PRINTTYPE','SPOOL',.T.)),'PDF',fwGetProfString(cSession,'PRINTTYPE','SPOOL',.T.))
	Local nPrintType    := aScan(aDevice, {|x| x == cDevice })
	Local nOrientation  := 1 //If(fwGetProfString(cSession, 'ORIENTATION', 'PORTRAIT', .T.) == 'PORTRAIT', 1, 2)
	Local nLocal        := 2 //If(fwGetProfString(cSession, 'LOCAL', 'SERVER', .T.) == 'SERVER', 1, 2)
	Local nFlags        := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	
	//Cria o setup do relatório
	oSetup := FWPrintSetup():New(nFlags, 'ETIQUETA')
	oSetup:SetPropert(PD_DESTINATION , nLocal)
	oSetup:SetPropert(PD_ORIENTATION , nOrientation)
	oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
	oSetup:SetPropert(PD_MARGIN      , {0,0,0,0})
	
	oSetupRel := Nil
	
	//Se a tela for confirmada, atualiza o setup default do relatório
	If oSetup:Activate() == PD_OK
		If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL .And. oSetup:GetProperty(PD_DESTINATION) == 2
			oSetupRel := oSetup
		Else
			FWAlertInfo('Escolha o tipo SPOOL e LOCAL para impressão!')
		EndIf
	EndIf
	
	FWRestArea(aArea)
Return
