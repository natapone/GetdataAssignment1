read_data_text <- function(directory = "./Dataset/test", file_name="X_test.txt", subject=F, activity=T, feature_filter=T) {
    library(data.table)
    file_name <- paste(directory, file_name, sep = "/")
    
    # read feature name
    feature_table   <- get_feature_name()
    feature_measure <- get_feature_measure(feature_table)

    print(feature_measure)
    print(length(feature_measure))
    print(class(feature_measure))
    
    #read activities with proper label
    activity_table  <- get_activity_label()
    print(activity_table)
    
    return()

    # read data file
    dt <- read.table(file_name, header=F)
    colnames(dt) <- feature_table$feature

    # filter mean and std columns
    if (length(feature_measure) > 0) {
        dt <- dt[, feature_measure]
    }
    
    
    print(head(dt))
    print(ncol(dt))
    print(nrow(dt))
    1
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
    dt[ , activity_label := sub( pattern="_", replacement=" ",x=activity_abb )]
    dt[ , activity_label := sapply(activity_label, cap_first)]
    dt
}

get_feature_measure <- function(feature_table) {
    #print(class(feature_table))

    valid_feature <- grep("\\-mean\\(\\)|\\-std\\(\\)", feature_table$feature, perl = T)
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
