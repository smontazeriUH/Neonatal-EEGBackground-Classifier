function shapesplot(shapes,whichplot,minNtoplot,clean)
%  shapesplot(shapes,whichplot,minNtoplot,clean)
% plot all average shapes on the same axes, alongside skewness and kurtosis
% whichplot = 'shape' (or not given): plot av shapes
%             'skew': plot skew with fit
%             'kur': plot kurtosis with fit
% minNtoplot = integer minimum nbursts for which to plot shapes,
%              default=-inf 
% clean = flag for whether to remove diagnostic text. default=0.

if nargin<2
    whichplot='shape';
end
if nargin<3
    minNtoplot=-inf;
end
if nargin<4
    clean=0;
end

if clean
    tsc=1/250;
else
    tsc=1;
end

switch whichplot
    case {'shape','shapes'}
        shapeerrorbarplotflag=0;

        nshapes=length(shapes.avshape);
        shapecolors=hsv(nshapes+1);
        if nshapes==5,
            shapecolors(2,:)=[1.0000 0.8571 0]; % nicer yellow
            %shapecolors(2,:)=[1.0000 0.5 0]; % orange
            %shapecolors(2,:)=[0.9098 0.4627 0]; % "safety orange"
        end

        if shapeerrorbarplotflag
            for jj=nshapes:-1:1, errorbar(shapes.tt{jj},shapes.avshape{jj},shapes.avshape_sem{jj},'color',shapecolors(jj,:)), hold on, end
        else
            for jj=1:nshapes, 
                txtstar='*'; % if not plotting, will still label and denote missing with *
                if shapes.nbursts(jj)>=minNtoplot
                    plot(shapes.tt{jj},shapes.avshape{jj},'color',shapecolors(jj,:))
                    txtstar='';
                end
                hold on
                if ~clean
                    txt=[sprintf('dur=[%.f,%.f)  N=%d',shapes.durbins(jj),shapes.durbins(jj+1),shapes.nbursts(jj)) txtstar];
                    text(0.4,0.01+jj*0.03,txt,'color',shapecolors(jj,:),'fontsize',6,'units','normalized')
                end
            end
        end
        xlabel('t/T'), ylabel('<y(t,T)>')
    case 'skew'
        skdurs=shapes.dur*tsc;
        skewfit=polyfit(skdurs,shapes.skewd,1);
        plot(skdurs,shapes.skewc,'b.',skdurs,shapes.skewd,'k.'), hline=refline(skewfit); set(hline,'color','r'); if ~clean, text(0.05,0.85,[sprintf('\\Sigma=%f*dur ',skewfit(1)) char(44-sign(skewfit(2))) sprintf(' %f',abs(skewfit(2)))],'units','normalized'); xlabel('dur left edge (time pts)'), else xlabel('T (s)'), end, ylabel('\Sigma')
    case 'kur'
        skdurs=shapes.dur*tsc;
        kurfit=polyfit(skdurs,shapes.kurd,1);
        plot(skdurs,shapes.kurc,'b.',skdurs,shapes.kurd,'k.'), hline=refline(kurfit); set(hline,'color','r'); if ~clean, text(0.05,0.85,[sprintf('\\kappa=%f*dur ',kurfit(1)) char(44-sign(kurfit(2))) sprintf(' %f',abs(kurfit(2)))],'units','normalized'); xlabel('dur left edge (time pts)'), else xlabel('T (s)'), end, ylabel('\kappa')
    case 'skewlog' % not done
        skdurs=shapes.dur;
        skewfit=polyfit(skdurs,shapes.skewd,1);
        plot(skdurs,shapes.skewc,'b.',skdurs,shapes.skewd,'k.'), hline=refline(skewfit); set(hline,'color','r'); if ~clean, text(0.05,0.85,[sprintf('\\Sigma=%f*dur ',skewfit(1)) char(44-sign(skewfit(2))) sprintf(' %f',abs(skewfit(2)))],'units','normalized'); xlabel('dur left edge (time pts)'), else xlabel('T (s)'), end, ylabel('\Sigma')
    case 'kurlog' % not done
        skdurs=shapes.dur;
        kurfit=polyfit(skdurs,shapes.kurd,1);
        plot(skdurs,shapes.kurc,'b.',skdurs,shapes.kurd,'k.'), hline=refline(kurfit); set(hline,'color','r'); if ~clean, text(0.05,0.85,[sprintf('\\kappa=%f*dur ',kurfit(1)) char(44-sign(kurfit(2))) sprintf(' %f',abs(kurfit(2)))],'units','normalized'); xlabel('dur left edge (time pts)'), else xlabel('T (s)'), end, ylabel('\kappa')
    case 'all' % uses subplot, will not play nicely with other subplots
        subplot(2,2,[1 3]), shapesplot(shapes)
        subplot(2,2,2), shapesplot(shapes,'skew')
        subplot(2,2,4), shapesplot(shapes,'kur')
    otherwise
        error('invalid whichplot')
end
        
end