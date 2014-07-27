#DATA DICTIONARY - merged_Tidy_Dataset.txt

Dummy Col – Running number
SubjectId -identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
ActivityLabelId – Activity label id 1-6
1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
ActivityName – Activity names above id

Below variable are derived based on the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

- Features are normalized and bounded within [-1,1].
tBodyAcc.mean...X
tBodyAcc.mean...Y
tBodyAcc.mean...Z
tBodyAcc.std...X
tBodyAcc.std...Y
tBodyAcc.std...Z
tGravityAcc.mean...X
tGravityAcc.mean...Y
tGravityAcc.mean...Z
tGravityAcc.std...X
tGravityAcc.std...Y
tGravityAcc.std...Z
tBodyAccJerk.mean...X
tBodyAccJerk.mean...Y
tBodyAccJerk.mean...Z
tBodyAccJerk.std...X
tBodyAccJerk.std...Y
tBodyAccJerk.std...Z
tBodyGyro.mean...X
tBodyGyro.mean...Y
tBodyGyro.mean...Z
tBodyGyro.std...X
tBodyGyro.std...Y
tBodyGyro.std...Z
tBodyGyroJerk.mean...X
tBodyGyroJerk.mean...Y
tBodyGyroJerk.mean...Z
tBodyGyroJerk.std...X
tBodyGyroJerk.std...Y
tBodyGyroJerk.std...Z
tBodyAccMag.mean..
tBodyAccMag.std..
tGravityAccMag.mean..
tGravityAccMag.std..
tBodyAccJerkMag.mean..
tBodyAccJerkMag.std..
tBodyGyroMag.mean..
tBodyGyroMag.std..
tBodyGyroJerkMag.mean..
tBodyGyroJerkMag.std..
fBodyAcc.mean...X
fBodyAcc.mean...Y
fBodyAcc.mean...Z
fBodyAcc.std...X
fBodyAcc.std...Y
fBodyAcc.std...Z
fBodyAccJerk.mean...X
fBodyAccJerk.mean...Y
fBodyAccJerk.mean...Z
fBodyAccJerk.std...X
fBodyAccJerk.std...Y
fBodyAccJerk.std...Z
fBodyGyro.mean...X
fBodyGyro.mean...Y
fBodyGyro.mean...Z
fBodyGyro.std...X
fBodyGyro.std...Y
fBodyGyro.std...Z
fBodyAccMag.mean..
fBodyAccMag.std..
fBodyBodyAccJerkMag.mean..
fBodyBodyAccJerkMag.std..
fBodyBodyGyroMag.mean..
fBodyBodyGyroMag.std..
fBodyBodyGyroJerkMag.mean..
fBodyBodyGyroJerkMag.std..


Reference of the data can be found in 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# DATA DICTIONARY - merged_Tidy_Dataset_measurement_avg.txt

It contains the average of each variable for each activity and each subject of the above mentioned tidy dataset



# run_analysis.R
  Script to create tidy data
  
  ## To get activity name
  activity_set_name<-read.table("UCI HAR Dataset/features.txt",col.names=c("ColId","ColName"))
  
  ## To get activity measurement name
  activity_label<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("ActivityLabelId","ActivityName"))
  
  ## To get col ids for mean and  standard deviation of the activity measurement
  std_mean_cols=sort(as.numeric(c(setdiff(grep(c(".mean"), activity_set_name$ColName,fixed=F),grep(c(".meanFreq"), activity_set_name$ColName,fixed=F)),grep(c('.std..'), activity_set_name$ColName)))) 
  
  ### Training set
  #### To get subject id's of train correspond row
  train_sub<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names="SubjectId")
  #### To get activity label of the train set
  train_activity_lab<-read.table("UCI HAR Dataset/train/y_train.txt",col.names="ActivityLabelId")
  train_activity_lab_ref<-merge(train_activity_lab,activity_label) # to mearge with corresponding name
  #### To get activity measurement of the train set
  train_activity_set<-read.table("UCI HAR Dataset/train/X_train.txt",col.names=activity_set_name$ColName)
  #### Tidy train data frame with only mean and standard deviation measurement
  train_df<-data.frame(train_sub,train_activity_lab_ref,train_activity_set[,std_mean_cols])
  
  
  ### Test set
  #### To get subject id's of test  correspond row
  test_sub<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names="SubjectId")
  #### To get activity label of the train set
  test_activity_lab<-read.table("UCI HAR Dataset/test/y_test.txt",col.names="ActivityLabelId")
  test_activity_lab_ref<-merge(test_activity_lab,activity_label) # to mearge with corresponding name
  #### To get activity measurement of the train set
  test_activity_set<-read.table("UCI HAR Dataset/test/X_test.txt",col.names=activity_set_name$ColName)
  #### Tidy test data frame with only mean and standard deviation measurement
  test_df<-data.frame(test_sub,test_activity_lab_ref,test_activity_set[,std_mean_cols])
  names(test_activity_set[,std_mean_cols])
  
  ### Merge tidy and test dataframe
  tidy_df<-rbind(train_df,test_df)
  
  ### write the tidy data set to the file
  write.csv(tidy_df,file="merged_Tidy_Dataset.txt")
  
  ### calculate the ave of the measurements per activity per subject
  sp_df<-split(tidy_df,list(tidy_df$SubjectId,tidy_df$ActivityName))  # split data frame based on activity and measurement
  a<-sapply(sp_df,function(x) colMeans(x[,names(test_activity_set[,std_mean_cols])],na.rm=T)) # calculate average
  write.csv(a,"merged_Tidy_Dataset_measurement_avg.txt")

