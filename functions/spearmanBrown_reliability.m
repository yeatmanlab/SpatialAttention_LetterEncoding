function reliability = spearmanBrown_reliability(subject, cueType)
reliability.dprime_NeutralTrials_odd =[]; reliability.dprime_NeutralTrials_even=[];
reliability.dprime_ValidTrials_odd =[]; reliability.dprime_ValidTrials_even=[];
if cueType==2
    reliability.cueBen_odd=[]; reliability.cueBen_even=[];
    reliability.cueEff_odd=[]; reliability.cueEff_even=[];
    reliability.cueCst_odd=[]; reliability.cueCst_even=[];
    reliability.dprime_InVal_odd =[]; reliability.dprime_InVal_even=[];
    CTOA = [50, 100, 300];
    for n=1:length(CTOA)
        eval(['reliability.cueEff_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueEff_' num2str(CTOA(n)) '_even=[];'])
        eval(['reliability.cueCst_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueCst_' num2str(CTOA(n)) '_even=[];'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_even=[];'])
    end
elseif cueType==1
    reliability.cueBen_odd=[]; reliability.cueBen_even=[];
    
    CTOA = [100, 300, 600];
    for n=1:length(CTOA)
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_even=[];'])
    end
elseif cueType ==3 
     reliability.cueBen_odd=[]; reliability.cueBen_even=[];
     reliability.cueEff_odd=[]; reliability.cueEff_even=[];
    reliability.cueCst_odd=[]; reliability.cueCst_even=[];
    reliability.dprime_InVal_odd =[]; reliability.dprime_InVal_even=[];
    CTOA = [50, 100];
    for n=1:length(CTOA)
        eval(['reliability.cueEff_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueEff_' num2str(CTOA(n)) '_even=[];'])
        eval(['reliability.cueCst_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueCst_' num2str(CTOA(n)) '_even=[];'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_odd=[];'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_even=[];'])
    end
    
end
for s=1:length(subject)
    this_neut_odd = subject(s).reliability.dprime_NeutralTrials_odd;
    reliability.dprime_NeutralTrials_odd =[reliability.dprime_NeutralTrials_odd; this_neut_odd];
    this_neut_even = subject(s).reliability.dprime_NeutralTrials_even;
    reliability.dprime_NeutralTrials_even =[reliability.dprime_NeutralTrials_even; this_neut_even];
    
    this_Val_odd = subject(s).reliability.dprime_ValidTrials_odd;
    reliability.dprime_ValidTrials_odd =[reliability.dprime_ValidTrials_odd; this_Val_odd];
    this_Val_even = subject(s).reliability.dprime_ValidTrials_even;
    reliability.dprime_ValidTrials_even =[reliability.dprime_ValidTrials_even; this_Val_even];
   
    this_cueBen_odd = subject(s).reliability.cueBen_odd;
    reliability.cueBen_odd =[reliability.cueBen_odd; this_cueBen_odd];
    this_cueBen_even = subject(s).reliability.cueBen_even;
    reliability.cueBen_even =[reliability.cueBen_even; this_cueBen_even];
    
    
    for n=1:length(CTOA)
        eval(['this_cueBen_odd_' num2str(CTOA(n))             '= subject(s).reliability.cueBen_' num2str(CTOA(n)) '_odd;'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_odd       =[reliability.cueBen_' num2str(CTOA(n)) '_odd; this_cueBen_odd_' num2str(CTOA(n)) '];'])
        eval(['this_cueBen_even_' num2str(CTOA(n))             '= subject(s).reliability.cueBen_' num2str(CTOA(n)) '_even;'])
        eval(['reliability.cueBen_' num2str(CTOA(n)) '_even      =[reliability.cueBen_' num2str(CTOA(n)) '_even; this_cueBen_even_' num2str(CTOA(n)) '];'])
    end
    
    if cueType==2 || cueType==3
        this_InVal_odd = subject(s).reliability.dprime_InVtrials_odd;
        reliability.dprime_InVal_odd =[reliability.dprime_InVal_odd; this_InVal_odd];
        this_InVal_even = subject(s).reliability.dprime_InVtrials_even;
        reliability.dprime_InVal_even =[reliability.dprime_InVal_even; this_InVal_even];
        
        
        this_cueEff_odd = subject(s).reliability.cueEff_odd;
        reliability.cueEff_odd =[reliability.cueEff_odd; this_cueEff_odd];
        this_cueEff_even = subject(s).reliability.cueEff_even;
        reliability.cueEff_even =[reliability.cueEff_even; this_cueEff_even];
        
        this_cueCst_odd        = subject(s).reliability.cueCst_odd;
        reliability.cueCst_odd =[reliability.cueCst_odd; this_cueCst_odd];
        this_cueCst_even       = subject(s).reliability.cueCst_even;
        reliability.cueCst_even =[reliability.cueCst_even; this_cueCst_even];
        
        for n=1:length(CTOA)
            eval(['this_cueCst_odd_' num2str(CTOA(n)) '= subject(s).reliability.cueCst_' num2str(CTOA(n)) '_odd;'])
            eval(['reliability.cueCst_' num2str(CTOA(n)) '_odd =[reliability.cueCst_' num2str(CTOA(n)) '_odd; this_cueCst_odd_' num2str(CTOA(n)) '];'])
            eval(['this_cueCst_even_' num2str(CTOA(n)) '= subject(s).reliability.cueCst_' num2str(CTOA(n)) '_even;'])
            eval(['reliability.cueCst_' num2str(CTOA(n)) '_even =[reliability.cueCst_' num2str(CTOA(n)) '_even; this_cueCst_even_' num2str(CTOA(n)) '];'])
        end
    end
end
reliability.rho_dpN= corr(reliability.dprime_NeutralTrials_odd,reliability.dprime_NeutralTrials_even);
reliability.spearman_BrownN_dp= 2*reliability.rho_dpN/(1+reliability.rho_dpN);

reliability.rho_dpV= corr(reliability.dprime_ValidTrials_odd,reliability.dprime_ValidTrials_even);
reliability.spearman_BrownV_dp= 2*reliability.rho_dpV/(1+reliability.rho_dpV);

reliability.rho_cB= corr(reliability.cueBen_even,reliability.cueBen_odd);
reliability.spearman_Brown_dpcB= 2*reliability.rho_cB/(1+reliability.rho_cB);

for n=1:length(CTOA)
    eval(['reliability.rho_cueBen' num2str(CTOA(n)) '= corr(reliability.cueBen_' num2str(CTOA(n)) '_even,reliability.cueBen_' num2str(CTOA(n)) '_odd);'])
    eval(['reliability.spearmanBrown_cueBen' num2str(CTOA(n)) '= 2*reliability.rho_cueBen' num2str(CTOA(n)) '/(1+reliability.rho_cueBen' num2str(CTOA(n)) ');'])
end
    if cueType==2 || cueType==3
        
     reliability.rho_dpInV= corr(reliability.dprime_InVal_even,reliability.dprime_InVal_odd);
     reliability.spearman_BrownInV_dp= 2*reliability.rho_dpInV/(1+reliability.rho_dpInV);

    reliability.rho_cueEff = corr(reliability.cueEff_even,reliability.cueEff_odd);
    reliability.spearmanBrown_cueEff = 2*reliability.rho_cueEff/(1+reliability.rho_cueEff);    

    reliability.rho_cueCst = corr(reliability.cueCst_even, reliability.cueCst_odd);
    reliability.spearmanBrown_cueCst = 2*reliability.rho_cueCst/(1+reliability.rho_cueCst);
    end
