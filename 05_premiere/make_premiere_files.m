%% make_premiere_files.m  -  STEP 5 of the tutorial
% Turns events.csv (video clock) into two files Premiere Pro can use:
%   events.srt         - one caption per event; File > Import, drag to timeline
%   markers_list.txt   - timecodes to place markers by hand or via a connector
% Input : ../04_sync_video/events.csv

here = fileparts(mfilename('fullpath')); if isempty(here), here = pwd; end
ev = readtable(fullfile(here,'..','04_sync_video','events.csv'), 'TextType','string');
fps = 30; dur = 0.25;                                % caption length (s), shorter than the gap between events

tc  = @(s) sprintf('%02d:%02d:%02d,%03d', floor(s/3600), floor(mod(s,3600)/60), floor(mod(s,60)), round(1000*mod(s,1)));
tcf = @(s) sprintf('%02d:%02d:%02d:%02d', floor(s/3600), floor(mod(s,3600)/60), floor(mod(s,60)), round(fps*mod(s,1)));

fid = fopen(fullfile(here,'events.srt'),'w');
for i = 1:height(ev)
    fprintf(fid, '%d\n%s --> %s\n%s\n\n', i, tc(ev.video_time_s(i)), tc(ev.video_time_s(i)+dur), ev.event(i));
end
fclose(fid);

fid = fopen(fullfile(here,'markers_list.txt'),'w');
fprintf(fid, 'Marker timecodes (HH:MM:SS:FF at %d fps)\n', fps);
for i = 1:height(ev)
    fprintf(fid, '%s  %s\n', tcf(ev.video_time_s(i)), ev.event(i));
end
fclose(fid);
type(fullfile(here,'markers_list.txt'))
