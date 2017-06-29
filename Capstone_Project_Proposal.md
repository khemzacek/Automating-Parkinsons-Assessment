Capstone Project Proposal
================
Katherine Hemzacek
June 18, 2017

Abstract
--------

This project will create an algorithm that uses signal characteristics of voice recordings to predict Unified Parkinson's Disease Prediction Scale (UPDRS) scores, which are a standard measure of the severity of disability in Parkinson's patients. This could be implemented into the Kinetics Foundation's At Home Testing Device to aid in better disease progression monitoring, especially for remote patients.

[GitHub Repository](https://github.com/khemzacek/Automating-Parkinsons-Assessment)

![](AHTD.jpg)
Fig 1: The At Home Testing Device (AHTD)

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

|  subject.|  age|  sex|  test\_time|  motor\_UPDRS|  total\_UPDRS|  Jitter...|  Jitter.Abs.|  Jitter.RAP|  Jitter.PPQ5|  Jitter.DDP|  Shimmer|  Shimmer.dB.|  Shimmer.APQ3|  Shimmer.APQ5|  Shimmer.APQ11|  Shimmer.DDA|       NHR|     HNR|     RPDE|      DFA|      PPE|
|---------:|----:|----:|-----------:|-------------:|-------------:|----------:|------------:|-----------:|------------:|-----------:|--------:|------------:|-------------:|-------------:|--------------:|------------:|---------:|-------:|--------:|--------:|--------:|
|         1|   72|    0|      5.6431|        28.199|        34.398|    0.00662|     3.38e-05|     0.00401|      0.00317|     0.01204|  0.02565|        0.230|       0.01438|       0.01309|        0.01662|      0.04314|  0.014290|  21.640|  0.41888|  0.54842|  0.16006|
|         1|   72|    0|     12.6660|        28.447|        34.894|    0.00300|     1.68e-05|     0.00132|      0.00150|     0.00395|  0.02024|        0.179|       0.00994|       0.01072|        0.01689|      0.02982|  0.011112|  27.183|  0.43493|  0.56477|  0.10810|
|         1|   72|    0|     19.6810|        28.695|        35.389|    0.00481|     2.46e-05|     0.00205|      0.00208|     0.00616|  0.01675|        0.181|       0.00734|       0.00844|        0.01458|      0.02202|  0.020220|  23.047|  0.46222|  0.54405|  0.21014|
|         1|   72|    0|     25.6470|        28.905|        35.810|    0.00528|     2.66e-05|     0.00191|      0.00264|     0.00573|  0.02309|        0.327|       0.01106|       0.01265|        0.01963|      0.03317|  0.027837|  24.445|  0.48730|  0.57794|  0.33277|
|         1|   72|    0|     33.6420|        29.187|        36.375|    0.00335|     2.01e-05|     0.00093|      0.00130|     0.00278|  0.01703|        0.176|       0.00679|       0.00929|        0.01819|      0.02036|  0.011625|  26.126|  0.47188|  0.56122|  0.19361|
|         1|   72|    0|     40.6520|        29.435|        36.870|    0.00353|     2.29e-05|     0.00119|      0.00159|     0.00357|  0.02227|        0.214|       0.01006|       0.01337|        0.02263|      0.03019|  0.009438|  22.946|  0.53949|  0.57243|  0.19500|

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
