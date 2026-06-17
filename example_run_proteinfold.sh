#!/bin/bash -l 
#SBATCH --job-name=proteinfold
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8GB
#SBATCH --account=pawsey0012


############################################################################################################################################################
# Check if FCP is installed. If not, install it. This only needs to be done once.
# Once FCP is installed for you, you can delete this block.
# FCP enables super-fast copy of key reference files to /tmp for colabfold_search. Reading those files from /tmp instead of /scratch provides a 10x speedup. 
if ! command -v fcp >/dev/null 2>&1; then
    echo "fcp not found on PATH" >&2
    module load rust/1.85.0
    cargo install fcp
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi 
############################################################################################################################################################


# Load singularity module.
module load singularity/3.11.4-nompi 

# This workflow seems to only work with Nextflow version 25.10.4, which I installed in my conda base environment. 
# If you choose to install into a different conda environment, you'll need to replace `base` with your environment name
conda_activate="${CONDA_EXE%conda}activate"
source $conda_activate base

# Run the workflow
nextflow run main.nf \
    --input samplesheet.csv \
    --outdir $MYSCRATCH/proteinfold/outdir \
    -config conf/pawsey_setonix.conf \
    -config conf/amd_containers.conf \
    --mode boltz,colabfold,esmfold,alphafold2 \
    -params-file params.yaml \
    -resume
