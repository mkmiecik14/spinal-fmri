# Anatomical Pre-processing 
# ---------------------------------------

# Performs sc segmentation
sct_deepseg_sc \
-i ./data/matt/Series9/Series9.nii.gz \
-centerline viewer \
-c t2 \
-brain 0 \
-kernel 2d \
-v 1 \
-qc ./data/matt/Series9/qc_report/ \
-ofolder ./data/matt/Series9/ \
-o anat_segment.nii.gz

sct_deepseg_sc \
-i ./data/mcup/Series50/Series50.nii.gz \
-centerline viewer \
-c t2 \
-brain 0 \
-kernel 2d \
-v 1 \
-qc ./data/mcup/Series50/qc_report/ \
-ofolder ./data/mcup/Series50/ \
-o anat_segment.nii.gz

# manual labeling ALL labels 
sct_label_utils \
-i ./data/matt/Series9/Series9.nii.gz \
-create-viewer 17:19 \
-o ./data/matt/Series9/labels_disc.nii.gz

sct_label_utils \
-i ./data/mcup/Series50/Series50.nii.gz \
-create-viewer 15:19 \
-o ./data/mcup/Series50/labels_disc.nii.gz

# extracting specific labels for registration 
sct_label_utils \
-i ./data/matt/Series9/labels_disc.nii.gz \
-vert-body 18 \
-o ./data/matt/Series9/anat_segment_vert.nii.gz 

sct_label_utils \
-i ./data/mcup/Series50/labels_disc.nii.gz \
-vert-body 16,18 \
-o ./data/mcup/Series50/anat_segment_vert.nii.gz

# applying registration algorithm 
sct_register_to_template \
-i ./data/matt/Series9/Series9.nii.gz \
-s ./data/matt/Series9/anat_segment.nii.gz \
-l ./data/matt/Series9/anat_segment_vert.nii.gz \
-c t2 \
-o ./data/matt/Series9/ \
-qc ./data/matt/Series9/qc_report/

sct_register_to_template \
-i ./data/mcup/Series50/Series50.nii.gz \
-s ./data/mcup/Series50/anat_segment.nii.gz \
-l ./data/mcup/Series50/anat_segment_vert.nii.gz \
-c t2 \
-o ./data/mcup/Series50/ \
-qc ./data/mcup/Series50/qc_report/

# Transforming template using warping fields
sct_warp_template \
-d ./data/matt/Series9/Series9.nii.gz \
-w ./data/matt/Series9/warp_template2anat.nii.gz \
-a 0 \
-ofolder ./data/matt/Series9/label \
-qc ./data/matt/Series9/qc_report/

sct_warp_template \
-d ./data/mcup/Series50/Series50.nii.gz \
-w ./data/mcup/Series50/warp_template2anat.nii.gz \
-a 0 \
-ofolder ./data/mcup/Series50/label \
-qc ./data/mcup/Series50/qc_report/

# Gray matter segmentation 
sct_deepseg_gm \
-i ./data/matt/Series9/template2anat.nii.gz \
-o ./data/matt/Series9/gm_segment.nii.gz \
-qc ./data/matt/Series9/qc_report/

sct_deepseg_gm \
-i ./data/mcup/Series50/template2anat.nii.gz \
-o ./data/mcup/Series50/gm_segment.nii.gz \
-qc ./data/mcup/Series50/qc_report/

# Subtracting gray matter and white matter
sct_maths \
-i ./data/matt/Series9/anat_segment.nii.gz \
-sub ./data/matt/Series9/gm_segment.nii.gz \
-o ./data/matt/Series9/wm_segment.nii.gz 

sct_maths \
-i ./data/mcup/Series50/anat_segment.nii.gz \
-sub ./data/mcup/Series50/gm_segment.nii.gz \
-o ./data/mcup/Series50/wm_segment.nii.gz 

# computing CSA for gm and wm (using binary mask)
sct_process_segmentation \
-i ./data/matt/Series9/wm_segment.nii.gz \
-o ./data/matt/Series9/wm_csa.csv \
-perslice 1 \
-angle-corr 0

