function [mdfa,mdfa_max] = multifractal_analysis(eeg_seg)
% eeg_seg must be a horizontal vector
signal=eeg_seg';


X=cumsum(signal-mean(signal));
X=transpose(X);
scale=[16,32,64,128,256,512,1024];
q=[-5,-3,-1,0,1,3,5];
m=1;
for ns=1:length(scale),
    segments(ns)=floor(length(X)/scale(ns));
    for v=1:segments(ns),
        Index=((((v-1)*scale(ns))+1):(v*scale(ns)));
        C=polyfit(Index,X(Index),m);
        fit=polyval(C,Index);
        RMS{ns}(v)=sqrt(mean((X(Index)-fit).^2));
    end
    for nq=1:length(q),
        qRMS{nq,ns}=RMS{ns}.^q(nq);
        Fq(nq,ns)=mean(qRMS{nq,ns}).^(1/q(nq));
    end
    Fq(q==0,ns)=exp(0.5*mean(log(RMS{ns}.^2)));
end

%Matlab code 9-------------------------------------------
for nq=1:length(q)
    C=polyfit(log2(scale),log2(Fq(nq,:)),1);
    Hq(nq)=C(1);
    qRegLine{nq}=polyval(C,log2(scale));
end
%Matlab code 10------------------------------------------
tq=Hq.*q-1;

%Matlab code 11------------------------------------------
hq=diff(tq)./(q(2)-q(1));
Dq=(q(1:end-1).*hq)-tq(1:end-1);

mdfa=trapz(Dq);
mdfa_max=max(Dq);
end