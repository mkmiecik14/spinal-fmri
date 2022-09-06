# DICOM 2 NIFTI Conversion
main_dir="/mnt/c/Analysis/spinal-fmri/"
cd $main_dir

# HERE: create output directory for this ss if does not exist

output_dir="${main_dir}output/"
ss="103/"
ss_dir="${main_dir}${ss}"

# dicom to nifti conversion
# code so that it is flexible to ss number
dcm2niix -o ./output/103/ -z y ./data/103/
