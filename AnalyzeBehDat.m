%% setup analysis
%{
Use this script to generate the ALLEndo and AllExo mat files that has all
behavioral data across all subjects. 
Make sure the following functions are in your path 
splitHalf_reliability_inLab.m
indivEndo_SPP.m
plot_Wprofile.m
confusionMatrix_SPP.m
indivExo_SPP.m
spearmanBrown_reliability.m
Avgplot_all_cueEff.m
by Maha Ramamurthy, 2021
%}

expType= 1; %fir in-lab data collention 
adult =1;
diagnosis = 0; %Typical adults 
cueType =input('What Cue type are you analysing? 1 - Endo 2 Exo: ');
analysisType = input('Are you looking at group stats or individual data? Enter 0 - for group and 1 for individual: ');
if cueType==1 && adult && expType && ~diagnosis
    dataDir                 = what('~/Desktop/DataSharing_MR/results/Endo');
    dataDir =dataDir.path;
    cd (dataDir);
elseif cueType==2 && adult && expType && ~diagnosis
    dataDir                 = what('~/Desktop/DataSharing_MR/results/Exo');
    dataDir=dataDir.path;
    cd (dataDir);
end
if analysisType && expType
    subjDir = uigetdir(dataDir,'Select the relevant dir');
    cd(subjDir);
    if cueType==1
        endo.thisBlock=dir('*_b*.mat');
        endo.thisBlEye =dir('*_b*.edf');
        reliability=splitHalf_reliability_inLab(cueType,endo,[]);
        [endo] = indivEndo_SPP(cueType, endo);
      
                 Wprofile = plot_Wprofile(cueType,adult,endo);
                 errTable = confusionMatrix_SPP(cueType,adult, endo);
    elseif cueType==2
        exo.thisBlock=dir('*_b*.mat');
        exo.thisBlEye=dir('*_b*.edf');
        reliability=splitHalf_reliability_inLab(cueType,[],exo);
        [exo] = indivExo_SPP(cueType, exo);
       
                  Wprofile= plot_Wprofile(cueType,adult,[],exo);
                  errTable=confusionMatrix_SPP(cueType,adult, [],exo);
    end
elseif ~analysisType && expType
    files = dir(dataDir);
    dirFlags = [files.isdir];
    data_folder = files(dirFlags);
    errorDataTable = table;
    for k = 1:length(data_folder)-2 %the first two folders are github
        
        sdir    = data_folder(k+2).name;
        cd(sdir)
        if cueType==1
            endo(k).thisBlock =dir('*_b*.mat');
            endo(k).thisBlEye =dir('*_b*.edf');
            sprintf('In this session there are: %d Blocks', length(endo(k).thisBlock))
            reliability=splitHalf_reliability_inLab(cueType,endo(k));
            [endo] = indivEndo_SPP(cueType, endo(k));
            
            errTable{k}= confusionMatrix_SPP(cueType,adult, endo,[]);
            Wprofile(k)= plot_Wprofile(cueType,adult,endo,[]);
            subject(k).endo = endo;
            subject(k).reliability= reliability;
            % Who to include
            N = size(subject(k).endo.ValidTrials,1); %Number of trials on the Valid cue condition
            guessRate = 1/12;
            C = subject(k).endo.AccuracyValidtrials*N/100;
            [phat, pCI]=binofit(C,N);
            if pCI(:,1)>guessRate; subject(k).includeMe = 1; else subject(k).includeMe = 0; end                 
           
        elseif cueType==2
            exo(k).thisBlock =dir('*_b*.mat');
            exo(k).thisBlEye =dir('*_b*.edf');
            sprintf('In this session there are: %d Blocks', length(exo(k).thisBlock))
            reliability=splitHalf_reliability_inLab(cueType,[],exo(k));
            [exo] = indivExo_SPP(cueType, exo(k));
            
            errTable{k}=confusionMatrix_SPP(cueType,adult, [],exo);
            Wprofile(k)= plot_Wprofile(cueType,adult,[],exo);
            subject(k).exo = exo;
            subject(k).reliability= reliability;
            % Who to include
            N = size(subject(k).exo.ValidTrials,1); %Number of trials on the Valid cue condition
            guessRate = 1/12;
            C = subject(k).exo.AccuracyValidtrials*N/100;
            [phat, pCI]=binofit(C,N);
            if pCI(:,1)>guessRate; subject(k).includeMe = 1; else subject(k).includeMe = 0; end 
        end
        cd (dataDir);
    end
    %% GEt spearman_BrownN reliability
    reliability = spearmanBrown_reliability(subject, cueType);
    [All_accu,All_dpri] = Avgplot_all_cueEff(cueType,adult,subject);
    if cueType ==1 
        save('AllEndo.mat','exo','subject','Wprofile','errTable','reliability')
    else 
        save('AllExo.mat','exo','subject','Wprofile','errTable','reliability')
    end
end
