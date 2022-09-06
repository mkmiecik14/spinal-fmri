# 12345678901234567890123456789012345678901234567890123456789012345678901234567890
# Performs preprocessing on anatomical images using Spinal Cord Toolbox
main_dir="/mnt/c/Analysis/spinal-fmri/"
cd $main_dir

cd output/103/

################
#              #
# SEGMENTATION #
#              #
################

# This step creates a segmentation mask isolating spinal cord in the anatomical
# image

# sct_propseg works better than sct_deepseg_sc on 103 
#sct_propseg \
#-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-c t2 \
#-init-centerline viewer \
#-qc ./qc_report/ \
#-ofolder ./ \
#-o anat_propseg.nii.gz

#sct_deepseg_sc \
#-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-centerline viewer \
#-c t2 \
#-brain 0 \
#-v 1 \
#-qc ./qc_report/ \
#-ofolder ./ \
#-o anat_segment.nii.gz

######################
#                    #
# Vertebral Labeling #
#                    #
######################

#sct_label_utils -i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-create-viewer 11,20 \
#-o anat_labels_disc.nii.gz \
#-msg "Place labels at the posterior tip of each inter-vertebral disc. E.g. Label 11: T3/T4, Label 20: T12/L1"

# DID NOT WORK
#sct_label_vertebrae \
#-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-s anat_propseg.nii.gz \
#-c t2 \
#-discfile anat_labels_disc.nii.gz \
#-ofolder ./ \
#-qc ./qc_report/ 

# PROBABLY NOT NECESSARY
#sct_label_utils \
#-i anat_labels_disc.nii.gz \
#-vert-body 11,20 \
#-o anat_labels_vert.nii.gz

####################################
#                                  #
# Registration to template (PAM50) #
#                                  #
####################################

#sct_register_to_template \
#-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-s anat_propseg.nii.gz \
#-ldisc anat_labels_disc.nii.gz \ # USE THE DISK LABELS HERE
#-c t2 \
#-qc ./qc_report/ \
#-ofolder ./

##################################################
#                                                #
# Transforming the template using warping fields #
#                                                #
##################################################

sct_warp_template -d 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
-w warp_template2anat.nii.gz \
-a 0 \
-qc ./qc_report/


