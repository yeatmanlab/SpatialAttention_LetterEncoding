function [data4pos, data4lme, exo_only, endo_only,Data4lme,Data4pos]=getDataOrg2
% This is a duplicate of getDataOrg.m 
% The only difference in this mfile is how Position Swaps are calculated. 
% Position swaps are only when swaps are made from adjacent positions. 
%{ 
The data structure is as follows: each subject performs both the exo and
endo conditions/cueTypes. 
Randome effect: subject
Fixed factors:
CueType     : Exo (0) and Endo(1)
CTOAs       : 50ms (1), 100(2), 300 (3) and 400(4)
positions   : 1 through 6.
----
keep this optional-incase you want to see difference in performance with 
each  cueType otherwise the dependent of interest is the 
cueBenefit. 

cueValidity : Valid(1), Neutral (2), Invalid(3) 
---
Dependent variables:
cue Benefit: d' (V-N) 
cue Effect : d' (V-I) only for exo
cue Cost   : d' (N-I) only for exo 
pSwaps_V   : errorRate (#of positionSwap errors/total#of trials)
pSwaps_N   : errorRate/AOC
misId_V    : errorRate/AOC
misID_N    : errorRate/AOC

By Maha Ramamurthy, 2021

%} 
clear all; close all;clc
load('~/Desktop/DataSharing_MR/results/Endo/AllEndo.mat')
for n=1:length(subject)
    endo(n) =subject(n).endo;
end
pos=6;postn=[1 2 3 4 5 6];
endo_all=[];
endo_ctoa=[];
CTOA = endo(1).ctoa;
for n=1:length(endo)
    subjId=str2num(extractBefore(subject(n).endo.thisBlock(1).name,'_20'));
    if isempty(subjId)
        subjId=str2num(extractBefore(subject(n).endo.thisBlock(1).name,'_21'));
    end
    cueType=1;
    for c=1:length(CTOA)
          eval(['perf_Valid_' num2str(CTOA(c)) '= endo(' num2str(n) ').dprime_ValidTrial_' num2str(CTOA(c)) ';'])
          eval(['perf_Neutl_' num2str(CTOA(c)) '= endo(' num2str(n) ').dprime_NeutralTrial_' num2str(CTOA(c)) ';'])
          eval(['cueBen_' num2str(CTOA(c)) '= endo(' num2str(n) ').dpriCueEff_' num2str(CTOA(c)) ';'])
          eval(['pSwap_V_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.SwapPos_Vmat2_' num2str(CTOA(c)) ');'])
          eval(['pSwap_N_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.SwapPos_Nmat2_' num2str(CTOA(c)) ');'])
          eval(['misID_V_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.misID_Vmat_' num2str(CTOA(c)) ');'])
          eval(['misID_N_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.misID_Nmat_' num2str(CTOA(c)) ');'])
         
          eval(['tot_N_' num2str(CTOA(c)) '=(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) ');'])
          eval(['tot_V_' num2str(CTOA(c)) '=(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) ');'])
          eval(['num_InCx_swapsV_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.SwapPos_Vmat2_' num2str(CTOA(c)) '));'])
          eval(['num_InCx_misIDV_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.misID_Vmat_' num2str(CTOA(c)) '));'])
          
          eval(['num_InCx_swapsN_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.SwapPos_Nmat2_' num2str(CTOA(c)) '));'])
          eval(['num_InCx_misIDN_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.misID_Nmat_' num2str(CTOA(c)) '));'])
          
          eval(['AUC_pSwap_V_' num2str(CTOA(c)) '=trapz(postn,pSwap_V_' num2str(CTOA(c)) char(39) ');'])
          eval(['AUC_pSwap_N_' num2str(CTOA(c)) '=trapz(postn,pSwap_N_' num2str(CTOA(c)) char(39) ');'])
          eval(['AUC_misID_V_' num2str(CTOA(c)) '=trapz(postn,misID_V_' num2str(CTOA(c)) char(39) ');'])
          eval(['AUC_misID_N_' num2str(CTOA(c)) '=trapz(postn,misID_N_' num2str(CTOA(c)) char(39) ');'])
          
        for p=1:pos
            eval(['cueBen_' num2str(p) '= endo(' num2str(n) ').dp' num2str(p) '_Val_' num2str(CTOA(c))  '- endo(' num2str(n) ').dp' num2str(p) '_Neu_' num2str(CTOA(c)) ';'])
            eval(['dpVal_' num2str(p) '= endo(' num2str(n) ').dp' num2str(p) '_Val_' num2str(CTOA(c)) ';'])
            eval(['dpNeu_' num2str(p) '= endo(' num2str(n) ').dp' num2str(p) '_Neu_' num2str(CTOA(c)) ';'])
            eval(['endo_all = [endo_all;subjId,cueType,' num2str(CTOA(c)) ',' num2str((c)) ',' num2str(p) ', cueBen_' num2str(p) ',dpVal_' num2str(p) ',dpNeu_' num2str(p)...
                ',pSwap_V_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '/6),pSwap_N_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c))...
                '/6),misID_V_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '/6), misID_N_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) '/6)];'])
        end        
        eval(['endo_ctoa = [endo_ctoa;subjId,cueType,' num2str(CTOA(c)) ',' num2str((c)) ',' num2str(p) ', cueBen_' num2str(CTOA(c))...
            ',sum(pSwap_V_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '),sum(pSwap_N_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) ...           
            '),sum(misID_V_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '),sum(misID_N_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) '),perf_Valid_' num2str(CTOA(c)) ',perf_Neutl_' num2str(CTOA(c)) ',AUC_pSwap_V_' num2str(CTOA(c)) ',AUC_pSwap_N_' num2str(CTOA(c))...
            ',AUC_misID_V_' num2str(CTOA(c)) ',AUC_misID_N_' num2str(CTOA(c)) ',tot_N_' num2str(CTOA(c)) ',tot_V_' num2str(CTOA(c)) ',num_InCx_swapsV_' num2str(CTOA(c)) ',num_InCx_misIDV_' num2str(CTOA(c)) ',num_InCx_swapsN_' num2str(CTOA(c)) ',num_InCx_misIDN_' num2str(CTOA(c)) '];'])
    end
