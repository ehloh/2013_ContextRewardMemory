%  MEMORY TEST: Remember/Know procedure, with Confidence ratings
%   Note: Foils set up during encoding stage. This script just executes.
%   Different from previous iterations of this experiment
clear all; clc

testing=1;

for o1=1:1 % Documentation
    
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
for o1=1:1 % TESTING or Coding?
    if testing==0   % Coding
        disp('Coding mode')
        w.subject='t2';
        w.screenmode=0;
    elseif testing==1 % testing
        w.subject=input('Subject ID: ','s');
        w.screenmode=0;
    end
    try w.s=load('Stimuli\stimlist.mat');
    catch; error('You are in the wrong directory!')
    end
    rand('state',sum(100*clock));
end
for o1=1:1 % PARAMETERS: General
    load Stimuli\stimlist.mat
    load(['Data' filesep w.subject '_file_2enc.mat'])
    p.subjectlog=enc.settings.subjectlog;
    p.n.encitems=enc.settings.n.items_encoded;
    p.n.itemfoils=enc.settings.n.itemfoils;
    p.n.memtrials=p.n.encitems+p.n.itemfoils;
    
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
    w.line=50;  w.res=3;
end
for o1=1:1 % PARAMETERS: Subject-specific
    data=nan(p.n.memtrials, 20);
    data(1:p.n.encitems, [col.ItemStim col.EncTrial  col.EncSceneStim(1) col.EncSceneStim(2)  col.EncSimDis col.EncContextBlock  col.EncCorrect col.EncItemType  col.EncItemPos])= enc.trialstats(enc.trialstats(:, enc.col.ItemType)<3, [enc.col.ItemStim enc.col.Trialnum enc.col.SceneStim(1) enc.col.SceneStim(2) enc.col.SimDis enc.col.ContextBlock  enc.col.ItemCorrectResp enc.col.ItemType  enc.col.ItemPos]);
    data(1:p.n.encitems, col.OldFoil)=1;
    data(p.n.encitems+1:end, col.OldFoil)=2;
    data(p.n.encitems+1:end, col.ItemStim)=[enc.settings.itemfoils(1:p.n.itemfoils/2, 2); enc.settings.itemfoils(    find(enc.settings.itemfoils(:, 1)==2, 1, 'first'):find(enc.settings.itemfoils(:, 1)==2, 1, 'first')-1+p.n.itemfoils/2 , 2)];
    data(:,col.Trialnum)=rand(p.n.memtrials,1); data=sortrows(data, col.Trialnum);
end

% COGENT
config_display(w.screenmode, w.res, [0 0 0], [1 1 1], 'Helvetica', 40, 4); % marker 5g start
config_keyboard; cgloadlib; cgpencol([1 1 1])
start_cogent 
cgtext('You should receive new instructions for this stage', 0, w.line*3)
cgtext(' of the experiment. If you do not receive instructions', 0, w.line*2)
cgtext('before the trials start, please tell the experimenter.', 0, w.line*1)
cgtext('Press any key to continue with the instructions', 0, w.line*-2)
w.startcogent=cgflip(0,0,0);
waitkeydown(inf)

%% ########### INSTRUCTIONS  ###############
% 
 for o1=1:1
     if testing==1
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