sct_process_segmentation \
-i ./data/matt/Series9/gm_segment.nii.gz \
-o ./data/matt/Series9/gm_csa.csv \
-perslice 1 \
-angle-corr 0

sct_process_segmentation \
-i ./data/mcup/Series50/wm_segment.nii.gz \
-o ./data/mcup/Series50/wm_csa.csv \
-perslice 1 \
-angle-corr 0

sct_process_segmentation \
-i ./data/mcup/Series50/gm_segment.nii.gz \
-o ./data/mcup/Series50/gm_csa.csv \
-perslice 1 \
-angle-corr 0

# computing intensity values for gm and wm (using binary mask)
sct_extract_metric \
-i ./data/matt/Series9/Series9.nii.gz \
-f ./data/matt/Series9/wm_segment.nii.gz \
-method bin \
-z 240:305 \
-o ./data/matt/Series9/wm_intensity.csv

sct_extract_metric \
-i ./data/matt/Series9/Series9.nii.gz \
-f ./data/matt/Series9/gm_segment.nii.gz \
-method bin \
-z 240:305 \
-o ./data/matt/Series9/gm_intensity.csv

sct_extract_metric \
-i ./data/mcup/Series50/Series50.nii.gz \
-f ./data/mcup/Series50/wm_segment.nii.gz \
-method bin \
-z 240:305 \
-o ./data/mcup/Series50/wm_intensity.csv

sct_extract_metric \
-i ./data/mcup/Series50/Series50.nii.gz \
-f ./data/mcup/Series50/gm_segment.nii.gz \
-method bin \
-z 240:305 \
-o ./data/mcup/Series50/gm_intensity.csv

-append 1

# straightening the sc 
sct_crop_image \
-i ./data/matt/Series9/Series9.nii.gz \
-m ./data/matt/Series9/label/template/PAM50_gm.nii.gz \
-o ./data/matt/Series9/CROP.nii.gz

sct_straighten_spinalcord \
-i ./data/matt/Series9/Series9.nii.gz \
-s ./data/matt/Series9/label/template/PAM50_gm.nii.gz \
-dest ./data/matt/Series9/CROP.nii.gz \
-o ./data/matt/Series9/STRAIGHT.nii.gz

# ---------------------------------------
# fMRI Pre-processing 
# ---------------------------------------

# Initializes variables
SCT_DIR="C:\Users\GyrlUser\spinalcordtoolbox"

# Computing a mean image (default Series7)
sct_maths \
-i ./data/matt/Series7/Series7.nii.gz \
-mean t \
-o ./data/matt/Series7/mean.nii.gz

sct_maths \
-i ./data/matt/Series8/Series8.nii.gz \
-mean t \
-o ./data/matt/Series8/mean.nii.gz

sct_maths \
-i ./data/mcup/Series51/Series51.nii.gz \
-mean t \
-o ./data/mcup/Series51/mean.nii.gz

# Getting spinal cord centerline 
sct_get_centerline \
-i ./data/matt/Series7/mean.nii.gz \
-c t2 \
-method viewer \
-o ./data/matt/Series7/mean_centerline.nii.gz

sct_get_centerline \
-i ./data/matt/Series8/mean.nii.gz \
-c t2 \
-method viewer \
-o ./data/matt/Series8/mean_centerline.nii.gz

sct_get_centerline \
-i ./data/mcup/Series51/mean.nii.gz \
-c t2 \
-method viewer \
-o ./data/mcup/Series51/mean_centerline.nii.gz

# Creating mask around spinal cord 
sct_create_mask \
-i ./data/matt/Series7/Series7.nii.gz \
-p centerline,./data/matt/Series7/mean_centerline.nii.gz \
-size 35mm \
-f cylinder \
-o ./data/matt/Series7/mask_sc.nii.gz

sct_create_mask \
-i ./data/matt/Series8/Series8.nii.gz \
-p centerline,./data/matt/Series8/mean_centerline.nii.gz \
-size 35mm \
-f cylinder \
-o ./data/matt/Series8/mask_sc.nii.gz