end
endo_all=table(endo_all(:,1),endo_all(:,2),endo_all(:,3),endo_all(:,4),endo_all(:,5),endo_all(:,6),endo_all(:,7),endo_all(:,8),endo_all(:,9), endo_all(:,10),endo_all(:,11),endo_all(:,12),...
    'VariableNames',{'subID', 'cueType','CTOAs','CTOA_nom','position','cueBenefit','dpVal','dpNeu','pSwaps_V','pSwaps_N','misID_V','misID_N'});
endo_ctoa=table(endo_ctoa(:,1),endo_ctoa(:,2),endo_ctoa(:,3),endo_ctoa(:,4),endo_ctoa(:,5),endo_ctoa(:,6),endo_ctoa(:,7),endo_ctoa(:,8),endo_ctoa(:,9),endo_ctoa(:,10),endo_ctoa(:,11),endo_ctoa(:,12),...
    endo_ctoa(:,13),endo_ctoa(:,14),endo_ctoa(:,15),endo_ctoa(:,16),endo_ctoa(:,17),endo_ctoa(:,18),endo_ctoa(:,19),endo_ctoa(:,20),endo_ctoa(:,21),endo_ctoa(:,22),...
    'VariableNames',{'subID', 'cueType','CTOAs','CTOA_nom','position','cueBenAvg','pSwaps_V','pSwaps_N','misID_V','misID_N','perf_Valid','perf_Neutl','AUC_pSwap_V','AUC_pSwap_N','AUC_misID_V','AUC_misID_N','TotN','TotV','num_InCx_swapsV', 'num_InCx_misIDV','num_InCx_swapsN', 'num_InCx_misIDN'});
%% 
clear errTable
clear subject
load('~/Desktop/DataSharing_MR/results/Exo/AllExo.mat')
for n=1:length(subject)
    exo(n) =subject(n).exo;
