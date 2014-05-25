# project script for getting and cleaning data:
#
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive activity names. 
# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
# data source:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# 1 read the data in and merge it

x.train <- read.table("train/x_train.txt")
y.train <- read.table("train/y_train.txt")
subject.train <- read.table("train/subject_train.txt")

x.test <- read.table("test/x_test.txt")
t.test <- read.table("test/y_test.txt")
subject.test <- read.table("test/subject_test.txt")

merged.x <- rbind(x.train, x.test)
merged.y <- rbind(y.train, t.test)
merged.subject <- rbind(subject.train, subject.test)

# 2 we just want the features with mean() or std in the name 

features <- read.table("features.txt")
features.mean <- grep("mean\\(\\)", features[, 2])
features.std <- grep("std", features[, 2])
features.match <- c(features.mean, features.std)

merged.x <- merged.x[, features.match]
names(merged.x) <- features[features.match, 2]

# 3 - append an activity column 

activity.label <- read.table("activity_labels.txt")
merged.y[, 1] = activity.label[merged.y[, 1], 2]
names(merged.y) <- "activity"

# 4 - append a subject column

names(merged.subject) <- "subject"
subject.activity <- cbind(merged.subject, merged.y, merged.x)

# 5 - take the average by subject and activity

subject.activity.table <- data.table(subject.activity)
pivot <- melt(subject.activity.table, id.vars = c("subject", "activity"))
average.subject.activity <- dcast.data.table(pivot, subject + activity ~ variable, fun = mean)
write.table(subject.activity , "average.subject.activity.txt")





