#############################################
## Getting and Cleaning Data Course Project #
##        June 21st 2015, Ola Lie           #
#############################################

## You should create one R script called run_analysis.R
## that does the following. 

## 1. Merges the training and the test sets to create one data set.

    ## Remember to set working directory
    setwd("C:\\Users\\olalie\\Documents\\DataScience\\3_Getting_And_Cleaning_Data\\3_Getting_And_Cleaning_Data_Course_Project")
    
    ## First, get the raw data:
    
    if(!file.exists("./UCI HAR Dataset")){
        
        cat("Download files... (you might need to add argument: method = \"curl\"")
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile = "./getdata-projectfiles-UCI HAR Dataset.zip")
        
        cat('Unzip files...')
        unzip("getdata-projectfiles-UCI HAR Dataset.zip")
    }

    ## Second, read data into R
    cat('Loading data ...\n')
    dftrain <- read.table("./UCI HAR Dataset/train/X_train.txt",
                          header=FALSE, colClasses = rep("numeric", 561, col))
    dftest  <- read.table("./UCI HAR Dataset/test/X_test.txt",
                          header=FALSE, colClasses = rep("numeric", 561, col))
    
    ## Third, combine rows. There is no need for a set variable in the final data
    cat('Merging data ...\n')
    df <- rbind(dftrain,dftest)
    remove(dftrain,dftest)


## 2. Extracts only the measurements on the mean and standard deviation
##    for each measurement.

    cat('Extract mean and std ...\n')
    library(dplyr)
    columnNames <- gsub("[-(),]","",                ## read and clean column names 
                   as.character(
                   read.table("./UCI HAR Dataset/features.txt")$V2))
    names(df)   <- columnNames                      ## give names to columns
    df <- df[ !duplicated(names(df)) ]              ## remove duplicate names (columns not needed)
    keepColumns <- grep("mean|std", names(df) ) ## keep only mean and std (+set)
    df <- select(df,keepColumns)
    remove(keepColumns)


## 3. Uses descriptive activity names to name the activities
##    in the data set
    
    cat('Add activity names ...\n')
    activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
    activityLabels$V2 <- tolower(activityLabels$V2)
    fix<-regexpr("_",activityLabels$V2) ## remove _ and uppercase next letter

    for (i in 1:length(activityLabels$V2)) 
        if (fix[i]>0) activityLabels$V2[i] = paste(substr(activityLabels$V2[i],1,fix[i]-1),
            toupper(substr(activityLabels$V2[i],fix[i]+1,fix[i]+1)),
            substr(activityLabels$V2[i],fix[i]+2,nchar(activityLabels$V2[i])),
            sep = "")

    remove(fix)
    
    ## read activity data into R
    dfTrainActivites <- read.table("./UCI HAR Dataset/train/y_train.txt",
                            header=FALSE)
    dfTestActivites  <- read.table("./UCI HAR Dataset/test/y_test.txt",
                            header=FALSE)
    
    ## combine rows
    dfActivites <- rbind(dfTrainActivites, dfTestActivites)
    remove( dfTrainActivites, dfTestActivites)
    
    ## change activity number with descriptive names
    dfActivites$V1   <- activityLabels[match(dfActivites$V1, activityLabels$V1),2]
    names(dfActivites) <- 'activity'
    
    ## add activity column to dataset
    df <- cbind(df,dfActivites)
    remove(dfActivites, activityLabels)

## 4. Appropriately labels the data set with descriptive variable names.

    cat('Rename variable names ...\n')
    fromShort <- c("^t", "^f", "Acc", "Gyro", "Mag", "mean", "Freq", "std")
    toLong   <- c("time", "frequency", "Acceleration", "AngularVelocity", "Magnitude", "Mean", "Frequency", "StandardDeviation")
    columnNames <- names(df)

    for(i in seq_along(fromShort)) columnNames <- sub(fromShort[i], toLong[i], columnNames)

    remove(i, fromShort, toLong)

    names(df) <- columnNames
    remove(columnNames)


## 5. From the data set in step 4, creates a second, 
##    independent tidy data set with the average 
##    of each variable for each activity and each subject.

    cat('Add subjects (no descriptive values) ...\n')

    ## read subject data into R
    dfTrainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                            header=FALSE)
    dfTestSubjects  <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                            header=FALSE)
    
    ## combine rows
    dfSubjects      <- rbind(dfTrainSubjects,dfTestSubjects)
    remove(dfTrainSubjects, dfTestSubjects)

    names(dfSubjects) <- 'subject'

    ## add subject column to dataset
    df <- cbind(df,dfSubjects)
    remove(dfSubjects)

    cat('Calculate means ...\n')
    df <- df %>% group_by(activity, subject) %>% summarise_each(funs(mean),-activity,-subject) %>% data.frame()
    
    cat('Create tidy data set) ...\n')
    write.table(df, file = "tidyDataSet.txt", col.names = TRUE, row.names = FALSE)

## END OF SCRIPT


