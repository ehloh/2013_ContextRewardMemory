% Analysis script (mem and enc-stage) for Deacon v3-6 (ContextControl) - tested by Charles July 2014
% Are items with a context picture in the backgroudn better
%       remembered? [No reward in entire expt]

clear all; close all hidden; clc

for o1=1:1 % Set up 
    
    w=pwd; addpath(w)
    if strcmp(w(1), '/')==1;  
        where.data='/Users/EleanorL/Dropbox/SCRIPPS/3 Deacon project/3 Analysis/2 Data/v3_6';
    else where.data='D:\Dropbox\SCRIPPS\3 Deacon project\3 Analysis\2 Data\v3_6';
    end
    
%     where.data=[where.data filesep '1stbatch'];  disp('Some subjects only!!!!')
    
    cd(where.data); log.subjects=dir('p*'); log.subjects= cellstr(char(log.subjects.name)); 
    log.n_subjs=length(log.subjects);
end

%% Encoding stage checks (must load for memdata stage also)

encdata=[log.subjects cell(log.n_subjs,2)]; % subject, accuracy, rt
d_encscores0=nan(log.n_subjs,2); d_encscores1=d_encscores0; % 0=no context: accuracy, RT
for s=1:log.n_subjs
    ws=load([log.subjects{s} filesep log.subjects{s} '_file_2enc.mat']);
    encdata{s,2}=ws.enc.trialstats; ecol=ws.enc.col;
    
    % Get scores
    ws.context=encdata{s,2}(encdata{s,2}(:, ecol.ContextBlock)==1,:);
    ws.nocontext=encdata{s,2}(encdata{s,2}(:, ecol.ContextBlock)==0,:);
    d_encscores0(s,1)=mean(ws.context(:,ecol.ItemAccuracy)); % accuracy
    d_encscores1(s,1)=mean(ws.nocontext(:,ecol.ItemAccuracy));
    ws.context=ws.context(ws.context(:, ecol.ItemAccuracy)==1,:); % rt
    ws.nocontext=ws.nocontext(ws.nocontext(:, ecol.ItemAccuracy)==1,:);
    d_encscores0(s,2)=mean(ws.context(:,ecol.RespRT)); % accuracy
    d_encscores1(s,2)=mean(ws.nocontext(:,ecol.RespRT));
end
for m=1:2  % Stats
    [h(m,1) p(m,1) ci stats]=ttest(d_encscores0(:, m), d_encscores1(:, m));
    means(m, 1:2)=[mean(d_encscores0(:, m)) mean(d_encscores1(:, m))];
    sd(m, 1:2)=[std(d_encscores0(:, m)) std(d_encscores1(:, m))];
    tstat(m,1:2)=[stats.df stats.tstat];
end
d_encscores1M0=d_encscores1-d_encscores0;
disp('Encoding accuracy & RT: sig effect of context?'); [h p tstat]

%% Load mem data

log.memtypes={'Hit';'Surehit';'Rem';'Surerem';'Know';'Sureknow';'Assoc';'dprime'};  % Hard coded

for o1=1:1 % Columns
    col.Trialnum=1;
    col.ItemStim=2;
    col.OldFoil=3;
    col.EncTrial=4;
    col.EncSceneStim=[5 6];
    col.EncSimDis=7;
    col.EncContextBlock=8;
    col.EncCorrect=9;
    col.EncItemType=10;
    col.EncItemPos=11;
    %
    col.OldNew=12;
    col.RT_OldNew=13;
    col.RemKnow=14;
    col.RT_RemKnow=15;
    col.SureGuess=16;
    col.RT_SureGuess=17;
    col.Pos=18;
    col.RT_Pos=19;
    %
    col.OldNewAccuracy=20;
    col.Roc=21;
    col.PosAccuracy=22;
    
end

