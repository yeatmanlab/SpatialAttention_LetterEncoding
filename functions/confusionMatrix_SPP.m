%% % Confusion matrix %%%
% Get the errror Trials and make a position matrix that gives information
% about position swaps and misidentified errors...
function  errTable = confusionMatrix_SPP(cueType,endo,exo,online,subject)      % errTable = confusionMatrix_SPP(cueType,adult,endo,exo)
errTable = table;thisRun =[];
if cueType==1 && online==0
    InCxValidTrials  = endo.InCxValidTrials;
    CxValidTrials    = endo.CxValidTrials;
    ValidTrials      = endo.ValidTrials;
    InCxNeutTrials   = endo.InCxNeutTrials;
    CxNeutTrials     = endo.CxNeutTrials;
    NeutralTrials    = endo.NeutralTrials;
    CTOA             = endo.ctoa;
    for n=1:length(CTOA)
        eval(['ValidTrials_' num2str(CTOA(n)) '=endo.ValidTrials_' num2str(CTOA(n)) ';' ])
        eval(['NeutralTrials_' num2str(CTOA(n)) '= endo.NeutralTrials_' num2str(CTOA(n)) ';'])
    end
    
elseif cueType==2 && online==0
    InCxInVTrials    = exo.InCxInVTrials;
    CxInVTrials      = exo.CxInVTrials;
    InvalidTrials    = exo.InvalidTrials;
    
    InCxValidTrials  = exo.InCxValidTrials;
    CxValidTrials    = exo.CxValidTrials;
    ValidTrials      = exo.ValidTrials;
    InCxNeutTrials   = exo.InCxNeutTrials;
    CxNeutTrials     = exo.CxNeutTrials;
    NeutralTrials    = exo.NeutralTrials;
    CTOA             = exo.ctoa;
    
    for i=1:length(CTOA)
        eval(['ValidTrials_' num2str(CTOA(i))   '=exo.ValidTrials_' num2str(CTOA(i)) ';' ])
        eval(['NeutralTrials_' num2str(CTOA(i)) '= exo.NeutralTrials_' num2str(CTOA(i)) ';'])
        eval(['InValTrials_' num2str(CTOA(i))   '= exo.InValTrials_' num2str(CTOA(i)) ';'])
    end
    
end

targetPositions = [1 2 3 4 5 6]';
for pos=1:6
    errResponsePosV = []; misIdletterV=[]; posTracker =[];
    %% __________________________________________
    %Valid trial types
    eval(['pos' num2str(pos) '_validTrialsInCx    = InCxValidTrials(InCxValidTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['pos' num2str(pos) '_validTrialsCx      = CxValidTrials(CxValidTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['countNumCx' mat2str(pos) '= size(pos' mat2str(pos) '_validTrialsCx,1);'])
    for n=1:eval(['size(pos' num2str(pos) '_validTrialsInCx,1)'])
        if online==0
            posTracker = eval(['strfind(pos' num2str(pos) '_validTrialsInCx.string{n},char(pos' num2str(pos) '_validTrialsInCx.chosenRes(n)));']);
        else
            eval(['currString=pos' num2str(pos) '_validTrialsInCx.string{' num2str(n) '};'])
            posTracker = eval(['strfind(currString(3:8),char(pos' num2str(pos) '_validTrialsInCx.RecordedResp(n)));']);
        end
        if isempty(posTracker)
            if online==0 
                misIdletterV = eval(['[misIdletterV; pos' num2str(pos) '_validTrialsInCx.CxResp(n), char(pos' num2str(pos) '_validTrialsInCx.chosenRes(n))];']);
            else
                misIdletterV = eval(['[misIdletterV; pos' num2str(pos) '_validTrialsInCx.CxResp(n), char(pos' num2str(pos) '_validTrialsInCx.RecordedResp(' num2str(n) '))];']);
            end
            posTracker=0;
            if cell2mat(misIdletterV) == 0
                misIdletterV= [];
            end
        end
        errResponsePosV =[errResponsePosV; posTracker];
    end
    eval(['errTrials_posSwapsV_' num2str(pos) '= nnz(errResponsePosV)'])
    if numel(errResponsePosV)==1
        dummyVector=zeros(size(targetPositions));
        dummyVector(1,1)=errResponsePosV;
        errResponsePosV=dummyVector;
    end
    eval(['errRespV_' num2str(pos)      '= histc(errResponsePosV(:), targetPositions)'])
    eval(['errTrials_misIdentV_' num2str(pos) '= size(misIdletterV,1);'])
end
NuminCx_Valid                             = size(InCxValidTrials,1);
poSwap_Vmat                               = [errRespV_1';errRespV_2';errRespV_3'; errRespV_4';errRespV_5';errRespV_6'];
Swaps_cuedSide                            = (sum(sum(poSwap_Vmat(1:3,1:3)+poSwap_Vmat(4:6,4:6)))/sum(sum(poSwap_Vmat,2)))*100;
Swaps_NcueSide                            = (sum(sum(poSwap_Vmat(1:3,4:6)+poSwap_Vmat(4:6,1:3)))/sum(sum(poSwap_Vmat,2)))*100;
pCx_Lt                                    = (sum([countNumCx1, countNumCx2, countNumCx3])/size(CxValidTrials,1))*100;
pCx_Rt                                    = (sum([countNumCx4, countNumCx5, countNumCx6])/size(CxValidTrials,1))*100;
SwapPos_Vmat                              = sum(poSwap_Vmat,2);
%% Adding a second matrix that only sums the swap errors from the adjacent
%positions
%GEt the Indx of those adjacent positions and them sum them to give you the
%count matrix
Adj1_indx=find(eye(size(poSwap_Vmat)))-1;
Adj1_indx=Adj1_indx(Adj1_indx~=0);
Adj2_indx= find(eye(size(poSwap_Vmat)))+1;
Adj2_indx=Adj2_indx(Adj2_indx~=37);
AdjPosSwaps_V = zeros(size(poSwap_Vmat));

AdjPosSwaps_V(Adj1_indx) = poSwap_Vmat(Adj1_indx);
AdjPosSwaps_V(Adj2_indx) = poSwap_Vmat(Adj2_indx);

SwapPos_Vmat2 = sum(AdjPosSwaps_V,2);

%%
p_Pswp                                    = sum(SwapPos_Vmat);%/NuminCx_Valid)*100;
poSwap_Vmat(find(eye(size(poSwap_Vmat)))) = [countNumCx1, countNumCx2, countNumCx3, countNumCx4, countNumCx5, countNumCx6];
misID_Vmat                                = [errTrials_misIdentV_1;errTrials_misIdentV_2;errTrials_misIdentV_3; errTrials_misIdentV_4;errTrials_misIdentV_5;errTrials_misIdentV_6];
if any(misID_Vmat==0)
    indx= find(misID_Vmat==0);
    %        misID_Vmat(indx,:) =1;
end
p_mId                                     = (sum(misID_Vmat));%/NuminCx_Valid)*100;
err_ratio_Vpos                            = SwapPos_Vmat./misID_Vmat;
errMatrix_Valid                           = [poSwap_Vmat, misID_Vmat, err_ratio_Vpos];
errMatrix_Valid                           = [poSwap_Vmat];
sumMatrix_Valid                           = sum(errMatrix_Valid,2);
errMatrix_Valid                           = errMatrix_Valid; %,sumMatrix_Valid];
err_ratio                                 = p_Pswp/p_mId;
swp_ratio                                 = Swaps_cuedSide/Swaps_NcueSide;

errTable.TotV       = size(ValidTrials,1);
errTable.IncxV      = NuminCx_Valid;
errTable.pSwapV     = p_Pswp./size(ValidTrials,1);
errTable.misidV     = p_mId./size(ValidTrials,1); % *(NuminCx_Valid/100);
errTable.swTarV     = Swaps_cuedSide; %this is also the cued side for the valid condition
errTable.swNtarV    = Swaps_NcueSide; %this is also the non-cued side for the valid condition
%     errTable.S2M_V_1    = err_ratio_Vpos(1);
%     errTable.S2M_V_2    = err_ratio_Vpos(2);
%     errTable.S2M_V_3    = err_ratio_Vpos(3);
%     errTable.S2M_V_4    = err_ratio_Vpos(4);
%     errTable.S2M_V_5    = err_ratio_Vpos(5);
%     errTable.S2M_V_6    = err_ratio_Vpos(6);
errTable.SwapPos_Vmat = {SwapPos_Vmat};
errTable.SwapPos_Vmat2 = {SwapPos_Vmat2};
errTable.misID_Vmat   ={misID_Vmat};
errTable.Swap_matV= {errMatrix_Valid};
% In case you want the error matrix as accuracy: errMatrix_Valid = (errMatrix_Valid./sumMatrix_Valid).*100;
figure(7); subplot 431;
fighandle=heatmap(errMatrix_Valid);
colormap(fighandle, gray)
fighandle.YLabel ='TargetPosition';
fighandle.XDisplayLabels = {'1', '2', '3', '4', '5', '6'};% 'misID','pS/misID'};%, 'TT'};
fighandle.Title = ['p_Pswp/p_misID= ' num2str(err_ratio)];

