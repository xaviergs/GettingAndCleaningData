### Code book and guidelines

The R script that produces the outcome is called run_analysis.R and basically performs the next steps:
*    Read the source data (as described in the Readme.md file)
*    Transform and clean the read data (as described in the Readme.md file)
*    Creates a tidy data file containing a merge of test and train variables (mean and std) for all subjects
*    Creates a tidy data file containing the averages of every measure for all the subjects and activities

### Activities
The recorded activities are coded as:
1	LAYING
2	SITTING
3	STANDING
4	WALKING
5	WALKING_DOWNSTAIRS
6	WALKING_UPSTAIRS

### Subjects
The subjects recorded in both test and train sets are numbered from 1 to 30.
*    In the test_train_set.txt file is possible to distinguish between subjects coming from the train or test file
*    1 - test set
*    2 - train set

### Variables
The variables recorded in the file are an extract of the raw ones that are detailed in the code book for the assignment. 
My version of them are named in an autodescriptive way by following the keys:

* X: x axis related variable
* Y: y axis related variable
* Z: z axis related variable
* Mean: applies to the mean value of single observations
* Std: applies to the standard deviation of single observations

The complete list of variables is:

tBodyAccMeanX
tBodyAccMeanY
tBodyAccMeanZ
tBodyAccStdX
tBodyAccStdY
tBodyAccStdZ
tGravityAccMeanX
tGravityAccMeanY
tGravityAccMeanZ
tGravityAccStdX
tGravityAccStdY
tGravityAccStdZ
tBodyAccJerkMeanX
tBodyAccJerkMeanY
tBodyAccJerkMeanZ
tBodyAccJerkStdX
tBodyAccJerkStdY
tBodyAccJerkStdZ
tBodyGyroMeanX
tBodyGyroMeanY
tBodyGyroMeanZ
tBodyGyroStdX
tBodyGyroStdY
tBodyGyroStdZ
tBodyGyroJerkMeanX
tBodyGyroJerkMeanY
tBodyGyroJerkMeanZ
tBodyGyroJerkStdX
tBodyGyroJerkStdY
tBodyGyroJerkStdZ
tBodyAccMagMean
tBodyAccMagStd
tGravityAccMagMean
tGravityAccMagStd
tBodyAccJerkMagMean
tBodyAccJerkMagStd
tBodyGyroMagMean
tBodyGyroMagStd
tBodyGyroJerkMagMean
tBodyGyroJerkMagStd
fBodyAccMeanX
fBodyAccMeanY
fBodyAccMeanZ
fBodyAccStdX
fBodyAccStdY
fBodyAccStdZ
fBodyAccJerkMeanX
fBodyAccJerkMeanY
fBodyAccJerkMeanZ
fBodyAccJerkStdX
fBodyAccJerkStdY
fBodyAccJerkStdZ
fBodyGyroMeanX
fBodyGyroMeanY
fBodyGyroMeanZ
fBodyGyroStdX
fBodyGyroStdY
fBodyGyroStdZ
fBodyAccMagMean
fBodyAccMagStd
fBodyBodyAccJerkMagMean
fBodyBodyAccJerkMagStd
fBodyBodyGyroMagMean
fBodyBodyGyroMagStd
fBodyBodyGyroJerkMagMean
fBodyBodyGyroJerkMagStd