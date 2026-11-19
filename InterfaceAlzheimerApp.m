function InterfaceAlzheimerApp
    nomesEletrodos = {'Fp1','F3','C3','P3','O1','F7','T3','T5', ...
                      'Fz','Cz','Pz','Fp2','F4','C4','P4','O2','F8','T4','T6'};
    FsPadrao = 256;
    nivelWavelet = 6;

    arquivosEEG = struct('nome', {}, 'caminho', {}, 'rotulo', {});

    fig = uifigure('Name','Analise Computacional de EEG - Doenca de Alzheimer', ...
                   'Position',[80 50 1380 850]);

    layoutPrincipal = uigridlayout(fig,[2 1]);
    layoutPrincipal.RowHeight = {100,'1x'};
    layoutPrincipal.ColumnWidth = {'1x'};
    layoutPrincipal.Padding = [10 10 10 10];
    layoutPrincipal.RowSpacing = 8;

    painelSuperior = uipanel(layoutPrincipal,'Title','Selecao dos dados EEG');
    painelSuperior.Layout.Row = 1;
    painelSuperior.Layout.Column = 1;

    gradeSuperior = uigridlayout(painelSuperior,[2 4]);
    gradeSuperior.RowHeight = {34,34};
    gradeSuperior.ColumnWidth = {220,220,170,'1x'};
    gradeSuperior.Padding = [8 5 8 5];
    gradeSuperior.RowSpacing = 3;
    gradeSuperior.ColumnSpacing = 8;

    btnPasta = uibutton(gradeSuperior,'push','Text','Selecionar pasta dos dados', ...
        'ButtonPushedFcn',@selecionarPasta);
    btnPasta.Layout.Row = 1;
    btnPasta.Layout.Column = 1;

    btnArquivos = uibutton(gradeSuperior,'push','Text','Adicionar arquivo(s) .txt/.csv', ...
        'ButtonPushedFcn',@adicionarArquivos);
    btnArquivos.Layout.Row = 1;
    btnArquivos.Layout.Column = 2;

    lblStatus = uilabel(gradeSuperior,'Text','Nenhum arquivo carregado. Selecione a pasta que contem Control_*.txt e Patient_*_MCI/AD.txt.');
    lblStatus.Layout.Row = 1;
    lblStatus.Layout.Column = [3 4];

    lblEletrodo = uilabel(gradeSuperior,'Text','Eletrodo para exibicao:');
    lblEletrodo.Layout.Row = 2;
    lblEletrodo.Layout.Column = 1;

    ddEletrodo = uidropdown(gradeSuperior,'Items',nomesEletrodos,'Value','P3');
    ddEletrodo.Layout.Row = 2;
    ddEletrodo.Layout.Column = 2;

    lblFs = uilabel(gradeSuperior,'Text',sprintf('Frequencia de amostragem: %g Hz (relatorio)',FsPadrao));
    lblFs.Layout.Row = 2;
    lblFs.Layout.Column = [3 4];

    abas = uitabgroup(layoutPrincipal); abas.Layout.Row = 2; abas.Layout.Column = 1;

    abaResultados = uitab(abas,'Title','Resultados');
    abaBandas = uitab(abas,'Title','Sinal original e bandas');
    abaPacientes = uitab(abas,'Title','Comparacao entre grupos');
    abaCompleto = uitab(abas,'Title','Sinal completo');

    gradeResultados = uigridlayout(abaResultados,[2 2]);
    gradeResultados.RowHeight = {'1x',34};
    gradeResultados.ColumnWidth = {'1.6x','1x'};
    gradeResultados.Padding = [12 12 12 8];
    gradeResultados.ColumnSpacing = 12;

    axAcuracia = uiaxes(gradeResultados); axAcuracia.Layout.Row = 1; axAcuracia.Layout.Column = 1;

    dadosOriginal = {
        'Fp1',0.6381,0.2571,0.3048;
        'F3', 0.6286,0.3333,0.4762;
        'C3', 0.6381,0.3238,0.4667;
        'P3', 0.6857,0.2571,0.4571;
        'O1', 0.6476,0.2143,0.3810;
        'F7', 0.6381,0.2571,0.4476;
        'T3', 0.6286,0.2190,0.4095;
        'T5', 0.6000,0.2857,0.4762;
        'Fz', 0.6762,0.3048,0.3048;
        'Cz', 0.6476,0.2952,0.4000;
        'Pz', 0.5905,0.1905,0.3048;
        'Fp2',0.7524,0.3429,0.4667;
        'F4', 0.5714,0.2476,0.4667;
        'C4', 0.6476,0.2476,0.4714;
        'P4', 0.7238,0.2857,0.3314;
        'O2', 0.5619,0.2952,0.3238;
        'F8', 0.7619,0.2571,0.3419;
        'T4', 0.6667,0.2190,0.5333;
        'T6', 0.6286,0.2571,0.3905};

    eletrodos = dadosOriginal(:,1);
    valoresC = cell2mat(dadosOriginal(:,2));
    valoresF = cell2mat(dadosOriginal(:,3));
    valoresQ = cell2mat(dadosOriginal(:,4));

    plot(axAcuracia,1:19,valoresC,'-o','LineWidth',1.8,'DisplayName','GQ - Coeficiente de agrupamento (C)');
    hold(axAcuracia,'on');
    plot(axAcuracia,1:19,valoresF,'-s','LineWidth',1.8,'DisplayName','Dimensao fractal (F)');
    plot(axAcuracia,1:19,valoresQ,'-^','LineWidth',1.8,'DisplayName','Entropia quadratica (Q)');
    hold(axAcuracia,'off');
    axAcuracia.XTick = 1:19;
    axAcuracia.XTickLabel = eletrodos;
    axAcuracia.XTickLabelRotation = 45;
    axAcuracia.YLim = [0 0.85];
    xlabel(axAcuracia,'Eletrodos (sistema 10-20)');
    ylabel(axAcuracia,'Acuracia SVM');
    title(axAcuracia,'Comparacao das acuracias por eletrodo - sinal original');
    legend(axAcuracia,'Location','best');
    grid(axAcuracia,'on');

    tabelaResumo = {
        'Grafos de Quantis - C',0.7619,'F8','Original','k = 87';
        'Dimensao fractal - F',0.4762,'T5','Alfa','Sem parametro k';
        'Entropia quadratica - Q',0.5333,'T4','Original','m = 2; r = 0,80'};

    tabResumo = uitable(gradeResultados,'Data',tabelaResumo, ...
        'ColumnName',{'Tecnica','Acuracia maxima','Eletrodo','Sinal/banda','Parametro'}, ...
        'ColumnEditable',[false false false false false]);
    tabResumo.Layout.Row = 1;
    tabResumo.Layout.Column = 2;
    tabResumo.ColumnWidth = {150,100,65,90,110};

    lblFonte = uilabel(gradeResultados,'Text', ...
        ['O grafico de linhas utiliza os valores fixos ja presentes na interface enviada ' ...
         'para o sinal original. O resumo das maiores acuracias foi organizado a partir ' ...
         'das Tabelas 5.1 a 5.5 do relatorio. Os mapas topograficos foram removidos.'], ...
        'WordWrap','on');
    lblFonte.Layout.Row = 2;
    lblFonte.Layout.Column = [1 2];

    gradeBandas = uigridlayout(abaBandas,[2 1]);
    gradeBandas.RowHeight = {48,'1x'};
    gradeBandas.ColumnWidth = {'1x'};
    gradeBandas.Padding = [10 10 10 10];

    painelControlesBandas = uipanel(gradeBandas,'Title','Arquivo para decomposicao');
    painelControlesBandas.Layout.Row = 1;
    painelControlesBandas.Layout.Column = 1;
    gradeControlesBandas = uigridlayout(painelControlesBandas,[1 3]);
    gradeControlesBandas.ColumnWidth = {100,'1x',210};
    gradeControlesBandas.Padding = [5 3 5 3];

    uilabel(gradeControlesBandas,'Text','Arquivo EEG:');
    ddBandas = uidropdown(gradeControlesBandas,'Items',{'Selecione a pasta ou um arquivo'});
    btnPlotBandas = uibutton(gradeControlesBandas,'push','Text','Exibir sinal e bandas', ...
        'ButtonPushedFcn',@plotarBandas);

    gradeEixosBandas = uigridlayout(gradeBandas,[5 1]);
    gradeEixosBandas.Layout.Row = 2;
    gradeEixosBandas.Layout.Column = 1;
    gradeEixosBandas.RowHeight = {'1x','1x','1x','1x','1x'};
    gradeEixosBandas.ColumnWidth = {'1x'};
    gradeEixosBandas.Padding = [5 5 5 5];
    axOriginal = uiaxes(gradeEixosBandas);
    axBeta = uiaxes(gradeEixosBandas);
    axAlfa = uiaxes(gradeEixosBandas);
    axTheta = uiaxes(gradeEixosBandas);
    axDelta = uiaxes(gradeEixosBandas);

    gradePacientes = uigridlayout(abaPacientes,[2 1]);
    gradePacientes.RowHeight = {90,'1x'};
    gradePacientes.ColumnWidth = {'1x'};
    gradePacientes.Padding = [10 10 10 10];

    painelPacientes = uipanel(gradePacientes,'Title','Selecione um arquivo de cada grupo');
    painelPacientes.Layout.Row = 1;
    painelPacientes.Layout.Column = 1;
    gradeSelecaoPacientes = uigridlayout(painelPacientes,[2 3]);
    gradeSelecaoPacientes.RowHeight = {22,32};
    gradeSelecaoPacientes.ColumnWidth = {'1x','1x','1x'};
    gradeSelecaoPacientes.Padding = [6 4 6 4];

    uilabel(gradeSelecaoPacientes,'Text','Controle (Control_...)','HorizontalAlignment','center');
    uilabel(gradeSelecaoPacientes,'Text','DCL (Patient_..._MCI)','HorizontalAlignment','center');
    uilabel(gradeSelecaoPacientes,'Text','Alzheimer (Patient_..._AD)','HorizontalAlignment','center');

    ddControle = uidropdown(gradeSelecaoPacientes,'Items',{'Selecione os dados'});
    ddMCI = uidropdown(gradeSelecaoPacientes,'Items',{'Selecione os dados'});
    ddAD = uidropdown(gradeSelecaoPacientes,'Items',{'Selecione os dados'});
    ddControle.ValueChangedFcn = @plotarPacientes;
    ddMCI.ValueChangedFcn = @plotarPacientes;
    ddAD.ValueChangedFcn = @plotarPacientes;

    gradeEixosPacientes = uigridlayout(gradePacientes,[3 1]);
    gradeEixosPacientes.Layout.Row = 2;
    gradeEixosPacientes.Layout.Column = 1;
    gradeEixosPacientes.RowHeight = {'1x','1x','1x'};
    gradeEixosPacientes.ColumnWidth = {'1x'};
    gradeEixosPacientes.Padding = [5 5 5 5];
    axControle = uiaxes(gradeEixosPacientes);
    axMCI = uiaxes(gradeEixosPacientes);
    axAD = uiaxes(gradeEixosPacientes);

    gradeCompleto = uigridlayout(abaCompleto,[2 1]);
    gradeCompleto.RowHeight = {48,'1x'};
    gradeCompleto.ColumnWidth = {'1x'};
    gradeCompleto.Padding = [10 10 10 10];

    painelCompleto = uipanel(gradeCompleto,'Title','Arquivo para visualizacao completa');
    painelCompleto.Layout.Row = 1;
    painelCompleto.Layout.Column = 1;
    gradeControlesCompleto = uigridlayout(painelCompleto,[1 3]);
    gradeControlesCompleto.ColumnWidth = {100,'1x',210};
    gradeControlesCompleto.Padding = [5 3 5 3];
    uilabel(gradeControlesCompleto,'Text','Arquivo EEG:');
    ddCompleto = uidropdown(gradeControlesCompleto,'Items',{'Selecione a pasta ou um arquivo'});
    btnPlotCompleto = uibutton(gradeControlesCompleto,'push','Text','Exibir sinal completo', ...
        'ButtonPushedFcn',@plotarCompleto);

    axCompleto = uiaxes(gradeCompleto);
    axCompleto.Layout.Row = 2;
    axCompleto.Layout.Column = 1;

    function selecionarPasta(~,~)
        pasta = uigetdir(pwd,'Selecione a pasta que contem os arquivos de EEG');
        if isequal(pasta,0)
            return;
        end

        lista = dir(pasta);
        lista = lista(~[lista.isdir]);
        novos = struct('nome',{},'caminho',{},'rotulo',{});
        for k = 1:numel(lista)
            [~,~,ext] = fileparts(lista(k).name);
            if ismember(lower(ext),{'.txt','.csv'})
                item.nome = lista(k).name;
                item.caminho = fullfile(pasta,lista(k).name);
                item.rotulo = lista(k).name;
                novos(end+1) = item; %#ok<AGROW>
            end
        end

        if isempty(novos)
            uialert(fig,'Nao foram encontrados arquivos .txt ou .csv nessa pasta.','Arquivos nao encontrados');
            return;
        end

        arquivosEEG = novos;
        atualizarSeletores();
        lblStatus.Text = sprintf('%d arquivo(s) EEG encontrados em: %s',numel(arquivosEEG),pasta);
    end

    function adicionarArquivos(~,~)
        [nomes,pasta] = uigetfile({'*.txt;*.csv','Arquivos EEG (*.txt, *.csv)'}, ...
            'Selecione um ou mais arquivos de EEG','MultiSelect','on');
        if isequal(nomes,0)
            return;
        end
        if ischar(nomes)
            nomes = {nomes};
        end

        for k = 1:numel(nomes)
            caminho = fullfile(pasta,nomes{k});
            jaExiste = false;
            for j = 1:numel(arquivosEEG)
                if strcmpi(arquivosEEG(j).caminho,caminho)
                    jaExiste = true;
                    break;
                end
            end
            if ~jaExiste
                item.nome = nomes{k};
                item.caminho = caminho;
                item.rotulo = nomes{k};
                arquivosEEG(end+1) = item; %#ok<AGROW>
            end
        end

        atualizarSeletores();
        lblStatus.Text = sprintf('%d arquivo(s) disponivel(is) na interface.',numel(arquivosEEG));
    end

    function atualizarSeletores()
        if isempty(arquivosEEG)
            return;
        end

        nomes = {arquivosEEG.nome};
        for k = 1:numel(arquivosEEG)
            if sum(strcmp(nomes,arquivosEEG(k).nome)) > 1
                [pastaAtual,~,~] = fileparts(arquivosEEG(k).caminho);
                arquivosEEG(k).rotulo = [arquivosEEG(k).nome '  [' pastaAtual ']'];
            else
                arquivosEEG(k).rotulo = arquivosEEG(k).nome;
            end
        end
        rotulos = {arquivosEEG.rotulo};

        configurarDropdown(ddBandas,rotulos);
        configurarDropdown(ddCompleto,rotulos);

        idxControle = false(1,numel(arquivosEEG));
        idxMCI = false(1,numel(arquivosEEG));
        idxAD = false(1,numel(arquivosEEG));
        for k = 1:numel(arquivosEEG)
            nomeLower = lower(arquivosEEG(k).nome);
            idxControle(k) = startsWith(nomeLower,'control') || contains(nomeLower,'_control');
            idxMCI(k) = contains(nomeLower,'_mci') || contains(nomeLower,'mci');
            idxAD(k) = contains(nomeLower,'_ad') || contains(nomeLower,'_alzheimer');
        end
        configurarDropdown(ddControle,rotulos(idxControle));
        configurarDropdown(ddMCI,rotulos(idxMCI));
        configurarDropdown(ddAD,rotulos(idxAD));
    end

    function configurarDropdown(dd,itens)
        if isempty(itens)
            dd.Items = {'(grupo/arquivo nao encontrado)'};
            dd.Value = dd.Items{1};
        else
            dd.Items = itens;
            dd.Value = itens{1};
        end
    end

    function item = arquivoSelecionado(dd)
        item = [];
        if isempty(arquivosEEG)
            error('Selecione primeiro a pasta dos dados ou adicione arquivos EEG.');
        end
        rotulo = dd.Value;
        idx = find(strcmp({arquivosEEG.rotulo},rotulo),1,'first');
        if isempty(idx)
            error('Nao ha arquivo valido selecionado nesse campo. Verifique o grupo e os nomes dos arquivos.');
        end
        item = arquivosEEG(idx);
    end

    function X = lerArquivoEEG(item)
        try
            X = readmatrix(item.caminho,'FileType','text');
        catch
            X = readmatrix(item.caminho);
        end
        if isempty(X) || ~isnumeric(X)
            error('O arquivo selecionado nao contem uma matriz numerica que possa ser lida.');
        end

        X = X(:,any(isfinite(X),1));
        X = X(any(isfinite(X),2),:);
        if isempty(X)
            error('Nao foram encontrados valores numericos no arquivo.');
        end

        if size(X,2) == 19
        elseif size(X,1) == 19 && size(X,2) > 19
            X = X.';
        elseif isvector(X)
            X = X(:); 
        else
            error(['Dimensoes inesperadas: o arquivo tem %d linha(s) e %d coluna(s). ' ...
                   'Esperava-se N x 19 (ou 19 x N) ou um unico canal.'],size(X,1),size(X,2));
        end
    end

    function sinal = obterCanal(X)
        if size(X,2) == 1
            sinal = X(:,1);
        else
            indice = find(strcmp(nomesEletrodos,ddEletrodo.Value),1);
            if isempty(indice) || indice > size(X,2)
                error('O eletrodo selecionado nao existe no arquivo.');
            end
            sinal = X(:,indice);
        end
        sinal = sinal(:);
    end

    function plotarBandas(~,~)
        try
            item = arquivoSelecionado(ddBandas);
            X = lerArquivoEEG(item);
            sinal = obterCanal(X);

            if exist('wavedec','file') == 0 || exist('wrcoef','file') == 0
                uialert(fig,['A decomposicao do relatorio usa wavelet Coiflets 1. ' ...
                    'Para reproduzir esse grafico no MATLAB, e necessario instalar/ativar o Wavelet Toolbox.'], ...
                    'Wavelet Toolbox nao encontrado');
                return;
            end
            if numel(sinal) < 2^(nivelWavelet+2)
                uialert(fig,'O sinal e curto demais para a decomposicao wavelet de nivel 6.','Sinal insuficiente');
                return;
            end

            [coeficientes,tamanhos] = wavedec(sinal,nivelWavelet,'coif1'); 
            beta = wrcoef('d',coeficientes,tamanhos,'coif1',3);
            alfa = wrcoef('d',coeficientes,tamanhos,'coif1',4);
            theta = wrcoef('d',coeficientes,tamanhos,'coif1',5);
            delta = wrcoef('d',coeficientes,tamanhos,'coif1',6) + ...
                    wrcoef('a',coeficientes,tamanhos,'coif1',6);

            n = min([numel(sinal),numel(beta),numel(alfa),numel(theta),numel(delta)]);
            sinal = sinal(1:n); beta = beta(1:n); alfa = alfa(1:n); theta = theta(1:n); delta = delta(1:n);
            tempo = (0:n-1)/FsPadrao;

            cla(axOriginal); plot(axOriginal,tempo,sinal,'k');
            title(axOriginal,['Sinal original - ' item.nome]);
            ylabel(axOriginal,'Amplitude'); grid(axOriginal,'on');

            cla(axBeta); plot(axBeta,tempo,beta,'r');
            title(axBeta,'Banda beta (reconstrucao wavelet)');
            ylabel(axBeta,'Amplitude'); grid(axBeta,'on');

            cla(axAlfa); plot(axAlfa,tempo,alfa,'Color',[0.9 0.55 0.1]);
            title(axAlfa,'Banda alfa (reconstrucao wavelet)');
            ylabel(axAlfa,'Amplitude'); grid(axAlfa,'on');

            cla(axTheta); plot(axTheta,tempo,theta,'g');
            title(axTheta,'Banda theta (reconstrucao wavelet)');
            ylabel(axTheta,'Amplitude'); grid(axTheta,'on');

            cla(axDelta); plot(axDelta,tempo,delta,'b');
            title(axDelta,'Banda delta (reconstrucao wavelet)');
            xlabel(axDelta,'Tempo (s)'); ylabel(axDelta,'Amplitude'); grid(axDelta,'on');
        catch ME
            uialert(fig,ME.message,'Nao foi possivel exibir as bandas');
        end
    end

    function plotarPacientes(~,~)
        seletores = {ddControle,ddMCI,ddAD};
        eixos = {axControle,axMCI,axAD};
        nomesGrupos = {'Controle','DCL (MCI)','Doenca de Alzheimer (AD)'};

        for k = 1:3
            cla(eixos{k});
            try
                item = arquivoSelecionado(seletores{k});
                X = lerArquivoEEG(item);
                sinal = obterCanal(X);
                if numel(sinal) >= 10000
                    inicio = 5000;
                    fim = 10000;
                else
                    inicio = 1;
                    fim = min(5000,numel(sinal));
                end
                plot(eixos{k},inicio:fim,sinal(inicio:fim),'LineWidth',0.8);
                title(eixos{k},sprintf('%s - %s - eletrodo %s',nomesGrupos{k},item.nome,ddEletrodo.Value));
                ylabel(eixos{k},'Amplitude');
                grid(eixos{k},'on');
            catch ME
                title(eixos{k},nomesGrupos{k});
                text(eixos{k},0.05,0.5,ME.message,'Units','normalized','Interpreter','none');
                grid(eixos{k},'on');
            end
        end
        xlabel(axAD,'Indice da amostra');
    end

    function plotarCompleto(~,~)
        try
            item = arquivoSelecionado(ddCompleto);
            X = lerArquivoEEG(item);
            sinal = obterCanal(X);
            cla(axCompleto);
            tempo = (0:numel(sinal)-1)/FsPadrao;
            plot(axCompleto,tempo,sinal,'LineWidth',0.7);
            title(axCompleto,['Sinal EEG completo - ' item.nome ' - ' ddEletrodo.Value]);
            xlabel(axCompleto,'Tempo (s)');
            ylabel(axCompleto,'Amplitude');
            grid(axCompleto,'on');
        catch ME
            uialert(fig,ME.message,'Nao foi possivel exibir o sinal');
        end
    end

    abas.SelectionChangedFcn = @mudancaAba;
    function mudancaAba(~,evento)
        if evento.NewValue == abaPacientes && ~isempty(arquivosEEG)
            plotarPacientes();
        end
    end
    title(axOriginal,'Selecione a pasta/arquivo e clique em Exibir sinal e bandas');
    title(axBeta,'Banda beta');
    title(axAlfa,'Banda alfa');
    title(axTheta,'Banda theta');
    title(axDelta,'Banda delta');
    title(axControle,'Sinal do grupo Controle');
    title(axMCI,'Sinal do grupo DCL');
    title(axAD,'Sinal do grupo Alzheimer');
    title(axCompleto,'Selecione um arquivo e clique em Exibir sinal completo');
end