end
pos=6;
exo_all=[];exo_ctoa=[];
CTOA = exo(1).ctoa;
for n=1:length(exo)
    subjId = str2num(extractBefore(subject(n).exo.thisBlock(1).name,'_20'));
    if isempty(subjId)
        subjId=str2num(extractBefore(subject(n).exo.thisBlock(1).name,'_21'));
    end
    cueType= 0;
    for c=1:length(CTOA)
         eval(['perf_Valid_' num2str(CTOA(c)) '=exo(' num2str(n) ').dprime_ValidTrial_' num2str(CTOA(c)) ';'])
         eval(['perf_Neutl_' num2str(CTOA(c)) '=exo(' num2str(n) ').dprime_NeutralTrial_' num2str(CTOA(c)) ';'])
         eval(['perf_InVal_' num2str(CTOA(c)) '=exo(' num2str(n) ').dprime_InValTrial_' num2str(CTOA(c)) ';'])
         
         eval(['cueBen_' num2str(CTOA(c)) '= exo(' num2str(n) ').cueEff_dp_' num2str(CTOA(c)) ';'])
         eval(['cueEff_' num2str(CTOA(c)) '= exo(' num2str(n) ').cueEff_V2I_dp_' num2str(CTOA(c)) ';'])
         eval(['cueCst_' num2str(CTOA(c)) '= exo(' num2str(n) ').cueCost_dp_' num2str(CTOA(c)) ';'])
         
         eval(['pSwap_V_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.SwapPos_Vmat2_' num2str(CTOA(c)) ');'])
         eval(['pSwap_N_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.SwapPos_Nmat2_' num2str(CTOA(c)) ');'])
         eval(['pSwap_I_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.SwapPos_Imat2_' num2str(CTOA(c)) ');'])
         
         eval(['misID_V_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.misID_Vmat_' num2str(CTOA(c)) ');'])
         eval(['misID_N_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.misID_Nmat_' num2str(CTOA(c)) ');'])
         eval(['misID_I_' num2str(CTOA(c)) '=cell2mat(errTable{' num2str(n) '}.misID_Imat_' num2str(CTOA(c)) ');'])
         
         
         eval(['tot_N_' num2str(CTOA(c)) '=(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) ');'])
          eval(['tot_V_' num2str(CTOA(c)) '=(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) ');'])
          eval(['num_InCx_swapsV_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.SwapPos_Vmat2_' num2str(CTOA(c)) '));'])
          eval(['num_InCx_misIDV_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.misID_Vmat_' num2str(CTOA(c)) '));'])
          
          eval(['num_InCx_swapsN_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.SwapPos_Nmat2_' num2str(CTOA(c)) '));'])
          eval(['num_InCx_misIDN_' num2str(CTOA(c)) '=sum(cell2mat(errTable{' num2str(n) '}.misID_Nmat_' num2str(CTOA(c)) '));'])
         
         
         eval(['AUC_pSwap_V_' num2str(CTOA(c)) '=trapz(postn,pSwap_V_' num2str(CTOA(c)) char(39) ');'])
         eval(['AUC_pSwap_N_' num2str(CTOA(c)) '=trapz(postn,pSwap_N_' num2str(CTOA(c)) char(39) ');'])
         eval(['AUC_pSwap_I_' num2str(CTOA(c)) '=trapz(postn,pSwap_I_' num2str(CTOA(c)) char(39) ');'])
         
         eval(['AUC_misID_V_' num2str(CTOA(c)) '=trapz(postn,misID_V_' num2str(CTOA(c)) char(39) ');'])
         eval(['AUC_misID_N_' num2str(CTOA(c)) '=trapz(postn,misID_N_' num2str(CTOA(c)) char(39) ');'])
         eval(['AUC_misID_I_' num2str(CTOA(c)) '=trapz(postn,misID_I_' num2str(CTOA(c)) char(39) ');'])
          
        for p=1:pos
            eval(['cueBen_' num2str(p) '= exo(' num2str(n) ').dp' num2str(p) '_Val_' num2str(CTOA(c))  '- exo(' num2str(n) ').dp' num2str(p) '_Neu_' num2str(CTOA(c)) ';'])
            eval(['cueEff_' num2str(p) '= exo(' num2str(n) ').dp' num2str(p) '_Val_' num2str(CTOA(c))  '- exo(' num2str(n) ').dp' num2str(p) '_InV_' num2str(CTOA(c)) ';'])
            eval(['cueCst_' num2str(p) '= exo(' num2str(n) ').dp' num2str(p) '_Neu_' num2str(CTOA(c))  '- exo(' num2str(n) ').dp' num2str(p) '_InV_' num2str(CTOA(c)) ';'])
            eval(['dpVal_' num2str(p) '= exo(' num2str(n) ').dp' num2str(p) '_Val_' num2str(CTOA(c)) ';'])
            eval(['dpNeu_' num2str(p) '= exo(' num2str(n) ').dp' num2str(p) '_Neu_' num2str(CTOA(c)) ';'])
            eval(['dpInV_' num2str(p) '= exo(' num2str(n) ').dp' num2str(p) '_InV_' num2str(CTOA(c)) ';'])
            eval(['exo_all = [exo_all;subjId,cueType,' num2str(CTOA(c)) ',' num2str((c)) ',' num2str(p) ', cueBen_' num2str(p) ', cueEff_' num2str(p) ',cueCst_' num2str(p) ',dpVal_' num2str(p) ',dpNeu_' num2str(p) ',dpInV_' num2str(p)  ...
                ',pSwap_V_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '/6),pSwap_N_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) '/6),pSwap_I_' num2str(CTOA(c))...
                '(' num2str(p) ')./(errTable{' num2str(n) '}.TotI_' num2str(CTOA(c))...
                '/6),misID_V_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '/6), misID_N_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) '/6), misID_I_' num2str(CTOA(c)) '(' num2str(p) ')./(errTable{' num2str(n) '}.TotI_' num2str(CTOA(c)) '/6)];'])
        end
        eval(['exo_ctoa = [exo_ctoa;subjId,cueType,' num2str(CTOA(c)) ',' num2str((c)) ',' num2str(p) ', cueBen_' num2str(CTOA(c)) ', cueEff_' num2str(CTOA(c)) ',cueCst_' num2str(CTOA(c)) ...
            ',sum(pSwap_V_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '),sum(pSwap_N_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) '),sum(pSwap_I_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotI_' num2str(CTOA(c))...
            '),sum(misID_V_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotV_' num2str(CTOA(c)) '),sum(misID_N_' num2str(CTOA(c)) ')./(errTable{' num2str(n) '}.TotN_' num2str(CTOA(c)) '),sum(misID_I_' num2str(CTOA(c)) ...
            ')./(errTable{' num2str(n) '}.TotI_' num2str(CTOA(c)) '),perf_Valid_' num2str(CTOA(c)) ',perf_Neutl_' num2str(CTOA(c)) ',perf_InVal_' num2str(CTOA(c)) ',AUC_pSwap_V_' num2str(CTOA(c)) ',AUC_pSwap_N_' num2str(CTOA(c)) ',AUC_pSwap_I_' num2str(CTOA(c))...
            ',AUC_misID_V_' num2str(CTOA(c)) ',AUC_misID_N_' num2str(CTOA(c)) ',AUC_misID_I_' num2str(CTOA(c)) ',tot_N_' num2str(CTOA(c)) ',tot_V_' num2str(CTOA(c)) ',num_InCx_swapsV_' num2str(CTOA(c)) ',num_InCx_misIDV_' num2str(CTOA(c)) ',num_InCx_swapsN_' num2str(CTOA(c)) ',num_InCx_misIDN_' num2str(CTOA(c)) '];'])
    end
