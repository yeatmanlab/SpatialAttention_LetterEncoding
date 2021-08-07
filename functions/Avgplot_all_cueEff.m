function [All_accu,All_dpri]=Avgplot_all_cueEff(cueType,adult,sub)
% Use this to visualize group stats from SPP 
%{ 
Color schemes: 
CueBenefits - [0.1 0.6 0.6] 

%}


All_accu=[]; All_dpri=[];cueBen_CTOA=[];cueEff_CTOA=[]; cueCst_CTOA=[];dp_ctoa=[];Acc_ctoa=[];cueBen_dp_CTOA=[]; cueEff_dp_CTOA=[];cueCst_dp_CTOA=[];


if cueType==1  
        CTOA                        = sub(1).endo.ctoa;    
        %for fig 1
        for n=1:length(sub)
        All_accu = [All_accu; sub(n).endo.AccuracyValidtrials, sub(n).endo.AccuracyNeutraltrials,sub(n).endo.OverallCueEffect];
        All_dpri = [All_dpri; sub(n).endo.dprime_ValidTrials, sub(n).endo.dprime_NeutralTrials, sub(n).endo.CueEff_dprime];
        end
        AccuracyValidtrials             = mean(All_accu(:,1));
        AccuracyNeutraltrials           = mean(All_accu(:,2));
        OverallCueEffect                = mean(All_accu(:,3));

        dprime_ValidTrials              = mean(All_dpri(:,1));
        dprime_NeutralTrials            = mean(All_dpri(:,2));
        OverallCueEff_dp                = mean(All_dpri(:,3));
        
        errorValidTrials                = std(All_accu(:,1))/sqrt((length(sub)-2));
        errorNeutralTrials              = std(All_accu(:,2))/sqrt((length(sub)-2));    
        errorOverallCueEffect           = std(All_accu(:,3))/sqrt((length(sub)-2));
        
        errorValidTrials_dp             = std(All_dpri(:,1))/sqrt(size(All_dpri,1));
        errorNeutralTrials_dp           = std(All_dpri(:,2))/sqrt(size(All_dpri,1));    
        errorOverallCueEffect_dp        = std(All_dpri(:,3))/sqrt(size(All_dpri,1));
        
        %[errorValidTrials,errorNeutralTrials,errorOverallCueEffect]
        %[errorValidTrials_dp,errorNeutralTrials_dp,errorOverallCueEffect_dp]
        
        %For fig 3
        for n=1:length(sub)
        cueBen_CTOA = [cueBen_CTOA; sub(n).endo.CueEffect_100,sub(n).endo.CueEffect_300,sub(n).endo.CueEffect_600];       
        cueBen_dp_CTOA = [cueBen_dp_CTOA; sub(n).endo.dpriCueEff_100,sub(n).endo.dpriCueEff_300,sub(n).endo.dpriCueEff_600];       
        end
        
        for n=1:length(CTOA)
        eval(['CueEffect_' num2str(CTOA(n)) '= mean(cueBen_CTOA(:,' num2str(n) '));']);
        eval(['errCueEff_' num2str(CTOA(n)) '= std(cueBen_CTOA(:,' num2str(n) '))/sqrt(size(cueBen_CTOA,1));']);
        
        eval(['dp_CueEffect_' num2str(CTOA(n)) '= mean(cueBen_dp_CTOA(:,' num2str(n) '));'])
        eval(['dp_errCueEff_' num2str(CTOA(n)) '= std(cueBen_dp_CTOA(:,' num2str(n) '))/sqrt(size(cueBen_dp_CTOA,1));']);
        end
        
        %{
        CueEffect_600 = mean(cueBen_CTOA(:,2));
        errCueEff_600 = std(cueBen_CTOA(:,2))/sqrt(size(cueBen_CTOA,1));
        
        dp_CueEffect_600 = mean(cueBen_dp_CTOA(:,2));
        dp_errCueEff_600 = std(cueBen_dp_CTOA(:,2))/sqrt(size(cueBen_dp_CTOA,1));
        %}
        
        %for fig 4       
        
    for i=1:length(CTOA)
        for n=1:length(sub)
        eval(['Acc_ctoa = [Acc_ctoa; sub(n).endo.AccuracyValidTrial_' num2str(CTOA(i)) ', sub(n).endo.AccuracyNeuTrial_' num2str(CTOA(i)) ',sub(n).endo.CueEffect_' num2str(CTOA(i)) '];'])
        eval(['dp_ctoa  = [dp_ctoa; sub(n).endo.dprime_ValidTrial_' num2str(CTOA(i)) ', sub(n).endo.dprime_NeutralTrial_' num2str(CTOA(i)) ', sub(n).endo.dpriCueEff_' num2str(CTOA(i)) '];'])
        end
        eval(['AccuracyValidTrial_' num2str(CTOA(i))    '= mean(Acc_ctoa(:,1));'])
        eval(['AccuracyNeuTrial_' num2str(CTOA(i))      '= mean(Acc_ctoa(:,2)) ;'])
        eval(['CueEffect_' num2str(CTOA(i))             '=  mean(Acc_ctoa(:,3));'])
       
        eval(['errAccValidTrial_' num2str(CTOA(i))      '= std(Acc_ctoa(:,1))/sqrt(size(Acc_ctoa,1));'])
        eval(['errAccNeuTrial_' num2str(CTOA(i))        '= std(Acc_ctoa(:,2))/sqrt(size(Acc_ctoa,1));'])
        eval(['errCueEffect_' num2str(CTOA(i))          '= std(Acc_ctoa(:,3))/sqrt(size(Acc_ctoa,1));'])
        
        %[errAccValidTrial_300,errAccNeuTrial_300,errCueEffect_300]
        
        eval(['dprime_ValidTrial_' num2str(CTOA(i))     '=  mean(dp_ctoa(:,1));'])
        eval(['dprime_NeutralTrial_' num2str(CTOA(i))   '= mean(dp_ctoa(:,2));'])
        eval(['dprime_allCueEff_' num2str(CTOA(i))      '= mean(dp_ctoa(:,3));'])
        
        %[dprime_ValidTrial_300,
        %dprime_NeutralTrial_300,dprime_allCueEff_300]
        
        eval(['errdprime_ValidTrial_' num2str(CTOA(i))     '= std(dp_ctoa(:,1))/sqrt(size(dp_ctoa,1));'])
        eval(['errdprime_NeutralTrial_' num2str(CTOA(i))   '= std(dp_ctoa(:,2))/sqrt(size(dp_ctoa,1));'])
        eval(['errdprime_allCueEff_' num2str(CTOA(i))      '= std(dp_ctoa(:,3))/sqrt(size(dp_ctoa,1));'])
        
    end
        
