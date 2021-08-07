function [reliability] = splitHalf_reliability_inLab(cueType,endo, exo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Individual data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the number of blocks in the session 
if cueType==1
    thisBlock= endo.thisBlock;
    cueDuratn = 100;
%     thisSubj= extractBefore(allsubj(n).name,'_Endo');
elseif cueType==2 
    thisBlock= exo.thisBlock;
    cueDuratn = 50;
%     thisSubj= extractBefore(allsubj(n).name,'_Exo');
end
% sprintf('In this session there are: %d Blocks', length(thisBlock))

% Load each block 
for blocks=1:length(thisBlock)
    thisSession(blocks).blocks = load(thisBlock(blocks).name);
end

% get rid of trials with fixation breaks and get a count of fixation break
% in each block
alldata=[]; countFixationBreaks=[];
for bloc=1:length(thisBlock)
    IdxToFixationBreakTrials  = length(find(thisSession(bloc).blocks.task.trials.fixBreak==1));
    countFixationBreaks =[countFixationBreaks;(IdxToFixationBreakTrials)];
    IdxToFixationBreakTrials  = thisSession(bloc).blocks.task.trials.fixBreak==1;
    thisSession(bloc).blocks.task.trials(IdxToFixationBreakTrials,:)=[];
    % eval(['alldata_' str2mat(subjs{sj}) '=[alldata;thisSession(' num2str(bloc) ').blocks.task.trials];'])
    eval(['alldata =[alldata;thisSession(' num2str(bloc) ').blocks.task.trials];'])
end

% call the gathered alldata - allBlocks
reliability.allBlocks     = alldata;

% Parse the valid, neutral and invalid conditions
reliability.NeutralTrials = reliability.allBlocks(reliability.allBlocks.cueValidity==0,:);
reliability.ValidTrials   = reliability.allBlocks(reliability.allBlocks.cueValidity==1,:);

format long 
cTISI=unique(reliability.allBlocks.cueTargetISI);
ctoa=(cTISI*1000)+cueDuratn;
    for n=1:length(cTISI)
    eval(['reliability.NeutralTrials_' num2str(ctoa(n)) '= reliability.NeutralTrials(reliability.NeutralTrials.cueTargetISI==cTISI(n), :);'])
    eval(['reliability.ValidTrials_' num2str(ctoa(n)) '= reliability.ValidTrials(reliability.ValidTrials.cueTargetISI==cTISI(n), :);'])
    end

if cueType==2
    reliability.InvalidTrials = reliability.allBlocks(reliability.allBlocks.cueValidity==-1,:);
    for n=1:length(cTISI)
    eval(['reliability.InvalidTrials_' num2str(ctoa(n)) '= reliability.InvalidTrials(reliability.InvalidTrials.cueTargetISI==' num2str(cTISI(n)) ', :);'])
    end
end
%Get odd and even trials
    reliability.ValidTrials_odd    = reliability.ValidTrials(1:2:end,:);
    reliability.ValidTrials_even   = reliability.ValidTrials(2:2:end,:);
    for t=1:length(cTISI)
        eval(['reliability.ValidTrials_' num2str(ctoa(t)) '_odd    = reliability.ValidTrials_' num2str(ctoa(t)) '(1:2:end,:);'])
        eval(['reliability.ValidTrials_' num2str(ctoa(t)) '_even   = reliability.ValidTrials_' num2str(ctoa(t)) '(2:2:end,:);'])
    end
    reliability.NeutralTrials_odd  = reliability.NeutralTrials(1:2:end,:);
    reliability.NeutralTrials_even = reliability.NeutralTrials(2:2:end,:);
    for t=1:length(cTISI)
        eval(['reliability.NeutralTrials_' num2str(ctoa(t)) '_odd    = reliability.NeutralTrials_' num2str(ctoa(t)) '(1:2:end,:);'])
        eval(['reliability.NeutralTrials_' num2str(ctoa(t)) '_even   = reliability.NeutralTrials_' num2str(ctoa(t)) '(2:2:end,:);'])
    end
    if cueType==2
    reliability.InvalidTrials_odd  = reliability.InvalidTrials(1:2:end,:);
    reliability.InvalidTrials_even = reliability.InvalidTrials(2:2:end,:);
    for t=1:length(cTISI)
        eval(['reliability.InvalidTrials_' num2str(ctoa(t)) '_odd    = reliability.InvalidTrials_' num2str(ctoa(t)) '(1:2:end,:);'])
        eval(['reliability.InvalidTrials_' num2str(ctoa(t)) '_even   = reliability.InvalidTrials_' num2str(ctoa(t)) '(2:2:end,:);'])
    end
    end
%%-----Valid trials
reliability.AccValidTrials_odd     =  (nansum(reliability.ValidTrials_odd.respCorrect)/(size(reliability.ValidTrials_odd,1)))*100;
reliability.AccValidTrials_even    =  (nansum(reliability.ValidTrials_even.respCorrect)/(size(reliability.ValidTrials_even,1)))*100;
    for t=1:length(cTISI)
        eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_odd     =  (nansum(reliability.ValidTrials_' num2str(ctoa(t)) '_odd.respCorrect)/(size(reliability.ValidTrials_' num2str(ctoa(t)) '_odd,1)))*100;'])
        eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_even     =  (nansum(reliability.ValidTrials_' num2str(ctoa(t)) '_even.respCorrect)/(size(reliability.ValidTrials_' num2str(ctoa(t)) '_even,1)))*100;'])
    end

if reliability.AccValidTrials_odd  == 0
    reliability.AccValidTrials_odd = (1+(1/(2*(size(reliability.ValidTrials_odd,1)))))*100;
elseif reliability.AccValidTrials_odd ==100
    reliability.AccValidTrials_odd = (1-(1/(2*(size(reliability.ValidTrials_odd,1)))))*100;
end
if reliability.AccValidTrials_even  == 0
    reliability.AccValidTrials_even = (1+(1/(2*(size(reliability.ValidTrials_even,1)))))*100;
elseif reliability.AccValidTrials_even ==100
    reliability.AccValidTrials_even = (1-(1/(2*(size(reliability.ValidTrials_even,1)))))*100;
end
for t=1:length(cTISI)
    if eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_odd  == 0'])
        eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_odd = (1+(1/(2*(size(reliability.ValidTrials_' num2str(ctoa(t)) '_odd,1)))))*100;'])
    elseif eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_odd ==100'])
        eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_odd = (1-(1/(2*(size(reliability.ValidTrials_' num2str(ctoa(t)) '_odd,1)))))*100;'])
    end
    if eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_even  == 0'])
       eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_even = (1+(1/(2*(size(reliability.ValidTrials_' num2str(ctoa(t)) '_even,1)))))*100;'])
    elseif eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_even ==100'])
      eval(['reliability.AccValidTrials_' num2str(ctoa(t)) '_even = (1-(1/(2*(size(reliability.ValidTrials_' num2str(ctoa(t)) '_even,1)))))*100;'])
    end

     eval(['reliability.dprime_ValidTrials_' num2str(ctoa(t)) '_odd           = PAL_SDT_MAFC_PCtoDP(reliability.AccValidTrials_' num2str(ctoa(t)) '_odd/100, 12);'])
     eval(['reliability.dprime_ValidTrials_' num2str(ctoa(t)) '_even           = PAL_SDT_MAFC_PCtoDP(reliability.AccValidTrials_' num2str(ctoa(t)) '_even/100, 12);'])
end

reliability.dprime_ValidTrials_odd           = PAL_SDT_MAFC_PCtoDP(reliability.AccValidTrials_odd/100, 12);
reliability.dprime_ValidTrials_even           = PAL_SDT_MAFC_PCtoDP(reliability.AccValidTrials_even/100, 12);

%%-----Neutral trials
reliability.AccNeutraltrials_odd        = (nansum(reliability.NeutralTrials_odd.respCorrect)/(size(reliability.NeutralTrials_odd,1)))*100;
reliability.AccNeutraltrials_even        = (nansum(reliability.NeutralTrials_even.respCorrect)/(size(reliability.NeutralTrials_even,1)))*100;

    for t=1:length(cTISI)
        eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_odd     =  (nansum(reliability.NeutralTrials_' num2str(ctoa(t)) '_odd.respCorrect)/(size(reliability.NeutralTrials_' num2str(ctoa(t)) '_odd,1)))*100;'])
        eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_even     =  (nansum(reliability.NeutralTrials_' num2str(ctoa(t)) '_even.respCorrect)/(size(reliability.NeutralTrials_' num2str(ctoa(t)) '_even,1)))*100;'])
    end

if reliability.AccNeutraltrials_odd == 0
    reliability.AccNeutraltrials_odd = (1+(1/(2*(size(reliability.NeutralTrials_odd,1)))))*100;
elseif reliability.AccNeutraltrials_odd ==100
    reliability.AccNeutraltrials_odd = (1-(1/(2*(size(reliability.NeutralTrials_odd,1)))))*100;
end
if reliability.AccNeutraltrials_even == 0
    reliability.AccNeutraltrials_even = (1+(1/(2*(size(reliability.NeutralTrials_even,1)))))*100;
elseif reliability.AccNeutraltrials_even ==100
    reliability.AccNeutraltrials_even = (1-(1/(2*(size(reliability.NeutralTrials_even,1)))))*100;
end
for t=1:length(cTISI)
    if eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_odd  == 0'])
        eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_odd = (1+(1/(2*(size(reliability.NeutralTrials_' num2str(ctoa(t)) '_odd,1)))))*100;'])
    elseif eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_odd ==100'])
        eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_odd = (1-(1/(2*(size(reliability.NeutralTrials_' num2str(ctoa(t)) '_odd,1)))))*100;'])
    end
    if eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_even  == 0'])
       eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_even = (1+(1/(2*(size(reliability.NeutralTrials_' num2str(ctoa(t)) '_even,1)))))*100;'])
    elseif eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_even ==100'])
      eval(['reliability.AccNeutraltrials_' num2str(ctoa(t)) '_even = (1-(1/(2*(size(reliability.NeutralTrials_' num2str(ctoa(t)) '_even,1)))))*100;'])
    end
end

for t =1:length(cTISI)
     eval(['reliability.dprime_NeutralTrials_' num2str(ctoa(t)) '_odd           = PAL_SDT_MAFC_PCtoDP(reliability.AccNeutraltrials_' num2str(ctoa(t)) '_odd/100, 12);'])
     eval(['reliability.dprime_NeutralTrials_' num2str(ctoa(t)) '_even           = PAL_SDT_MAFC_PCtoDP(reliability.AccNeutraltrials_' num2str(ctoa(t)) '_even/100, 12);'])
end

reliability.dprime_NeutralTrials_odd    =PAL_SDT_MAFC_PCtoDP(reliability.AccNeutraltrials_odd/100, 12);
reliability.dprime_NeutralTrials_even    =PAL_SDT_MAFC_PCtoDP(reliability.AccNeutraltrials_even/100, 12);

% Compute cue Ben
reliability.cueBen_odd = reliability.dprime_ValidTrials_odd - reliability.dprime_NeutralTrials_odd;
reliability.cueBen_even = reliability.dprime_ValidTrials_even - reliability.dprime_NeutralTrials_even;

for t=1:length(cTISI)
    eval(['reliability.cueBen_' num2str(ctoa(t)) '_odd = reliability.dprime_ValidTrials_' num2str(ctoa(t)) '_odd - reliability.dprime_NeutralTrials_' num2str(ctoa(t)) '_odd;'])
    eval(['reliability.cueBen_' num2str(ctoa(t)) '_even = reliability.dprime_ValidTrials_' num2str(ctoa(t)) '_even - reliability.dprime_NeutralTrials_' num2str(ctoa(t)) '_even;'])
end
%%-----InValid trials
if cueType==2    
    reliability.AccInVtrials_odd = (nansum(reliability.InvalidTrials_odd.respCorrect)/(size(reliability.InvalidTrials_odd,1)))*100;
    reliability.AccInVtrials_even = (nansum(reliability.InvalidTrials_even.respCorrect)/(size(reliability.InvalidTrials_even,1)))*100;
    for t=1:length(cTISI)
        eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_odd     =  (nansum(reliability.InvalidTrials_' num2str(ctoa(t)) '_odd.respCorrect)/(size(reliability.InvalidTrials_' num2str(ctoa(t)) '_odd,1)))*100;'])
        eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_even     =  (nansum(reliability.InvalidTrials_' num2str(ctoa(t)) '_even.respCorrect)/(size(reliability.InvalidTrials_' num2str(ctoa(t)) '_even,1)))*100;'])
    end   
    
    if reliability.AccInVtrials_odd ==0
        reliability.AccInVtrials_odd = 1+(1/(2*(size(reliability.InvalidTrials_odd,1))))*100;
    elseif reliability.AccInVtrials_odd ==100
        reliability.AccInVtrials_odd = 1-(1/(2*(size(reliability.InvalidTrials_odd,1))))*100;
    end
    if reliability.AccInVtrials_even ==0
        reliability.AccInVtrials_even = 1+(1/(2*(size(reliability.InvalidTrials_even,1))))*100;
    elseif reliability.AccInVtrials_even ==100
        reliability.AccInVtrials_even = 1-(1/(2*(size(reliability.InvalidTrials_even,1))))*100;
    end
    
    for t=1:length(cTISI)
        if eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_odd  == 0'])
            eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_odd = (1+(1/(2*(size(reliability.InvalidTrials_' num2str(ctoa(t)) '_odd,1)))))*100;'])
        elseif eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_odd ==100'])
            eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_odd = (1-(1/(2*(size(reliability.InvalidTrials_' num2str(ctoa(t)) '_odd,1)))))*100;'])
        end
        if eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_even  == 0'])
            eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_even = (1+(1/(2*(size(reliability.InvalidTrials_' num2str(ctoa(t)) '_even,1)))))*100;'])
        elseif eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_even ==100'])
            eval(['reliability.AccInVtrials_' num2str(ctoa(t)) '_even = (1-(1/(2*(size(reliability.InvalidTrials_' num2str(ctoa(t)) '_even,1)))))*100;'])
        end
    end
    
    reliability.dprime_InVtrials_odd  = PAL_SDT_MAFC_PCtoDP(reliability.AccInVtrials_odd/100, 12);
    reliability.dprime_InVtrials_even  = PAL_SDT_MAFC_PCtoDP(reliability.AccInVtrials_even/100, 12);
    for t =1:length(cTISI)
     eval(['reliability.dprime_InVtrials_' num2str(ctoa(t)) '_odd           = PAL_SDT_MAFC_PCtoDP(reliability.AccInVtrials_' num2str(ctoa(t)) '_odd/100, 12);'])
     eval(['reliability.dprime_InVtrials_' num2str(ctoa(t)) '_even           = PAL_SDT_MAFC_PCtoDP(reliability.AccInVtrials_' num2str(ctoa(t)) '_even/100, 12);'])
    end
    %Compute CueEff
    reliability.cueEff_odd = reliability.dprime_ValidTrials_odd - reliability.dprime_InVtrials_odd;
    reliability.cueEff_even = reliability.dprime_ValidTrials_even - reliability.dprime_InVtrials_even;   
    
    for t=1:length(cTISI)
        eval(['reliability.cueEff_' num2str(ctoa(t)) '_odd = reliability.dprime_ValidTrials_' num2str(ctoa(t)) '_odd - reliability.dprime_InVtrials_' num2str(ctoa(t)) '_odd;'])
        eval(['reliability.cueEff_' num2str(ctoa(t)) '_even = reliability.dprime_ValidTrials_' num2str(ctoa(t)) '_even - reliability.dprime_InVtrials_' num2str(ctoa(t)) '_even;'])
    end
    
    reliability.cueCst_odd = reliability.dprime_NeutralTrials_odd - reliability.dprime_InVtrials_odd;
    reliability.cueCst_even = reliability.dprime_NeutralTrials_even - reliability.dprime_InVtrials_even;
    for t=1:length(cTISI)
        eval(['reliability.cueCst_' num2str(ctoa(t)) '_odd = reliability.dprime_NeutralTrials_' num2str(ctoa(t)) '_odd - reliability.dprime_InVtrials_' num2str(ctoa(t)) '_odd;'])
        eval(['reliability.cueCst_' num2str(ctoa(t)) '_even = reliability.dprime_NeutralTrials_' num2str(ctoa(t)) '_even - reliability.dprime_InVtrials_' num2str(ctoa(t)) '_even;'])
    end
            
end

%% Get the Spearman Brown correlation 
% reliability.rho= corr(reliability.dprime_NeutralTrials_odd,reliability.dprime_NeutralTrials_even);
% reliability.spearman_BrownN= 2*reliability.rho/(1+reliability.rho);