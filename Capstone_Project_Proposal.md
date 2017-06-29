Capstone Project Proposal
================
Katherine Hemzacek
June 18, 2017

Abstract
--------

This project will create an algorithm that uses signal characteristics of voice recordings to predict Unified Parkinson's Disease Prediction Scale (UPDRS) scores, which are a standard measure of the severity of disability in Parkinson's patients. This could be implemented into the Kinetics Foundation's At Home Testing Device to aid in better disease progression monitoring, especially for remote patients.

[GitHub Repository](https://github.com/khemzacek/Automating-Parkinsons-Assessment)

![Fig 1: The At Home Testing Device (AHTD)](AHTD.jpg)

Problem Setup
-------------

The current gold-standard for monitoring the progression of Parkinson's Disease (PD) is the Unified Parkinson's Disease Rating Scale (UPDRS). To get a UPDRS score, a patient will perform a series of tasks and a trained medical rater will assess the degree of disability shown in the patient. This assessment protocol can be problematic for two reasons: 1) The test must be done in person, which limits how often monitoring can be done, especially for rural patients with a long commute into a medical center. 2) The test is subjective, so tests often require longer and depend on clinical opinion.

The Kinetics Foundation, with the help of Intel, developed an At Home Testing Device (AHTD) to test the feasibility of remote monitoring for PD patients. This device guides patients through a series of tasks and records the results, which are then sent via internet to the patient's physician. The AHTD would allow monitoring measurements to be performed much more frequently, detecting changes more quickly. It would also reduce the travel time required of patients, especially rural patients. The measurements taken by this device could also be analyzed quantitatively, making the measurement of PD progression less subjective and potentially automated.

This project will focus on the automated analysis of voice recordings resulting from a speech task that AHTD users were asked to perform. An algorithm will be developed that uses signal characteristics of these voice recordings to predict a UPDRS score. This algorithm could potentially be implemented into the AHTD or other similar devices to better automate all PD monitoring and to increase the feasibility of implementing widespread AHTD usage by reducing the time required of physicians to interpret results.

Data
----

This project will use the Oxford Parkinson's Disease Telemonitoring Dataset, available [here](https://archive.ics.uci.edu/ml/datasets/parkinsons+telemonitoring). It was donated to the UCI Machine Learning Repository on 2009-10-29 by Athanasios Tsanas and Max Little of the University of Oxford.

The voice recordings were obtained as part of a feasibility study for the AHTD<sup>1</sup>. A variety of signal processing techniques were then applied to each recording to calculate the signal attributes that are shown in the dataset referenced above<sup>2</sup>.

The overall dataset includes 22 attributes for 5875 observations.

The observations come from 42 unique people, each taking about 150 recordings over a 6-month period. Once per week, each subject would take six recordings of the same sound (a sustained vowel phonation "ah"). Four of the six were done at normal speaking volume and the other two were done at a louder volume.

The attributes include:

-   Subject number
-   Time since trial recruitment
-   2 subject demographics (age, gender)
-   2 UPDRS scores (total, motor)
-   16 signal attributes
    -   5 measures of variation in fundamental frequency (Jitter(%), Jitter(Abs), Jitter:RAP, Jitter:PPQ5, Jitter:DDP)
    -   6 measures of variation in amplitude (Shimmer, Shimmer(dB), Shimmer:APQ3, Shimmer:APQ5, Shimmer:APQ11, Shimmer:DDA)
    -   5 non-linear signal characteristics: NHR (Noise to Harmonics Ratio), HNR (Harmonics to Noise Ratio), RPDE (Recurrence Period Density Entropy), DFA (Detrended Fluctuation Analysis), PPE (Pitch Period Entropy)

