%  MEMORY TEST 
%  Remember/Know procedure, with Confidence ratings

for o1=1:1 % Documentation
% Details of parameters file ('par')
%
%       Col 1:    Trial # (Memtest)
%       Col 2:    Item Stimulus index
%       Col 3:      Old or New/foil (actual) (1=Old, 2=New)
%
% [Encoding-stage: Item level]
%
%       Col 4:      Trial # (Encoding)
%       Col 5-6:    Scene stimuli index(1a-2b)
%       Col 7:       Scene stimuli type (1=Similar, 2=Dissimilar)
%       Col 8:       [Item] Correctly judged during encoding?
%       Col 9:       [Item] Valence category
%       Col 10:     [Item] Effective R
%       Col 11:     [Item] Item outcome (actual)
% 
% [Encoding-stage: Trial level]
%
%       Col 12:     Trial outcome (actual)
%       Col 13:     # Item Rs on this enc trial (total)
%       Col 14:     Accompanying # Item Rs
%       Col 15:     Trial seed-type
%                         (1=[00],2=[+0],2.5=[0+],3=[++])
%       ----------
%       Col 16:     Stimuli cell (1-8) 
%       Col 17:     Design cell (main cell.#seeds)
%
% [Memory test stage]
%
%       Col 18:     Old/New Judgment - Keypress (1=Old, 2=New)
%       Col 19:     Old/New Judgment - RT
%       Col 20:     Remember/Know Judgment - Keypress (1=Rem, 2=Know; 0=n/a i.e.NEW)
%       Col 21:     Remember/Know Judgment - RT
%       Col 22:     Old/New Confidence - Keypress (1=Sure/Strong, 2=Guess/Weak)
%       Col 23:     Old/New Confidence - RT
%       ----------
%       Col 26:     Accuracy - Item recognition
%       Col 27:     Response type (ROC)
%                         1=Sure New
%                         2= Unsure New
%                         3= U K 
%                         4= S K
%                         5= U R
%                         6= S R
%       Col 28:     Item semantic type (1=Natural, 2=Manmade)
%       ----------
%       Col 29:     Item position (1-4)
%       Col 30:     [Response] Position (Keypress)
%       Col 31:     [Response] Position (RT)
%       Col 32:     Item position - Accuracy
%
end
for o1=1:1 % TESTING or Coding?
clear all
clc

w.testing=1;  % Coding

if w.testing==0   % Not testing
    disp('Coding mode')
    w.subjname='t3';
    w.screenmode=0;
    w.res=2;
     dataloc=pwd; % 'I:\2 [PatSep Context] Experiment execution';
elseif w.testing==1 % testing
    w.subjname=input('Subject ID: ','s');
    w.screenmode=1;
    w.res=3;
    dataloc=pwd; % 'F:\2 [PatSep Context] Experiment execution';
end
try
cd(dataloc)
load Stimuli\stimlist.mat
catch
    dataloc=pwd;
    cd(dataloc)
    try
    cd(dataloc)
    load Stimuli\stimlist.mat
    catch
        disp('Wrong directory!')
        disp('No need to change script - just make sure you are in the correct Matlab folder!')
        input('Stop script now','s')
    end
end

end
for o1=1:1 % PARAMETERS: General
rand('state',sum(100*clock));
w.subject.filename=strcat(w.subjname,'_memtest');
% Fetch details from encoding phase
cd('Data')
load([w.subjname, '_file_2encoding.mat'])
cd(dataloc)
p.subjectlog=encoding.settings.subjectlog;
p.n.scenetypes=encoding.settings.n.scenetypes;
p.n.items_encoded=encoding.settings.n.n_items;
p.n.itemfoils=encoding.settings.n.n_items/2; % Foils=50% new 
p.n.items_encoded_tested=p.n.items_encoded;  % Test all encoded items
% New parameters for memory test phase
p.n.enctrials=p.n.items_encoded/encoding.settings.n.n_items_pertrial;
p.n.memtrials=p.n.items_encoded_tested+p.n.itemfoils;
% Display and responses
p.resp.keyleft=97;
p.resp.keyright=98;
p.resp.itemold=p.resp.keyleft; % OLD = leftmost  key
p.resp.itemnew=p.resp.keyright; % NEW = rightmost key
p.resp.itemguess=p.resp.keyleft;
p.resp.itemsure=p.resp.keyright;
p.resp.itemremember=p.resp.keyleft;
p.resp.itemknow=p.resp.keyright;
p.resp.pos1=28;
p.resp.pos2=29;
p.resp.pos3=30;
p.resp.pos4=31;
par_untested=0;
w.line=50; 
%
cd('Stimuli')
load ('stimlist.mat') 
cd ..
end
for o1=1:1 % PARAMETERS: Subject-specific 
% IDENTIFY FOILS
ets=encoding.trialstats_1item;
[w.nitemstotal w.a]=size(itemlist);
w.itemlist=zeros(w.nitemstotal,3);
for i=1:w.nitemstotal
    w.itemlist(i,1)=itemlist{i,2};
    w.itemlist(i,2)=itemlist{i,3};  
    w.itemlist(i,3)=2;
end
for i=1:p.n.items_encoded % Mark in Itemlist, which are foils/old
   ws.itemnum=ets(i,8);
   w.itemlist(ws.itemnum,3)=1;
end
j=1; % Create list of foils
w.foils=zeros(p.n.itemfoils,3);
for i=1:w.nitemstotal
    if w.itemlist(i,3)==2
        w.foils(j,:)=w.itemlist(i,:);
        j=j+1;
    end
end
w.foils(:,4)=rand(w.nitemstotal-p.n.items_encoded,1);
w.foils=sortrows(w.foils,4);
w.parfoils=zeros(p.n.itemfoils,28);
w.parfoils(:,:)=nan;
w.parfoils(:,4:17)=0;
w.parfoils(:,3)=2;
w.parfoils(:,2)=w.foils(1:p.n.itemfoils,2);
w.parfoils(:,28)=w.foils(1:p.n.itemfoils,1);
w.parfoils(:,29)=zeros(p.n.itemfoils,1);
% CONSTRUCT PAR FOR OLD ITEMS
par=zeros(p.n.memtrials,28);
par(:,:)=nan;
w.par=zeros(p.n.items_encoded,28);
w.par(:,:)=nan;
w.par(:,3)=1;
for i=1:p.n.items_encoded
    w.par(i,2)=ets(i,8);
    w.par(i,4)=ets(i,4);
    w.par(i,5:7)=ets(i,1:3);
    w.par(i,8)=ets(i,13);
    w.par(i,9)=ets(i,5);
    w.par(i,10)=ets(i,6);
    w.par(i,11)=ets(i,14);
    w.par(i,12)=ets(i,17); %
    w.par(i,13)=ets(i,18); 
    w.par(i,14)=ets(i,19);
    w.par(i,15)=ets(i,20);
    w.par(i,16:17)=ets(i,15:16);  
    w.par(i,28)=ets(i,7);
    w.par(i,29)=ets(i,9);
end
% FINISH OFF
par=vertcat(w.par,w.parfoils);
par(:,1)=rand(p.n.memtrials,1);
par=sortrows(par,1);
data=par;
end
    
% COGENT
config_display(w.screenmode, w.res, [0 0 0], [1 1 1], 'Helvetica', 40, 4); % marker 5g start
config_keyboard;
config_log(w.subject.filename); 
start_cogent 
cgloadlib
cgpencol([1 1 1])
cgtext('You should receive new instructions for this stage', 0, w.line*3)
cgtext(' of the experiment. If you do not receive instructions', 0, w.line*2)
cgtext('before the trials start, please tell the experimenter.', 0, w.line*1)
cgtext('Press any key to continue with the instructions', 0, w.line*-2)
w.startcogent=cgflip(0,0,0);
waitkeydown(inf)

%% ########### INSTRUCTIONS  ###############
% 
 for o1=1:1
     if w.testing==1
        cgflip(0,0,0)
        cgtext('Now you will do a memory test', 0, w.line*3)
        cgtext('Use the LEFT and RIGHT arrows', 0, w.line*1)       
        cgtext('to make your responses', 0, w.line*0)        
        cgtext('(with your RIGHT hand)', 0, w.line*-1)        
        cgtext('Press the RIGHT arrow key to continue', 0, w.line*-3)
        clearkeys
        cgflip(0,0,0);    
        waitkeydown(inf, p.resp.keyright)
        
        cgtext('Throughout this test, the two grey blocks ', 0, w.line*3)
        cgtext('at the bottom will indicate which Key you', 0, w.line*2)
        cgtext('should press for each type of response.', 0, w.line*1)     
        cgmakesprite(3, 170, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260)   
        cgfont('Helvetiuca',30)
        cgtext('LEFT key', -300, -260) 
        cgtext('RIGHT key', 300, -260) 
        cgfont('Helvetiuca',40)
        cgflip(0,0,0);    
        waitkeydown(inf)
        
        % OLD/NEW
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',150,150)
        cgdrawsprite(1,0,220) 
        cgtext('First you will see a picture of an object. On some', 0, w.line*2+20)
        cgtext('trials, you will have seen this object before. On', 0, w.line*1+20)
        cgtext('other trials, it will be new. ', 0, w.line*0+20)
        cgtext('Press the correct button to indicate ', 0, w.line*-2+20)
        cgtext('whether you think this picture is OLD or NEW.', 0, w.line*-3+20)
        cgfont('Helvetiuca',20)
        cgtext('(Note: OLD = You''ve seen the item before, in an earlier session of the experiment)', 0, w.line*-3-25)
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260) 
        cgfont('Helvetiuca',30)
        cgtext(' OLD                                                                               NEW', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        clearkeys
        cgflip(0,0,0);        
        waitkeydown(inf)
        
        % CONFIDENCE
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',150,150)
        cgdrawsprite(1,0,220) 
        cgtext('NEW', 0, w.line*2+20)
        cgtext('If you think the item is NEW, you will then indicate', 0, w.line*1+10)
        cgtext('how confident you are, about your response', 0, w.line*0+10)
        cgtext('Press the correct button to indicate if you are ', 0, w.line*-2+20)
        cgtext('SURE that the item is NEW, or if ', 0, w.line*-3+20)
        cgtext('you are just GUESSING ', 0, w.line*-4+20)
        cgfont('Helvetiuca',40)
        cgfont('Helvetiuca',40)
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260) 
        cgfont('Helvetiuca',30)
        cgtext(' GUESS                                                                          SURE  ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        cgflip(0,0,0);        
        waitkeydown(inf)

        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',150,150)
        cgdrawsprite(1,0,220) 
        cgtext('OLD', 0, w.line*2+20)
        cgtext('If you think the item is OLD, you will then be', 0, w.line*1+10)
        cgtext('asked about whether you REMEMBER seeing this', 0, w.line*0+10)
        cgtext('item, or if you just KNOW that it is an old one', 0, w.line*-1+10)
        cgflip(0,0,0);        
        waitkeydown(inf)
        %
        cgdrawsprite(1,0,220) 
        cgtext('OLD', 0, w.line*2+20)
        cgtext('If you think the item is OLD, you will then be', 0, w.line*1+10)
        cgtext('asked about whether you REMEMBER seeing this', 0, w.line*0+10)
        cgtext('item, or if you just KNOW that it is an old one', 0, w.line*-1+10)
        cgtext('Take a moment to see if you can remember any', 0, w.line*-3+20)
        cgtext('detail from when you saw this item, previously,', 0, w.line*-4+20)
        cgtext('(e.g.a thought you might have had at the time)', 0, w.line*-5+20)
        cgflip(0,0,0);
        waitkeydown(inf)
        %
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',150,150)
        cgdrawsprite(1,0,220) 
        cgtext('If you can explicitly remember seeing this item, or', 0, w.line*2+20)
        cgtext('if you recollect any specific associations from ', 0, w.line*1+20)
        cgtext('the experience of seeing this item previously,', 0, w.line*0+20)
        cgtext('press the LEFT key to indicate that you', 0, w.line*-1+20)
        cgtext('REMEMBER seeing this item', 0, w.line*-2+20)
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260)  
        cgfont('Helvetiuca',30)
        cgtext('REMEMBER                                                                     KNOW     ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        cgflip(0,0,0);        
        waitkeydown(inf)
        %
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',150,150)
        cgdrawsprite(1,0,220) 
        cgtext('If you cannot recollect any specific details', 0, w.line*2+20)
        cgtext('about having seen this item previously, but know ', 0, w.line*1+20)
        cgtext('that it is OLD because it seems familiar,', 0, w.line*0+20)
        cgtext('press the RIGHT key to indicate that you KNOW', 0, w.line*-1+20)
        cgtext('that this item is old', 0, w.line*-2+20)
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260)    
        cgfont('Helvetiuca',30)
        cgtext('REMEMBER                                                                     KNOW     ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        clearkeys
        cgflip(0,0,0);        
        waitkeydown(inf)
        %
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',150,150)
        cgdrawsprite(1,0,220) 
        cgtext('If you cannot recollect any specific details', 0, w.line*2+20)
        cgtext('about having seen this item previously, but know ', 0, w.line*1+20)
        cgtext('that it is OLD because it seems familiar,', 0, w.line*0+20)
        cgtext('press the RIGHT key to indicate that you KNOW', 0, w.line*-1+20)
        cgtext('that this item is old', 0, w.line*-2+20)
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260)    
        cgfont('Helvetiuca',25)
        cgtext('Note: It is very important that you understand when you should give a', 0, w.line*-2-20)
        cgtext('REMEMBER response, and when you should indicate KNOW', 0, w.line*-2-45)
        cgtext('If you feel like this is still unclear, please ask the experimenter', 0, w.line*-2-80)
        cgtext('for more explantion!', 0, w.line*-2-105)
        cgfont('Helvetiuca',30)
        cgtext('REMEMBER                                                                     KNOW     ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        cgflip(0,0,0);        
        waitkeydown(inf)
        
        cgdrawsprite(1,0,220) 
        cgtext('After you have indicated if you ', 0, w.line*2+20)
        cgtext('REMEMBER or KNOW the item, you will also', 0, w.line*1+20)
        cgtext('have to indicate how strongly you', 0, w.line*0+20)
        cgtext('remember, or know, the item', 0, w.line*-1+20)
        cgtext('Press the LEFT key if your memory for the item is', 0, w.line*-2)
        cgtext('weak, or the RIGHT key if your memory is strong', 0, w.line*-3)
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260)  
        cgfont('Helvetiuca',30)
        cgtext('WEAK',-300,-260)
        cgtext('STRONG',300,-260)
        cgfont('Helvetiuca',40)
        cgflip(0,0,0);        
        waitkeydown(inf)
               
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',100,100)
        cgloadbmp(2, 'Stimuli\eg_position.bmp',200,200)
        cgdrawsprite(2,0,195) 
        cgdrawsprite(1,0,80) 
        cgfont('Helvetiuca',30)
        cgtext('Background picture',220,255)        
        cgfont('Helvetiuca',40)
        cgtext('Lastly, you will be asked WHERE the item was,', 0, w.line*0)
        cgtext('on background picture, when you first saw it in the', 0, w.line*-1)
        cgtext('previous stage of the experiment', 0, w.line*-2)
        cgfont('Helvetiuca',20)
        cgtext('Reminder: In the previous session of the experiment, you saw Natural and Man-made items presented', 0, w.line*-3)
        cgtext('randomly in the four corners of the background pictures, one after the other. ', 0, w.line*-3-20)
        cgfont('Helvetiuca',40)
        cgflip(0,0,0);     
        waitkeydown(inf);   
        
        cgmakesprite(1, 600, 600, 0, 0 ,0) 
        cgloadbmp(1, 'Stimuli\eg_item.bmp',100,100)
        cgloadbmp(2, 'Stimuli\eg_position.bmp',200,200)
        cgdrawsprite(2,0,195) 
        cgdrawsprite(1,0,80) 
        cgfont('Helvetiuca',30)
        cgtext('Background picture',220,255)        
        cgfont('Helvetiuca',40)
        cgtext('Press the numbers 1, 2, 3 or 4 to indicate which', 0, w.line*0)
        cgtext('position you saw this item in, previously', 0, w.line*-1)
        cgtext('Use your LEFT hand, and the buttons on the', 0, w.line*-3)
        cgtext('LEFT side of the keyboard, for this task', 0, w.line*-4)
        cgflip(0,0,0);        
        waitkeydown(inf);   
                
        cgtext('Try your best to make the correct choices', 0, w.line*2)
        cgtext('Your memory score in this stage of the', 0, w.line*0)
        cgtext('experiment will be used to calculate how much ', 0, w.line*-1)
        cgtext('extra money we pay you, so do your best!', 0, w.line*-2)
        clearkeys
        cgflip(0,0,0);        
        waitkeydown(inf) 

        cgfont('Helvetiuca',40)
        cgtext('Any questions?', 0, w.line*2)
        cgtext('Please ask the experimenter if anything is unclear', 0, w.line*-3)
        cgfont('Helvetiuca',25)
        cgtext('Reminder: It is very important that you understand when you should give a', 0, w.line*1-20)
        cgtext('REMEMBER response, and when you should indicate KNOW', 0, w.line*1-45)
        cgtext('If you feel like this is still unclear, please ask the experimenter', 0, w.line*1-80)
        cgtext('for more explanation!', 0, w.line*1-105)
        cgflip(0,0,0);       
        waitkeydown(inf)
     else
     end
     
     % Last instruction before start
        cgflip(0,0,0)
        cgtext('Please position your fingers on the response keys', 0, w.line*3)
        cgfont('Helvetiuca',25)
        cgtext('RIGHT HAND: Left & Right arrow, for the item recognition task', 0, w.line*1+20)
        cgtext('LEFT HAND: Number buttons 1,2,3 & 4, for the position recognition task', 0, w.line*1-20)
        cgtext('LEFT ARROW', -300,-200)  
        cgtext('RIGHT ARROW', 300, -200)  
        cgfont('Helvetiuca',40)
        cgtext('Press the RIGHT arrow to begin', 0, w.line*-2)     
        cgmakesprite(3, 170, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260)  
        w.start=cgflip(0,0,0); 
        waitkeydown(inf,p.resp.keyright)
        cgtext('+',0,0)
        
 end
