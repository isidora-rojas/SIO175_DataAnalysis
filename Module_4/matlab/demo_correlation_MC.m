load Module2_large.mat

%get time series at the equator, lon = 270°E
[jj,jlat] = min(abs(ALT.lat));
[jj,jlon] = min(abs(ALT.lon-270));
y = squeeze(ALT.sl(:,jlat,jlon));

%compute synthetic time series
N = 1000;
ymc = bootstrap_phase(y,N);

%compute correlation
for j = 1:N
    r(j) = corr(ONI,ymc(:,j));
end

histogram(r)
