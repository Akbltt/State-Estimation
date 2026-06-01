function [xUp, PUp, K, innovation] = ekf_update(xPred, PPred, zMeas, cfg)
%EKF_UPDATE Measurement update using Joseph covariance form.

[zPred, H] = measurement_model(xPred);
innovation = zMeas - zPred;

S = H * PPred * H' + cfg.R;
K = PPred * H' / S;

xUp = xPred + K * innovation;
xUp(3) = wrapToPi(xUp(3));

I = eye(size(PPred));
PUp = (I - K * H) * PPred * (I - K * H)' + K * cfg.R * K';
end
