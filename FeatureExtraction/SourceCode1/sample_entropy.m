function [sse, A, B] = sample_entropy(uu, m, nr)
% m - embedding dimension?
% nr - 
epoch=60*32;
uuu{1,1}=uu(1:epoch);
uuu{2,1}=uu((epoch+1):(2*epoch));
uuu{3,1}=uu((2*epoch+1):(3*epoch));
uuu{4,1}=uu((3*epoch+1):(4*epoch));
uuu{5,1}=uu((4*epoch+1):end);

for k=1:5
u=uuu{k,1};    
for i=1:size(u,1)

N = length(u); 
% N = 1000;
% u = rand(1,N);
% m=3;
r  = nr*std(u);

% Sample Entropy
% Bm = zeros(1,N-m);
% for ii = 1:N-m
%     d  = zeros(1,N-m);
%     for jj = 1:N-m
%         u1 = u(ii:ii+m-1);
%         u2 = u(jj:jj+m-1);
%         d(jj) = max(abs(u1-u2));
%     end
%     Bm(ii) = (length(find(d<r))-1)/(N-m-1); 
% end
% B = sum(Bm)/(N-m);

% FASTER
d = r*ones(N-m,N-m);
for ii = 1:N-m
    for jj = ii+1:N-m
        u1 = u(ii:ii+m-1);
        u2 = u(jj:jj+m-1);
        d(ii,jj) = max(abs(u1-u2));
    end
end
B = 2*length(find(d<r))/(N-m-1)/(N-m);

% Am = zeros(1,N-(m+1));
% for ii = 1:N-(m+1)
%     d  = zeros(1,N-(m+1));
%     for jj = 1:N-(m+1)
%         u1 = u(ii:ii+(m+1)-1);
%         u2 = u(jj:jj+(m+1)-1);
%         d(jj) = max(abs(u1-u2));
%     end
%     Am(ii) = (length(find(d<r))-1)/(N-m-1); 
% end
% A = sum(Am)/(N-m);

% FASTER
d = r*ones(N-(m+1),N-(m+1));
for ii = 1:N-(m+1)
    for jj = ii+1:N-(m+1)
        u1 = u(ii:ii+(m+1)-1);
        u2 = u(jj:jj+(m+1)-1);
        d(ii,jj) = max(abs(u1-u2));
    end
end
A = 2*length(find(d<r))/(N-m-1)/(N-m);

se(i) = -log(A/B);
%SampEnmax = log(N-m)+log(N-m-1)-log(2);

end
sse_epoch(k)=mean(se);

end

sse=mean(sse_epoch);
end

