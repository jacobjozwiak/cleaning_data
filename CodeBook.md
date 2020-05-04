# Code Book

The code book outlines the steps taken to create a tidy dataset from the "Human Activity Recognition Using Smartphones Data Set".


## Original Tidy Data

The following transformations were undertaken to result in a tidy datset of 10,299 observations across 81 variables. 79 of these variables relate to the mean and standard deviation measurements as outlined in the requirements of this project. The remaining 2 variables describe the subject and the activity that was being undertaken when the measurements took place.

### 1. Merging
When the data was imported form the subject, activity and measurements table for both the test and training groups, the data was merged into a single dataset
```{r}
data <- rbind(cbind(train_subject, train_activity, train_measurement), cbind(test_subject, test_activity, test_measurement))
```

### 2. Activity Renaming
The activities were renamed from their numeric value to a more meaningful textual representation.
```{r}
data$activity = factor(data$activity, levels = activity_labels[, 1], labels = tolower(activity_labels[, 2]))
```

### 3. Filtering Variables
Only the variables called "subject", "activity" and the measurements that related to mean and standard deviation were kept, all other variables were discarded. This resulted in 81 variables of interest.
```{r}
data <- data[, grepl("subject|activity|mean|std", colnames(data))]
```

### 4. Column Name Tidying
Column names were tidied by:

1. Converting to lower case to improve readability and consistency.
2. Removal of multiple periods '.' and replacing with underscore '_'.
3. Renaming the 't' and 'f' prefixes to "time_" and "freq_" to provide a more meaningful desciption of the measurement domain.
4. Removing trailing underscores and repeated "body" occurrences.
```{r}
colnames(data) <-   gsub("\\.+", "_", tolower(colnames(data))) %>%
                    { gsub("^t", "time_", .) } %>%          #Change prefix 't' to more meaningful domain descriptor "time_"
                    { gsub("^f", "freq_", .) } %>%          #Change prefix 'f' to more meaningful domain descriptor "frequency_"
                    { gsub("_$", "", .)} %>%                #Remove trailing occurences of underscore '_'
                    { gsub("(body)+", "body", .) }          #Tidy up occurences where column name has multiple instances of "body" eg. "bodybodygyrojerK"
```


### 5. Resulting Tidy Data
The resulting tidy data contains 10,299 observations across 81 variables. 



## Secondary Tidy Data - Subject Activity Means

The secondary tidy data is saved by run_analysis.R in the file "subject_activity_means.txt"

This dataset contains the means of each measurement from the "Original Tidy Data" and summarises them by grouping the data by subject and activity undertaken. The columns have the same names as those from the "Original Tidy Set" in 5. However, they now contain the corresponding mean value.

```{r}
subject_activity_means <-   group_by(data, subject, activity) %>%
                            summarize_each(mean)
            
#Write out the "means" table to file "subject_activity_means.txt"
write.table(subject_activity_means, "subject_activity_means.txt", row.names = FALSE, quote = FALSE)
```

## Appendix - Variable Descriptors

