#!/bin/bash -l
#SBATCH -J metontiime_9feb
#SBATCH -A naiss2023-22-866
#SBATCH -t 00:15:00
#SBATCH -p core
#SBATCH -n 1
#SBATCH --qos=short
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ida.nordstrom@slu.se
#SBATCH --error=metontiime_9feb.err
#SBATCH --output=metontiime_9feb.out

cd /crex/proj/naiss2023-22-866/MetONTIIME

module load uppmax bioinfo-tools Nextflow 
module load qiime2/2018.11.0
source activate qiime2-2018.11
source tab-qiime
nextflow -c metontiime_9feb.conf run metontiime2_9feb.nf -profile uppmax,singularity --project naiss2023-22-866 