end
exo_all=table(exo_all(:,1),exo_all(:,2),exo_all(:,3),exo_all(:,4),exo_all(:,5),exo_all(:,6),exo_all(:,7), exo_all(:,8),exo_all(:,9),exo_all(:,10),exo_all(:,11), exo_all(:,12),exo_all(:,13),exo_all(:,14), exo_all(:,15),exo_all(:,16),exo_all(:,17), ...
     'VariableNames',{'subID', 'cueType','CTOAs','CTOA_nom','position','cueBenefit','cueEffect','cueCst','dpVal','dpNeu','dpInV','pSwaps_V','pSwaps_N','pSwaps_I','misID_V','misID_N','misID_I'});
exo_ctoa=table(exo_ctoa(:,1),exo_ctoa(:,2),exo_ctoa(:,3),exo_ctoa(:,4),exo_ctoa(:,5),exo_ctoa(:,6),exo_ctoa(:,7), exo_ctoa(:,8),exo_ctoa(:,9),exo_ctoa(:,10),exo_ctoa(:,11), exo_ctoa(:,12), ...
                exo_ctoa(:,13),exo_ctoa(:,14), exo_ctoa(:,15), exo_ctoa(:,16), exo_ctoa(:,17), exo_ctoa(:,18), exo_ctoa(:,19), exo_ctoa(:,20), exo_ctoa(:,21), exo_ctoa(:,22), exo_ctoa(:,23),exo_ctoa(:,24),exo_ctoa(:,25),exo_ctoa(:,26),exo_ctoa(:,27),exo_ctoa(:,28),exo_ctoa(:,29),...
     'VariableNames',{'subID', 'cueType','CTOAs','CTOA_nom','position','cueBenAvg','cueEffAvg','cueCstAvg','pSwaps_V','pSwaps_N','pSwaps_I','misID_V','misID_N','misID_I','perf_Valid','perf_Neutl','perf_InVal','AUC_pSwap_V','AUC_pSwap_N','AUC_pSwap_I','AUC_misID_V','AUC_misID_N','AUC_misID_I','TotN','TotV','num_InCx_swapsV', 'num_InCx_misIDV','num_InCx_swapsN', 'num_InCx_misIDN'});

