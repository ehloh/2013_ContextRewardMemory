% Master memory script
clear all; clc; 

version='v3.2';
where.where='/Volumes/PENNYDISK/6 [v3 Seeds] Experiment MDeacon/3 Analysis';
% where.where='H:\6 [v3 Seeds] Experiment MDeacon\3 Analysis';
where.data=[where.where filesep '2 Data' filesep version];
where.scripts=[where.where filesep '1 Analysis scripts'];
where.printfiles=[where.where filesep '3 Analysis inputs' filesep version];

for o1=1:1 % Data specifications for this experiment
    col.itemvalence=9;
    col.enc_accuracy=8;
    col.cellnum=33;
    col.simordis=7;
    col.seedtrialtype=15;
    col.trulyoldornew=3;
    col.resp_ROC=33;
    col.resp_oldornew=18;
    col.resp_remknow=col.resp_oldornew+2;
    col.resp_sureunsure=col.resp_remknow+2;
    col.assocmem_truepos=29;
    col.assocmem_posresp=30;
    col.assocmem_accuracy=32;
    
    load([where.scripts filesep 'i_eval1_memseeds_v3-4.mat']) % load instuction file
    
    % Instructions list tells you which samples to combine, to calculate
    % memory measures for
    %   'instruc': group means
    %             Col 1: Name of measure
    %             Col 7: Cells to be combined
    %   'instruc_diff': difference scores
    %             Col 1: Name of measure
    %             Col 7: Cells to be combined
    %             Col 8: Combined cells to be subtracted
    %  'measures': memory measures to be calculated 
    %           e.g. dprime, rem, know, assocmemory etc
    %
    % CELLS
    %       Cell 1=SimR, Cell 2=SimN, Cell 3=DisR, Cell 4=DisN
    
end

%% PRE-PROCESSING
% 'memdata' - Col 1: Raw trialstats
%                    Col 2: Data split into cells
%                    Col 3: Subject's workspace, for calculating memory scores
%                    Col 4: Subject's workspace, for calculating difference scores
%                    Col 5: Subject's workspace, for calculating associative memory

cd(where.data)
w.dir=dir('p*');
cd(where.scripts)
memdata=cell(size(w.dir,1),3);

for s=1:size(w.dir,1) % Load up all subject's data + mark response indicators
    ws.subjname=w.dir(s).name;
    % (1) Load memory test data ('sub')
    ws.d=load([where.data filesep ws.subjname filesep ws.subjname '_file_3memorytest.mat']); % If details regarding organization & naming of files need to be changed, change it here
    ws.ts_all=ws.d.memtest.trialstats;
    ws.tsf=ws.d.memtest.trialstats(ws.d.memtest.trialstats(:,col.trulyoldornew)==2,:);
    ws.ts=ws.d.memtest.trialstats(ws.d.memtest.trialstats(:,col.enc_accuracy)==1,:); % Delete trials that were correctly judged during encoding
    ws.ts=vertcat(ws.ts,ws.tsf);
    % (2) Mark ROC response type (Col 33)
    %             1=Sure New
    %             2= Unsure New
    %             3= U K 
    %             4= S K
    %             5= U R
    %             6= S R
    for i=1:size(ws.ts,1)
        if ws.ts(i,col.resp_oldornew)==2 % New
             switch num2str(ws.ts(i,col.resp_sureunsure))
                case '1'
                    ws.ts(i,col.resp_ROC)=1;
                case '2'
                    ws.ts(i,col.resp_ROC)=2;
             end
        else % Old
            switch [num2str(ws.ts(i,col.resp_remknow)) num2str(ws.ts(i,col.resp_sureunsure))]
                case '22'
                    ws.ts(i,col.resp_ROC)=3;
                case '21'
                    ws.ts(i,col.resp_ROC)=4;
                case '12'
                    ws.ts(i,col.resp_ROC)=5;
                case '11'
                    ws.ts(i,col.resp_ROC)=6;
            end
        end
    end
    % (3) Mark accuracy of position if it is not yet marked
%     if sum(ws.ts(:, col.assocmem_accuracy))==0
        for i=1:size(ws.ts,1)
            if ws.ts(i, col.assocmem_truepos)==ws.ts(i,col.assocmem_posresp)
                ws.ts(i, col.assocmem_accuracy)=1;
            else
                ws.ts(i, col.assocmem_accuracy)=0;
            end
        end
