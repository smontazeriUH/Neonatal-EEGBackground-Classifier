function [I,M,SP] = ETDF(seq,seq2,en1,en2,dist)

% Computes mutual information of symbols at distance k in the sequence

% Compute probability of each symbol

symbols = unique(seq);
lambda = length(symbols);


symb_map = zeros(max(symbols),1);
for k = 1:length(symbols)
    symb_map(symbols(k)) = k;
end

symbol_count = zeros(lambda,1);

for k = 1:lambda
    symbol_count(k) = length(find(seq == symbols(k)));
end

% Symbol probability

symbol_prob = symbol_count./sum(symbol_count)+0.000001;


symbols2 = unique(seq2);
lambda2 = length(symbols2);


symb_map2 = zeros(max(symbols2),1);
for k = 1:length(symbols2)
    symb_map2(symbols2(k)) = k;
end

symbol_count2 = zeros(lambda2,1);

for k = 1:lambda2
    symbol_count2(k) = length(find(seq2 == symbols2(k)));
end

% Symbol probability

symbol_prob2 = symbol_count2./sum(symbol_count2)+0.000001;

% Compute transition matrix at distance dist 
mass = 0;
inds = 0;
M = zeros(lambda,lambda2);
M_w = zeros(lambda,lambda2);
if(dist > 0)
for k = 1:length(seq)-dist
    loc1 = symb_map(seq(k));    
    w1 = en1(k);
    
    loc2 = symb_map2(seq2(k+dist));  
    w2 = en2(k+dist);
    inds = inds+1;
    mass = mass+w1.*w2;
    M(loc1,loc2) = M(loc1,loc2)+1; 
    M_w(loc1,loc2) = M_w(loc1,loc2)+1.*(w1.*w2).^1;    
end
else
    for k = abs(dist)+1:length(seq)
    loc1 = symb_map(seq(k));    
    w1 = en1(k);   
    
    loc2 = symb_map2(seq2(k+dist));    
    w2 = en2(k+dist);
    
    M(loc1,loc2) = M(loc1,loc2)+1;
    M_w(loc1,loc2) = M_w(loc1,loc2)+1.*(w1.*w2).^1;    
    inds = inds+1;
    mass = mass+w1.*w2;
    end    
end

SP = symbol_prob*symbol_prob2';

% Pair joint probability
%M = M./mass.*inds;
M = M./sum(M(:))+0.0000000001;
M_w = M_w./sum(M_w(:))+0.0000000001;

%M
%SP

%M./SP

% Compute mutual information

I = sum(sum(M_w.*(M./SP))); %/log2(lambda);





