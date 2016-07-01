% eval_memseeds
%
% Assess item recognition, in terms of dprime, remember, know, sure rem,
% sure know. ROCs are done via another script. (9/08/12)

for o1=1:1 % Documentation
% Instructions list (for execution)
%     Col 1: Name of measure
%     Col 2: Cue status (1=Sim, 2=Dis, 999=n/a)
%     Col 3: Context status (1=Reward, 0=Neutral)
%     Col 4: Item status (1=Reward, 0=Neutral)
%     Col 5: Seed status (n/a)
%     Col 6: [Blank]
%     Col 7: Cells (combined) corresponding to this measure
%     Col 8: [diff only] Cells to deduct, for this measure
%     Col 9: Order for printing

% This script produces txt files for reading in SPSS. It also produces
% (un-saved) cell arrays corresponding to each measure, corresponding to:
% - cell means only (prefix 'm_')
% - difference between means only (prefix 'd_')
% - combination of both means and difference scores (prefix 'r_')

end

clear all
clc

dataloc='H:\6 [v3.2 Seeds] Experiment MDeacon\3 Analysis\';

for o1=1:1 % Options & Setup for analysis
    % SCRIPT SPEX
    w.respcol=27; % In which col is ROC response marked? (6=sure rem etc)
    w.minimum_ntrials=10;
    w.extravar=12; % dprime is always the last one
    
    % Type of seeds
    w.seedtype=input('Type of seeds? (1=Actual outcome, 2=Accompanying # Item Rs, 3=Total # Item Rs): ');
%     w.seedtype=2;
    switch w.seedtype
        case 1
            w.seedcol=12;
            w.seedname='Actual outcome';
        case 2
            w.seedcol=14;            
            w.seedname='Accompanying ItemRs';
        case 3
            w.seedcol=13;
            w.seedname='Total ItemRs'; % total number of Item Rs on this encoding trial
    end
end

cd([dataloc '1 Analysis scripts'])
load('i_eval1_memseeds.mat')
cd([dataloc '2 Data'])
w.dir_versions=dir;
w.subject_number=1;

for i4=3:length(w.dir_versions)
    exptversion=w.dir_versions(i4).name;
%     exptversion='Data v3.1';
    disp(exptversion)
    cd(exptversion)
    w.dir=dir;

   for i1=3:length(w.dir)
        subjname=w.dir(i1).name;
%         subjname='p179_DO'; 
        disp(subjname)
        cd(subjname)
        load(strcat(subjname,'_file_3memorytest.mat'))
        ts_all=memtest.trialstats;
        cd([dataloc '1 Analysis scripts'])
        try
            counterbal_version=memtest.settings.counterbalance_ver;
        catch
            counterbal_version=0;
        end
        
%% Outputs

