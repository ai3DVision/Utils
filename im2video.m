function im2video(img_path, img_fmt, save_name, frame_rate)

frame_names         = dir([img_path '\*.' img_fmt]);
num_frames          = numel(frame_names);
writerObj   		    = VideoWriter([save_name '.avi']);
writerObj.FrameRate = frame_rate;

open(writerObj);

for i = 1 : num_frames
    img = im2double(imread([img_path frame_names(i, 1).name]));
    writeVideo(writerObj, img);
end

close(writerObj);
