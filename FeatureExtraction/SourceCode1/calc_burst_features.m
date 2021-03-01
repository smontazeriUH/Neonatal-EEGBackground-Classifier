function [burst_nro,burst_duration,ibi_duration]=calc_burst_features(eeg_seg,fs_new)

% % % % % % figure;plot(t2,channel)
% % % % % % hold on;
% % % % % % plot(t2(end_point_bursts),ones(length(t2(end_point_bursts))),'ro')
% % % % % % plot(t2(start_point_bursts),ones(length(t2(start_point_bursts))),'go')
% % % % % %
% % % % % %
% % % % % % figure;plot(t2,channel)
% % % % % % hold on;
% % % % % % plot(t2(end_point_ibis),zeros(length(t2(end_point_ibis))),'ro')
% % % % % % plot(t2(start_point_ibis),zeros(length(t2(start_point_ibis))),'go')
% % % % % %

[t2, channel] = detector_per_channel_palmu(eeg_seg, fs_new);

%sections=diff(channel);
inds_burts=find(channel==1);
inds_ibis=find(channel==0);
inds_burst=find(diff(inds_burts)>1);
inds_ibi=find(diff(inds_ibis)>1);
end_point_bursts=inds_burts(inds_burst);
end_point_ibis=inds_ibis(inds_ibi);
start_point_ibis=end_point_bursts+1;
start_point_bursts=end_point_ibis+1;

if ~isempty(start_point_ibis) || ~isempty(end_point_ibis) || ~isempty(start_point_bursts) || ~isempty(end_point_bursts)
    
    if channel(1)==0 && channel(end)==1
        %disp('eka')
        val_start=inds_burts(inds_burst(end)+1);
        end_point_ibis(1)=[];
        end_point_ibis=[end_point_ibis, val_start-1];
    end
    
    if channel(1)==1 && channel(end)==1
        %disp('toka')
%         val_start=inds_ibis(inds_ibi(end)+1); % changed by Saeed since it
%         has not used any where and causes error in program
        end_point_bursts(1)=[];
        end_point_ibis=[end_point_ibis, inds_ibis(end)];
    end
    
    if channel(1)==0 && channel(end)==0
        %disp('kolmas')
        val_start=inds_ibis(inds_ibi(end)+1);
        end_point_ibis(1)=[];
        end_point_bursts=[end_point_bursts,val_start-1];
    end
    
    if channel(1)==1 && channel(end)==0
        %disp('neljäs')
        val_start=inds_ibis(inds_ibi(end)+1);
        end_point_bursts(1)=[];
        end_point_bursts=[end_point_bursts,val_start-1];
    end
    
    dur_ibis=t2(end_point_ibis)-t2(start_point_ibis);
    dur_ibis(dur_ibis==0)=t2(2)-t2(1);
    dur_bursts=t2(end_point_bursts)-t2(start_point_bursts);
    dur_bursts(dur_bursts==0)=t2(2)-t2(1);
    
    % % % %     start_point=1;
    % % % %     inds=find(ba(jj,:));
    % % % %     inds_diff=diff(inds);
    % % % %     bursts=find(inds_diff>1);
    % % % %     if length(bursts)~=0
    % % % %         for kk=1:length(bursts)+1
    % % % %             if kk==(length(bursts)+1)
    % % % %                 end_point=length(inds);
    % % % %             else
    % % % %                 end_point=bursts(kk);
    % % % %             end
    % % % %             sig=ba(jj,start_point:end_point);
    % % % %             s=inds(start_point);
    % % % %             e=inds(end_point);
    % % % %             dur(kk)=t2(e)-t2(s); %Duration of the bursts
    % % % %
    % % % %             start_point=end_point+1;
    % % % %         end
    % % % %     else
    % % % %         dur(kk)=0;
    % % % %     end
    
    nro_channel=length(start_point_bursts);
    dur_bursts_channel = mean(dur_ibis);
    dur_ibis_channel = mean(dur_bursts);
    
    %ind_ibi=(find(ba(jj,:)==0));
    %p=find(diff(ind_ibi)==1);
else
    nro_channel=0;
    dur_bursts_channel = 0;
    dur_ibis_channel = 0;
end

if isnan(nro_channel)
    burst_nro = 0;
else
    burst_nro = nro_channel;
end

if isnan(dur_bursts_channel)
    burst_duration = 0;
else
    burst_duration = dur_bursts_channel;
end

if isnan(dur_ibis_channel)
    ibi_duration = 0;
else
    ibi_duration = dur_ibis_channel;
end

end