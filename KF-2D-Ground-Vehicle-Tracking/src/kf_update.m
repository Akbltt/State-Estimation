function [xUpd, PUpd, K, innov, S] = kf_update(xPred, PPred, z, H, R)
%KF_UPDATE Linear KF measurement update using Joseph covariance form.

innov = z - H * xPred;
S = H * PPred * H' + R;
K = PPred * H' / S;

xUpd = xPred + K * innov;

I = eye(size(PPred));
PUpd = (I - K * H) * PPred * (I - K * H)' + K * R * K';
end
