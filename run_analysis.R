# tidy dataset by subject and activity
export_run_analysis_data <- function (dataset = "./Dataset") {
    dt <- read_clean_data()
    
    #file <- "clean_data.txt"
    #write.table(dt, file = file, row.names=F, col.names=T, sep="\t", quote=F )
    #message("Export clean data -> ", file)
    
    mean_dt <- dt[, lapply(.SD, mean, na.rm=TRUE), by=c("subjectID", "activity")]
    file <- "tidy_average_data.txt"
    write.table(mean_dt, file = file, row.names=F, col.names=T, sep="\t", quote=F )
    message("Export average data -> ", file)
}

# create dataset of mean and standard deviation for each measurement
read_clean_data <- function (dataset = "./Dataset") {
    library(data.table)
    
    sets <- c("test", "train")
    clean_data <- data.table()
    for (set in sets) {
        message("Reading ", set, " data file ...")
        data_directory <- paste(dataset, set, sep = "/")
        data <- read_data_text(directory = data_directory, set = set)
        message("- count: ", nrow(data), " rows , ", ncol(data), " columns")
        
        if(nrow(clean_data) > 0){
            clean_data <- rbind(clean_data, data)
        } else {
            clean_data <- data
        }
    }
    
    clean_data
}

read_data_text <- function(directory = "./Dataset/test", set = "test") {
    # read feature name
    feature_table   <- get_feature_name()
    #feature_measure <- get_feature_measure(feature_table)

    #print(feature_measure)
    #print(length(feature_measure))
    #print(class(feature_measure))
    
    #read activities with proper label
    activity_table  <- get_activity_label()
    #print(activity_table)
    
    # read activity data file
    dt_activity <- read_activity_data(directory, activity_table, set)
    #print(tail(dt_activity))
    #print(nrow(dt_activity))
    
    # read subject data file
    dt_subject <- read_subject_data(directory, set)
    #print(tail(dt_subject))
    #print(nrow(dt_subject))
    

    # read feature data file
    dt_feature <- read_feature_data(directory, feature_table, set)
    
    #print(tail(dt_feature))
    #print(ncol(dt_feature))
    #print(nrow(dt_feature))
    #return()
    
    # merge subject, activity and feature
    cbind(dt_subject, dt_activity, dt_feature)
}

# read subject data
read_subject_data <- function(directory, set) {
    #file_name <- "subject_test.txt"
    file_name <- paste("subject_", set, ".txt", sep="")
    file_name <- paste(directory, file_name, sep = "/")
    dt_subject <- read.table(file_name, header=F)
    # name colume
    colnames(dt_subject) <- c("subjectID")
    as.data.table(dt_subject)
}

# read feature data and filter only measured column
read_feature_data <- function(directory, feature_table, set) {
    #file_name <- "X_test.txt"
    file_name <- paste("X_", set, ".txt", sep="")
    file_name <- paste(directory, file_name, sep = "/")
    
    dt_feature <- read.table(file_name, header=F)
    colnames(dt_feature) <- feature_table$feature
    
    # filter feature
    feature_measure <- get_feature_measure(feature_table)
    # filter mean and std columns
    if (length(feature_measure) > 0) {
        dt_feature <- dt_feature[, feature_measure]
    }
    
    as.data.table(dt_feature)
}

# read activity data and replace id with descriptive label
read_activity_data <- function(directory, activity_table, set) {
    file_name <- paste("y_", set, ".txt", sep="")
    file_name <- paste(directory, file_name, sep = "/")
    dt_activity <- read.table(file_name, header=F)
    # name colume
    colnames(dt_activity) <- c("activity")
    dt_activity <- as.data.table(dt_activity)
    
    # replace id with descriptive name
    for(id in 1:nrow(activity_table)){
        #print(activity_table[id]$activity_label )
        dt_activity[ , activity := sub( 
                pattern     = activity_table[id]$id, 
                replacement = activity_table[id]$activity_label, 
                x           = dt_activity$activity 
            )
        ]
    }
    
    dt_activity
}

get_activity_label <- function(directory = "./Dataset") {
    file_name <- "activity_labels.txt"
    file_name <- paste(directory, file_name, sep = "/")
    # read data file
    dt <- read.table(file_name, header=F)
    colnames(dt) <- c("id", "activity_abb")
    dt <- as.data.table(dt) # convert data frame to data table
    
    # rename label
    # - remove "_"
    # - capitalize the first letter
    dt[ , activity_label := gsub( pattern="_", replacement=" ",x=activity_abb )]
    dt[ , activity_label := sapply(activity_label, cap_first)]
    dt
}

get_feature_measure <- function(feature_table) {
    #print(class(feature_table))

    valid_feature <- grep("\\-mean\\(\\)|\\-std\\(\\)", feature_table$feature, perl = T)
    #valid_feature <- grep("fBodyAcc-mean\\(\\)", feature_table$feature, perl = T)
    
    #print(grepl("std()", feature_table$feature)   )

    feature_measure <-feature_table$feature[valid_feature]
    as.character(feature_measure)
}

get_feature_name <- function(directory = "./Dataset") {
    file_name <- "features.txt"
    file_name <- paste(directory, file_name, sep = "/")
    # read data file
    dt <- read.table(file_name, header=F)
    colnames(dt) <- c("id", "feature")
    
    dt
}

cap_first <- function(str) {
    str <- tolower(str)
    s <- strsplit(str, " ")[[1]]
    paste(
        toupper( substring(s, 1,1) ), 
        substring(s, 2),
        sep="", collapse=" "
    )
}

#source("run_analysis.R")
#read_data_text()

#source("run_analysis.R")
#get_feature_names()