%     end
    memdata{s,1}=ws.ts;
    ws=[];
end
for s=1:size(w.dir,1) % Split into cell-samples (according to v3.2)
    ws.ts=memdata{s,1};
    ws.foils=ws.ts(ws.ts(:,3)==2,:); 
    % (Cell 1=SimR, Cell 2=SimN, Cell 3=DisR, Cell 4=DisN)
    ws.s1=ws.ts(ws.ts(:,col.trulyoldornew)==1 & ws.ts(:,col.simordis)==1 & ws.ts(:,col.itemvalence)==1,:);
    ws.s2=ws.ts(ws.ts(:,col.trulyoldornew)==1 & ws.ts(:,col.simordis)==1 & ws.ts(:,col.itemvalence)==0,:);
    ws.s3=ws.ts(ws.ts(:,col.trulyoldornew)==1 & ws.ts(:,col.simordis)==2 & ws.ts(:,col.itemvalence)==1,:);
    ws.s4=ws.ts(ws.ts(:,col.trulyoldornew)==1 & ws.ts(:,col.simordis)==2 & ws.ts(:,col.itemvalence)==0,:);
    ws.s1_4=ws.s1(ws.s1(:,col.seedtrialtype)==1,:); % Seed type is marked 1-4: (1=[00],2=[+0],2.5=[0+],3=[++])
    ws.s1_2=ws.s1(ws.s1(:,col.seedtrialtype)==2,:);
    ws.s1_3=ws.s1(ws.s1(:,col.seedtrialtype)==2.5,:);
    ws.s1_1=ws.s1(ws.s1(:,col.seedtrialtype)==3,:);
    ws.s2_4=ws.s2(ws.s2(:,col.seedtrialtype)==1,:);
    ws.s2_2=ws.s2(ws.s2(:,col.seedtrialtype)==2,:);
    ws.s2_3=ws.s2(ws.s2(:,col.seedtrialtype)==2.5,:);
    ws.s2_1=ws.s2(ws.s2(:,col.seedtrialtype)==3,:);
    ws.s3_4=ws.s3(ws.s3(:,col.seedtrialtype)==1,:);
    ws.s3_2=ws.s3(ws.s3(:,col.seedtrialtype)==2,:);
    ws.s3_3=ws.s3(ws.s3(:,col.seedtrialtype)==2.5,:);
    ws.s3_1=ws.s3(ws.s3(:,col.seedtrialtype)==3,:);
    ws.s4_4=ws.s4(ws.s4(:,col.seedtrialtype)==1,:);
    ws.s4_2=ws.s4(ws.s4(:,col.seedtrialtype)==2,:);
    ws.s4_3=ws.s4(ws.s4(:,col.seedtrialtype)==2.5,:);
    ws.s4_1=ws.s4(ws.s4(:,col.seedtrialtype)==3,:);
    disp('Note: Seed-sorting is according to v3.2, but labelling is as per 1.4')
    if size(ws.s1,1)+size(ws.s2,1)+size(ws.s3,1)+size(ws.s4,1)+size(ws.foils,1)~=size(ws.ts,1)
        disp('Error in cell-sorting: trials in all cells ~=Total number of trials')
    end
    memdata{s,2}=ws; 
end

%% Item recognition memory

for s=1:size(w.dir,1) % FA rates (dprime, rem, know, surerem, sureknow, hitrate, surehitrate) 
    % generally, FA rate=(new, rated old)/total number of new
    memdata{s,2}.FA.hitrate=size(find(memdata{s,2}.foils(:,col.resp_oldornew)==1),1)/size(memdata{s,2}.foils,1);
    memdata{s,2}.FA.dprime=memdata{s,2}.FA.hitrate;
    memdata{s,2}.FA.rem=size(find(memdata{s,2}.foils(:,col.resp_remknow)==1),1)/size(memdata{s,2}.foils,1);
    memdata{s,2}.FA.know=size(find(memdata{s,2}.foils(:,col.resp_remknow)==2),1)/size(memdata{s,2}.foils,1);
    memdata{s,2}.FA.surerem=size(find(memdata{s,2}.foils(:,col.resp_remknow)==1 & memdata{s,2}.foils(:,col.resp_sureunsure)==1),1)/size(memdata{s,2}.foils,1);
    memdata{s,2}.FA.sureknow=size(find(memdata{s,2}.foils(:,col.resp_remknow)==2 & memdata{s,2}.foils(:,col.resp_sureunsure)==1),1)/size(memdata{s,2}.foils,1);
    memdata{s,2}.FA.surehitrate=size(find(memdata{s,2}.foils(:,col.resp_oldornew)==1 & memdata{s,2}.foils(:,col.resp_sureunsure)==1),1)/size(memdata{s,2}.foils,1);
