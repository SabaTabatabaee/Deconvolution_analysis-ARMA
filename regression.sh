#!/bin/csh

############################## Initialize parameters ##############################
set subj = $1

set proj_path = /Users/sabatb/Desktop/data
set out = "$proj_path"/output"$subj"
mkdir -p $out
set subj_name = subj"$subj"
set stimtimes = "$proj_path"/"$subj_name"
set input = "$proj_path"/"$subj_name"/led_concatinated_"$subj_name".1D
set fileCensor = "$proj_path"/"$subj_name"/censor_labels_"$subj_name".1D
set concatinfo = "$proj_path"/"$subj_name"/starting_times_"$subj_name".1D

set visual_basis = "CSPLIN(-10,15, 26)"
echo $visual_basis

echo "========================================================="
echo "        Analysis of $subj_name from file: $input"
echo "========================================================="
############################## Doing first stage regression ##############################
3dDeconvolve -overwrite \
    -force_TR 1 \
	-input $input \
	-noFDR \
	-polort A \
	-local_times \
	-censor "$fileCensor" \
	-concat "$concatinfo" \
	-num_stimts 1 \
	-stim_times 1 "$stimtimes"/stim_times_"$subj_name".1D "$visual_basis" 		-stim_label 1 visualstimulation \
	-x1D "$out"/"$subj_name"_Main_block_deconv.x1D \
	-x1D_uncensored "$out"/"$subj_name"_Main_block_deconv_uncensored.x1D \
	-errts "$out"/"$subj_name"_resids.1D \
	-bucket "$out"/"$subj_name"_bucket.1D \
	-cbucket "$out"/"$subj_name"_betas.1D \
	-x1D_stop


echo "***** Running 3dREMLfit *****"
3dREMLfit -matrix "$out"/"$subj_name"_Main_block_deconv.x1D \
	-input $input \
	-overwrite \
	-noFDR \
	-Rbeta "$out"/"$subj_name"_betas_REML.1D \
	-Rbuck "$out"/"$subj_name"_bucket_REML.1D \
	-Rvar "$out"/"$subj_name"_bucket_REMLvar.1D \
	-Rerrts "$out"/"$subj_name"_resids_REML.1D \
	-Rwherr "$out"/"$subj_name"__wherrs_REML.1D \
	

echo "Exiting..."
exit





