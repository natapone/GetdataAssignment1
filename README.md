# GetdataAssignment1

## Instruction
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How to use?
1. Copy "getdata-projectfiles-UCI HAR Dataset.zip" to working directory
2. Rename folder to "Dataset"
3. Run the script below:

```
source("run_analysis.R")
```

```
export_run_analysis_data()
```

The result will be exported to file "tidy\_average\_data.txt"


## How does it work?
After calling main function 'export_run_analysis_data'

### Read data from text file
1. The script read raw test and train data from text file included:

    * Subject from 'subject_test.txt'

    * Activity data from 'y_test.txt'

    * Activity label from 'activity_labels.txt'

    * Feature data from 'X_test.txt'

    * Feature label from 'features.txt'

### Clean up data
1. **Subject** comes in form of ID for participant. We put descriptive column name as "subjectID".
2. **Activity** data is an ID. We match it with activity label. The label itself is not in proper format. We make it readable by replace underscore with space and all uppercase with capitalize name.
3. **Features** that required measuring are ones ending with -mean() and -std(). We use grep function to locate and filter the target fields. We match feature data and feature label then apply the filter.
4. **Merge clean data** by put test and train data together

### Average each feature by subject and activity
1. Call function 'lapply' on clean dataset which is grouped by subject and activity
