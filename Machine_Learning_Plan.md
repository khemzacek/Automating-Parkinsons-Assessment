Machine Learning Plan
================
KHemzacek
September 6, 2017

Machine learning will be used to create a model to predict motor UPDRS scores. As the outcome variable is continuous and at least some of the features seem to have a strong enough linear correlation with the outcome variable, linear regression will be the primary technique used.

The data will first be split into train and test sets. Because the observations are not independent of each other, a simple random split with cannot be used. Instead, a random 4 of 42 patients are fully allocated to the test set and a random 20% of observations from each of the rest of the patients is also allocated to the test set. This results in just over 70% of all observations being allocated to the train set. This type of split ensures two things: 1) a good representation of different subjects in both training and testing sets to prevent overfitting to a few patients, and 2) that the testing set contained some patients that were not present in the training set to demonstrate the model's efficacy on unseen patients.

A linear regression model will then be built to predict motor UPDRS scores. The dataset features will be explored to find sets of features that are strongly correlated with UPDRS and weakly correlated with each other. These sets can each be used to create a model and the efficacy of each of these models can be compared to find the best model.

Because the observations are not independent of each other, the linear regression algorithm should not be run on all observations together. Instead, a set of independent observations will be selected with one random observation from each person. A linear regression model will be trained using this set and the output of this model will be saved. This will be repeated many times and the coefficient values will be averaged to create a single model. This model can then be tested on the test dataset to determine its efficacy on new data.

This best model will also be compared to a model that was trained with a set of observations that are not independent from each other. The model may also be compared with a Regression Tree model (CART for continuous variables), to see if the data is better described by a model that is not linear in nature. The R-squared value will be used as the primary measure of success to compare all of the different models. This can be used both to measure performance on the training set, and then to measure performance on the test set to confirm the model's performance on unseen data.
