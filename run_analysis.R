library(dplyr)
library(reshape2)

#Downloading the dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#Unzipping the dataset
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Going through the directory
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files

#Reading train files
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"), header=FALSE)
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"), header=FALSE)
featureTrain <- read.table(file.path(path, "train", "X_train.txt"), header=FALSE)

#Reading test files
subjectTest <- read.table(file.path(path, "test", "subject_test.txt"), header=FALSE)
activityTest <- read.table(file.path(path, "test", "Y_test.txt"), header=FALSE)
featureTest <- read.table(file.path(path, "test", "X_test.txt"), header=FALSE)

#Reading "names" files
activityNames <- read.table(file.path(path, "activity_labels.txt"), header=FALSE)
featureNames <- read.table(file.path(path, "features.txt"), header=FALSE)

#Adding a column indicating the subject's group (train/test)
subjectTrain$group <- rep("train", nrow(subjectTrain))
subjectTest$group <- rep("test", nrow(subjectTest))

#Merging data by type (subject, activity, measures)
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featureTrain, featureTest)

#Renaming columns
subject <- rename(subject, subject=V1)
names(activity) <- c("activity")
names(features) <- featureNames$V2

#Combining subject table, activity table and features table in one dataset
data <- cbind(subject, activity, features)

#Extracting measurements on the mean and standard deviation for each measurement
featuresMeanStd <- featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
data <- subset(data, select=c("subject", "activity", as.character(featuresMeanStd)))

#Using descriptive activity names to name the activities in the data set
x <- factor(data$activity)
levels(x) <- list("WALKING"=1,"WALKING_UPSTAIRS"=2,"WALKING_DOWNSTAIRS"=3,"SITTING"=4,"STANDING"=5,"LAYING"=6)
data$activity <- x

#Appropriately labeling the data set with descriptive variable names
#^t -> time
names(data) <- sapply(names(data), function(x) gsub("^t", "time", x)) 
#Acc -> Accelerometer
names(data) <- sapply(names(data), function(x) gsub("Acc", "Accelerometer", x))
#Gyro -> Gyroscope
names(data) <- sapply(names(data), function(x) gsub("Gyro", "Gyroscope", x))
#^f -> frequency
names(data) <- sapply(names(data), function(x) gsub("^f", "frequency", x))
#Mag -> Magnitude
names(data) <- sapply(names(data), function(x) gsub("Mag", "Magnitude", x))
#BodyBody -> Body
names(data) <- sapply(names(data), function(x) gsub("BodyBody", "Body", x))

#Creating a second, independent tidy data set with the average of each variable for each activity and each subject
tidyData <- aggregate(.~subject+activity, data, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]

#outputing the tidy dataset
write.table(tidyData, "tidyData.txt", row.name=FALSE)
