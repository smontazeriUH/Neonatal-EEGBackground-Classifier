% baby av fits using Clauset methods

mindur=40e-3; % in s, discard all bursts shorter than this

%disttype='interp'; % 'raw' or 'interp'

figdir='L:\Lab_MichaeBr\jamesR\babyavs\figs\';

%old
%bs_set = [36,38,40,42,44,46,48,16,18,22,26,12];
%cts_set = [37,39,41,43,45,47,50,17,20,23,27,13];
% final 10 babies
bs_set=[11 18 22 26 29 38 42 44 46 48];
cts_set=[13 20 23 27 30 39 43 45 47 49];
bs_dist_set=[9 11 15 18 22 26 29 32 38 42 44 46 48];
%runset=sort([bs_set cts_set]);
%runset=sort([cts_set bs_dist_set]);
%runset=bs_dist_set;
% all
runset=1:57; %%%%%%%%%%%%%%%


%allthrs=cell(1,runset(end));
%allxmins=cell(1,runset(end));
%allparetoalphas=cell(1,runset(end));
%allpowerexpalphas=cell(1,runset(end));

for j=runset
    %figure(200+j), clf
    %figorigpos
    %figdoublewidth
    %figdoubleheight
    fprintf(1,'j=%d  %s\n',j,instrings{j});
    
    %navs=zeros(1,nfilt);
    %alphas=zeros(1,nfilt);
    %powerexpalphas=zeros(1,nfilt);
    %xmins=zeros(1,nfilt);
    
    
    avs=getbabyavs(j,[49 10]); % [27 12], [49 10], [51 6]
    
    % trim to mindur - eventually should merge into extractavstats
    pretrimmeddurs=extractavdata(avs,'durs');
    okdurs=pretrimmeddurs>=mindur;
    avs=avs(okdurs);
    
	avstats(j)=extractavstats(avs); % both areas and durs, but NO MINDUR
    
    %area_avs=extractavdata(avs,'areas',mindur);
    
    
    
    %subplot(2,2,1), plot(t,ypowfilt,'b',[t(1) t(end)],thr*[1 1],'r'), title(strrep(instrings{j},'_','\_')), xlabel('t (s)'), ylabel('ypowfilt (\muV^2/Hz)')
    %subplot(2,2,1), plot(sgk,navs,'b'), xlabel('sgk'), ylabel('navs'), title(strrep(instrings{j},'_','\_'))
    %subplot(2,2,2), semilogy(xdat,xmins,'b'), xlabel(xlab), ylabel('area xmin')
    %subplot(2,2,3), plot(xdat,alphas,'b'), xlabel(xlab), ylabel('area pareto alpha')
    %subplot(2,2,4), plot(xdat,powerexpalphas,'b'), xlabel(xlab), ylabel('area powerexp alpha')
    
    %allthrs{j}=thrs;
    %allxmins{j}=xmins;
    %allparetoalphas{j}=alphas;
    %allpowerexpalphas{j}=powerexpalphas;
    
    %saveas(gcf,[figdir 'baby_nosgolay_thresh_' instrings{j} '.fig'])
    %save([figdir 'baby_clausetfits_f49_k10_nomindur' instrings{j}],'avstats')
    
    
    
end

save([figdir 'baby_clausetfits_f27_k12_mindur40ms___'],'avstats')