for o1=1:1 % Outputs
    w.template{1,1}=exptversion;
    w.template{1,2}=counterbal_version;
    w.template{1,3}=subjname;
    w.template{1,4}=memtest.TPQ.NS(1);
    w.template{1,5}=memtest.TPQ.NS(2);
    w.template{1,6}=memtest.TPQ.NS(3);
    w.template{1,7}=memtest.TPQ.NS(4);
    w.template{1,8}=memtest.TPQ.RD(1);
    w.template{1,9}=memtest.TPQ.RD(2);
    w.template{1,10}=memtest.TPQ.RD(3);
    w.template{1,11}=memtest.TPQ.RD(4);
    for j=1:w.extravar-1
        m_dprime{w.subject_number+1,j}=w.template{1,j};
        m_rem{w.subject_number+1,j}=w.template{1,j};
        m_know{w.subject_number+1,j}=w.template{1,j};
        m_surerem{w.subject_number+1,j}=w.template{1,j};
        m_sureknow{w.subject_number+1,j}=w.template{1,j};
        m_rec_corrhitrate{w.subject_number+1,j}=w.template{1,j};
        m_rec_uncorrhitrate{w.subject_number+1,j}=w.template{1,j};
        d_dprime{w.subject_number+1,j}=w.template{1,j};
        d_rem{w.subject_number+1,j}=w.template{1,j};
        d_know{w.subject_number+1,j}=w.template{1,j};
        d_surerem{w.subject_number+1,j}=w.template{1,j};
        d_sureknow{w.subject_number+1,j}=w.template{1,j};
        d_rec_corrhitrate{w.subject_number+1,j}=w.template{1,j};
        d_rec_uncorrhitrate{w.subject_number+1,j}=w.template{1,j};
    end
    if w.subject_number==1 % Headings
        clear('w.template')
        w.template{1,1}='Expt_version';
        w.template{1,2}='Counterbal';
        w.template{1,3}='Subject';
        w.template{1,4}='p.NS_1';
        w.template{1,5}='p.NS_2';
        w.template{1,6}='p.NS_3';
        w.template{1,7}='p.NS_4';
        w.template{1,8}='p.RD_1';
        w.template{1,9}='p.RD_2';
        w.template{1,10}='p.RD_3';
        w.template{1,11}='p.RD_4';
        w.template{1,12}='dprime';
        for j=1:w.extravar
            m_dprime{1,j}=w.template{1,j}; % means 
            m_rem{1,j}=w.template{1,j};
            m_know{1,j}=w.template{1,j};
            m_surerem{1,j}=w.template{1,j};
            m_sureknow{1,j}=w.template{1,j};          
            m_rec_corrhitrate{1,j}=w.template{1,j};
            m_rec_uncorrhitrate{1,j}=w.template{1,j};  
            d_dprime{1,j}=w.template{1,j}; % differences
            d_rem{1,j}=w.template{1,j};
            d_know{1,j}=w.template{1,j};
            d_surerem{1,j}=w.template{1,j};
            d_sureknow{1,j}=w.template{1,j};
            d_rec_corrhitrate{1,j}=w.template{1,j};
            d_rec_uncorrhitrate{1,j}=w.template{1,j};
        end
    end
end

%%  PRE-PROCESSING ##################################

    for o2=1:1 % Details for workspace
%     Working variables:
%        1) Sample - data, sorted by cells
%        2) res - count, rate & d'
%
% -----------------------------------------------------------------------------------------------------------
% 
% DESIGN CELLS
%
% 
%                      Cue A (Similar)     Cue B (Dissimilar)
%
%			Item R          1               	3					
%			Item N          2                   4
% 
% -------------------------------------------------------------------------------------  
% 
% STIMULI CELLS (reward not reflected)
% 
%                         Cue A (Similar)                       Cue B (Dissimilar)
%           Scene exemplar 1    Scene exemplar 2     Scene exemplar 1   Scene exemplar 2
%
%  Item N            1                 2                   5               6
%  Item M            3                 4                  7                8

