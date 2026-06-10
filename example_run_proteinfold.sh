#!/bin/bash -l 
#SBATCH --job-name=proteinfold
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8GB
#SBATCH --account=pawsey0012

module load singularity/3.11.4-nompi 
source  /software/projects/pawsey0001/sbeecroft/miniforge3/bin/activate base

export NXF_SINGULARITY_CACHEDIR=$MYSCRATCH/nf_singularity_cache

nextflow run main.nf \
    --input samplesheet.csv \
    --outdir outdir \
    -config conf/pawsey_setonix.conf \
    -config conf/amd_containers.conf \
    --mode boltz,colabfold,esmfold,alphafold2 \
    -params-file params.yaml \
    -resume
