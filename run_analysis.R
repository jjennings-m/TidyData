# run_analysis.R downloads, combines, and cleans the University of California Irvine's
# Human Activity Recognition (HAR) dataset created from Galaxy S smartphones.
#

# Load necessary packages
library(data.table)
library(reshape2)

# Source: UCI-HAR Dataset.
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Set working directory and download zipped data file.
# setwd("~/GitHub/")
zipfile <- "./getdata-projectfiles-UCI HAR Dataset.zip"
if (!file.exists(zipfile)) {
        download.file(url, destfile = zipfile, mode = "wb")
}

# Create a folder to unzip the file to.
zipfolder <- "./UCI HAR Dataset"
if (!file.exists(zipfolder)) {
        unzip(zipfile)
}

# Create data table of activity names and create a column to describe the activity.
activity_names <- paste(zipfolder, "/activity_labels.txt", sep = "")
dt_activity_names <- data.table(read.table(activity_names, stringsAsFactors = F))
dt_activity_names$V1 <- NULL
setnames(dt_activity_names, 1, "activity")
dt_activity_names$activity <- tolower(dt_activity_names$activity)

# Create data table of feature names and add a column name for description.
feature_names <- paste(zipfolder, "/features.txt", sep = "")
dt_feature_names <- data.table(read.table(feature_names, stringsAsFactors = F))
dt_feature_names$V1 <- NULL
setnames(dt_feature_names, 1, "name")

# Load the mean and standard deviation measurements, transform rows into columns, discard the garbage.
measurement_features <- grep("^[t|f].*-mean\\(\\)|^[t|f].*-std\\(\\)", dt_feature_names$name)
measurement_columns <- paste("V", measurement_features, sep = "")
dt_features <- dt_feature_names[measurement_features,]

# Make feature names more descriptive.
dt_feature_names$name <- sub("BodyBody", "body_", dt_feature_names$name)
dt_feature_names$name <- sub("Body", "body_", dt_feature_names$name)
dt_feature_names$name <- sub("^[t]", "time_", dt_feature_names$name)
dt_feature_names$name <- sub("^[f]", "frequency_", dt_feature_names$name)
dt_feature_names$name <- sub("Acc", "accelerometer_", dt_feature_names$name)
dt_feature_names$name <- sub("Gravity", "gravity_motion_", dt_feature_names$name)
dt_feature_names$name <- sub("Jerk", "jerk_motion_", dt_feature_names$name)
dt_feature_names$name <- sub("Gyro", "gyroscope_", dt_feature_names$name)
dt_feature_names$name <- sub("-mean\\(\\)-X", "x_MEAN", dt_feature_names$name)
dt_feature_names$name <- sub("-mean\\(\\)-Y", "y_MEAN", dt_feature_names$name)
dt_feature_names$name <- sub("-mean\\(\\)-Z", "z_MEAN", dt_feature_names$name)
dt_feature_names$name <- sub("-std\\(\\)-X", "x_STD", dt_feature_names$name)
dt_feature_names$name <- sub("-std\\(\\)-Y", "y_STD", dt_feature_names$name)
dt_feature_names$name <- sub("-std\\(\\)-Z","z_STD",dt_feature_names$name)
dt_feature_names$name <- sub("Mag-mean\\(\\)", "magnitude_MEAN", dt_feature_names$name)
dt_feature_names$name <- sub("Mag-std\\(\\)", "magnitude_STD", dt_feature_names$name)

# Extract the Subject IDs from the training file and create a Subject ID column.
subject_training <- paste(zipfolder, "/train/subject_train.txt", sep = "")
dt_subject_training <- data.table(read.table(subject_training, stringsAsFactors = F))
setnames(dt_subject_training, 1, "subject_id")

# Extract the Activity IDs from training file, create an Activity ID column, and
# and replace Activity IDs with Activity Names. 
labels_training <- paste(zipfolder, "/train/y_train.txt", sep = "")
dt_labels_training <- data.table(read.table(labels_training, stringsAsFactors = F))
setnames(dt_labels_training, 1, "activity")
dt_labels_training$activity <- dt_activity_names[dt_labels_training$activity,]

# Combine all of the Training data tabels into new data table for future merging.
training_data <- paste(zipfolder, "/train/X_train.txt", sep = "")
dt_training_data <- data.table(read.table(training_data, stringsAsFactors = F))
dt_training_data <- subset(dt_training_data, select = measurement_columns)
for (i in 1:length(dt_training_data)) {
        setnames(dt_training_data, i, dt_feature_names$name[i])
}
dt_training_data <- cbind(dt_subject_training, dt_labels_training, dt_training_data)

# Extract the Subject IDs from the test file and create a Subject ID column.
subject_test <- paste(zipfolder, "/test/subject_test.txt", sep = "")
dt_subject_test <- data.table(read.table(subject_test, stringsAsFactors = F))
setnames(dt_subject_test, 1, "subject_id")

# Extract the Activity IDs from test file, create an Activity ID column, and
# and replace Activity IDs with Activity Names.
labels_test <- paste(zipfolder, "/test/y_test.txt", sep = "")
dt_labels_test <- data.table(read.table(labels_test, stringsAsFactors = F))
setnames(dt_labels_test, 1, "activity")
dt_labels_test$activity <- dt_activity_names[dt_labels_test$activity,]

# Combine all of the Test data tabels into new data table for future merging.
test_data <- paste(zipfolder, "/test/X_test.txt", sep = "")
dt_test_data <- data.table(read.table(test_data, stringsAsFactors = F))
dt_test_data <- subset(dt_test_data, select = measurement_columns)
for (i in 1:length(dt_test_data)) {
        setnames(dt_test_data, i, dt_feature_names$name[i])
}
dt_test_data <- cbind(dt_subject_test, dt_labels_test, dt_test_data)

# Merge the Training and Test data tables.
dt_merged_data <- rbind(dt_training_data, dt_test_data)
setkeyv(dt_merged_data, c("activity", "subject_id"))

# Create tidy data table from the combined data table,
# calculating the means of each variable by activity and subject_id pair.
# This tidy dataset consists of 180 observations (1 observation per activity and subject_id pair).
dt_tidydata <- dt_merged_data[, lapply(.SD, mean), by = list(activity, subject_id)]

# Create comma-separated flat text file of the tidy data table in the current working directory.
txt_file_tidydata <- "./UCI HAR Dataset/tidydata.txt"
csv_file_tidydata <- "./UCI HAR Dataset/tidydata.csv"
write.table(dt_tidydata, file = txt_file_tidydata, sep = ",", row.names = F)
write.table(dt_tidydata, file = csv_file_tidydata, sep = ",", row.names = F)