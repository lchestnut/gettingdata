Getting and Cleaning Data


## Project objectives
The purpose of this project is to demonstrate your ability to **collect**, **work with**, and **clean** a data set. The goal is to prepare a **tidy dataset** that can be used for later analysis.

## Files in this repository
  * **run_analysis.R**: Main script
  * **tidydata.txt**: Tidy data set obtained after running the R script
  * **CodeBook.md**: Markdown file that describes the variables in the final tidy data set
  * **data/UCI HAR Dataset**: Folder that contains the *Human Activity Recognition Using Smartphones Dataset* files

## Steps used to get and clean the data set
  1. Installed and loaded needed library (plyr) and created function to capitalize activity names for greater readability

  2. Reads and creates data sets for test and train subjects, activity and feature names with their respective data

  3. **Change feature and activity names to be more descriptive**

  4. Merged activity labels with activity data, merged them with subjects

  5. **Combined test and training datasets to create one set**

  6. **Extracts only the measurements on the mean and standard deviation for each measurement.**

  7. **Exported the tidy set**