%
% ----------------------------------------------------------------------------------------------------------
%

    end
    
    
    for o1=1:1 % Delete all Items that were incorrectly judged during Encoding (Col 8)
        [wp.sizeall w.a]=size(ts_all); % marker enc
        ts=[];
        for i=1:wp.sizeall
            if ts_all(i,3)==2
                ts=vertcat(ts,ts_all(i,:));
            elseif ts_all(i,8)==1
                ts=vertcat(ts,ts_all(i,:));
            end
        end
    end
    
    for o3=1:1 % Sort into cell-samples (including seeds)
    [wp.nmemtrials w.a]=size(ts);
    sample.c1=[];
    sample.c2=[];
    sample.c3=[];
    sample.c4=[];
    sample.c1_0=[]; % Seed samples
    sample.c2_0=[];
    sample.c3_0=[];
    sample.c4_0=[];    
    sample.c1_1=[];
    sample.c2_1=[];
    sample.c3_1=[];
    sample.c4_1=[];    
    sample.c1_2=[];
    sample.c2_2=[];
    sample.c3_2=[];
    sample.c4_2=[];
    sample.c9=[];
    for i=1:wp.nmemtrials
        if ts(i,3)==2 % foils
            sample.c9=vertcat(sample.c9, ts(i,:));
        else
           switch [num2str(ts(i,7)) num2str(ts(i,9))] % % Cuetype - Item valence
               case '11' % Similar + Item R 
                   sample.c1=vertcat(sample.c1,ts(i,:));
                   ws.sampleseednum=[num2str(1) '_' num2str(ts(i,w.seedcol))]; 
                   eval(['sample.c' ws.sampleseednum '=vertcat(sample.c' ws.sampleseednum ', ts(i,:));'])
               case '10' % Similar + Item N
                   sample.c2=vertcat(sample.c2,ts(i,:));
                   ws.sampleseednum=[num2str(2) '_' num2str(ts(i,w.seedcol))]; 
                   eval(['sample.c' ws.sampleseednum '=vertcat(sample.c' ws.sampleseednum ', ts(i,:));'])
               case '21' % Disimilar + Item R 
                   sample.c3=vertcat(sample.c3,ts(i,:));
                   ws.sampleseednum=[num2str(3) '_' num2str(ts(i,w.seedcol))]; 
                   eval(['sample.c' ws.sampleseednum '=vertcat(sample.c' ws.sampleseednum ', ts(i,:));'])
               case '20' % Similar + Item N
                   sample.c4=vertcat(sample.c4,ts(i,:));
                   ws.sampleseednum=[num2str(4) '_' num2str(ts(i,w.seedcol))]; 
                   eval(['sample.c' ws.sampleseednum '=vertcat(sample.c' ws.sampleseednum ', ts(i,:));'])
               otherwise
                   disp(['Error: Cannot sort into samples - Trial ' num2str(i)])
           end
        clear('ws')
        end
    end
    end 

%% ANALYSIS #####################################################   
 
for o3=1:1 % FA rates (Dprime, RemKnow, Sure Remknow, Rec hit rates)
    [ws.size.c9 w.a]=size(sample.c9);
    % DPRIME - FA rate
    res.dprime.c9.n_fa=sum(sample.c9(:,w.respcol)>2.9);
    res.dprime.c9.fa_rate=(res.dprime.c9.n_fa+0.5)/ws.size.c9;
    switch res.dprime.c9.fa_rate % Correct for +/-Inf
        case 1
            res.dprime.c9.fa_rate=res.dprime.c9.fa_rate-0.001;
        case 0
            res.dprime.c9.fa_rate=res.dprime.c9.fa_rate+0.001; 
    end
    % REM/KNOW FA rates (Remember/Know, Sure/All)
    for i=1:6
        ws.count(i)=sum(sample.c9(:,w.respcol)==i);
    end
    res.rem.c9.n_fa=ws.count(5)+ws.count(6);            % Rem
    res.rem.c9.fa_rate=res.rem.c9.n_fa/ws.size.c9;
    res.surerem.c9.n_fa=ws.count(6);                    % SureRem
    res.surerem.c9.fa_rate=res.surerem.c9.n_fa/ws.size.c9;
    res.know.c9.n_fa=ws.count(3)+ws.count(4);           % Know
    res.know.c9.fa_rate=res.know.c9.n_fa/ws.size.c9;
    res.sureknow.c9.n_fa=ws.count(4);                   % Sure Know
    res.sureknow.c9.fa_rate=res.sureknow.c9.n_fa/ws.size.c9;
    res.rec_hitrate.c9.n_fa=ws.count(3)+ws.count(4)+ws.count(5)+ws.count(6); % Recognition hit rate
    res.rec_hitrate.c9.fa_rate=res.rec_hitrate.c9.n_fa/ws.size.c9;
    clear('ws')
