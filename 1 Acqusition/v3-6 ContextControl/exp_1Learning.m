% LEARNING PHASE 
clear all; clc

testing=0;

for o1=1:1 % Documentation
    
    col.SceneStim=[1 2];
    col.SimDis=3;
    col.Trialnum=4;
    %
    col.ItemRespCat=5; % Typical correct response, 1=Up, 2=Down
    col.ItemRespCorr=6; % Actual correct response
    %
    col.ItemType=7; % 1=Natural, 2=Man-made
    col.ItemStim=8;
    col.ItemPos=9;
    col.Resp=10; % 1=Up, 2=Down
    col.RespRT=11;
    col.ItemAccuracy=12;
    
end
for o1=1:1 % TESTING or Coding?
    
    if testing==0   % Not testing
        disp('Coding mode')
        p.subjectlog.name='t2';
        w.screenmode=0;
    elseif testing==1 % testing
        p.subjectlog.name=input('Subject ID: ','s');
        w.screenmode=1;
    end
    
    p.contextcounterbal=input('Context counterbal (1-16):');
    p.itemcounterbal=input('Item counterbalancing version (1-2) : '); % Relates only to Learning UpDown task
    p.contextstartblockcounterbal=(p.contextcounterbal/2==floor(p.contextcounterbal/2))+1;
    try
        where=pwd;
        cd(where)
        load(['Stimuli' filesep 'stimlist.mat'])
    catch
        where=pwd;
        cd(where)
        try
            load Stimuli\stimlist.mat
        catch
            disp('Wrong directory: Move to the correct Matlab folder!')
            input('Stop script now','s')
        end
    end
end
for o1=1:1 % PARAMETERS: General
    rand('state',sum(100*clock));% Make sure the random numbers are really random
    p.contingency_high=0.7;
    p.n.ntrials=64;
    p.n.contexts=4;
    if round(p.n.ntrials/p.n.contexts)~=p.n.ntrials/p.n.contexts; error('Number of trials must be a multiple of 4!'); end
    p.n.dummyitems=20;  % Used in this Learning phase
    p.nreps_percontext=p.n.ntrials/p.n.contexts;
    %
    p.disp.fixationtime=500;
    p.disp.framelength_enc=2000;  % Length of presentation for ENCODING phase
    p.disp.framelength_learn=2000;  % Length of presentation for initial learning phase (pair learning)
    p.disp.sizescene=680;
    p.disp.sizeitem=275;
    p.disp.posx=0;
    p.disp.posy=0;
    p.disp.pos1_x=-160;
    p.disp.pos1_y=200;
    p.disp.pos2_x=160;
    p.disp.pos2_y=200;
    p.disp.pos3_x=-160;
    p.disp.pos3_y=-140;
    p.disp.pos4_x=160;
    p.disp.pos4_y=-140;
    p.resp.premature=100;
    p.resp.item_natural=98; % Right=98
    p.resp.item_manmade=97; % Left=97
    p.resp.up=95; % Up=95
    p.resp.down=100; % Down=100
    w.line=50;
    w.line1=40;
    w.res=3;
    w.breaktrials=(1:4)*p.n.ntrials/4;
