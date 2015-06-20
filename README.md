## Data Science Specialization
#### Johns Hopkins University - Coursera
### Getting and Cleaning Data Course

### Final Project
June 20, 2015 1:03 AM
#### Carlos Rodriguez-Contreras
This repository contains the next files:
- **run_analysis.R** R script that executes all actions required to perform the project. The srcipt retrieves the ziped file from the internet but, as required, it also unzip and read the datasets in the working directory.
- The zipped file **zippedFile.zip** to be unzipped by the script. When it is unzipped, this file creates the directory *UCI HAR Dataset* where the script retrieves the datasets and complementary data.
- A file named **UCI HAR Dataset.names** which is used to interpret all variables of the project.
- The intended tidy dataset named **newDataset.txt** containing 66 columns with all variables where means and standard deviations are involved. All readings consist of averages of the measurements in the original dataset. Because it is saved with  *write.table* and *row.names = FALSE*, this dataframe loses its first column which identifies the Subject and Activity (30 subjects, 6 activities, which yield 180 rows).

Before writing *newDataset.txt*, the script produces the dataframe *newDataset* which can be seen in the *RStudio* Environment, this is much more readable than the final file in .txt format.

**WARNING!!!** The process of generating the numeric datasets is time consuming, be patient, it works.