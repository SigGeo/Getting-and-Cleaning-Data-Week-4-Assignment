# Download the appropriate files.

filename <- "getdata_dataset.zip"
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}


# Reading the two datasets.

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
var_names <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1)Merging the previous datasets in order to create one data set.

X_new <- rbind(X_train, X_test)
Y_new <- rbind(Y_train, Y_test)
Subj_new <- rbind(Subj_train, Subj_test)

# 2)Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)
extract_var <- var_names[grep("mean\\(\\)|std\\(\\)",var_names[,2]),]
X_new <- X_new[,extract_var[,1]]

# 3)Uses descriptive activity names to name the activities in the data set

colnames(Y_new) <- "activity"
Y_new$activitylabel <- factor(Y_new$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_new[,-1]

# 4)Appropriately labels the data set with descriptive variable names.

colnames(X_new) <- var_names[extract_var[,1],2]

# 5)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(Subj_new) <- "subject"
newData <- cbind(X_new, activitylabel, Subj_new)
newData_mean <- newData %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(newData_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

