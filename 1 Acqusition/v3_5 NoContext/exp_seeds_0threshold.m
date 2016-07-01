% Thresholding 

for o1=1:1 % Documentation
% ITEM TASK
% Details of par and data file 
%   Col 1: 
%   Col 2: Keypress (1= Not manmade, 2=Manmade)
%   Col 3: RT
%   Col 4: Response status (1=Correct, 0=Incorrect or no response)
%   Col 5: Item stim index
%   Col 6: Item category (1= Not manmade, 2=Manmade)
% ------------------------------------------------------------------------------------- 
end
for o1=1:1 % TESTING or Coding?
clear all
clc

w.testing=1;
dataloc=pwd;  % 'H:\6 [v3.2 Seeds] Experiment MDeacon\2 Experiment execution\';

if w.testing==0   % Not testing
    disp('Coding mode')
    w.subjname='testing';
    w.screenmode=0;
elseif w.testing==1 % testing
    w.subjname=input('Subject ID: ','s');
    w.screenmode=1;
end

try
cd(dataloc)
catch
    dataloc=pwd;
    cd(dataloc)
    try
    cd(dataloc)
    catch
        disp('Wrong directory: Move to the correct Matlab folder!')
        input('Stop script now','s')
    end
end
end
for o2=1:1 % PARAMETERS: Item task
rand('state',sum(100*clock));% Make sure the random numbers are really random
w.subject.filename=strcat(w.subjname,'_thresholding');
p.subjectlog.name=w.subjname;
load Stimuli\stimlist
p.itemthresh_ntrials=30*2; % nitems x 2
p.resp.item_natural=98; % Natural = Right arrow
p.resp.item_manmade=97; % Man-made = Left arrow
p.itemthresh_RTcutoff=1600; %maximum time to make manmade/not judgment
p.itemfeedback=500;
% Subject-specific parameters
w.par(1:p.itemthresh_ntrials/2,5)=1:p.itemthresh_ntrials/2;
par=[];
for j=1:2
    for i=1:p.itemthresh_ntrials/2 % each item is repeated twice
        w.par(i,6)=thresholditem_list{w.par(i,5),2};
    end
    w.par(:,1)=rand(p.itemthresh_ntrials/2,1)';
    w.par=sortrows(w.par,1);
    par=vertcat(par,w.par);
end
par(:,1)=1:p.itemthresh_ntrials;
idata=par;
w.line=50; 
end

% COGENT
config_display(w.screenmode, 3, [0 0 0], [1 1 1], 'Helvetica', 40, 4); % marker 5g start
config_keyboard;
config_log(w.subject.filename); 
start_cogent 
cgloadlib
cgpencol([1 1 1])
cgtext('You should receive instructions for this stage', 0, w.line*3)
cgtext(' of the experiment. If you do not receive instructions', 0, w.line*2)
cgtext('before the trials start, please tell the experimenter.', 0, w.line*1)
cgtext('Press any key to continue', 0, w.line*-2)
w.startcogent=cgflip(0,0,0);
waitkeydown(inf)

%% ########### [ITEM THRESHOLDING] INSTRUCTIONS  ############################################
if w.testing==1;

for o1=1:1
    
    cgtext('This is a short practice stage, to get you used', 0, w.line*4)
    cgtext('to the tasks that you will have to do later on', 0, w.line*3)
    cgtext('You will do a short practice task', 0, w.line*1)
    cgflip(0,0,0); 
    waitkeydown(inf)
    
    cgmakesprite(1,300,300,0.1,0.1,0.1)
    cgloadbmp(2,'Stimuli\eg_item.bmp',150,0)
    cgdrawsprite(1,0,200)
    cgdrawsprite(2,0,200)
    cgtext('The task is very easy. On each trial, you will see', 0, w.line*0)
    cgtext('a picture of an item in the middle of the screen. ', 0, w.line*-1)
    cgtext('You have to decide whether the item is man-made, or not.',0, w.line*-2)
    cgtext('Press the LEFT arrow key if it is Man-made,', 0, w.line*-4)
    cgtext('or the RIGHT arrow key if it is Natural (not man-made)', 0, w.line*-5)
    cgmakesprite(3,235,60,0.1,0.1,0.1) 
    cgdrawsprite(3,300,-350)
    cgdrawsprite(3,-300,-350)
     cgtext('Man-made',-300,-350)
     cgtext('Natural',300,-350)
    cgflip(0,0,0); 
    waitkeydown(inf)
    
    cgdrawsprite(1,0,200)
    cgdrawsprite(2,0,200)
    cgtext('The computer will tell you if you were correct or not.', 0, w.line*0)
    cgtext('You have two seconds to make your response, for each item', 0, w.line*-1)
    cgtext('Note: An item like a potted plant, or a plant that''s been', 0, w.line*-3)
    cgtext('arranged decoratively, still counts as a NATURAL item.', 0, w.line*-4)
    cgtext('Please ask the experimenter if this is unclear ', 0, w.line*-5)
    cgflip(0,0,0); 
    waitkeydown(inf)
   
    cgtext(strcat('You will do [' , num2str(p.itemthresh_ntrials),'] trials of this task'), 0, w.line*3)
    cgtext('Please position your fingers on the response keys', 0, w.line*0)
    cgtext('      Man-made= Left Arrow        Natural= Right Arrow',0, w.line*-2+10)
    cgtext('Press the left arrow to begin', 0, w.line*-4)
    w.startthr=cgflip(0,0,0); 
    waitkeydown(inf,97)
    
