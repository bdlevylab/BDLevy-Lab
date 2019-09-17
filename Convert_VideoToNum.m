clear all
clc;
close all;


%% load .avi files

name_list=dir('08*.avi');

for i=1:length(name_list)
    disp(i);
    disp(name_list(i).name);
end

%% convert avi files to .mat files


for i = 1:length(name_list)  
      
    disp(name_list(i).name);
    disp('start');
    
    filename = name_list(i).name;
    
    v = VideoReader(filename);

    framerate = v.framerate;
    duration = v.duration * framerate;
    stack = zeros(v.Height, v.Width, duration, 'uint8');

    i=1;
    
    while hasFrame(v)
        v2=readFrame(v);
        v3=rgb2gray(v2);
        figure(2);
        imagesc(v3);
  
        v3_med = medfilt2(v3, [5 1]);
        stack(:,:,i) = v3_med;
 
        figure(3);
        imagesc(stack(:,:,i));
        title(filename);
        
        i = i+1;
    end

    filename_save = filename(1:length(filename)-4);
    filename_save = [filename_save '.mat']

    save(filename_save, 'framerate', 'stack', 'duration');
        
end


