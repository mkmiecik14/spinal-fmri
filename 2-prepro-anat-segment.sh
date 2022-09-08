# Performs segmentation on anatomical images
# Matt Kmiecik
# Started 7 SEPT 2022

# Sets present working directory
main_dir="/mnt/c/Analysis/spinal-fmri/"
cd $main_dir
# all paths relative from here

# The subject we are working on:
ss="103/"

# change dir into subject dir
cd ./output/$ss

# Initializations
qc_dir="./qc/"

# Step 1 - Segmentation
# This step creates a segmentation mask isolating spinal cord in the anatomical
# image

# First trying segmentation using the raw anatomical image with user input:
sct_propseg \
-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
-c t2 \
-init-centerline viewer \
-max-deformation 5 \
-qc $qc_dir \
-o anat_propseg.nii.gz

# If this does not work; try smoothing the anatomical image:
#sct_smooth_spinalcord -i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-s anat_propseg.nii.gz \
#-smooth 0,0,5

#sct_propseg -i 103_HASTE_t2-Sag_20220811124555_3_smooth.nii.gz \
#-c t2 \
#-init-centerline viewer \
#-qc $qc_dir \
#-o anat_propseg.nii.gz

#sct_propseg -i 103_HASTE_t2-Sag_20220811124555_3_smooth.nii.gz \
#-c t2 \
#-init-centerline 103_HASTE_t2-Sag_20220811124555_3_smooth_centerline.nii.gz \
#-radius 7 \
#-qc $qc_dir \
#-o anat_propseg.nii.gz

# If smoothing does not work, try sct_deepseg_sc:
#sct_deepseg_sc \
#-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-centerline viewer \
#-c t2 \
#-brain 0 \
#-v 1 \
#-qc $qc_dir \
#-o anat_segment.nii.gz
