getdata-016-project
===================

# Project submission for Coursera getdata-016

## Synopsis

This is the course project submission for Coursera getdata-016.

## Project Instruction
You should create one R script called run_analysis.R that does the following. 
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Project Files
I extracted the ZIP file into my working directory, where all the files are located in "getdata-projectfiles-UCI HAR Dataset/"
I am working on a PC, so my directory/file location might be slightly different from others. But the below paths worked for me.
There were many files in the downloaded ZIP file. After analyzing them, I decided to use the following files:
- UCI HAR Dataset/activity_labels.txt (label file)
- UCI HAR Dataset/features.txt (label file)
- UCI HAR Dataset/test/subject_test.txt (test data file)
- UCI HAR Dataset/test/y_test.txt (test data file)
- UCI HAR Dataset/test/X_test.txt (test data file)
- UCI HAR Dataset/train/subject_train.txt (test data file)
- UCI HAR Dataset/train/y_train.txt (test data file)
- UCI HAR Dataset/train/X_train.txt (test data file)

## Project Steps
- Read in label files from main directory using read.table()
- Read in test data files from test directory using read.table()
- Read in training data files from training directory using read.table()
- Combine test and training data, including only columns with mean and std data, into one data frame (dataset). My dataset also has all the variable names already. Variable: dataset
- Convert act.id to act.name, then remove act.id from dataset. Variable: dataset.activity
- Apply melt() to dataset.activity to get a data frame with 4 variables (subject.id, act.name, variable and value). Variable: dataset.melt
- Apply dcast() to dataset.melt to cast the molten data into an independent tidy data set with the average of each variable for each activity and each subject. Variable: dataset.wide
- Apply melt() again to make the data into "long format". Variable: dataset.long

## Libraries
To accomplish my tasks, I had to use the following libraries:
- dplyr
- plyr
- reshape2