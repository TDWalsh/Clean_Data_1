

##Merges the training and the test sets to create one data set.

  ## read all the data
test.labels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names="label")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names="subject")
test.data <- read.table("UCI HAR Dataset/test/X_test.txt")
train.labels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names="label")
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names="subject")
train.data <- read.table("UCI HAR Dataset/train/X_train.txt")

# Combind datasets
data <- rbind(cbind(test.subjects, test.labels, test.data),cbind(train.subjects, train.labels, train.data))


##Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]


##Uses descriptive activity names to name the activities in the data set

labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
data.mean.std$label <- labels[data.mean.std$label, 2]


##Appropriately labels the data set with descriptive variable names.

good.colnames <- c("subject", "label", features.mean.std$V2)

good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))

colnames(data.mean.std) <- good.colnames

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, label = data.mean.std$label),mean)

# write the data for course upload
write.table(format(aggr.data, scientific=T), "TidyDataSet.txt",
            row.names=F, col.names=T, quote=2)