figure(8); subplot 431;
%     yy=[(size(CxValidTrials,1)/size(ValidTrials,1))*100;(NuminCx_Valid/size(ValidTrials,1))*100; p_Pswp ; p_mId;Swaps_cuedSide;Swaps_Ncueside;Swaps_fromRt;Swaps_fromLt];
yy=[(NuminCx_Valid/size(ValidTrials,1))*100; p_Pswp ; p_mId;Swaps_cuedSide;Swaps_NcueSide;pCx_Rt;pCx_Rt];
bar(yy)
ylabel '(%)'
ylim ([0 100])
yticks (0:20:100)
xlim ([0 8])
xticks(1:1:7)
xtickangle(45)
set(gca, 'xticklabels',{'%Incx', 'pPosSwaps','pmisID','pSwp_cuedside','pSwp_ncueSide','pCx_Rt','pCx_Lt'}, 'FontSize', 10)
title(['All ValidTrials: ' num2str(swp_ratio)])
grid on

%{
    subplot 462
    h=heatmap([misID_Vmat sumMatrix_Valid],'Colormap',white);
    h.ColorbarVisible = 'off';
    h.XDisplayLabels = {'misIdentified Letter', 'TotalTrials@eachPosition'};
%}
%% __________________________________________
%Neutral trial types; Also make one matrix for each CTOA may be all
%these can be in one figure

for pos=1:6
    errResponsePosN = [];misIdletterN=[]; posTracker=[];
    eval(['pos' mat2str(pos) '_neutTrialsInCx    = InCxNeutTrials(InCxNeutTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['pos' mat2str(pos) '_neutTrialsCx      = CxNeutTrials(CxNeutTrials.postCueLocation==' mat2str(pos) ',:);'])
    eval(['countNumCx' mat2str(pos) '= size(pos' mat2str(pos) '_neutTrialsCx,1);'])
    for n=1:eval(['size(pos' num2str(pos) '_neutTrialsInCx,1)'])
        if online==0
            posTracker = eval(['strfind(pos' num2str(pos) '_neutTrialsInCx.string{n},char(pos' num2str(pos) '_neutTrialsInCx.chosenRes(n)));']);
        else
            eval(['currString=pos' num2str(pos) '_neutTrialsInCx.string{' num2str(n) '};'])
            posTracker = eval(['strfind(currString(3:8),char(pos' num2str(pos) '_neutTrialsInCx.RecordedResp(n)));']);
        end
        if isempty(posTracker)
            if online==0 
                misIdletterN = eval(['[misIdletterN; pos' num2str(pos) '_neutTrialsInCx.CxResp(n), char(pos' num2str(pos) '_neutTrialsInCx.chosenRes(n))];']);
            else
                misIdletterN = eval(['[misIdletterN; pos' num2str(pos) '_neutTrialsInCx.CxResp(' num2str(n) '), char(pos' num2str(pos) '_neutTrialsInCx.RecordedResp(' num2str(n) '))];']);
            end
            posTracker=0;
            if cell2mat(misIdletterN)== 0
                misIdletterN= [];
            end
        end
        errResponsePosN =[errResponsePosN; posTracker];
    end
    eval(['errTrials_posSwapsN_' num2str(pos) '= nnz(errResponsePosN);'])
    if numel(errResponsePosN)==1
        dummyVector=zeros(size(targetPositions)); dummyVector(1,1)=errResponsePosN; errResponsePosN=dummyVector;
    end
    eval(['errRespN_' num2str(pos)      '=  histc(errResponsePosN(:), targetPositions);'])
    eval(['errTrials_misIdentN_' num2str(pos) '= size(misIdletterN,1);'])
end
NuminCx_neutral                             = size(InCxNeutTrials,1);
poSwap_Nmat                                 = [errRespN_1';errRespN_2';errRespN_3'; errRespN_4';errRespN_5';errRespN_6'];
Swaps_tarSide                               = (sum(sum(poSwap_Nmat(1:3,1:3)+poSwap_Nmat(4:6,4:6)))/sum(sum(poSwap_Nmat,2)))*100;
Swaps_NtarSide                              = (sum(sum(poSwap_Nmat(1:3,4:6)+poSwap_Nmat(4:6,1:3)))/sum(sum(poSwap_Nmat,2)))*100;
pCx_Lt                                      = (sum([countNumCx1, countNumCx2, countNumCx3])/size(CxNeutTrials,1))*100;
pCx_Rt                                      = (sum([countNumCx4, countNumCx5, countNumCx6])/size(CxNeutTrials,1))*100;
SwapPos_Nmat                                = sum(poSwap_Nmat,2);
%% Adding a second matrix that only sums the swap errors from the adjacent
%positions
%GEt the Indx of those adjacent positions and them sum them to give you the
%count matrix
Adj1_indx=find(eye(size(poSwap_Nmat)))-1;
Adj1_indx=Adj1_indx(Adj1_indx~=0);
Adj2_indx= find(eye(size(poSwap_Nmat)))+1;
Adj2_indx=Adj2_indx(Adj2_indx~=37);
AdjPosSwaps_N = zeros(size(poSwap_Nmat));

AdjPosSwaps_N(Adj1_indx) = poSwap_Nmat(Adj1_indx);
AdjPosSwaps_N(Adj2_indx) = poSwap_Nmat(Adj2_indx);

SwapPos_Nmat2 = sum(AdjPosSwaps_N,2);
%%
p_Pswp                                      = (sum(sum(poSwap_Nmat,2)));%/NuminCx_neutral)*100;
poSwap_Nmat(find(eye(size(poSwap_Nmat))))   = [countNumCx1, countNumCx2, countNumCx3, countNumCx4, countNumCx5, countNumCx6];
misID_Nmat                                  = [errTrials_misIdentN_1;errTrials_misIdentN_2;errTrials_misIdentN_3; errTrials_misIdentN_4;errTrials_misIdentN_5;errTrials_misIdentN_6];
if any(misID_Nmat==0)
    indx= find(misID_Nmat==0);
    %        misID_Nmat(indx,:) =1;
end
p_mId                                       = (sum(misID_Nmat));%/NuminCx_neutral)*100;
err_ratio_Npos                              = SwapPos_Nmat./misID_Nmat;
errMatrix_neuT                              = [poSwap_Nmat, misID_Nmat,err_ratio_Npos];
errMatrix_neuT                              = [poSwap_Nmat];
sumMatrix_neuT                              = sum(errMatrix_neuT,2);
errMatrix_neuT                              = [errMatrix_neuT];% sumMatrix_neuT];
err_ratio                                   = p_Pswp/p_mId;
swp_ratio                                   = Swaps_tarSide/Swaps_NtarSide;

errTable.TotN       = size(NeutralTrials,1);
errTable.IncxN      = NuminCx_neutral;
errTable.pSwapN     = p_Pswp./size(NeutralTrials,1);%*(NuminCx_neutral/100);
errTable.misidN     = p_mId./size(NeutralTrials,1);%*(NuminCx_neutral/100);
errTable.swTarN     = Swaps_tarSide;
errTable.swNtarN    = Swaps_NtarSide;
%     errTable.S2M_N_1    = err_ratio_Npos(1);
%     errTable.S2M_N_2    = err_ratio_Npos(2);
%     errTable.S2M_N_3    = err_ratio_Npos(3);
%     errTable.S2M_N_4    = err_ratio_Npos(4);
%     errTable.S2M_N_5    = err_ratio_Npos(5);
%     errTable.S2M_N_6    = err_ratio_Npos(6);
errTable.SwapPos_Nmat= {SwapPos_Nmat};
errTable.SwapPos_Nmat2 = {SwapPos_Nmat2};
errTable.misID_Nmat   ={misID_Nmat};
errTable.Swap_matN= {errMatrix_neuT};
figure(7); subplot 432;
fighandle=heatmap(errMatrix_neuT);
colormap(fighandle, gray)
fighandle.XDisplayLabels = {'1', '2', '3', '4', '5', '6'}; %, 'misID','pS/misID'};%, 'TT'};
fighandle.Title = ['p_Pswp/p_misID= ' num2str(err_ratio)];

figure(8); subplot 432;
%     yy=[(size(CxNeutTrials,1)/size(NeutralTrials,1))*100;(NuminCx_neutral/size(NeutralTrials,1))*100; p_Pswp ; p_mId];
yy=[(NuminCx_neutral/size(NeutralTrials,1))*100; p_Pswp ; p_mId;Swaps_tarSide;Swaps_NtarSide;pCx_Rt;pCx_Lt];
bar(yy)
ylabel '(%)'
ylim ([0 100])
yticks (0:20:100)
xlim ([0 8])
xticks(1:1:7)
xtickangle(45)
set(gca, 'xticklabels',{'%Incx', 'pPosSwaps','pmisID','pSwp-TarSide','pSwp-nTarSide','pCx_Rt','pCx_Lt'}, 'FontSize', 10)
title(['All NeutralTrials: ' num2str(swp_ratio)]);
grid on

