% ENC PHASE 
clear all; clc

testing=0;

for o1=1:1 % Documentation
    
    col.SceneStim=[1 2];
    col.SimDis=3;
    col.Trialnum=4;
    col.ContextBlock=5; % 1=Context shown, 0=No Context
    col.Blocknum=13;
    %
    col.ItemCorrectResp=6; % 1=Natural, 2=Man-made, 3=Upside down
    %
    col.ItemType=7; % 1=Natural, 2=Man-made, 3=Upside down
    col.ItemStim=8;
    col.ItemPos=9;
    col.Resp=10; % 1=Natural, 2=Man-made, 3=Upside down
    col.RespRT=11;
    col.ItemAccuracy=12;
    
end
 for o1=1:1 % TESTING or Coding?
    
    if testing==0   % Not testing
        disp('Coding mode')
        p.subjectlog.name='t1';
        w.screenmode=1;
    elseif testing==1 % testing
        p.subjectlog.name=input('Subject ID: ','s');
        w.screenmode=0;
    end

    try w.stim=load(['Stimuli' filesep 'stimlist.mat']);
    catch; error('You are in the wrong directory!')
    end
end
for o1=1:1 % PARAMETERS: General
    load(['Data' filesep p.subjectlog.name '_file_1learning.mat'])
    p.contextcounterbal=learning.settings.contextcounterbal;
    p.contextstartblockcounterbal=learning.settings.contextstartblockcounterbal;
    p.disp=learning.settings.disp;
    p.resp=learning.settings.resp;
    p.resp.upsidedown=71; % spacebar =71
    p.n.items_encoded=240;    
    p.n.itemfoils=120;
    p.n.items_upside=24; % MUST FIND 4 more
    p.n.ntrials=p.n.items_encoded+p.n.items_upside;
    p.n.blocks=6;
    if p.n.ntrials/p.n.blocks~=floor(p.n.ntrials/p.n.blocks); error('No. of trials won''t fit well w no. of blocks!'); end
    w.line=50;
    w.line1=40;
    w.res=3;
    rand('state',sum(100*clock));
    w.breaktrials=floor((1:p.n.blocks)*p.n.ntrials/p.n.blocks);
