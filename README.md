### Description of the run_analysis.R script

The general notes related to the script:

1. Code is reproducible on any working directory mapped to the UCI HAR Dataset folder coming in the ZIP file
2. The steps are numbered as functional blocks, but don't follow the same order as in the assignment description
3. The outcome of the run_analysis.R script is a text file called test_train_set.txt that matches the required output
4. Simple and atomic functions are the most used along the script. Some of them require the installation of specific packages


###      STEP 01 
*      Assuming that the data is located in the working directory:
*              The "UCI HAR Dataset" folder coming in the zip file
*              is the working folder and has the subfolders test and train

###    STEP 02 
*      Loads the metadata files into raw structures (features and activities)
*      assumptions: columns are in the same order as described in the features text
*      Identifies the "mean()" and "std()" measures by adding a boolean column that will be helpful downstream
*      Loads the activities from activity_labels.txt and sets proper names to columns
*      Loads the features from features.txt and sets proper names to columns

###     STEP 03 
*       Load the TEST measures files into raw structures (subjects and activities for test)
*       assumptions: rows are in the same order for all observations
*               columns are in the same order as described in the features text
*       Loads the subjects from the file ./test/subject_test.txt
*       Marks the subjects with a "Set" column indicating that the data comes from a test set
*       Loads the activities for the test set from the file ./test/y_test.txt
*       Merges activities names and activities performed for the test set
*       Binds the subjects and the activities for the test set
*       Loads the observations for the test set from the file ./test/x_test.txt
*       Filters the observations to get only the means and std using the factor tag set upstream
*       Adds activity_id to the observation set. Assuming no reordering has been done
*       The resulting obs_test object is tidy and contains:
*              observations for mean and std variables
*              identified subjects
*              identified activities
*              identified variables
*              identified test/train sets

###     STEP 04 
*       Repeats the steps in STEP 03 but using the train set instead of the test set
*       At the end of this block, the train and test set will have the same structure

###     STEP 05
*       Merging the two tables toghether into a tidy data set
*       First converting the tables into data frames
*       Ensures that the subject id have distinct values for the two dataframes
*          to do so the plyr library is loaded and ddply is used to verify that no
*          join is returning values when done between dataframes and subject id keys
*       Proceed using the merge function for all records in both dataframes
*       A cleaning step to make variable names more readable by
*          Setting the "mean" and "std" to Capital Letters (camel script)
*          Removing dots "." in the names
namVar <- names(test_train_set)
namVar <- gsub("mean","Mean",namVar)
namVar <- gsub("std","Std",namVar)
namVar <- gsub("\\.\\.\\.","",namVar)
namVar <- gsub("\\.\\.","",namVar)
namVar <- gsub("\\.","",namVar)
names(test_train_set) <- namVar

###     STEP 06
*       Prepares a WIDE tidy dataset containing the average of each variable
*       Aggregations for every variable will be done based on:
*               Activity
*               SubjectId
*       First, removing the useless columns for the tidy outcome (ActivityId, SetID, Set)
*       Sorts the records by SubjectId and Activity

###     STEP 07
*       This is an OPTIONAL step I did to prepare a LONG tidy dataset
*       Aggregations for every variable will be done based on:
*              Activity
*              SubjectId
*              66 Variables
*       Melts the dataframe to get a "Long" tidy dataset

###     STEP 08
*       Exports the data sets required in the assignment description
*       Exports the train + test data set
*       Removing the useless columns