sct_create_mask \
-i ./data/mcup/Series51/Series51.nii.gz \
-p centerline,./data/mcup/Series51/mean_centerline.nii.gz \
-size 35mm \
-f cylinder \
-o ./data/mcup/Series51/mask_sc.nii.gz

# Motion correction 
sct_fmri_moco \
-i ./data/matt/Series7/Series7.nii.gz \
-m ./data/matt/Series7/mask_sc.nii.gz \
-g 1 \
-ofolder ./data/matt/Series7/ 

sct_fmri_moco \
-i ./data/matt/Series8/Series8.nii.gz \
-m ./data/matt/Series8/mask_sc.nii.gz \
-g 1 \
-ofolder ./data/matt/Series8/ 

sct_fmri_moco \
-i ./data/mcup/Series51/Series51.nii.gz \
-m ./data/mcup/Series51/mask_sc.nii.gz \
-g 1 \
-ofolder ./data/mcup/Series51/

# manual sc segmentation
sct_deepseg_sc \
-i ./data/matt/Series7/Series7_moco_mean.nii.gz \
-centerline viewer \
-c t2 \
-brain 0 \
-kernel 2d \
-v 1 \
-o ./data/matt/Series7/Series7_moco_mean_segment.nii.gz

sct_deepseg_sc \
-i ./data/matt/Series8/Series8_moco_mean.nii.gz \
-centerline viewer \
-c t2 \
-brain 0 \
-kernel 2d \
-v 1 \
-o ./data/matt/Series8/Series8_moco_mean_segment.nii.gz 

sct_deepseg_sc \
-i ./data/mcup/Series51/Series51_moco_mean.nii.gz \
-centerline viewer \
-c t2 \
-brain 0 \
-kernel 2d \
-v 1 \
-o ./data/mcup/Series51/Series51_moco_mean_segment.nii.gz 

# Transform T2 anat. seg. to fMRI space 
sct_register_multimodal \
-i ./data/matt/Series9/anat_segment.nii.gz \
-d ./data/matt/Series7/mean.nii.gz \
-identity 1 \
-ofolder ./data/matt/Series7

sct_register_multimodal \
-i ./data/matt/Series9/anat_segment.nii.gz \
-d ./data/matt/Series8/mean.nii.gz \
-identity 1 \
-ofolder ./data/matt/Series8/

sct_register_multimodal \
-i ./data/mcup/Series50/anat_segment.nii.gz \
-d ./data/mcup/Series51/mean.nii.gz \
-identity 1 \
-ofolder ./data/mcup/Series51/

# Register fMRI onto template 
sct_register_multimodal \
-i "${SCT_DIR}/data/PAM50/template/PAM50_t2.nii.gz" \
-d ./data/matt/Series7/Series7_moco_mean.nii.gz \
-dseg ./data/matt/Series7/Series7_moco_mean_segment.nii.gz \
-param step=1,type=im,algo=syn,metric=CC,iter=5,slicewise=0 \
-initwarp ./data/matt/Series9/warp_template2anat.nii.gz \
-initwarpinv ./data/matt/Series9/warp_anat2template.nii.gz \
-owarp ./data/matt/Series7/warp_template2fmri.nii.gz \
-owarpinv ./data/matt/Series7/warp_fmri2template.nii.gz \
-qc ./data/matt/Series7/qc_report/ \
-ofolder ./data/matt/Series7/ 

sct_register_multimodal \
-i "${SCT_DIR}/data/PAM50/template/PAM50_t2.nii.gz" \
-d ./data/matt/Series8/Series8_moco_mean.nii.gz \
-dseg ./data/matt/Series8/Series8_moco_mean_segment.nii.gz \
-param step=1,type=im,algo=syn,metric=CC,iter=5,slicewise=0 \
-initwarp ./data/matt/Series9/warp_template2anat.nii.gz \
-initwarpinv ./data/matt/Series9/warp_anat2template.nii.gz \
-owarp ./data/matt/Series8/warp_template2fmri.nii.gz \
-owarpinv ./data/matt/Series8/warp_fmri2template.nii.gz \
-qc ./data/matt/Series8/qc_report/ \
-ofolder ./data/matt/Series8/ 

