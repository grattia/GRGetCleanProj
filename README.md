# GRGetCleanProj
 Project for getting and cleaning data. 
 This program prepares a Tidy Dataset from Samsung S II sensor signals (accelerometer and gyroscope) data.
 
### it uses readr and dplyr packages. make sure these packages are installed in advance

## Major sections of this program
### step 0
###Preparing the storage dir on disk

### Downloading and uncompressing files
### Reading common files with features names and activity Labels
### Read Training Data
 Read subject Data
 setting column name for activity
 reading Train Data as fixed format. it will read nFeatures columns of 16 characters
 setting the column names from features file
### Activity ID data
 setting column name for activity
### puting together the Subject Id, Activity Id and Data in one data frame

### Reading Test Data. Same steps as done for Train data
  subject Data
  Test Data
  Activity ID data
  puting together the Subject Id, Activity Id and Data in one data frame

# Step 1.
### Merges the training and the test sets to create one data set.

# Step 2
### Extracts only the measurements on the mean and standard deviation for each measurement.

# Step 3
### Uses descriptive activity names to name the activities in the data set
 assign column names to activity file
 Merge activity file with dataset 
 refactor activity to keep the original order
 remove the activityId column from dataframe

# Step 4
### Appropriately labels the data set with descriptive variable names.

The labels have to be descruptive, in lowercase, without special characteres
and not duplicated

Expand t as Time,
expand f as Frequency,
Expand Mag as Magnitude,
Expand Acc as Acceleration,
substitute -mean() as Mean,
substitute -std() as StandardDeviation,
substitute -meanFreq as MeanFrequency,
remove all the remaining special characteres,
set names to lowercase

# Step 5
### From the data set in step 4, creates a second, independent tidy data set 
### with the average of each variable for each activity and each subject.

 use dplyr
 group the dataset by activity and subject
 summarize using mean for all columns
 write summarizedatasetMeanStd on disk
 
 
 ### About source dataset:
 
 For more information about this dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

