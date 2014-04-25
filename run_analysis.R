read_test_data <- function(directory = "./Dataset/test") {
    library(data.table)
    file_name <- "X_test.txt"
    file_name <- paste(directory, file_name, sep = "/")

    feature_table   <- get_feature_name()
    feature_measure <- get_measure_feature(feature_table)
    print(feature_measure)

    print(length(feature_measure))
    #return()

    # read data file
    dt <- read.table(file_name, header=F)
    colnames(dt) <- feature_table$feature

    # filter mean and std columns
    #???
    dt <- dt[, feature_measure]
    head(dt)

}

get_measure_feature <- function(feature_table) {
    print(class(feature_table))

    valid_feature <- grep("\\-mean\\(\\)|\\-std\\(\\)", feature_table$feature, perl = T)
    #print(grepl("std()", feature_table$feature)   )

    feature_table$feature[valid_feature]
}

get_feature_name <- function(directory = "./Dataset") {
    file_name <- "features.txt"
    file_name <- paste(directory, file_name, sep = "/")
    # read data file
    dt <- read.table(file_name, header=F)
    colnames(dt) <- c("id", "feature")
    #print(dt$feature)
    dt
}


#source("run_analysis.R")
#read_test_data()

#source("run_analysis.R")
#get_feature_names()