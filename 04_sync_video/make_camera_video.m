%% make_camera_video.m  -  STEP 4a of the tutorial (synthetic camera)
% Renders a SYNTHETIC 30 fps "camera" video of the drop test, so the sync
% step has something to work on. With real experiments, skip this script
% and use your own camera file instead.
%
% The camera starts recording at true t = 0.2 s and sees an LED (top-left)
% that lights for 100 ms at t = 0.513 s: the shared sync event.
% Input : ../02_data/trial01.csv     Output: camera.mp4

here = fileparts(mfilename('fullpath')); if isempty(here), here = pwd; end
T = readtable(fullfile(here,'..','02_data','trial01.csv'));
rng(11);

fps = 30; W = 480; H = 540; t0 = 0.2; t_led = 0.513;
tv = t0 + (0:floor(3.4*fps)-1)/fps;        % true time of each frame
[X,Y] = meshgrid(1:W, 1:H);

vw = VideoWriter(fullfile(here,'camera.mp4'),'MPEG-4'); vw.FrameRate = fps; open(vw);
for k = 1:numel(tv)
    img = 28*ones(H,W,3,'uint8');  img(H-40:end,:,:) = 70;      % floor plate
    yb  = interp1(T.t, T.h, tv(k));  cy = round(H-40-22-yb*420);
    ball = (X-W/2).^2 + (Y-cy).^2 <= 22^2;
    led  = (X-40).^2 + (Y-40).^2 <= 14^2;
    if tv(k) >= t_led && tv(k) < t_led + 0.1, ledc = [250 250 210]; else, ledc = [60 60 60]; end
    ballc = [224 144 74];
    for c = 1:3
        ch = img(:,:,c); ch(ball) = ballc(c); ch(led) = ledc(c); img(:,:,c) = ch;
    end
    img = uint8(min(255, max(0, double(img) + randi([-6 6], H, W, 3))));
    writeVideo(vw, img);
end
close(vw);
fprintf('camera.mp4: %d frames at %d fps (%.2f s)\n', numel(tv), fps, numel(tv)/fps);
