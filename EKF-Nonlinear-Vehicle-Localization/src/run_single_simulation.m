function out = run_single_simulation(cfg)
%RUN_SINGLE_SIMULATION Runs true system simulation and EKF estimation.

N = cfg.N;
dt = cfg.dt;

[accelTrue, yawRateTrue] = generate_control_profile(cfg);

xTrue = zeros(4, N);
xEst = zeros(4, N);
xPred = zeros(4, N);
zMeas = zeros(2, N);
P = zeros(4, 4, N);
KHist = zeros(4, 2, N);
innovationHist = zeros(2, N);

xTrue(:, 1) = cfg.x0True;
xEst(:, 1) = cfg.x0Est;
P(:, :, 1) = cfg.P0;

[z0, ~] = measurement_model(xTrue(:, 1));
zMeas(:, 1) = z0 + mvnrnd([0, 0], cfg.R)';

for k = 2:N
    uTrue = [accelTrue(k - 1); yawRateTrue(k - 1)];

    xTrueNom = vehicle_dynamics(xTrue(:, k - 1), uTrue, dt);
    xTrue(:, k) = xTrueNom + mvnrnd([0, 0, 0, 0], cfg.QTrue)';
    xTrue(3, k) = wrapToPi(xTrue(3, k));
    xTrue(4, k) = max(0.1, xTrue(4, k));

    % Estimator uses mismatched motion assumptions.
    uEst = [uTrue(1) + cfg.modelMismatch.accelBias;
            uTrue(2) * cfg.modelMismatch.turnRateScale];

    [xPred(:, k), PPred, ~] = ekf_predict(xEst(:, k - 1), P(:, :, k - 1), uEst, cfg);

    [zIdeal, ~] = measurement_model(xTrue(:, k));
    zMeas(:, k) = zIdeal + mvnrnd([0, 0], cfg.R)';

    [xEst(:, k), P(:, :, k), KHist(:, :, k), innovationHist(:, k)] = ...
        ekf_update(xPred(:, k), PPred, zMeas(:, k), cfg);
end

posErr = vecnorm(xEst(1:2, :) - xTrue(1:2, :), 2, 1);
headingErr = wrapToPi(xEst(3, :) - xTrue(3, :));
velErr = xEst(4, :) - xTrue(4, :);

out.time = cfg.time;
out.xTrue = xTrue;
out.xPred = xPred;
out.xEst = xEst;
out.zMeas = zMeas;
out.P = P;
out.K = KHist;
out.innovation = innovationHist;
out.accelTrue = accelTrue;
out.yawRateTrue = yawRateTrue;
out.posError = posErr;
out.headingError = headingErr;
out.velocityError = velErr;
out.rmsePos = sqrt(mean(posErr .^ 2));
out.rmseHeadingDeg = rad2deg(sqrt(mean(headingErr .^ 2)));
out.rmseVelocity = sqrt(mean(velErr .^ 2));
end
