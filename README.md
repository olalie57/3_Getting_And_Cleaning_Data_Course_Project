# README.md

The idea of the experiment is to use smartphone as an inexpensive tool to monitor physical activity.
Is the person walking, standing, laying, etc. This information could be used, for instance,
within healthcare in daily activity monitoring for elderly people. More information about the experiment
is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

In the raw data, the subjects and activities are stored in separate files. Furthermore, the observations
are split in two files (train and test). This program combines the data to one file, selects only variables
that has to do with the mean and standard deviation. More specfic, the script:

<ol>
  <li>Checks if the &quot;UCI HAR Dataset&quot; folder exists. If it does, it is assumed that the raw data is in place.<br>
    If not, the zip file is downloaded and unpacked.</li>
  <li>Then the two sets are combined (test and train).</li>
  <li>79 of 561 columns are selected (those with mean and standard deviation)</li>
  <li>The numerical values of the different activities are replaced by explanatory words.<br>
    The files with the activities corresponding the observations are read and merged with the rest of the data.</li>
  <li>The names of the other variables are made more explanatory.</li>
  <li>The files with the subjects corresponding to the observations are read and merged.</li>
  <li>The observations are summarized, calculating the mean grouped by activity and subject.</li>
  <li>The result is written to the file tidyDataSet.txt</li>
</ol>

All you have to do to create your own tidyDataSet.txt, is to download run_analysis.R, set the woriking directory, and run the script.
