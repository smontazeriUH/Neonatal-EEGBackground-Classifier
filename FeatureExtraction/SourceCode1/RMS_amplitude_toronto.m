function result = RMS_amplitude_toronto(data)
% data must be a horizontal vector

% if size(data,1) < size(data,2)
%     data = data';
% end
%result = sqrt((data'*data)/(length(data)));
result = rms(data');