for trialnum=1: p.n.memtrials
    w.fixationonset=cgflip(0,0,0);

    % Assemble correct stimuli for this trial
    w.itemfilename=itemlist{data(trialnum,col.ItemStim)};           
    cgmakesprite(1, 600, 600, 0, 0 ,0) 
    cgloadbmp(1, w.itemfilename)

    % %% Prepare Item-recognition (OLD/NEW)
    cgdrawsprite(1,0,100) ;
    cgtext('OLD or NEW ? ', 0, w.line*-2);
    cgmakesprite(3, 185, 60, 0.2, 0.2 ,0.2); cgdrawsprite(3,-300,-260); cgdrawsprite(3,300,-260) ;
    cgfont('Helvetiuca',30);
    cgtext(' OLD                                                                               NEW', 0, w.line*-5-12) ;  
    cgfont('Helvetiuca',40);
    w.keypress=[]; w.keypressyes=0; w.keypresstime=[];
    waituntil(w.fixationonset*1000+0.25)    
    w.itemoldnewonset=cgflip(0,0,0);
    while w.keypressyes~=1
        clearkeys; [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemold p.resp.itemnew]);
        if length(w.keypress)==1;  w.keypressyes=1; end
    end
    if isempty(w.keypress)==1
        data(trialnum,col.OldNew)=nan;
        data(trialnum,col.RT_OldNew)=nan;
    elseif w.keypress==p.resp.itemold %  old
        data(trialnum,col.OldNew)=1;
        data(trialnum,col.RT_OldNew)=w.keypresstime-w.itemoldnewonset*1000;
    elseif w.keypress==p.resp.itemnew % new
        data(trialnum,col.OldNew)=2;
        data(trialnum,col.RT_OldNew)=w.keypresstime-w.itemoldnewonset*1000;
    end

    % %% Test other detail? 
    w.testdetails=1; % default is to test details
    if data(trialnum,col.OldNew)== 1 % if guess old, follow default
    elseif data(trialnum,col.OldNew)==2
            w.testdetails=0;
    end

    if w.testdetails==0 %skip testing the rest of the details if picture is judged new 
         % %% Item: Sure/Guess (NEW)
        cgdrawsprite(1,0,100)   
        cgfont('Helvetiuca',30)
        cgtext('HOW SURE ARE YOU THAT THIS ITEM IS NEW?', 0, w.line*-2)
        cgmakesprite(3, 185, 60, 0.2, 0.2 ,0.2); cgdrawsprite(3,-300,-260); cgdrawsprite(3,300,-260) 
        cgfont('Helvetiuca',30)
        cgtext(' GUESS                                                                          SURE  ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        w.keypress=[]; w.keypressyes=0; w.keypresstime=[];
        w.itemconfidence=cgflip(0,0,0);
        while w.keypressyes~=1
            clearkeys; [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemsure p.resp.itemguess]);
            if length(w.keypress)==1;  w.keypressyes=1;end
        end
        if isempty(w.keypress)==1
            data(trialnum,col.SureGuess)=nan;
            data(trialnum,col.RT_SureGuess)=nan;
        elseif w.keypress==p.resp.itemsure %  Sure 
            data(trialnum,col.SureGuess)=1;
            data(trialnum,col.RT_SureGuess)=w.keypresstime-w.itemconfidence*1000;
        elseif w.keypress==p.resp.itemguess % Guess
            data(trialnum,col.SureGuess)=2;
            data(trialnum,col.RT_SureGuess)=w.keypresstime-w.itemconfidence*1000;
        end
        data(trialnum, col.RemKnow)=999; % No Remember/Know judgments
        data(trialnum, col.RT_RemKnow)=999;
        waituntil(w.itemconfidence*1000+1000) 
    else % Item is Old

        % %% ITEM: REMEMBER/KNOW --------------------------------
        cgdrawsprite(1,0,100) 
        cgtext('REMEMBER or KNOW?', 0, w.line*-1-10)
        cgfont('Helvetiuca',20)
        cgtext('Do you explicitly REMEMBER seeing this item, or any details from when you saw it?', 0, w.line*-3+20)
        cgtext('Or do you just KNOW that you''ve seen it before, without being able to remember', 0, w.line*-3-15)
        cgtext('anything about when you saw it?', 0, w.line*-3-40)
        cgmakesprite(3, 185, 60, 0.2, 0.2 ,0.2); cgdrawsprite(3,-300,-260); cgdrawsprite(3,300,-260) 
        cgfont('Helvetiuca',30)
        cgtext('REMEMBER                                                                      KNOW   ', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
        w.keypress=[]; w.keypressyes=0; w.keypresstime=[];
        w.itemremknowonset=cgflip(0,0,0);
        while w.keypressyes~=1
            clearkeys; [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemremember p.resp.itemknow]);
            if length(w.keypress)==1; w.keypressyes=1; end
        end
        if isempty(w.keypress)==1
            data(trialnum, col.RemKnow)=nan;
            data(trialnum, col.RT_RemKnow)=nan;
        elseif w.keypress==p.resp.itemremember %  remember
            data(trialnum, col.RemKnow)=1;
            data(trialnum, col.RT_RemKnow)=w.keypresstime-w.itemremknowonset*1000;
        elseif w.keypress==p.resp.itemknow % know
            data(trialnum, col.RemKnow)=2;
            data(trialnum, col.RT_RemKnow)=w.keypresstime-w.itemremknowonset*1000;
        end

        if data(trialnum, col.RemKnow)==1 % %% Item: REMEMBER
            cgdrawsprite(1,0,100)
            cgtext('REMEMBER', 0, w.line*-2+35)
            cgfont('Helvetiuca',30)
            cgtext('How strongly do you REMEMBER seeing this item?', 0, w.line*-2-35)
            cgmakesprite(3, 265, 60, 0.2, 0.2 ,0.2); cgdrawsprite(3,-260,-260); cgdrawsprite(3,260,-260) 
            cgfont('Helvetiuca',30)
            cgtext(' WEAKLY remember                                         STRONGLY remember', 0, w.line*-5-12)   
            cgfont('Helvetiuca',40)
            w.keypress=[]; w.keypressyes=0; w.keypresstime=[];
            w.itemconfidence=cgflip(0,0,0);
            while w.keypressyes~=1
                clearkeys; [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemsure p.resp.itemguess]);
                if length(w.keypress)==1; w.keypressyes=1; end
            end
            if isempty(w.keypress)==1
                data(trialnum,col.SureGuess)=nan;
                data(trialnum,col.RT_SureGuess)=nan;
            elseif w.keypress==p.resp.itemsure
                data(trialnum,col.SureGuess)=1;
                data(trialnum,col.RT_SureGuess)=w.keypresstime-w.itemconfidence*1000;
            elseif w.keypress==p.resp.itemguess
                data(trialnum,col.SureGuess)=2;
                data(trialnum,col.RT_SureGuess)=w.keypresstime-w.itemconfidence*1000;
            end

        elseif data(trialnum, col.RemKnow)==2% %% Item: KNOW
            cgdrawsprite(1,0,100)  
            cgtext('KNOW', 0, w.line*-2+35)
            cgfont('Helvetiuca',30)
            cgtext('How strongly do you KNOW that you have seen this item?', 0, w.line*-2-35)
            cgmakesprite(3, 265, 60, 0.2, 0.2 ,0.2); cgdrawsprite(3,-260,-260); cgdrawsprite(3,260,-260) 
            cgfont('Helvetiuca',30)
            cgtext(' WEAKLY know                                               STRONGLY know', 0, w.line*-5-12)   
            cgfont('Helvetiuca',40)
            w.keypress=[]; w.keypressyes=0; w.keypresstime=[];
            w.itemconfidence=cgflip(0,0,0);
            while w.keypressyes~=1
                clearkeys; [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.itemsure p.resp.itemguess]);
                if length(w.keypress)==1; w.keypressyes=1;end
            end
            if isempty(w.keypress)==1
                data(trialnum,col.SureGuess)=nan;
                data(trialnum,col.RT_SureGuess)=nan;
            elseif w.keypress==p.resp.itemsure %  Sure 
                data(trialnum,col.SureGuess)=1;
                data(trialnum,col.RT_SureGuess)=w.keypresstime-w.itemconfidence*1000;
            elseif w.keypress==p.resp.itemguess % Guess
                data(trialnum,col.SureGuess)=2;
                data(trialnum,col.RT_SureGuess)=w.keypresstime-w.itemconfidence*1000;
            end
        end
        
        % Test position recall
        cgloadbmp(5,'Stimuli\eg_position.bmp',400,400)
        cgloadbmp(1, w.itemfilename)
        cgdrawsprite(5,-100,85); cgdrawsprite(1,180,-20); cgmakesprite(3, 180, 60, 0.2, 0.2 ,0.2) ; cgdrawsprite(3,-300,-260) ; cgdrawsprite(3,300,-260) ; cgdrawsprite(3,100,-260) ; cgdrawsprite(3,-100,-260) ;
        cgfont('Helvetiuca',35)
        cgtext('Where on the background picture was this item shown?', 0, w.line*-3-35)
        cgfont('Helvetiuca',30)
        cgtext('Position 1             Position 2             Position 3              Position 4', 0, w.line*-5-12)   
        cgfont('Helvetiuca',40)
       w.keypress=[]; w.keypressyes=0; w.keypresstime=[];
       w.itempos=cgflip(0,0,0);
        while w.keypressyes~=1
            clearkeys; [w.keypress, w.keypresstime, w.keypressx]=waitkeydown(inf,[p.resp.pos1 p.resp.pos2 p.resp.pos3 p.resp.pos4]);
            if length(w.keypress)==1; w.keypressyes=1; end
        end
        if isempty(w.keypress)==1
            data(trialnum, col.Pos)=nan;
            data(trialnum, col.RT_Pos)=nan;
        else
            data(trialnum,col.RT_Pos)=w.keypresstime-w.itempos*1000;
            switch w.keypress
                case p.resp.pos1
                    data(trialnum, col.Pos)=1;
                case p.resp.pos2
                    data(trialnum, col.Pos)=2;
                case p.resp.pos3
                    data(trialnum, col.Pos)=3;
                case p.resp.pos4
                    data(trialnum, col.Pos)=4;
            end
        end
    end


    % Notify researcher if almost done!
    if trialnum==p.n.memtrials-10
        try; w.time=clock; f_sendemail('learnreward', strcat('[TEST] ', w.subjname, ' (Memory test) has 10 trials left (', num2str(w.time(4)), ':', num2str(w.time(5)),' hrs)') , strcat('Session almost complete: Memory test.') ); end
    end
    disp(['Trial ' num2str(trialnum) ':      '  num2str(data(trialnum,[col.OldFoil col.OldNew col.RemKnow col.SureGuess col.Pos]))])
    
    
    cgtext('+',0,0)  
