README FILE FOR REPRODUCIBLE RESEARCH - Gait Analysis to Track Parkinson’s Disease Evolution Using Reproducible Research
Practices
------------------------------------- 
A research work is reproducible when all research artifacts such as as text, data, figure and code are available for independent researchers reproduce the results. In this paper, we present a reproducible gait analysis to track Parkinson's Disease evolution by monitoring walking abnormalities. We applied Principal Component Analysis into gait data to detect user's abnormalities that may indicate the progression of Parkinson's Disease. We validated our approach with a public database [1] of foot sensor data, which includes vertical ground reaction force records of subjects with healthy gait and Parkinson's Disease patients. 

Computational sciences such as computer science, statistics, many fields of engineering, and signal processing are  theoretical and experimental. These sciences are result of a combination of theorems proving and development of computer codes to validate the research. According to Vanderwalle[2], to reproducible research increases the publication impact in these sciences. A research work is called reproducible if all information relevant to the work, including, text, data and code, are available for the independent researchers can reproduce the results. 

System Overview
================
Gait analysis studies the forces and moments of the movement of body segments in a human gait, including the measurement of VGRF. The patients use adapted force sensors under the feet and attached to the shoes to measure the VGRF[3]. The result of this acquired data is the movement signal.

The biomechanical analysis of human gait is part of the diagnosis and treatment process for PD. During this analysis, the patients are required to walk. The doctor analyses the gait by looking at the swing and stance phase and the gait posture. To automate the identification of each gait phase in the VGRF data, it is necessary to use signal processing techniques. In this work, we focus on the VGRF of each foot and identifying when the foot initiates contact (i.e., start of stance phase) with the ground and when it is off the ground (i.e., start of swing phase). For this purpose, we used the peaks and valleys technique.

After identifying the cycle, we extract a window length with the cycle movement and the gait characteristics and transform the VGRF data into PCA values. We project the values into the \textit{eigenspace} providing a visualization tool to doctor. With this information, the doctor evaluates the patient's gait.


Materials and Methods
=====================
Principal Component Analysis (PCA) is a statistic procedure to reduce data and eliminate redundancies. It identifies the data variance and applies linear data transformation to detect the most relevant data components on the first dimension, called the main axis.  The second remaining variance is the secondary axis and so on [4].

PCA consists of the following steps[4]: 
  1. Scale the measurement data into an m x n matrix, where m is the number of measurement types and n is the number of samples;
  2. Subtract the mean for each measurement type;
  3. Calculate the eigenvectors and eigenvalues of the covariance matrix.
  4. The Calculated eigenvectors and eigenvalues can be used to project the data into a new space called eigenspace.


Reproducing the Results
=============================
Considering you have checkout the repository, so:

1. The Rawdata of research subjects are splited on the "Normal" directory where is located the Control Group Files, and the Parkinson Disease Subjects are in the "Parkinson" directory.
2. To support to reproduce our results we processed the raw data into an Saved Data Array located into the "GaitDataBase.mat" file.
3. To run this files on OCTAVE it is necessary install the Statiscs Package, version 1.2.4. Located on to libs directory. But, in the Matlab Version 12 this code runs correctly.
4. The Main File of this Research is the "EigenGaitMain.m". If you followed the previous step you can reproduce our results just running this file.
5. The scripts to Generate the paper's figures is "FigurePlots.m". If you followed the previous step you can generate our plots.


References
==========
[1] Physionet: Parkinson Disease Database - http://physionet.org/pn3/gaitpdb/

[2] P. Vandewalle, J. Kovacevic, and M. Vetterli, “Reproducible research in signal processing,” Signal Processing Magazine, IEEE, vol. 26, no. 3, pp. 37–47, May 2009.

[3] W. Tao, T. Liu, R. Zheng, and H. Feng, “Gait analysis using wearable sensors,” Sensors, vol. 12, no. 2, 2012.

[4] J. Shlens, “A tutorial on principal component analysis,” in Systems Neurobiology Laboratory, Salk Institute for Biological Studies, 2005.
