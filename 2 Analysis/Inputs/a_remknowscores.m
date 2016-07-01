% a_remknowscores 
clear all; clc

for o=1:1 % DATA. d_rk1=NoContext, d_rk2=Context
d_remknow= {'Condition'	'r_Reward'	'r_Neutral'	'k_Reward'	'k_Neutral';  % Condition: 1=NoContext, 2=Context
    1	0.2	0.12	0.17	0.23
    1	0.2	0.11	0.15	0.23
    1	0.22	0.21	-0.13	0.12
    1	0.36	0.24	0.17	0.08
    1	0.16	0.12	0.22	0.16
    1	0.17	0.04	0.11	0.03
    1	0.39	0.25	0.21	0.14
    1	0.05	0.14	0	0.21
    1	0.18	0.13	0.31	0.33
    1	0.25	0.34	0.09	0.07
    1	0.19	0.13	0.23	0.14
    1	0.18	0.08	0.13	0.28
    1	0.27	0.12	0.04	0.21
    1	0.25	0.16	0.14	0.07
    1	0.24	0.33	-0.02	0.06
    1	0.28	0.21	0.03	0
    2	0.6	0.4	0.08	0.03
    2	0.38	0.51	0.11	0.05
    2	0.24	0.33	0.1	0.05
    2	0.19	0.13	0.14	0.11
    2	0.26	0.22	0.15	0.21
    2	0.41	0.4	0.05	0.06
    2	0.21	0.15	0.07	0.05
    2	0.08	0.23	0.04	0.13
    2	0.08	0.06	0.31	0.17
    2	0.16	0.28	-0.03	0.11
    2	0.22	0.22	0.17	0.18
    2	0.35	0.25	0.15	0.11
    2	0.09	-0.01	0.15	0.07
    2	0.08	0.12	0.27	0.06}; 
d_rk1= cell2mat(d_remknow(2:17,:));  d_rk2= cell2mat(d_remknow(18:end, :)); 
end 
  
col.r_rew=2; 
col.r_neu=3; 
col.k_rew=4; 
col.k_neu=5; 

%%



% BETWEEN groups ttests 
d={d_rk1(:, col.r_neu)  d_rk2(:, col.r_neu)}; % Rem-Neutral
d={d_rk1(:, col.k_neu)  d_rk2(:, col.k_neu)}; % Know-Neutral

% Meta- effects 
d={d_rk1(:, col.r_neu)-d_rk1(:, col.k_neu)    d_rk2(:, col.r_neu)-d_rk2(:, col.k_neu)  };  % MEM EFFECT, Neutral 
d={d_rk1(:, col.r_rew)-d_rk1(:, col.k_rew)    d_rk2(:, col.r_rew)-d_rk2(:, col.k_rew)  };  % MEM EFFECT, Reward

d={d_rk1(:, col.r_rew)-d_rk1(:, col.r_neu)    d_rk2(:, col.r_rew)-d_rk2(:, col.r_neu)};  % % VAL EFFECT, Rem 



[h p ci st] = ttest2(   d{1}, d{2}); disp(['t(' num2str(st.df) ')= ' num2str(st.tstat) ', p=' num2str(p)])





% WITHIN group tests 
dd=d_rk1;    ddiff= dd(:,col.r_neu)- dd(:,col.k_neu);     % REM vs KNOW, Neutral
dd=d_rk2;    ddiff= dd(:,col.r_neu)- dd(:,col.k_neu); 

dd=d_rk1;    ddiff= dd(:,col.r_rew)- dd(:,col.k_rew);     % REM vs KNOW, Rew
dd=d_rk2;    ddiff= dd(:,col.r_rew)- dd(:,col.k_rew); 

[h p ci st] = ttest(   ddiff); disp(['t(' num2str(st.df) ')= ' num2str(st.tstat) ', p=' num2str(p)])


%%

[r p]=corr(d_rk2(:, [col.r_neu col.k_neu]))


std(d_rk2(:, [col.r_neu col.k_neu]))






