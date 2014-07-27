train_sub<-read.table("UCI HAR Dataset/train/subject_train.txt")
test_sub<-read.table("UCI HAR Dataset/test/subject_test.txt")
train_activity_lab<-read.table("UCI HAR Dataset/train/y_train.txt")
train_activity_set<-read.table("UCI HAR Dataset/train/X_train.txt")
test_activity_lab<-read.table("UCI HAR Dataset/test/y_test.txt")
test_activity_set<-read.table("UCI HAR Dataset/test/X_test.txt")
train_body_acc_x<-read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
train_body_acc_y<-read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
train_body_acc_z<-read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
train_body_gyro_x<-read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
train_body_gyro_y<-read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
train_body_gyro_z<-read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
train_total_acc_x<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
train_total_acc_y<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
train_total_acc_z<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
test_body_acc_x<-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
test_body_acc_y<-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
test_body_acc_z<-read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
test_body_gyro_x<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
test_body_gyro_y<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
test_body_gyro_z<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")
test_total_acc_x<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
test_total_acc_y<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
test_total_acc_z<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")



# To get activity name
activity_set_name<-read.table("UCI HAR Dataset/features.txt",col.names=c("ColId","ColName"))

# To get activity measurement name
activity_label<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("ActivityLabelId","ActivityName"))

# To get col ids for mean and  standard deviation of the activity measurement
std_mean_cols=sort(as.numeric(c(setdiff(grep(c(".mean"), activity_set_name$ColName,fixed=F),grep(c(".meanFreq"), activity_set_name$ColName,fixed=F)),grep(c('.std..'), activity_set_name$ColName)))) 

## Training set
# To get subject id's of train correspond row
train_sub<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names="SubjectId")
# To get activity label of the train set
train_activity_lab<-read.table("UCI HAR Dataset/train/y_train.txt",col.names="ActivityLabelId")
train_activity_lab_ref<-merge(train_activity_lab,activity_label) # to mearge with corresponding name
# To get activity measurement of the train set
train_activity_set<-read.table("UCI HAR Dataset/train/X_train.txt",col.names=activity_set_name$ColName)
# Tidy train data frame with only mean and standard deviation measurement
train_df<-data.frame(train_sub,train_activity_lab_ref,train_activity_set[,std_mean_cols])


## Test set
# To get subject id's of test  correspond row
test_sub<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names="SubjectId")
# To get activity label of the train set
test_activity_lab<-read.table("UCI HAR Dataset/test/y_test.txt",col.names="ActivityLabelId")
test_activity_lab_ref<-merge(test_activity_lab,activity_label) # to mearge with corresponding name
# To get activity measurement of the train set
test_activity_set<-read.table("UCI HAR Dataset/test/X_test.txt",col.names=activity_set_name$ColName)
# Tidy test data frame with only mean and standard deviation measurement
test_df<-data.frame(test_sub,test_activity_lab_ref,test_activity_set[,std_mean_cols])
names(test_activity_set[,std_mean_cols])

# Merge tidy and test dataframe
tidy_df<-rbind(train_df,test_df)

# write the tidy data set to the file
write.csv(tidy_df,file="merged_Tidy_Dataset.csv")

# calculate the ave of the measurements per activity per subject
sp_df<-split(tidy_df,list(tidy_df$SubjectId,tidy_df$ActivityName))  # split data frame based on activity and measurement
a<-sapply(sp_df,function(x) colMeans(x[,names(test_activity_set[,std_mean_cols])],na.rm=T)) # calculate average
write.csv(a,"check.csv")