end
for o4=1:1 % Execute instructions for analysis (cell means)
    % See Documentation for usage of summary-compiling instructions
    [w.n_instruc w.a]=size(instruc);
    sample.c0=[]; % Dummies
    for j=1:w.n_instruc % Execute entire instructions list 
        % Compile samples
        for i=1:4 % 
            wss.sn=instruc{j,7}{i};
            if isnumeric(wss.sn)==1
                eval(['ws.s' num2str(i) '=sample.c' num2str(wss.sn) ';'])
            else
                eval(['ws.s' num2str(i) '=sample.c' wss.sn ';'])       
            end
            clear('wss')
        end
            ws.sample=vertcat(ws.s1,ws.s2,ws.s3,ws.s4);
        try
            % Calculate memory measures
            [ws.res.dprime]=f_calcmem(1,ws.sample(:,w.respcol), res.dprime.c9.fa_rate);
            [ws.res.rem]=f_calcmem(2,ws.sample(:,w.respcol), res.rem.c9.fa_rate);
            [ws.res.know]=f_calcmem(3,ws.sample(:,w.respcol), res.know.c9.fa_rate);
            [ws.res.surerem]=f_calcmem(4,ws.sample(:,w.respcol), res.surerem.c9.fa_rate);
            [ws.res.sureknow]=f_calcmem(5,ws.sample(:,w.respcol), res.sureknow.c9.fa_rate);
            [ws.res.rec_corrhitrate]=f_calcmem(6,ws.sample(:,w.respcol), res.rec_hitrate.c9.fa_rate);
            [ws.res.rec_uncorrhitrate]=f_calcmem(7,ws.sample(:,w.respcol), res.rec_hitrate.c9.fa_rate);
            if ws.res.dprime.n_trials <w.minimum_ntrials % Catch for minimum number of trials
                ws.res.dprime.dprime=[];
                ws.res.rem.rate=[];
                ws.res.know.rate=[];
                ws.res.surerem.rate=[];
                ws.res.sureknow.rate=[];
                ws.res.rec_corrhitrate.rate=[];
                ws.res.rec_uncorrhitrate.rate=[];
            end
        catch % If for whatever reason it doesn't work
            ws.res.dprime.dprime=[];
            ws.res.rem.rate=[];
            ws.res.know.rate=[];
            ws.res.surerem.rate=[];
            ws.res.sureknow.rate=[];
            ws.res.rec_corrhitrate.rate=[];
            ws.res.rec_uncorrhitrate.rate=[];
        end
        % Assign
        ws.summname=instruc{j,1};
        eval(['res.dprime.' ws.summname '=ws.res.dprime;']);
        eval(['res.rem.' ws.summname '=ws.res.rem;']);
        eval(['res.know.' ws.summname '=ws.res.know;']);
        eval(['res.surerem.' ws.summname '=ws.res.surerem;']);
        eval(['res.sureknow.' ws.summname '=ws.res.sureknow;']);
        eval(['res.rec_corrhitrate.' ws.summname '=ws.res.rec_corrhitrate;']);
        eval(['res.rec_uncorrhitrate.' ws.summname '=ws.res.rec_uncorrhitrate;']);
        % Write to array
        if w.subject_number==1 % Headings
            m_dprime{1,j+w.extravar}=ws.summname;
            m_rem{1,j+w.extravar}=ws.summname;
            m_know{1,j+w.extravar}=ws.summname;
            m_surerem{1,j+w.extravar}=ws.summname;
            m_sureknow{1,j+w.extravar}=ws.summname;
            m_rec_corrhitrate{1,j+w.extravar}=ws.summname;
            m_rec_uncorrhitrate{1,j+w.extravar}=ws.summname;
        end
        eval(['m_dprime{w.subject_number+1, j+w.extravar}=res.dprime.' ws.summname '.dprime;'])
        eval(['m_rem{w.subject_number+1, j+w.extravar}=res.rem.' ws.summname '.rate;'])
        eval(['m_know{w.subject_number+1, j+w.extravar}=res.know.' ws.summname '.rate;'])
        eval(['m_surerem{w.subject_number+1, j+w.extravar}=res.surerem.' ws.summname '.rate;'])
        eval(['m_sureknow{w.subject_number+1, j+w.extravar}=res.sureknow.' ws.summname '.rate;'])
        eval(['m_rec_corrhitrate{w.subject_number+1, j+w.extravar}=res.rec_corrhitrate.' ws.summname '.rate;'])
        eval(['m_rec_uncorrhitrate{w.subject_number+1, j+w.extravar}=res.rec_uncorrhitrate.' ws.summname '.rate;'])
        clear('ws')
    end    
