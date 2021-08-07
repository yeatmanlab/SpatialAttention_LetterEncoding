function Wprofile= plot_Wprofile(cueType,adult,endo,exo)
% for individual visualizations there are no error bars associated, when
%{
analyzing group stats need to add error bars
varargin - pass the structure endo or exo based on what paradigm you are
looking into



%}
% copyright Maha Ramamurthy, Stanford University, 2020

if cueType==1
    CTOA = endo.ctoa;
    for p=1:6
        eval(['Acc_pos' num2str(p) '_Neutral    = endo.Acc_pos' num2str(p) '_Neutral;'])
        eval(['Acc_pos' num2str(p) '_Valid      = endo.Acc_pos' num2str(p) '_Valid;'])
        eval(['dprime_' num2str(p) '_Neutral    = endo.dprime_' num2str(p) '_Neutral;'])
        eval(['dprime_' num2str(p) '_Valid      = endo.dprime_' num2str(p) '_Valid;'])
        
        for i=1:length(CTOA)
            eval(['acc' num2str(p) '_Neu_' num2str(CTOA(i))        '= endo.acc' num2str(p) '_Neu_' num2str(CTOA(i)) ';'])
            eval(['acc' num2str(p) '_Val_' num2str(CTOA(i))        '= endo.acc' num2str(p) '_Val_' num2str(CTOA(i)) ';'])
            eval(['dp' num2str(p) '_Neu_' num2str(CTOA(i))         '= endo.dp' num2str(p) '_Neu_' num2str(CTOA(i)) ';'])
            eval(['dp' num2str(p) '_Val_' num2str(CTOA(i))         '= endo.dp' num2str(p) '_Val_' num2str(CTOA(i)) ';'])
        end
    end
elseif cueType==2 || cueType==3
    CTOA = exo.ctoa;
    for p=1:6
        eval(['Acc_pos' num2str(p) '_Neutral = exo.Acc_pos' num2str(p) '_Neutral;'])
        eval(['Acc_pos' num2str(p) '_Valid   = exo.Acc_pos' num2str(p) '_Valid;'])
        eval(['Acc_pos' num2str(p) '_InVal   = exo.Acc_pos' num2str(p) '_InVal;'])
        eval(['dprime_' num2str(p) '_Neutral = exo.dprime_' num2str(p) '_Neutral;'])
        eval(['dprime_' num2str(p) '_Valid   = exo.dprime_' num2str(p) '_Valid;'])
        eval(['dprime_' num2str(p) '_InVal   = exo.dprime_' num2str(p) '_InVal;'])
        for i=1:length(CTOA)
            eval(['acc' num2str(p) '_Neu_' num2str(CTOA(i))        '= exo.acc' num2str(p) '_Neu_' num2str(CTOA(i)) ';'])
            eval(['acc' num2str(p) '_Val_' num2str(CTOA(i))        '= exo.acc' num2str(p) '_Val_' num2str(CTOA(i)) ';'])
            eval(['acc' num2str(p) '_InV_' num2str(CTOA(i))        '= exo.acc' num2str(p) '_InV_' num2str(CTOA(i)) ';'])
            eval(['dp' num2str(p) '_Neu_' num2str(CTOA(i))         '= exo.dp' num2str(p) '_Neu_' num2str(CTOA(i)) ';'])
            eval(['dp' num2str(p) '_Val_' num2str(CTOA(i))         '= exo.dp' num2str(p) '_Val_' num2str(CTOA(i)) ';'])
            eval(['dp' num2str(p) '_InV_' num2str(CTOA(i))         '= exo.dp' num2str(p) '_InV_' num2str(CTOA(i)) ';'])
        end
    end
end
figure(6); subplot 241;
matValid_overall = [Acc_pos1_Valid, Acc_pos2_Valid,Acc_pos3_Valid,Acc_pos4_Valid,Acc_pos5_Valid,Acc_pos6_Valid];
matNeutl_overall = [Acc_pos1_Neutral,Acc_pos2_Neutral, Acc_pos3_Neutral,Acc_pos4_Neutral,Acc_pos5_Neutral, Acc_pos6_Neutral];