Variable | Description
---------|------------
subject   | The subject identifier of the subject involved in the observation                
activity  | The activity the subject was performing. Possible values: walking, walking_upstairs, walking_downstairs, sitting, standing, laying
time_bodyacc_mean_x | Body acceleration average on the X-Axis in the time domain          
time_bodyacc_mean_y  | Body acceleration average on the Y-Axis in the time domain            
time_bodyacc_mean_z  | Body acceleration average on the Z-Axis in the time domain           
time_bodyacc_std_x  | Body acceleration standard deviation on the X-Axis in the time domain             
time_bodyacc_std_y  | Body acceleration standard deviation on the Y-Axis in the time domain   
time_bodyacc_std_z  | Body acceleration standard deviation on the Z-Axis in the time domain   
time_gravityacc_mean_x | Gravity acceleration average on the X-Axis in the time domain       
time_gravityacc_mean_y | Gravity acceleration average on the Y-Axis in the time domain       
time_gravityacc_mean_z  | Gravity acceleration average on the Z-Axis in the time domain   
time_gravityacc_std_x   | Gravity acceleration standard deviation on the X-Axis in the time domain       
time_gravityacc_std_y   | Gravity acceleration standard deviation on the Y-Axis in the time domain       
time_gravityacc_std_z   | Gravity acceleration standard deviation on the Z-Axis in the time domain       
time_bodyaccjerk_mean_x  | Body acceleration jerk average on the X-axis in the time domain     
time_bodyaccjerk_mean_y    | Body acceleration jerk average on the Y-axis in the time domain    
time_bodyaccjerk_mean_z   | Body acceleration jerk average on the Z-axis in the time domain     
time_bodyaccjerk_std_x    | Body acceleration jerk standard deviation on the X-axis in the time domain     
time_bodyaccjerk_std_y   | Body acceleration jerk standard deviation on the Y-axis in the time domain      
time_bodyaccjerk_std_z   | Body acceleration jerk standard deviation on the Z-axis in the time domain     
time_bodygyro_mean_x   | Body gyroscopic average on the X-axis in the time domain        
time_bodygyro_mean_y  | Body gyroscopic average on the Y-axis in the time domain          
time_bodygyro_mean_z    | Body gyroscopic average on the Z-axis in the time domain        
time_bodygyro_std_x  | Body gyroscopic standard deviation on the X-axis in the time domain 
time_bodygyro_std_y  | Body gyroscopic standard deviation on the Y-axis in the time domain          
time_bodygyro_std_z | Body gyroscopic standard deviation on the Z-axis in the time domain            
time_bodygyrojerk_mean_x  | Body gyroscopic jerk average on the X-axis in the time domain     
time_bodygyrojerk_mean_y  | Body gyroscopic jerk average on the Y-axis in the time domain        
time_bodygyrojerk_mean_z  | Body gyroscopic jerk average on the Z-axis in the time domain        
time_bodygyrojerk_std_x  | Body gyroscopic jerk standard deviation on the X-axis in the time domain        
time_bodygyrojerk_std_y | Body gyroscopic jerk standard deviation on the Y-axis in the time domain          
time_bodygyrojerk_std_z  | Body gyroscopic jerk standard deviation on the Z-axis in the time domain         
time_bodyaccmag_mean  | Body acceleration magnitude average in the time domain       
time_bodyaccmag_std     | Body acceleration magnitude standard deviation in the time domain       
time_gravityaccmag_mean  | Gravity acceleration magnitude average in the time domain    
time_gravityaccmag_std   | Gravity acceleration magnitude standard deviation in the time domain     
time_bodyaccjerkmag_mean | Body acceleration jerk magnitude average in the time domain      
time_bodyaccjerkmag_std | Body acceleration jerk magnitude standard deviation in the time domain        
time_bodygyromag_mean  | Body gyroscopic magnitude average in the time domain       
time_bodygyromag_std | Body gyroscopic magnitude standard deviation in the time domain         
time_bodygyrojerkmag_mean  | Body gyroscopic jerk magnitude average in the time domain
time_bodygyrojerkmag_std | Body gyroscopic jerk magnitude standard deviation in the time domain      
freq_bodyacc_mean_x | Body acceleration average on the X-axis in the frequency domain          
freq_bodyacc_mean_y | Body acceleration average on the Y-axis in the frequency domain          
freq_bodyacc_mean_z  | Body acceleration average on the Z-axis in the frequency domain        
freq_bodyacc_std_x  | Body acceleration standard deviation on the X-axis in the frequency domain          
freq_bodyacc_std_y  | Body acceleration standard deviation on the Y-axis in the frequency domain          
freq_bodyacc_std_z  | Body acceleration standard deviation on the Z-axis in the frequency domain          
freq_bodyacc_meanfreq_x  | Body acceleration average frequency on the X-axis in the frequency domain     
freq_bodyacc_meanfreq_y   | Body acceleration average frequency on the Y-axis in the frequency domain     
freq_bodyacc_meanfreq_z  | Body acceleration average frequency on the Z-axis in the frequency domain       
freq_bodyaccjerk_mean_x  | Body acceleration jerk average on the X-axis in the frequency domain       
freq_bodyaccjerk_mean_y    | Body acceleration jerk average on the Y-axis in the frequency domain    
freq_bodyaccjerk_mean_z   | Body acceleration jerk average on the Z-axis in the frequency domain     
freq_bodyaccjerk_std_x   | Body acceleration jerk standard deviation on the X-axis in the frequency domain     
freq_bodyaccjerk_std_y    | Body acceleration jerk standard deviation on the Y-axis in the frequency domain       
freq_bodyaccjerk_std_z    | Body acceleration jerk standard deviation on the Z-axis in the frequency domain       
freq_bodyaccjerk_meanfreq_x  | Body acceleration jerk average frequency on the X-axis in the frequency domain    
freq_bodyaccjerk_meanfreq_y   | Body acceleration jerk average frequency on the Y-axis in the frequency domain   
freq_bodyaccjerk_meanfreq_z  | Body acceleration jerk average frequency on the Z-axis in the frequency domain   
freq_bodygyro_mean_x | Body gyroscopic average on the X-axis in the frequency domain          
freq_bodygyro_mean_y | Body gyroscopic average on the Y-axis in the frequency domain         
freq_bodygyro_mean_z | Body gyroscopic average on the Z-axis in the frequency domain         
freq_bodygyro_std_x  | Body gyroscopic standard deviation on the X-axis in the frequency domain         
freq_bodygyro_std_y  | Body gyroscopic standard deviation on the Y-axis in the frequency domain        
freq_bodygyro_std_z   | Body gyroscopic standard deviation on the Z-axis in the frequency domain        
freq_bodygyro_meanfreq_x | Body gyroscopic average frequency on the X-axis in the frequency domain      
freq_bodygyro_meanfreq_y | Body gyroscopic average frequency on the Y-axis in the frequency domain         
freq_bodygyro_meanfreq_z  | Body gyroscopic average frequency on the Z-axis in the frequency domain        
freq_bodyaccmag_mean  | Body acceleration average magnitude in the frequency domain           
freq_bodyaccmag_std  | Body acceleration magnitude standard deviation in the frequency domain           
freq_bodyaccmag_meanfreq | Body acceleration magnitude frequency average in the frequency domain       
freq_bodyaccjerkmag_mean | Body acceleration jerk magnitude average in the frequency domain         
freq_bodyaccjerkmag_std | Body acceleration jerk magnitude standard deviation in the frequency domain     
freq_bodyaccjerkmag_meanfreq | Body acceleration jerk magnitude frequency average in the frequency domain  
freq_bodygyromag_mean  | Body gyroscopic magnitude average in the frequency domain          
freq_bodygyromag_std       | Body gyroscopic magnitude standard deviation in the frequency domain      
freq_bodygyromag_meanfreq   | Body gyroscopic magnitude average frequency in the frequency domain     
freq_bodygyrojerkmag_mean  | Body gyroscopic jerk magnitude average in the frequency domain      
freq_bodygyrojerkmag_std    | Body gyroscopic jerk magnitude standard deviation in the frequency domain    
freq_bodygyrojerkmag_meanfreq   | Body gyroscopic jerk magnitude average frequency in the frequency domain 

