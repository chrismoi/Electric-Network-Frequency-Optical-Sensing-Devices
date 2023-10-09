function y = SLIC(video_path)
%   SLIC analysis of video recording
v = VideoReader(video_path);
frames=v.Duration*v.FrameRate;

tic
for i=1:fix(frames);
    frame = read(v,i);
    
    %%%SLIC
    if i==1
       I = rgb2gray(frame);
       [L,NumLabels] = superpixels(I,20);
       idx = label2idx(L);
    end
    
    I = rgb2gray(frame);
    
    for labelVal = 1:NumLabels
        redIdx = idx{labelVal};
        outputImage(labelVal) = mean(I(redIdx));
    end  
    med_val=median(outputImage);
    xxx=(outputImage>=(med_val/3));
    
    frame_val(i) = mean(outputImage(xxx));
    y=frame_val;

end
toc
end