end % for number of trials

% %%
cgflip(0,0,0)
cgtext('Thank you', 0, w.line*4)
cgtext('You have completed this stage', 0, w.line*2)
cgtext('of the experiment', 0, w.line*1)
cgtext('Please call the experimenter', 0, w.line*-2)
clearkeys
w.endmemtest=cgflip(0,0,0);
waitkeydown(inf)
        
stop_cogent
        
%%

% Evaluate memory performance
data(:, col.OldNewAccuracy)=data(:, col.OldFoil)==data(:, col.OldNew);
data(:, col.PosAccuracy)=data(:, col.EncItemPos)==data(:, col.Pos);
data(data(:, col.OldNew)==1 & data(:, col.RemKnow)==1 &  data(:, col.SureGuess)==1, col.Roc)=6;
data(data(:, col.OldNew)==1 & data(:, col.RemKnow)==1 &  data(:, col.SureGuess)==2, col.Roc)=5;
data(data(:, col.OldNew)==1 & data(:, col.RemKnow)==2 &  data(:, col.SureGuess)==1, col.Roc)=4;
data(data(:, col.OldNew)==1 & data(:, col.RemKnow)==2 &  data(:, col.SureGuess)==2, col.Roc)=3;
data(data(:, col.OldNew)==2 & data(:, col.SureGuess)==2, col.Roc)=2;
data(data(:, col.OldNew)==2 & data(:, col.SureGuess)==1, col.Roc)=1;

try % Duration
    p.duration.memorytest=(w.endmemtest-w.startcogent)/60;
catch p.duration.memorytest='Couldn''t log duration';
end

% Save
memtest.settings=p;
memtest.trialstats=data;
memtest.accuracy_payment=mean(data(:,col.OldNewAccuracy));
save(['Data' filesep p.subjectlog.name '_file_3memorytest'], 'memtest');
disp('--------------------------------------')
disp(['Position recall score: ' num2str(mean(data(:,col.OldNewAccuracy)))])
disp(['Memory test score: ' num2str(mean(data(:,col.PosAccuracy)))])
disp('--------------------------------------')