end

% Calculate memory statistic for all grouped-cells (execute instruction list)
m_dprime=cell(size(w.dir,1), size(instruc,1)); % Preallocations
m_rem=cell(size(w.dir,1), size(instruc,1));
m_know=cell(size(w.dir,1), size(instruc,1));
m_surerem=cell(size(w.dir,1), size(instruc,1));
m_sureknow=cell(size(w.dir,1), size(instruc,1));
m_hitrate=cell(size(w.dir,1), size(instruc,1));
m_surehitrate=cell(size(w.dir,1), size(instruc,1));
for s=1:size(w.dir,1)
ws=[];
ws=memdata{s,2};
ws.s0=[]; % dummy
    for i=1:size(instruc,1) % Excute entire instruction list
        wc=[];
        % Compile samples
        eval(char(strcat('wc.sample=vertcat(ws.s', instruc{i,7}(1), ', ws.s', instruc{i,7}(2), ', ws.s', instruc{i,7}(3), ', ws.s', instruc{i,7}(4), ');')))
        if size(wc.sample,1)>0
            % Calculate
            memdata{s,3}.mdprime=f_calcmem(1,wc.sample(:,col.resp_ROC),memdata{s,2}.FA.dprime);
            memdata{s,3}.mrem=f_calcmem(2,wc.sample(:,col.resp_ROC),memdata{s,2}.FA.rem);
            memdata{s,3}.mknow=f_calcmem(3,wc.sample(:,col.resp_ROC),memdata{s,2}.FA.know);
            memdata{s,3}.msurerem=f_calcmem(4,wc.sample(:,col.resp_ROC),memdata{s,2}.FA.surerem);
            memdata{s,3}.msureknow=f_calcmem(5,wc.sample(:,col.resp_ROC),memdata{s,2}.FA.sureknow);
            memdata{s,3}.mhitrate=f_calcmem(6,wc.sample(:,col.resp_ROC),memdata{s,2}.FA.hitrate);
            % Output to group matrix
            m_dprime{s,i}=memdata{s,3}.mdprime.rate;
            m_rem{s,i}=memdata{s,3}.mrem.rate;
            m_know{s,i}=memdata{s,3}.mknow.rate;
            m_surerem{s,i}=memdata{s,3}.msurerem.rate;
            m_sureknow{s,i}=memdata{s,3}.msureknow.rate;
            m_hitrate{s,i}=memdata{s,3}.mhitrate.rate;
            m_surehitrate{s,i}=(sum(wc.sample(:,col.resp_oldornew)==1 & wc.sample(:,col.resp_sureunsure)==1)/sum(wc.sample(:,col.trulyoldornew)==1))-memdata{s,2}.FA.surehitrate; % Manually calculate sure-hitrate: (actually old, rated sure old)/total n old     -    (actually new, rated sure old)/total n new
        else
            m_dprime{s,i}=[];
            m_rem{s,i}=[];
            m_know{s,i}=[];
            m_surerem{s,i}=[];
            m_sureknow{s,i}=[];
            m_hitrate{s,i}=[];
            m_surehitrate{s,i}=[];
        end
    end
end

