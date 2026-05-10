function [xPred, PPred] = kf_predict(xPrev, PPrev, F, Q)
%KF_PREDICT State and covariance prediction.

xPred = F * xPrev;
PPred = F * PPrev * F' + Q;
end
