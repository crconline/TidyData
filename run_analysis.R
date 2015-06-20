# Johns Hopkins University-Coursera Data Science Specialization
# Getting and Cleaning Data
# Final Project
# Carlos Rodriguez-Contreras

# Retrieving the zipped file from the internet:
datasetURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(datasetURL, destfile = "zippedFile.zip", method = "curl")

# Unzip the dataset into UCI HAR Dataset directory:
unzip("zippedFile.zip") 

# Reading the common files:
activity.labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", header = FALSE, stringsAsFactors = FALSE)
features.labels <- read.csv("UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
col.labels.complete <- as.character(features.labels$V2)

# Selecting the columns asked for the project:
vector.of.cols.needed <- c(1:6,41:46,81:86,121:126,161:166,201,202,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543)
col.labels.needed <- col.labels.complete[vector.of.cols.needed]

# Reading the test dataset:
test.readings <- read.csv("UCI HAR Dataset/test/X_test.txt", header = FALSE)
test.activity.identifiers <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE)
test.subject.identifiers <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Reading the training dataset:
train.readings <- read.csv("UCI HAR Dataset/train/X_train.txt", header = FALSE)
train.activity.identifiers <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE)
train.subject.identifiers <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Loading required psackages:
library(plyr)
library(stringr)

# Manipulation of the test dataset:
test.activities <- mapvalues(as.factor(test.activity.identifiers$V1), from = activity.labels$V1, to = activity.labels$V2) # To create the labels of Activity Column
test.words <- as.character(test.readings$V1) # This transaltes the dataset into rows of only one column dataset
test.readings.vector <- as.numeric() # Creates an empty vector
for (i in 1:nrow(test.readings)){
    test.readings.vector <- rbind(test.readings.vector, as.numeric(unlist(str_extract_all(test.words[i], '-?[0-9.]+e?[-+]?[0-9]*'))))
} # Cycle to produce numeric readings
test.readings.needed <- as.data.frame(test.readings.vector)[vector.of.cols.needed] # produces a dataframe with only the required columns
final.test.dataset <- cbind(test.subject.identifiers, test.activities, test.readings.needed) # Creates the final dataframe for test readings
names(final.test.dataset) <- c("Subject", "Activity", col.labels.needed) # Names each column of the dataframe

# Manipulation of the train dataset:
train.activities <- mapvalues(as.factor(train.activity.identifiers$V1), from = activity.labels$V1, to = activity.labels$V2) # To create the labels of Activity Column
train.words <- as.character(train.readings$V1) # This transaltes the dataset into rows of only one column dataset
train.readings.vector <- as.numeric() # Creates an empty vector
for (i in 1:nrow(train.readings)){
    train.readings.vector <- rbind(train.readings.vector, as.numeric(unlist(str_extract_all(train.words[i], '-?[0-9.]+e?[-+]?[0-9]*'))))
} # Cycle to produce numeric readings
train.readings.needed <- as.data.frame(train.readings.vector)[vector.of.cols.needed] # produces a dataframe with only the required columns
final.train.dataset <- cbind(train.subject.identifiers, train.activities, train.readings.needed) # Creates the final dataframe for train readings
names(final.train.dataset) <- c("Subject", "Activity", col.labels.needed) # Names each column of the dataframe

# Binding the two datasets:
complete.dataset <- rbind(final.test.dataset, final.train.dataset)
complete.dataset.ordered <- complete.dataset[order(complete.dataset$Subject, complete.dataset$Activity), ] # Sorted by Subject and Activity

# Splitting the dataset by Subject:
splitted.datasets <- split(complete.dataset.ordered, list(complete.dataset.ordered$Subject, complete.dataset.ordered$Activity))
averages <- function(x) colMeans(x[ ,col.labels.needed], na.rm = TRUE)
newDataset <- as.data.frame(t(sapply(splitted.datasets, averages))) # Create the transpose of the new dataset 

write.table(newDataset, file = "newDataset.txt", row.names = FALSE) # Writing output to a .txt file