scatter([1 2 3 4 5 6], matNeutl_overall)
line([1 2 3 4 5 6], matNeutl_overall,'Color',[0 0 0.7])
hold on
scatter([1 2 3 4 5 6], matValid_overall)
line([1 2 3 4 5 6], matValid_overall,'Color', [0.6 0.8 0.5])
hold on
if cueType ==2 || cueType==3
    matInVal_overall = [Acc_pos1_InVal, Acc_pos2_InVal,Acc_pos3_InVal,Acc_pos4_InVal,Acc_pos5_InVal,Acc_pos6_InVal];
    scatter([1 2 3 4 5 6], matInVal_overall)
    line([1 2 3 4 5 6], matInVal_overall,'Color', 'r')
end
% % scatter([1 2 3 4 5 6],...
% %      [Acc_pos1_Valid-Acc_pos1_Neutral, Acc_pos2_Valid-Acc_pos2_Neutral,Acc_pos3_Valid-Acc_pos3_Neutral,Acc_pos4_Valid-Acc_pos4_Neutral,Acc_pos5_Valid-Acc_pos5_Neutral,Acc_pos6_Valid-Acc_pos6_Neutral])
% %  line([1 2 3 4 5 6],[Acc_pos1_Valid-Acc_pos1_Neutral, Acc_pos2_Valid-Acc_pos2_Neutral,Acc_pos3_Valid-Acc_pos3_Neutral,Acc_pos4_Valid-Acc_pos4_Neutral,Acc_pos5_Valid-Acc_pos5_Neutral,Acc_pos6_Valid-Acc_pos6_Neutral],...
% %             'Color', 'c')
xlabel 'String positions'
ylabel 'Accuracy (%)'
xlim([0 8])
ylim([0 100])
xticks (1:1:6)
grid on
title('Overall Position Profiles');
posMatrix =[1 2 3 4 5 6];


for n=1:length(CTOA)
    eval(['matNeutral_' num2str(CTOA(n)) '= [acc1_Neu_'  num2str(CTOA(n)) ',acc2_Neu_'  num2str(CTOA(n)) ',acc3_Neu_'  num2str(CTOA(n)) ',acc4_Neu_'  num2str(CTOA(n)) ',acc5_Neu_'  num2str(CTOA(n)) ', acc6_Neu_'  num2str(CTOA(n)) '];'])
    eval(['matValid_'  num2str(CTOA(n)) '= [acc1_Val_' num2str(CTOA(n)) ', acc2_Val_' num2str(CTOA(n)) ',acc3_Val_' num2str(CTOA(n)) ',acc4_Val_' num2str(CTOA(n)) ',acc5_Val_' num2str(CTOA(n)) ',acc6_Val_' num2str(CTOA(n)) '];'])
    if cueType==2 || cueType==3
        eval(['matInvalid_' num2str(CTOA(n)) '= [acc1_InV_' num2str(CTOA(n)) ', acc2_InV_' num2str(CTOA(n)) ',acc3_InV_' num2str(CTOA(n)) ',acc4_InV_' num2str(CTOA(n)) ',acc5_InV_' num2str(CTOA(n)) ',acc6_InV_' num2str(CTOA(n)) '];'])
    end
end
if adult && cueType==3
    hold on; subplot 242
    scatter(posMatrix, matNeutral_50)
    line(posMatrix, matNeutral_50,'Color','b')
    hold on
    scatter(posMatrix, matValid_50)
    line(posMatrix, matValid_50,'Color', 'g')
    hold on
    if cueType ==2 ||cueType==3
        scatter(posMatrix, matInvalid_50)
        line(posMatrix, matInvalid_50,'Color', 'r')
    end
    
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:50ms Position Profiles');
    hold on; subplot 243
    
    scatter(posMatrix, matNeutral_100)
    line(posMatrix, matNeutral_100,'Color','b')
    hold on
    scatter(posMatrix, matValid_100)
    line(posMatrix, matValid_100,'Color', 'g')
    hold on
    
    if cueType ==2 ||cueType==3
        scatter(posMatrix, matInvalid_100)
        line(posMatrix, matInvalid_100,'Color', 'r')
    end
    
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:100ms Position Profiles');
end

