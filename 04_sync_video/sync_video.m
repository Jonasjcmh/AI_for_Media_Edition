%% sync_video.m  -  STEP 4b of the tutorial
% Synchronises the camera video with the force logger and renders a
% side-by-side video: camera frame | force trace drawn up to "now".
%
% 1 Detect  - LED flash in the video, trigger step in the logger
% 2 Shift   - move logger time onto the video clock
% 3 Sample  - PEAK force within each frame interval (not interp1 at the
%             frame time: a 4 ms impact falls between 33 ms frames!)
% 4 Render  - write trial01_sync.mp4 and events.csv (for Premiere, Step 5)
%
% Inputs : camera.mp4, ../02_data/logger.csv
% Outputs: trial01_sync.mp4, sync_check.png, events.csv

here = fileparts(mfilename('fullpath')); if isempty(here), here = pwd; end
L  = readtable(fullfile(here,'..','02_data','logger.csv'));
vr = VideoReader(fullfile(here,'camera.mp4'));
fps = vr.FrameRate;

% ---- 1 Detect --------------------------------------------------------------
frames = read(vr);                                  % H x W x 3 x N
nF   = size(frames,4);  tVid = (0:nF-1)'/fps;       % video clock (constant fps)
ledB = squeeze(mean(frames(27:54,27:54,1,:),[1 2]));
kLed = find(ledB > (min(ledB)+max(ledB))/2, 1);
tSyncVideo  = tVid(kLed);
tSyncLogger = L.t_logger(find(L.trigger > 2.5, 1));

% ---- 2 Shift ---------------------------------------------------------------
tSig = L.t_logger - tSyncLogger + tSyncVideo;       % logger -> video clock
fprintf('LED at frame %d (%.3f s) | trigger at logger %.3f s | offset %.3f s\n', ...
        kLed-1, tSyncVideo, tSyncLogger, tSyncLogger - tSyncVideo);

% ---- 3 Sample: peak within each frame interval ------------------------------
Fnaive = interp1(tSig, L.force, tVid);              % what NOT to do
Fpeak  = zeros(nF,1);
for k = 1:nF
    in = tSig > tVid(k) - 1/fps & tSig <= tVid(k);
    if any(in), Fpeak(k) = max(L.force(in)); end
end
[~,kImp] = max(Fpeak);
fprintf('Impact frame %d: interp1 gives %.1f N, frame-peak gives %.0f N\n', kImp-1, Fnaive(kImp), Fpeak(kImp));

% sync check figure (inspect by eye before trusting the video!)
fc = figure('Color','w','Position',[100 100 1100 380],'Visible','off');
subplot(1,2,1); plot(tVid, ledB,'o-','Color',[0.43 0.6 0.27]); xline(tSyncVideo,'--','Color',[0.48 0.36 0.24]);
xlim([0 1]); title('Video: LED patch brightness'); xlabel('Video time (s)'); ylabel('Mean pixel value'); box off
subplot(1,2,2); plot(L.t_logger, L.trigger,'Color',[0.75 0.44 0.23]); xline(tSyncLogger,'--','Color',[0.48 0.36 0.24]);
xlim(tSyncLogger + [-0.3 0.7]); title('Logger: trigger channel'); xlabel('Logger time (s)'); ylabel('V'); box off
exportgraphics(fc, fullfile(here,'sync_check.png'), 'Resolution',150); close(fc);

% ---- 4 Render --------------------------------------------------------------
H = size(frames,1); pw = 720;
fp = figure('Color','w','Units','pixels','Position',[100 100 pw H],'Visible','off');
ax = axes(fp,'Position',[0.12 0.12 0.84 0.78]);
vis = tSig >= 0 & tSig <= tVid(end);
vw = VideoWriter(fullfile(here,'trial01_sync.mp4'),'MPEG-4'); vw.FrameRate = fps; open(vw);
for k = 1:nF
    cla(ax); hold(ax,'on')
    plot(ax, tSig(vis), L.force(vis), 'Color',[0.85 0.82 0.77]);
    now_ = vis & tSig <= tVid(k);
    plot(ax, tSig(now_), L.force(now_), 'Color',[0.75 0.44 0.23], 'LineWidth',1.4);
    xline(ax, tVid(k), 'Color',[0.48 0.36 0.24], 'LineWidth',1.5);
    xlim(ax,[0 tVid(end)]); ylim(ax,[-5 1.08*max(L.force)]); box(ax,'off')
    xlabel(ax,'Video time (s)'); ylabel(ax,'Force (N)');
    title(ax, sprintf('t = %.2f s   peak F in frame = %.0f N', tVid(k), Fpeak(k)), 'Color',[0.48 0.36 0.24]);
    pnl = print(fp,'-RGBImage','-r0');  pnl = imresize(pnl,[H pw]);
    writeVideo(vw, [frames(:,:,:,k), pnl]);
end
close(vw); close(fp);

% ---- events.csv for Premiere (video clock) ----------------------------------
on = find(L.force(2:end) > 20 & L.force(1:end-1) <= 20) + 1;
tImp = tSig(on) - 1e-3;
ev = table([{'LED sync'}; compose('impact %d',(1:4)')], round([tSyncVideo; tImp(1:4)],3), ...
           'VariableNames', {'event','video_time_s'});
writetable(ev, fullfile(here,'events.csv'));
disp(ev)
fprintf('Wrote trial01_sync.mp4 (%d frames), sync_check.png, events.csv\n', nF);
