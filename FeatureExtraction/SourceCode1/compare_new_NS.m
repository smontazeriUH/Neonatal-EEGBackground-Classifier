function [fit] = compare_new_NS(m, test_data)

% Determine list of inputs.
% inpn = cell(1, length(varargin));
% for kn = 1:length(varargin);
%     inpn{kn} = inputname(kn);
% end
% 
% v = {varargin{:} inpn};
% th = idss(v{2});
% th = th('y1', cell(0));
% 
% z = v{1};
% z = iddata(z(:, 1), z(:, 2:end), 1);
% y = pvget(z, 'OutputData');
% z1 = z(:, 'y1', cell(0));

%yh = predict(m, model_data', );
% if isnan(m.NoiseVariance)
%     fit=0;
% else

    [yhh, ~] = predict(m, test_data', 1, 'e');
    y = test_data;
    %Compute fit.
    err = norm(yhh' - y);
    meanerr = norm(y - mean(y));
    fit = 100*(1-err/meanerr);
% end

