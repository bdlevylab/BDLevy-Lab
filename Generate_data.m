clc
close all
clear all
format compact

name_list=dir('08*.mat');
fprintf('Processing %d files\n',length(name_list))
%%

for i=1:length(name_list)
    disp(i);
    disp(name_list(i).name);
end


%%
for i_name= 1:length(name_list)
    matName = name_list(i_name).name;
    load(matName)
    % Make folder for saving particle images
    disp(matName)
    
    % Variables initialization
    Area_Array = [];
    Centroid_Array=[];
    Eccentricity_Array =[];
    Frame_Array=[];
    MeanIntensity_Array = [];
    SumIntensity_Array = [];
    MajorAxisLength_Array = [];
    MinorAxisLength_Array = [];
    
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
       
    background = median(stack(:,:,:),3);
    
    % For each frame, find cells
    for frame_num = 1  :size(stack,3)
        disp(frame_num)
        
        % Show the background
        I = stack(:,:,frame_num);
        I2 = uint8(abs(double(I)-double(background(:,:))));
        bwCells = im2bw(I2,0.02);
        cellObject = bwconncomp(bwCells, 8);
        cellArea = regionprops(cellObject, 'FilledArea');
        cellCentroid = regionprops(cellObject, 'Centroid');
        cellEccentricity = regionprops(cellObject, 'Eccentricity');
        cellMajorAxisLength = regionprops(cellObject, 'MajorAxisLength');
        cellMinorAxisLength = regionprops(cellObject, 'MinorAxisLength');
        
        % Filtering cellObject based on properties
        for i = 1:cellObject.NumObjects
            if (cellArea(i).FilledArea > 20 & cellEccentricity(i).Eccentricity > 0.8 )
                Area_Array = [Area_Array; cellArea(i).FilledArea;];
                Centroid_Array = [Centroid_Array; cellCentroid(i).Centroid];
                Eccentricity_Array = [Eccentricity_Array; cellEccentricity(i).Eccentricity];
                Frame_Array = [Frame_Array; frame_num;];
                Intensity = double(I2(cellObject.PixelIdxList{i}));
                MeanIntensity_Array = [MeanIntensity_Array; mean(Intensity)];
                SumIntensity_Array = [SumIntensity_Array; sum(Intensity)];
                MajorAxisLength_Array = [MajorAxisLength_Array; cellMajorAxisLength(i).MajorAxisLength];
                MinorAxisLength_Array = [MinorAxisLength_Array; cellMinorAxisLength(i).MinorAxisLength];
            end
        end
        
    end
    
    [savePath,saveName,EXT]=fileparts(matName);
    % Save feature arrays
    save(fullfile(sprintf('data_%02d_%s.mat',i_name,saveName)),'Area_Array','Centroid_Array','Eccentricity_Array','Frame_Array','MeanIntensity_Array','SumIntensity_Array','MajorAxisLength_Array', 'MinorAxisLength_Array', 'background')
    clear stack
    
end

