# load packages
library("dplyr")
library("tidyr")
library("ggplot2")
library("GGally")
library("readxl")

# load data
parkinsons <- read.csv("parkinsons_data.csv")

# examine structure of dataset
str(parkinsons)
# first 3 int; last 19 are num --> as expected
# Apparent issues: no volume variable, special characters in names, 
# "sex" unclear 
summary(parkinsons)


# Add in volume level variable
# According to source, indices should line up
Volume <- read_excel("Xloud_normal.xlsx", sheet = "Loudness level",
                     col_names = FALSE)
dim(parkinsons)[1] == dim(Volume)[1]
# returns TRUE, data read correctly and indices should line up
parkinsons <- bind_cols(parkinsons, Volume)
str(parkinsons)
# the volume variable should be given a descriptive name
# it should also be a factor, not a char
parkinsons <- rename(parkinsons, Volume = X__1)
parkinsons$Volume <- as.factor(parkinsons$Volume)
str(parkinsons)


# special characters in variable names did not read into r correctly
# fix names that didn't read in correctly
parkinsons <- rename(parkinsons, subject_num = subject.,
                     Jitter_Percent = Jitter...,
                     Jitter_Abs = Jitter.Abs.,
                     Jitter_RAP = Jitter.RAP, 
                     Jitter_PPQ5 = Jitter.PPQ5,
                     Jitter_DDP = Jitter.DDP,
                     Shimmer_dB = Shimmer.dB.,
                     Shimmer_APQ3 = Shimmer.APQ3,
                     Shimmer_APQ5 = Shimmer.APQ5,
                     Shimmer_APQ11 = Shimmer.APQ11,
                     Shimmer_DDA = Shimmer.DDA)


# "sex" variable is unclear - Is 0 male or female?
# 0 is male, 1 is female; rename to female so that binary 1 = yes is female
parkinsons <- rename(parkinsons, female = sex)


# TYPOS/MISSING VALUES?

# check for NA and unexpected 0s
# we expect 0s in the female column (for male); makes no sense elsewhere
if ((sum(is.na(parkinsons)) + sum((select(parkinsons, -female) == 0)))  == 0) {
  print("No missing values")
} else {
  print("Contains missing values")
}
# Returns "No missing values"
# Or, summary() shows a count of the NAs
# summary() also shows a range. Neither 0s or negative numbers make sense for
# most of these variables, so as long as the min is above 0, this code isn't 
# really necessary


# Check if demographic info (age, sex) is consistent within each subject
# Check if expected number of subjects is present
demographics <- select(parkinsons, subject_num, age, female) %>% distinct()
if (length(unique(parkinsons$subject_num)) == length(demographics$subject_num)) {
  print("Demographics consistent. Number of subjects:")
  length(demographics$subject_num)
} else {
  print("Demographics not consistent")
}
# Returns "Demographics consistent" "42" --> as expected


# HISTOGRAMS
# check for unexpected values or distribution shapes

# Check subject_num variable distribution
ggplot(parkinsons, aes(subject_num)) +
  geom_histogram(bins = 42)
# all 42 subjects are numbered in order starting at 1, no numbers skipped or missing
# bins not even --> subjects did not all take same number of recordings
  # could be due to missing time points or missing replicate trials; need to check
# histogram plot - how many subjects had #-# recordings
nRecs <- group_by(parkinsons, subject_num) %>% count()
ggplot(nRecs, aes(x = n)) +
  geom_histogram(binwidth = 6) # 6 recordings per week expected
ggplot(nRecs, aes(x = subject_num, y = n)) +
  geom_point()
summary(nRecs$n)
# range: 101 - 168 recordings
# median: 141 recordings
# slightly left skewed (not many patients with more than expected,
# definitely some with less than expected)

# Check age variable distribution
# Using demographics, we get 1 entry per subject - distrib of subj ages
ggplot(demographics, aes(age)) +
  geom_histogram(binwidth = 1)
# Most subjects 55 - 80; other: 36, 49, 49, 85


# Check sex variable distribution
# Using demographics, we get 1 entry per subject - proportion of each sex
ggplot(demographics, aes(female)) +
  geom_histogram(binwidth = 1)
# About twice as many males


# Check test_time distribution
ggplot(parkinsons, aes(x = test_time)) +
  geom_histogram(binwidth = 7) +
  facet_grid(subject_num ~ .)
# appears there may be both time points and replicates missing
# some weeks, trials performed less than 7 days apart


