function [S,Su,Sl,f] = auto_spc(x,dt,Navg,r_win)
%Computes a one-side autospectrum S as a function for input time
%series x, with a sample period of dt.  Smooths Sxx over Navg
%frequencies.  A Tukey window is applied prior to taking the fft.
%r_win is the cosine fraction of the window.  If r_win = 0 the window is 
% a boxcar (i.e., no window at all), if r_win = 0.5 the window is a Hamm 
%window.

%Inputs
%x: time series
%dt: sample period
%Navg: no. of frequency bands to smooth
%r_win = cosine fraction of the Tukey window (r_win = 0, boxcar, 0.5 = Hamm window)

%Outputs
%S: autospectrum
%Su: 95% confidence level upper
%Sl: 95% confidence level lower
%f: frequency

N = length(x);
x = x(:);

%ensure that record length is even
if(rem(N,2))
   x = x(1:end-1);
   N = N-1;
end

%remove mean
x_rm = detrend(x,0);

%window and compute FFT
w = tukeywin(N,r_win);
X = fft(x_rm.*w);

%one-sided frequency
f = (1:N/2)'/(N*dt);

%compute spectral density
S = abs(X(2:N/2+1)).^2/N*dt;  %index 2 corresponds to 1/(N*dt), index N/2+1 to 1/(2*dt)
S(1:end-1) = 2*S(1:end-1);    %double to account for negative frequencies, except Nyqust

%correct for window assuming total variance is conserved 
varx = var(x_rm);
varS = sum(S)/(N*dt);
S = S*varx/varS;

%running mean, discard trims the ends of the record
S = movmean(S,Navg,'Endpoints','discard');    
f = movmean(f,Navg,'Endpoints','discard');  

%compute 95% confidence interval
nu = 2*Navg;
alpha = 0.05;
Su = S*nu/chi2inv(alpha/2,nu);
Sl = S*nu/chi2inv(1-alpha/2,nu);

end