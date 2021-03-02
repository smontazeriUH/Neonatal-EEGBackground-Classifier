%% calTrendwithCI.m
% Calculates Background Trend (BT), upper and lower lines (confidence
% interval (CI))
%
%% Inputs:
%   probabilitySignal   : a matrix containing probability values for each  
%                         class in a classification problem. Each row  
%                         is a sample and each column is probability for 
%                         each class
%% Outputs:
%   WeightedAvg         : a vector containing BT trend
%   lowerLim            : a vector containing lower boundary
%   upperLim            : a vector containing upperLim boundary
%% Example:
%
% probabilitySignal = rand(1000,6);
% [WeightedAvg, lowerLim, upperLim] = calTrendwithCI(probabilitySignal)
%%
% Saeed Montazeri M.
% Jan 23, 2021
% Last update : Feb 14, 2021

function [WeightedAvg, lowerLim, upperLim] = calTrendwithCI(probabilitySignal)

nClasses = size(probabilitySignal,2); % number of classes
% Compute BT as a weighted average of classes
WeightedAvg = sum([0.5 2:nClasses-1 nClasses+0.5].*probabilitySignal,2);

lowerLim = []; upperLim = [];
classes = [1 2:nClasses-1 nClasses];
for inx = 1:length(probabilitySignal)
    % Interpolate probability of the estimated class
    interpProb = interp1(classes',probabilitySignal(inx,:)',WeightedAvg(inx),'PCHIP');
    
    modalC = round(WeightedAvg(inx)); % the modal class
    % Updating probability value for modal class with the distance between 
    % interpolated probability of the weighted average class and 
    % probability of the modal class
    probabilitySignal(inx,modalC) = probabilitySignal(inx,modalC) - interpProb;
    % Upper and lower boundaries as sum of weighted probabilites 
    if modalC == nClasses
        pLowers(inx) = sum(classes(1:end-1) .* probabilitySignal(inx,1:nClasses-1));
        pUppers(inx) = classes(1).*probabilitySignal(inx,nClasses);
    elseif modalC == 1
        pLowers(inx) = classes(1).*probabilitySignal(inx,1);
        pUppers(inx) = sum(classes(1:end-1).*probabilitySignal(inx,2:nClasses));
    else
        if modalC >= WeightedAvg(inx)
            pLowers(inx) = sum(classes(1:modalC-1).*probabilitySignal(inx,1:modalC-1));
            pUppers(inx) = sum(classes(1:end-modalC+1).*probabilitySignal(inx,modalC:nClasses));
        else
            pLowers(inx) = sum(classes(1:modalC).*probabilitySignal(inx,1:modalC));
            pUppers(inx) = sum(classes(1:end-modalC).*probabilitySignal(inx,modalC+1:nClasses));
        end
    end
    lowerLim(inx) = WeightedAvg(inx) - abs(pLowers(inx));
    upperLim(inx) = WeightedAvg(inx) + abs(pUppers(inx));
end

% Thresholding 
lowerLim(lowerLim < 0.5) = 0.5;
upperLim(upperLim > nClasses+0.5) = nClasses+0.5;