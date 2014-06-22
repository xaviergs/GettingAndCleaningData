#################################################################################
##      Assignment for "getting and cleaning data"
##      Code notes:
##              Code is reproducible on any working directory
##              Steps don't follow the assignement sequence
##              Every step contains a functional block
##              The outcome is the required in the instructions
##              simple and atomic functions are used along the script

#################################################################################
##      STEP 01 
##      Download the data file from the web
##      Assuming that the data is located in the working directory:
##              The "UCI HAR Dataset" folder coming in the zip file
##              is the working folder and has the subfolders test and train


#################################################################
##      STEP 02 
##      Load the metadata files into raw structures (features and activities)
##      assumptions: columns are in the same order as described in the features text

##      Load the features
features <- read.table("features.txt", col.names=c("FeatureId","FeatureName"),colClasses=c("numeric","character"))
head(features,10)

##      Identify the mean and std measures by adding a boolean column (possible aid for downstream steps)
##      only columns which names contain "mean()" and "std()" as stated in the readme.txt file
features$isFilter <- 0
features[grep("mean\\(\\)",features$FeatureName),3] <- 1
features[grep("std\\(\\)",features$FeatureName),3] <- 1

##      Load the activities
activities <- read.table("activity_labels.txt", col.names=c("ActivityId","Activity"),colClasses=c("numeric","character"))

#################################################################
##      STEP 03 
##      Load the TEST files into raw structures (subjects and activities for test)
##      assumptions: rows are in the same order for all observations
##              columns are in the same order as described in the features text

##      Load the subjects (TEST set)
subj_test <- read.table("./test/subject_test.txt",col.names=c("SubjectId"))
subj_test$SubjectId <- as.numeric(subj_test$SubjectId)

##       adds a "test" factor variable to be able to distinguish between sets once
##       they will be merged
subj_test$SetId <- 1
subj_test$SetName <- "Test"
head(subj_test,5)

##       Load the activities (TEST set)
activ_test <- read.table("./test/y_test.txt",col.names=c("ActivityId"))
head(activ_test);unique(activ_test$ActivityId)

##       merge the activities with the name metadata 
activ_test <- merge (activities,activ_test, by.x="ActivityId", by.y="ActivityId")
names(activ_test);head(activ_test);unique(activ_test$Activity)
##      bind subjects and activities
subj_test <- cbind(subj_test,activ_test)
names(subj_test);head(subj_test)

##      Load observations (TEST set)
obs_test <- read.table("./test/x_test.txt",
                       col.names=features$FeatureName,
                       colClasses=rep("numeric",nrow(features)))

##       filter the observations to get only means and std (using tag set upstream)
obs_test <- obs_test[,which(features$isFilter == 1)]
names(obs_test);head(obs_test);

##      adds activity_id to the observation set. Assuming no reordering has been done
##      The resulting obs_test object is tidy and contains:
##              observations for mean and std variables
##              identified subjects
##              identified activities
##              identified variables
obs_test <- cbind(subj_test,obs_test)

#################################################################
##      STEP 04 
##      Load the TRAIN files into raw structures (subjects and activities for test)
##      assumptions: rows are in the same order for all observations
##              columns are in the same order as described in the features text

##      Load the subjects (TRAIN set)
subj_train <- read.table("./train/subject_train.txt",col.names=c("SubjectId"))
subj_train$SubjectId <- as.numeric(subj_train$SubjectId)

##      adds a "train" factor variable to be able to distinguish between sets once
##      they will be merged
subj_train$SetId <- 2
subj_train$SetName <- "Train"
head(subj_train,5)

##       Load the activities (TRAIN set)
activ_train <- read.table("./train/y_train.txt",col.names=c("ActivityId"))
head(activ_train)

##       merge the activities with the name metadata 
activ_train <- merge (activities,activ_train, by.x="ActivityId", by.y="ActivityId")
##      bind subjects and activities
subj_train <- cbind(subj_train,activ_train)

##      Load observations (TEST set)
obs_train <- read.table("./train/x_train.txt",
                       col.names=features$FeatureName,
                       colClasses=rep("numeric",nrow(features)))
##       filter the observations to get only means and std (using tag set upstream)
obs_train <- obs_train[,which(features$isFilter == 1)]
names(obs_train);head(obs_train)