subjdata=[log.subjects cell(log.n_subjs,2)];
d_memscores0=nan(log.n_subjs,2); d_memscores1=d_memscores0; % hit, surehit, rem, surerem, know, sureknow, assoc
for s=1:log.n_subjs
    ws=load([log.subjects{s} filesep log.subjects{s} '_file_3memorytest.mat']);
    subjdata{s,2}.alld=ws.memtest.trialstats;
    subjdata{s,2}.md=subjdata{s,2}.alld( subjdata{s,2}.alld(:,col.OldFoil)==1, :);
    
    % Mark correctly encoded or not
    ws.enc=encdata{s,2}(encdata{s,2}(:,ecol.ItemType)~=3,:); % Enc data to be remembmered
    for t=1:size(subjdata{s,2}.md,1)
        wt.stimnum=subjdata{s,2}.md(t, col.ItemStim);
        wt.encok=ws.enc(find(ws.enc(:, ecol.ItemStim)==wt.stimnum), ecol.ItemAccuracy);
        subjdata{s,2}.md(t,col.EncCorrect)=wt.encok;  
    end
    subjdata{s,2}.md=subjdata{s,2}.md(subjdata{s,2}.md(:, col.EncCorrect)==1,:); % Correctly encoded only

    % FA rates
    ws.foils=subjdata{s,2}.alld(subjdata{s,2}.alld(:, col.OldFoil)==2,:);
	ws.fas=[
        mean(ws.foils(:, col.OldNew)==1)
        mean(ws.foils(:, col.OldNew)==1 & ws.foils(:, col.SureGuess)==1)
        mean(ws.foils(:, col.RemKnow)==1)
        mean(ws.foils(:, col.RemKnow)==1 & ws.foils(:, col.SureGuess)==1)
        mean(ws.foils(:, col.RemKnow)==2)
        mean(ws.foils(:, col.RemKnow)==2 & ws.foils(:, col.SureGuess)==1)
        mean(ws.foils(:, col.PosAccuracy)==1)
        ];
    ws.fa_dprime=(sum(ws.foils(:, col.OldNew)==1)+0.5)/size(ws.foils,1);
    
    % Collect data into conditions 
    ws.context0=subjdata{s,2}.md(subjdata{s,2}.md(:, col.EncContextBlock)==0, :);
    ws.context1=subjdata{s,2}.md(subjdata{s,2}.md(:, col.EncContextBlock)==1, :);

%     disp('Surehit is artificially set to be un-sure hits!!')
    
    d_memscores0(s, 1:7)= [
        mean(ws.context0(:, col.OldNew)==1)
        mean(ws.context0(:, col.OldNew)==1 & ws.context0(:, col.SureGuess)==1)
%         mean(ws.context0(:, col.OldNew)==1 & ws.context0(:, col.SureGuess)==2) % Artificial ### !!! 
        mean(ws.context0(:, col.RemKnow)==1)
        mean(ws.context0(:, col.RemKnow)==1 & ws.context0(:, col.SureGuess)==1)
        mean(ws.context0(:, col.RemKnow)==2)
        mean(ws.context0(:, col.RemKnow)==2 & ws.context0(:, col.SureGuess)==1)
        mean(ws.context0(:, col.PosAccuracy)==1)
        ];
    d_memscores1(s, 1:7)= [
        mean(ws.context1(:, col.OldNew)==1)
        mean(ws.context1(:, col.OldNew)==1 & ws.context1(:, col.SureGuess)==1)
%         mean(ws.context1(:, col.OldNew)==1 & ws.context1(:, col.SureGuess)==2)  % Artificial ### !!! 
        %
        mean(ws.context1(:, col.RemKnow)==1)
        mean(ws.context1(:, col.RemKnow)==1 & ws.context1(:, col.SureGuess)==1)
        mean(ws.context1(:, col.RemKnow)==2)
        mean(ws.context1(:, col.RemKnow)==2 & ws.context1(:, col.SureGuess)==1)
        mean(ws.context1(:, col.PosAccuracy)==1)
        ];
    
    
    % d'
    ws.dprime=f_calcmem(1,  ws.context0(:, col.Roc), ws.fa_dprime);
    d_memscores0(s, 8)=ws.dprime.rate;
    ws.dprime=f_calcmem(1,  ws.context1(:, col.Roc), ws.fa_dprime);
    d_memscores1(s, 8)=ws.dprime.rate;
    
    
    % Associative memory =  # position correctly recognized/# old recognized as old
    ws.context0=ws.context0( ws.context0(:, col.OldNew)==1,:);
    d_memscores0(s, 7)=mean(ws.context0(:, col.PosAccuracy)==1);
    ws.context1=ws.context1( ws.context1(:, col.OldNew)==1,:);
    d_memscores1(s, 7)=mean(ws.context1(:, col.PosAccuracy)==1);
    
    
    % Correct for FA rates (Assoc memory not corrected for!)
    d_memscores0(s, 1:7)=d_memscores0(s, 1:7)-ws.fas';
    d_memscores1(s, 1:7)=d_memscores1(s, 1:7)-ws.fas';
end

%% Actual analysis
% Transfer to SPSS for plots: d_encscores0/1, d_memscores0/1

% Stats
for m=1:length(log.memtypes) 
    [h(m,1) p(m,1) ci stats]=ttest(d_memscores0(:, m), d_memscores1(:, m));
    if p(m,1)<0.1; h(m,1)=0.5; end
    means(m, 1:2)=[mean(d_memscores0(:, m)) mean(d_memscores1(:, m))];
    sd(m, 1:2)=[std(d_memscores0(:, m)) std(d_memscores1(:, m))];
    tstats(m,1:2)=[stats.df stats.tstat];
