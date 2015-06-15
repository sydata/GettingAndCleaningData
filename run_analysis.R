# Read files
filepath <- "F:/MOOC/Getting and Cleaning Data/Course Project/UCI HAR Dataset"

X_test <- read.table(paste(filepath, "/test/X_test.txt", sep = ""))

X_train <- read.table(paste(filepath, "/train/X_train.txt", sep = ""))

y_test <- read.table(paste(filepath, "/test/y_test.txt", sep = ""),col.names = "Activity")

y_train <- read.table(paste(filepath, "/train/y_train.txt", sep = ""),col.names = "Activity")

Subject_test <- read.table(paste(filepath, "/test/subject_test.txt", sep = ""),col.names = "Subject")

Subject_train <- read.table(paste(filepath, "/train/subject_train.txt", sep = ""),col.names = "Subject")

features <- read.table(paste(filepath,"/features.txt", sep = ""))

activity_lables <- read.table(paste(filepath,"/activity_labels.txt", sep = ""))

# Column bind Dataframes y_test and subject_test
A <- cbind(y_test,Subject_test)

# Column bind Dataframes y_train and subject_train
B <- cbind(y_train,Subject_train)

# Merge A and B
C <- merge(A,B,all = TRUE)

# Merge X_train and X_test
D <- merge(X_train,X_test,all = TRUE)

# Change column names of D from features
colnames(D) <- features[,2]

# Eliminate columns from D which do not have "mean()" or "std()"
E <- D[,sort(c(grep("mean()", features[,2],fixed = TRUE),grep("std()", features[,2],fixed = TRUE)))]

# Column bind C and E
F <- cbind(C,E)

library(dplyr)

G <- tbl_df(F)

# Take mean of observations per activity per subject
H <- group_by(G,Activity,Subject)

I <- summarise_each(H,funs(mean))

# Replace Activity numbers with Activity names
I[,1] <- merge(I[,1],activity_lables,by.x ="Activity" ,by.y ="V1" )[,2]

write.table(I,file = "resault.txt",row.names = FALSE)