The dataset header is shown below:
<script data-pagedtable-source type="application/json">
{"columns":[{"label":["subject."],"name":[1],"type":["int"],"align":["right"]},{"label":["age"],"name":[2],"type":["int"],"align":["right"]},{"label":["sex"],"name":[3],"type":["int"],"align":["right"]},{"label":["test_time"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["motor_UPDRS"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["total_UPDRS"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Jitter..."],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Jitter.Abs."],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Jitter.RAP"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["Jitter.PPQ5"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["Jitter.DDP"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["Shimmer"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["Shimmer.dB."],"name":[13],"type":["dbl"],"align":["right"]},{"label":["Shimmer.APQ3"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["Shimmer.APQ5"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["Shimmer.APQ11"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["Shimmer.DDA"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["NHR"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["HNR"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["RPDE"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["DFA"],"name":[21],"type":["dbl"],"align":["right"]},{"label":["PPE"],"name":[22],"type":["dbl"],"align":["right"]}],"data":[{"1":"1","2":"72","3":"0","4":"5.6431","5":"28.199","6":"34.398","7":"0.00662","8":"3.380e-05","9":"0.00401","10":"0.00317","11":"0.01204","12":"0.02565","13":"0.230","14":"0.01438","15":"0.01309","16":"0.01662","17":"0.04314","18":"0.014290","19":"21.640","20":"0.41888","21":"0.54842","22":"0.16006"},{"1":"1","2":"72","3":"0","4":"12.6660","5":"28.447","6":"34.894","7":"0.00300","8":"1.680e-05","9":"0.00132","10":"0.00150","11":"0.00395","12":"0.02024","13":"0.179","14":"0.00994","15":"0.01072","16":"0.01689","17":"0.02982","18":"0.011112","19":"27.183","20":"0.43493","21":"0.56477","22":"0.10810"},{"1":"1","2":"72","3":"0","4":"19.6810","5":"28.695","6":"35.389","7":"0.00481","8":"2.462e-05","9":"0.00205","10":"0.00208","11":"0.00616","12":"0.01675","13":"0.181","14":"0.00734","15":"0.00844","16":"0.01458","17":"0.02202","18":"0.020220","19":"23.047","20":"0.46222","21":"0.54405","22":"0.21014"},{"1":"1","2":"72","3":"0","4":"25.6470","5":"28.905","6":"35.810","7":"0.00528","8":"2.657e-05","9":"0.00191","10":"0.00264","11":"0.00573","12":"0.02309","13":"0.327","14":"0.01106","15":"0.01265","16":"0.01963","17":"0.03317","18":"0.027837","19":"24.445","20":"0.48730","21":"0.57794","22":"0.33277"},{"1":"1","2":"72","3":"0","4":"33.6420","5":"29.187","6":"36.375","7":"0.00335","8":"2.014e-05","9":"0.00093","10":"0.00130","11":"0.00278","12":"0.01703","13":"0.176","14":"0.00679","15":"0.00929","16":"0.01819","17":"0.02036","18":"0.011625","19":"26.126","20":"0.47188","21":"0.56122","22":"0.19361"},{"1":"1","2":"72","3":"0","4":"40.6520","5":"29.435","6":"36.870","7":"0.00353","8":"2.290e-05","9":"0.00119","10":"0.00159","11":"0.00357","12":"0.02227","13":"0.214","14":"0.01006","15":"0.01337","16":"0.02263","17":"0.03019","18":"0.009438","19":"22.946","20":"0.53949","21":"0.57243","22":"0.19500"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

The dataset can be downloaded as a csv file [here](https://archive.ics.uci.edu/ml/machine-learning-databases/parkinsons/telemonitoring/parkinsons_updrs.data).

Analysis Approach
-----------------

The biggest challenge in analyzing the data will be addressing the fact that the observations are not truly independent. To address this, the data will first be analyzed as if the observations are independent, then replicate observations will be averaged and subsets of independent observations will be analyzed.

To analyze the observations as if they are independent, correlation between attributes will first be explored. Then a supervised machine learning algorithm will be used to predict UPDRS scores. A clustering algorithm will also be used to see if the observations cluster by a certain variable (such as by patient).

Summary statistics will then be taken for the set of replicate observations for each patient each week. For each signal characteristic, a measure of central tendency and a measure of variability will be calculated. Subsets of independent instances can then be analyzed and a supervised machine learning algorithm will be used to predict UPDRS scores.

Deliverables
------------

The primary deliverables are the code used to execute the analysis described above, and the final code which would automatically predict the UPDRS score.

I will also deliver a paper and slide deck which will communicate the analysis process and the findings. The paper and slide deck will be targeted at a representative of the Kinetics Foundation and will aim to persuade the client to implement the algorithm into the AHTD.

All final deliverables, as well as intermediate deliverables, will be made available on the project's [GitHub Repository](https://github.com/khemzacek/Automating-Parkinsons-Assessment).

References
----------

1.  Goetz, C.G. et al. Testing objective measures of motor impairment in early Parkinson's disease: Feasibility study of an at-home testing device. Movement Disorders (December 11, 2008) doi. 10.1002/mds.22379

2.  Athanasios Tsanas, Max A. Little, Patrick E. McSharry, Lorraine O. Ramig (2009), 'Accurate telemonitoring of Parkinson's disease progression by non-invasive speech tests', IEEE Transactions on Biomedical Engineering.
