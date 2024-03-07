#!/bin/bash
module load bioinfo-tools Nextflow 

module load qiime2/2018.11.0
source activate qiime2-2018.11
module load python3/3.12.1
python3 --version

# Download a fresh Nextflow file
rm -f metontiime2.nf
wget https://raw.githubusercontent.com/richelbilderbeek/MetONTIIME/master/metontiime2.nf

# Download a fresh config file
rm -f metontiime2.conf
wget https://raw.githubusercontent.com/MaestSi/MetONTIIME/master/metontiime2.conf

# Change the number of processors from 6 to 4
sed -i 's/ ? 6 : 1 }/ ? 4 : 1 }/' metontiime2.conf

# Change the memory use from 10 to 7 GB
sed -i 's/ 10.GB / 7.GB /' metontiime2.conf

# Change the executor from pbspro to local
sed -i "s/executor = 'pbspro'/executor = 'local'/" metontiime2.conf

# work_dir="${PWD}/work_local_singularity"
work_dir="/crex/proj/staff/richel/ticket_287014/work_local_singularity"
echo "work_dir: ${work_dir}"

# Get the sequences in the correct folder 
mkdir "${work_dir}"
# cp example_reads.fastq.gz "${work_dir}"
cp /crex/proj/naiss2023-22-866/MetONTIIME/trimmed_and_filtered_Q15_qz/seqkitQ15cutadaptlib1sup_bc01.fastq.gz "${work_dir}"

# results_dir="${PWD}/results_local_singularity"
results_dir="/crex/proj/staff/richel/ticket_287014/results_local_singularity"
echo "results_dir: ${results_dir}"

# db_sequence_fasta_filename="${PWD}/example_db_sequence.fasta"
db_sequence_fasta_filename="/crex/proj/naiss2023-22-866/MetONTIIME/sh_refs_qiime_ver9_dynamic_all_25.07.2023.fasta"
echo "db_sequence_fasta_filename: ${db_sequence_fasta_filename}"

sample_metadata_tsv_filename="${work_dir}/created_sample_metadata.tsv"
# From Simone Maestri:
# > the sample metadata file is optional, 
# > you don't need to create one, you can specify the path to an empty file, 
# > which will be created upon running
# sample_metadata_tsv_filename="${PWD}/example_sample_metadata.tsv"
echo "sample_metadata_tsv_filename: ${sample_metadata_tsv_filename}"

#taxonomy_tsv_filename="${PWD}/example_taxonomy.tsv"
taxonomy_tsv_filename="/crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv"
echo "taxonomy_tsv_filename: ${taxonomy_tsv_filename}"

config_filename="${PWD}/metontiime2.conf"

# Run locally
nextflow -c "${config_filename}" run metontiime2.nf \
  --workDir="${work_dir}" \
  --resultsDir="${results_dir}" \
  --dbSequencesFasta="${db_sequence_fasta_filename}" \
  --sampleMetadata="${sample_metadata_tsv_filename}" \
  --dbTaxonomyTsv="${taxonomy_tsv_filename}" \
  -profile singularity