end
for o1=1:1 % PARAMETERS: Subject-specific
    eval(['scenelist=scenelist' num2str(p.contextcounterbal) ';'])
    data=nan*zeros(p.n.ntrials, 12);
    
    % Load context and other parameters
    data(:,[col.SceneStim(1) col.SceneStim(2)])=repmat([1  1;1 2; 2 1; 2 2], p.nreps_percontext,1); data(:,col.SimDis)=data(:,col.SceneStim(1));
    data(:,col.Trialnum)=rand(p.n.ntrials,1); data=sortrows(data, col.Trialnum);
    data(:, col.ItemType)=repmat([1;2], p.n.ntrials/2,1);
    if p.itemcounterbal==1; data(:,col.ItemRespCat)=data(:, col.ItemType);
    elseif p.itemcounterbal==2; data(:,col.ItemRespCat)=3-data(:, col.ItemType); end
    data=sortrows(data,col.ItemRespCat); % Load correct responses (probabilistic)
    data(:, col.ItemRespCorr)=3-data(:,col.ItemRespCat);
    data(1:floor(p.n.ntrials/2*p.contingency_high),  col.ItemRespCorr)=data(1,col.ItemRespCat);
    data((p.n.ntrials/2+1): (p.n.ntrials/2+floor(p.n.ntrials/2*p.contingency_high)),  col.ItemRespCorr)=data(p.n.ntrials/2+1,col.ItemRespCat);
    
    % Load items(repeating)
    learn_itemlist(:,3)=num2cell((1:size(learn_itemlist,1))');
    w.itemlist{1}=learn_itemlist(cell2mat(learn_itemlist(:,2))==1, :);  w.itemlist{1}(:,4)=num2cell(rand(size(w.itemlist{1},1),1)); w.itemlist{1}=sortrows(w.itemlist{1},4);
    w.itemlist{2}=learn_itemlist(cell2mat(learn_itemlist(:,2))==2, :);  w.itemlist{2}(:,4)=num2cell(rand(size(w.itemlist{2},1),1)); w.itemlist{2}=sortrows(w.itemlist{2},4);
    w.countitem=[1 1];
    for i=1:size(data,1)
        data(i,col.ItemStim)=w.itemlist{data(i,col.ItemType)}{w.countitem(data(i,col.ItemType)),3};
        
        % Advance counter
        w.countitem(data(i,col.ItemType))=w.countitem(data(i,col.ItemType))+1;
        if w.countitem(data(i,col.ItemType))==size(w.itemlist{data(i,col.ItemType)},1)+1
            w.countitem(data(i,col.ItemType))=1;
        end
    end
    
    %
    data(:,col.ItemPos)=randi(4,size(data,1),1);
    data(:,col.Trialnum)=rand(size(data,1),1);
    data=sortrows(data,col.Trialnum);
end

% COGENT
config_display(w.screenmode, w.res, [0 0 0], [1 1 1], 'Helvetica', 35, 4,0); % marker 5g start
config_keyboard; start_cogent % if using testing laptops, w.res in config dis must be 3!
cgpencol([1 1 1])
cgtext('You should receive new instructions for this stage', 0, w.line*3)
cgtext(' of the experiment. If you have not received instructions', 0, w.line*2)
cgtext('before the trials start, please tell the experimenter.', 0, w.line*1)
cgtext('Press any key to continue', 0, w.line*-2)
t.startcogent=cgflip(0,0,0);
waitkeydown(inf)


%% ########### MAIN DISPLAY LOOP  ############################################

w.numtrials_missed=0;      

for trialnum=1: p.n.ntrials
  
    for o4=1:1 % Set up for current trial
        cgloadbmp(1,scenelist{data(trialnum,col.SceneStim(1)),data(trialnum,col.SceneStim(2))},p.disp.sizescene,p.disp.sizescene) % Context
        cgloadbmp(2,learn_itemlist{data(trialnum,col.ItemStim),1},p.disp.sizeitem,p.disp.sizeitem) % Item
        cgmakesprite(5,230,50,0.2,0.2,0.2) % Sprite 5 = Response options
        eval(['w.item1_x=p.disp.pos' num2str(data(trialnum,9)) '_x;'])
        eval(['w.item1_y=p.disp.pos' num2str(data(trialnum,9)) '_y;'])
        %
        data(trialnum,col.Trialnum)=trialnum;
        wt=[];
    end
    
    % % FIXATION
    cgtext('+',0,0)
    cgtext('UP or DOWN?',0,145)
    wt.fixationonset=cgflip(0,0,0);
    
    % % Scene only
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    waituntil(wt.fixationonset*1000+p.disp.framelength_learn/2)
    wt.contextonset=cgflip(0,0,0);
    
    % %% Scene + Item
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    cgdrawsprite(2,w.item1_x,w.item1_y);
    waituntil(wt.contextonset*1000+p.disp.framelength_learn); clearkeys; 
    wt.itemonset=cgflip(0,0,0);
    [wt.key wt.time wt.n]= waitkeydown(p.disp.framelength_learn,[p.resp.up p.resp.down]);
    if wt.n==0
        data(trialnum,col.Resp)=nan;
        data(trialnum,col.RespRT)=nan;
        data(trialnum,col.ItemAccuracy)=0;
        w.numtrials_missed=w.numtrials_missed+1;
        wt.outcome='No Response';
    else
        data(trialnum,col.RespRT)=wt.time(1)-wt.itemonset*1000;
        switch wt.key(1)
            case p.resp.up; data(trialnum,col.Resp)=1;
            case p.resp.down; data(trialnum,col.Resp)=2;
        end
        data(trialnum,col.ItemAccuracy)=(data(trialnum, col.ItemRespCorr)==data(trialnum,col.Resp));
            
        % Set up feedback
        switch data(trialnum,col.ItemAccuracy)
            case 1; wt.outcome='Correct!';
            case 0; wt.outcome='Wrong!';
        end
    end
    
    % Display outcome
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    cgmakesprite(4, 200, 200, [0.1 0.1 0.1])
    cgdrawsprite(4,w.item1_x,w.item1_y);
    cgtext(wt.outcome,w.item1_x,w.item1_y);    
    waituntil(wt.itemonset*1000+p.disp.framelength_learn)
    wt.outcomeonset=cgflip(0,0,0);
    
    % BREAKS
    if sum(w.breaktrials==trialnum)==1
        waituntil(wt.outcomeonset*1000+p.disp.framelength_learn/2); cgflip(0,0,0);
        cgtext('Please take a break and rest your eyes if you''d like', 0, w.line*3)
        cgtext('Press any key to continue when you are ready', 0, w.line*-3-20)
        cgflip(0,0,0);
        waituntil(wt.outcomeonset*1000+3000); waitkeydown(inf);
    end
    
    % Notify researcher!
    if trialnum==p.n.ntrials-10
        try
            w.time=clock;
            f_sendemail('learnreward', strcat('[TEST] ', w.subjname, ' (learning) has 15 trials left - 1.5 min (', num2str(w.time(4)), ':', num2str(w.time(5)),' hrs)') , strcat('Session almost complete: learning.') )
        end
    end
    
    disp('------------------------------------------------------------------------------')
    disp(['Trial no. ' num2str(trialnum)])
    disp(['Context stim: ' scenelist{data(trialnum,col.SceneStim(1)),data(trialnum,col.SceneStim(2))}])
    disp(['Item stim:    ' learn_itemlist{data(trialnum,col.ItemStim),1}]);
    disp(['Response: ' num2str(data(trialnum,col.Resp)) '   (' wt.outcome ')'])
    disp(['Correct response congruency: ' num2str(data(trialnum, col.ItemRespCorr)== data(trialnum, col.ItemRespCat))])
%         waitkeydown(inf);
    
    %wp=input('Move on?');
    %         waitkeydown(inf)% THIS NEEDS TO BE DELETED¬!
    
    waituntil(wt.outcomeonset*1000+p.disp.framelength_learn/2)
end 

%% 

t.endlearn=cgflip(0,0,0);
cgtext('Thank you', 0, w.line*4)
cgtext('You have completed the first stage', 0, w.line*2)
cgtext('of the experiment', 0, w.line*1)
cgtext('Please call the experimenter', 0, w.line*-4)
clearkeys
cgflip(0,0,0);
waitkeydown(inf)

stop_cogent

%%

disp('################################################################')
disp('EXPERIMENTER PLEASE RESPOND')
disp('################################################################')
disp('Which response goes with which the following types of objects?    (1=Up, 2=Down)')
learning.res.report.natural_goeswith=input('Natural objects:       ');
learning.res.report.manmade_goeswith=input('Man-made objects:       ');
if isempty(learning.res.report.natural_goeswith)+ isempty(learning.res.report.manmade_goeswith) ~=0 ||  learning.res.report.natural_goeswith==learning.res.report.manmade_goeswith || isnan(learning.res.report.natural_goeswith)+isnan(learning.res.report.manmade_goeswith) ~=0
    disp('ERROR! Invalid responses. Experimenter, please manually note responses'); 
    disp('Responses CANNOT be the same for the 2 types of objects'); disp(' ')
    learning.res.beh_consistentwreport.natural=nan;
    learning.res.beh_consistentwreport.manmade=nan;
else
    % Does explicit report match up with choice?
    gdata=data(isnan(data(:, col.Resp))==0, :);
    learning.res.beh_consistentwreport.natural=mean(gdata(gdata(:, col.ItemType)==1, col.Resp)==learning.res.report.natural_goeswith);
    learning.res.beh_consistentwreport.manmade=mean(gdata(gdata(:, col.ItemType)==2, col.Resp)==learning.res.report.manmade_goeswith);
end
disp('################################################################')
        
%%

% Save data
learning.settings=p;
learning.trialstats=data;
learning.col=col;
learning.res.missedtrials=w.numtrials_missed;
learning.res.accuracy=mean(data(isnan(data(:,col.ItemAccuracy))==0, col.ItemAccuracy));
save(['Data' filesep p.subjectlog.name '_file_1learning.mat'], 'learning')
try % Transfer to DeletedDaily
    if isdir('\\Asia\DeletedDaily\EL mem data')==0; mkdir('\\Asia\DeletedDaily\EL mem data'); end
    copyfile(['Data' filesep p.subjectlog.name '_file_1learning.mat'], ['\\Asia\DeletedDaily\EL mem data' filesep p.subjectlog.name '_file_1learning.mat'])
    w.warning=' ';
catch
    w.warning='Warning: Did not transfer to Deleted Daily!';
end

disp('-----------------------------------------------------------------------------')
disp(['Duration: ' num2str((t.endlearn-t.startcogent)/(1000*60)) ' min' ])
disp(['Accuracy (choice): ', num2str(learning.res.accuracy)]);
disp(['# of Omissions: ', num2str(learning.res.missedtrials)]);
disp(['Choice consistent w report (natural): ', num2str(learning.res.beh_consistentwreport.natural)]);
disp(['Choice consistent w report (man-made): ', num2str(learning.res.beh_consistentwreport.manmade)]);
disp('-----------------------------------------------------------------------------')
% 
%  After this session, experimenter must note:
%          How many omissions? If many, why?
%          Is reported relationship between response & stimulus consistent with behaviour? If not, probe why?
%          Is reported relationship between response & stimulus correct? If not, why?



disp('Duration:')
t.endlearn- t.startcogent