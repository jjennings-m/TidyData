## Codebook for Samsung Galaxy S smartphone dataset

Run_analysis.R downloads the University of California Irvine’s dataset for Human Activity Recognition created from Samsung Galaxy S smartphones.  This downloaded data is then cleaned and condensed and providing two outputs.

The output of run_analyis.R consists of two files.  The first, is a text file (tidydata.txt) can be used for further analysis using (dt_new_tidy <- data.table(read.csv(tidydata.txt, stringsAsFactors = F))).  The second file is the raw .csv (tidydata.csv) and is ready to be imported into Excel.

Information regarding UCI’s experiment can be found at [Link to Experiment](https://www.elen.ucl.ac.be/Proceedings/esann/esannpdf/es2013-84.pdf)

## Variables

The Tidy dataset consists of 180 observations summarized by activity (6 categories) and subject (30 volunteers) pairs. 

Activity (1 variable) consists of:
* walking
* walking_upstairs
* walking_downstairs
* sitting
* standing
* laying

Subject (1 variable) consists of s numeric identifier (1-30) for each of the volunteers who carried out the experiment.

There are 6 variables, summarizing the activity and volunteer pair.  Variable names representing the mean are suffixed with _MEAN and variable names representing the standard deviation are suffixed with _STD.

There are 20 time variables prefixed with time_

There are 13 frequency variables prefixed with frequency_

There are 9 variables, 3 each representing the x, y, and z axis measurements for time body (prefixed by time_body_accelerometer_), time gravity (prefixed by time_gravity_motion_accelerometer_), and time body (prefixed by time_body_gyroscope_).

There are 6 derived variables, 3 each representing the x, y, and z axis for linear acceleration (prefixed by time_body_accelerometer_jerk_motion_) and angular velocity (prefixed by time_body_gyroscope_jerk_motion_).

There are 5 calculated variables representing the magnitude of the above 3D signals, prefixed with (time_body_accelerometer_magnitude_),(time_gravity_motion_accelerometer_magnitude_),(time_body_accelerometer_jerk_motion_magnitude_),(time_body_gyroscope_magnitude_), and (time_body_gyroscope_jerk_magnitude_).

There are 9 frequency signals, 3 each for the x, y, and z axis, representing accelerometer (prefixed by frequency_body_accelerometer_), the jerk motion of the accelerometer (prefixed by frequency_body_accelerometer_jerk_motion_), and the gyroscope (prefixed by frequency_body_gyroscope_).

There are 4 calculated variables representing the magnitude of the above 3D signals, prefixed with (frequency_body_accelerometer_magnitude_), (frequency_body_accelerometer_jerk_motion_magnitude), (frequency_body_gyroscope_magnitude_), and (frequency_body_gyroscope_jerk_motion_magnitude_).