%% ########### MAIN LOOP  ############################################

for trialnum=1:p.n.memtrials
    w.fixationonset=cgflip(0,0,0);

    % Assemble correct stimuli for this trial
    w.itemfilename=itemlist{data(trialnum,2)};           
    cgmakesprite(1, 600, 600, 0, 0 ,0) 
    cgloadbmp(1, w.itemfilename)

    % %% Prepare Item-recognition (OLD/NEW)
    cgdrawsprite(1,0,100) 
    cgtext('OLD or NEW ? ', 0, w.line*-2)
    cgmakesprite(3, 185, 60, 0.2, 0.2 ,0.2) 
    cgdrawsprite(3,-300,-260) 
    cgdrawsprite(3,300,-260) 
    cgfont('Helvetiuca',30)
    cgtext(' OLD                                                                               NEW', 0, w.line*-5-12)   
    cgfont('Helvetiuca',40)
    w.keypress=[];
    w.keypressyes=0;
    w.keypresstime=[];
    waituntil(w.fixationonset*1000+0.25)    
    w.itemoldnewonset=cgflip(0,0,0);
    while w.keypressyes~=1
        clearkeys
        [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemold p.resp.itemnew]);
        if length(w.keypress)==1
            w.keypressyes=1;
        else
        end
    end
    if isempty(w.keypress)==1
        data(trialnum,18)=nan;
        data(trialnum,19)=nan;
    elseif w.keypress==p.resp.itemold %  old
        data(trialnum,18)=1;
        data(trialnum,19)=w.keypresstime-w.itemoldnewonset*1000;
    elseif w.keypress==p.resp.itemnew % new
        data(trialnum,18)=2;
        data(trialnum,19)=w.keypresstime-w.itemoldnewonset*1000;
    end

    % %% Test other detail? 
    w.testdetails=1; % default is to test details
    if data(trialnum,18)== 1 % if guess old, follow default
    elseif data(trialnum,18)==2
            w.testdetails=0;
    end

    if w.testdetails==0 %skip testing the rest of the details if picture is judged new 
         % %% Item: Sure/Guess (NEW)
        cgdrawsprite(1,0,100)   
        cgfont('Helvetiuca',30)
        cgtext('HOW SURE ARE YOU THAT THIS ITEM IS NEW?', 0, w.line*-2)
        cgmakesprite(3, 185, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260) 
        cgfont('Helvetiuca',30)
        cgtext(' GUESS                                                                          SURE  ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        w.keypress=[];
        w.keypressyes=0;
        w.keypresstime=[];
        w.itemconfidence=cgflip(0,0,0);
        while w.keypressyes~=1
            clearkeys
            [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemsure p.resp.itemguess]);
            if length(w.keypress)==1
                w.keypressyes=1;
            else
            end
        end
        if isempty(w.keypress)==1
            data(trialnum,22)=nan;
            data(trialnum,23)=nan;
        elseif w.keypress==p.resp.itemsure %  Sure 
            data(trialnum,22)=1;
            data(trialnum,23)=w.keypresstime-w.itemconfidence*1000;
        elseif w.keypress==p.resp.itemguess % Guess
            data(trialnum,22)=2;
            data(trialnum,23)=w.keypresstime-w.itemconfidence*1000;
        end
        data(trialnum,20)=999; % No Remember/Know judgments
        data(trialnum,21)=999;
        waituntil(w.itemconfidence*1000+1000) 
    else % Item is Old

        % %% ITEM: REMEMBER/KNOW --------------------------------
        cgdrawsprite(1,0,100) 
        cgtext('REMEMBER or KNOW?', 0, w.line*-1-10)
        cgfont('Helvetiuca',20)
        cgtext('Do you explicitly REMEMBER seeing this item, or any details from when you saw it?', 0, w.line*-3+20)
        cgtext('Or do you just KNOW that you''ve seen it before, without being able to remember', 0, w.line*-3-15)
        cgtext('anything about when you saw it?', 0, w.line*-3-40)
        cgmakesprite(3, 185, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260) 
        cgfont('Helvetiuca',30)
        cgtext('REMEMBER                                                                      KNOW   ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        w.keypress=[];
        w.keypressyes=0;
        w.keypresstime=[];
        w.itemremknowonset=cgflip(0,0,0);
        while w.keypressyes~=1
            clearkeys
            [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemremember p.resp.itemknow]);
            if length(w.keypress)==1
                w.keypressyes=1;
            else
            end
        end
        if isempty(w.keypress)==1
            data(trialnum,20)=nan;
            data(trialnum,21)=nan;
        elseif w.keypress==p.resp.itemremember %  remember
            data(trialnum,20)=1;
            data(trialnum,21)=w.keypresstime-w.itemremknowonset*1000;
        elseif w.keypress==p.resp.itemknow % know
            data(trialnum,20)=2;
            data(trialnum,21)=w.keypresstime-w.itemremknowonset*1000;
        end

        if data(trialnum,20)==1 % %% Item: REMEMBER
            cgdrawsprite(1,0,100)
            cgtext('REMEMBER', 0, w.line*-2+35)
            cgfont('Helvetiuca',30)
            cgtext('How strongly do you REMEMBER seeing this item?', 0, w.line*-2-35)
            cgmakesprite(3, 265, 60, 0.2, 0.2 ,0.2) 
            cgdrawsprite(3,-260,-260) 
            cgdrawsprite(3,260,-260) 
            cgfont('Helvetiuca',30)
            cgtext(' WEAKLY remember                                         STRONGLY remember', 0, w.line*-5-12)   
            cgfont('Helvetiuca',40)
            w.keypress=[];
            w.keypressyes=0;
            w.keypresstime=[];
            w.itemconfidence=cgflip(0,0,0);
            while w.keypressyes~=1
                clearkeys
                [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemsure p.resp.itemguess]);
                if length(w.keypress)==1
                    w.keypressyes=1;
                else
                end
            end
            if isempty(w.keypress)==1
                data(trialnum,22)=nan;
                data(trialnum,23)=nan;
            elseif w.keypress==p.resp.itemsure
                data(trialnum,22)=1;
                data(trialnum,23)=w.keypresstime-w.itemconfidence*1000;
            elseif w.keypress==p.resp.itemguess
                data(trialnum,22)=2;
                data(trialnum,23)=w.keypresstime-w.itemconfidence*1000;
            end

        elseif data(trialnum,20)==2% %% Item: KNOW
            cgdrawsprite(1,0,100)  
            cgtext('KNOW', 0, w.line*-2+35)
            cgfont('Helvetiuca',30)
            cgtext('How strongly do you KNOW that you have seen this item?', 0, w.line*-2-35)
            cgmakesprite(3, 265, 60, 0.2, 0.2 ,0.2) 
            cgdrawsprite(3,-260,-260) 
            cgdrawsprite(3,260,-260) 
            cgfont('Helvetiuca',30)
            cgtext(' WEAKLY know                                               STRONGLY know', 0, w.line*-5-12)   
            cgfont('Helvetiuca',40)
            w.keypress=[];
            w.keypressyes=0;
            w.keypresstime=[];
            w.itemconfidence=cgflip(0,0,0);
            while w.keypressyes~=1
                clearkeys
                [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemsure p.resp.itemguess]);
                if length(w.keypress)==1
                    w.keypressyes=1;
                else
                end
            end
            if isempty(w.keypress)==1
                data(trialnum,22)=nan;
                data(trialnum,23)=nan;
            elseif w.keypress==p.resp.itemsure %  Sure 
                data(trialnum,22)=1;
                data(trialnum,23)=w.keypresstime-w.itemconfidence*1000;
            elseif w.keypress==p.resp.itemguess % Guess
                data(trialnum,22)=2;
                data(trialnum,23)=w.keypresstime-w.itemconfidence*1000;
            end
        end
        
        % Test position recall
        cgloadbmp(5,'Stimuli\eg_position.bmp',400,400)
        cgloadbmp(1, w.itemfilename)
        cgdrawsprite(5,-100,85)          
        cgdrawsprite(1,180,-20)          
        cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) 
        cgdrawsprite(3,-300,-260) 
        cgdrawsprite(3,300,-260) 
        cgdrawsprite(3,100,-260) 
        cgdrawsprite(3,-100,-260) 
        cgfont('Helvetiuca',35)
        cgtext('Where on the background picture was this item shown?', 0, w.line*-3-35)
        cgfont('Helvetiuca',30)
        cgtext('Position 1             Position 2             Position 3              Position 4', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
       w.keypress=[];
       w.keypressyes=0;
       w.keypresstime=[];
       w.itempos=cgflip(0,0,0);
        while w.keypressyes~=1
            clearkeys
            [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.pos1 p.resp.pos2 p.resp.pos3 p.resp.pos4]);
            if length(w.keypress)==1
                w.keypressyes=1;
            else
            end
        end
        if isempty(w.keypress)==1
            data(trialnum,30)=nan;
            data(trialnum,31)=nan;
        else
            data(trialnum,31)=w.keypresstime-w.itempos*1000;
            switch w.keypress
                case p.resp.pos1
                    data(trialnum,30)=1;
                case p.resp.pos2
                    data(trialnum,30)=2;
                case p.resp.pos3
                    data(trialnum,30)=3;
                case p.resp.pos4
                    data(trialnum,30)=4;
            end
        end
    end


    % Notify researcher if almost done!
    if trialnum==p.n.memtrials-10
        try
        cd(dataloc)
        w.time=clock;
        f_sendemail('learnreward', strcat('[TEST] ', w.subjname, ' (Memory test) has 10 trials left (', num2str(w.time(4)), ':', num2str(w.time(5)),' hrs)') , strcat('Session almost complete: Memory test.') )
        catch
        end
        cd(dataloc)
    else
    end

    cgtext('+',0,0)  