if adult && cueType ==2
    hold on; subplot 242
    scatter(posMatrix, matNeutral_50)
    line(posMatrix, matNeutral_50,'Color','b')
    hold on
    scatter(posMatrix, matValid_50)
    line(posMatrix, matValid_50,'Color', 'g')
    hold on
    if cueType ==2 ||cueType==3
        scatter(posMatrix, matInvalid_50)
        line(posMatrix, matInvalid_50,'Color', 'r')
    end
    
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:50ms Position Profiles');
    
    hold on; subplot 243
    scatter(posMatrix, matNeutral_100)
    line(posMatrix, matNeutral_100,'Color','b')
    hold on
    scatter(posMatrix, matValid_100)
    line(posMatrix, matValid_100,'Color', 'g')
    hold on
    if cueType ==2 ||cueType==3
        scatter(posMatrix, matInvalid_100)
        line(posMatrix, matInvalid_100,'Color', 'r')
    end
    
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:100ms Position Profiles');

    hold on; subplot 244
    scatter(posMatrix, matNeutral_300)
    line(posMatrix, matNeutral_300,'Color','b')
    hold on
    scatter(posMatrix, matValid_300)
    line(posMatrix, matValid_300,'Color', 'g')
    hold on
    if cueType ==2 || cueType==3
        scatter(posMatrix, matInvalid_300)
        line(posMatrix, matInvalid_300,'Color', 'r')
    end
    
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:300ms Position Profiles')
end

if  cueType==1
    
    hold on; subplot 242
    scatter(posMatrix, matNeutral_100)
    line(posMatrix, matNeutral_100,'Color','b')
    hold on
    scatter(posMatrix, matValid_100)
    line(posMatrix, matValid_100,'Color', 'g')
    hold on
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:100ms Position Profiles');
    
    hold on; subplot 243
    scatter(posMatrix, matNeutral_300)
    line(posMatrix, matNeutral_300,'Color','b')
    hold on
    scatter(posMatrix, matValid_300)
    line(posMatrix, matValid_300,'Color', 'g')    
    hold on 
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title('CTOA:300ms Position Profiles')
    
    hold on ; subplot 244
    scatter(posMatrix, matNeutral_600)
    line(posMatrix, matNeutral_600,'Color','b')
    hold on
    scatter(posMatrix, matValid_600)
    line(posMatrix, matValid_600,'Color', 'g')
    hold on
    
    xlabel 'String positions'
    ylabel 'Accuracy (%)'
    xlim([0 8])
    ylim([0 100])
    xticks (1:1:6)
    grid on
    title ('CTOA: 600ms Position Profiles')
end


hold on; subplot 245
matValdp_overall = [dprime_1_Valid, dprime_2_Valid,dprime_3_Valid,dprime_4_Valid,dprime_5_Valid,dprime_6_Valid];
matNeudp_overall = [dprime_1_Neutral,dprime_2_Neutral, dprime_3_Neutral,dprime_4_Neutral,dprime_5_Neutral, dprime_6_Neutral];
if cueType==2 ||cueType==3
    matInVdp_overall = [dprime_1_InVal, dprime_2_InVal,dprime_3_InVal,dprime_4_InVal,dprime_5_InVal,dprime_6_InVal];
end
scatter([1 2 3 4 5 6], matNeudp_overall)
line([1 2 3 4 5 6],matNeudp_overall ,'Color','b')
hold on
scatter([1 2 3 4 5 6],matValdp_overall )
line([1 2 3 4 5 6], matValdp_overall,'Color', 'g')
hold on
if cueType ==2 || cueType==3
    scatter([1 2 3 4 5 6],matInVdp_overall)
    line([1 2 3 4 5 6], matInVdp_overall,'Color', 'r')
end

xlabel 'String positions'
ylabel 'Sensitivity(dprime)'
xlim([0 8])
ylim([-2 4])
xticks (1:1:6)
grid on
title('Overall PP - dprime');