elseif cueType==2
    
        CTOA                        = sub(1).exo.ctoa;
        %For fig 1 
        for n=1:length(sub)
        All_accu = [All_accu; sub(n).exo.AccuracyValidtrials, sub(n).exo.AccuracyNeutraltrials,sub(n).exo.AccuracyInVtrials,sub(n).exo.OverallCueEffect,...
           sub(n).exo.cueEff_V_InV, sub(n).exo.overall_cueCost];
        All_dpri = [All_dpri; sub(n).exo.dprime_ValidTrials, sub(n).exo.dprime_NeutralTrials,sub(n).exo.dprime_InVtrials,...
            sub(n).exo.OverallCueEff_dp,sub(n).exo.cueEff_V_InV_dp,sub(n).exo.overall_cueCost_dp];
        end
        
        AccuracyValidtrials             = mean(All_accu(:,1));
        AccuracyNeutraltrials           = mean(All_accu(:,2));
        AccuracyInVtrials               = mean(All_accu(:,3));
        OverallCueEffect                = mean(All_accu(:,4));
        cueEff_V_InV                    = mean(All_accu(:,5));
        overall_cueCost                 = mean(All_accu(:,6));
       
        dprime_ValidTrials              = mean(All_dpri(:,1));
        dprime_NeutralTrials            = mean(All_dpri(:,2));
        dprime_InVtrials                = mean(All_dpri(:,3));
        OverallCueEff_dp                = mean(All_dpri(:,4));
        cueEff_V_InV_dp                 = mean(All_dpri(:,5));
        overall_cueCost_dp              = mean(All_dpri(:,6));
%         OverallCueEff_dp =  mean(All_dpri(:,1)-All_dpri(:,2));
%         overall_cueCost_dp= mean(All_dpri(:,2)-All_dpri(:,3));
%         cueEff_V_InV_dp   = mean(All_dpri(:,1)-All_dpri(:,3));
        
        
        errorValidTrials                = std(All_accu(:,1))/sqrt(size(All_accu,1));
        errorNeutralTrials              = std(All_accu(:,2))/sqrt(size(All_accu,1));  
        errorInVtrials                  = std(All_accu(:,3))/sqrt(size(All_accu,1));
        errorOverallCueEffect           = std(All_accu(:,4))/sqrt(size(All_accu,1));
        errorcueEff_V_InV               = std(All_accu(:,5))/sqrt(size(All_accu,1));
        erroroverall_cueCost            = std(All_accu(:,6))/sqrt(size(All_accu,1));
       
        errorValidTrials_dp             = std(All_dpri(:,1))/sqrt(size(All_dpri,1));
        errorNeutralTrials_dp           = std(All_dpri(:,2))/sqrt(size(All_dpri,1));
        errorInVtrials_dp               = std(All_dpri(:,3))/sqrt(size(All_dpri,1));
        errorOverallCueEff_dp           = std(All_dpri(:,1)-All_dpri(:,2))/sqrt(size(All_dpri,1));
        errorcueEff_V_InV_dp            = std(All_dpri(:,2)-All_dpri(:,3))/sqrt(size(All_dpri,1));
        erroroverall_cueCost_dp         = std(All_dpri(:,1)-All_dpri(:,3))/sqrt(size(All_dpri,1));   
   
        %[errorValidTrials,errorNeutralTrials,errorInVtrials,errorOverallCueEffect,errorcueEff_V_InV,erroroverall_cueCost]
        %[errorValidTrials_dp,errorNeutralTrials_dp,errorInVtrials_dp.errorOverallCueEff_dp,errorcueEff_V_InV_dp,erroroverall_cueCost_dp]
        
        %For fig 3
        for n=1:length(sub)
        cueBen_CTOA = [cueBen_CTOA; sub(n).exo.CueEffect_50,sub(n).exo.CueEffect_100,sub(n).exo.CueEffect_300]; 
        cueEff_CTOA = [cueEff_CTOA; sub(n).exo.CueEff_V2I_50, sub(n).exo.CueEff_V2I_100, sub(n).exo.CueEff_V2I_300];
        cueCst_CTOA = [cueCst_CTOA; sub(n).exo.cueCost_50, sub(n).exo.cueCost_100, sub(n).exo.cueCost_300];
        
        cueBen_dp_CTOA = [cueBen_dp_CTOA; sub(n).exo.cueEff_dp_50,sub(n).exo.cueEff_dp_100,sub(n).exo.cueEff_dp_300];
        cueEff_dp_CTOA = [cueEff_dp_CTOA; sub(n).exo.cueEff_V2I_dp_50,sub(n).exo.cueEff_V2I_dp_100,sub(n).exo.cueEff_V2I_dp_300];
        cueCst_dp_CTOA = [cueCst_dp_CTOA; sub(n).exo.cueCost_dp_50, sub(n).exo.cueCost_dp_100,sub(n).exo.cueCost_dp_300];
        end
        
        CueEffect_50 = mean(cueBen_CTOA(:,1));
        CueEffect_100 = mean(cueBen_CTOA(:,2));
        CueEffect_300 = mean(cueBen_CTOA(:,3));
   
        CueEff_V2I_50= mean(cueEff_CTOA(:,1));
        CueEff_V2I_100= mean(cueEff_CTOA(:,2));
        CueEff_V2I_300= mean(cueEff_CTOA(:,3));
        
        cueCost_50   = mean(cueCst_CTOA(:,1));
        cueCost_100   = mean(cueCst_CTOA(:,2));
        cueCost_300   = mean(cueCst_CTOA(:,3));
        
        errCueEff_50 = std(cueBen_CTOA(:,1))/sqrt(size(cueBen_CTOA,1));
        errCueEff_100 = std(cueBen_CTOA(:,2))/sqrt(size(cueBen_CTOA,1));
        errCueEff_300 = std(cueBen_CTOA(:,3))/sqrt(size(cueBen_CTOA,1));
        
        errCueEff_V2I_50= std(cueEff_CTOA(:,1))/sqrt(size(cueEff_CTOA,1));
        errCueEff_V2I_100= std(cueEff_CTOA(:,2))/sqrt(size(cueEff_CTOA,1));
        errCueEff_V2I_300= std(cueEff_CTOA(:,3))/sqrt(size(cueEff_CTOA,1));
        
        errcueCost_50   = std(cueCst_CTOA(:,1))/sqrt(size(cueCst_CTOA,1));
        errcueCost_100   = std(cueCst_CTOA(:,2))/sqrt(size(cueCst_CTOA,1));
        errcueCost_300   = std(cueCst_CTOA(:,3))/sqrt(size(cueCst_CTOA,1));
     
        dp_CueEffect_50 = mean(cueBen_dp_CTOA(:,1));
        dp_CueEffect_100 = mean(cueBen_dp_CTOA(:,2));
        dp_CueEffect_300 = mean(cueBen_dp_CTOA(:,3));
   
        dp_CueEff_V2I_50= mean(cueEff_dp_CTOA(:,1));
        dp_CueEff_V2I_100= mean(cueEff_dp_CTOA(:,2));
        dp_CueEff_V2I_300= mean(cueEff_dp_CTOA(:,3));
        
        dp_cueCost_50   = mean(cueCst_dp_CTOA(:,1));
        dp_cueCost_100   = mean(cueCst_dp_CTOA(:,2));
        dp_cueCost_300   = mean(cueCst_dp_CTOA(:,3));
        
        dp_errCueEff_50 = std(cueBen_dp_CTOA(:,1))/sqrt(size(cueBen_dp_CTOA,1));
        dp_errCueEff_100 = std(cueBen_dp_CTOA(:,2))/sqrt(size(cueBen_dp_CTOA,1));
        dp_errCueEff_300 = std(cueBen_dp_CTOA(:,3))/sqrt(size(cueBen_dp_CTOA,1));
        
        dp_errCueEff_V2I_50= std(cueEff_dp_CTOA(:,1))/sqrt(size(cueEff_dp_CTOA,1));
        dp_errCueEff_V2I_100= std(cueEff_dp_CTOA(:,2))/sqrt(size(cueEff_dp_CTOA,1));
        dp_errCueEff_V2I_300= std(cueEff_dp_CTOA(:,3))/sqrt(size(cueEff_dp_CTOA,1));
        
        dp_errcueCost_50   = std(cueCst_dp_CTOA(:,1))/sqrt(size(cueCst_dp_CTOA,1));
        dp_errcueCost_100   = std(cueCst_dp_CTOA(:,2))/sqrt(size(cueCst_dp_CTOA,1));
        dp_errcueCost_300   = std(cueCst_dp_CTOA(:,3))/sqrt(size(cueCst_dp_CTOA,1));
        
        %for fig 4   
        
        for i=1:length(CTOA)
            for n=1:length(sub)
        eval(['Acc_ctoa = [Acc_ctoa; sub(n).exo.AccuracyValidTrial_' num2str(CTOA(i)) ', sub(n).exo.AccuracyNeuTrial_' num2str(CTOA(i)) ...
            ',sub(n).exo.AccuracyInValTrial_' num2str(CTOA(i)) ', sub(n).exo.CueEffect_' num2str(CTOA(i)) ',sub(n).exo.CueEff_V2I_' num2str(CTOA(i)) ',sub(n).exo.cueCost_' num2str(CTOA(i)) '];'])
        eval(['dp_ctoa  = [dp_ctoa; sub(n).exo.dprime_ValidTrial_' num2str(CTOA(i)) ', sub(n).exo.dprime_NeutralTrial_' num2str(CTOA(i))...
            ',sub(n).exo.dprime_InValTrial_' num2str(CTOA(i)) ',sub(n).exo.cueEff_dp_' num2str(CTOA(i)) ',sub(n).exo.cueEff_V2I_dp_' num2str(CTOA(i)) ',sub(n).exo.cueCost_dp_' num2str(CTOA(i)) '];'])
            end
        eval(['AccuracyValidTrial_' num2str(CTOA(i))  '= mean(Acc_ctoa(:,1));'])
        eval(['AccuracyNeuTrial_' num2str(CTOA(i))    '= mean(Acc_ctoa(:,2));'])
        eval(['AccuracyInValTrial_' num2str(CTOA(i))  '= mean(Acc_ctoa(:,3));'])
