# Getting and Cleaning Data
## Course Project


The purpose of this project is to create tidy data from "Human Activity Recognition Using Smartphones Data Set". The data set and more information regarding its format can be accessed here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The raw data has also been included in this repository for reference.

# Assumptions

1. The run_analysis.R script expects the raw data to be in a folder called "UCI HAR Dataset" in the working directory. If it's missing, download it from the link above, or alternatively, clone it from this repository.
2. The dplyr and tidyr packages are installed in the R environment.


Analysis of the original data sets found the following issues which were then subsequently resolved by the run_analysis.R script.

1. The data for each observation was distributed across multiple tables. 
2. The activity variable was numeric and therefore readability could be improved.
3. Column names missing from the data set.
4. Column names provided in the features.text supplemental file were not descriptive.

The run_analysis.R script resolved the issues stated above in the following way:

1. Merged the tables containing the "subject", "activity" and the 561 measurements into a single dataframe.
2. Converted the numeric based activity values to more meaningful activity descriptions eg. "walking". 
3. Mapped the contents of the "features.txt" to the column names of the activity measurements.
4. Renamed the column names from step 3. to be more readable by removing multiple periods '..' and replacing them with an underscore '_'.
5. Renamed the column names to be all lower case to improve consistency and readability.
6. Renamed the 't' and 'f' prefixes to "time_" and "freq_" to provide a more meaningful desciption of the measurement domain.
7. Removed all the measurement columns which were considered uneccessary for the purpose of our analysis, keeping only the columns that contain data relating to the mean and standard deviations. The assumption was made that any column with a column name that contains either the word "mean" or "std" classifies as a column of interest.


Finally, there was a requirement to create secondary tidy data set containing the mean of each remaining measurement in the tidy data set above. These mean calculations were to be grouped by subject and their activity.

In it's final step, the run_analysis.R script summarises the data accordingly and writes out this data table to the working directory as subject_activity_means.txt. This file has also been included in this repository for reference.



