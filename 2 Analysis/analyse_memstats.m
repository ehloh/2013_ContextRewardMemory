clear all; close all hidden;

where= '/Users/EleanorL/Dropbox/sandisk/9 Deacon project/3 Analysis/3 Analysis inputs/Reported v1 and v2 (3-5 and 3-3)/';
[n t d_dat]=xlsread([where filesep 'AllMemScores.xlsx'], 'hitrate'); % load d_data
d_head=d_dat(1,:)';

%%

d=d_dat;
whichsubs=find(cell2mat(d(2:end,2))==1)+1;   % 1 =Context, 2= No Context, 3=ContextControl

openvar d
openvar d_head
d(whichsubjs, 


% d(whichsubjs

