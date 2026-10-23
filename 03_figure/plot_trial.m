%% plot_trial.m  -  STEP 3 of the tutorial
% Two stacked panels (force, height) on a shared time axis, SI units,
% exported as a vector PDF 85 mm wide (one journal column) and a PNG.
% Input : ../02_data/trial01.csv      Output: fig_trial01.pdf / .png

here = fileparts(mfilename('fullpath')); if isempty(here), here = pwd; end
T = readtable(fullfile(here,'..','02_data','trial01.csv'));

t_release = 1.0;                                    % s, from the protocol
sel = T.t > 0.9 & T.t < 3.6;  tp = T.t(sel) - t_release;

f  = figure('Name','Drop test, trial 01 (synthetic data)','Color','w', ...
            'Units','centimeters','Position',[4 4 17 18]);
tiledlayout(f,2,1,'TileSpacing','compact');
nexttile; plot(tp, T.force(sel), 'Color',[0.75 0.44 0.23], 'LineWidth',1.2);
ylabel('Force (N)'); grid on; box off
title('Drop test, trial 01 (synthetic data)','Color',[0.48 0.36 0.24])
nexttile; plot(tp, 1e3*T.h(sel), 'Color',[0.18 0.19 0.22], 'LineWidth',1.4);
ylabel('Height (mm)'); xlabel('Time since release (s)'); grid on; box off

set(f,'Position',[4 4 8.5 9]);                      % 85 mm column width
exportgraphics(f, fullfile(here,'fig_trial01.pdf'), 'ContentType','vector');
set(f,'Position',[4 4 17 18]);
exportgraphics(f, fullfile(here,'fig_trial01.png'), 'Resolution',200);

% --- sanity check: first rebound should reach e^2 x 1 m = 490 mm -----------
pk = findpeaks(1e3*T.h(sel), 'MinPeakHeight',100);
fprintf('First rebound: %.0f mm (expected %.0f mm for e = 0.7)\n', pk(1), 0.7^2*1000);
fprintf('Peak force: %.0f N | processing applied: none (raw samples)\n', max(T.force));
