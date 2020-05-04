#run_analysis.R
#Author: Jacob Jozwiak
#
#This script performs the tidying of the data from the UCI HAR Dataset, and then writes out a secondary tidy dataset
#containing a summarised view of the mean and standard deviation measurements as required by the assignment.

#ASSUMPTIONS: 
#The dplyr and tidyr packages are installed. If they are missing, install the packages
#install.packages("dplyr")
#install.packages("tidyr)

#The required UCI HAR Dataset folder and its contents are in the working directory. 
#If these files are missing, download them from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#Required libraries
library(dplyr)
library(tidyr)

#Read features
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)[, 2]

#Read activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#Read test data
test_measurement <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features)
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
test_activity <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "activity")

#Read training data
train_measurement <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features)
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
train_activity <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "activity")

#Combine data from the test and train dataframes
data <- rbind(cbind(train_subject, train_activity, train_measurement), cbind(test_subject, test_activity, test_measurement))

#Convert activity to a factor with more meaningful values
data$activity = factor(data$activity, levels = activity_labels[, 1], labels = tolower(activity_labels[, 2]))

#Keep columns that match "subject", "activity" as well as all columns that contain "mean" or "standard deviation" measurements
data <- data[, grepl("subject|activity|mean|std", colnames(data))]

#Tidy up column names by removing multiple periods '.' and replacing them with a single underscore '_' and converting to lowercase
colnames(data) <-   gsub("\\.+", "_", tolower(colnames(data))) %>%
                    { gsub("^t", "time_", .) } %>%          #Change prefix 't' to more meaningful domain descriptor "time_"
                    { gsub("^f", "freq_", .) } %>%          #Change prefix 'f' to more meaningful domain descriptor "frequency_"
                    { gsub("_$", "", .)} %>%                #Remove trailing occurences of underscore '_'
                    { gsub("(body)+", "body", .) }          #Tidy up occurences where column name has multiple instances of "body" eg. "bodybodygyrojerK"

#Remove no longer required dataframes
rm(activity_labels, features, test_measurement, test_subject, test_activity, train_measurement, train_activity, train_subject)

#The data frame 'data' now contains tidy data relating to the mean and standard deviations measurements from each observation

#Create a new data set that is grouped by subject and activity and contains the mean of each measurement
subject_activity_means <-   group_by(data, subject, activity) %>%
                            summarize_each(mean)
            
#Write out the "means" table to file "subject_activity_means.txt"
write.table(subject_activity_means, "subject_activity_means.txt", row.names = FALSE, quote = FALSE)
