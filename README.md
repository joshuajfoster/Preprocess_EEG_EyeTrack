# Preprocess_EEG_EyeTrack

This is my pipeline for the preprocessing EEG and eye tracking data obtained in the Awh-Vogel Lab setup. 

Note: We record EEG data with [BrainVision Recorder](www.brainproducts.com). We record eye tracking data with the [EyeLink 1000Plus](http://www.sr-research.com/mount_desktop_1000plus.html). 

## EEG preprocessing

Use `runEEG.m` to preprocess the EEG data. 

You can specify important preprocessing settings in `EEG_Settings.m` (e.g., event markers of interest, epoch size, the directory that contains the data).

`runEEG.m` will perform the following preprocessing steps:

* re-reference
* segmentation
* some preliminary artifact detection (saccades, blinks etc.)
* baseline correction

## Eye tracking preprocessing

Use `runEyeTrack.m` to preprocess the eye tracking data. 

You can specify the important preprocessing settings in `EyeTrack_Settings.m` (e.g., event messages of interest, epoch size, the directory that contains the data).

`runEyeTrack.m` will perform the following preprocessing steps:

* segmentation
* convert gaze from pixels to degrees from fixation
* some preliminary artifact detection (saccades, blinks etc.)

## Manual artifact rejection

We use [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)'s gui to manually inspect the data for artifacts. `RestructureforEEGLABgui.m` will take the segmeted data files created by `runEEG.m` and `runEyeTrack.m` and create a reformatted file that can be read by EEGLAB. 

You can use this gui to unmark any trials that were erroneously marked as an artifact by the automated routines, or mark any artifacts that were missed. To do this:

1. Open EEGLAB by typing 'eeglab' in the matlab command line
2. Open the relevant data file: File -> Load Existing Dataset
3. Use the gui for manual inspection of trials: Tools -> Reject data epochs -> Reject data (all methods)
   * Click **Scroll data**
   * Click on an epoch to mark as as artifact (will turn yellow), clicking again will unmark the epoch.
   * Once finished, click **Update Marks**
   * Make sure you save the changes in the main EEGLAB window: File -> Save current dataset(s)

Finally, you can run `compileEEGarf.m` to save the updated artifact index back into the file that contains the segmented EEG data. 













