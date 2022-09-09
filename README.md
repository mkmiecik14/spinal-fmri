# Spinal fMRI

This repository contains code related to processing spinal fMRI data.

The main project is organized the following way:

|---- spinal-fmri/    * I refer to this as the main directory
|
|-- data/       * raw data and info about participants
|
|-- docs/       * documentation
|
|-- output/     * any files that were manipulated by code
|
|-- src/        * this is what is on github


## Processing scripts

**Step 1 - convert raw data from DICOM to NIFTI format**

* `convert-dicom-to-nifti.sh` this is a shell script function that I developed that will convert the dicom files in a participant's data/ directory and place them in the participants output/ directory (localizer and 2D files are ignored).

Run the function in the main directory with the participant number (i.e., data/ directory name) as input:
EXAMPLE: convert_dicom_to_nifti 103 # this will process participant ./data/103/

* `1-convert-dcm-to-nifti.sh` is the same above but not as a function (i.e., does not take input, but you will have to modify the code to run other participants)

**Step 2 - preprocess anatomical files**

Given our non-traditional way of imaging the spinal cord (i.e., vertebrae C2-C3 not visible), this is a semi-automated processing pipeline. Closely follows the Spinal Cord Toolbox tutorials: https://spinalcordtoolbox.com/user_section/tutorials/segmentation.html

First, run the script `2-prepro-anat-segment.sh` to segment the spinal cord. You wiill have to select the center of the spinal cord to help the algorithm.

Then, run the script `3-prepro-anat.sh` that will prompt you to label vertebral discs. These will likely change in the future with changes in scanning parameters.

**Step 3 - preprocess functional runs**

Assuming that your functional runs are identical, run the script `4-prepro-fmri.sh`. This will loop through the functional runs and perform a series of processing steps (e.g., removing first volume, motion correction, registration, mean centering, concatenation). This script will have to be edited for participant number and probably scan names.

**Step 4 - GLM**

Scripting has yet to be developed for this step, but use FSL's FEAT tool.