# check volume level ratio
sum(parkinsons$Volume == "loud") / sum(parkinsons$Volume == "normal") 
# = 0.5006386
# we expect 2/4 = 0.5 --> pretty close, though not exact


# Check UPDRS scores
trials <- select(parkinsons, test_time, motor_UPDRS, total_UPDRS) %>% distinct()
trials_thin <- gather(trials, "Score_Type", "Score", 2:3)
ggplot(trials_thin, aes(x = Score, fill = Score_Type)) +
  geom_histogram(binwidth = 1, position = "dodge")
# both look very roughly normally distributed
# total is consistently higher than motor --> as expected
# within expected ranges (motor = 0-108; total = 0-176)
# on lower end of expected ranges because these are early stage PD patients
# total higher overall; diff btwn lower ends not as big as btwn upper ends



# Check Jitter variables
ggpairs(select(parkinsons, contains("Jitter")))
# all right-skewed
# all pretty highly correlated; DDP and RAP have R = 1


# Check Shimmer variables
ggpairs(select(parkinsons, contains("Shimmer")))
# all right-skewed
# all pretty highly correlated; APQ3 and DDA have R = 1


# Check other variables
ggpairs(parkinsons[ , 18:22])
# not as highly correlated
# different distribution shapes
# non-linear relationships make sense --> 3 of these were non-linear processing techniques



# Split train/test sets
groupwise_split <- function(X, obsRatio = 2/3, groupRatio = 1, seed = NULL) {
  set.seed(seed)
  groups <- unique(X)  # vector of unique group names
  index <- 1:length(X)  # create indices
  table <- cbind(index, X)  # bind indices and group labels
  
  obsInd <- list(NULL)  # initiate list
  for (i in 1:length(groups)){
    group_i <- subset(table, X == groups[i])[ ,1]  # select all indices of one group
    # randomly select % of indices of group i
    obsInd[[i]] <- sample(group_i, round(obsRatio * length(group_i)))
  }
  obsLogical <- index %in% unlist(obsInd)  # create logical vector where selected indices = TRUE
  
  # randomly select % of groups; create logical vector with these groups=TRUE
  groupLogical <- X %in% sample(groups, round(groupRatio * length(groups)))
  
  split <- ((obsLogical == TRUE) & (groupLogical == TRUE))
  return(split)
}

split <- groupwise_split(parkinsons$subject_num, obsRatio = .75, groupRatio = 37/42, seed = 1)

train <- subset(parkinsons, split == TRUE)
test <- subset(parkinsons, split == FALSE)

# Check if groupwise_split() works
unique(test$subject_num)
# returns all 42 subjects, as expected
unique(train$subject_num)
# returns 37 subjects, 5 removed fully to test set, as expected

count(subset(test, subject. == 1)) # 37
count(subset(train, subject. == 1)) # 112
# 37/(37 + 112) = about 25%
count(subset(test, subject. == 2)) # 36
count(subset(train, subject. == 2)) # 109
# 36/(36 + 109) = about 25%
ratio <- NULL
for(i in 1:length(unique(parkinsons$subject_num))){
  testCount <- count(subset(test, subject_num == i))
  trainCount <- count(subset(train, subject_num == i))
  ratio[i] <- testCount/(testCount + trainCount)
}
# 5 are 1 (for 100% in test set), rest are 0.25 +/- 0.005 <- as expected

split1 <- groupwise_split(parkinsons$subject., obsRatio = .75, groupRatio = 37/42, seed = 1)
split2 <- groupwise_split(parkinsons$subject., obsRatio = .75, groupRatio = 37/42, seed = 1)
split3 <- groupwise_split(parkinsons$subject., obsRatio = .75, groupRatio = 37/42, seed = 1)
sum(split1 != split2) # 0
sum(split3 != split2) # 0
# multiple runs with seed set returns the same output

# many runs without seed set
split <- groupwise_split(parkinsons$subject_num, obsRatio = .75, groupRatio = 37/42)
for(i in 2:1000){
  split_i <- groupwise_split(parkinsons$subject_num, obsRatio = .75, groupRatio = 37/42)
  split <- cbind(split, split_i)
}
groupsplitSums <- rowSums(split)
mean(groupsplitSums) # 660.6861
sd(groupsplitSums) # 15.57357
summary(groupsplitSums)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 597.0   650.0   661.0   660.7   671.0   729.0 
# not too wide of a spread, no 0% or 100%, seems to be truly random