%% 
endoAll_colMissing=setdiff(exo_all.Properties.VariableNames, endo_all.Properties.VariableNames);
endo_all = [endo_all array2table(nan(height(endo_all), numel(endoAll_colMissing)), 'VariableNames', endoAll_colMissing)];

endo_colMissing=setdiff(exo_ctoa.Properties.VariableNames, endo_ctoa.Properties.VariableNames);
endo_ctoa = [endo_ctoa array2table(nan(height(endo_ctoa), numel(endo_colMissing)), 'VariableNames', endo_colMissing)];

data4pos = [exo_all; endo_all];
Data4pos = data4pos;
% Data4pos = [data4pos; exo_On_all];
% Data4pos = [Data4pos; exo_On_all_retest];
% Data4pos.cueType = categorical(Data4pos.cueType, [0 1 3],{'exo' 'endo' 'exoOn'});
Data4pos.cueType = categorical(Data4pos.cueType, [0 1],{'exo' 'endo'});
Data4pos.CTOAs = categorical(Data4pos.CTOAs);
Data4pos.position = categorical(Data4pos.position);

data4lme = [exo_ctoa; endo_ctoa];
Data4lme = data4lme;
% Data4lme = [data4lme; exo_On_ctoa];
% Data4lme.cueType = categorical(Data4lme.cueType, [0 1 3],{'exo' 'endo' 'exoOn'});
Data4lme.cueType = categorical(Data4lme.cueType, [0 1],{'exo' 'endo'});
Data4lme.CTOAs = categorical(Data4lme.CTOAs);

data4lme.cueType = categorical(data4lme.cueType, [0 1],{'exo' 'endo' });
data4lme.CTOAs = categorical(data4lme.CTOAs);
exo_only = data4lme(data4lme.cueType=='exo',:);
exo_only.CTOAs = removecats(exo_only.CTOAs);
endo_only = data4lme(data4lme.cueType=='endo',:);
endo_only.CTOAs = removecats(endo_only.CTOAs);

