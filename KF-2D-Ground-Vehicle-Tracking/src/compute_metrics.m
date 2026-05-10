function metrics = compute_metrics(xTrue, xHat)
%COMPUTE_METRICS Compute RMSE metrics for state components.

err = xHat - xTrue;

metrics.positionRMSE = sqrt(mean(sum(err(1:2, :).^2, 1)));
metrics.velocityRMSE = sqrt(mean(sum(err(3:4, :).^2, 1)));
metrics.xRMSE = sqrt(mean(err(1, :).^2));
metrics.yRMSE = sqrt(mean(err(2, :).^2));
metrics.vxRMSE = sqrt(mean(err(3, :).^2));
metrics.vyRMSE = sqrt(mean(err(4, :).^2));
end
