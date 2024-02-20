#!/bin/bash -l
#SBATCH -J metontiime_9feb_with_cd
#SBATCH -A naiss2023-22-866
#SBATCH -t 00:15:00
#SBATCH -p core
#SBATCH -n 1
#SBATCH --qos=short
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ida.nordstrom@slu.se
#SBATCH --error=metontiime_9feb_with_cd.err
#SBATCH --output=metontiime_9feb_with_cd.out

cd /crex/proj/naiss2023-22-866/MetONTIIME

module load uppmax bioinfo-tools Nextflow
nextflow -c metontiime_9feb_2.conf run metontiime2_9feb_wpath.nf -profile uppmax,singularity --project naiss2023-22-866 
