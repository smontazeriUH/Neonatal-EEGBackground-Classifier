# NeonatalEEG-BTvisualisation
This repository contains a set of Matlab codes for classifying and visualising the neonatal EEG background activity.

*   &nbsp;&nbsp;&nbsp;Run main.m to get a visualisation of background trend for the input EDF file/files.
  
*   &nbsp;&nbsp;&nbsp;Run main_preprocessing.m to get a MAT file containing preprocessed resamples EEG signal.
  
*   &nbsp;&nbsp;&nbsp;Run main_featureExtraction.m to get an excel file containing 98 features calculated from preprocessed EEG data.

## EEG files
Example EEG recordings (in EDF format) from 4 neonates.  
Please extract ZIP files under the same name and the same directory.

## Prerequisites
MATLAB 2019a

## References
  &nbsp;&nbsp;&nbsp;De Wel, O., Lavanga, M., Dorado, A.C., Jansen, K., Dereymaeker, A., Naulaers, G., et al. (2017). Complexity analysis of neonatal EEG using multiscale entropy: applications in brain maturation and sleep stage classification. Entropy 19(10), 516. doi: 10.3390/e19100516.  
  &nbsp;&nbsp;&nbsp;Dereymaeker, A., Koolen, N., Jansen, K., Vervisch, J., Ortibus, E., De Vos, M., et al. (2016). The suppression curve as a quantitative approach for measuring brain maturation in preterm infants. Clin Neurophysiol 127(8), 2760-2765. doi: 10.1016/j.clinph.2016.05.362.  
  &nbsp;&nbsp;&nbsp;Greene, B.R., Faul, S., Marnane, W.P., Lightbody, G., Korotchikova, I., and Boylan, G.B. (2008). A comparison of quantitative EEG features for neonatal seizure detection. Clin Neurophysiol 119(6), 1248-1261. doi: 10.1016/j.clinph.2008.02.001.  
  &nbsp;&nbsp;&nbsp;Higuchi, T. (1988). Approach to an irregular time series on the basis of the fractal theory. Physica D 31(2), 277-283. doi: 10.1016/0167-2789(88)90081-4.  
  &nbsp;&nbsp;&nbsp;Ihlen, E.A. (2012). Introduction to multifractal detrended fluctuation analysis in matlab. Front Physiol 3, 141. doi: 10.3389/fphys.2012.00141.  
  &nbsp;&nbsp;&nbsp;Iyer, K.K., Roberts, J.A., Hellstrom-Westas, L., Wikstrom, S., Hansen Pupp, I., Ley, D., et al. (2015). Cortical burst dynamics predict clinical outcome early in extremely preterm infants. Brain 138(Pt 8), 2206-2218. doi: 10.1093/brain/awv129.  
  &nbsp;&nbsp;&nbsp;Iyer, K.K., Roberts, J.A., Metsaranta, M., Finnigan, S., Breakspear, M., and Vanhatalo, S. (2014). Novel features of early burst suppression predict outcome after birth asphyxia. Ann Clin Transl Neurol 1(3), 209-214. doi: 10.1002/acn3.32.  
  &nbsp;&nbsp;&nbsp;Kantelhardt, J.W., Koscielny-Bunde, E., Rego, H.H., Havlin, S., and Bunde, A. (2001). Detecting long-range correlations with detrended fluctuation analysis. Physica A 295(3-4), 441-454. doi: 10.1016/S0378-4371(01)00144-3.  
  &nbsp;&nbsp;&nbsp;Koolen, N., Jansen, K., Vervisch, J., Matic, V., De Vos, M., Naulaers, G., et al. (2014). Line length as a robust method to detect high-activity events: automated burst detection in premature EEG recordings. Clin Neurophysiol 125(10), 1985-1994. doi: 10.1016/j.clinph.2014.02.015.  
  &nbsp;&nbsp;&nbsp;Navakatikyan, M.A., O’Reilly, D., and Van Marter, L.J. (2016). Automatic measurement of interburst interval in premature neonates using range EEG. Clin Neurophysiol 127(2), 1233-1246. doi: 10.1016/j.clinph.2015.11.008.  
  &nbsp;&nbsp;&nbsp;O’Toole JM, Boylan GB, Vanhatalo S, Stevenson NJ. Estimating functional brain maturity in very and extremely preterm neonates using automated analysis of the electroencephalogram. Clinical Neurophysiology. 2016; 127(8): 2910-8.  
  &nbsp;&nbsp;&nbsp;Palmu, K., Stevenson, N., Wikstrom, S., Hellstrom-Westas, L., Vanhatalo, S., and Palva, J.M. (2010). Optimization of an NLEO-based algorithm for automated detection of spontaneous activity transients in early preterm EEG. Physiol Meas 31(11), N85-93. doi: 10.1088/0967-3334/31/11/N02.  
  &nbsp;&nbsp;&nbsp;Peng, C.K., Buldyrev, S.V., Havlin, S., Simons, M., Stanley, H.E., and Goldberger, A.L. (1994). Mosaic organization of DNA nucleotides. Phys Rev E Stat Phys Plasmas Fluids Relat Interdiscip Topics 49(2), 1685-1689. doi: 10.1103/physreve.49.1685.  
  &nbsp;&nbsp;&nbsp;Rasanen, O., Metsaranta, M., and Vanhatalo, S. (2013). Development of a novel robust measure for interhemispheric synchrony in the neonatal EEG: activation synchrony index (ASI). Neuroimage 69, 256-266. doi: 10.1016/j.neuroimage.2012.12.017.  
  &nbsp;&nbsp;&nbsp;Stevenson, N.J., Korotchikova, I., Temko, A., Lightbody, G., Marnane, W.P., and Boylan, G.B. (2013). An automated system for grading EEG abnormality in term neonates with hypoxic-ischaemic encephalopathy. Ann Biomed Eng 41(4), 775-785. doi: 10.1007/s10439-012-0710-5.  
  &nbsp;&nbsp;&nbsp;Stevenson NJ, Oberdorfer L, Koolen N, O’Toole JM, Werther T, Klebermass-Schrehof K, Vanhatalo S. Functional maturation in preterm infants measured by serial recording of cortical activity. Scientific Reports. 2017; 7(1): 12969.  
  &nbsp;&nbsp;&nbsp;Temko, A., Thomas, E., Marnane, W., Lightbody, G., and Boylan, G. (2011). EEG-based neonatal seizure detection with Support Vector Machines. Clin Neurophysiol 122(3), 464-473. doi: 10.1016/j.clinph.2010.06.034.  
  &nbsp;&nbsp;&nbsp;van Putten, M.J. (2007). The revised brain symmetry index. Clin Neurophysiol 118(11), 2362-2367. doi: 10.1016/j.clinph.2007.07.019. 



