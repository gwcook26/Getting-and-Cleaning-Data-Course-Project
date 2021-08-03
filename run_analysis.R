library(reshape2)

filename <- "getdata_dataset.zip"

if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
      download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
      unzip(filename) 
}

labels <- read.table("UCI HAR Dataset/activity_labels.txt")
labels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

feats <- grep(".*mean.*|.*std.*", features[,2])
feats.names <- features[feats,2]
feats.names = gsub('-mean', 'Mean', feats.names)
feats.names = gsub('-std', 'Std', feats.names)
feats.names <- gsub('[-()]', '', feats.names)

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainactive <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubject, trainactive, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testactive <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubject, testactive, test)

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", feats.names)

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allmelted <- melt(allData, id = c("subject", "activity"))
allmean <- dcast(allmelted, subject + activity ~ variable, mean)

write.table(allmean, "tidy.txt", row.names = FALSE, quote = FALSE)