% Calculate difference scores (execute difference-instruction list)
d_dprime=cell(size(w.dir,1), size(instruc_diff,1)); % Preallocations
d_rem=cell(size(w.dir,1), size(instruc_diff,1));
d_know=cell(size(w.dir,1), size(instruc_diff,1));
d_surerem=cell(size(w.dir,1), size(instruc_diff,1));
d_sureknow=cell(size(w.dir,1), size(instruc_diff,1));
d_hitrate=cell(size(w.dir,1), size(instruc_diff,1));
d_surehitrate=cell(size(w.dir,1), size(instruc_diff,1));
for s=1:size(w.dir,1)
ws=[];
ws=memdata{s,2};
ws.s0=[]; % dummy
    for i=1:size(instruc_diff,1) % Excute entire instruction list
        wc=[];
        % Compile plus & minus samples
        eval(char(strcat('wc.psample=vertcat(ws.s', instruc_diff{i,7}(1), ', ws.s', instruc_diff{i,7}(2), ', ws.s', instruc_diff{i,7}(3), ', ws.s', instruc_diff{i,7}(4), ');')))
        eval(char(strcat('wc.msample=vertcat(ws.s', instruc_diff{i,8}(1), ', ws.s', instruc_diff{i,8}(2), ', ws.s', instruc_diff{i,8}(3), ', ws.s', instruc_diff{i,8}(4), ');')))
        if size(wc.psample,1)>0 && size(wc.msample,1)>0
            % Calculate 'plus' scores
            memdata{s,4}.pdprime=f_calcmem(1,wc.psample(:,col.resp_ROC),memdata{s,2}.FA.dprime);
            memdata{s,4}.prem=f_calcmem(2,wc.psample(:,col.resp_ROC),memdata{s,2}.FA.rem);
            memdata{s,4}.pknow=f_calcmem(3,wc.psample(:,col.resp_ROC),memdata{s,2}.FA.know);
            memdata{s,4}.psurerem=f_calcmem(4,wc.psample(:,col.resp_ROC),memdata{s,2}.FA.surerem);
            memdata{s,4}.psureknow=f_calcmem(5,wc.psample(:,col.resp_ROC),memdata{s,2}.FA.sureknow);
            memdata{s,4}.phitrate=f_calcmem(6,wc.psample(:,col.resp_ROC),memdata{s,2}.FA.hitrate);
            memdata{s,4}.psurehitrate=f_calcmem(6,wc.psample(wc.psample(:,col.resp_sureunsure)==1,col.resp_ROC),memdata{s,2}.FA.surehitrate);
            % Calculate 'minus' scores
            memdata{s,4}.mdprime=f_calcmem(1,wc.msample(:,col.resp_ROC),memdata{s,2}.FA.dprime);
            memdata{s,4}.mrem=f_calcmem(2,wc.msample(:,col.resp_ROC),memdata{s,2}.FA.rem);
            memdata{s,4}.mknow=f_calcmem(3,wc.msample(:,col.resp_ROC),memdata{s,2}.FA.know);
            memdata{s,4}.msurerem=f_calcmem(4,wc.msample(:,col.resp_ROC),memdata{s,2}.FA.surerem);
            memdata{s,4}.msureknow=f_calcmem(5,wc.msample(:,col.resp_ROC),memdata{s,2}.FA.sureknow);
            memdata{s,4}.mhitrate=f_calcmem(6,wc.msample(:,col.resp_ROC),memdata{s,2}.FA.hitrate);
            memdata{s,4}.msurehitrate=f_calcmem(6,wc.msample(wc.msample(:,col.resp_sureunsure)==1,col.resp_ROC),memdata{s,2}.FA.surehitrate);
            % Calculate difference + output to group matrix
            d_dprime{s,i}=memdata{s,4}.pdprime.rate-memdata{s,4}.mdprime.rate;
            d_rem{s,i}=memdata{s,4}.prem.rate-memdata{s,4}.mrem.rate;
            d_know{s,i}=memdata{s,4}.pknow.rate-memdata{s,4}.mknow.rate;
            d_surerem{s,i}=memdata{s,4}.psurerem.rate-memdata{s,4}.msurerem.rate;
            d_sureknow{s,i}=memdata{s,4}.psureknow.rate-memdata{s,4}.msureknow.rate;
            d_hitrate{s,i}=memdata{s,4}.phitrate.rate-memdata{s,4}.mhitrate.rate;
            d_surehitrate{s,i}=memdata{s,4}.psurehitrate.rate-memdata{s,4}.msurehitrate.rate;
        else
            d_dprime{s,i}=[];
            d_rem{s,i}=[];
            d_know{s,i}=[];
            d_surerem{s,i}=[];
            d_sureknow{s,i}=[];
            d_hitrate{s,i}=[];
            d_surehitrate{s,i}=[];
        end
    end
end

%% Associative memory
%        Assoc mem=# position correctly recognized/# old recognized as old