end
for o1=1:1 % PARAMETERS: Subject-specific
    eval(['scenelist=w.stim.scenelist' num2str(p.contextcounterbal) ';'])
     itemlist=w.stim.itemlist;
    targetlist=w.stim.invert_itemlist;
    dispstim=cell(p.n.ntrials,1);
    
     % Load items (foils & encoding stage, upside-down from thresholditem_list)
    w.items=cell2mat(w.stim.itemlist(:,2:3));  % spit into old and foils
    w.items(:,3)=rand(size(w.items,1),1); 
    w.items1=sortrows(w.items(w.items(:,1)==1,:),3); w.items2=sortrows(w.items(w.items(:,1)==2,:),3);
    p.itemfoils=[w.items1(1:p.n.itemfoils/2,:);  w.items2(1:p.n.itemfoils/2,:)];
    w.items1(1:p.n.itemfoils/2,:)=[]; w.items2(1:p.n.itemfoils/2,:)=[];
    data(:,[col.ItemType col.ItemStim])=[w.items1(1:p.n.items_encoded/2,1:2); w.items2(1:p.n.items_encoded/2,1:2)]; % Load items into encoding stage 
    w.targetlist=[sortrows([(1:size(targetlist,1))' rand(size(targetlist,1),1)],2) 3*ones(size(targetlist,1),1)]; % Load targets (upside-down)
    data(p.n.items_encoded+1:p.n.ntrials, [col.ItemType col.ItemStim])=    w.targetlist(1:p.n.items_upside, [3 1]);
    data(:,col.ItemPos)=randi(4,size(data,1),1);

    % Load context and other parameters
    data(:,col.Trialnum)=rand(size(data,1),1); data=sortrows(data,col.Trialnum);
    data(:,col.Blocknum)=repmat((1:p.n.blocks)',p.n.ntrials/p.n.blocks,1); data=sortrows(data,col.Blocknum);
    data(:,col.ContextBlock)=data(:,col.Blocknum)/2==floor(data(:,col.Blocknum)/2);
    if p.contextstartblockcounterbal~=1; data(:,col.ContextBlock)=1-data(:,col.ContextBlock); end
    data_nc=data(data(:,col.ContextBlock)==0,:);
    data_c=data(data(:,col.ContextBlock)==1,:);
    
    % Load context stimuli
    data_c(:,col.Trialnum)=rand(size(data_c,1),1); data_c=sortrows(data_c,col.Trialnum);
    p.nreps_percontext=size(data_c,1)/4;

    data_c(:,[col.SceneStim(1) col.SceneStim(2)])=repmat([1  1;1 2; 2 1; 2 2], p.nreps_percontext,1); 
    data_c(:,col.SimDis)=data_c(:,col.SceneStim(1));
    data=[data_nc; data_c];
    %
    data(:,col.ItemCorrectResp)=data(:,col.ItemType);
    data(:,col.Trialnum)=rand(size(data,1),1);
    data=sortrows(data,[col.Blocknum col.Trialnum]);
    data(:,col.Trialnum)=1:size(data,1);
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

for trialnum=1:p.n.ntrials
  
    for o4=1:1 % Set up for current trial
        if data(trialnum, col.ContextBlock)==1
            cgloadbmp(1,scenelist{data(trialnum,col.SceneStim(1)),data(trialnum,col.SceneStim(2))},p.disp.sizescene,p.disp.sizescene) % Context
        else cgmakesprite(1,230,50,0,0,0)
        end
        if data(trialnum, col.ItemType)==3
            cgloadbmp(2,targetlist{data(trialnum,col.ItemStim),1},p.disp.sizeitem,p.disp.sizeitem) % Target Item
            dispstim{trialnum}=targetlist{data(trialnum,col.ItemStim),1};
        else cgloadbmp(2,itemlist{data(trialnum,col.ItemStim),1},p.disp.sizeitem,p.disp.sizeitem) % Item        
            dispstim{trialnum}=itemlist{data(trialnum,col.ItemStim),1};
        end
        eval(['w.item1_x=p.disp.pos' num2str(data(trialnum,9)) '_x;'])
        eval(['w.item1_y=p.disp.pos' num2str(data(trialnum,9)) '_y;'])
        %
        data(trialnum,col.Trialnum)=trialnum;
        wt=[];
    end
    
    % % FIXATION
    cgtext('+',0,0)
    cgtext('Upside-down, Man-made or Natural?',0,145)
    wt.fixationonset=cgflip(0,0,0);
    
    % % Scene only
    if data(trialnum, col.ContextBlock)==1
        cgdrawsprite(1,p.disp.posx,p.disp.posy);
        waituntil(wt.fixationonset*1000+p.disp.framelength_learn/2)
        wt.contextonset=cgflip(0,0,0);
    else
        wt.contextonset=wt.fixationonset;
    end
    
    % %%  Item (+ Context if applicable)
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    if data(trialnum, col.ItemType)==3;
        cgrotatesprite(2,w.item1_x,w.item1_y,180)
    else cgdrawsprite(2,w.item1_x,w.item1_y);
    end
    waituntil(wt.contextonset*1000+p.disp.framelength_learn); clearkeys; 
    wt.itemonset=cgflip(0,0,0);
    [wt.key wt.time wt.n]= waitkeydown(p.disp.framelength_learn,[p.resp.upsidedown p.resp.item_natural p.resp.item_manmade]);
    if wt.n==0
        data(trialnum,col.Resp)=nan;
        data(trialnum,col.RespRT)=nan;
        data(trialnum,col.ItemAccuracy)=0;
        w.numtrials_missed=w.numtrials_missed+1;
        wt.outcome='No Response';
    else
        data(trialnum,col.RespRT)=wt.time(1)-wt.itemonset*1000;
        switch wt.key(1)
            case p.resp.upsidedown; data(trialnum,col.Resp)=3;
            case p.resp.item_natural; data(trialnum,col.Resp)=1;
            case p.resp.item_manmade; data(trialnum,col.Resp)=2;
        end
        data(trialnum,col.ItemAccuracy)=data(trialnum, col.ItemCorrectResp)==data(trialnum,col.Resp);
    
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
    if trialnum<p.n.ntrials && data(trialnum, col.ContextBlock)~=data(trialnum+1, col.ContextBlock)
        try
            w.time=clock;
            f_sendemail('learnreward', strcat('[TEST] ', w.subjname, ' (learning) has 15 trials left - 1.5 min (', num2str(w.time(4)), ':', num2str(w.time(5)),' hrs)') , strcat('Session almost complete: learning.') )
        end
    end
    
    disp('------------------------------------------------------------------------------')
    disp(['Trial no. ' num2str(trialnum)])
    if data(trialnum, col.ContextBlock)==1; disp(['Context stim: ' scenelist{data(trialnum,col.SceneStim(1)),data(trialnum,col.SceneStim(2))}])
    else disp('Context Stim: None');
    end
    if data(trialnum, col.ItemType)==3; disp(['Item stim:    '  targetlist{data(trialnum,col.ItemStim),1}]);
    else disp(['Item stim:    ' itemlist{data(trialnum,col.ItemStim),1}]);
    end
    disp(['Response: ' num2str(data(trialnum,col.Resp)) '   (' wt.outcome ')'])
    disp(['Response Accuracy: '  num2str(data(trialnum, col.ItemAccuracy))])  
%     waitkeydown(inf);
    
    %wp=input('Move on?');
    %         waitkeydown(inf)% THIS NEEDS TO BE DELETED¬!
    
    waituntil(wt.outcomeonset*1000+p.disp.framelength_learn/2)
end 

%% 

t.endlearn=cgflip(0,0,0);
cgtext('Thank you', 0, w.line*4)
cgtext('You have completed this stage', 0, w.line*2)
cgtext('of the experiment', 0, w.line*1)
cgtext('Please call the experimenter', 0, w.line*-4)
cgflip(0,0,0);
waitkeydown(inf)

stop_cogent
        
%%

% Save data
enc.settings=p;
enc.trialstats=data;
enc.col=col;
enc.res.missedtrials=w.numtrials_missed;
enc.res.accuracy=mean(data(isnan(data(:,col.ItemAccuracy))==0, col.ItemAccuracy));
save(['Data' filesep p.subjectlog.name '_file_2enc.mat'], 'enc')
try % Transfer to DeletedDaily
    if isdir('\\Asia\DeletedDaily\EL mem data')==0; mkdir('\\Asia\DeletedDaily\EL mem data'); end
    copyfile(['Data' filesep p.subjectlog.name '_file_2enc.mat'], ['\\Asia\DeletedDaily\EL mem data' filesep p.subjectlog.name '_file_2enc.mat'])
    w.warning=' ';
catch
    w.warning='Warning: Did not transfer to Deleted Daily!';
end


disp('--------------------------------------------------')
disp(['Duration: ' num2str((t.endlearn-t.startcogent)/(1000*60)) ' min' ])
disp(['Accuracy: ', num2str(learning.res.accuracy)]);
disp(['# of Omissions: ', num2str(learning.res.missedtrials)]);
disp('--------------------------------------------------')
% 