%% Input parameters
clear
clc

% Parameters
maxAge= 300;
age = (0:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/10);
markovMatrices{1} = [.1 .4 .5 0; .1 .495 .4 .005; 0 .1 .7 .2; 0 .1, .4, .5]; % Shallow
markovMatrices{2} = [.8 .1 .1 0; .4 .5 .1 0; .4 .4 .2 0; 0 0 .7 .3];  % Deep
depositionalRates = [1, .7, .5, -.1];
depositionalRates = [1, 1, 1, 1];

%% Multiple realizations
nRealizations=5;

figure('Color', 'White')

for i = 1:nRealizations
    
    % Simulate
    strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
    strata = finalizeStrata(strata);

    % Plotting 
    subplot(3,nRealizations,[i, i+nRealizations])
    plotStrata(strata);
    title(['Realization ', num2str(i)])

    hold on
end

subplot(3,nRealizations,2*nRealizations+1:3*nRealizations)
plot(seaLevelAge,seaLevelHeight, 'LineWidth',2)
set(gca, 'xDir', 'reverse')
ylabel('Normalized relative sea-level'); xlabel('Age')
axis tight

%% Upscaling example


% Parameters
maxAge= 100;
age = (0:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/20);
markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .3 .7]; % Shallow
markovMatrices{2} = [.8 .1 .1; .4 .5 .1; .4 .4 .2];  % Deep
depositionalRates = [1, 1, 1];

% Simulate
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);

smoothingIntervals = [1 7 13];
nScales = numel(smoothingIntervals);

figure('Color', 'White')

for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strataUpscaled = upscaleStrata(strata, smoothingInterval);
    strataUpscaled = finalizeStrata(strataUpscaled);

    subplot(1,nScales+1,i+1)
    plotStrata(strataUpscaled, true, 3);
    title(['Scaled ', num2str(smoothingInterval)])

end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Normalized relative sea-level'); ylabel('Depth')
axis tight


%%