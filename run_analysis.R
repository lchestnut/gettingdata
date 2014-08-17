## Check to see if required packages are installed

if(!is.element("plyr", installed.packages()[,1])){
  print("Installing packages")
  install.packages("plyr")
}
library(plyr)

## Load function to capitalize activity names

simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

# 1. Reads and creates data sets for test and train subjects

## Main datasets

train.raw <- read.table("./UCI HAR Dataset/train/X_train.txt")
test.raw <- read.table("./UCI HAR Dataset/test/X_test.txt")


## Feature/variable names - read in variable names

features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactor=F)
colnames(features) <- c("num", "name")

## Set column names of test and train datasets

colnames(train.raw) <- features$name
colnames(test.raw) <- features$name

## Read in Activity and activity labels

activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactor=F)
colnames(activity.labels) <- c("ActivityID", "ActivityName")

## Create more descriptive activity names

activity.labels$ActivityName <- tolower(gsub('_', ' ' , activity.labels$ActivityName))
activity.labels$ActivityName <- sapply(activity.labels$ActivityName, simpleCap)

## Merge activity labels with activity data

activity.test <- read.table("./UCI HAR Dataset/test/y_test.txt", stringsAsFactor=F)
colnames(activity.test) <- c("ActivityID")

activity.train <- read.table("./UCI HAR Dataset/train/y_train.txt", stringsAsFactor=F)
colnames(activity.train) <- c("ActivityID")

## Read in Subject data

subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject.test) <- c("Subject")

subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject.train) <- c("Subject")

# 2. Join Activity, activity labels and subjects

act.test.merge <- join(activity.test, activity.labels, by = "ActivityID", type = "left", match = "all")

act.train.merge <- join(activity.train, activity.labels, by = "ActivityID", type = "left", match = "all")

test.subjects <- cbind(subject.test, 'ActivityName'=act.test.merge$ActivityName, test.raw)

train.subjects <- cbind(subject.train, 'ActivityName'=act.train.merge$ActivityName, train.raw)

# 3. combine test and training datasets

subject.data <- rbind(test.subjects, train.subjects)

# 4. Extracts only the measurements on the mean and standard deviation for each measurement.

select.data <- subject.data[,c(1,2,grep("std", colnames(subject.data)), grep("mean", colnames(subject.data)))]

# 5. Modifies the feature names to be more readable and more descriptive

names(select.data) <- gsub('^t', 'Time', names(select.data))
names(select.data) <- gsub('^f', 'Freq', names(select.data))
names(select.data) <- gsub("-","", names(select.data))
names(select.data) <- gsub("\\()","", names(select.data))
names(select.data) <- gsub('mean', 'Mean', names(select.data))
names(select.data) <- gsub('std', 'Std', names(select.data))

tidy.data <- ddply(select.data, .(Subject, ActivityName), .fun=function(x){ colMeans(x[,-c(1:2)]) })

# 6. Export the tidy set

write.table(tidy.data, file="./UCI HAR Dataset/tidydata.txt", sep="\t", row.names=FALSE)