% Mean scores
m_assoc_percentrec=cell(size(w.dir,1), size(instruc,1));
m_assoc=cell(size(w.dir,1), size(instruc,1));
for s=1:size(w.dir,1)
ws=[];
ws=memdata{s,2};
ws.s0=[]; % dummy
    for i=1:size(instruc,1) % Excute entire instruction list
        wc=[];
        % Compile samples & calculate
        eval(char(strcat('wc.sample=vertcat(ws.s', instruc{i,7}(1), ', ws.s', instruc{i,7}(2), ', ws.s', instruc{i,7}(3), ', ws.s', instruc{i,7}(4), ');')))
        if size(wc.sample,1)>0
            wc.nhits=size(find(wc.sample(:,col.assocmem_accuracy)==1 & wc.sample(:,col.resp_oldornew)==1),1);
            wc.nrecold=size(find(wc.sample(:,col.resp_oldornew)==1),1); % Assoc mem=# position correctly recognized/# old recognized as old
            % Output to group matrix
            m_assoc{s,i}=wc.nhits/size(wc.sample,1);
            m_assoc_percentrec{s,i}=wc.nhits/wc.nrecold;
        else
            m_assoc{s,i}=[];
            m_assoc_percentrec{s,i}=[];
        end
    end
end

% Difference scores
d_assoc_percentrec=cell(size(w.dir,1), size(instruc_diff,1));
d_assoc=cell(size(w.dir,1), size(instruc_diff,1));
for s=1:size(w.dir,1)
ws=[];
ws=memdata{s,2};
ws.s0=[]; % dummy
    for i=1:size(instruc_diff,1) % Excute entire instruction list
        wc=[];
        % Compile samples & calculate (plus sample)
        eval(char(strcat('wc.psample=vertcat(ws.s', instruc_diff{i,7}(1), ', ws.s', instruc_diff{i,7}(2), ', ws.s', instruc_diff{i,7}(3), ', ws.s', instruc_diff{i,7}(4), ');')))
        eval(char(strcat('wc.msample=vertcat(ws.s', instruc_diff{i,8}(1), ', ws.s', instruc_diff{i,8}(2), ', ws.s', instruc_diff{i,8}(3), ', ws.s', instruc_diff{i,8}(4), ');')))
        if size(wc.psample,1)>0 && size(wc.msample,1)>0
            % Calculate scores (plus & minus)
            wc.p_nhits=size(find(wc.psample(:,col.assocmem_accuracy)==1 & wc.psample(:,col.resp_oldornew)==1),1);
            wc.p_nrecold=size(find(wc.psample(:,col.resp_oldornew)==1),1); % Assoc mem=# position correctly recognized/# old recognized as old
            wc.m_nhits=size(find(wc.msample(:,col.assocmem_accuracy)==1 & wc.msample(:,col.resp_oldornew)==1),1);
            wc.m_nrecold=size(find(wc.msample(:,col.resp_oldornew)==1),1); % Assoc mem=# position correctly recognized/# old recognized as old
            % Output to group matrix
            d_assoc_percentrec{s,i}=wc.p_nhits/wc.p_nrecold-wc.m_nhits/wc.m_nrecold;
            d_assoc{s,i}=wc.p_nhits/size(wc.psample,1)-wc.m_nhits/size(wc.msample,1);
        else
            d_assoc_percentrec{s,i}=[];
            d_assoc{s,i}=[];
        end
    end
end

%% Compile subject details

subj_titles={'subject' 'counterbal' 'NS_1' 'NS_2' 'NS_3' 'NS_4' 'RS_1' 'RS_2' 'RS_3' 'RS_4' 'overallDprime' 'overallSurehitrate'};
subj=cell(size(w.dir,1),12);
for s=1:size(w.dir,1)
    subj{s,1}=w.dir(s).name;
%     subj{s,2}=counterbalancing
%     try % TPQ: Col 3-10 for TPQ
%     catch
%     end
    subj{s,11}=m_dprime{s,1}; % Assuming first score is overall
    subj{s,12}=m_surehitrate{s,1};
end

%% Output to SPSS

% Combine all data: subject specs, mean scores, difference scores, titles
headers=horzcat(subj_titles, instruc{:,1},instruc_diff{:,1});
for m=1:size(measures,1)
    ws=[];
    eval(['ws.sample=horzcat(subj, m_' measures{m} ', d_' measures{m} ');'])
    ws.sample=vertcat(headers, ws.sample);
    eval([measures{m} '=ws.sample;']) % To save in Matlab, save measures here
    [printok]=print2txt(where.printfiles, ['(' date ') ' num2str(m) ' ' measures{m}], ws.sample);
    disp([measures{m} ': File print=' num2str(printok.fileprint) ', File moved=' num2str(printok.filemoved)])
end


