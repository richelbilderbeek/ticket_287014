#!/bin/bash


# On GitHub Actiobs
export JAVA_HOME=/opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/17.0.10-7/x64

# export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64


# Don's use older version than CI script
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Don't user newer than Java 18:
# ERROR: Cannot find Java or it's a wrong version -- please make sure that Java 8 or later (up to 18) is installed
# export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# Original
# nextflow -c metontiime_9feb.conf run metontiime2_9feb.nf

cp metontiime_9feb.conf my.conf

sed -i "s,/crex/proj/naiss2023-22-866/,${PWD}/,g" my.conf

# Suitable for local
nextflow -c my.conf run metontiime2_9feb.nf -profile singularity

#  --workDir trimmed_and_filtered_Q15_qz \
#  --dbSequencesFasta sh_refs_qiime_ver9_dynamic_all_25.07.2023.fasta \
#  --dbTaxonomyTsv="noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv"
#  --resultsDir=Output