end
for o4=1:1 % Execute instructions for analysis (cell means)
    % See Documentation for usage of summary-compiling instructions
    [w.n_instruc_diff w.a]=size(instruc_diff);
    sample.c0=[]; % Dummies
    for j=1:w.n_instruc_diff % Execute entire instructions list 
        % CALCULATE PLUS -------------------------------------------------
        for i=1:4 % Compile samples
            wss.sn=instruc_diff{j,7}{i};
            if isnumeric(wss.sn)==1
                eval(['ws_p.s' num2str(i) '=sample.c' num2str(wss.sn) ';'])
            else
                eval(['ws_p.s' num2str(i) '=sample.c' wss.sn ';'])       
            end
            clear('wss')
        end
            ws_p.sample=vertcat(ws_p.s1,ws_p.s2,ws_p.s3,ws_p.s4);
        try
            % Calculate memory measures
            [ws_p.res.dprime]=f_calcmem(1,ws_p.sample(:,w.respcol), res.dprime.c9.fa_rate);
            [ws_p.res.rem]=f_calcmem(2,ws_p.sample(:,w.respcol), res.rem.c9.fa_rate);
            [ws_p.res.know]=f_calcmem(3,ws_p.sample(:,w.respcol), res.know.c9.fa_rate);
            [ws_p.res.surerem]=f_calcmem(4,ws_p.sample(:,w.respcol), res.surerem.c9.fa_rate);
            [ws_p.res.sureknow]=f_calcmem(5,ws_p.sample(:,w.respcol), res.sureknow.c9.fa_rate);
            [ws_p.res.rec_corrhitrate]=f_calcmem(6,ws_p.sample(:,w.respcol), res.rec_hitrate.c9.fa_rate);
            [ws_p.res.rec_uncorrhitrate]=f_calcmem(7,ws_p.sample(:,w.respcol), res.rec_hitrate.c9.fa_rate);           
            if ws_p.res.dprime.n_trials <w.minimum_ntrials % Catch for minimum number of trials
                ws_p.res.dprime.dprime=[];
                ws_p.res.rem.rate=[];
                ws_p.res.know.rate=[];
                ws_p.res.surerem.rate=[];
                ws_p.res.sureknow.rate=[];
                ws_p.res.rec_corrhitrate.rate=[];
                ws_p.res.rec_uncorrhitrate.rate=[];
            end
        catch 
            ws_p.res.dprime.dprime=[];
            ws_p.res.rem.rate=[];
            ws_p.res.know.rate=[];
            ws_p.res.surerem.rate=[];
            ws_p.res.sureknow.rate=[];
            ws_p.res.rec_corrhitrate.rate=[];
            ws_p.res.rec_uncorrhitrate.rate=[];
        end
        % CALCULATE MINUS -------------------------------------------------
        for i=1:4 % Compile samples
            wss.sn=instruc_diff{j,8}{i};
            if isnumeric(wss.sn)==1
                eval(['ws_m.s' num2str(i) '=sample.c' num2str(wss.sn) ';'])
            else
                eval(['ws_m.s' num2str(i) '=sample.c' wss.sn ';'])       
            end
            clear('wss')
        end
            ws_m.sample=vertcat(ws_m.s1,ws_m.s2,ws_m.s3,ws_m.s4);
        try
            % Calculate memory measures
            [ws_m.res.dprime]=f_calcmem(1,ws_m.sample(:,w.respcol), res.dprime.c9.fa_rate);
            [ws_m.res.rem]=f_calcmem(2,ws_m.sample(:,w.respcol), res.rem.c9.fa_rate);
            [ws_m.res.know]=f_calcmem(3,ws_m.sample(:,w.respcol), res.know.c9.fa_rate);
            [ws_m.res.surerem]=f_calcmem(4,ws_m.sample(:,w.respcol), res.surerem.c9.fa_rate);
            [ws_m.res.sureknow]=f_calcmem(5,ws_m.sample(:,w.respcol), res.sureknow.c9.fa_rate);
            [ws_m.res.rec_corrhitrate]=f_calcmem(6,ws_m.sample(:,w.respcol), res.rec_hitrate.c9.fa_rate);
            [ws_m.res.rec_uncorrhitrate]=f_calcmem(7,ws_m.sample(:,w.respcol), res.rec_hitrate.c9.fa_rate);            
            if ws_m.res.dprime.n_trials <w.minimum_ntrials % Catch for minimum number of trials
                ws_m.res.dprime.dprime=[];
                ws_m.res.rem.rate=[];
                ws_m.res.know.rate=[];
                ws_m.res.surerem.rate=[];
                ws_m.res.sureknow.rate=[];
                ws_m.res.rec_corrhitrate.rate=[];
                ws_m.res.rec_uncorrhitrate.rate=[];
            end
        catch 
            ws_m.res.dprime.dprime=[];
            ws_m.res.rem.rate=[];
            ws_m.res.know.rate=[];
            ws_m.res.surerem.rate=[];
            ws_m.res.sureknow.rate=[];
            ws_m.res.rec_corrhitrate.rate=[];
            ws_m.res.rec_uncorrhitrate.rate=[];
        end
        % CALCULATE DIFFERENCE -------------------------------------------------
        ws.summname=instruc_diff{j,1};
        ws.res.dprime=ws_p.res.dprime.dprime-ws_m.res.dprime.dprime;
        ws.res.rem=ws_p.res.rem.rate-ws_m.res.rem.rate;
        ws.res.surerem=ws_p.res.surerem.rate-ws_m.res.surerem.rate;
        ws.res.know=ws_p.res.know.rate-ws_m.res.know.rate;
        ws.res.sureknow=ws_p.res.sureknow.rate-ws_m.res.sureknow.rate;
        ws.res.rec_corrhitrate=ws_p.res.rec_corrhitrate.rate-ws_m.res.rec_corrhitrate.rate;
        ws.res.rec_uncorrhitrate=ws_p.res.rec_uncorrhitrate.rate-ws_m.res.rec_uncorrhitrate.rate;
        % Assign
        eval(['res.dprime.' ws.summname '=ws.res.dprime;']);
        eval(['res.rem.' ws.summname '=ws.res.rem;']);
        eval(['res.know.' ws.summname '=ws.res.know;']);
        eval(['res.surerem.' ws.summname '=ws.res.surerem;']);
        eval(['res.sureknow.' ws.summname '=ws.res.sureknow;']);        
        eval(['res.rec_corrhitrate.' ws.summname '=ws.res.rec_corrhitrate;']);        
        eval(['res.rec_uncorrhitrate.' ws.summname '=ws.res.rec_uncorrhitrate;']);        
        % Write to array
        if w.subject_number==1 % Headings
            d_dprime{1,j+w.extravar}=ws.summname;
            d_rem{1,j+w.extravar}=ws.summname;
            d_know{1,j+w.extravar}=ws.summname;
            d_surerem{1,j+w.extravar}=ws.summname;
            d_sureknow{1,j+w.extravar}=ws.summname;
            d_rec_corrhitrate{1,j+w.extravar}=ws.summname;
            d_rec_uncorrhitrate{1,j+w.extravar}=ws.summname;
        end
        eval(['d_dprime{w.subject_number+1, j+w.extravar}=res.dprime.' ws.summname ';'])
        eval(['d_rem{w.subject_number+1, j+w.extravar}=res.rem.' ws.summname ';'])
        eval(['d_know{w.subject_number+1, j+w.extravar}=res.know.' ws.summname ';'])
        eval(['d_surerem{w.subject_number+1, j+w.extravar}=res.surerem.' ws.summname ';'])
        eval(['d_sureknow{w.subject_number+1, j+w.extravar}=res.sureknow.' ws.summname ';'])
        eval(['d_rec_corrhitrate{w.subject_number+1, j+w.extravar}=res.rec_corrhitrate.' ws.summname ';'])
        eval(['d_rec_uncorrhitrate{w.subject_number+1, j+w.extravar}=res.rec_uncorrhitrate.' ws.summname ';'])
        clear('ws_p', 'ws_m', 'ws')
    end    
