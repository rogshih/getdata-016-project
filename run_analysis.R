# Loading required libraries
library(dplyr)
library(plyr)
library(reshape2)

# Project objectives:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data 
#    set with the average of each variable for each activity and each subject.

# Note: For my variables, I used the Google preferred format:
# https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml#identifiers
# "variable.name" is preferred, "variableName" is accepted 

# used on my PC to reset working directory every run
setwd("C:/Users/Roger/Google Drive/Courses/Getting and Cleaning Data/project/")

# To get my script to work, I set the working directory to main directory
setwd("getdata-projectfiles-UCI HAR Dataset/")

# Read data files in main directory
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                            header = FALSE,
                            col.names = c("activity.id", "activity.name"), 
                            sep = " ")

features <- read.table("UCI HAR Dataset/features.txt",
                     header = FALSE,
                     col.names = c("feature.id", "feature.name"),
                     sep = " ")

# Read data files in test folder
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt",
                         header = FALSE,
                         col.names = c("subject.id"))

test.activity <- read.table("UCI HAR Dataset/test/y_test.txt",
                         header = FALSE,
                         col.names = c("activity.id"))

test.data <- read.table("UCI HAR Dataset/test/X_test.txt",
                      header = FALSE,
                      col.names = features[,2],
                      check.names = FALSE,
                      sep = "")

# Read data files in train folder
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt",
                           header = FALSE,
                           col.names = c("subject.id"))

train.activity <- read.table("UCI HAR Dataset/train/y_train.txt",
                            header = FALSE,
                            col.names = c("activity.id"))

train.data <- read.table("UCI HAR Dataset/train/X_train.txt",
                        header = FALSE,
                        col.names = features[,2],
                        check.names = FALSE,
                        sep = "")

# Combine via cbind() the test data, cbind() the training data, then rbind() them into one DF
# Used grep("-(mean|std)", features[,2]) to only keep columns with "-mean" or "-std" in the name
dataset <- rbind(cbind(test.subject, 
                       test.activity, 
                       test.data[,grep("-(mean|std)", features[,2])]),
                 cbind(train.subject, 
                       train.activity, 
                       train.data[,grep("-(mean|std)", features[,2])]))

# Call join() with activity.lables by activity.id to get activity names
dataset.activity <- join(activity.labels, dataset, by = "activity.id")

# Drop activity.id from dataset.activity since we have the actual name already
# We can always look it back in via join()
dataset.activity <- dataset.activity[,names(dataset.activity) != "activity.id"]

# Use melt() to melt the data frame into subject.id, activity.name, variable and value
dataset.melt <- melt(dataset.activity, 
                     id = c("subject.id", "activity.name"))

# Use dcast() to cast the molten data into an independent tidy data set 
# with the average of each variable for each activity and each subject
# dataset.wide is in "wide format"
dataset.wide <- dcast(dataset.melt, 
                      subject.id + activity.name ~ variable, 
                      fun.aggregate = mean, 
                      na.rm = TRUE)

# Use melt() again to make the data into "long format"
# dataset.long is in "long format"
dataset.long <- melt(dataset.wide,
                     id = c("subject.id", "activity.name"),
                     value.name = "variable.mean")