%{
    subplot 464;
    h=heatmap([misID_Nmat sumMatrix_neuT],'Colormap',white);
    h.ColorbarVisible = 'off';
    h.XDisplayLabels = {'misIdentified Letter', 'TotalTrials@eachPosition'};
%}
%% __________________________________________
%Invalid trial type only for the exp condition
if cueType==2
    for pos=1:6
        errResponsePosIn = [];misIdletterIn=[]; posTracker=[];
        eval(['pos' mat2str(pos) '_invTrialsInCx    = InCxInVTrials(InCxInVTrials.postCueLocation==' mat2str(pos) ',:);'])
        eval(['pos' mat2str(pos) '_invTrialsCx      = CxInVTrials(CxInVTrials.postCueLocation==' mat2str(pos) ',:);'])
        eval(['countNumCx' mat2str(pos) '= size(pos' mat2str(pos) '_invTrialsCx,1);'])
        for n=1:eval(['size(pos' num2str(pos) '_invTrialsInCx,1)'])
            if online==0
                posTracker = eval(['strfind(pos' num2str(pos) '_invTrialsInCx.string{n},char(pos' num2str(pos) '_invTrialsInCx.chosenRes(n)));']);
            else
                eval(['currString=pos' num2str(pos) '_invTrialsInCx.string{' num2str(n) '};'])
                posTracker = eval(['strfind(currString(3:8),char(pos' num2str(pos) '_invTrialsInCx.RecordedResp(n)));']);
            end
            if isempty(posTracker)
                if online ==0
                    misIdletterIn = eval(['[misIdletterIn; pos' num2str(pos) '_invTrialsInCx.CxResp(n), char(pos' num2str(pos) '_invTrialsInCx.chosenRes(n))];']);
                else 
                    misIdletterIn = eval(['[misIdletterIn; pos' num2str(pos) '_invTrialsInCx.CxResp(n), char(pos' num2str(pos) '_invTrialsInCx.RecordedResp(n))];']);
                end
                    posTracker=0;
                if cell2mat(misIdletterIn) == 0
                    misIdletterIn= [];
                end
            end
            errResponsePosIn =[errResponsePosIn; posTracker];
        end
        eval(['errTrials_posSwapsI_' num2str(pos) '= nnz(errResponsePosIn);'])
        if numel(errResponsePosIn)==1
            dummyVector=zeros(size(targetPositions)); dummyVector(1,1)=errResponsePosIn; errResponsePosIn=dummyVector;
        end
        eval(['errRespIn_' num2str(pos)      '= histc(errResponsePosIn(:), targetPositions)'])
        eval(['errTrials_misIdentI_' num2str(pos) '= size(misIdletterIn,1);'])
    end
    NuminCx_inVal                               = size(InCxInVTrials,1);
    poSwap_Inmat                                = [errRespIn_1';errRespIn_2';errRespIn_3'; errRespIn_4';errRespIn_5';errRespIn_6'];
    Swaps_cuedSide                              = (sum(sum(poSwap_Inmat(1:3,4:6)+poSwap_Inmat(4:6,1:3)))/sum(sum(poSwap_Inmat,2)))*100;
    Swaps_NcueSide                              = (sum(sum(poSwap_Inmat(1:3,1:3)+poSwap_Inmat(4:6,4:6)))/sum(sum(poSwap_Inmat,2)))*100;
    pCx_Lt                                      = (sum([countNumCx1, countNumCx2, countNumCx3])/size(CxInVTrials,1))*100;
    pCx_Rt                                      = (sum([countNumCx4, countNumCx5, countNumCx6])/size(CxInVTrials,1))*100;
    SwapPos_Imat                                = sum(poSwap_Inmat,2);
    %% Adding a second matrix that only sums the swap errors from the adjacent
    %positions
    %GEt the Indx of those adjacent positions and them sum them to give you the
    %count matrix
    Adj1_indx=find(eye(size(poSwap_Inmat)))-1;
    Adj1_indx=Adj1_indx(Adj1_indx~=0);
    Adj2_indx= find(eye(size(poSwap_Inmat)))+1;
    Adj2_indx=Adj2_indx(Adj2_indx~=37);
    AdjPosSwaps_I = zeros(size(poSwap_Inmat));
    
    AdjPosSwaps_I(Adj1_indx) = poSwap_Inmat(Adj1_indx);
    AdjPosSwaps_I(Adj2_indx) = poSwap_Inmat(Adj2_indx);
    
    SwapPos_Imat2 = sum(AdjPosSwaps_I,2);
    %%
    
    p_Pswp                                      = (sum(sum(poSwap_Inmat,2))); %/NuminCx_inVal)*100;
    poSwap_Inmat(find(eye(size(poSwap_Inmat)))) = [countNumCx1, countNumCx2, countNumCx3, countNumCx4, countNumCx5, countNumCx6];
    misID_Inmat                                 = [errTrials_misIdentI_1;errTrials_misIdentI_2;errTrials_misIdentI_3; errTrials_misIdentI_4;errTrials_misIdentI_5;errTrials_misIdentI_6];
    if any(misID_Inmat==0)
        indx= find(misID_Inmat==0);
        %         misID_Inmat(indx,:) =1;
    end
    p_mId                                       = (sum(misID_Inmat)); %/NuminCx_inVal)*100;
    err_ratio_Ipos                              = SwapPos_Imat./misID_Inmat;
    errMatrix_inVal                             = [poSwap_Inmat, misID_Inmat,err_ratio_Ipos];
    errMatrix_inVal                            = [poSwap_Inmat];
    sumMatrix_inVal                             = sum(errMatrix_inVal,2);
    errMatrix_inVal                             = [errMatrix_inVal];%, sumMatrix_inVal];
    err_ratio                                   = p_Pswp/p_mId;
    swp_ratio                                   = Swaps_cuedSide/Swaps_NcueSide;
    
    errTable.TotinV     = size(InvalidTrials,1);
    errTable.IncxinV    = NuminCx_inVal;
    errTable.pSwapinV   = p_Pswp./size(InvalidTrials,1); %*(NuminCx_inVal/100);
    errTable.misidinV   = p_mId./size(InvalidTrials,1); %*(NuminCx_inVal/100);
    errTable.swTarInv   =  Swaps_NcueSide;
    errTable.swNtarInv  =  Swaps_cuedSide; % Non- cued side has the target in invalid conditions
    %     errTable.S2M_I_1    = err_ratio_Ipos(1);
    %     errTable.S2M_I_2    = err_ratio_Ipos(2);
    %     errTable.S2M_I_3    = err_ratio_Ipos(3);
    %     errTable.S2M_I_4    = err_ratio_Ipos(4);
    %     errTable.S2M_I_5    = err_ratio_Ipos(5);
    %     errTable.S2M_I_6    = err_ratio_Ipos(6);
    errTable.SwapPos_Imat = {SwapPos_Imat};
    errTable.SwapPos_Imat2 = {SwapPos_Imat2}; % Counting those adjacent position swaps 
    errTable.misID_Inmat   ={misID_Inmat};
    errTable.Swap_matI= {errMatrix_inVal};
    figure(7); subplot 433;
    fighandle=heatmap(errMatrix_inVal);
    colormap(fighandle, gray)
    fighandle.XDisplayLabels = {'1', '2', '3', '4', '5', '6'}; %, 'misID','pS/misID'};%, 'TT'};
    fighandle.Title = ['p_Pswp/p_misID= ' num2str(err_ratio)];
    
    figure(8); subplot 433;
    %     yy=[(size(CxInVTrials,1)/size(InvalidTrials,1))*100;(NuminCx_neutral/size(InvalidTrials,1))*100; p_Pswp ; p_mId];
    yy=[(NuminCx_inVal/size(InvalidTrials,1))*100; p_Pswp ; p_mId;Swaps_cuedSide;Swaps_NcueSide;pCx_Rt;pCx_Lt];
    bar(yy)
    ylabel '(%)'
    ylim ([0 100])
    yticks (0:20:100)
    xlim ([0 8])
    xticks(1:1:7)
    xtickangle(45)
    set(gca, 'xticklabels',{'%Incx', 'pPosSwaps','pmisID','pSwp_cuedside','pSwp_ncueSide','pCx_rt','pCx_lt'}, 'FontSize', 10)
    title(['All InvalidTrials: ' num2str(swp_ratio)])
    grid on
    
    %{
    subplot 466;
    h=heatmap([misID_Inmat sumMatrix_inVal],'Colormap',white);
    h.ColorbarVisible = 'off';
    h.XDisplayLabels = {'misIdentified Letter', 'TotalTrials@eachPosition'};
    %}
end

