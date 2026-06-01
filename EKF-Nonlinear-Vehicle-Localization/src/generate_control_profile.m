function [accel, yawRate] = generate_control_profile(cfg)
%GENERATE_CONTROL_PROFILE Builds a realistic drive profile with maneuvers.

t = cfg.time(:);
N = cfg.N;

% Baseline smooth commands.
accel = 0.18 * sin(0.22 * t) + 0.08 * sin(0.05 * t + 1.4);
yawRate = 0.05 * sin(0.18 * t) + 0.08 * sin(0.04 * t + 0.9);

% Aggressive turn window.
idxTurn = (t >= 20) & (t < 34);
yawRate(idxTurn) = yawRate(idxTurn) + 0.22 .* sin(0.9 * (t(idxTurn) - 20));

% Sudden speed change and recovery.
idxBrake = (t >= 42) & (t < 48);
accel(idxBrake) = accel(idxBrake) - 0.55;

idxAccel = (t >= 48) & (t < 55);
accel(idxAccel) = accel(idxAccel) + 0.38;

% Late maneuver.
idxLate = (t >= 62) & (t < 72);
yawRate(idxLate) = yawRate(idxLate) - 0.18;

if numel(accel) ~= N || numel(yawRate) ~= N
    error('Control profile length mismatch.');
end
end
