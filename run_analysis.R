library(dplyr)

# downloaded files fron
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Reading the files
x_file   <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_file   <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_file2   <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_file2   <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject2 <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# joining the files
x_file   <- rbind(x_file, x_file2)
y_file   <- rbind(y_file, y_file2)
subject <- rbind(subject, subject2)

# getting lables
Col_lables <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

# creating tables
#using 'grep' to isolate the mean and std columns
#using the number index of the columns to filter x_file
selected_lables <- Col_lables[grep(".*mean\\(\\)|std\\(\\)", Col_lables[,2], ignore.case = FALSE),]
x_slect <- x_file[,selected_lables[,1]]
# Applying labling
colnames(x_slect)   <- selected_lables[,2]
colnames(y_file)   <- "activity"
colnames(subject) <- "subject"
#joining the results into one table
x_final <- cbind(subject, y_file, x_slect)

#more relabling
x_final$activity <- factor(x_final$activity, levels = activity[,1], labels = activity[,2])
x_final$subject  <- as.factor(x_final$subject)

# neating up colunms names
x_finalcols <- colnames(x_final)
#substituting names
x_finalcols <- gsub("[\\(\\)-]", "", x_finalcols)
x_finalcols <- gsub("^f", "frequencydomain", x_finalcols)
x_finalcols <- gsub("^t", "timedomain", x_finalcols)
x_finalcols <- gsub("Acc", "accelerometer", x_finalcols)
x_finalcols <- gsub("Gyro", "gyroscope", x_finalcols)
x_finalcols <- gsub("Mag", "magnitude", x_finalcols)
x_finalcols <- gsub("Freq", "frequency", x_finalcols)

colnames(x_final) <- x_finalcols

# list the average of each variable for each activity and each subject.
x_means <- x_final %>% group_by(activity, subject) %>% summarise(across(everything(), mean))
write.csv(x_means, "./UCI HAR Dataset/tidydata.csv", row.names = FALSE) 
write.table(x_means, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE) 
