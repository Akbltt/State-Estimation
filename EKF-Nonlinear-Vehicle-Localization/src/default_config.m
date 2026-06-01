function cfg = default_config(projectRoot)
%DEFAULT_CONFIG Centralized configuration for simulation and EKF settings.

cfg.projectRoot = projectRoot;
cfg.resultsDir = fullfile(projectRoot, 'results');

% Time settings.
cfg.dt = 0.1;
cfg.T = 80;
cfg.time = 0:cfg.dt:cfg.T;
cfg.N = numel(cfg.time);

% Initial true state: [x; y; heading; velocity].
cfg.x0True = [0; 0; deg2rad(8); 6.0];

% Initial estimate and covariance.
cfg.x0Est = [0.6; -0.4; deg2rad(0); 5.0];
cfg.P0 = diag([2.0^2, 2.0^2, deg2rad(15)^2, 1.2^2]);

% Process noise used by the true simulator.
qTruePos = 0.07;
qTrueHeading = deg2rad(0.8);
qTrueVel = 0.10;
cfg.QTrue = diag([qTruePos^2, qTruePos^2, qTrueHeading^2, qTrueVel^2]);

% Process noise assumed by EKF.
qEstPos = 0.10;
qEstHeading = deg2rad(1.2);
qEstVel = 0.18;
cfg.QEst = diag([qEstPos^2, qEstPos^2, qEstHeading^2, qEstVel^2]);

% GPS-like measurement noise: z = [x; y] + noise.
rGps = 1.8;
cfg.R = diag([rGps^2, rGps^2]);

% Motion-model mismatch used by estimator.
cfg.modelMismatch.turnRateScale = 0.9;
cfg.modelMismatch.accelBias = -0.03;

% Animation options.
cfg.animation.makeGif = true;
cfg.animation.gifFilename = 'ekf_tracking.gif';
cfg.animation.makeMp4 = false;
cfg.animation.mp4Filename = 'ekf_tracking.mp4';
cfg.animation.frameStep = 2;
cfg.animation.playbackFps = 25;
end