end % for number of trials

        % %%
        cgflip(0,0,0)
        cgtext('Thank you', 0, w.line*4)
        cgtext('You have completed the last stage', 0, w.line*2)
        cgtext('of the experiment', 0, w.line*1)
        cgtext('Please call the experimenter', 0, w.line*-2)
        clearkeys
        w.endmemtest=cgflip(0,0,0);
        waitkeydown(inf)
        
stop_cogent
        
%%

for o5=1:1 % Evaluate memory test accuracy
    % Item recognition
    for i=1:p.n.memtrials
       if and(data(i,3)==1, data(i,18)==1) %if old, rate old
           data(i,26)=1;
       elseif and(data(i,3)==2, data(i,18)==2) %if new, rate new
           data(i,26)=1;
       else
           data(i,26)=0;
       end
    end
    w.accuracy_memtest=mean(data(:,26));     
    
    for i=1:p.n.memtrials
        if data(trialnum,29)==data(trialnum,30)
            data(trialnum,32)=1;
        else
            data(trialnum,32)=0;
        end
    end
    w.accuracy_itemposition=mean(data(:,32));
end
for o1=1:1 % Process Response type (ROC)
    for i=1:p.n.memtrials
        switch [num2str(data(i,12)) num2str(data(i,14)) num2str(data(i,16))]
            case '111' % 6: Old Rem Strong
                data(i,27)=6;
            case '112' % Old Rem Weak
                data(i,27)=5;
            case '121' % Old Know Strong
                data(i,27)=4;
            case '122' % Old Know Weak
                data(i,27)=3;
            case '29992' % New Unsure
                data(i,27)=2;
            case '29991' % Sure new
                data(i,27)=1;
            otherwise
                disp(['Error - cannot mark ROC - Trial ' num2str(i)])
        end
    end
end

try % Duration
    p.duration.memorytest=(w.endmemtest-w.startcogent)/60;
catch
    p.duration.memorytest='Couldn''t log duration';
end

% SAVE FILES
cd(dataloc)
cd('Data')
memtest.settings=p;
memtest.par_memtest=par;
memtest.trialstats=data;
memtest.accuracy_payment=w.accuracy_memtest;
w.savefile=strcat(p.subjectlog.name,'_file_3memorytest'); 
w.savefilecommand=strcat('save(w.savefile, ''memtest'')');
eval(w.savefilecommand)
p.duration
disp('-------------------')
disp(['Position recall score: ' num2str(w.accuracy_itemposition)])
disp(['Memory test score: ' num2str(w.accuracy_memtest)])
disp('-------------------')