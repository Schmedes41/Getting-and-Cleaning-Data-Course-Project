library(dplyr)
library(tidyr)
#Load the intermediate frames and the features/activities.
train_x <- read.table("train/X_train.txt", sep ="", header=FALSE)
train_y <- read.delim("train/y_train.txt", sep =" ", header=FALSE)
train_s <- read.table("train/subject_train.txt", sep=" ", header=FALSE)
test_x <- read.table("test/X_test.txt", sep ="", header=FALSE)
test_y <- read.delim("test/y_test.txt", sep =" ", header=FALSE)
test_s <- read.table("test/subject_test.txt", sep=" ", header=FALSE)
features <- readLines(con = "features.txt")
activ <- read.table("activity_labels.txt", sep ="", header=FALSE)
colnames(activ) <- c("ActCode", "ActivityName")
#Bind Train X, Y, and Subjects for both train and test and apply column names
train <- cbind(train_s, train_y, train_x)
colnames(train) <- c("Subject", "Activity", features)
test <- cbind(test_s, test_y, test_x)
colnames(test) <- c("Subject", "Activity", features)
#Combine the testing and training dataframes
combined <- rbind(test, train)
#Pull the columns that have "mean()" and "std()" in the name and remove the other columns. 
column_list <-c(grep("*mean*", colnames(combined)), grep("*std*", colnames(combined))) #Pulls mean frequency as well. 
filtered <- combined[,c(1, 2, column_list)]
#Merge Activity names, subject, and then remove the numbered column. 
filtered <- merge(activ, filtered, all.y=TRUE, by.x="ActCode", by.y= "Activity")
filtered <- filtered[2:length(colnames(filtered))]
filtered_group <- filtered %>% group_by(Subject, ActivityName) %>% summarise_all(mean)
write.table(filtered_group, "tidy_data.txt")
#Remove intermediate and test/train tables from environment
remove(train_x, train_y, train_s, test_x, test_y, test_s, test, train, activ, features, combined, column_list)

