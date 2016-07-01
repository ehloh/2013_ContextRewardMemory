% eval_learning

clear all
clc

% where.where='C:\Documents and Settings\Nico\Desktop\6 [v3.3 Seeds] Experiment MDeacon\3 Analysis\';
where.where='/Volumes/SANDISK/9 Matthew Deacon manuscript/3 Analysis';
where.scripts=[where.where filesep '1 Analysis scripts'];
where.data=[where.where filesep '2 Data new ELacquired' filesep 'v3_5'];
where.output=[where.where filesep '3 Analysis inputs'];
load([where.scripts filesep 'i_eval1_memseeds_v3-5.mat']) % load instuction file
exptversion='3_5';


for o2=1:1 % Documentation
    
% Instructions list
%   Col 1: Name
%   Col 3: Cells to combine
%   Col 4: Order for printing   
    
% Details for workspace
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
for o1=1:1 % Options & Setup for analysis

    % Data specifications (which column
    enc_col.itemval=5;
    enc_col.simordis=3;
    enc_col.seed=0;
    col.RT=12;
    col.accuracy=13;
    col.instruclist_cells2combine=7; % In instructions list 
    
    
    % Instructions list tells you which samples to combine, to calculate
    % memory measures for
    %   'instruc': group means
    %             Col 1: Name of measure
    %             Col 7: Cells to be combined
    %
    % CELLS
    %       Cell 1=SimR, Cell 2=SimN, Cell 3=DisR, Cell 4=DisN
    

    w.extravar=12;
end

cd([where.data])
w.dir_versions=dir;
w.subject_number=1;

%%
disp(exptversion)
w.dir=dir('p*');

   for i1=1:length(w.dir)
        subjname=w.dir(i1).name;
%         subjname='p179_DO'; 
        disp(subjname)
        cd(subjname)
        load(strcat(subjname,'_file_1learning.mat'))
        load(strcat(subjname,'_file_2encoding.mat'))
        load(strcat(subjname,'_file_3memorytest.mat'))
        wp.ts_all{1}=learning.trialstats;
        wp.ts_all{2}=encoding.trialstats_1item; % 1 item version
        try
            counterbal_version=memtest.settings.counterbalance_ver;
        catch
            counterbal_version=0;
        end

for o1=1:1 % Output off
% % Outputs
% for o1=1:1 % Outputs
%     if w.subject_number==1 % Headings (general)
%         clear('w.template')
%         w.template{1,1}='Expt_version';
%         w.template{1,2}='Counterbal';
%         w.template{1,3}='Subject';
%         w.template{1,4}='p.NS_1';
%         w.template{1,5}='p.NS_2';
%         w.template{1,6}='p.NS_3';
%         w.template{1,7}='p.NS_4';
%         w.template{1,8}='p.RD_1';
%         w.template{1,9}='p.RD_2';
%         w.template{1,10}='p.RD_3';
%         w.template{1,11}='p.RD_4';
%         w.template{1,12}='dprime'; % Headings (measures)
%         [w.ninstruc w.a]=size(instruc);
%         for i= 1:w.ninstruc
%             w.template{1,w.extravar+i}=instruc{i,1};
%         end
%         for j=1:w.extravar+w.ninstruc
%             r_learn_accuracy{1,j}=w.template{1,j};
%             r_learn_RT{1,j}=w.template{1,j};
%             r_enc_accuracy{1,j}=w.template{1,j};
%             r_enc_RT{1,j}=w.template{1,j};
%         end
%     end
%     w.template=[];
%     w.template{1,1}=exptversion; % Load subject details
% %     w.template{1,2}=counterbal_version;
%     w.template{1,3}=subjname;
% %     w.template{1,4}=memtest.TPQ.NS(1);
% %     w.template{1,5}=memtest.TPQ.NS(2);
% %     w.template{1,6}=memtest.TPQ.NS(3);
% %     w.template{1,7}=memtest.TPQ.NS(4);
% %     w.template{1,8}=memtest.TPQ.RD(1);
% %     w.template{1,9}=memtest.TPQ.RD(2);
% %     w.template{1,10}=memtest.TPQ.RD(3);
% %     w.template{1,11}=memtest.TPQ.RD(4);
% %     w.template{1,12}=memtest.overalldprime;
%     for j=1:w.extravar
%         r_learn_accuracy{w.subject_number+1,j}=w.template{1,j};
%         r_learn_RT{w.subject_number+1,j}=w.template{1,j};
%         r_enc_accuracy{w.subject_number+1,j}=w.template{1,j};
%         r_enc_RT{w.subject_number+1,j}=w.template{1,j};
%     end
%     w.template=[];
% end
% r_learn_accuracy{i1+1,1}=subjname;
% r_learn_RT{i1+1,1}=subjname;
% r_enc_accuracy{i1+1,1}=subjname;
% r_enc_RT{i1+1,1}=subjname;
end

%%  PRE-PROCESSING #################

for o1=1:2 % Sort into cell samples (all) 
    ws.ts=wp.ts_all{o1};
    
%     disp('Dummy sim or dis!')
%     ws.ts(:,enc_col.simordis)=randi(2, size(ws.ts,1),1);
    [w.sizen w.a]=size(ws.ts);
    ws.sample.c1=[];
    ws.sample.c2=[];
    ws.sample.c3=[];
    ws.sample.c4=[];
    for i=1:w.sizen
        switch [num2str(ws.ts(i,enc_col.simordis)) num2str(ws.ts(i,enc_col.itemval))]
            %       Cell 1=SimR, Cell 2=SimN, Cell 3=DisR, Cell 4=DisN
            case '11'
                ws.sample.c1=vertcat(ws.sample.c1,ws.ts(i,:));
            case '10'
                ws.sample.c2=vertcat(ws.sample.c2,ws.ts(i,:));
            case '21'
                ws.sample.c3=vertcat(ws.sample.c3,ws.ts(i,:));
            case '20'
                ws.sample.c4=vertcat(ws.sample.c4,ws.ts(i,:));
        end
    end
    switch o1
        case 1
            allsample_L=ws.sample;
        case 2
            allsample_E=ws.sample;
    end
    clear('ws')
end
for o1=1:2 % Remove incorrect responses
    ws.ts_all=wp.ts_all{o1};
    [ws.sizen w.a]=size(ws.ts_all);
    ws.ts=[];
    for i=1:ws.sizen
        if ws.ts_all(i,13)==1
            ws.ts=vertcat(ws.ts,ws.ts_all(i,:));
        end
    end
    wp.ts{o1}=ws.ts;
    clear('ws')
end
for o1=1:2 % Sort into cell samples
    ws.ts=wp.ts{o1};
%     disp('Dummy sim or dis!')
%     ws.ts(:,enc_col.simordis)=randi(2, size(ws.ts,1),1);
    [w.sizen w.a]=size(ws.ts);
    ws.sample.c1=[];
    ws.sample.c2=[];
    ws.sample.c3=[];
    ws.sample.c4=[];
    for i=1:w.sizen
        switch [num2str(ws.ts(i,enc_col.simordis)) num2str(ws.ts(i,enc_col.itemval))]
            %       Cell 1=SimR, Cell 2=SimN, Cell 3=DisR, Cell 4=DisN
            case '11'
                ws.sample.c1=vertcat(ws.sample.c1,ws.ts(i,:));
            case '10'
                ws.sample.c2=vertcat(ws.sample.c2,ws.ts(i,:));
            case '21'
                ws.sample.c3=vertcat(ws.sample.c3,ws.ts(i,:));
            case '20'
                ws.sample.c4=vertcat(ws.sample.c4,ws.ts(i,:));
        end
    end
    switch o1
        case 1
            sample_L=ws.sample;
        case 2
            sample_E=ws.sample;
    end
    clear('ws')
end

%% ANALYSIS

for o1=1:2 % Extract means
% Ignoring seeds during encoding
    switch o1
        case 1
            wm.sample=sample_L;
            wm.allsample=allsample_L;
        case 2
            wm.sample=sample_E;
            wm.allsample=allsample_E;
    end
    [w.n_instruc w.a]=size(instruc);
    wm.sample.c0=[]; % Dummies
    wm.allsample.c0=[];
    for j=1:w.n_instruc
        for i=1:4
            eval(['ws.s' num2str(i) '=wm.sample.c' char(instruc{j,col.instruclist_cells2combine}(i)) ';']) % Sample for RT
            eval(['ws.alls' num2str(i) '=wm.allsample.c' char(instruc{j,col.instruclist_cells2combine}(i)) ';']) % Sample for accuracy score
        end
        ws.sample=vertcat(ws.s1,ws.s2,ws.s3,ws.s4);
        ws.allsample=vertcat(ws.alls1,ws.alls2,ws.alls3,ws.alls4);

        % Extract cell means
        ws.meanaccuracy=mean(ws.allsample(:,col.accuracy));
        ws.meanRT=mean(ws.sample(:,col.RT));
        % Write to array
        switch o1
            case 1 % Learning 
                r_learn_accuracy{w.subject_number+1,w.extravar+j}=ws.meanaccuracy;
                r_learn_RT{w.subject_number+1,w.extravar+j}=ws.meanRT;
            case 2 % Encoding
                r_enc_accuracy{w.subject_number+1,w.extravar+j}=ws.meanaccuracy;
                r_enc_RT{w.subject_number+1,w.extravar+j}=ws.meanRT;
        end
        clear('ws')
    end
    clear('wm')
end

% 
w.subject_number=w.subject_number+1;
clear('ts_l','ts_e','sample_E','sample_L','allsample_E','allsample_L')
wp=[];
cd ..
   end % subject loop

   
%% PRINT TO TXT DOCUMENT ###################################################
for i=1:w.n_instruc % Headings
    r_learn_RT{1,i+w.extravar}=instruc{i,1};
    r_learn_accuracy{1,i+w.extravar}=instruc{i,1};
    r_enc_RT{1,i+w.extravar}=instruc{i,1};
    r_enc_accuracy{1,i+w.extravar}=instruc{i,1};
end
for o1=1:2 % Combine accuracy & RT files
    switch o1
        case 1 % Learning
            ws.rt=r_learn_RT;
            ws.acc=r_learn_accuracy;
        case 2 % Encoding
            ws.rt=r_enc_RT;
            ws.acc=r_enc_accuracy;
    end
    for i1=1:w.n_instruc % Change headings to reflect RT / Acc
        i=i1+w.extravar;
        ws.acc{1,i}=['acc.' ws.acc{1,i}];
        ws.rt{1,i}=['rt.' ws.rt{1,i}];
    end
    ws.res=ws.acc;
    [ws.nrows ws.ncols]=size(ws.rt);
    for i=1:ws.nrows
        for j=1:w.n_instruc
        ws.res{i,ws.ncols+j}=ws.rt{i,w.extravar+j};
        end 
    end
    for i=1:size(w.dir,1) % Mark name
        ws.res{i+1,1}=w.dir(i).name;
    end
    switch o1
        case 1 % Learning
            r_learn=ws.res;
        case 2 % Encoding
            r_enc=ws.res;
    end
    clear('ws')
end
for o1=1:2
    % Set up the correct file
    switch o1
        case 1 
            ws.measure='learn';
            ws.dat=r_learn;
        case 2
            ws.measure='enc';
            ws.dat=r_enc;
    end
    % Print to txt file
    cd(where.scripts)
    printreport=print2txt(where.output, ['(' date ') 0-' num2str(o1) ' ' ws.measure],ws.dat);    
end