end

%%
    % Reset for next subject
    memtest.overalldprime=m_dprime{w.subject_number+1,w.extravar+1};
    cd([dataloc '2 Data'])
    cd(exptversion)
    cd(subjname)
    save([subjname '_file_3memorytest.mat'], 'memtest');
    %
    cd([dataloc '2 Data'])
    cd(exptversion)
    clear('res','wp', 'sample', 'ts', 'ts_all')
    w.subject_number=w.subject_number+1;
   end % subject loop


   w.dir=[];
    cd([dataloc '2 Data'])
end % experiment version
   
%% PRINT TO TXT DOCUMENT ###################################################

for o1=1:7 % Combine means & differences array
    % once for each type of memory
    switch o1
        case 1
            ws.dat=m_dprime;
            ws.dat_d=d_dprime;
        case 2
            ws.dat=m_rem;
            ws.dat_d=d_rem;
        case 3 
            ws.dat=m_know;
            ws.dat_d=d_know;
        case 4 
            ws.dat=m_surerem;
            ws.dat_d=d_surerem;
        case 5
            ws.dat=m_sureknow;
            ws.dat_d=d_sureknow;
        case 6
            ws.dat=m_rec_corrhitrate;
            ws.dat_d=d_rec_corrhitrate;
        case 7
            ws.dat=m_rec_uncorrhitrate;
            ws.dat_d=d_rec_uncorrhitrate;
    end
    [ws.res_meanrows ws.res_meancols]=size(ws.dat);
    [ws.res_diffrows ws.res_diffcols]=size(ws.dat_d);
    for i=1:ws.res_diffrows
        for j=1+w.extravar:ws.res_diffcols
            ws.j=j-w.extravar+ws.res_meancols;
            ws.dat{i, ws.j}=ws.dat_d{i,j};
        end
        if i==1% Print overall dprime
        else
        ws.dat{i,12}=m_dprime{i,12+1};
        end
    end
    switch o1 % Assign
        case 1
            r_dprime=ws.dat;
        case 2
            r_rem=ws.dat;
        case 3 
            r_know=ws.dat;
        case 4 
            r_surerem=ws.dat;
        case 5
            r_sureknow=ws.dat;
        case 6
            r_rec_corrhitrate=ws.dat;
        case 7
            r_rec_uncorrhitrate=ws.dat;
    end
    clear('ws')
