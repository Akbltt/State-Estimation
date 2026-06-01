function [xPred, PPred, F] = ekf_predict(xPrev, PPrev, uEst, cfg)
%EKF_PREDICT Nonlinear state and covariance prediction.

dt = cfg.dt;

xPred = vehicle_dynamics(xPrev, uEst, dt);

psi = xPrev(3);
v = xPrev(4);

F = [1, 0, -v * sin(psi) * dt, cos(psi) * dt;
     0, 1,  v * cos(psi) * dt, sin(psi) * dt;
     0, 0, 1,                  0;
     0, 0, 0,                  1];

PPred = F * PPrev * F' + cfg.QEst;
end