%---% Calculate dprime for all CTOAs ---%
for n=1:length(CTOA)
    eval(['matNeudp_' num2str(CTOA(n)) '= [dp1_Neu_' num2str(CTOA(n)) ',dp2_Neu_' num2str(CTOA(n)) ', dp3_Neu_' num2str(CTOA(n)) ',dp4_Neu_' num2str(CTOA(n)) ',dp5_Neu_' num2str(CTOA(n)) ', dp6_Neu_' num2str(CTOA(n)) '];'])
    eval(['matValdp_'  num2str(CTOA(n)) '= [dp1_Val_' num2str(CTOA(n)) ', dp2_Val_' num2str(CTOA(n)) ',dp3_Val_' num2str(CTOA(n)) ',dp4_Val_' num2str(CTOA(n)) ',dp5_Val_' num2str(CTOA(n)) ',dp6_Val_' num2str(CTOA(n)) '];'])
    if cueType==2 || cueType==3
        eval(['matInvaldp_' num2str(CTOA(n)) '= [dp1_InV_' num2str(CTOA(n)) ', dp2_InV_' num2str(CTOA(n)) ',dp3_InV_' num2str(CTOA(n)) ',dp4_InV_' num2str(CTOA(n)) ',dp5_InV_' num2str(CTOA(n)) ',dp6_InV_' num2str(CTOA(n)) '];'])
    end
end
if  ~adult && cueType==3
    hold on; subplot 246;
    scatter(posMatrix, matNeudp_50)
    line(posMatrix, matNeudp_50,'Color','b')
    hold on
    scatter(posMatrix, matValdp_50)
    hold on
    line(posMatrix, matValdp_50,'Color', 'g')
    hold on
    if cueType==2 || cueType==3
        scatter(posMatrix, matInvaldp_50)
        line(posMatrix, matInvaldp_50,'Color', 'r')
    end
    xlabel 'String positions'
    ylabel 'Sensitivity(dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:50 Position Profile - dPrime');
    hold on; subplot 247;
    scatter(posMatrix, matNeudp_100)
    line(posMatrix, matNeudp_100,'Color','b')
    hold on
    scatter(posMatrix, matValdp_100)
    hold on
    line(posMatrix, matValdp_100,'Color', 'g')
    hold on
    if cueType==2 || cueType==3
        scatter(posMatrix, matInvaldp_100)
        line(posMatrix, matInvaldp_100,'Color', 'r')
    end
    xlabel 'String positions'
    ylabel 'Sensitivity(dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:100 Position Profile - dPrime');
end

if adult && cueType==2 
    hold on; subplot 246;
    scatter(posMatrix, matNeudp_50)
    line(posMatrix, matNeudp_50,'Color','b')
    hold on
    scatter(posMatrix, matValdp_50)
    hold on
    line(posMatrix, matValdp_50,'Color', 'g')
    hold on
    if cueType==2 || cueType==3
        scatter(posMatrix, matInvaldp_50)
        line(posMatrix, matInvaldp_50,'Color', 'r')
    end
    xlabel 'String positions'
    ylabel 'Sensitivity(dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:50 Position Profile - dPrime');
    
    hold on; subplot 247;
    scatter(posMatrix, matNeudp_100)
    line(posMatrix, matNeudp_100,'Color','b')
    hold on
    scatter(posMatrix, matValdp_100)
    hold on
    line(posMatrix, matValdp_100,'Color', 'g')
    hold on
    if cueType==2 || cueType==3
        scatter(posMatrix, matInvaldp_100)
        line(posMatrix, matInvaldp_100,'Color', 'r')
    end
    xlabel 'String positions'
    ylabel 'Sensitivity(dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:100 Position Profile - dPrime');

    hold on ; subplot 248
    scatter(posMatrix, matNeudp_300)
    line(posMatrix, matNeudp_300,'Color','b')
    hold on
    scatter(posMatrix, matValdp_300)
    line(posMatrix, matValdp_300,'Color', 'g')
    hold on
    if cueType==2 || cueType==3
        scatter(posMatrix, matInvaldp_300)
        line(posMatrix, matInvaldp_300,'Color', 'r')
    end
    xlabel 'String positions'
    ylabel 'Sensitivity (dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:300ms Position Profile - dPrime');
end

