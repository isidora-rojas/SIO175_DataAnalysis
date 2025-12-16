% 1. Load the original data
load('SIO_TEMP_1917_2023_fill.mat');

% 2. Convert the proprietary 'time' object to a standard string format
time_str = string(time, 'yyyy-MM-dd'); 

% 3. Also create separate Year, Month, Day vectors 
% (This makes it even easier to analyze in Python without parsing dates)
[yr, mo, dy] = ymd(time);

% 4. Save to a new .mat file
% We save the old 'T' variable, plus our new 'time_str' and date parts.
save('SIO_TEMP_Fixed.mat', 'T', 'time_str', 'yr', 'mo', 'dy', '-v7');