##      adds activity_id to the observation set. Assuming no reordering has been done
##      The resulting obs_test object is tidy and contains:
##              observations for mean and std variables
##              identified subjects
##              identified activities
##              identified variables
obs_train <- cbind(subj_train,obs_train)

#################################################################
##      STEP 05
##      Merging the two tables toghether into a tidy data set

##      Convert sets into dataframes
obs_test <- data.frame(obs_test)
obs_train <- data.frame(obs_train)

##      Ensure that the subjects are different for obs_test and obs_train, so we can
##      move on with the merge without troubles due to equal keys
##      to do so, we use a temp estructure containing subject keys and count of variable
##      for every set of data
library(plyr)
ote <- ddply(obs_test,'SubjectId',function(x) c(count=nrow(x)))
otr <- ddply(obs_train,'SubjectId',function(x) c(count=nrow(x)))

##      A merge of both dataset must be zero length, proving that there are no common keys
##      for subjets between sets
moter <- merge(ote, otr, by.x="SubjectId", by.y="SubjectId")
nrow(moter)

##      Go ahead by merging the two datasets
test_train_set <- merge(obs_test, obs_train, all=TRUE)
names(test_train_set)
head(test_train_set)

##      A final step to make the variable names more readable by
##              Setting the "mean" and "std" to Capital Letters (camel script)
##              Removing dots "." in the names
namVar <- names(test_train_set)
namVar <- gsub("mean","Mean",namVar)
namVar <- gsub("std","Std",namVar)
namVar <- gsub("\\.\\.\\.","",namVar)
namVar <- gsub("\\.\\.","",namVar)
namVar <- gsub("\\.","",namVar)
names(test_train_set) <- namVar

#################################################################
##      STEP 06
##      Prepares a WIDE tidy dataset containing the average of each variable
##      Aggregations for every variable will be done based on:
##              Activity
##              SubjectId

##      removing the useless columns for the tidy outcome
uless = c(which(names(test_train_set) == "ActivityId"),
          which(names(test_train_set) == "SetId"),
          which(names(test_train_set) == "SetName"))
wide_tidy_means <- test_train_set[,-uless]
wide_tidy_means <- aggregate(. ~ SubjectId + Activity, 
                             FUN = mean, 
                             data = wide_tidy_means,
                             na.action = na.pass)

##      Sorts the records by SubjectId and Activity
index <- with(wide_tidy_means, order(SubjectId, Activity))
wide_tidy_means <- wide_tidy_means[index,]
head(wide_tidy_means)

##      An exploratory way to check the 40 mean observations summarizing by subjects and activities
summaryBy(SubjectId ~ Activity, data=wide_tidy_means, FUN=function(x) c(count=length(x),min=min(x),max=max(x),mean=mean(x)))
summaryBy(Activity ~ SubjectId, data=wide_tidy_means, FUN=function(x) c(count=length(x),min=min(x),max=max(x)))
summaryBy(tBodyAccMeanX ~ SubjectId + Activity, data=wide_tidy_means, FUN=function(x) c(cmin=min(x),max=max(x)))

#################################################################
##      STEP 07
##      Prepares a LONG tidy dataset containing the average of each variable
##      Aggregations for every variable will be done based on:
##              Activity
##              SubjectId
##              66 Variables

##      melts the dataframe to get a "Long" tidy dataset
long_tidy_means <- melt(wide_tidy_means, id = c("SubjectId","Activity"),na.rm=TRUE)
head(long_tidy_means)

#################################################################
##      STEP 08
##      Exports the first data sets required in the assignment description

##      Exports the train + test data set
##      Removing the useless columns
test_train_set <- test_train_set[,-uless]
write.table(test_train_set,file =".\\test_train_set.txt"
          ,sep=" ",col.names=colnames(test_train_set)
          ,row.names=FALSE, quote=FALSE)

#################################################################
##      STEP 09
##      Exports the second data set required in the assignment description

##      Exports the averages data set for std an mean
##      Removing the useless columns
head(wide_tidy_means)
write.table(wide_tidy_means,file =".\\wide_tidy_means_set.txt"
            ,sep=" ",col.names=colnames(wide_tidy_means)
            ,row.names=FALSE, quote=FALSE)