if cueType==1
    hold on; subplot 246;
    scatter(posMatrix, matNeudp_100)
    line(posMatrix, matNeudp_100,'Color','b')
    hold on
    scatter(posMatrix, matValdp_100)
    hold on
    line(posMatrix, matValdp_100,'Color', 'g')
    hold on
    xlabel 'String positions'
    ylabel 'Sensitivity(dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:100 Position Profile - dPrime');
    
    hold on ; subplot 247
    scatter(posMatrix, matNeudp_300)
    line(posMatrix, matNeudp_300,'Color','b')
    hold on
    scatter(posMatrix, matValdp_300)
    line(posMatrix, matValdp_300,'Color', 'g')
    hold on
    xlabel 'String positions'
    ylabel 'Sensitivity (dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:300ms Position Profile - dPrime');
  
    hold on; subplot 248
    scatter(posMatrix, matNeudp_600)
    line(posMatrix, matNeudp_600,'Color','b')
    hold on
    scatter(posMatrix, matValdp_600)
    line(posMatrix, matValdp_600,'Color', 'g')
    hold on
    
    xlabel 'String positions'
    ylabel 'Sensitivity (dprime)'
    xlim([0 8])
    ylim([-2 6])
    xticks (1:1:6)
    grid on
    title('CTOA:600ms Position Profile - dPrime')
end
if ~adult && cueType==2
    W_accuracy = [matValid_overall; matNeutl_overall; matInVal_overall; matValid_100; matNeutral_100; matInvalid_100; matValid_300; matNeutral_300; matInvalid_300];
    W_dprime   = [matValdp_overall;matNeudp_overall;matInVdp_overall;matValdp_100;matNeudp_100;matInvaldp_100;matValdp_300;matNeudp_300; matInvaldp_300];
elseif adult && cueType==2
    W_accuracy = [matValid_overall; matNeutl_overall; matInVal_overall; matValid_50; matNeutral_50; matInvalid_50; matValid_100; matNeutral_100; matInvalid_100; matValid_300; matNeutral_300; matInvalid_300];
    W_accuracy = array2table(W_accuracy,'VariableNames',{'pos1','pos2','pos3','pos4','pos5','pos6'}); %,'RowNames', {'Validall','Neutall','InValidall','Valid50','Neut50','InValid50','Valid100', 'Neut100','InValid100','Valid300','Neut300','InValid300'});
    W_dprime   = [matValdp_overall;matNeudp_overall;matInVdp_overall; matValdp_50;matNeudp_50;matInvaldp_50; matValdp_100;matNeudp_100;matInvaldp_100;matValdp_300;matNeudp_300; matInvaldp_300];
    W_dprime   = array2table(W_dprime,'VariableNames',{'pos1','pos2','pos3','pos4','pos5','pos6'}); %,'RowNames', {'Validall','Neutall','InValidall','Valid50','Neut50','InValid50','Valid100', 'Neut100','InValid100','Valid300','Neut300','InValid300'});
elseif cueType==1
    W_accuracy = [matValid_overall; matNeutl_overall;matValid_100; matNeutral_100;matValid_300; matNeutral_300; matValid_600; matNeutral_600];
    W_accuracy = array2table(W_accuracy,'VariableNames',{'pos1','pos2','pos3','pos4','pos5','pos6'}); %,'RowNames', {'Validall','Neutall','InValidall','Valid100', 'Neut100','InValid100','Valid300','Neut300','InValid300','Valid600','Neut600','InValid600',});
    W_dprime   = [matValdp_overall; matNeudp_overall;matValdp_100;matNeudp_100;matValdp_300;matNeudp_300; matValdp_600;matNeudp_600];
    W_dprime = array2table(W_dprime,'VariableNames',{'pos1','pos2','pos3','pos4','pos5','pos6'}); %,'RowNames', {'Validall','Neutall','InValidall','Valid100', 'Neut100','InValid100','Valid300','Neut300','InValid300','Valid600','Neut600','InValid600',});
elseif cueType==3 
    W_accuracy = [matValid_overall; matNeutl_overall; matInVal_overall; matValid_50; matNeutral_50; matInvalid_50; matValid_100; matNeutral_100; matInvalid_100];
    W_dprime   = [matValdp_overall;matNeudp_overall;matInVdp_overall;matValdp_50;matNeudp_50;matInvaldp_50;matValdp_100;matNeudp_100; matInvaldp_100];
    
end
Wprofile.accuracy = W_accuracy;
Wprofile.dprime   = W_dprime;