end
            
else
end

%% ###########  [ITEM THRESHOLDING] MAIN LOOP  ############################################

cgmakesprite(1,600,600,0.1,0.1,0.1)
w.itemwrong=0;
% cgloadbmp(1,'static.bmp',600,0)

    for trialitem=1:p.itemthresh_ntrials
        w.item=thresholditem_list{idata(trialitem,5),1};
        cgloadbmp(2,w.item)
        cgdrawsprite(1,0,0)
        cgdrawsprite(2,0,0)
        cgmakesprite(3,235,60,0.1,0.1,0.1) 
        cgdrawsprite(3,300,-335)
        cgdrawsprite(3,-300,-335)
        cgtext('Man-made',-300,-335)
        cgtext('Natural',300,-335)
        clearkeys
        wi.itemonset=cgflip(0,0,0);
        waituntil(wi.itemonset*1000+p.itemthresh_RTcutoff)
        readkeys;
        [wi.key, wi.keytime, wi.n] = getkeydown;
        if wi.n==0 % no response
                wi.outcome='No response';
                w.keypress=nan;
                w.keypresstime=-999;
                idata(trialitem,2)=nan;
                idata(trialitem,3)=999;
                idata(trialitem,4)=-1;
                w.itemwrong=w.itemwrong+1;
        else
                wi.keypress=wi.key(1);
                if wi.keypress==p.resp.item_manmade
                    idata(trialitem,2)=2;
                elseif wi.keypress==p.resp.item_natural
                    idata(trialitem,2)=1;
                else
                    wi.outcome='Invalid response';
                    idata(trialitem,2)=999;
                    idata(trialitem,4)=-1;
                    w.itemwrong=w.itemwrong+1;
                end
                if idata(trialitem,2)==idata(trialitem,6)
                    wi.outcome='Correct!';
                    idata(trialitem,4)=1;
                elseif idata(trialitem,2)==999;
                     % if invalid response, keep the previous feedback!
                else
                    wi.outcome='Wrong answer!';
                    w.itemwrong=w.itemwrong+1;
                    idata(trialitem,4)=0;
                end
                idata(trialitem,3)=wi.keytime(1)-wi.itemonset*1000;
        end

        cgdrawsprite(1,0,0)
        cgdrawsprite(2,0,0)
        cgdrawsprite(3,300,-335)
        cgdrawsprite(3,-300,-335)
        cgtext('Man-made',-300,-335)
        cgtext('Natural',300,-335)
        cgtext(wi.outcome,0,-200)
        wi.feedbackonset=cgflip(0,0,0);
        waituntil(wi.feedbackonset*1000+p.itemfeedback)
        clear('wi')

    end

% %%
cgflip(0,0,0)
cgtext('Thank you', 0, w.line*3)
cgtext('You have completed the practice session',0, w.line*2)
cgtext('Please call the experimenter', 0, w.line*0)
clearkeys
w.endexperiment=cgflip(0,0,0); 
waitkeydown(inf)

stop_cogent

for o3=1:1 % Find a good threshold
% Item task
w.itemdat=[];
[w.sizeidataitem w.a]=size(idata);
for i=1:w.sizeidataitem % collect correct trials
    if idata(i,4)==1 && idata(i,1)>10 % discard first 10 trials
        w.itemdat=vertcat(w.itemdat,idata(i,:));
    else
    end
end
try
p.itemcutoff=mean(w.itemdat(:,3))+sqrt(var(w.itemdat(:,3)));
w.itemwarning=' ';
catch
    p.itemcutoff=1500; % Default item cutoff is 1.5s
    w.itemwarning='Could not compute threshold for Item judgments. Manually inspect data - too few correct?';
end
end
try % Duration
    if w.testing==1
        p.duration.instructions=(w.startthr-w.startcogent)/60;
        p.duration.thresholding=(w.endexperiment-w.startthr)/60;
    elseif w.testing==0
        p.duration.thresholding=(w.endexperiment-w.startcogent)/60;
    end
catch
    p.duration='Couldn''t log duration';
end

% SAVE FILES
cd(dataloc)
cd('Data')
thresholding.settings=p;
thresholding.par_item=par;
thresholding.item_trialstats=idata;
w.savefile=strcat(p.subjectlog.name,'_file_0thresholding'); 
w.savefilecommand=strcat('save(w.savefile, ''thresholding'')');
eval(w.savefilecommand)
%
disp('----------------')
disp('ITEM TASK')
disp(['# Errors:' num2str(w.itemwrong) ' out of 50'])
disp(['Mean + SD = ' num2str(p.itemcutoff)])
disp(w.itemwarning)
disp('----------------')