%         eval(['CueEffect_' num2str(CTOA(i))           '= mean(Acc_ctoa(:,4));'])
%         eval(['CueEff_V2I_' num2str(CTOA(i))          '= mean(Acc_ctoa(:,5));'])
%         eval(['cueCost_' num2str(CTOA(i))             '= mean(Acc_ctoa(:,6));'])
        
        eval(['errAccValidTrial_' num2str(CTOA(i))    '= std(Acc_ctoa(:,1))/sqrt(size(Acc_ctoa,1));'])
        eval(['errAccNeuTrial_' num2str(CTOA(i))      '= std(Acc_ctoa(:,2))/sqrt(size(Acc_ctoa,1));'])
        eval(['errAccInValTrial_' num2str(CTOA(i))    '= std(Acc_ctoa(:,3))/sqrt(size(Acc_ctoa,1));'])
%         eval(['errCueEffect_' num2str(CTOA(i))        '= std(Acc_ctoa(:,4))/sqrt(size(Acc_ctoa,1));'])
%         eval(['errCueEff_V2I_' num2str(CTOA(i))       '= std(Acc_ctoa(:,5))/sqrt(size(Acc_ctoa,1));'])
%         eval(['errcueCost_' num2str(CTOA(i))          '= std(Acc_ctoa(:,6))/sqrt(size(Acc_ctoa,1));'])
        
        %[errAccValidTrial_50,errAccNeuTrial_50,errAccInValTrial_50,errCueEffect_50,errCueEff_V2I_50,errcueCost_50]
        
        eval(['dprime_ValidTrial_' num2str(CTOA(i))   '= mean(dp_ctoa(:,1));'])
        eval(['dprime_NeutralTrial_' num2str(CTOA(i)) '= mean(dp_ctoa(:,2));'])
        eval(['dprime_InValTrial_' num2str(CTOA(i))   '= mean(dp_ctoa(:,3));'])
         eval(['dprime_allCueEff_' num2str(CTOA(i))    '= mean(dp_ctoa(:,4));'])
         eval(['dprime_CueEff_V2I_' num2str(CTOA(i))   '= mean(dp_ctoa(:,5));'])
         eval(['dprime_cueCost_' num2str(CTOA(i))      '= mean(dp_ctoa(:,6));'])
        
        %[dprime_ValidTrial_50,dprime_NeutralTrial_50,dprime_InValTrial_50,dprime_allCueEff_50,dprime_CueEff_V2I_50,dprime_cueCost_50]
        
        eval(['errdprime_ValidTrial_' num2str(CTOA(i))   '= std(dp_ctoa(:,1))/sqrt(size(dp_ctoa,1));'])
        eval(['errdprime_NeutralTrial_' num2str(CTOA(i)) '= std(dp_ctoa(:,2))/sqrt(size(dp_ctoa,1));'])
        eval(['errdprime_InValTrial_' num2str(CTOA(i))   '= std(dp_ctoa(:,3))/sqrt(size(dp_ctoa,1));'])
         eval(['errdprime_allCueEff_' num2str(CTOA(i))    '= std(dp_ctoa(:,4))/sqrt(size(dp_ctoa,1));'])
         eval(['errdprime_CueEff_V2I_' num2str(CTOA(i))   '= std(dp_ctoa(:,5))/sqrt(size(dp_ctoa,1));'])
         eval(['errdprime_cueCost_' num2str(CTOA(i))      '= std(dp_ctoa(:,6))/sqrt(size(dp_ctoa,1));'])
        