sct_register_multimodal \
-i "${SCT_DIR}/data/PAM50/template/PAM50_t2.nii.gz" \
-d ./data/mcup/Series51/Series51_moco_mean.nii.gz \
-dseg ./data/mcup/Series51/Series51_moco_mean_segment.nii.gz \
-param step=1,type=im,algo=syn,metric=CC,iter=5,slicewise=0 \
-initwarp ./data/mcup/Series50/warp_template2anat.nii.gz \
-initwarpinv ./data/mcup/Series50/warp_anat2template.nii.gz \
-owarp ./data/mcup/Series51/warp_template2fmri.nii.gz \
-owarpinv ./data/mcup/Series51/warp_fmri2template.nii.gz \
-qc ./data/mcup/Series51/qc_report/ \
-ofolder ./data/mcup/Series51/ 

# warping template/ Spinal labeling 
sct_warp_template \
-d ./data/matt/Series7/Series7_moco_mean.nii.gz \
-w ./data/matt/Series7/warp_template2fmri.nii.gz \
-s 1 \
-a 0 \
-qc ./data/matt/Series7/qc_report/ \
-ofolder ./data/matt/Series7/ 

sct_warp_template \
-d ./data/matt/Series8/Series8_moco_mean.nii.gz \
-w ./data/matt/Series8/warp_template2fmri.nii.gz \
-s 1 \
-a 0 \
-qc ./data/matt/Series8/qc_report/ \
-ofolder ./data/matt/Series8/ 

sct_warp_template \
-d ./data/mcup/Series51/Series51_moco_mean.nii.gz \
-w ./data/mcup/Series51/warp_template2fmri.nii.gz \
-s 1 \
-a 0 \
-qc ./data/mcup/Series51/qc_report/ \
-ofolder ./data/mcup/Series51/

# Cropping an image 
sct_crop_image \
-i ./data/matt/Series7/Series7_moco.nii.gz \
-m ./data/matt/Series7/template/PAM50_gm.nii.gz \
-o ./data/matt/Series7/crop_Series7_moco.nii.gz

sct_crop_image \
-i ./data/matt/Series8/Series8_moco.nii.gz \
-m ./data/matt/Series8/template/PAM50_gm.nii.gz \
-o ./data/matt/Series8/crop_Series8_moco.nii.gz 

sct_crop_image \
-i ./data/mcup/Series51/Series51_moco.nii.gz \
-m ./data/mcup/Series51/template/PAM50_gm.nii.gz \
-o ./data/mcup/Series51/crop_Series51_moco.nii.gz 

# Straightening the spinal cord 
sct_straighten_spinalcord \
-i ./data/matt/Series7/Series7_moco.nii.gz \
-s ./data/matt/Series7/template/PAM50_gm.nii.gz \
-dest ./data/matt/Series7/crop_Series7_moco.nii.gz \
-o ./data/matt/Series7/straight_Series7_moco.nii.gz

sct_straighten_spinalcord \
-i ./data/matt/Series8/Series8_moco.nii.gz \
-s ./data/matt/Series8/template/PAM50_gm.nii.gz \
-dest ./data/matt/Series8/crop_Series8_moco.nii.gz \
-o ./data/matt/Series8/straight_Series8_moco.nii.gz

sct_straighten_spinalcord \
-i ./data/mcup/Series51/Series51_moco.nii.gz \
-s ./data/mcup/Series51/template/PAM50_gm.nii.gz \
-dest ./data/mcup/Series51/crop_Series51_moco.nii.gz \
-o ./data/mcup/Series51/straight_Series51_moco.nii.gz

# Applying the warping fields (in Ubuntu) -- not aligning with input image and warping field files error
applywarp \
-i crop_Series7_moco.nii.gz \
-r ./template/PAM50_gm.nii.gz \
-o WARP.nii.gz

# Smoothing -- only for 3D images***
sct_smooth_spinalcord \
-i ./data/mcup/Series50/Series50.nii.gz \
-s ./data/mcup/Series50/anat_segment.nii.gz \
-smooth 3 \
-o ./data/mcup/Series50/Series50_blur.nii.gz