%% ____For each CTOA compute a correlation matrix - Valid trials
for t=1:length(CTOA)
    if online==0
    eval(['CxValidTrials_' num2str(CTOA(t)) '=ValidTrials_' num2str(CTOA(t)) '(ValidTrials_' num2str(CTOA(t)) '.respCorrect==1,:);'])
    eval(['InCxValidTrials_' num2str(CTOA(t)) '=ValidTrials_' num2str(CTOA(t)) '(ValidTrials_' num2str(CTOA(t)) '.respCorrect==0,:);'])
    else 
        eval(['CxValidTrials_' num2str(CTOA(t)) '=ValidTrials_' num2str(CTOA(t)) '(ValidTrials_' num2str(CTOA(t)) '.Response==1,:);'])
        eval(['InCxValidTrials_' num2str(CTOA(t)) '=ValidTrials_' num2str(CTOA(t)) '(ValidTrials_' num2str(CTOA(t)) '.Response==0,:);'])
    end
    for pos=1:6
        eval(['errRespPosV_' num2str(CTOA(t)) '= [];']); eval(['misIdletV' num2str(CTOA(t)) '=[];']); posTracker=[];
        eval(['pos' mat2str(pos) '_Val' num2str(CTOA(t)) 'InCx    = InCxValidTrials_' num2str(CTOA(t)) '(InCxValidTrials_' num2str(CTOA(t)) '.postCueLocation==' mat2str(pos) ',:);'])
        eval(['pos' num2str(pos) '_Val' num2str(CTOA(t)) 'Cx      = CxValidTrials_' num2str(CTOA(t)) '(CxValidTrials_' num2str(CTOA(t)) '.postCueLocation==' mat2str(pos) ',:);'])
        eval(['countNumCx_' num2str(CTOA(t)) '_' mat2str(pos) '= size(pos' mat2str(pos) '_Val' num2str(CTOA(t)) 'Cx,1);'])
        for n=1:eval(['size(pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx,1)'])
            if online ==0
                posTracker = eval(['strfind(pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.string{n},char(pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.chosenRes(n)));']);
            else
                eval(['currString=pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.string{n};'])
                posTracker = eval(['strfind(currString(3:8),char(pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.RecordedResp(n)));']);
            end
            if isempty(posTracker)
                if online==0
                    eval(['misIdletV' num2str(CTOA(t)) '= [misIdletV' num2str(CTOA(t)) '; pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.CxResp(n), char(pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.chosenRes(n))];']);
                else 
                   eval(['misIdletV' num2str(CTOA(t)) '= [misIdletV' num2str(CTOA(t)) '; pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.CxResp(n), char(pos' num2str(pos) '_Val' num2str(CTOA(t)) 'InCx.RecordedResp(n))];']);
                end
                    posTracker=0;
            end
            eval(['errRespPosV_' num2str(CTOA(t)) '=[errRespPosV_' num2str(CTOA(t)) '; posTracker];'])
        end
        eval(['errTrials_posSwapsV_' num2str(CTOA(t)) '_' num2str(pos) '= nnz(errRespPosV_' num2str(CTOA(t)) ');'])
        if eval(['numel(errRespPosV_' num2str(CTOA(t)) ')==1'])
            dummyVector=zeros(size(targetPositions)); eval(['dummyVector(1,1)=errRespPosV_' num2str(CTOA(t)) ';']); eval(['errRespPosV_' num2str(CTOA(t)) '=dummyVector;'])
        end
        eval(['errRespV_' num2str(CTOA(t)) '_' num2str(pos)      '= histc(errRespPosV_' num2str(CTOA(t)) '(:), targetPositions);'])
        eval(['errTrials_misIdentV' num2str(CTOA(t)) '_' num2str(pos) '= size(misIdletV' num2str(CTOA(t)) ',1);'])
    end
    eval(['NuminCx_Val_' num2str(CTOA(t))       '= size(InCxValidTrials_' num2str(CTOA(t)) ',1);'])
    eval(['poSwap_Vmat_' num2str(CTOA(t))       '= [errRespV_' num2str(CTOA(t)) '_1' ''';errRespV_' num2str(CTOA(t)) '_2' ''';errRespV_' num2str(CTOA(t)) '_3' '''; errRespV_' num2str(CTOA(t)) '_4' ''';errRespV_' num2str(CTOA(t)) '_5' ''';errRespV_' num2str(CTOA(t)) '_6' '''];']);
    eval(['Swaps_cuedSidV_' num2str(CTOA(t))    '= (sum(sum(poSwap_Vmat_' num2str(CTOA(t)) '(1:3,1:3)+poSwap_Vmat_' num2str(CTOA(t)) '(4:6,4:6)))/sum(sum(poSwap_Vmat_' num2str(CTOA(t)) ',2)))*100;'])
    eval(['Swaps_NcueSidV_' num2str(CTOA(t))    '= (sum(sum(poSwap_Vmat_' num2str(CTOA(t)) '(1:3,4:6)+poSwap_Vmat_' num2str(CTOA(t)) '(4:6,1:3)))/sum(sum(poSwap_Vmat_' num2str(CTOA(t)) ',2)))*100;'])
    %     eval(['Swaps_fromRtV_' num2str(CTOA(t))      '= (sum(sum(poSwap_Vmat_' num2str(CTOA(t)) '(1:6,1:3)))/sum(sum(poSwap_Vmat_' num2str(CTOA(t)) ',2)))*100;'])
    %     eval(['Swaps_fromLtV_' num2str(CTOA(t))      '= (sum(sum(poSwap_Vmat_' num2str(CTOA(t)) '(1:6,4:6)))/sum(sum(poSwap_Vmat_' num2str(CTOA(t)) ',2)))*100;'])
    eval(['pCx_Lt_V_' num2str(CTOA(t))          '= (sum([countNumCx_' num2str(CTOA(t)) '_1, countNumCx_' num2str(CTOA(t)) '_2, countNumCx_' num2str(CTOA(t)) '_3])/size(CxValidTrials_' num2str(CTOA(t)) ',1))*100;'])
    eval(['pCx_Rt_V_' num2str(CTOA(t))          '= (sum([countNumCx_' num2str(CTOA(t)) '_4, countNumCx_' num2str(CTOA(t)) '_5, countNumCx_' num2str(CTOA(t)) '_6])/size(CxValidTrials_' num2str(CTOA(t)) ',1))*100;'])
    eval(['SwapPos_Vmat_' num2str(CTOA(t))      '= sum(poSwap_Vmat_' num2str(CTOA(t)) ',2);'])
    %% Adding a second matrix that only sums the swap errors from the adjacent
    %positions
    %GEt the Indx of those adjacent positions and them sum them to give you the
    %count matrix
    eval(['Adj1_indx=find(eye(size(poSwap_Vmat_' num2str(CTOA(t)) ')))-1;'])
    Adj1_indx=Adj1_indx(Adj1_indx~=0);
    eval(['Adj2_indx= find(eye(size(poSwap_Vmat_' num2str(CTOA(t)) ')))+1;'])
    Adj2_indx=Adj2_indx(Adj2_indx~=37);
    eval(['AdjPosSwaps_V_' num2str(CTOA(t)) '= zeros(size(poSwap_Vmat_' num2str(CTOA(t)) '));'])
    
    eval(['AdjPosSwaps_V_' num2str(CTOA(t)) '(Adj1_indx) = poSwap_Vmat_' num2str(CTOA(t)) '(Adj1_indx);'])
    eval(['AdjPosSwaps_V_' num2str(CTOA(t)) '(Adj2_indx) = poSwap_Vmat_' num2str(CTOA(t)) '(Adj2_indx);'])
    
    eval(['SwapPos_Vmat2_' num2str(CTOA(t)) '= sum(AdjPosSwaps_V_' num2str(CTOA(t)) ',2);'])
    %%
    eval(['p_Pswp_V_' num2str(CTOA(t))      '= (sum(sum(poSwap_Vmat_' num2str(CTOA(t)) ',2)));'])%/NuminCx_Val_' num2str(CTOA(t)) ')*100;'])
    eval(['poSwap_Vmat_' num2str(CTOA(t)) '(find(eye(size(poSwap_Vmat_' num2str(CTOA(t)) ')))) = [countNumCx_' num2str(CTOA(t)) '_1, countNumCx_' num2str(CTOA(t)) '_2, countNumCx_' num2str(CTOA(t)) '_3, countNumCx_' num2str(CTOA(t)) '_4, countNumCx_' num2str(CTOA(t)) '_5, countNumCx_' num2str(CTOA(t)) '_6];'])
    eval(['misID_Vmat_' num2str(CTOA(t))  '= [errTrials_misIdentV' num2str(CTOA(t)) '_1;errTrials_misIdentV' num2str(CTOA(t)) '_2;errTrials_misIdentV' num2str(CTOA(t)) '_3; errTrials_misIdentV' num2str(CTOA(t)) '_4;errTrials_misIdentV' num2str(CTOA(t)) '_5;errTrials_misIdentV' num2str(CTOA(t)) '_6];'])
    if eval(['any(misID_Vmat_' num2str(CTOA(t)) '==0)'])
        eval(['indx= find(misID_Vmat_' num2str(CTOA(t)) '==0)'])
        %         eval(['misID_Vmat_' num2str(CTOA(t)) '(indx,:) =1;'])
    end
    eval(['p_mId_V_' num2str(CTOA(t))       '= (sum(misID_Vmat_' num2str(CTOA(t)) '))'])%/NuminCx_Val_' num2str(CTOA(t)) ')*100;'])
    eval(['err_ratio_Vpos_' num2str(CTOA(t)) '= SwapPos_Vmat_' num2str(CTOA(t)) './misID_Vmat_' num2str(CTOA(t)) ';'])
    eval(['errMatrix_Valid_' num2str(CTOA(t)) '= [poSwap_Vmat_' num2str(CTOA(t)) ', misID_Vmat_' num2str(CTOA(t)) ', err_ratio_Vpos_' num2str(CTOA(t)) '];'])
    %PositionSwap Matrix
    eval(['errMatrix_Valid_' num2str(CTOA(t)) '= [poSwap_Vmat_' num2str(CTOA(t)) '];']) %, misID_Vmat_' num2str(CTOA(t)) ', err_ratio_Vpos_' num2str(CTOA(t)) '];'])
    eval(['sumMatrix_Valid_' num2str(CTOA(t)) '= sum(errMatrix_Valid_' num2str(CTOA(t)) ',2);'])
    %%%%%Toremove the total trials column     eval(['errMatrix_Valid_' num2str(CTOA(t)) '= [errMatrix_Valid_' num2str(CTOA(t)) ',sumMatrix_Valid_' num2str(CTOA(t)) '];'])
    eval(['errRatio_V_' num2str(CTOA(t)) '= p_Pswp_V_' num2str(CTOA(t))  '/ p_mId_V_' num2str(CTOA(t)) ';' ]);
    eval(['swp_ratio_V_' num2str(CTOA(t)) '= Swaps_cuedSidV_' num2str(CTOA(t)) '/Swaps_NcueSidV_' num2str(CTOA(t)) ';'])
    %%________Neutral___________
    if online ==0
        eval(['CxNeutTrials_' num2str(CTOA(t)) '=NeutralTrials_' num2str(CTOA(t)) '(NeutralTrials_' num2str(CTOA(t)) '.respCorrect==1,:);'])
        eval(['InCxNeutTrials_' num2str(CTOA(t)) '=NeutralTrials_' num2str(CTOA(t)) '(NeutralTrials_' num2str(CTOA(t)) '.respCorrect==0,:);'])
    else 
        eval(['CxNeutTrials_' num2str(CTOA(t)) '=NeutralTrials_' num2str(CTOA(t)) '(NeutralTrials_' num2str(CTOA(t)) '.Response==1,:);'])
        eval(['InCxNeutTrials_' num2str(CTOA(t)) '=NeutralTrials_' num2str(CTOA(t)) '(NeutralTrials_' num2str(CTOA(t)) '.Response==0,:);'])
    end
    
    for pos=1:6
        eval(['errRespPosN_' num2str(CTOA(t)) '= []']);eval(['misIdletN' num2str(CTOA(t)) '=[];']); posTracker=[];
        eval(['pos' mat2str(pos) '_Neu' num2str(CTOA(t)) 'InCx    = InCxNeutTrials_' num2str(CTOA(t)) '(InCxNeutTrials_' num2str(CTOA(t)) '.postCueLocation==' mat2str(pos) ',:);'])
        eval(['pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'Cx      = CxNeutTrials_' num2str(CTOA(t)) '(CxNeutTrials_' num2str(CTOA(t)) '.postCueLocation==' mat2str(pos) ',:);'])
        eval(['countNumCx_' num2str(CTOA(t)) '_' mat2str(pos) '= size(pos' mat2str(pos) '_Neu' num2str(CTOA(t)) 'Cx,1);'])
        for n=1:eval(['size(pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx,1)'])
            if online ==0
                posTracker = eval(['strfind(pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.string{n},char(pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.chosenRes(n)));']);
            else 
                eval(['currString=pos' num2str(pos) '_neutTrialsInCx.string{' num2str(n) '};'])
                posTracker = eval(['strfind(currString(3:8),char(pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.RecordedResp(n)));']);
            end
            if isempty(posTracker)
                if online==0
                    eval(['misIdletN' num2str(CTOA(t)) '= [misIdletN' num2str(CTOA(t)) '; pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.CxResp(n), char(pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.chosenRes(n))];']);
                else 
                    eval(['misIdletN' num2str(CTOA(t)) '= [misIdletN' num2str(CTOA(t)) '; pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.CxResp(n), char(pos' num2str(pos) '_Neu' num2str(CTOA(t)) 'InCx.RecordedResp(n))];']);
                end
                    posTracker=0;
            end
            eval(['errRespPosN_' num2str(CTOA(t)) '=[errRespPosN_' num2str(CTOA(t)) '; posTracker];'])
        end
        eval(['errTrials_posSwapsN_' num2str(CTOA(t)) '_' num2str(pos) '= nnz(errRespPosN_' num2str(CTOA(t)) ');'])
        if eval(['numel(errRespPosN_' num2str(CTOA(t)) ')==1'])
            dummyVector=zeros(size(targetPositions)); eval(['dummyVector(1,1)=errRespPosN_' num2str(CTOA(t)) ';']); eval(['errRespPosN_' num2str(CTOA(t)) '=dummyVector;'])
        end
        eval(['errRespN_' num2str(CTOA(t)) '_' num2str(pos)      '= histc(errRespPosN_' num2str(CTOA(t)) '(:), targetPositions);'])
        eval(['errTrials_misIdentN' num2str(CTOA(t)) '_' num2str(pos) '= size(misIdletN' num2str(CTOA(t)) ',1);'])
    end
    eval(['NuminCx_Neu_' num2str(CTOA(t))       '= size(InCxNeutTrials_' num2str(CTOA(t)) ',1);'])
    eval(['poSwap_Nmat_' num2str(CTOA(t))       '= [errRespN_' num2str(CTOA(t)) '_1' ''';errRespN_' num2str(CTOA(t)) '_2' ''';errRespN_' num2str(CTOA(t)) '_3' '''; errRespN_' num2str(CTOA(t)) '_4' ''';errRespN_' num2str(CTOA(t)) '_5' ''';errRespN_' num2str(CTOA(t)) '_6' '''];'])
    eval(['Swaps_TarSidN_' num2str(CTOA(t))    '= (sum(sum(poSwap_Nmat_' num2str(CTOA(t)) '(1:3,1:3)+poSwap_Nmat_' num2str(CTOA(t)) '(4:6,4:6)))/sum(sum(poSwap_Nmat_' num2str(CTOA(t)) ',2)))*100;'])
    eval(['Swaps_NtarSidN_' num2str(CTOA(t))    '= (sum(sum(poSwap_Nmat_' num2str(CTOA(t)) '(1:3,4:6)+poSwap_Nmat_' num2str(CTOA(t)) '(4:6,1:3)))/sum(sum(poSwap_Nmat_' num2str(CTOA(t)) ',2)))*100;'])
    %     eval(['Swaps_fromRtN_' num2str(CTOA(t))      '= (sum(sum(poSwap_Nmat_' num2str(CTOA(t)) '(1:6,1:3)))/sum(sum(poSwap_Nmat_' num2str(CTOA(t)) ',2)))*100;'])
    %     eval(['Swaps_fromLtN_' num2str(CTOA(t))      '= (sum(sum(poSwap_Nmat_' num2str(CTOA(t)) '(1:6,4:6)))/sum(sum(poSwap_Nmat_' num2str(CTOA(t)) ',2)))*100;'])
    eval(['pCx_Lt_N_' num2str(CTOA(t))          '= (sum([countNumCx_' num2str(CTOA(t)) '_1, countNumCx_' num2str(CTOA(t)) '_2, countNumCx_' num2str(CTOA(t)) '_3])/size(CxNeutTrials_' num2str(CTOA(t)) ',1))*100;'])
    eval(['pCx_Rt_N_' num2str(CTOA(t))          '= (sum([countNumCx_' num2str(CTOA(t)) '_4, countNumCx_' num2str(CTOA(t)) '_5, countNumCx_' num2str(CTOA(t)) '_6])/size(CxNeutTrials_' num2str(CTOA(t)) ',1))*100;'])
    eval(['SwapPos_Nmat_' num2str(CTOA(t))       '= sum(poSwap_Nmat_' num2str(CTOA(t)) ',2);'])
    %% Adding a second matrix that only sums the swap errors from the adjacent
    %positions
    %GEt the Indx of those adjacent positions and them sum them to give you the
    %count matrix
    eval(['Adj1_indx=find(eye(size(poSwap_Nmat_' num2str(CTOA(t)) ')))-1;'])
    Adj1_indx=Adj1_indx(Adj1_indx~=0);
    eval(['Adj2_indx= find(eye(size(poSwap_Nmat_' num2str(CTOA(t)) ')))+1;'])
    Adj2_indx=Adj2_indx(Adj2_indx~=37);
    eval(['AdjPosSwaps_N_' num2str(CTOA(t)) '= zeros(size(poSwap_Nmat_' num2str(CTOA(t)) '));'])
    
    eval(['AdjPosSwaps_N_' num2str(CTOA(t)) '(Adj1_indx) = poSwap_Nmat_' num2str(CTOA(t)) '(Adj1_indx);'])
    eval(['AdjPosSwaps_N_' num2str(CTOA(t)) '(Adj2_indx) = poSwap_Nmat_' num2str(CTOA(t)) '(Adj2_indx);'])
    
    eval(['SwapPos_Nmat2_' num2str(CTOA(t)) '= sum(AdjPosSwaps_N_' num2str(CTOA(t)) ',2);'])
    %%
    eval(['p_Pswp_N_'  num2str(CTOA(t))           '= (sum(sum(poSwap_Nmat_' num2str(CTOA(t)) ',2)));'])%/NuminCx_Neu_' num2str(CTOA(t)) ')*100;'])
    eval(['poSwap_Nmat_' num2str(CTOA(t)) '(find(eye(size(poSwap_Nmat_' num2str(CTOA(t)) ')))) = [countNumCx_' num2str(CTOA(t)) '_1, countNumCx_' num2str(CTOA(t)) '_2, countNumCx_' num2str(CTOA(t)) '_3, countNumCx_' num2str(CTOA(t)) '_4, countNumCx_' num2str(CTOA(t)) '_5, countNumCx_' num2str(CTOA(t)) '_6];'])
    eval(['misID_Nmat_' num2str(CTOA(t))        '= [errTrials_misIdentN' num2str(CTOA(t)) '_1;errTrials_misIdentN' num2str(CTOA(t)) '_2;errTrials_misIdentN' num2str(CTOA(t)) '_3; errTrials_misIdentN' num2str(CTOA(t)) '_4;errTrials_misIdentN' num2str(CTOA(t)) '_5;errTrials_misIdentN' num2str(CTOA(t)) '_6];'])
    if eval(['any(misID_Nmat_' num2str(CTOA(t)) '==0)'])
        eval(['indx= find(misID_Nmat_' num2str(CTOA(t)) '==0)'])
        %        eval(['misID_Nmat_' num2str(CTOA(t)) '(indx,:)=1;'])
    end
    eval(['p_mId_N_' num2str(CTOA(t))             '= (sum(misID_Nmat_' num2str(CTOA(t)) '));']) %/NuminCx_Neu_' num2str(CTOA(t)) ')*100;'])
    eval(['err_ratio_Npos_' num2str(CTOA(t))      '= SwapPos_Nmat_' num2str(CTOA(t)) './misID_Nmat_' num2str(CTOA(t)) ';'])
    eval(['errMatrix_Neutral_' num2str(CTOA(t)) '= [poSwap_Nmat_' num2str(CTOA(t)) ', misID_Nmat_' num2str(CTOA(t)) ',err_ratio_Npos_' num2str(CTOA(t)) '];'])
    %PositionSwap Matrix
    eval(['errMatrix_Neutral_' num2str(CTOA(t)) '= [poSwap_Nmat_' num2str(CTOA(t)) '];']) %, misID_Nmat_' num2str(CTOA(t)) ',err_ratio_Npos_' num2str(CTOA(t)) '];'])
    eval(['sumMatrix_Neutral_' num2str(CTOA(t)) '= sum(errMatrix_Neutral_' num2str(CTOA(t)) ',2);'])
    %%%%%Toremove the total trials column: eval(['errMatrix_Neutral_' num2str(CTOA(t)) '= [errMatrix_Neutral_' num2str(CTOA(t)) ',sumMatrix_Neutral_' num2str(CTOA(t)) '];'])
    eval(['errRatio_N_' num2str(CTOA(t)) '= p_Pswp_N_' num2str(CTOA(t))  '/ p_mId_N_' num2str(CTOA(t)) ';']);
    eval(['swp_ratio_N_' num2str(CTOA(t)) '= Swaps_TarSidN_' num2str(CTOA(t)) '/Swaps_NtarSidN_' num2str(CTOA(t)) ';'])
    %%________InValid___________
    if cueType==2
        if online==0
        eval(['CxInVTrials_' num2str(CTOA(t)) '=InValTrials_' num2str(CTOA(t)) '(InValTrials_' num2str(CTOA(t)) '.respCorrect==1,:);'])
        eval(['InCxInVTrials_' num2str(CTOA(t)) '=InValTrials_' num2str(CTOA(t)) '(InValTrials_' num2str(CTOA(t)) '.respCorrect==0,:);'])
        else 
            eval(['CxInVTrials_' num2str(CTOA(t)) '=InValTrials_' num2str(CTOA(t)) '(InValTrials_' num2str(CTOA(t)) '.Response==1,:);'])
            eval(['InCxInVTrials_' num2str(CTOA(t)) '=InValTrials_' num2str(CTOA(t)) '(InValTrials_' num2str(CTOA(t)) '.Response==0,:);'])
        end
        for pos=1:6
            eval(['errRespPosI_' num2str(CTOA(t)) '= [];']); eval(['misIdletI' num2str(CTOA(t)) '=[];']);posTracker=[];
            eval(['pos' mat2str(pos) '_InV' num2str(CTOA(t)) 'InCx    = InCxInVTrials_' num2str(CTOA(t)) '(InCxInVTrials_' num2str(CTOA(t)) '.postCueLocation==' mat2str(pos) ',:);'])
            eval(['pos' num2str(pos) '_InV' num2str(CTOA(t)) 'Cx      = CxInVTrials_' num2str(CTOA(t)) '(CxInVTrials_' num2str(CTOA(t)) '.postCueLocation==' mat2str(pos) ',:);'])
            eval(['countNumCx_' num2str(CTOA(t)) '_' mat2str(pos) '= size(pos' mat2str(pos) '_InV' num2str(CTOA(t)) 'Cx,1);'])
            for n=1:eval(['size(pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx,1)'])
                if online==0
                    posTracker = eval(['strfind(pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.string{n},char(pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.chosenRes(n)));']);
                else
                    eval(['currString=pos' num2str(pos) '_invTrialsInCx.string{' num2str(n) '};'])
                    posTracker = eval(['strfind(currString(3:8),char(pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.RecordedResp(n)));']);
                end
                if isempty(posTracker)
                    if online==0
                        eval(['misIdletI' num2str(CTOA(t)) '= [misIdletI' num2str(CTOA(t)) '; pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.CxResp(n), char(pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.chosenRes(n))];']);
                    else 
                        eval(['misIdletI' num2str(CTOA(t)) '= [misIdletI' num2str(CTOA(t)) '; pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.CxResp(n), char(pos' num2str(pos) '_InV' num2str(CTOA(t)) 'InCx.RecordedResp(n))];']);
                    end
                        posTracker=0;
                end
                eval(['errRespPosI_' num2str(CTOA(t)) '=[errRespPosI_' num2str(CTOA(t)) '; posTracker];'])
            end
            eval(['errTrials_posSwapsI_' num2str(CTOA(t)) '_' num2str(pos) '= nnz(errRespPosI_' num2str(CTOA(t)) ');'])
            if eval(['numel(errRespPosI_' num2str(CTOA(t)) ')==1'])
                dummyVector=zeros(size(targetPositions)); eval(['dummyVector(1,1)=errRespPosI_' num2str(CTOA(t)) ';']); eval(['errRespPosI_' num2str(CTOA(t)) '=dummyVector;']);
            end
            eval(['errRespI_' num2str(CTOA(t)) '_' num2str(pos)      '= histc(errRespPosI_' num2str(CTOA(t)) '(:), targetPositions);'])
            eval(['errTrials_misIdinV' num2str(CTOA(t)) '_' num2str(pos) '= size(misIdletI' num2str(CTOA(t)) ',1);'])
        end
        eval(['NuminCx_inV_' num2str(CTOA(t))       '= size(InCxInVTrials_' num2str(CTOA(t)) ',1);'])
        eval(['poSwap_Inmat_' num2str(CTOA(t))      '= [errRespI_' num2str(CTOA(t)) '_1' ''';errRespI_' num2str(CTOA(t)) '_2' ''';errRespI_' num2str(CTOA(t)) '_3' '''; errRespI_' num2str(CTOA(t)) '_4' ''';errRespI_' num2str(CTOA(t)) '_5' ''';errRespI_' num2str(CTOA(t)) '_6' '''];']);
        eval(['Swaps_cuedSidI_' num2str(CTOA(t))    '= (sum(sum(poSwap_Inmat_' num2str(CTOA(t)) '(1:3,4:6)+poSwap_Inmat_' num2str(CTOA(t)) '(4:6,1:3)))/sum(sum(poSwap_Inmat_' num2str(CTOA(t)) ',2)))*100;'])
        eval(['Swaps_NcueSidI_' num2str(CTOA(t))    '= (sum(sum(poSwap_Inmat_' num2str(CTOA(t)) '(1:3,1:3)+poSwap_Inmat_' num2str(CTOA(t)) '(4:6,4:6)))/sum(sum(poSwap_Inmat_' num2str(CTOA(t)) ',2)))*100;'])
        %     eval(['Swaps_fromRtI_' num2str(CTOA(t))      '= (sum(sum(poSwap_Inmat_' num2str(CTOA(t)) '(1:6,1:3)))/sum(sum(poSwap_Inmat_' num2str(CTOA(t)) ',2)))*100;'])
        %     eval(['Swaps_fromLtI_' num2str(CTOA(t))      '= (sum(sum(poSwap_Inmat_' num2str(CTOA(t)) '(1:6,4:6)))/sum(sum(poSwap_Inmat_' num2str(CTOA(t)) ',2)))*100;'])
        eval(['pCx_Lt_I_' num2str(CTOA(t))          '= (sum([countNumCx_' num2str(CTOA(t)) '_1, countNumCx_' num2str(CTOA(t)) '_2, countNumCx_' num2str(CTOA(t)) '_3])/size(CxInVTrials_' num2str(CTOA(t)) ',1))*100;'])
        eval(['pCx_Rt_I_' num2str(CTOA(t))          '= (sum([countNumCx_' num2str(CTOA(t)) '_4, countNumCx_' num2str(CTOA(t)) '_5, countNumCx_' num2str(CTOA(t)) '_6])/size(CxInVTrials_' num2str(CTOA(t)) ',1))*100;'])
        eval(['SwapPos_Imat_' num2str(CTOA(t))    '= sum(poSwap_Inmat_' num2str(CTOA(t)) ',2);'])
        %% Adding a second matrix that only sums the swap errors from the adjacent
        %positions
        %GEt the Indx of those adjacent positions and them sum them to give you the
        %count matrix
        eval(['Adj1_indx=find(eye(size(poSwap_Inmat_' num2str(CTOA(t)) ')))-1;'])
        Adj1_indx=Adj1_indx(Adj1_indx~=0);
        eval(['Adj2_indx= find(eye(size(poSwap_Inmat_' num2str(CTOA(t)) ')))+1;'])
        Adj2_indx=Adj2_indx(Adj2_indx~=37);
        eval(['AdjPosSwaps_I_' num2str(CTOA(t)) '= zeros(size(poSwap_Inmat_' num2str(CTOA(t)) '));'])
        
        eval(['AdjPosSwaps_I_' num2str(CTOA(t)) '(Adj1_indx) = poSwap_Inmat_' num2str(CTOA(t)) '(Adj1_indx);'])
        eval(['AdjPosSwaps_I_' num2str(CTOA(t)) '(Adj2_indx) = poSwap_Inmat_' num2str(CTOA(t)) '(Adj2_indx);'])
        
        eval(['SwapPos_Imat2_' num2str(CTOA(t)) '= sum(AdjPosSwaps_I_' num2str(CTOA(t)) ',2);'])
        %%
        eval(['p_Pswp_I_' num2str(CTOA(t))        '= (sum(sum(poSwap_Inmat_' num2str(CTOA(t)) ',2)))'])%/NuminCx_inV_' num2str(CTOA(t)) ')*100;'])
        eval(['poSwap_Inmat_' num2str(CTOA(t)) '(find(eye(size(poSwap_Inmat_' num2str(CTOA(t)) ')))) = [countNumCx_' num2str(CTOA(t)) '_1, countNumCx_' num2str(CTOA(t)) '_2, countNumCx_' num2str(CTOA(t)) '_3, countNumCx_' num2str(CTOA(t)) '_4, countNumCx_' num2str(CTOA(t)) '_5, countNumCx_' num2str(CTOA(t)) '_6];']);
        eval(['misID_Imat_' num2str(CTOA(t))      '= [errTrials_misIdinV' num2str(CTOA(t)) '_1;errTrials_misIdinV' num2str(CTOA(t)) '_2;errTrials_misIdinV' num2str(CTOA(t)) '_3; errTrials_misIdinV' num2str(CTOA(t)) '_4;errTrials_misIdinV' num2str(CTOA(t)) '_5;errTrials_misIdinV' num2str(CTOA(t)) '_6];']);
        if eval(['any(misID_Imat_' num2str(CTOA(t)) '==0)'])
            eval(['indx= find(misID_Imat_' num2str(CTOA(t)) '==0)'])
            %         eval(['misID_Imat_' num2str(CTOA(t)) '(indx,:) =1;'])
        end
        eval(['p_mId_I_' num2str(CTOA(t))         '= (sum(misID_Imat_' num2str(CTOA(t)) '));'])%/NuminCx_inV_' num2str(CTOA(t)) ')*100;'])
        eval(['err_ratio_Ipos_' num2str(CTOA(t))  '= SwapPos_Imat_' num2str(CTOA(t)) './misID_Imat_' num2str(CTOA(t)) ';'])
        eval(['errMatrix_InV_' num2str(CTOA(t))   '= [poSwap_Inmat_' num2str(CTOA(t)) ', misID_Imat_' num2str(CTOA(t)) ',err_ratio_Ipos_' num2str(CTOA(t)) '];'])
        %PositionSwap Matrix
        eval(['errMatrix_InV_' num2str(CTOA(t))   '= [poSwap_Inmat_' num2str(CTOA(t)) '];']) %, misID_Imat_' num2str(CTOA(t)) ',err_ratio_Ipos_' num2str(CTOA(t)) '];'])
        eval(['sumMatrix_InV_' num2str(CTOA(t))   '= sum(errMatrix_InV_' num2str(CTOA(t)) ',2);'])
        %%%%%Toremove the total trials column:  eval(['errMatrix_InV_' num2str(CTOA(t))   '= [errMatrix_InV_' num2str(CTOA(t)) ',sumMatrix_InV_' num2str(CTOA(t)) '];'])
        eval(['errRatio_I_' num2str(CTOA(t))      '= p_Pswp_I_' num2str(CTOA(t))  '/ p_mId_I_' num2str(CTOA(t)) ';']);
        eval(['swp_ratio_I_' num2str(CTOA(t))     '= Swaps_NcueSidI_' num2str(CTOA(t)) '/Swaps_cuedSidI_' num2str(CTOA(t)) ';'])
    end
