function animate_tracking(t, xTrue, zMeas, xHat, resultsDir, cfg)
%ANIMATE_TRACKING Create simple tracking animation and save as MP4.

videoPath = fullfile(resultsDir, "tracking_animation.mp4");
writerObj = VideoWriter(videoPath, "MPEG-4");
writerObj.FrameRate = 20;
open(writerObj);

fig = figure("Color", "w", "Name", "Tracking Animation");

xMin = min([xTrue(1, :), zMeas(1, :)]) - 10;
xMax = max([xTrue(1, :), zMeas(1, :)]) + 10;
yMin = min([xTrue(2, :), zMeas(2, :)]) - 10;
yMax = max([xTrue(2, :), zMeas(2, :)]) + 10;

for k = 1:cfg.animationFrameSkip:length(t)
    clf;

    plot(xTrue(1, 1:k), xTrue(2, 1:k), "k-", "LineWidth", 1.8); hold on;
    plot(zMeas(1, 1:k), zMeas(2, 1:k), ".", "Color", [0.7 0.7 0.7], "MarkerSize", 8);
    plot(xHat(1, 1:k), xHat(2, 1:k), "b-", "LineWidth", 1.5);

    plot(xTrue(1, k), xTrue(2, k), "ko", "MarkerFaceColor", "k", "MarkerSize", 6);
    plot(xHat(1, k), xHat(2, k), "bo", "MarkerFaceColor", "b", "MarkerSize", 6);

    xlabel("x [m]");
    ylabel("y [m]");
    title(sprintf("KF Tracking Animation (t = %.1f s)", t(k)));
    legend("True", "Measurements", "KF estimate", "Location", "best");
    grid on;
    axis equal;
    axis([xMin xMax yMin yMax]);

    frame = getframe(fig);
    writeVideo(writerObj, frame);
end

close(writerObj);
close(fig);
end
