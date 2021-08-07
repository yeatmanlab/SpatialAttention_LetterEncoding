function [exo] = indivExo_SPP(cueType, exo)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Individual data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get the number of blocks in the session 
thisBlock= exo.thisBlock;
sprintf('In this session there are: %d Blocks', length(thisBlock))

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
exo. totalFixationBreaks = sum(countFixationBreaks);
figure(1);
histogram(countFixationBreaks,'Normalization','probability')

% call the gathered alldata - allBlocks
exo.allBlocks     = alldata;

% Parse the valid, neutral and invalid conditions
exo.NeutralTrials = exo.allBlocks(exo.allBlocks.cueValidity==0,:);
exo.ValidTrials   = exo.allBlocks(exo.allBlocks.cueValidity==1,:);

exo.CxNeutTrials    = exo.NeutralTrials(exo.NeutralTrials.respCorrect==1,:);
exo.InCxNeutTrials  = exo.NeutralTrials(exo.NeutralTrials.respCorrect==0,:);

exo.CxValidTrials   = exo.ValidTrials(exo.ValidTrials.respCorrect==1,:);
exo.InCxValidTrials = exo.ValidTrials(exo.ValidTrials.respCorrect==0,:);

exo.AccuracyValidtrials     =  (nansum(exo.ValidTrials.respCorrect)/(size(exo.CxValidTrials,1)+size(exo.InCxValidTrials,1)))*100;
if exo.AccuracyValidtrials  == 0
    exo.AccuracyValidtrials = ((1/(2*(size(exo.CxValidTrials,1)+size(exo.InCxValidTrials,1)))))*100;
elseif exo.AccuracyValidtrials ==100
    exo.AccuracyValidtrials = (1-(1/(2*(size(exo.CxValidTrials,1)+size(exo.InCxValidTrials,1)))))*100;
end
exo.dprime_ValidTrials           = PAL_SDT_MAFC_PCtoDP(exo.AccuracyValidtrials/100, 12);

exo.AccuracyNeutraltrials        = (nansum(exo.NeutralTrials.respCorrect)/(size(exo.CxNeutTrials,1)+size(exo.InCxNeutTrials,1)))*100;
if exo.AccuracyNeutraltrials == 0
    exo.AccuracyNeutraltrials = ((1/(2*(size(exo.CxValidTrials,1)+size(exo.InCxValidTrials,1)))))*100;
elseif exo.AccuracyNeutraltrials ==100
    exo.AccuracyNeutraltrials = (1-(1/(2*(size(exo.CxValidTrials,1)+size(exo.InCxValidTrials,1)))))*100;
end
exo.dprime_NeutralTrials    =PAL_SDT_MAFC_PCtoDP(exo.AccuracyNeutraltrials/100, 12);

%Overall cue effects
exo.OverallCueEffect        =(exo.AccuracyValidtrials - exo.AccuracyNeutraltrials);
exo.OverallCueEff_dp        =(exo.dprime_ValidTrials - exo.dprime_NeutralTrials);

% EXO paradigm

    exo.InvalidTrials = exo.allBlocks(exo.allBlocks.cueValidity==-1,:);
    exo.CxInVTrials=exo.InvalidTrials(exo.InvalidTrials.respCorrect==1,:);
    exo.InCxInVTrials=exo.InvalidTrials(exo.InvalidTrials.respCorrect==0,:);
    
    exo.AccuracyInVtrials = (nansum(exo.InvalidTrials.respCorrect)/(size(exo.CxInVTrials,1)+size(exo.InCxInVTrials,1)))*100;
    if exo.AccuracyInVtrials ==0
        exo.AccuracyInVtrials = 1+(1/(2*(size(exo.CxInVTrials,1)+size(exo.InCxInVTrials,1))))*100;
    elseif exo.AccuracyInVtrials ==100
        exo.AccuracyInVtrials = 1-(1/(2*(size(exo.CxInVTrials,1)+size(exo.InCxInVTrials,1))))*100;
    end
        
    exo.dprime_InVtrials  = PAL_SDT_MAFC_PCtoDP(exo.AccuracyInVtrials/100, 12);