end
res=[log.memtypes num2cell(h) num2cell(p) num2cell(tstats)]; openvar res

domeanplot=0;
if domeanplot
    % Plots
    f.subplot_rowcols=[3 3]; f.figwidth= 700; f.figheight=800; f.yaxisslack=0.05; ff=1; 
    f.subplot_VerHorz=[0.1 0.1]; f.fig_BotTop=[0.05 0.05]; f.fig_LeftRight=[0.07 0.02];
    figure('Name', ['Memory scores (n= ' num2str(log.n_subjs) ')'], 'NumberTitle', 'off', 'Position',[800,400,f.figheight,f.figwidth], 'Color',[1 1 1]);
    for m=1:length(log.memtypes)
        subtightplot(f.subplot_rowcols(1), f.subplot_rowcols(2),   ff,  f.subplot_VerHorz,f.fig_BotTop, f.fig_LeftRight);
        wm.means=[mean( d_memscores1(:,m) )  mean( d_memscores0(:,m) )];
        wm.std=[std( d_memscores1(:,m) ) std( d_memscores0(:,m) )];
        wm.sterr=wm.std/sqrt(log.n_subjs);
        
        %
        wm.errorbar=wm.sterr;  % Error bars =  ?
        %
        barwitherr(wm.errorbar,wm.means,'y')
%         ylim([min(wm.means(:))-max(wm.errorbar(:))-f.yaxisslack     max(wm.means(:))+max(wm.errorbar(:))+f.yaxisslack])
        ylim([0    max(wm.means(:))+max(wm.errorbar(:))+f.yaxisslack])
        xlim([0.5 2.5])
        title(log.memtypes{m})
        set(gca, 'XTick', [1 2], 'XTickLabel', {'Context' 'No Context'});    %  xlabel('Condition')
        ylabel('Memory score')
        
        ff=ff+1;
    end
end

disp(['No subjects  = ' num2str(log.n_subjs)])

%% Difference scores?

d_memscores1M0=d_memscores1- d_memscores0;
% openvar d_memscores1M0

dodiffplot=0;
if dodiffplot
    % Plots
    f.subplot_rowcols=[3 3]; f.figwidth= 700; f.figheight=800; f.yaxisslack=0.05; ff=1; 
    f.subplot_VerHorz=[0.1 0.1]; f.fig_BotTop=[0.05 0.05]; f.fig_LeftRight=[0.07 0.02];
    figure('Name', ['Memory diff scores (n= ' num2str(log.n_subjs) ')'], 'NumberTitle', 'off', 'Position',[800,400,f.figheight,f.figwidth], 'Color',[1 1 1]);
    for m=1:length(log.memtypes)
        subtightplot(f.subplot_rowcols(1), f.subplot_rowcols(2),   ff,  f.subplot_VerHorz,f.fig_BotTop, f.fig_LeftRight);
        wm.means=mean( d_memscores1M0(:,m) )  ;
        wm.std=std( d_memscores1M0(:,m) ) ;
        wm.sterr=wm.std/sqrt(log.n_subjs);
        %
        wm.errorbar=wm.sterr;  % Error bars =  ?

        
        %
        barwitherr(wm.errorbar,wm.means,'y')
%         scatter(ones(log.n_subjs,1),d_memscores1M0(:,m) )  % Scatter
        boxplot(d_memscores1M0(:,m) )
        refline(0,0)
        
        %
        title(log.memtypes{m}); ylabel('Memory score')
        ff=ff+1;
    end
end


%% Compile into one array
% error

d_allenc=[{'eacc_context' 'ert_context' 'eacc_nocontext' 'ert_nocontext' 'eacc_confx' 'ert_confx'};
    num2cell([d_encscores1 d_encscores0 d_encscores1M0])];

d_allmem=[
{'mh_context'
'msh_context'
'mr_context'
'msr_context'
'mk_context'    
'msk_context'
'ma_context'
'md_context'
'mh_nocontext' % 
'msh_nocontext'
'mr_nocontext'
'msr_nocontext'
'mk_nocontext'    
'msk_nocontext'
'ma_nocontext'
'md_nocontext'
'mh_confx' % 
'msh_confx'
'mr_confx'
'msr_confx'
'mk_confx'    
'msk_confx'
'ma_confx'
'md_confx'
}'
num2cell([d_memscores1 d_memscores0 d_memscores1M0])];

d_all=[[{'Subject'}; log.subjects]  d_allenc d_allmem];
openvar d_all
ans=strtrim(d_all(1,:)');
% openvar ans



%%




