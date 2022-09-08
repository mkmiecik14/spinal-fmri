# This script performs preprocessing on fMRI runs
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

# Beginning of run loop
run=$((0))
for i in 103_HASTE_BOLD*.nii.gz;
do
	echo Processing $i
	run=$(($run + 1)) # provides a counter for runs
	echo Run $run
	
done;

# Step 1 - remove first volume
sct_image -i 103_HASTE_BOLD_SAG_SPINE_PRE_ICE_20220811124555_4.nii.gz \
-remove-vol 0 \
-o fmri_run1.nii.gz

# Step 2 - compute mean image
#sct_maths -i fmri_run1.nii.gz -mean t -o fmri_run1_mean.nii.gz

# Step 3 - transforming the T2 segmentation (from anat preprocessing) to the
# fMRI space
#sct_register_multimodal -i anat_propseg.nii.gz \
#-d fmri_run1_mean.nii.gz \
#-identity 1

# Step 4 - creating a mask around the spinal cord
# this will use the anatomical mask registered to fMRI space created in step 3
#sct_create_mask -i fmri_run1.nii.gz \
#-p centerline,anat_propseg_reg.nii.gz \
#-size 35mm \
#-f cylinder \
#-o fmri_run1_mask.nii.gz

# Step 5 - motion correction
#sct_fmri_moco -i fmri_run1.nii.gz \
#-m fmri_run1_mask.nii.gz \
#-qc $qc_dir \
#-qc-seg anat_propseg_reg.nii.gz

# Step 6 - registering fMRI data to PAM50 template
#sct_register_multimodal -i "${SCT_DIR}/data/PAM50/template/PAM50_t2s.nii.gz" \
#-d fmri_run1_moco_mean.nii.gz \
#-dseg anat_propseg_reg.nii.gz \
#-param step=1,type=im,algo=syn,metric=CC,iter=5,slicewise=0 \
#-initwarp warp_template2anat.nii.gz \
#-initwarpinv warp_anat2template.nii.gz \
#-owarp warp_template2fmri_run1.nii.gz \
#-owarpinv warp_fmri_run12template.nii.gz \
#-qc $qc_dir

# Step 7 - warping spinal levels to fMRI space
#sct_warp_template -d fmri_run1_moco_mean.nii.gz \
#-w warp_template2fmri_run1.nii.gz \
#-s 1 \
#-a 0 \
#-qc $qc_dir