%         [errdprime_ValidTrial_50,errdprime_NeutralTrial_50,errdprime_InValTrial_50,errdprime_allCueEff_50,errdprime_CueEff_V2I_50,errdprime_cueCost_50]
 
        end
        %}
end

%% Plot figures on over all cueEffect, cueEffect as a func of CTOA, 
if cueType ==2
    figure(2); subplot 121; grid on
    barH=bar([1,2,3,4,5,6], [AccuracyValidtrials,AccuracyNeutraltrials, AccuracyInVtrials, OverallCueEffect, cueEff_V_InV, overall_cueCost]);
     hold on 
    errorH=errorbar([AccuracyValidtrials,AccuracyNeutraltrials, AccuracyInVtrials, OverallCueEffect, cueEff_V_InV,overall_cueCost],[errorValidTrials,errorNeutralTrials,errorInVtrials,...
    errorOverallCueEffect,errorcueEff_V_InV, erroroverall_cueCost],'-b','LineStyle','none','CapSize',0,'LineWidth',1);
    %Guess rate
    line ([0 7],[8 8],'Color','blue','LineStyle','--')
    set(gca, 'xticklabels',{'Valid', 'Neutral', 'InValid','cBenefit','cueEff:(V-I)', 'cueCost'}, 'FontSize', 15)
    barH(1).FaceColor ='Flat' ; barH(1).CData=[0.6 0.8 0.5;0 0 0.7;0.6 0 0;0.1 0.6 0.6;0.9 0.8 0.2;0.8 0.2 0.8];

    ylabel 'Accuracy (%)'
    ylim ([0 100])
    yticks (0:20:100)
    xlim ([0 7])
    xticks(1:1:6)
    title('Overall CueEffect')
    grid on
    
    hold on; subplot 122; grid on
    plot([1,2,3,4,5,6], [dprime_ValidTrials,dprime_NeutralTrials,dprime_InVtrials,OverallCueEff_dp,cueEff_V_InV_dp,overall_cueCost_dp],'Marker','*','MarkerSize',10,'MarkerEdgeColor', 'b','LineStyle','none')
    hold on   
    errorbar([dprime_ValidTrials,dprime_NeutralTrials,dprime_InVtrials,OverallCueEff_dp,cueEff_V_InV_dp,overall_cueCost_dp],...
        [errorValidTrials_dp,errorNeutralTrials_dp,errorInVtrials_dp,errorOverallCueEff_dp,errorcueEff_V_InV_dp,erroroverall_cueCost_dp],'-b','LineStyle','none','CapSize',0,'LineWidth',1.2)
    line ([0 8],[0 0],'Color','blue','LineStyle','--')
    set(gca, 'xticklabels',{'Valid', 'Neutral', 'InValid','cBenefit','cueEff:(V-I)', 'cueCost'}, 'FontSize', 15)
    xlim ([0 7]);
    xticks(1:1:6)
    ylabel 'Sensitivity(dprime)'
    ylim ([-2 4]);
    title('d prime')
    grid on
