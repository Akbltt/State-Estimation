function cfg = default_config()
%DEFAULT_CONFIG Simulation and filter configuration.

cfg.projectName = "KF-2D-Ground-Vehicle-Tracking";
cfg.randomSeed = 42;

cfg.dt = 0.1;          % [s]
cfg.totalTime = 45.0;  % [s]
cfg.N = floor(cfg.totalTime / cfg.dt) + 1;

cfg.x0True = [0; 0; 8; 1.5];

% Continuous-time acceleration process noise used in discrete Q.
cfg.qAccel = [0.8, 0.8];

% Measurement noise covariance for GPS-like position measurements [m^2].
cfg.R_meas = diag([3.0^2, 3.0^2]);

% Filter initialization.
cfg.x0Hat = [0; 0; 0; 0];
cfg.P0 = diag([20^2, 20^2, 8^2, 8^2]);

% Plotting and output.
cfg.resultsDir = fullfile(fileparts(fileparts(mfilename("fullpath"))), "results");
cfg.enableAnimation = false;
cfg.animationFrameSkip = 2;

% Optional study switches.
cfg.runTuningStudy = true;

% Truth-model maneuvers introduce model mismatch against CV filter model.
cfg.truthModel.enableManeuvers = true;
end
