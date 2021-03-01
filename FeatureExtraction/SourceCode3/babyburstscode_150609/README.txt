--------------------------
Baby burst analysis code


Authors:

James Roberts
Kartik Iyer
Michael Breakspear

QIMR Berghofer 2011-2015

Readme version 5 June 2015
--------------------------

Apologies for the scruffy nature of this "research code"...send any queries to
james.roberts@qimrberghofer.edu.au


------------------------
 Scripts
------------------------

prem_analysis.m - after having loaded in a given EEG epoch [for example using
		  load('6_1.mat')], performs pre-processing on the time series,
		  calculates the instantaneous power signal, extracts bursts
		  (aka avalanches or "avs"), calculates average shapes, and
		  calculates slope of duration-vs-area plot.

baby_avdatafits.m - read in each epoch, extract bursts, calculate burst
                    statistics (area exponent and dur-vs-area slope)


------------------------
 Functions
------------------------

getbabyypow.m - given an epoch's index number, reads the time series, calculates
                instantaneous power

getbabyavs.m - given an epoch's index number, gets the bursts

nthrstest.m - given a time series, calculates data-derived threshold

extractbursts.m - given a time series and threshold, extracts all bursts

extractavstats.m - given bursts, calculates areas and durations and their
		   statistics (fit distributions to get parameters
		   including burst area power-law exponent alpha, and various
                   estimates of the duration-vs-area slope)

extractavdata.m - given bursts, calculates areas and durations

adurplot.m - given burst areas and durations, calculates slope measure from
             duration-vs-area plot

getBDvsBAexponent.m - another alternative code for obtaining duration-vs-area
                      slope measure

extractshapes2.m - given bursts, calculates average shapes (incl skew and
                   kurtosis measures)
dependencies: extractshapes_singledur.m, burstinterp.m,
	      burstinterp_single_ends.m, burstinterp_single_uniform.m,
	      structcat2.m

shapesplot.m - given a shapes struct output by extractshapes2, plots average
               shapes, skew, kurtosis


------------------------
 Included external code
------------------------

pltools/* - Aaron Clauset's power-law fitting MATLAB code from
http://tuvalu.santafe.edu/~aaronc/powerlaws/ 
plus parplpva2.m by Casper Peterson, also available above

pli_R_matlabport/* - My (JR's) MATLAB port of Cosma Shalizi's R code from
http://tuvalu.santafe.edu/~aaronc/powerlaws/
includes: allplfits.m - our code to do all the fits at once, extracting burst
	                area exponent alpha amongst others
	  ploteucdfwithfits.m - our code to plot an empirical CDF with fits
	                        overlaid 
	  powerstrict_fit.m - our implementation of the Deluca and Corral (2013)
			      [Fitting and goodness-of-fit test of non-truncated
			      and truncated power-law distributions. Acta
			      Geophys 61:1351–1394] method for fitting a
                              strictly-truncated power law 

Clauset and Shalizi's codes are available here:
http://tuvalu.santafe.edu/~aaronc/powerlaws/powerlaws_full_v0.0.10-2012-01-17.zip
(note they also provide C and python ports too)
