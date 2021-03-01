%Function: ar_prediction_error
%Author: Stephen Faul
%Date: 9th May 2005
%Description: Create an AR model using some data. Then see how the prediction from that model matches the test data
%               fit_error=ar_prediction_error(model_data,test_data,ar_order)

function fit_error=ar_prediction_error_ns(model_data,test_data,ar_order)
% model_data = remove_infsnans(model_data);
% test_data = remove_infsnans(test_data);

for zzz=1:ar_order
    m = ar(model_data,zzz,'YW');
    %           [simulated_data,fit_error(zzz)] = compare(test_data,m{zzz},1);
    fit_error(zzz) = compare_new_NS(m, test_data);
end
end
