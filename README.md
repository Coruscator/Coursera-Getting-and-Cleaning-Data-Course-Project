# Coursera-Getting-and-Cleaning-Data-Course-Project

- Author : Arjun Rai Mahendra
- Date   : 2015-03-19

## Project Instructions:

You should create one R script called run_analysis.R that does the following:

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set.
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of 
each variable for each activity and each subject.

## Source Data:

A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for this project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Description of the Analysis file - run_analysis.R

### Section 1. Merge the training and the test sets to create one data set.

The data is download from location mentioned above. It is unzipped and various tables given below are read into R.

- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

Column names are assigned and the training and test data are merged to create a single data table.

### Section 2. Extract only the measurements on the mean and standard deviation for each measurement. 

Using regular expressions and "grep" function, various indices for columns which are measurements of mean 
and standard deviation along with the activity and subject id's are found.
The data table is then subsetted only taking the columns with the above indices.

### Section 3. Use descriptive activity names to name the activities in the data set

Merge the data table with the activities table for naming the activities in the data table.

### Section 4. Appropriately label the data set with descriptive variable names.

"gsub" function is used for pattern replacement to add descriptive variables names, such as:

* Acc to Acceleration
* Mag to Magnitude
* mean() to Mean
* std() to StdDev
* t to TimeDomain
* f to FrequencyDomain

### Section 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

For each activity and subject id the average for each of the variables is calculated using the "melt" and "dcast" functions 
in the "reshape2" package.