elseif cueType ==1
    figure(2); hold on; subplot 121; grid on
    barH=bar([1,2,3], [AccuracyValidtrials,AccuracyNeutraltrials,OverallCueEffect]);
    barH.FaceColor ='Flat' ; barH.CData=[0.6 0.8 0.5;0 0 0.7;0.1 0.6 0.6];
    hold on
    errorH=errorbar([1,2,3],[AccuracyValidtrials,AccuracyNeutraltrials, OverallCueEffect],[errorValidTrials,errorNeutralTrials,...
    errorOverallCueEffect],'-b','LineStyle','none','CapSize',0,'LineWidth',1);
    %GuessRate
    line ([0 4],[8 8],'Color','blue','LineStyle','--')
    set(gca, 'xticklabels',{'Valid', 'Neutral', 'CueEffect'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    ylim ([0 100])
    yticks (0:20:100)
    xlim ([0 4])
    xticks(1:1:3)
    title('Overall CueEffect')
    hold on; subplot 122; grid on

    plot([1,2,3], [dprime_ValidTrials,dprime_NeutralTrials,OverallCueEff_dp], 'Marker','*','MarkerSize',5,'MarkerEdgeColor', 'b','LineStyle','none')
    hold on
    errorbar([1,2,3],[dprime_ValidTrials,dprime_NeutralTrials, OverallCueEff_dp],[errorValidTrials_dp,errorNeutralTrials_dp,...
        errorOverallCueEffect_dp],'-b','LineStyle','none','CapSize',0,'LineWidth',1.2);
    line ([0 4],[0 0],'Color','blue','LineStyle','--')
    set(gca, 'xticklabels',{'Valid', 'Neutral','CueEffect'}, 'FontSize', 15)
    ylabel 'Sensitivity (dprime)'
    xlim ([0 4])
    xticks(1:1:3)
    ylim([-2 4])
    title('d prime')
    grid on
end

%% fig3
if adult && cueType==2
    figure(3);subplot 131
    h1=bar([1,2,3], [CueEffect_50,CueEffect_100,CueEffect_300]);
    h1.FaceColor = [0.1 0.6 0.6];
    hold on 
    eh1=errorbar([CueEffect_50,CueEffect_100,CueEffect_300],[errCueEff_50, errCueEff_100,errCueEff_300],'-','LineStyle','none','CapSize',0,'LineWidth',1.2,'Color',[0.4660 0.6740 0.1880]);
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    ylim ([0 50])
    yticks (0:10:50)
    title('cueBenefit (V-N)')
    grid on
    
    hold on; subplot 132
    h2=bar([1,2,3], [CueEff_V2I_50,CueEff_V2I_100,CueEff_V2I_300]);
    h2.FaceColor = [0.9 0.8 0.2];
    hold on
    eh2=errorbar([CueEff_V2I_50,CueEff_V2I_100,CueEff_V2I_300],[errCueEff_V2I_50,errCueEff_V2I_100,errCueEff_V2I_300],'-k','LineStyle','none','CapSize',0,'LineWidth',1.2);
    set(gca, 'xticklabels',{'50', ' 100', '300'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    xlabel 'Cue Target Onset Asynchrony (CTOA) in ms'
    ylim ([0 50])
    yticks (0:10:50)
    title('CueEffect (V-I)')
    grid on
    
    hold on; subplot 133   
    h3=bar([1,2,3], [cueCost_50,cueCost_100,cueCost_300]);
    h3.FaceColor=[0.8 0.2 0.8];
    hold on;
    eh3=errorbar([cueCost_50,cueCost_100,cueCost_300],[errcueCost_50,errcueCost_100,errcueCost_300],'-r','LineStyle','none','CapSize',0,'LineWidth',1.2);
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    ylim ([0 50])
    yticks (0:10:50)
    title('cueCost (N-I)')
    grid on 
elseif ~adult && cueType==2
    figure(3);subplot 131
    h1=bar([1,2], [CueEffect_50,CueEffect_100]);
    h1.FaceColor = [0.4 0.8 0.5];
    hold on 
    errorbar([CueEffect_50,CueEffect_100],[errCueEffect_50,errCueEffect_100],'-','LineStyle','none','CapSize',0,'LineWidth',1.2,'Color',[0.4660 0.6740 0.1880]);
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    ylim ([-20 50])
    yticks (0:10:50)
    title('cueBenefit (V-N)')
    grid on
    
    hold on; subplot 132
    h2=bar([1,2], [CueEff_V2I_50,CueEff_V2I_100]);
    h2.FaceColor = [0.6 0.6 0.6];
    hold on;
    eh2=errorbar([CueEff_V2I_50,CueEff_V2I_100],[errCueEff_V2I_50,errCueEff_V2I_100],'-k','LineStyle','none','CapSize',0,'LineWidth',1.2); 
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    xlabel 'Cue Target Onset Asynchrony (CTOA) in ms'
    ylim ([-20 50])
    yticks (0:10:50)
    title('cueEffect (V-I)')
    grid on
    
    hold on; subplot 133
    h3=bar([1,2], [cueCost_50,cueCost_100]);
    h3.FaceColor=[0.8 0.6 0.3];
    hold on 
    eh3=errorbar([cueCost_50,cueCost_100],[errcueCost_50,errcueCost_100],'-r','LineStyle','none','CapSize',0,'LineWidth',1.2);
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    ylim ([-20 50])
    yticks (0:10:50)
    title('cueCost (N-I)')
    grid on
elseif cueType==1 
    figure(3);
    h1=bar([1,2,3], [CueEffect_100,CueEffect_300,CueEffect_600]);
    h1.FaceColor = [0.1 0.6 0.6];
    hold on 
    eh1=errorbar([1,2,3],[CueEffect_100,CueEffect_300,CueEffect_600],[errCueEff_100,errCueEff_300,errCueEff_600],'-k','LineStyle','none','CapSize',0,'LineWidth',1.2); 

    set(gca, 'xticklabels',{'100','300','600'}, 'FontSize', 20)
    ylabel 'Accuracy (%)'
    xlabel 'CueTarget Onset Asynchrony (CTOA) in ms'
    xlim ([0 4])
    ylim ([0 50])
    yticks (0:10:50)
    title('CueEffect/Benefit')
    grid on
end

%fig4
    
if adult && cueType==2
    figure(4); 
    y=[AccuracyValidtrials,AccuracyNeutraltrials,AccuracyInVtrials,OverallCueEffect,cueEff_V_InV,overall_cueCost;
       AccuracyValidTrial_50,AccuracyNeuTrial_50,AccuracyInValTrial_50,CueEffect_50, CueEff_V2I_50,cueCost_50; 
       AccuracyValidTrial_100,AccuracyNeuTrial_100,AccuracyInValTrial_100,CueEffect_100,CueEff_V2I_100,cueCost_100; AccuracyValidTrial_300,AccuracyNeuTrial_300,...
       AccuracyInValTrial_300,CueEffect_300,CueEff_V2I_300,cueCost_300];
    errorY=[errorValidTrials,errorNeutralTrials,errorInVtrials,errorOverallCueEffect,errorcueEff_V_InV,erroroverall_cueCost;
           errAccValidTrial_50,errAccNeuTrial_50,errAccInValTrial_50,errCueEff_50,errCueEff_V2I_50,errcueCost_50;
           errAccValidTrial_100,errAccNeuTrial_100,errAccInValTrial_100,errCueEff_100,errCueEff_V2I_100,errcueCost_100;
           errAccValidTrial_300,errAccNeuTrial_300,errAccInValTrial_300,errCueEff_300,errCueEff_V2I_300,errcueCost_300];
        %[errorValidTrials,errorNeutralTrials,errorInVtrials,errorOverallCueEffect,errorcueEff_V_InV,erroroverall_cueCost]
        %[errorValidTrials_dp,errorNeutralTrials_dp,errorInVtrials_dp.errorOverallCueEff_dp,errorcueEff_V_InV_dp,erroroverall_cueCost_dp]]
   
    h1=bar(y,'grouped');
    h1(1).FaceColor ='Flat' ; h1(1).CData=[0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5];
    h1(2).FaceColor ='Flat' ; h1(2).CData=[0 0 0.7;0 0 0.7;0 0 0.7;0 0 0.7];
    h1(3).FaceColor ='Flat' ; h1(3).CData=[0.6 0 0;0.6 0 0;0.6 0 0;0.6 0 0];
    h1(4).FaceColor ='Flat' ; h1(4).CData=[0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6];
    h1(5).FaceColor ='Flat' ; h1(5).CData=[0.9 0.8 0.2;0.9 0.8 0.2;0.9 0.8 0.2;0.9 0.8 0.2];
    h1(6).FaceColor ='Flat' ; h1(6).CData=[0.8 0.2 0.8;0.8 0.2 0.8;0.8 0.2 0.8;0.8 0.2 0.8];
    for k=1:size(h1,2)
        ctr(k,:) = bsxfun(@plus,h1(1).XData, h1(k).XOffset');
        ydt(k,:) = h1(k).YData;
    end
    hold on 
    eh1=errorbar(ctr',ydt',errorY,'-k','LineStyle','none','CapSize',0,'LineWidth',1); 
    legend('Valid', 'Neutral', 'Invalid', 'cE:V-N','cE:V-I', 'cC:I-N')
    set(gca, 'xticklabels',{'Overall', 'CTOA:50', '100', '300'}, 'FontSize', 20)
    ylabel 'Accuracy (%)'
    set(gca, 'Fontsize',20)
    ylim ([-10 100])
    yticks (-10:10:100)
    grid on
    
%     hold on; subplot 122
figure(6);
    y=[dprime_ValidTrials, dprime_NeutralTrials,dprime_InVtrials,OverallCueEff_dp, cueEff_V_InV_dp,overall_cueCost_dp;
        dprime_ValidTrial_50, dprime_NeutralTrial_50,dprime_InValTrial_50, dp_CueEffect_50, dp_CueEff_V2I_50,dp_cueCost_50;
        dprime_ValidTrial_100,dprime_NeutralTrial_100,dprime_InValTrial_100,dp_CueEffect_100, dp_CueEff_V2I_100,dp_cueCost_100;
        dprime_ValidTrial_300, dprime_NeutralTrial_300,dprime_InValTrial_300, dp_CueEffect_100, dp_CueEff_V2I_300,dp_cueCost_300];
    
    errorY=[errorValidTrials_dp,errorNeutralTrials_dp,errorInVtrials_dp,errorOverallCueEff_dp,errorcueEff_V_InV_dp,erroroverall_cueCost_dp;
        errdprime_ValidTrial_50,errdprime_NeutralTrial_50,errdprime_InValTrial_50,errdprime_allCueEff_50,errdprime_CueEff_V2I_50,errdprime_cueCost_50;
       errdprime_ValidTrial_100,errdprime_NeutralTrial_100,errdprime_InValTrial_100,errdprime_allCueEff_100,errdprime_CueEff_V2I_100,errdprime_cueCost_100;
       errdprime_ValidTrial_300,errdprime_NeutralTrial_300,errdprime_InValTrial_300,errdprime_allCueEff_300,errdprime_CueEff_V2I_300,errdprime_cueCost_300];
    
    h2= bar(y,'grouped');
   h2(1).FaceColor ='Flat' ; h2(1).CData=[0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5];
    h2(2).FaceColor ='Flat' ; h2(2).CData=[0 0 0.7;0 0 0.7;0 0 0.7;0 0 0.7];
    h2(3).FaceColor ='Flat' ; h2(3).CData=[0.6 0 0;0.6 0 0;0.6 0 0;0.6 0 0];
    h2(4).FaceColor ='Flat' ; h2(4).CData=[0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6];
    h2(5).FaceColor ='Flat' ; h2(5).CData=[0.9 0.8 0.2;0.9 0.8 0.2;0.9 0.8 0.2;0.9 0.8 0.2];
    h2(6).FaceColor ='Flat' ; h2(6).CData=[0.8 0.2 0.8;0.8 0.2 0.8;0.8 0.2 0.8;0.8 0.2 0.8];
    hold on 
    for k=1:size(h2,2)
        ctr(k,:) = bsxfun(@plus,h2(1).XData, h2(k).XOffset');
        ydt(k,:) = h2(k).YData;
    end
    
    eh2=errorbar(ctr',ydt',errorY,'-k','LineStyle','none','CapSize',0,'LineWidth',1); 
    
    set(gca, 'xticklabels',{'Avg','CTOAs:50', '100', '300'}, 'FontSize', 16)
    ylabel 'd'''
    legend('Valid', 'Neutral', 'Invalid', 'cB:V-N','cE:V-I', 'cC:I-N')
    set(gca,'FontSize',14,'FontName','Times New Roman')
    ylim ([0 3])
    grid on
elseif ~adult && cueType==2
    figure(4); subplot 121
     y=[AccuracyValidtrials,AccuracyNeutraltrials,AccuracyInVtrials,OverallCueEffect,cueEff_V_InV,overall_cueCost;
        AccuracyValidTrial_50,AccuracyNeuTrial_50,AccuracyInValTrial_50,CueEffect_50, CueEff_V2I_50,cueCost_50;
        AccuracyValidTrial_300,AccuracyNeuTrial_300,AccuracyInValTrial_300,CueEffect_300,CueEff_V2I_300,cueCost_100;
        AccuracyValidTrial_300,AccuracyNeuTrial_300,AccuracyInValTrial_300,CueEffect_300,CueEff_V2I_300,cueCost_300];
     
     errorY=[errorValidTrials,errorNeutralTrials,errorInVtrials,errorOverallCueEffect,errorcueEff_V_InV,erroroverall_cueCost;
           errAccValidTrial_50,errAccNeuTrial_50,errAccInValTrial_50,errCueEff_50,errCueEff_V2I_50,errcueCost_50;
           errAccValidTrial_100,errAccNeuTrial_100,errAccInValTrial_100,errCueEff_100,errCueEff_V2I_100,errcueCost_100;
           errAccValidTrial_300,errAccNeuTrial_300,errAccInValTrial_300,errCueEff_300,errCueEff_V2I_300,errcueCost_300];
    
   h1= bar(y,'grouped');
    h1(1).FaceColor='flat'; h1(1).CData=[0.2, 0.2, .9;0.2, 0.2, .9;0.2, 0.2, .9;0.2, 0.2, .9];
    h1(2).FaceColor='flat'; h1(2).CData=[0.3 0.4 .9;0.3 0.4 .9;0.3 0.4 .9;0.3 0.4 .9];
    h1(3).FaceColor='flat'; h1(3).CData=[0.5 0.6 .9;0.5 0.6 .9;0.5 0.6 .9;0.5 0.6 .9];
    h1(4).FaceColor='flat'; h1(4).CData=[.4 .8 .5;.4 .8 .5;.4 .8 .5;.4 .8 .5];
    h1(5).FaceColor='flat'; h1(5).CData=[.6 .6 .6;.6 .6 .6;.6 .6 .6;.6 .6 .6];
    h1(6).FaceColor='flat'; h1(6).CData=[.9 .4 .3;.9 .4 .3;.9 .4 .3;.9 .4 .3];
    hold on 
    for k=1:size(h1,2)
        ctr(k,:) = bsxfun(@plus,h1(1).XData, h1(k).XOffset');
        ydt(k,:) = h1(k).YData;
    end
    
    eh1=errorbar(ctr',ydt',errorY,'-k','LineStyle','none','CapSize',0,'LineWidth',1); 
    
    legend('Valid', 'Neutral', 'Invalid', 'cE:V-N','cE:V-I', 'cueCost')
    set(gca, 'xticklabels',{'Overall', 'CTOA100', 'CTOA300'}, 'FontSize', 20)
    ylabel 'Accuracy (%)'
    set(gca, 'Fontsize',20)
    ylim ([-20 100])
    yticks (-20:10:100)
    grid on
    
    hold on; subplot 122
    y=[dprime_ValidTrials,dprime_NeutralTrials,dprime_InVtrials,OverallCueEff_dp, cueEff_V_InV_dp,overall_cueCost_dp; 
        dprime_ValidTrial_100, dprime_NeutralTrial_100,dprime_InValTrial_100,dprime_allCueEff_100, dprime_CueEff_V2I_100,dprime_cueCost_100;
        dprime_ValidTrial_300,dprime_NeutralTrial_300,dprime_InValTrial_300,dprime_allCueEff_300, dprime_CueEff_V2I_300,dprime_cueCost_300];
    errorY = [errorValidTrials_dp,errorNeutralTrials_dp,errorInVtrials_dp,errorOverallCueEff_dp,errorcueEff_V_InV_dp,erroroverall_cueCost_dp;
        errdprime_ValidTrial_100,errdprime_NeutralTrial_100,errdprime_InValTrial_100,errdprime_allCueEff_100,errdprime_CueEff_V2I_100,errdprime_cueCost_100;
       errdprime_ValidTrial_300,errdprime_NeutralTrial_300,errdprime_InValTrial_300,errdprime_allCueEff_300,errdprime_CueEff_V2I_300,errdprime_cueCost_300];
    
    h2= bar(y,'grouped');
    h2(1).FaceColor='flat'; h2(1).CData=[0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5];
    h2(2).FaceColor='flat'; h2(2).CData=[0.3 0.4 .9;0.3 0.4 .9;0.3 0.4 .9;0.3 0.4 .9];
    h2(3).FaceColor='flat'; h2(3).CData=[0.5 0.6 .9;0.5 0.6 .9;0.5 0.6 .9;0.5 0.6 .9];
    h2(4).FaceColor='flat'; h2(4).CData=[.4 .8 .5;.4 .8 .5;.4 .8 .5;.4 .8 .5];
    h2(5).FaceColor='flat'; h2(5).CData=[.6 .6 .6;.6 .6 .6;.6 .6 .6;.6 .6 .6];
    h2(6).FaceColor='flat'; h2(6).CData=[.9 .4 .3;.9 .4 .3;.9 .4 .3;.9 .4 .3];
    hold on 
    for k=1:size(h2,2)
        ctr(k,:) = bsxfun(@plus,h2(1).XData, h2(k).XOffset');
        ydt(k,:) = h2(k).YData;
    end
    
    eh2=errorbar(ctr',ydt',errorY,'-k','LineStyle','none','CapSize',0,'LineWidth',1); 
    
    set(gca, 'xticklabels',{'Overall', 'CTOA100', 'CTOA300'}, 'FontSize', 20)
    ylabel 'dprime'
    set(gca,'FontSize',14,'FontName','Times New Roman')
    ylim ([-1 4])
    grid on
    
elseif cueType==1       
%     figure(4); subplot 121
   y=[AccuracyValidtrials,AccuracyNeutraltrials, OverallCueEffect;
       AccuracyValidTrial_100, AccuracyNeuTrial_100, CueEffect_100;
       AccuracyValidTrial_300, AccuracyNeuTrial_300, CueEffect_300;
       AccuracyValidTrial_600, AccuracyNeuTrial_600, CueEffect_600];
    errorY=[errorValidTrials,errorNeutralTrials,errorOverallCueEffect;
            errAccValidTrial_100,errAccNeuTrial_100,errCueEff_100;
            errAccValidTrial_300,errAccNeuTrial_300,errCueEff_300;
            errAccValidTrial_600,errAccNeuTrial_600,errCueEff_600];
    hendo= bar(y,'grouped');
    hendo(1).FaceColor='flat'; hendo(1).CData=[0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5];
    hendo(2).FaceColor='flat'; hendo(2).CData=[0 0 0.7;0 0 0.7;0 0 0.7;0 0 0.7];    
    hendo(3).FaceColor='flat'; hendo(3).CData=[0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6];
    for k=1:size(hendo,2)
        ctr(k,:) = bsxfun(@plus,hendo(1).XData, hendo(k).XOffset');
        ydt(k,:) = hendo(k).YData;
    end
    hold on 
    errh=errorbar(ctr',ydt',errorY,'-k','LineStyle','none','CapSize',0,'LineWidth',1); 
    
    legend('Valid', 'Neutral','cueEff')
    set(gca, 'xticklabels',{'Overall', '100','300', '600'}, 'FontSize', 15)
    ylabel 'Accuracy (%)'
    set(gca, 'Fontsize',15)
    ylim ([-10 100])
    yticks (-10:10:100)
    grid on
%     hold on; subplot 122
figure(4);
    y=[dprime_ValidTrials, dprime_NeutralTrials, OverallCueEff_dp;...
       dprime_ValidTrial_100,dprime_NeutralTrial_100,dp_CueEffect_100;...
       dprime_ValidTrial_300,dprime_NeutralTrial_300,dp_CueEffect_300;...
       dprime_ValidTrial_600, dprime_NeutralTrial_600,dp_CueEffect_600];
   
   errorY = [errorValidTrials_dp,errorNeutralTrials_dp,errorOverallCueEffect_dp;
             errdprime_ValidTrial_100, errdprime_NeutralTrial_100,errdprime_allCueEff_100; 
             errdprime_ValidTrial_300, errdprime_NeutralTrial_300,errdprime_allCueEff_300; 
             errdprime_ValidTrial_600, errdprime_NeutralTrial_600,errdprime_allCueEff_600];%dp_errCueEff_300; 

    h2= bar(y,'grouped'); hold on 
    h2(1).FaceColor='flat'; h2(1).CData=[0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5;0.6 0.8 0.5];
    h2(2).FaceColor='flat'; h2(2).CData=[0 0 0.7;0 0 0.7;0 0 0.7;0 0 0.7];   
    h2(3).FaceColor='flat'; h2(3).CData=[0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6;0.1 0.6 0.6];
   
     
    for k=1:size(h2,2)
        ctr(k,:) = bsxfun(@plus,h2(1).XData, h2(k).XOffset');
        ydt(k,:) = h2(k).YData;
    end   
    eh2=errorbar(ctr',ydt',errorY,'-k','LineStyle','none','CapSize',0,'LineWidth',1); 
    
    set(gca, 'xticklabels',{'Overall','100', '300','600'})    
%     legend('Valid', 'Neutral')
    ylabel 'd'''    
    ylim ([0 3])
    legend('Valid', 'Neutral','cueEff')
    set(gca,'FontSize',14,'FontName','Times New Roman')
    grid on
end       

%% Fig 5

if adult && cueType==2
    figure(5);subplot 131
    h1=bar([1,2,3], [dp_CueEffect_50,dp_CueEffect_100,dp_CueEffect_300]);
    h1.FaceColor = [0.1 0.6 0.6];
    hold on 
    eh1=errorbar([dp_CueEffect_50,dp_CueEffect_100,dp_CueEffect_300],[dp_errCueEff_50, dp_errCueEff_100,dp_errCueEff_300],'-','LineStyle','none','CapSize',0,'LineWidth',1.2,'Color',[0.4660 0.6740 0.1880]);
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 16)
    ylabel 'd'''
    ylim ([-0 1.2])
    yticks (-0:.2:1.2)
    title('cueBenefit (V-N)')
    set(gca,'FontSize',14,'FontName','Times New Roman')
    grid on
    
    hold on; subplot 132
    h2=bar([1,2,3], [dp_CueEff_V2I_50,dp_CueEff_V2I_100,dp_CueEff_V2I_300]);
    h2.FaceColor = [0.9 0.8 0.2];
    hold on
    eh2=errorbar([dp_CueEff_V2I_50,dp_CueEff_V2I_100,dp_CueEff_V2I_300],[dp_errCueEff_V2I_50,dp_errCueEff_V2I_100,dp_errCueEff_V2I_300],'-k','LineStyle','none','CapSize',0,'LineWidth',1.2);
    set(gca, 'xticklabels',{'50', ' 100', '300'}, 'FontSize', 16)
    ylabel 'd'''
    xlabel 'Cue Target Onset Asynchrony (CTOA) in ms'
    ylim ([-0 1.2])
    yticks (-0.2:.2:1.2)
    title('CueEffect (V-I)')
    set(gca,'FontSize',14,'FontName','Times New Roman')
    grid on
    hold on; subplot 133
    
    h3=bar([1,2,3], [dp_cueCost_50,dp_cueCost_100,dp_cueCost_300]);
    h3.FaceColor=[0.8 0.2 0.8];
    hold on;
    eh3=errorbar([dp_cueCost_50,dp_cueCost_100,dp_cueCost_300],[dp_errcueCost_50,dp_errcueCost_100,dp_errcueCost_300],'-r','LineStyle','none','CapSize',0,'LineWidth',1.2);
    set(gca, 'xticklabels',{'50', '100', '300'}, 'FontSize', 20)
    ylabel 'd'''
    ylim ([-0 1.2])
    yticks (-0.2:.2:1.2)
    title('cueCost (N-I)')
    set(gca,'FontSize',14,'FontName','Times New Roman')
    grid on 
elseif ~adult && cueType==2
    figure(5);subplot 131
    h1=bar([1,2], [dp_CueEffect_100,dp_CueEffect_300]);
    h1.FaceColor = [0.4 0.8 0.5];
    hold on 
    errorbar([dp_CueEffect_100,dp_CueEffect_300],[dp_errCueEffect_100,dp_errCueEffect_300],'-','LineStyle','none','CapSize',0,'LineWidth',1.2,'Color',[0.4660 0.6740 0.1880]);
    set(gca, 'xticklabels',{'100', '300', '300'}, 'FontSize', 20)
    ylabel 'd'''
    ylim ([-20 50])
    yticks (0:10:50)
    title('cueBenefit (V-N)')
    grid on
    
    hold on; subplot 132
    h2=bar([1,2], [dp_CueEff_V2I_100,dp_CueEff_V2I_300]);
    h2.FaceColor = [0.6 0.6 0.6];
    hold on;
    eh2=errorbar([dp_CueEff_V2I_100,dp_CueEff_V2I_300],[dp_errCueEff_V2I_100,dp_errCueEff_V2I_300],'-k','LineStyle','none','CapSize',0,'LineWidth',1.2); 
    set(gca, 'xticklabels',{'100', '300'}, 'FontSize', 20)
    ylabel 'd'''
    xlabel 'Cue Target Onset Asynchrony (CTOA) in ms'
       ylim ([-1 4])
    yticks (-1:1:4)
    title('cueEffect (V-I)')
    grid on
    
    hold on; subplot 133
    h3=bar([1,2], [dp_cueCost_100,dp_cueCost_300]);
    h3.FaceColor=[0.8 0.6 0.3];
    hold on 
    eh3=errorbar([dp_cueCost_100,dp_cueCost_300],[dp_errcueCost_100,dp_errcueCost_300],'-r','LineStyle','none','CapSize',0,'LineWidth',1.2);
    set(gca, 'xticklabels',{'100', '300', '600'}, 'FontSize', 20)
    ylabel 'd'''
       ylim ([-1 4])
    yticks (-1:1:4)
    title('cueCost (N-I)')
    grid on
elseif cueType==1 
    figure(5);
    h2=bar([1,2,3], [dp_CueEffect_100,dp_CueEffect_300,dp_CueEffect_600]);
    h2.FaceColor = [0.1 0.6 0.6];
    hold on 
    eh1=errorbar([1,2,3],[dp_CueEffect_100,dp_CueEffect_300,dp_CueEffect_600],[dp_errCueEff_100,dp_errCueEff_300,dp_errCueEff_600],'-k','LineStyle','none','CapSize',0,'LineWidth',1.2); 

    set(gca, 'xticklabels',{'100','300','600'})
    set(gca,'FontSize',14,'FontName','Times New Roman')
    ylabel 'd'''
    xlabel 'CueTarget Onset Asynchrony (CTOA) in ms'
    xlim ([0 4])
    ylim ([0 1])
    yticks (0:.2:1)
    title('CueEffect/Benefit')
    grid on
end
 