% CueEffect for Exo
exo.cueEff_V_InV            = exo.AccuracyValidtrials - exo.AccuracyInVtrials;
exo.overall_cueCost         = exo.AccuracyNeutraltrials-exo.AccuracyInVtrials;
exo.cueEff_V_InV_dp            = exo.dprime_ValidTrials - exo.dprime_InVtrials;
exo.overall_cueCost_dp         = exo.dprime_NeutralTrials-exo.dprime_InVtrials;

%% get Overall position profiles - included dprime calculated using Palamedes
for pos=1:length(unique(exo.ValidTrials.postCueLocation))
    eval(['exo.pos' mat2str(pos) '_validTrials    = exo.ValidTrials(exo.ValidTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['exo.Acc_pos' mat2str(pos) '_Valid      = (nansum(exo.pos' mat2str(pos) '_validTrials.respCorrect)/size(exo.pos' mat2str(pos) '_validTrials,1))*100;'])
    %     eval(['dprime_' mat2str(pos) '_Valid      = 2*norminv(Acc_pos' mat2str(pos) '_Valid)/100;'])
        if eval(['exo.Acc_pos' mat2str(pos) '_Valid == 0'])
        eval(['exo.Acc_pos' mat2str(pos) '_Valid  = ((1/2*size(exo.pos' mat2str(pos) '_validTrials,1)))*100;'])
        elseif eval(['exo.Acc_pos' mat2str(pos) '_Valid == 100;'])
        eval(['exo.Acc_pos' mat2str(pos) '_Valid  = (1-(1/(2*size(exo.pos' mat2str(pos) '_validTrials,1))))*100;'])
        end
    eval(['exo.dprime_' mat2str(pos) '_Valid      = PAL_SDT_MAFC_PCtoDP((exo.Acc_pos' mat2str(pos) '_Valid/100),12);'])
    
    eval(['exo.pos' mat2str(pos) '_NeutralTrials  = exo.NeutralTrials(exo.NeutralTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['exo.Acc_pos' mat2str(pos) '_Neutral    = (nansum(exo.pos' mat2str(pos) '_NeutralTrials.respCorrect)/size(exo.pos' mat2str(pos) '_NeutralTrials,1))*100;'])
        if eval(['exo.Acc_pos' mat2str(pos) '_Neutral == 0'])
        eval(['exo.Acc_pos' mat2str(pos) '_Neutral  = ((1/2*size(exo.pos' mat2str(pos) '_NeutralTrials,1)))*100;'])
        elseif eval(['exo.Acc_pos' mat2str(pos) '_Neutral == 100;'])
        eval(['exo.Acc_pos' mat2str(pos) '_Neutral  = (1-(1/(2*size(exo.pos' mat2str(pos) '_NeutralTrials,1))))*100;'])
        end
    eval(['exo.dprime_' mat2str(pos) '_Neutral    = PAL_SDT_MAFC_PCtoDP((exo.Acc_pos' mat2str(pos) '_Neutral/100),12);'])
    
    eval(['exo.pos' mat2str(pos) '_InvalTrials    = exo.InvalidTrials(exo.InvalidTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['exo.Acc_pos' mat2str(pos) '_InVal      = (nansum(exo.pos' mat2str(pos) '_InvalTrials.respCorrect)/size(exo.pos' mat2str(pos) '_InvalTrials,1))*100;'])
        if eval(['exo.Acc_pos' mat2str(pos) '_InVal == 0'])
        eval(['exo.Acc_pos' mat2str(pos) '_InVal  = (1/(2*size(exo.pos' mat2str(pos) '_InvalTrials,1)))*100;'])
        elseif eval(['exo.Acc_pos' mat2str(pos) '_InVal == 100;'])
        eval(['exo.Acc_pos' mat2str(pos) '_InVal  = (1-(1/(2*size(exo.pos' mat2str(pos) '_InvalTrials,1))))*100;'])
        end
    eval(['exo.dprime_' mat2str(pos) '_InVal      = PAL_SDT_MAFC_PCtoDP((exo.Acc_pos' mat2str(pos) '_InVal/100),12);'])
    
end

%% Sort by SOAs
exo.ctoa = round(unique(exo.ValidTrials.cueTargetISI)*1000 +50,3);
format short;
CTOA_abs = unique(exo.ValidTrials.cueTargetISI);
mAFC = 12;

for ii= 1:length(exo.ctoa)
    eval(['exo.ValidTrials_' num2str(exo.ctoa(ii)) '= exo.ValidTrials(exo.ValidTrials.cueTargetISI==' 'CTOA_abs(ii)' ',:);'])
    eval(['exo.NeutralTrials_' num2str(exo.ctoa(ii)) ' = exo.NeutralTrials(exo.NeutralTrials.cueTargetISI==' 'CTOA_abs(ii)' ',:);'])
    eval(['exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '= (nansum(exo.ValidTrials_' num2str(exo.ctoa(ii)) '.respCorrect)/size(exo.ValidTrials_' num2str(exo.ctoa(ii)) ',1))*100;'])
     if eval(['exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '== 0'])
        eval(['exo. AccuracyValidTrial_' num2str(exo.ctoa(ii)) '= (1+(1/2*size(exo.ValidTrials_' num2str(exo.ctoa(ii)) ',1)))*100;'])
     elseif eval(['exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '== 100;'])
        eval(['exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '= (1-(1/(2*size(exo.ValidTrials_' num2str(exo.ctoa(ii)) ',1))))*100;'])
     end
     
     eval(['exo.dprime_ValidTrial_' num2str(exo.ctoa(ii))   '= PAL_SDT_MAFC_PCtoDP((exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '/100),mAFC);'])
     
     eval(['exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii))   '= (nansum(exo.NeutralTrials_' num2str(exo.ctoa(ii)) '.respCorrect)/size(exo.NeutralTrials_' num2str(exo.ctoa(ii)) ',1))*100;']) 
     if eval(['exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii))   '==0'])
        eval(['exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii))   '= (1/(2*/size(exo.NeutralTrials_' num2str(exo.ctoa(ii)) ',1)))*100;'])
     elseif eval(['exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii))   '==100'])
         eval(['exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii))   '= (1-(1/(2*/size(NeutralTrials_' num2str(exo.ctoa(ii)) ',1))))*100;'])
     end
     eval(['exo.dprime_NeutralTrial_' num2str(exo.ctoa(ii)) '= PAL_SDT_MAFC_PCtoDP((exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii)) '/100),mAFC);'])
     
       eval(['exo.InValTrials_' num2str(exo.ctoa(ii)) '= exo.InvalidTrials(exo.InvalidTrials.cueTargetISI==' 'CTOA_abs(ii)' ',:);'])
       eval(['exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) '= (nansum(exo.InValTrials_' num2str(exo.ctoa(ii)) '.respCorrect)/size(exo.InValTrials_' num2str(exo.ctoa(ii)) ',1))*100;'])
       if eval(['exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) '==0'])
          eval(['exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) '= (1/(2*size(exo.InValTrials_' num2str(exo.ctoa(ii)) ',1)))*100;'])
       elseif eval(['exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) '==100'])
            eval(['exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) '=(1-(1/(2*size(exo.InValTrials_' num2str(exo.ctoa(ii)) ',1))))*100;'])
       end
       eval(['exo.dprime_InValTrial_' num2str(exo.ctoa(ii)) '= PAL_SDT_MAFC_PCtoDP((exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) '/100),mAFC);'])
      
    %% Get Position profiles
    for pos=1:length(unique(exo.ValidTrials.postCueLocation))
        eval(['exo.pos' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '= exo.ValidTrials_' num2str(exo.ctoa(ii)) '(exo.ValidTrials_' num2str(exo.ctoa(ii)) '.postCueLocation ==' num2str(pos) ',:);'])
        eval(['exo.acc' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '= nansum(exo.pos' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '.respCorrect)/size(exo.pos' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) ',1)*100;'])
        if eval(['exo.acc' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '==0;'])
           eval(['exo.acc' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '=(1/(2*(size(exo.pos' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) ',1))))*100;'])
        elseif eval(['exo.acc' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '==100'])
            eval(['exo.acc' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '=(1-(1/(2*size(exo.pos' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) ',1))))*100;'])
        end 
        eval(['exo.dp' num2str(pos) '_Val_' num2str(exo.ctoa(ii))  '= PAL_SDT_MAFC_PCtoDP(exo.acc' num2str(pos) '_Val_' num2str(exo.ctoa(ii)) '/100,mAFC);'])   
        
         eval(['exo.pos' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '= exo.NeutralTrials_' num2str(exo.ctoa(ii)) '(exo.NeutralTrials_' num2str(exo.ctoa(ii)) '.postCueLocation ==' num2str(pos) ',:);'])
        eval(['exo.acc' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '= nansum(exo.pos' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '.respCorrect)/size(exo.pos' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) ',1)*100;'])
        if eval(['exo.acc' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '==0'])
           eval(['exo.acc' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '=(1/(2*size(exo.pos' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) ',1)))*100;'])
        elseif eval(['exo.acc' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '==100'])
            eval(['exo.acc' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '=(1-(1/(2*size(exo. pos' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) ',1))))*100;'])
        end 
        eval(['exo.dp' num2str(pos) '_Neu_' num2str(exo.ctoa(ii))  '= PAL_SDT_MAFC_PCtoDP(exo.acc' num2str(pos) '_Neu_' num2str(exo.ctoa(ii)) '/100,mAFC);'])   
        
            
                eval(['exo.pos' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '= exo.InValTrials_'  num2str(exo.ctoa(ii)) '(exo.InValTrials_'  num2str(exo.ctoa(ii)) '.postCueLocation ==' num2str(pos) ',:);'])
                eval(['exo.acc' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '= nansum(exo.pos' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '.respCorrect)/size(exo.pos' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) ',1)*100;'])
                if eval(['exo.acc' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '==0'])
                   eval(['exo.acc' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '= (1/(2*size(exo.pos' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) ',1)))*100'])
                elseif eval(['exo.acc' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '==100'])
                    eval(['exo.acc' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '= (1-(1/(2*size(exo.pos' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) ',1))))*100'])
                end
                eval(['exo.dp' num2str(pos) '_InV_' num2str(exo.ctoa(ii))  '= PAL_SDT_MAFC_PCtoDP(exo.acc' num2str(pos) '_InV_'  num2str(exo.ctoa(ii)) '/100,mAFC);'])
            
    end   
     % Cue Benefit = Accuracy on Valid trials - Accuracy on invlaid trials
        eval(['exo.CueEffect_' num2str(exo.ctoa(ii)) ' = exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '- exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii)) ';']);
        eval(['exo.cueEff_dp_' num2str(exo.ctoa(ii)) ' = exo.dprime_ValidTrial_' num2str(exo.ctoa(ii)) '- exo.dprime_NeutralTrial_' num2str(exo.ctoa(ii)) ';']);

     % Cue effect = Valid - invalid
        eval(['exo.CueEff_V2I_' num2str(exo.ctoa(ii)) '= exo.AccuracyValidTrial_' num2str(exo.ctoa(ii)) '- exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) ';']);
        eval(['exo.cueEff_V2I_dp_' num2str(exo.ctoa(ii)) '= exo.dprime_ValidTrial_' num2str(exo.ctoa(ii)) '- exo.dprime_InValTrial_' num2str(exo.ctoa(ii)) ';']);

     % Cue COST
        eval(['exo.cueCost_' num2str(exo.ctoa(ii)) '= exo.AccuracyNeuTrial_' num2str(exo.ctoa(ii)) '- exo.AccuracyInValTrial_' num2str(exo.ctoa(ii)) ';']);
        eval(['exo.cueCost_dp_' num2str(exo.ctoa(ii)) '= exo.dprime_NeutralTrial_' num2str(exo.ctoa(ii)) '- exo.dprime_InValTrial_' num2str(exo.ctoa(ii)) ';']);
    
end