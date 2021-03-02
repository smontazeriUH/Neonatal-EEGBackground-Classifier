%% plotbt.m
% Calculates and plots Background Trend (BT)
%
%% Inputs:
%   probabilitySignal   : a matrix representing the probabilistic output of
%                         classifiers. Each row is a sample and each column is probability for
%                         each class
%   classes             : a cell containing class names
%% Outputs:
% BT Visualization
%% Example:
%
% probabilitySignal = rand(1000,6);
% classes = {'Rejected' '1' '2' '3' '4' '5'};
% plotbt(probabilitySignal,classes)
%%
% Saeed Montazeri M.
% Jan 23, 2021
% Last update : Feb 14, 2021

function plotbt(probabilitySignal,classes)

% Calculate trends
[WeightedAvg, lowerLim, upperLim] = calTrendwithCI(probabilitySignal);

% Plot trends
nClasses = size(probabilitySignal,2);
y = 1:nClasses;
fig = figure();
hold on
for iFillSpaces = 1 : length(lowerLim)-1
    % Fill between upper and lower lines with colour
    v1 = [iFillSpaces WeightedAvg(iFillSpaces); iFillSpaces upperLim(iFillSpaces); iFillSpaces+1 upperLim(iFillSpaces+1); iFillSpaces+1 WeightedAvg(iFillSpaces+1)];
    patch('Faces',[1 2 3 4],'Vertices',v1,'FaceColor',[0.47 0.6 0.68],'FaceAlpha',.6,'EdgeColor',[0.47 0.6 0.68],'EdgeAlpha',.05);
    v2 = [iFillSpaces lowerLim(iFillSpaces); iFillSpaces WeightedAvg(iFillSpaces); iFillSpaces+1 WeightedAvg(iFillSpaces+1); iFillSpaces+1 lowerLim(iFillSpaces+1)];
    patch('Faces',[1 2 3 4],'Vertices',v2,'FaceColor',[0.47 0.6 0.68],'FaceAlpha',.6,'EdgeColor',[0.47 0.6 0.68],'EdgeAlpha',.05);
end

% Plot margine for each class
for iclasses = 1 : nClasses-1
    plot(1:length(probabilitySignal), iclasses+0.5*ones(1,length(probabilitySignal)), 'Color',[1 0 0.35], 'LineWidth',1)
end

plot(WeightedAvg,'-k','LineWidth',2)
ylim([0.5 nClasses+0.5])
xlim ([1 length(WeightedAvg)])
set(gca,'ydir','normal');
set(gca, 'YTick', y, 'YTickLabel', classes);
