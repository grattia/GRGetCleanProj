# run_analysis.R
# This program prepares a Tidy Dataset from Samsung S II sensor signals (accelerometer and gyroscope) collected
# 
# it uses readr and dplyr packages. make sure these packages are installed in advance
#

#preparing the storage dir on disk
setwd("C:/Users/ratti/Projects/GettingAndCleaningData")
if (!file.exists("proj")) { dir.create("proj") }

#Downloading and uncompressing files

dataSetUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataSetUrl, destfile = "./proj/Dataset.zip")
unzip("./proj/Dataset.zip", exdir = "./proj")
dataDir <- "./proj/UCI HAR Dataset"

# Reading common files with features names and activity Labels
activityLabel <- read.table(paste(dataDir,"activity_labels.txt",sep = "/"),sep=" ")

features <- read.table(paste(dataDir,"features.txt",sep = "/"),sep=" ")
str(features)
# counting number of features
nFeatures <- length(features$V2)

# Reading Training Data
# subject Data
trainSubject <- read.table(paste(dataDir,"train","subject_train.txt",sep = "/"),sep=" ")
# setting column name for activity
names(trainSubject) <- "subjectid"
# Train Data
library(readr)
# fixed format. it will read nFeatures columns of 16 characters
Xwidths = rep(16,nFeatures)
Xtrain <- read_fwf(file=paste(dataDir,"train","X_train.txt",sep = "/"), skip=0, fwf_widths(Xwidths))
# setting the column names from features file
names(Xtrain) <- features$V2
# Activity ID data
Ytrain <- read.table(file=paste(dataDir,"train","y_train.txt",sep = "/"),sep=" ")
# setting column name for activity
names(Ytrain) <- "activityid"
# puting together the Subject Id, Activity Id and Data in one data frame
Train <- cbind(trainSubject,Ytrain,Xtrain)

# Reading Test Data. Same steps as done for Train data
# subject Data
testSubject <- read.table(paste(dataDir,"test","subject_test.txt",sep = "/"),sep=" ")
names(testSubject) <- "subjectid"
# Test Data
Xwidths = rep(16,nFeatures)
Xtest <- read_fwf(file=paste(dataDir,"test","X_test.txt",sep = "/"), skip=0, fwf_widths(Xwidths))
names(Xtest) <- features$V2
# Activity ID data
Ytest <- read.table(file=paste(dataDir,"test","y_test.txt",sep = "/"),sep=" ")
names(Ytest) <- "activityid"
# puting together the Subject Id, Activity Id and Data in one data frame
Test <- cbind(testSubject,Ytest,Xtest)

# Step 1.
# Merges the training and the test sets to create one data set.

dataset <- rbind(Train, Test)

# Step 2
# Extracts only the measurements on the mean and standard deviation for each measurement.

datasetMeanStd <- dataset[,grepl("subjectid|activityid|[Mm]ean|std",names(dataset))]

# Step 3
# Uses descriptive activity names to name the activities in the data set

# assign column names to activity file
names(activityLabel) <- c("activityid","activity")
# Merge activity file with dataset 
datasetMeanStd <- merge(activityLabel,datasetMeanStd, by.x = "activityid", by.y = "activityid", all=FALSE,all.x = TRUE)
# refactor activity to keep the original order
datasetMeanStd$activity <- factor(datasetMeanStd$activity,levels=activityLabel$activity)
# remove the activityId column from dataframe
datasetMeanStd <- datasetMeanStd[,-1]

# Step 4
# Appropriately labels the data set with descriptive variable names.


columnNames <- names(datasetMeanStd)
# Expand t as Time
columnNames <- sub("tBody","TimeBody",columnNames)
columnNames <- sub("tGravity","TimeGravity",columnNames)
# expand f as Frequency
columnNames <- sub("fBody","FrequencyBody",columnNames)
# Expand Mag as Magnitude
columnNames <- sub("Mag","Magnitude",columnNames)
# Expand Acc as Acceleration
columnNames <- sub("Acc","Acceleration",columnNames)
# substitute -mean() as Mean
columnNames <- sub("-mean\\(\\)","Mean",columnNames)
# substitute -std() as StandardDeviation
columnNames <- sub("-std\\(\\)","StandardDeviation",columnNames)
# substitute -meanFreq as MeanFrequency
columnNames <- sub("-meanFreq\\(\\)","MeanFrequency",columnNames)
# remove all the remaining special characteres
columnNames <- gsub("\\(|\\)|\\,|\\-","",columnNames)
# set names to lowercase
columnNames <- tolower(columnNames)

names(datasetMeanStd) <- columnNames

write.csv(file = "./proj/datasetMeanStd.csv", datasetMeanStd)

# Step 5
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# use dplyr
library(dplyr)
# group the dataset by activity and subject
groupDataset <- group_by(datasetMeanStd, activity, subjectid)
# summarize using mean for all columns
summarizedatasetMeanStd <- summarize_each(groupDataset, funs(mean))

# write summarizedatasetMeanStd on disk
write.table(file = "./proj/summarizedatasetMeanStd.txt", summarizedatasetMeanStd, row.name=FALSE)


