# Preprocess_EEG_EyeTrack

This is my pipeline for the preprocessing EEG and eye tracking data obtained in the Awh-Vogel Lab setup. 

Note: We record EEG data with [BrainVision Recorder](www.brainproducts.com). We record eye tracking data with the [EyeLink 1000Plus](http://www.sr-research.com/mount_desktop_1000plus.html). 

## Step 1: Preprocess EEG

Use `runEEG.m` to preprocess the EEG data. 

You can specify important preprocessing settings in `EEG_Settings.m` (e.g., event markers of interest, epoch size, the directory that contains the data, and artifact rejection settings).

`runEEG.m` will perform the following preprocessing steps:

* re-reference
* segmentation
* baseline correction
* automated artifact rejection

## Step 2: Preprocess eye tracking data

Use `runEyeTrack.m` to preprocess the eye tracking data. 

You can specify the important preprocessing settings in `EyeTrack_Settings.m` (e.g., event messages of interest, epoch size, the directory that contains the data). The artifact rejection settings are specified in `EyeTrack_ArtRejectSettings.m`.

`runEyeTrack.m` will perform the following preprocessing steps:

* segmentation
* convert gaze from pixels to degrees from fixation
* baseline correct eye tracking data
* automated artifact detection (saccades, blinks, missing pupil)

## Step 3: Check automated artifact rejection

Use [EEGLAB](https://sccn.ucsd.edu/eeglab/index.php)'s gui to manually inspect the data for artifacts. To reformat the segmented data files (EEG and eye tracking) to view them in EEGLAB, run `RestructureforEEGLABgui.m`.

You can use the EEGLAB gui to scroll through the data and check that the automatic artifact rejection was effective (i.e., artifacts were rejected and there weren't many good trials marked). Here, you can mark artifacts that were missed by the automated routines or unmark good trials that were marked as containing an artifact. To do this:

1. Open EEGLAB by typing 'eeglab' in the matlab command line
2. Open the relevant data file: File -> Load Existing Dataset
3. Use the gui for manual inspection of trials: Tools -> Reject data epochs -> Reject data (all methods)
   * Click **Scroll data**
   * Click on an epoch to mark as an artifact (will turn yellow), clicking again will unmark the epoch.
   * Once finished, click **Update Marks**
   * Make sure you save the changes in the main EEGLAB window: File -> Save current dataset(s)

Note that the eye tracking and EOG channels have been offset so that they will be clearly visible when you stack the channels (click "stack" in the top right of the scroll window). The horizontal eye position and HEOG are above the scalp channels (which are all stacked), and the vertical eye position and the VEOG are below the scalp channels.

Finally, you can run `compileEEGarf.m` to save the updated artifact index back into the file that contains the segmented EEG data. 

### What if the automated artifact rejection procedures did a bad job?

There are two options if the automated artifact rejection procedures did a bad job. 

1. Check each and every trial manually, marking the trials with artifacts and unmarking the artifact-free trials. This is time consuming instead you could...
2. Adjust the artifact rejection settings and re-run the automated procedures. 
   * You can change the settings in `EEG_Settings.m` and `EyeTrack_ArtRejectSettings.m`
   * Once you've updated the `EEG_settings.m`, simply re-run `runEEG.m`
   * Once you've updated the `EyeTrack_ArtRejectSettings.m`, run `redoEyeTracArtReject.m`, which will save you having to re-run the time-consuming segmentation. This function just updates the artifact rejection indices. 

### Key

Different artifacts are marked with different colors in EEGLAB. Below is a summary of what each color means.

####For subjects with eye tracking:

* Blue: high-frequency noise
* Green: drifts
* Lime green: blinks, blocking, or sudden steps in voltage (dropout)
* Red: saccades (based on eye tracking)
* Pink: eye tracking gaze coordinates to far from fixation or pupil missing

####For subjects without eye tracking:

* Blue: high-frequency noise
* Green: drifts
* Lime green: blinks, blocking, or sudden steps in voltage (dropout)
* Red: saccades based on EOG (usually pretty inaccurate)

·    















