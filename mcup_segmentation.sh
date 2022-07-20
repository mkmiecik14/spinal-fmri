# Anatomical pre-processing 

# Performs sc segmentation 
sct_deepseg_sc \
-i ./data/mcup/Series50/Series50.nii.gz \
-centerline viewer \
-c t2s \
-thr 0.99 \
-brain 0 \
-kernel 2d \
-v 1 \
-qc ./data/mcup/Series50/qc_report/ \
-ofolder ./data/mcup/Series50/ \
-o anat_segment.nii.gz

# manual labeling ALL labels 
sct_label_utils \
-i ./data/mcup/Series50/Series50.nii.gz \
-create-viewer 16:19 \
-o ./data/mcup/Series50/labels_disc.nii.gz

# extracting specific labels for registration 
sct_label_utils \
-i ./data/mcup/Series50/labels_disc.nii.gz \
-vert-body 17,18 \
-o ./data/mcup/Series50/anat_segment_vert.nii.gz

# applying registration algorithm 
sct_register_to_template \
-i ./data/mcup/Series50/Series50.nii.gz \
-s ./data/mcup/Series50/anat_segment.nii.gz \
-l ./data/mcup/Series50/anat_segment_vert.nii.gz \
-c t2 \
-o ./data/mcup/Series50/ \
-qc ./data/mcup/Series50/qc_report/

# Transforming template using warping fields
sct_warp_template \
-d ./data/mcup/Series50/Series50.nii.gz \
-w ./data/mcup/Series50/warp_template2anat.nii.gz \
-a 0 \
-ofolder ./data/mcup/Series50/label \
-qc ./data/mcup/Series50/qc_report/

# Gray matter segmentation 
sct_deepseg_gm \
-i ./data/mcup/Series50/Series50.nii.gz \
-o ./data/mcup/Series50/gm_segment.nii.gz \
-qc ./data/mcup/Series50/qc_report/ 


