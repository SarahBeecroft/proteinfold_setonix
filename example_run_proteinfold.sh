#!/bin/bash -l 
#SBATCH --job-name=proteinfold
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8GB

module load singularity/3.11.4-nompi 
source  /software/projects/pawsey0001/sbeecroft/miniforge3/bin/activate base

export NXF_SINGULARITY_CACHEDIR=$MYSCRATCH/nf_singularity_cache

nextflow run main.nf \
    --input samplesheet.csv \
    --outdir outdir \
    -config conf/pawsey_setonix.conf \
    -config conf/amd_containers.conf \
    --mode alphafold2 \
    -resume
