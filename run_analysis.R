download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dat.zip")

workingdirectory <- getwd()

unzip(zipfile="./dat.zip",exdir="./Coursera")

pathdata <- file.path("./Coursera", "UCI HAR Dataset")


xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

xtest <- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test<-read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
features <- read.table(file.path(pathdata, "features.txt"),header = FALSE)
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)


colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityId"
colnames(subject_train) <-"subjectId"

colnames(xtest) <-features[,2]
colnames(ytest) <-"activityId"
colnames(subject_test) = "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

train<-cbind(ytrain, subject_train, xtrain)
test<-cbind(ytest, subject_test, xtest)

dat <-rbind(train, test)

namaCol <- colnames(dat)

meanstdCol <- (grepl("mean", namaCol)) | (grepl("std", namaCol)) | (grepl("activityId" , namaCol)) | (grepl("subjectId" , namaCol))

setForMeanAndStd <- dat[ , meanstdCol == TRUE]

set2 = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

set3 <- aggregate(. ~subjectId + activityId, set2, mean)
dat2 <- set3[order(set3$subjectId, set3$activityId),]

write.table(dat2, paste(pathdata, "/dat2.txt", sep=""), row.name=FALSE)
