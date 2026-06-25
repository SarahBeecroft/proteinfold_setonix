#!/bin/bash -l 
#SBATCH --job-name=proteinfold
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=4GB
#SBATCH --account=pawsey0012
#SBATCH --partition=work


# Load singularity module.
module load singularity/3.11.4-nompi 

# This workflow seems to only work with Nextflow version 25.10.4, which I installed in my conda base environment. 
# If you choose to install into a different conda environment, you'll need to replace `base` with your environment name
conda_activate="${CONDA_EXE%conda}activate"
source $conda_activate base

export NXF_SINGULARITY_CACHEDIR=/scratch/pawsey0001/sbeecroft/nf_singularity_cache
export SINGULARITY_CACHEDIR=/scratch/pawsey0001/sbeecroft/singularity_cache

# Run the workflow
nextflow run main.nf \
    --input samplesheet.csv \
    --outdir $MYSCRATCH/proteinfold/outdir \
    -config pawsey_setonix.config \
    --mode boltz,colabfold,esmfold,alphafold2 \
    -params-file setonix_params.yaml \
    -resume