end
for o1=1:7
    % Set up the correct file
    switch o1
        case 1 % dprime
            ws.measure='dprime';
            ws.dat=r_dprime;
        case 2 % remember
            ws.measure='rem';
            ws.dat=r_rem;
        case 3 % know
            ws.measure='know';
            ws.dat=r_know;
        case 4 % sure rememeber
            ws.measure='surerem';
            ws.dat=r_surerem;
        case 5 % sure know
            ws.measure='sureknow';
            ws.dat=r_sureknow;
        case 6 % corrected hit rates
            ws.measure='hitrate_corr';
            ws.dat=r_rec_corrhitrate;
        case 7 % corrected hit rates
            ws.measure='hitrate_uncorr';
            ws.dat=r_rec_uncorrhitrate;
    end
    % Setup output file
    cd([dataloc '3 Analysis inputs'])
    w.fid=fopen(['(' date ') (' w.seedname ') ' num2str(o1) ' ' ws.measure '.txt'],'wt');
    % Write headings
    [ws.nrows ws.ncols]=size(ws.dat);
    fprintf(w.fid, '%s \t',ws.dat{1,1:ws.ncols});
    fprintf(w.fid,'\n');
    % Write data
    for i=2:ws.nrows % Data from Row 2
        fprintf(w.fid, '%s \t %d \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t', ws.dat{i,1:w.extravar}); % Subject details
%         fprintf(w.fid, '%s \t %d \t %s \t %8d\t', ws.dat{i,1:w.extravar}); % Subject details    
        fprintf(w.fid, '%0.5f \t', ws.dat{i, w.extravar+1:ws.ncols}); % Data
        fprintf(w.fid,'\n');    
    end    
    % Finish
    clear('ws')
    fclose(w.fid);
end

 