end
%% Plot Valid trials

track=4;
for n=1:length(CTOA)
    figure(7);
    eval(['subplot(4,3,' num2str(track) ')'])
    eval(['fighandle=heatmap(errMatrix_Valid_' num2str(CTOA(n)) ');'])
    colormap(fighandle, gray)
    fighandle.YLabel ='TargetPosition';
    fighandle.XDisplayLabels = {'1', '2', '3', '4', '5', '6'}; %, 'misID', 'pS/misID'}; %, 'TT'};
    eval(['fighandle.Title = [' char(39) 'p_Pswp/p_mId =' char(39) ' num2str(errRatio_V_' num2str(CTOA(n)) ')];'])
    
    eval(['errTable.TotV_' num2str(CTOA(n))    '= size(ValidTrials_' num2str(CTOA(n)) ',1);'])
    eval(['errTable.IncxV_' num2str(CTOA(n))   '= NuminCx_Val_' num2str(CTOA(n)) ';'])
    eval(['errTable.pSwapV_' num2str(CTOA(n))  '= p_Pswp_V_' num2str(CTOA(n)) '/size(ValidTrials_' num2str(CTOA(n)) ',1);']) %*(NuminCx_Val_' num2str(CTOA(n)) '/100);'])
    eval(['errTable.misidV_' num2str(CTOA(n))  '= p_mId_V_' num2str(CTOA(n)) '/size(ValidTrials_' num2str(CTOA(n)) ',1);']) %*(NuminCx_Val_' num2str(CTOA(n)) '/100);'])
    eval(['errTable.swTarV_' num2str(CTOA(n))  '= Swaps_cuedSidV_' num2str(CTOA(n)) ';']) %this is also the cued side for the valid condition
    eval(['errTable.swNtarV_' num2str(CTOA(n)) '= Swaps_NcueSidV_' num2str(CTOA(n)) ';']) %this is also the non-cued side for the valid condition
    %       eval(['errTable.S2M_V_1_' num2str(CTOA(n))   '=err_ratio_Vpos_' num2str(CTOA(n)) '(1);'])
    %       eval(['errTable.S2M_V_2_' num2str(CTOA(n))   '=err_ratio_Vpos_' num2str(CTOA(n)) '(2);'])
    %       eval(['errTable.S2M_V_3_' num2str(CTOA(n))   '=err_ratio_Vpos_' num2str(CTOA(n)) '(3);'])
    %       eval(['errTable.S2M_V_4_' num2str(CTOA(n))   '=err_ratio_Vpos_' num2str(CTOA(n)) '(4);'])
    %       eval(['errTable.S2M_V_5_' num2str(CTOA(n))   '=err_ratio_Vpos_' num2str(CTOA(n)) '(5);'])
    %       eval(['errTable.S2M_V_6_' num2str(CTOA(n))   '=err_ratio_Vpos_' num2str(CTOA(n)) '(6);'])
    eval(['errTable.SwapPos_Vmat_' num2str(CTOA(n)) '={SwapPos_Vmat_' num2str(CTOA(n)) '};'])
    eval(['errTable.SwapPos_Vmat2_' num2str(CTOA(n)) '={SwapPos_Vmat2_' num2str(CTOA(n)) '};'])
    eval(['errTable.misID_Vmat_' num2str(CTOA(n))  '={misID_Vmat_' num2str(CTOA(n)) '};'])
    eval(['errTable.Swap_matV_' num2str(CTOA(n)) '={errMatrix_Valid_' num2str(CTOA(n)) '};'])
    figure(8);
    eval(['subplot(4,3,' num2str(track) ')'])
    eval(['yy=[(NuminCx_Val_' num2str(CTOA(n)) '/size(ValidTrials_' num2str(CTOA(n)) ',1))*100; p_Pswp_V_' num2str(CTOA(n)) '; p_mId_V_' num2str(CTOA(n)) ';Swaps_cuedSidV_' num2str(CTOA(n)) ';Swaps_NcueSidV_' num2str(CTOA(n)) ';pCx_Rt_V_' num2str(CTOA(n)) ';pCx_Lt_V_' num2str(CTOA(n)) '];'])
    bar(yy)
    ylabel '(%)'
    ylim ([0 100])
    yticks (0:20:100)
    xlim ([0 8])
    xticks(1:1:7)
    xtickangle(45)
    set(gca, 'xticklabels',{'%Incx', 'pPosSwaps','pmisID','pSwp_cuedside','pSwp_ncueSide','pCx_rt','pCx_lt'}, 'FontSize', 10)
    eval(['title([' char(39) 'Valid CTOA' num2str(CTOA(n)) '(T/nT): ' char(39) ' num2str(swp_ratio_V_' num2str(CTOA(n)) ')])']);
    grid on
    track=track+3;
