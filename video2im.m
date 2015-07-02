function video2im(video_file, save_path, img_fmt)

if ~isdir(save_path)
    mkdir(save_path);
end

videoObj    = VideoReader(video_file);
num_frame   = videoObj.NumberOfFrames;

for i = 1 : num_frame    
    imwrite(read(videoObj, i), fullfile(save_path, sprintf('%04d.%s', i, img_fmt)));
end
