%% run_all.m  -  runs the whole tutorial without AI, in order
% Use this to check your installation or to regenerate the reference outputs.
% (Each step runs in its own function workspace so variables don't collide.)
function run_all()
root = fileparts(mfilename('fullpath'));
steps = {'02_data/generate_drop_test.m', '03_figure/plot_trial.m', ...
         '04_sync_video/make_camera_video.m', '04_sync_video/sync_video.m', ...
         '05_premiere/make_premiere_files.m'};
for n = 1:numel(steps)
    fprintf('\n=== %s ===\n', steps{n});
    run_step(fullfile(root, steps{n}));
end
close all
end

function run_step(file)
run(file);
end
