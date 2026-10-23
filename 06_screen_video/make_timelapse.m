%% make_timelapse.m  -  STEP 6, way 2: time-lapse of Claude controlling an app
% Builds an MP4 from numbered screenshots plus a caption per screenshot.
% Inputs (in this folder):
%   frames/      screenshots, sorted by name (001.png, 002.png, ... or .jpg)
%   steps.csv    columns: file, caption   (one row per screenshot)
% Output: claude_controls_premiere.mp4 (1920x1080, 30 fps)
% Uses only base MATLAB (no toolboxes).

here = fileparts(mfilename('fullpath')); if isempty(here), here = pwd; end
S = readtable(fullfile(here,'steps.csv'), 'TextType','string', 'Delimiter',',');
secPerShot = 1.5;  fps = 30;  W = 1920;  H = 1080;
label = "Claude controlling Premiere Pro · real screenshots · time-lapse";

vw = VideoWriter(fullfile(here,'claude_controls_premiere.mp4'),'MPEG-4');
vw.FrameRate = fps; vw.Quality = 95; open(vw);
f  = figure('Color',[0.08 0.07 0.06],'Units','pixels','Position',[50 50 W H], ...
            'Visible','off','InvertHardcopy','off');
ax = axes(f,'Units','pixels','Position',[0 110 W H-180]);
for i = 1:height(S)
    img = imread(fullfile(here,'frames',S.file(i)));
    cla(ax); image(ax, img); axis(ax,'image','off');
    delete(findall(f,'Type','annotation'));
    annotation(f,'textbox','Units','pixels','Position',[40 20 W-80 70], ...
        'String',sprintf('%d/%d  %s', i, height(S), S.caption(i)), 'Color','w', ...
        'FontSize',30,'FontWeight','bold','EdgeColor','none','VerticalAlignment','middle');
    annotation(f,'textbox','Units','pixels','Position',[40 H-62 W-80 50], ...
        'String',label,'Color',[0.88 0.56 0.29],'FontSize',22,'EdgeColor','none');
    fr = print(f,'-RGBImage','-r0');
    % Retina screens render at 2x: rescale to exactly W x H (no toolbox needed)
    fr = fr(round(linspace(1,size(fr,1),H)), round(linspace(1,size(fr,2),W)), :);
    for k = 1:round(secPerShot*fps), writeVideo(vw, fr); end
end
close(vw); close(f);
fprintf('claude_controls_premiere.mp4: %d steps, %.0f s\n', height(S), height(S)*secPerShot);
