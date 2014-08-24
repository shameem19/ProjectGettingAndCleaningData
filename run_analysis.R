setwd("C:/Users/Shafi/Documents/shameem/Rprog")

# Read features and make names better suited for R with substitutions
features = read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Read activity labels
activityLabels = read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read training and testing data
training = read.csv("./UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("./UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

testing = read.csv("./UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("./UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

# Merge training and test sets together
mergeData = rbind(training, testing)

# Get only the data on mean and std. dev.
colsNeeded <- grep(".*Mean.*|.*Std.*", features[,2])
# First reduce the features table to what we want
features <- features[colsNeeded,]
# Now add the last two columns (subject and activity)
colsNeeded <- c(colsNeeded, 562, 563)
# And remove the unwanted columns from allData
mergeData <- mergeData[,colsNeeded]

# Add the column names to mergeData
colnames(mergeData) <- c(features$V2, "Activity", "Subject")
colnames(mergeData) <- tolower(colnames(mergeData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  mergeData$activity <- gsub(currentActivity, currentActivityLabel, mergeData$activity)
  currentActivity <- currentActivity + 1
}

mergeData$activity <- as.factor(mergeData$activity)
mergeData$subject <- as.factor(mergeData$subject)

tidy = aggregate(mergeData, by=list(activity = mergeData$activity, subject=mergeData$subject), mean)
# Remove the subject and activity column, since a mean of those has no use
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "./tidy.txt", sep="\t")