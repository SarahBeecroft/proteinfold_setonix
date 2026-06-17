#!/bin/bash -l 
#SBATCH --job-name=proteinfold
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8GB
#SBATCH --account=pawsey0012

module load singularity/3.11.4-nompi 

# This workflow seems to only work with Nextflow version 25.10.4, which I installed in my base conda env. 
# If you choose to also install with conda, you'll need to update the example path below with your conda info
source  /software/projects/pawsey0001/sbeecroft/miniforge3/bin/activate base

export NXF_SINGULARITY_CACHEDIR=$MYSCRATCH/nf_singularity_cache

#Check if FCP is installed. If not, install it. This only needs to be done once. 
if ! command -v fcp >/dev/null 2>&1; then
    echo "fcp not found on PATH" >&2
    module load rust/1.85.0
    cargo install fcp
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi 

nextflow run main.nf \
    --input samplesheet.csv \
    --outdir outdir \
    -config conf/pawsey_setonix.conf \
    -config conf/amd_containers.conf \
    --mode boltz,colabfold,esmfold,alphafold2 \
    -params-file params.yaml \
    -resume
