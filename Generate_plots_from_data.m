 clc
close all
clear all
format compact

name_list=dir('data*.mat');
fprintf('Processing %d files\n',length(name_list))

for i=1:length(name_list)
    disp(i);
    disp(name_list(i).name);
end

%%
mkdir('scatter_20(000-1280)')
mkdir('scatter_20(000-1280)_sumIntensity')
mkdir('scatter_20(000-1280)_MeanIntensity')
mkdir('scatter_20(000-1280)_MajorAxisLength')
mkdir('scatter_20(000-1280)_MinorAxisLength')
mkdir('hist_20_normalized(000-1280)')
mkdir('hist_20_normalized(000-1280)_Ath')
mkdir('hist_20_normalized(000-1280)_Wth')
mkdir('hist_20_normalized(000-1280)_Wth2')
mkdir('hist_20(000-1280)_various')


for i = 1:length(name_list)
    disp(i);
  
     matName = name_list(i).name;
    load (matName)
    [savePath,saveName,EXT]=fileparts(matName);
    
    dim = size(background);
    width = dim(2);
    
    selection = Centroid_Array(:,1)<1200 & Centroid_Array(:,1)>80;
    figure(1)
    cla
    plot([-1 -1])
    plot(Centroid_Array(selection,1),Area_Array(selection),'b.','markersize',5)
    xlabel('IDP(pixels)')
    ylabel('Area')
    ylim([0 1000])
    xlim([0 width])
    F = getframe(gcf);
    
    imwrite(F.cdata,fullfile('scatter_20(000-1280)',sprintf('%s_IDS_scatter(%s,%s).tif',saveName, num2str(mean(Area_Array(selection))), num2str(std(Area_Array(selection))) )),'tif');  
        
    figure(1)
    cla
    plot([-1 -1])
    plot(Centroid_Array(selection,1),MeanIntensity_Array(selection),'b.','markersize',5)
    xlabel('IDP(pixels)')
    ylabel('Intensity(Mean)')
    ylim([0 100])
    xlim([0 width])
    F = getframe(gcf);
  
    imwrite(F.cdata,fullfile('scatter_20(000-1280)_MeanIntensity',sprintf('%s_IDS_scatter_MeanIntensity(%s,%s).tif',saveName, num2str(mean(MeanIntensity_Array(selection))), num2str(std(MeanIntensity_Array(selection))) )),'tif');  
    
    figure(1)
    cla
    plot([-1 -1])
    plot(Centroid_Array(selection,1),SumIntensity_Array(selection),'b.','markersize',5)
    xlabel('IDP(pixels)')
    ylabel('Intensity(Sum)')
    ylim([0 10000])
    xlim([0 width])
    F = getframe(gcf);
   
    imwrite(F.cdata,fullfile('scatter_20(000-1280)_sumIntensity',sprintf('%s_IDS_scatter_SumIntensity(%s,%s).tif',saveName, num2str(mean(SumIntensity_Array(selection))), num2str(std(SumIntensity_Array(selection))) )),'tif');  
        
    % Major and Minor axis lengths scatter plot
    
    figure(1)
    cla
    plot([-1 -1])
    plot(Centroid_Array(selection,1),MajorAxisLength_Array(selection),'b.','markersize',5)
    xlabel('IDP(pixels)')
    ylabel('MajorAxisLength')
    ylim([0 300])
    xlim([0 width])
    F = getframe(gcf);
     
    imwrite(F.cdata,fullfile('scatter_20(000-1280)_MajorAxisLength',sprintf('%s_IDS_scatter_MajorAxisLength(%s,%s).tif',saveName, num2str(mean(MajorAxisLength_Array(selection))), num2str(std(MajorAxisLength_Array(selection))) )),'tif');  
        
    figure(1)
    cla
    plot([-1 -1])
    plot(Centroid_Array(selection,1),MinorAxisLength_Array(selection),'b.','markersize',5)
    xlabel('IDP(pixels)')
    ylabel('MinorAxisLength')
    ylim([0 50])
    xlim([0 width])
    F = getframe(gcf);   
 
    imwrite(F.cdata,fullfile('scatter_20(000-1280)_MinorAxisLength',sprintf('%s_IDS_scatter_MinorAxisLength(%s,%s).tif',saveName, num2str(mean(MinorAxisLength_Array(selection))), num2str(std(MinorAxisLength_Array(selection))) )),'tif');  
        
    
    figure(2)
    cla
    x = 0:20:width;
    x2 = 400:20:width;
    
    
    Ath_value = 0.5;
    Ath = quantile(Area_Array, Ath_value);
    Wth = 0;
    Ith = 6;
    Eth = 0.95;
    
    
    %% width selection
    selection = Centroid_Array(:,1)<1200 & Centroid_Array(:,1)>80 & MinorAxisLength_Array>Wth & MeanIntensity_Array > Ith & Eccentricity_Array > Eth;
    selection_0 = Centroid_Array(:,1)<1200 & Centroid_Array(:,1)>80;

    histIDP=hist(Centroid_Array(selection,1),x);
    h=Centroid_Array(selection,1),x;
    H=sort(h);
    histIDP2 = hist(Centroid_Array(selection,1),x2);
    
    
    A400_0 = Centroid_Array(selection,1);
    A400 = A400_0;    
        
    Q1 = quantile(A400, 0.25);
    Q2 = quantile(A400, 0.5);
    Q3 = quantile(A400, 0.75);

    plot(x,histIDP/sum(histIDP), 'b-', 'linewidth', 3)   
    hold on
    plot(Q1, 0, 'b*', Q2, 0, 'b*', Q3, 0, 'b*');

    
    %%%%%% add the original histogram
    
    histIDP_0=hist(Centroid_Array(selection_0,1),x);
    histIDP2_0 = hist(Centroid_Array(selection_0,1),x2);
    
    
    B400_0 = Centroid_Array(selection_0,1);
    B400 = B400_0;    
        
    Q1_B = quantile(B400, 0.25);
    Q2_B = quantile(B400, 0.5);
    Q3_B = quantile(B400, 0.75);
        
    xlabel('IDP(pixels)')
    ylabel('Number of Cell Images in per 20 pixel interval(000-1280)')
        
    xlim([0 width])
    F = getframe(gcf);
    imwrite(F.cdata,fullfile('hist_20_normalized(000-1280)_Wth2',sprintf('%s_IDS_hist_Wth_%s_%s_%s.tif',saveName, num2str(round(Q1)), num2str(round(Q2)), num2str(round(Q3)))),'tif');  

    save(fullfile(sprintf('histdata_%02d_%s.mat',i,saveName)),'x', 'histIDP', 'H', 'Q1','Q2','Q3')