end
%% -----Neutral-----

track=5;
for n=1:length(CTOA)
    figure(7);
    eval(['subplot(4,3,' num2str(track) ')'])
    eval(['fighandle=heatmap(errMatrix_Neutral_' num2str(CTOA(n)) ');'])
    colormap(fighandle, gray)
    fighandle.XDisplayLabels = {'1', '2', '3', '4', '5', '6'}; %, 'misID', 'pS/misID'}; %, 'TT'};
    eval(['fighandle.Title = [' char(39) 'p_Pswp/p_mId = ' char(39) ' num2str(errRatio_N_' num2str(CTOA(n)) ')];']);
    
    eval(['errTable.TotN_' num2str(CTOA(n))    '= size(NeutralTrials_' num2str(CTOA(n)) ',1);'])
    eval(['errTable.IncxN_' num2str(CTOA(n))   '= NuminCx_Neu_' num2str(CTOA(n)) ';'])
    eval(['errTable.pSwapN_' num2str(CTOA(n))  '= p_Pswp_N_' num2str(CTOA(n)) '/size(NeutralTrials_' num2str(CTOA(n)) ',1);']) %*(NuminCx_Neu_' num2str(CTOA(n)) '/100);'])
    eval(['errTable.misidN_' num2str(CTOA(n))  '= p_mId_N_' num2str(CTOA(n)) '/size(NeutralTrials_' num2str(CTOA(n)) ',1);']) %*(NuminCx_Neu_' num2str(CTOA(n)) '/100);'])
    eval(['errTable.swTarN_' num2str(CTOA(n))     '= Swaps_TarSidN_' num2str(CTOA(n)) ';'])
    eval(['errTable.swNtarN_' num2str(CTOA(n))    '= Swaps_NtarSidN_' num2str(CTOA(n)) ';'])
    %       eval(['errTable.S2M_N_1_' num2str(CTOA(n))    '= err_ratio_Npos_' num2str(CTOA(n)) '(1);'])
    %       eval(['errTable.S2M_N_2_' num2str(CTOA(n))    '= err_ratio_Npos_' num2str(CTOA(n)) '(2);'])
    %       eval(['errTable.S2M_N_3_' num2str(CTOA(n))    '= err_ratio_Npos_' num2str(CTOA(n)) '(3);'])
    %       eval(['errTable.S2M_N_4_' num2str(CTOA(n))    '= err_ratio_Npos_' num2str(CTOA(n)) '(4);'])
    %       eval(['errTable.S2M_N_5_' num2str(CTOA(n))    '= err_ratio_Npos_' num2str(CTOA(n)) '(5);'])
    %       eval(['errTable.S2M_N_6_' num2str(CTOA(n))    '= err_ratio_Npos_' num2str(CTOA(n)) '(6);'])
    eval(['errTable.SwapPos_Nmat_' num2str(CTOA(n)) '={SwapPos_Nmat_' num2str(CTOA(n)) '};'])
    eval(['errTable.SwapPos_Nmat2_' num2str(CTOA(n)) '={SwapPos_Nmat2_' num2str(CTOA(n)) '};'])
    eval(['errTable.misID_Nmat_' num2str(CTOA(n))  '={misID_Nmat_' num2str(CTOA(n)) '};'])
    eval(['errTable.Swap_matN_' num2str(CTOA(n)) '={errMatrix_Neutral_' num2str(CTOA(n)) '};'])
    figure(8);
    eval(['subplot(4,3,' num2str(track) ')'])
    eval(['yy=[(NuminCx_Neu_' num2str(CTOA(n)) '/size(NeutralTrials_' num2str(CTOA(n)) ',1))*100; p_Pswp_N_' num2str(CTOA(n)) '; p_mId_N_' num2str(CTOA(n)) ';Swaps_TarSidN_' num2str(CTOA(n)) ';Swaps_NtarSidN_' num2str(CTOA(n)) '; pCx_Rt_N_' num2str(CTOA(n)) ';pCx_Lt_N_' num2str(CTOA(n)) '];'])
    bar(yy)
    ylabel '(%)'
    ylim ([0 100])
    yticks (0:20:100)
    xlim ([0 8])
    xticks(1:1:7)
    xtickangle(45)
    set(gca, 'xticklabels',{'%Incx', 'pPosSwaps','pmisID','pSwp-TarSide','pSwp-nTarSide','pCx_rt','pCx_lt'}, 'FontSize', 10)
    eval(['title([' char(39) 'Neutral CTOA' num2str(CTOA(n)) ':(T/nT): ' char(39) ' num2str(swp_ratio_N_' num2str(CTOA(n)) ')])'])
    grid on
    track=track+3;
