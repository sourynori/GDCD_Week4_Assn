library(dplyr)

X1_trainDataset <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y1_trainDataset <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Subject_trainDataset <- read.table("./UCI HAR Dataset/train/subject_train.txt")

X2_testDataset <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y2_testDataset <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subject_testDataset <- read.table("./UCI HAR Dataset/test/subject_test.txt")

variable_names <- read.table("./UCI HAR Dataset/features.txt")


activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#1 merge train and test data.

X_Dataset <- rbind(X1_trainDataset, X2_testDataset)
Y_Dataset <- rbind(Y1_trainDataset, Y2_testDataset)
Subject_Dataset <- rbind(Subject_trainDataset, Subject_testDataset)

#2 measurements on the mean and standard deviation

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_Dataset <- X_Dataset[,selected_var[,1]]

#3 descriptive activity names to name the activities

colnames(Y_Dataset) <- "activity"
Y_Dataset$activitylabel <- factor(Y_Dataset$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_Dataset[,-1]

#4 labels the data set with descriptive variable

colnames(X_Dataset) <- variable_names[selected_var[,1],2]

#5 create second independent tidy dataset.

colnames(Subject_Dataset) <- "subject"
total <- cbind(X_Dataset, activitylabel, Subject_Dataset)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

