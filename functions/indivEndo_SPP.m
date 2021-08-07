function [endo] = indivEndo_SPP(cueType, endo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Individual data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the number of blocks in the session 
thisBlock= endo.thisBlock;
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

endo. totalFixationBreaks = sum(countFixationBreaks);
% endo=struct('totalFixationBreaks',(sum(countFixationBreaks)));

figure(1);
histogram(countFixationBreaks,'Normalization','probability')

% call the gathered alldata - allBlocks
endo.allBlocks     = alldata;

% Parse the valid, neutral and invalid conditions
endo.NeutralTrials = endo.allBlocks(endo.allBlocks.cueValidity==0,:);
endo.ValidTrials   = endo.allBlocks(endo.allBlocks.cueValidity==1,:);

endo.CxNeutTrials    = endo.NeutralTrials(endo.NeutralTrials.respCorrect==1,:);
endo.InCxNeutTrials  = endo.NeutralTrials(endo.NeutralTrials.respCorrect==0,:);

endo.CxValidTrials   = endo.ValidTrials(endo.ValidTrials.respCorrect==1,:);
endo.InCxValidTrials = endo.ValidTrials(endo.ValidTrials.respCorrect==0,:);

endo.AccuracyValidtrials     =  (nansum(endo.ValidTrials.respCorrect)/(size(endo.CxValidTrials,1)+size(endo.InCxValidTrials,1)))*100;
if endo.AccuracyValidtrials  == 0
    endo.AccuracyValidtrials = ((1/(2*(size(endo.CxValidTrials,1)+size(endo.InCxValidTrials,1)))))*100; %% CHECK!!! 
elseif endo.AccuracyValidtrials ==100
    endo.AccuracyValidtrials = (1-(1/(2*(size(endo.CxValidTrials,1)+size(endo.InCxValidTrials,1)))))*100;
end
endo.dprime_ValidTrials           = PAL_SDT_MAFC_PCtoDP(endo.AccuracyValidtrials/100, 12);
endo.AccuracyNeutraltrials        = (nansum(endo.NeutralTrials.respCorrect)/(size(endo.CxNeutTrials,1)+size(endo.InCxNeutTrials,1)))*100;
if endo.AccuracyNeutraltrials == 0
    endo.AccuracyNeutraltrials = ((1/(2*(size(endo.CxValidTrials,1)+size(endo.InCxValidTrials,1)))))*100;
elseif endo.AccuracyNeutraltrials ==100
    endo.AccuracyNeutraltrials = (1-(1/(2*(size(endo.CxValidTrials,1)+size(endo.InCxValidTrials,1)))))*100;
end
endo.dprime_NeutralTrials    =PAL_SDT_MAFC_PCtoDP(endo.AccuracyNeutraltrials/100, 12);
%%Cue effects
endo.OverallCueEffect        =(endo.AccuracyValidtrials - endo.AccuracyNeutraltrials);
endo.CueEff_dprime           =(endo.dprime_ValidTrials - endo.dprime_NeutralTrials);
%% get position profiles - included dprime calculated using Palamedes
for pos=1:length(unique(endo.ValidTrials.postCueLocation))
    eval(['endo.pos' mat2str(pos) '_validTrials    = endo.ValidTrials(endo.ValidTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['endo.Acc_pos' mat2str(pos) '_Valid      = (nansum(endo.pos' mat2str(pos) '_validTrials.respCorrect)/size(endo.pos' mat2str(pos) '_validTrials,1))*100;'])
    %     eval(['dprime_' mat2str(pos) '_Valid      = 2*norminv(Acc_pos' mat2str(pos) '_Valid)/100;'])
    if eval(['endo.Acc_pos' mat2str(pos) '_Valid  == 0'])
    eval(['endo.Acc_pos' mat2str(pos) '_Valid  = ((1/(2*(size(endo.pos' mat2str(pos) '_validTrials,1)))))*100;']);
    elseif eval(['endo.Acc_pos' mat2str(pos) '_Valid ==100'])
        eval(['endo.Acc_pos' mat2str(pos) '_Valid = (1-(1/(2*(size(endo.pos' mat2str(pos) '_validTrials,1)))))*100;']);
    end
    eval(['endo.dprime_' mat2str(pos) '_Valid      = PAL_SDT_MAFC_PCtoDP((endo.Acc_pos' mat2str(pos) '_Valid/100),12);'])
    
    eval(['endo.pos' mat2str(pos) '_NeutralTrials  = endo.NeutralTrials(endo.NeutralTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['endo.Acc_pos' mat2str(pos) '_Neutral    = (nansum(endo.pos' mat2str(pos) '_NeutralTrials.respCorrect)/size(endo.pos' mat2str(pos) '_NeutralTrials,1))*100;'])
    if eval(['endo.Acc_pos' mat2str(pos) '_Neutral  == 0'])
    eval(['endo.Acc_pos' mat2str(pos) '_Neutral = ((1/(2*(size(endo.pos' mat2str(pos)  '_NeutralTrials,1))))*100;']);
    elseif eval(['endo.Acc_pos' mat2str(pos) '_Neutral ==100'])
        eval(['endo.Acc_pos' mat2str(pos) '_Neutral = (1-(1/(2*(size(endo.pos' mat2str(pos)  '_NeutralTrials,1)))))*100;']);
    end
    eval(['endo.dprime_' mat2str(pos) '_Neutral    = PAL_SDT_MAFC_PCtoDP((endo.Acc_pos' mat2str(pos) '_Neutral/100),12);'])
    
end

%% Sort by SOAs
if cueType==1
    endo.ctoa = round(unique(endo.ValidTrials.cueTargetISI)*1000 +100,3);
elseif cueType==2
    exo.ctoa = round(unique(exo.ValidTrials.cueTargetISI)*1000 +50,3);
end
format short;
CTOA_abs = unique(endo.ValidTrials.cueTargetISI);
mAFC = 12;

for ii= 1:length(endo.ctoa)
    eval(['endo.ValidTrials_' num2str(endo.ctoa(ii)) '= endo.ValidTrials(endo.ValidTrials.cueTargetISI==' 'CTOA_abs(ii)' ',:);'])
    eval(['endo.NeutralTrials_' num2str(endo.ctoa(ii)) ' = endo.NeutralTrials(endo.NeutralTrials.cueTargetISI==' 'CTOA_abs(ii)' ',:);'])
    eval(['endo.AccuracyValidTrial_' num2str(endo.ctoa(ii)) '= (nansum(endo.ValidTrials_' num2str(endo.ctoa(ii)) '.respCorrect)/size(endo.ValidTrials_' num2str(endo.ctoa(ii)) ',1))*100;'])
     if eval(['endo.AccuracyValidTrial_' num2str(endo.ctoa(ii)) '== 0'])
        eval(['endo. AccuracyValidTrial_' num2str(endo.ctoa(ii)) '= (1+(1/2*size(endo.ValidTrials_' num2str(endo.ctoa(ii)) ',1)))*100;'])
     elseif eval(['endo.AccuracyValidTrial_' num2str(endo.ctoa(ii)) '== 100'])
        eval(['endo.AccuracyValidTrial_' num2str(endo.ctoa(ii)) '= (1-(1/(2*size(endo.ValidTrials_' num2str(endo.ctoa(ii)) ',1))))*100;'])
     end
     
     eval(['endo.dprime_ValidTrial_' num2str(endo.ctoa(ii))   '= PAL_SDT_MAFC_PCtoDP((endo.AccuracyValidTrial_' num2str(endo.ctoa(ii)) '/100),mAFC);'])
     
     eval(['endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii))   '= (nansum(endo.NeutralTrials_' num2str(endo.ctoa(ii)) '.respCorrect)/size(endo.NeutralTrials_' num2str(endo.ctoa(ii)) ',1))*100;']) 
     if eval(['endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii))   '==0'])
        eval(['endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii))   '= 0+(1+(1/(2*/size(endo.NeutralTrials_' num2str(endo.ctoa(ii)) ',1))));'])
     elseif eval(['endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii))   '==100'])
         eval(['endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii))   '= 100-(1-(1/(2*/size(NeutralTrials_' num2str(endo.ctoa(ii)) ',1))));'])
     end
     eval(['endo.dprime_NeutralTrial_' num2str(endo.ctoa(ii)) '= PAL_SDT_MAFC_PCtoDP((endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii)) '/100),mAFC);'])
    %% Get Position profiles
    for pos=1:length(unique(endo.ValidTrials.postCueLocation))
        eval(['endo.pos' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '= endo.ValidTrials_' num2str(endo.ctoa(ii)) '(endo.ValidTrials_' num2str(endo.ctoa(ii)) '.postCueLocation ==' num2str(pos) ',:);'])
        eval(['endo.acc' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '= nansum(endo.pos' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '.respCorrect)/size(endo.pos' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) ',1)*100;'])
        if eval(['endo.acc' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '==0'])
           eval(['endo.acc' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '=0+(1+(1/(2*(size(endo.pos' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) ',1)))));'])
        elseif eval(['endo.acc' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '==100'])
            eval(['endo.acc' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '=100-(1-(1/(2*(size(endo.pos' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) ',1)))));'])
        end 
        eval(['endo.dp' num2str(pos) '_Val_' num2str(endo.ctoa(ii))  '= PAL_SDT_MAFC_PCtoDP(endo.acc' num2str(pos) '_Val_' num2str(endo.ctoa(ii)) '/100,mAFC);'])   
        
         eval(['endo.pos' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '= endo.NeutralTrials_' num2str(endo.ctoa(ii)) '(endo.NeutralTrials_' num2str(endo.ctoa(ii)) '.postCueLocation ==' num2str(pos) ',:);'])
        eval(['endo.acc' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '= nansum(endo.pos' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '.respCorrect)/size(endo.pos' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) ',1)*100;'])
        if eval(['endo.acc' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '==0'])
           eval(['endo.acc' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '=0+(1+(1/(2*(size(endo.pos' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) ',1)))));'])
        elseif eval(['endo.acc' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '==100'])
            eval(['endo.acc' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '=100-(1-(1/(2*(size(endo. pos' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) ',1)))));'])
        end 
        eval(['endo.dp' num2str(pos) '_Neu_' num2str(endo.ctoa(ii))  '= PAL_SDT_MAFC_PCtoDP(endo.acc' num2str(pos) '_Neu_' num2str(endo.ctoa(ii)) '/100,mAFC);'])   
    end   
     % Cue Effect = Accuracy on Valid trials - Accuracy on invlaid trials
        eval(['endo.CueEffect_' num2str(endo.ctoa(ii)) ' = endo.AccuracyValidTrial_' num2str(endo.ctoa(ii)) '- endo.AccuracyNeuTrial_' num2str(endo.ctoa(ii)) ';']);
    eval(['endo.dpriCueEff_' num2str(endo.ctoa(ii)) ' = endo.dprime_ValidTrial_' num2str(endo.ctoa(ii)) '- endo.dprime_NeutralTrial_' num2str(endo.ctoa(ii)) ';']);
end


