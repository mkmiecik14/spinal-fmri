#!/bin/bash

# DICOM 2 NIFTI Conversion
# Matt Kmiecik
# Started 9 SEPT 2022

# Purpose: a function to convert DICOMS to NIFTI by accepting the participant
# number as an input

# Usage: convert_dicom_to_nifti 101
# assumes that you are in the main dir and that there is a data/ and output/ dir

convert_dicom_to_nifti(){

	# the subject number we are working with:
	ss=$1
	
	# makes the directory if it doesn't exist yet
	mkdir -p ./output/$ss

	# dicom to nifti conversion (ignores localizer and 2D images)
	dcm2niix -o ./output/$ss -z y -i y ./data/$ss

}