%% make histograms of various data
    
    figure(3)
    
    N_hist = 200;

    subplot(6,1,1);
    hist(Area_Array, linspace(0,1000,N_hist))
    xlim([0 1000]);
    title(['Area (' num2str(mean(Area_Array)) ', ' num2str(std(Area_Array)) ')  ' ...
        'Quantiles: (' num2str(quantile(Area_Array, 0.25)) ',' num2str(quantile(Area_Array, 0.5)) ',' num2str(quantile(Area_Array, 0.75)) ')']);
    
    subplot(6,1,2);
    hist(MajorAxisLength_Array, linspace(0,200,N_hist))
    xlim([0 200]);
    title(['MajorAxisLength (' num2str(mean(MajorAxisLength_Array)) ', ' num2str(std(MajorAxisLength_Array)) ')  ' ...
        'Quantiles: (' num2str(quantile(MajorAxisLength_Array, 0.25)) ',' num2str(quantile(MajorAxisLength_Array, 0.5)) ',' num2str(quantile(MajorAxisLength_Array, 0.75)) ')']);
    
    subplot(6,1,3);
    hist(MinorAxisLength_Array, linspace(0,30,N_hist))
    xlim([0 30]);
    title(['MinorAxisLength (' num2str(mean(MinorAxisLength_Array)) ', ' num2str(std(MinorAxisLength_Array)) ')  ' ...
        'Quantiles: (' num2str(quantile(MinorAxisLength_Array, 0.25)) ',' num2str(quantile(MinorAxisLength_Array, 0.5)) ',' num2str(quantile(MinorAxisLength_Array, 0.75)) ')']);
    
    subplot(6,1,4);
    hist(SumIntensity_Array, linspace(0,5000,N_hist))
    xlim([0 5000]);
    title(['SumIntensity (' num2str(mean(SumIntensity_Array)) ', ' num2str(std(SumIntensity_Array)) ')  ' ...
        'Quantiles: (' num2str(quantile(SumIntensity_Array, 0.25)) ',' num2str(quantile(SumIntensity_Array, 0.5)) ',' num2str(quantile(SumIntensity_Array, 0.75)) ')']);
    
    subplot(6,1,5);
    hist(MeanIntensity_Array, linspace(0,20,N_hist))
    xlim([0 20]);
    title(['MeanIntensity (' num2str(mean(MeanIntensity_Array)) ', ' num2str(std(MeanIntensity_Array)) ')  ' ...
        'Quantiles: (' num2str(quantile(MeanIntensity_Array, 0.25)) ',' num2str(quantile(MeanIntensity_Array, 0.5)) ',' num2str(quantile(MeanIntensity_Array, 0.75)) ')']);
    
    subplot(6,1,6);
    hist(Eccentricity_Array, linspace(0,1,N_hist))
    xlim([0 1]);
    title(['Eccentritiy (' num2str(mean(Eccentricity_Array)) ', ' num2str(std(Eccentricity_Array)) ')  ' ...
        'Quantiles: (' num2str(quantile(Eccentricity_Array, 0.25)) ',' num2str(quantile(Eccentricity_Array, 0.5)) ',' num2str(quantile(Eccentricity_Array, 0.75)) ')']);
   
    F = getframe(gcf);
    
  
    imwrite(F.cdata,fullfile('hist_20(000-1280)_various',sprintf('%s_IDS_hist_Various.tif',saveName) ),'tif');  


end
