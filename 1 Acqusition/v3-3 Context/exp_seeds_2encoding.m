% ENCODING PHASE 

for o1=1:1 % Documentation  
% Details of parameter and data files ('par & 'data')
% [Scene stim]           Col 1-2: Scene stim - Index (1-3)    
%                               Col 3:    Scene stim - Type. dissimilar 
%                                        (1=Similar, 2=Dissimilar)
%                               Col 4: Trial number
%
% [Task (Item)]         Col 5:  Item - Valence category (1=Rewarded, 0=Neutral)
%                               Col 6:  Item - Effective reward (1=Rewarded, 0=Neutral)
%                                         (= Item valence category, * reward contingency)
%                               Col 7:  Item - Semantic type
%                                           (1=Natural,2=Man-made)
%                               Col 8:  Item - Stimulus index 
%                               Col 9: Item- Position (1-4)
% 
%                               Col 11: [Resp] Keypress/choice (1=Natural,2=Man-made)
%                               Col 12: [Resp] RT
%                               Col 13: Item Accuracy (categorization)
%                               Col 14: Item Outcome (actual)
%
% [Design]              Col 15: 
%
% DESIGN CELLS
%
% 
%                      Cue A (Similar)     Cue B (Dissimilar)
%
%			Item R          1               	3					
%			Item N          2                   4
%
% ----------------------------------------------------------------------------------------------------------

end
for o1=1:1 % TESTING or Coding?
clear all
clc

w.testing=1;
where=pwd; 
% '/Volumes/MEDIASTAR/6 [v3 Seeds] Experiment MDeacon/2 v3.2 Experiment execution';

if w.testing==0   % Not testing
    disp('Coding mode')
    w.subjname='t3';
    w.screenmode=0;
    p.testingpc_cond=2;
elseif w.testing==1 % testing
    w.subjname=input('Subject ID: ','s');
    w.screenmode=1;
    p.testingpc_cond=input('Testing on? 1=Desktop, 2= Laptop: ');
end
switch p.testingpc_cond
    case 1
        w.res=4;
    case 2
        w.res=3;
end
try
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
load([where filesep 'Data' filesep w.subjname '_file_1learning.mat'])    
rand('state',sum(100*clock));
p=learning.settings;
% New stuff
p.n.ntrials=240;
p.n.n_items=p.n.ntrials;
if isnan(learning.settings.postlearning_RT)==0
    p.RThit=learning.settings.postlearning_RT;
end
p.n.n_items_pertrial=1;
%
w.line=50; 
w.line1=40;
end
for o1=1:1 % PARAMETERS: Subject-specific
% Create instructions list - details to be read off when constructing par
in.contexts=[1.1 1.2 2.1 2.2];
switch p.itemcounterbal
    case 1
        in.item1=[1 1 1 1];
        in.item2=[0 0 0 0];
    case 2
        in.item1=[0 0 0 0];
        in.item2=[1 1 1 1];
%     case 3
%         in.item2=[1 1 1 1];
%         in.item1=[0 0 0 0];
%     case 4
%         in.item1=[1 1 1 1];
%         in.item2=[0 0 0 0];
    otherwise
        input('Error: Item-counterbalancing cannot accomodate requested balance')
end
w.tsize=(p.n.ntrials)/p.n.contexts;
w.effectR=zeros(w.tsize/2,1);
w.effectR(1:floor(p.contingency_high*w.tsize/2),1)=1;
w.effectN=ones(w.tsize/2,1);
w.effectN(1:floor(p.contingency_high*w.tsize/2),1)=0;
par=[];
for j=1:p.n.contexts
    ws.t=nan*ones(w.tsize,8);
    ws.t(:,1)=floor(in.contexts(j)); % Load context details 
    ws.t(:,2)=floor((in.contexts(j)-floor(in.contexts(j)))*10);
    ws.t(:,3)=ws.t(:,1);
    ws.t(1:w.tsize/2,7)=1; % Load items, half M & half N
    ws.t(w.tsize/2+1:w.tsize,7)=2;
    if in.item1(j)==1
        ws.t(1:w.tsize/2,5)=1;
        ws.t(1:w.tsize/2,6)=w.effectR;
    else
        ws.t(1:w.tsize/2,5)=0;
        ws.t(1:w.tsize/2,6)=w.effectN;
    end
    if in.item2(j)==1
        ws.t(w.tsize/2+1:w.tsize,5)=1;
        ws.t(w.tsize/2+1:w.tsize,6)=w.effectR;
    else
        ws.t(w.tsize/2+1:w.tsize,5)=0;
        ws.t(w.tsize/2+1:w.tsize,6)=w.effectN;
    end
    par=vertcat(par,ws.t);
    rep{j}=ws.t;
    ws=[];
end
% Load item stim-indices
w.item1=[];
w.item2=[];
for i=1:size(itemlist,1)
    if itemlist{i,2}==1
        w.item1=vertcat(w.item1, itemlist{i,3});
    else
        w.item2=vertcat(w.item2, itemlist{i,3});
    end
end
w.item1(:,2)=rand(size(w.item1,1),1);
w.item1=sortrows(w.item1,2);
w.item2(:,2)=rand(size(w.item2,1),1);
w.item2=sortrows(w.item2,2);
w.count1=1;
w.count2=1;
par(:,4)=rand(size(par,1),1);
par=sortrows(par,4);
for i=1:size(par,1)
    if par(i,7)==1
        par(i,8)=w.item1(w.count1,1);
        w.count1=w.count1+1;
    else
        par(i,8)=w.item2(w.count2,1);
        w.count2=w.count2+1;
    end
end
p.unencodeditems=vertcat(w.item1(w.count1:size(w.item1,1),1),w.item2(w.count2:size(w.item2,1),1));
% Mark position
for i=1:size(par,1)
    par(i,9)=randi(4);
end
% Load correct scene stimuli (for counterbalancing)
eval(['scenelist=scenelist' num2str(p.counterbalance_ver) ';' ])
% Finish off
par(:,4)=rand(size(par,1),1);
par=sortrows(par,4);
data=par;
end

% COGENT
config_display(w.screenmode, w.res, [0 0 0], [1 1 1], 'Helvetica', 40, 4,0); % marker 5g start
config_keyboard;
config_log([w.subjname '_encoding']); 
start_cogent % if using testing laptops, w.res in config dis must be 3!
cgloadlib
cgpencol([1 1 1])
cgtext('You should receive new instructions for this stage', 0, w.line*3)
cgtext(' of the experiment. If you have not received instructions', 0, w.line*2)
cgtext('before the trials start, please tell the experimenter.', 0, w.line*1)
cgtext('Press any key to continue', 0, w.line*-2)
t.startcogent=cgflip(0,0,0);
waitkeydown(inf)


%% ###########  INSTRUCTIONS  ############################################
 for o1=1:1
     if w.testing==111 

        cgloadbmp(5, 'Stimuli\eg_similar_bed1.bmp', 200,0)
        cgloadbmp(6, 'Stimuli\eg_similar_bed2.bmp', 200,0)
        cgloadbmp(8, 'Stimuli\eg_dissimilar_kitchen1.bmp', 200,0)
        cgloadbmp(9, 'Stimuli\eg_dissimilar_kitchen2.bmp', 200,0)
        cgdrawsprite(5, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgtext('In this part of the experiment, you will learn about two pairs', 0, w.line*1)
        cgtext('of pictures. These pictures will tell you which kind of items',0,w.line*0)
        cgtext('you can win money for, on each trial', 0,w.line*-1)
        cgtext('Within each pair, one picture indicates that you can win money', 0, w.line*-3)
        cgtext('for Man-made items, while the other picture indicates that you can',0,w.line*-4)
        cgtext('win money for Natural items (i.e. those that are not man-made)',0,w.line*-5)
        cgfont('Helvetiuca',30)
        cgtext('Note: The above pictures are NOT the ones you''ll see later in ', 0, w.line*-7+20)
        cgtext('the experiment, but we''ll use them for this tutorial', 0, w.line*-7-10)
        cgfont('Helvetiuca',40)
        cgflip(0,0,0)
        waitkeydown(inf)


        % %% TRIAL SEQUENCE ----------------------------------------------
        cgloadbmp(5, 'Stimuli\eg_similar_bed1_large.bmp', 400, 400)
        % cgdrawsprite(5, 0,175)
        cgtext('Each trial will go like this:',0,w.line*-1)
        cgtext('First, you will see one of the four pictures on the screen', 0, w.line*-2)
        cgflip(0,0,0)
        waitkeydown(inf) %
        cgdrawsprite(5, 0,175)
        cgtext('Each trial will go like this:',0,w.line*-1)
        cgtext('First, you will see one of the four pictures on the screen', 0, w.line*-2)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(5, 0,175)
        cgloadbmp(1, 'Stimuli\eg_item.bmp',175,0)
        cgdrawsprite(1,0,175)
        cgtext('Each trial will go like this:',0,w.line*-1)
        cgtext('First, you will see one of the four pictures on the screen', 0, w.line*-2)
        cgtext('Then, you will see a picture of an item, shown on top', 0, w.line*-3)
        cgtext('of the first background picture', 0, w.line*-4)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(5, 0,175) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',175,0)
        cgdrawsprite(1,0,175)
        cgmakesprite(3, 200,45,0.2,0.2,0.2)
        cgdrawsprite(3,-200,-50)
        cgdrawsprite(3,200,-50)
        cgtext('Natural',200,-50)
        cgtext('Man-made',-200,-50)
        cgtext('When you see the item, you have to decide whether it is ',0,w.line*-2)
        cgtext('Man-made, or Natural', 0, w.line*-3)
        cgflip(0,0,0);
        waitkeydown(inf)

        cgdrawsprite(5, 0,175) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',175,0)
        cgdrawsprite(1,0,175)
        cgmakesprite(3, 200,45,0.2,0.2,0.2)
        cgdrawsprite(3,-200,-50)
        cgdrawsprite(3,200,-50)
        cgtext('Natural',200,-50)
        cgtext('Man-made',-200,-50)
        cgtext('When you see the item, you have to decide whether it is ',0,w.line*-2)
        cgtext('Man-made, or Natural', 0, w.line*-3)
        cgtext('Press the Left arrow key if the item is Man-made, or the', 0, w.line*-4-15)
        cgtext('Right arrow key if the item is Natural', 0, w.line*-5-15)
        cgtext('Respond quickly! You will have 2 seconds to do this, for each item', 0, w.line*-7)
        cgflip(0,0,0);
        waitkeydown(inf)

        cgdrawsprite(5, 0,175) 
        cgmakesprite(2,100,100,0,1,0)
        cgdrawsprite(2,0,175)
        cgpencol([0 0 0])
        cgtext('+20p',0,175)
        cgpencol([1 1 1])
        cgtext('After you do this, you will see some feedback about', 0, w.line*-2)
        cgtext('whether or not you won money, on that trial', 0, w.line*-3)
        cgtext('A proportion of your total winnings on this task will be added', 0, w.line*-5)
        cgtext('to the money we pay you at the end of the experiment', 0, w.line*-6)
        cgflip(0,0,0);
        waitkeydown(inf)
        
        % %% HOW TO WIN MONEY -------
        cgdrawsprite(5, 0,175) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',175,0)
        cgdrawsprite(1,0,175)
        cgmakesprite(3, 200,45,0.2,0.2,0.2)
        cgdrawsprite(3,-200,-50)
        cgdrawsprite(3,200,-50)
        cgtext('Natural',200,-50)
        cgtext('Man-made',-200,-50)
        cgtext('To win money on this task, you have to respond quickly and ',0,w.line*-2)
        cgtext('accurately to each item, indicating if it is Man-made, or Natural', 0, w.line*-3)
        cgflip(0,0,0);
        waitkeydown(inf)

        cgdrawsprite(5, 0,175) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',175,0)
        cgdrawsprite(1,0,175)
        cgmakesprite(3, 200,45,0.2,0.2,0.2)
        cgdrawsprite(3,-200,-50)
        cgdrawsprite(3,200,-50)
        cgtext('Natural',200,-50)
        cgtext('Man-made',-200,-50)
        cgtext('To win money on this task, you have to respond quickly and ',0,w.line*-2)
        cgtext('accurately to each item, indicating if it is Man-made, or Natural', 0, w.line*-3)
        cgtext('Money is not available for you to win on every trial. But when it', 0, w.line*-5)
        cgtext('is available, you will only get the money if you are both',0,w.line*-6)
        cgtext('quick and accurate', 0, w.line*-7)
        cgflip(0,0,0);
        waitkeydown(inf)

        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('You should learn to predict when money is likely to be available',0,w.line*-1-20)
        cgtext('For every item, there is a certain probability that money is available',0,w.line*-2-20)
        cgtext('That probability is determined by the background picture:',0,w.line*-3-20)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('You should learn to predict when money is likely to be available',0,w.line*-1-20)
        cgtext('For every item, there is a certain probability that money is available',0,w.line*-2-20)
        cgtext('That probability is determined by the background picture:',0,w.line*-3-20)
        cgtext('Some pictures indicate that Man-made items are likely to be', 0, w.line*-5)
        cgtext('rewarded, while other pictures indicate that Natural items', 0, w.line*-6)
        cgtext('are likely to be rewarded', 0, w.line*-7)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('Try and figure out which background pictures indicate', 0, w.line*-1-20)
        cgtext('that Man-made items are likely to be rewarded, and which pictures', 0, w.line*-2-20)
        cgtext('indicate that Natural items are likely to be rewarded', 0, w.line*-3-20)
        cgtext('You will need to know this for the next stage of the experiment -', 0, w.line*-5)
        cgtext('you cannot continue with the next stage if you do not figure this out! ', 0, w.line*-6)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('Remember: For the Item pictures, the only quality that determines', 0, w.line*-1-20)
        cgtext(' if it''s rewarded or not is whether it is Man-made or Natural', 0, w.line*-2-20)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('Remember: For the Item pictures, the only quality that determines', 0, w.line*-1-20)
        cgtext(' if it''s rewarded or not is whether it is Man-made or Natural', 0, w.line*-2-20)
        cgtext('There is also nothing about the Background pictures', 0, w.line*-4)
        cgtext('that can help you figure out whether it goes with Man-made', 0, w.line*-5)
        cgtext('items or Natural ones - you just have to try and remember,', 0, w.line*-6)
        cgtext('based on experience', 0, w.line*-7)
        cgflip(0,0,0)
        waitkeydown(inf)

        % Respond for all
        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('Learning to predict when money is likely to be available', 0, w.line*-1-20)
        cgtext('will help you win more money overall', 0, w.line*-2-20)
        cgtext('BUT: this doesn''t mean that you can ignore all items', 0, w.line*-4)
        cgtext('when you know they''re not likely to give you money', 0, w.line*-5)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgmakesprite(2,415,415,0,0,1)
        cgdrawsprite(2,0,175)
        cgdrawsprite(5, 0,175) 
        cgmakesprite(3,185,185,1,0,0)
        cgdrawsprite(3,0,175)
        cgdrawsprite(1,0,175)
        cgpencol([0 0 1])
        cgtext('Background',-320,250)
        cgtext('picture',-300,200)
        cgpencol([1 0 0])
        cgtext('Item picture',60,65)
        cgpencol([1 1 1])
        cgtext('You should respond accurately to every single item - you have', 0, w.line*-1-20)
        cgtext('2 seconds per item to make the decision, and we''ll be keeping ', 0, w.line*-2-20)
        cgtext('track of your accuracy levels', 0, w.line*-3-20)
        cgtext('BUT, when money is available for you to win, you have to respond', 0, w.line*-5)
        cgtext('much faster than 2 seconds, if you want to win it', 0, w.line*-6)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(5, 0,175) 
        cgmakesprite(2,100,100,0.2,0.2,0.2)
        cgdrawsprite(2,0,175)
        cgpencol([0 0 0])
        cgfont('Helvetiuca',25)
        cgtext('Too slow',0,175)
        cgfont('Helvetiuca',40)
        cgpencol([1 1 1])
        cgtext('If money is available for you to win, but you were too slow,', 0, w.line*-1-20)
        cgtext('the computer will tell you that you were too slow', 0, w.line*-2-20)
        cgtext('If you respond wrongly to an item, the computer will also tell you,', 0, w.line*-4)
        cgtext('by showing an X in the response box', 0, w.line*-5)
        cgflip(0,0,0)
        waitkeydown(inf)

        % %% DESIGN AGAIN
        cgloadbmp(10, 'Stimuli\eg_similar_bed1.bmp', 200,0)
        cgloadbmp(6, 'Stimuli\eg_similar_bed2.bmp', 200,0)
        cgloadbmp(8, 'Stimuli\eg_dissimilar_kitchen1.bmp', 200,0)
        cgloadbmp(9, 'Stimuli\eg_dissimilar_kitchen2.bmp', 200,0)
        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgtext('Now - let''s look a those background pictures again', 0, w.line*1)
        cgtext('You will see two pairs of background pictures, four in total',0,w.line*0)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgloadbmp(10, 'Stimuli\eg_similar_bed1.bmp', 200,0)
        cgloadbmp(6, 'Stimuli\eg_similar_bed2.bmp', 200,0)
        cgloadbmp(8, 'Stimuli\eg_dissimilar_kitchen1.bmp', 200,0)
        cgloadbmp(9, 'Stimuli\eg_dissimilar_kitchen2.bmp', 200,0)
        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('Now - let''s look a those background pictures again', 0, w.line*1)
        cgtext('You will see two pairs of background pictures, four in total',0,w.line*0)
        cgtext('Within each pair, one picture will indicate that you can',0,w.line*-2)
        cgtext('win money for Man-made items, while the other picture will', 0, w.line*-3)
        cgtext(' indicate that you can win money for Natural items',0,w.line*-4)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgloadbmp(10, 'Stimuli\eg_similar_bed1.bmp', 200,0)
        cgloadbmp(6, 'Stimuli\eg_similar_bed2.bmp', 200,0)
        cgloadbmp(8, 'Stimuli\eg_dissimilar_kitchen1.bmp', 200,0)
        cgloadbmp(9, 'Stimuli\eg_dissimilar_kitchen2.bmp', 200,0)
        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('Now - let''s look a those background pictures again', 0, w.line*1)
        cgtext('You will see two pairs of background pictures, four in total',0,w.line*0)
        cgtext('Within each pair, one picture will indicate that you can',0,w.line*-2)
        cgtext('win money for Man-made items, while the other picture will', 0, w.line*-3)
        cgtext(' indicate that you can win money for Natural items',0,w.line*-4)
        cgfont('Helvetiuca',30)
        cgtext('Note: The above pictures are NOT the ones you''ll see later in ', 0, w.line*-7+20)
        cgtext('the experiment, but we''ll use them for this tutorial', 0, w.line*-7-10)
        cgfont('Helvetiuca',40)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgtext('Pictures in a pair will be similar to each other - either they will look ', 0, w.line*1)
        cgtext('very similar (Pair 1), or they will be the same type of room (Pair 2)',0,w.line*0)
        cgtext('You may have to look closely at the pictures, to figure out',0,w.line*-2)
        cgtext('the differences between them', 0, w.line*-3)
        cgtext('You may even want to spend the first few trials looking', 0, w.line*-5)
        cgtext('closely at the background pictures, to make sure you can', 0, w.line*-6)
        cgtext('tell them apart', 0, w.line*-7)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgtext('In general, you should feel like you are seeing four unique ', 0, w.line*1)
        cgtext('pictures, instead of just two or three',0,w.line*0)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgtext('In general, you should feel like you are seeing four unique ', 0, w.line*1)
        cgtext('pictures, instead of just two or three',0,w.line*0)
        cgtext('You can also use the feedback you from the trials to help you ',0,w.line*-2+20)
        cgtext('get a sense for whether you''ve managed to tell the difference',0,w.line*-3+20)
        cgtext('between pictures in a pair, or not',0,w.line*-4+20)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('In general, you should feel like you are seeing four unique ', 0, w.line*1)
        cgtext('pictures, instead of just two or three',0,w.line*0)
        cgtext('You can also use the feedback you from the trials to help you ',0,w.line*-2+20)
        cgtext('get a sense for whether you''ve managed to tell the difference',0,w.line*-3+20)
        cgtext('between pictures in a pair, or not',0,w.line*-4+20)
        cgtext('If you feel like a picture gives you money for Man-made',0,w.line*-5)
        cgtext('and Natural items equally, this might mean that you are ',0,w.line*-6)
        cgtext('mistaking two of the pictures within a pair for the same one',0,w.line*-7)
        cgflip(0,0,0)
        waitkeydown(inf)

        % %% SUMMARY
        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('In summary, here is what you have to do for this task: ', 0, w.line*1+20)
        cgtext('(1) Carefully be able to tell the difference between pictures in a pair',0,w.line*0)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('In summary, here is what you have to do for this task: ', 0, w.line*1+20)
        cgtext('(1) Carefully be able to tell the difference between pictures in a pair',0,w.line*0)
        cgtext('(2) For ALL items, accurately indicate if it is Man-made or Natural',0,w.line*-2+20)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('In summary, here is what you have to do for this task: ', 0, w.line*1+20)
        cgtext('(1) Carefully be able to tell the difference between pictures in a pair',0,w.line*0)
        cgtext('(2) For ALL items, accurately indicate if it is Man-made or Natural',0,w.line*-2+20)
        cgtext('(3) Respond very quickly for items where money is available,',0,w.line*-3)
        cgtext('in order to win as much money as possible',0,w.line*-4)
        cgflip(0,0,0)
        waitkeydown(inf)

        cgdrawsprite(10, -150,200)
        cgdrawsprite(6,-400,200) 
        cgdrawsprite(8, 150,200)
        cgdrawsprite(9,400,200) 
        cgtext('PAIR 1',-280,330)
        cgtext('PAIR 2',280,330)
        cgfont('Helvetiuca',40)
        cgloadbmp(11, 'Stimuli\eg_itemmicro.bmp',80,0)
        cgdrawsprite(11, -150,200)
        cgloadbmp(12, 'Stimuli\eg_item3micro.bmp',80,0)
        cgdrawsprite(12, 150,200)
        cgloadbmp(13, 'Stimuli\eg_item2micro.bmp',80,0)
        cgdrawsprite(13, 400,200)
        cgloadbmp(14, 'Stimuli\eg_item5micro.bmp',80,0)
        cgdrawsprite(14, -400,200)
        cgtext('In summary, here is what you have to do for this task: ', 0, w.line*1+20)
        cgtext('(1) Carefully be able to tell the difference between pictures in a pair',0,w.line*0)
        cgtext('(2) For ALL items, accurately indicate if it is Man-made or Natural',0,w.line*-2+20)
        cgtext('(3) Respond very quickly for items where money is available,',0,w.line*-3)
        cgtext('in order to win as much money as possible',0,w.line*-4)
        cgtext('(4) For each background picture, figure out whether it indicates that',0,w.line*-6+15)
        cgtext('money is more likely to be available for Man-made or Natural items',0,w.line*-7+15)
        cgflip(0,0,0)
        waitkeydown(inf)

            %  %% LAST 
            cgtext('Please ask the experimenter if you have', 0, w.line*1)
            cgtext('any questions', 0, w.line*0)            
            cgfont('Helvetiuca',25)
            cgtext('It is VERY important that you understand what you need to do, and how to win',0,-3*w.line)
            cgtext('win on this task. If anything is unclear, please ask the experimenter now!',0,-4*w.line)
            cgfont('Helvetiuca',40)            
            cgflip(0,0,0);
            waitkeydown(inf)    
            
     else
     end
     
     
            % Last instruction before game starts
            cgflip(0,0,0)
            cgtext('Please position your finger', 0, w.line*4+15)
            cgtext('on the response buttons (right hand)', 0, w.line*3+15)
            cgfont('Helvetiuca',25)
            cgtext('Left Arrow=Man-made            Right arrow = Natural',0, w.line*1)    
            cgfont('Helvetiuca',40)
            cgtext('Press the left arrow to begin', 0, w.line*-1)
            t.startcond=cgflip(0,0,0); 
            waitkeydown(inf,97)
            cgtext('+',0,0)
         
 end

%% ########### MAIN DISPLAY LOOP  ############################################
w.numtrials_missed=0;      

for trialnum=1:p.n.ntrials
    cgtext('+',0,0)
    
    for o4=1:1 % Set up for current trial
        scenefilename=scenelist{data(trialnum,1),data(trialnum,2)}; % Background scene
        cgloadbmp(1,scenefilename,p.disp.sizescene,p.disp.sizescene)
        itemfilename=itemlist{data(trialnum,8),1};
        cgloadbmp(2,itemfilename,p.disp.sizeitem,p.disp.sizeitem)
        cgmakesprite(5,230,50,0.2,0.2,0.2) % Sprite 5 = Response options
        eval(['w.item1_x=p.disp.pos' num2str(data(trialnum,9)) '_x;'])
        eval(['w.item1_y=p.disp.pos' num2str(data(trialnum,9)) '_y;'])
        %
        data(trialnum,4)=trialnum;
        w.key=[];
        w.keytime=[];
        w.n=[];
    end
    
    % %% DISPLAY LOOP FOR EACH TRIAL -----------------------------
    % %% EXECUTE DISPLAYS -----------------
    % % Scene only
    w.fixationonset=cgflip(0,0,0);
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    cgdrawsprite(5,-230,-345)
    cgdrawsprite(5,230,-345)
    cgtext('Natural',230,-345)
    cgtext('Man-made',-230,-345)
    waituntil(w.fixationonset*1000+p.disp.framelength_learn/2)
    w.contextonset=cgflip(0,0,0);
    
    % %% Scene + Item
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    cgdrawsprite(2,w.item1_x,w.item1_y);
    cgdrawsprite(5,-230,-345)
    cgdrawsprite(5,230,-345)
    cgtext('Natural',230,-345)
    cgtext('Man-made',-230,-345)
    waituntil(w.contextonset*1000+p.disp.framelength_learn)
    clearkeys
    w.itemonset=cgflip(0,0,0);
    
    % %% Scene + Outcome
    % Process outcome
    waituntil(w.itemonset*1000+p.disp.framelength_learn-25)% 25 ms to compute outcome
    readkeys;
    [w.key, w.keytime, w.n] = getkeydown;
    if w.n==0 % Is there a valid response?
        data(trialnum,11)=nan;
        data(trialnum,12)=-999;
        data(trialnum,13)=0;
        data(trialnum,14)=0;
        w.numtrials_missed=w.numtrials_missed+1;
        cgpencol([0 0 0])
        w.outcome=num2str(0);
        cgfont('Helvetiuca',40)
        w.outcomecol=[0.8 0.8 0];
    else
        if  w.key(1)==p.resp.item_natural
            data(trialnum,11)=1;
        elseif  w.key(1)==p.resp.item_manmade
            data(trialnum,11)=2;
        else
            data(trialnum,11)=999;
        end
        data(trialnum,12)=w.keytime(1)-w.itemonset*1000;
        % Is the answer correct?
        if data(trialnum,11)~=data(trialnum,7)
            data(trialnum,13)=0;
            data(trialnum,14)=0;
            cgpencol([0 0 0])
            w.outcome='X';
            cgfont('Helvetiuca',25)
            w.outcomecol=[0.7 0.7 0.7];
            w.outcomecol=[0.8 0.8 0];
        else
            data(trialnum,13)=1;
            % Is reward available?
            if data(trialnum,6)==0
                data(trialnum,14)=0;
                cgpencol([0 0 0])
                w.outcome=num2str(0);
                cgfont('Helvetiuca',40)
                w.outcomecol=[0.8 0.8 0];
            else
                % Was response quick enough?
                if data(trialnum,12)< p.RThit && data(trialnum,12)>100 % hit (<100ms RT is considered premature)
                    data(trialnum,14)=1;
                    cgpencol([0 0 0])
                    w.outcome=['+ ' num2str(p.rewardpertrial) 'p'];
                    cgfont('Helvetiuca',40)
                    w.outcomecol=[0 1 0];
                else % late response
                    data(trialnum,14)=0;
                    cgpencol([0 0 0])
                    w.outcome='Too slow';
                    cgfont('Helvetiuca',30)
                    w.outcomecol=[0.7 0.7 0.7];
                end
            end
        end
    end
    
    % Display outcome
    cgdrawsprite(1,p.disp.posx,p.disp.posy);
    cgdrawsprite(5,-230,-345)
    cgdrawsprite(5,230,-345)
    cgmakesprite(4, 100, 100, w.outcomecol)
    cgdrawsprite(4,w.item1_x,w.item1_y);
    cgtext(w.outcome,w.item1_x,w.item1_y);
    cgpencol([1 1 1])
    cgfont('Helvetica',40)
    cgtext('Natural',230,-345)
    cgtext('Man-made',-230,-345)
    waituntil(w.itemonset*1000+p.disp.framelength_learn)
    w.outcomeonset=cgflip(0,0,0);
    
    %% BREAKS
    if round(trialnum/40)==trialnum/40
        cgflip(0,0,0);
        cgtext('Please take a break and rest your eyes if you''d like', 0, w.line*3)
        cgtext('Press any key to continue when you are ready', 0, w.line*-3-20)
        cgflip(0,0,0);
        waituntil(w.outcomeonset*1000+3000)
        waitkeydown(inf)
    else
    end
    
    % Notify researcher!
    if trialnum==p.n.ntrials-10
        try
            cd(where)
            w.time=clock;
            f_sendemail('learnreward', strcat('[TEST] ', w.subjname, ' (learning) has 15 trials left - 1.5 min (', num2str(w.time(4)), ':', num2str(w.time(5)),' hrs)') , strcat('Session almost complete: learning.') )
        catch
        end
        cd(where)
    else
    end
    
    %wp=input('Move on?');
    %         waitkeydown(inf)% THIS NEEDS TO BE DELETED¬!
    
    waituntil(w.outcomeonset*1000+p.disp.framelength_learn/2)
end % for loop that runs through trials

%% 

        % %%
        t.endlearn=cgflip(0,0,0);
        cgtext('Thank you', 0, w.line*4)
        cgtext('You have completed the second stage', 0, w.line*2)
        cgtext('of the experiment', 0, w.line*1)
        cgtext('You have 1 more stage to go', 0, w.line*-1)
        cgtext('Please call the experimenter', 0, w.line*-4)
        clearkeys
        cgflip(0,0,0); 
        waitkeydown(inf)

stop_cogent
        
res.item_classificationaccuracy=mean(data(:,13));
res.item_omissions=w.numtrials_missed;
res.item_winnings=sum(data(:,14));

try % Log duration
    if w.testing==1
    w.duration.enc_instruct=(t.startlearn-t.startcogent)/60;
    w.duration.learning=(t.endlearn-t.startlearn)/60;
else
    w.duration.learning=(t.endlearn-t.startcogent)/60;
    end
catch
    w.duration='Couldn''t log duration';
end

% Convert to trialstats_1item
data1=data;
data1(:,17)=data(:,14);
data1(:,18)=data(:,5);
data1(:,18)=0;
data1(:,20)=999;

% Calculate Accuracy Valfx
AccValfx=sum(data(data(:, 5)==1, 13))/size(data(:,5)==1,1)- sum(data(data(:, 5)==0, 13))/size(data(:,5)==0,1);


% SAVE FILES
cd([where filesep 'Data'])
encoding.settings=p;
encoding.par=par;
encoding.trialstats=data;
encoding.trialstats_1item=data1;
encoding.results_tasks=res;
w.savefile=strcat(p.subjectlog.name,'_file_2encoding'); 
w.savefilecommand=strcat('save(w.savefile, ''encoding'')');
eval(w.savefilecommand)
w.duration
disp('-------------------------')
disp(strcat('Accuracy: ', num2str(res.item_classificationaccuracy)));
disp(strcat('Learning score: ', num2str(res.item_winnings)));
disp(strcat('# of Omissions: ', num2str(res.item_omissions)));
disp(['Accuracy Valfx: ' num2str(AccValfx)])
disp('-------------------------')
% 