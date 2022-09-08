# Performs preprocessing on anatomical images using Spinal Cord Toolbox
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

######################
#                    #
# Vertebral Labeling #
#                    #
######################

# Labeling conventions:
# https://spinalcordtoolbox.com/user_section/tutorials/registration-to-template/vertebral-labeling/labeling-conventions.html

#sct_label_utils -i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-create-viewer 11,20 \
#-o anat_labels_disc.nii.gz \
#-msg "Place labels at the posterior tip of each inter-vertebral disc. E.g. Label 11: T3/T4, Label 20: T12/L1"

####################################
#                                  #
# Registration to template (PAM50) #
#                                  #
####################################

# note: this uses the disk labels (see -ldisc)
#sct_register_to_template \
#-i 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
#-s anat_propseg.nii.gz \
#-ldisc anat_labels_disc.nii.gz \
#-c t2 \
#-qc $qc_dir

##################################################
#                                                #
# Transforming the template using warping fields #
#                                                #
##################################################

sct_warp_template -d 103_HASTE_t2-Sag_20220811124555_3.nii.gz \
-w warp_template2anat.nii.gz \
-a 0 \
-qc $qc_dir


