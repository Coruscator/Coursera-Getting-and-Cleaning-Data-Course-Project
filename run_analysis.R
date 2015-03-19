#############################################################################################
#############################################################################################
## Project : Coursera Getting and Cleaning Data Course Project
## Author : Arjun Rai Mahendra
## Date : 2015-03-19
## File Name : run_analysis.r 
## File Description:
# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip":
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
##############################################################################################
##############################################################################################


## Download the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip")

## unzip the file
unzip("dataset.zip")

##################################################################
# 1. Merges the training and the test sets to create one data set.
##################################################################

## Reading from test data
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

## Reading from train data
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Reading the features
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F)[,2]

## Reading the activities
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)

## Adding column names
names(xTest) <- features
names(yTest) <- "activityId"
names(subjectTest) <- "subjectId"

names(xTrain) <- features
names(yTrain) <- "activityId"
names(subjectTrain) <- "subjectId"

names(activities) <- c("activityId", "activityType")

## Creating the final Train Data
trainData <- cbind(yTrain, subjectTrain, xTrain)

## Creating the final Test Data
testData <- cbind(yTest, subjectTest, xTest)

## Merge Test and Train data
finalData <- rbind(trainData, testData)


########################################################################
# 2. Extract only the measurements on the mean and standard deviation 
#    for each measurement. 
########################################################################

## Find the index of the selected features
selectFeatures <- grep("subjectId|activityId|mean\\(\\)|std\\(\\)", names(finalData))

## Subset the selected features from the dataset
finalData <- finalData[,selectFeatures]

############################################################################
# 3. Use descriptive activity names to name the activities in the data set.
############################################################################

## Merge the activities and finalData by activityId
finalData <- merge(activities, finalData, by = "activityId", all.y = TRUE)


#######################################################################
# 4. Appropriately label the data set with descriptive variable names.
#######################################################################

## Regular Expression function for adding descriptive labels to dataset
labelFunc <- function(name){
        name <- gsub("^t", "TimeDomain", name)
        name <- gsub("^f", "FrequencyDomain", name)
        name <- gsub("mean\\(\\)", "Mean", name)
        name <- gsub("std\\(\\)", "StdDev", name)
        name <- gsub("[Aa]cc", "Acceleration", name)
        name <- gsub("[Gg]yro", "Gyro", name)
        name <- gsub("[Bb]ody[Bb]ody|[Bb]ody", "Body", name)
        name <- gsub("[Gg]ravity", "Gravity", name)
        name <- gsub("[Mm]ag", "Magnitude", name)
        name <- gsub("[Jj]erk", "Jerk", name)
        return(name)
}

colNames <- sapply(names(finalData), labelFunc)

names(finalData) <- colNames

######################################################################
# 5. Creates a second, independent tidy data set with the average of 
#    each variable for each activity and each subject. 
######################################################################

## Load reshape2 package in R
library(reshape2)

## Apply melt function to the dataset
idLabels   <- c("subjectId", "activityId", "activityType")
dataLabels <- setdiff(names(finalData), idLabels)
meltedData <- melt(finalData, id = idLabels, measure.vars = dataLabels)

## Apply mean function to dataset using dcast function
tidyData   <- dcast(meltedData, subjectId + activityId ~ variable, mean)

## Write the tidy data to disk
write.table(tidyData, file = "./tidyData.txt", row.names = FALSE, sep='\t')
