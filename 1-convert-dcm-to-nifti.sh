# DICOM 2 NIFTI Conversion
# Matt Kmiecik
# Started 7 SEPT 2022

# Sets present working directory
main_dir="/mnt/c/Analysis/spinal-fmri/"
cd $main_dir

# the subject number we are working with:
ss="103/"

# output directory for this subject
#output_dir="${main_dir}output/${ss}"

# makes the directory if it doesn't exist yet
mkdir -p ./output/$ss

# dicom to nifti conversion (ignores localizer and 2D images)
dcm2niix -o ./output/$ss -z y -i y ./data/$ss
