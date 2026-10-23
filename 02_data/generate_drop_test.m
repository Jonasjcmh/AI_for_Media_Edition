%% generate_drop_test.m  -  STEP 2 of the tutorial
% Creates a SYNTHETIC drop-test dataset so everyone can follow the tutorial
% without lab data. Replace this step with your own recordings later.
%
% Physics: 0.2 kg ball released from 1 m at t = 1 s, coefficient of
% restitution e = 0.7, 4 ms contact pulse per impact.
%
% Outputs (written to this folder):
%   trial01.csv  - t (s, experiment clock), force (N), h (m)   -> used in Step 3
%   logger.csv   - t_logger (s, the logger's OWN clock), force (N),
%                  trigger (V)  -> what a real DAQ gives you, used in Step 4
%
% The logger clock starts 2.137 s "late" on purpose, and an LED/trigger
% pulse at t = 0.513 s is the sync event shared with the camera (Step 4).

here = fileparts(mfilename('fullpath')); if isempty(here), here = pwd; end
rng(7);                                   % reproducible noise

g = 9.81; e = 0.7; m = 0.2; tau = 0.004;  % SI units
dt = 1e-4; t = 0:dt:3.6;                  % fine simulation grid
h = ones(size(t)); v = 0; y = 1; imp = zeros(0,2); rest = false;
for k = 2:numel(t)
    if t(k) > 1 && ~rest
        v = v - g*dt;  y = y + v*dt;
        if y <= 0 && v < 0
            if -v > 0.3, imp(end+1,:) = [t(k) -v]; v = -e*v;   %#ok<AGROW>
            else,        v = 0; rest = true; end
            y = 0;
        end
    end
    h(k) = y;
end

ts = (0:1e-3:3.6)';                       % 1 kHz sensor samples
F  = zeros(size(ts));
for i = 1:size(imp,1)                     % half-sine force pulse per impact
    idx = ts >= imp(i,1) & ts <= imp(i,1) + tau;
    F(idx) = F(idx) + m*imp(i,2)*(1+e)*pi/(2*tau) * sin(pi*(ts(idx)-imp(i,1))/tau);
end
force = F + 0.05*randn(size(ts));

T = table(ts, force, interp1(t,h,ts), 'VariableNames', {'t','force','h'});
writetable(T, fullfile(here,'trial01.csv'));

t_led   = 0.513;                          % sync event (true time)
offset  = 2.137;                          % logger clock offset
trigger = 5*(ts >= t_led) + 0.02*randn(size(ts));
L = table(ts + offset, force, trigger, 'VariableNames', {'t_logger','force','trigger'});
writetable(L, fullfile(here,'logger.csv'));

fprintf('trial01.csv : %d samples, %d impacts, peak force %.0f N\n', height(T), size(imp,1), max(force));
fprintf('logger.csv  : logger clock starts at %.3f s, trigger at true t = %.3f s\n', L.t_logger(1), t_led);