end

%% ---InValid---
if cueType==2
    
    track=6;
    for n=1:length(CTOA)
        figure(7);
        eval(['subplot(4,3,' num2str(track) ')'])
        eval(['fighandle=heatmap(errMatrix_InV_' num2str(CTOA(n)) ');'])
        colormap(fighandle, gray)
        fighandle.XDisplayLabels = {'1', '2', '3', '4', '5', '6'}; %, 'misID','pS/misID'}; %, 'TT'};
        eval(['fighandle.Title = [' char(39) 'p_Pswp/p_mId = ' char(39) ' num2str(errRatio_I_' num2str(CTOA(n)) ')];'])
        
        eval(['errTable.TotI_' num2str(CTOA(n))      '= size(InValTrials_' num2str(CTOA(n)) ',1);'])
        eval(['errTable.IncxI_' num2str(CTOA(n))     '= NuminCx_inV_' num2str(CTOA(n)) ';'])
        eval(['errTable.pSwapI_' num2str(CTOA(n))    '= p_Pswp_I_' num2str(CTOA(n)) '/size(InValTrials_' num2str(CTOA(n)) ',1);']) %*(NuminCx_inV_' num2str(CTOA(n)) '/100);'])
        eval(['errTable.misidI_' num2str(CTOA(n))    '= p_mId_I_' num2str(CTOA(n)) '/size(InValTrials_' num2str(CTOA(n)) ',1);']) %*(NuminCx_inV_' num2str(CTOA(n)) '/100);'])
        eval(['errTable.swTarInv_' num2str(CTOA(n))  '=  Swaps_NcueSidI_' num2str(CTOA(n)) ';'])
        eval(['errTable.swNtarInv_' num2str(CTOA(n)) '=  Swaps_cuedSidI_' num2str(CTOA(n)) ';']) % Non- cued side has the target in invalid conditions
        %       eval(['errTable.S2M_I_1_' num2str(CTOA(n)) '=err_ratio_Ipos_' num2str(CTOA(n)) '(1);'])
        %       eval(['errTable.S2M_I_2_' num2str(CTOA(n)) '=err_ratio_Ipos_' num2str(CTOA(n)) '(2);'])
        %       eval(['errTable.S2M_I_3_' num2str(CTOA(n)) '=err_ratio_Ipos_' num2str(CTOA(n)) '(3);'])
        %       eval(['errTable.S2M_I_4_' num2str(CTOA(n)) '=err_ratio_Ipos_' num2str(CTOA(n)) '(4);'])
        %       eval(['errTable.S2M_I_5_' num2str(CTOA(n)) '=err_ratio_Ipos_' num2str(CTOA(n)) '(5);'])
        %       eval(['errTable.S2M_I_6_' num2str(CTOA(n)) '=err_ratio_Ipos_' num2str(CTOA(n)) '(6);'])
        eval(['errTable.SwapPos_Imat_' num2str(CTOA(n)) '={SwapPos_Imat_' num2str(CTOA(n)) '};'])
        eval(['errTable.SwapPos_Imat2_' num2str(CTOA(n)) '={SwapPos_Imat2_' num2str(CTOA(n)) '};'])
        eval(['errTable.misID_Imat_' num2str(CTOA(n))  '={misID_Imat_' num2str(CTOA(n)) '};'])
        eval(['errTable.Swap_matI_' num2str(CTOA(n)) '={errMatrix_InV_' num2str(CTOA(n)) '};'])
        figure(8);
        eval(['subplot(4,3,' num2str(track) ')'])
        eval(['yy=[(NuminCx_inV_' num2str(CTOA(n)) '/size(InValTrials_' num2str(CTOA(n)) ',1))*100; p_Pswp_I_' num2str(CTOA(n)) '; p_mId_I_' num2str(CTOA(n)) '; Swaps_cuedSidI_' num2str(CTOA(n)) ';Swaps_NcueSidI_' num2str(CTOA(n)) ';pCx_Rt_I_' num2str(CTOA(n)) ';pCx_Lt_I_' num2str(CTOA(n)) '];'])
        bar(yy)
        ylabel '(%)'
        ylim ([0 100])
        yticks (0:20:100)
        xlim ([0 8])
        xticks(1:1:7)
        xtickangle(45)
        set(gca, 'xticklabels',{'%Incx', 'pPosSwaps','pmisID','pSwp_cuedside','pSwp_ncueSide','pCx_rt','pCx_lt'}, 'FontSize', 10)
        eval(['title([' char(39) 'InVal CTOA' num2str(CTOA(n)) ':(T/nT): ' char(39) ' num2str(swp_ratio_I_' num2str(CTOA(n)) ')])'])
        grid on
        track=track+3;
    end
end
%}