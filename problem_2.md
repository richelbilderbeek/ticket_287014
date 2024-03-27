# [Problem 2: out of memory](problem_2.md)

## Solution

On Rackham, do:

```
wget https://raw.githubusercontent.com/richelbilderbeek/ticket_287014/master/continue_run_rackham_ida.sh
sbatch continue_run_rackham_ida.sh
```

## Details

...
```
[richel@rackham4 ticket_ida]$ cat metontiime_18mar_2.out

[...]

executor >  local (7)
[22/881f0a] process > importDb (1)          [100%] 1 of 1 ✔
[c9/0d60d4] process > concatenateFastq      [100%] 1 of 1 ✔
[b6/5deb63] process > filterFastq           [100%] 1 of 1 ✔
[05/f4b52a] process > downsampleFastq       [100%] 1 of 1 ✔
[03/c5e6ea] process > importFastq           [100%] 1 of 1 ✔
[e8/d56d53] process > derepSeq              [  0%] 0 of 1
[-        ] process > assignTaxonomy        -
[-        ] process > filterTaxa            -
[-        ] process > taxonomyVisualization -
[-        ] process > collapseTables        -
[23/6793ee] process > dataQC                [100%] 1 of 1 ✔
[-        ] process > diversityAnalyses     -
ERROR ~ Error executing process > 'derepSeq'

Caused by:
  Process `derepSeq` terminated with an error exit status (1)

Command executed:

  mkdir -p /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq
  
  qiime vsearch dereplicate-sequences 		--i-sequences /crex/proj/naiss2023-22-866/MetONTIIME/Output/importFastq/sequences.qza 		--o-dereplicated-table /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table_tmp.qza 		--o-dereplicated-sequences /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs_tmp.qza
  
  qiime vsearch cluster-features-de-novo 		--i-sequences /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs_tmp.qza 		--i-table /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table_tmp.qza 		--p-perc-identity 0.97 		--o-clustered-table /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table.qza 		--o-clustered-sequences /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs.qza --p-threads 4
  
  rm /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table_tmp.qza /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs_tmp.qza
  
  qiime feature-table summarize 		--i-table /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table.qza 		--o-visualization /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table.qzv 		--m-sample-metadata-file /crex/proj/naiss2023-22-866/MetONTIIME/example_sample_metadata.tsv
  
  qiime feature-table tabulate-seqs 		--i-data /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs.qza 		--o-visualization /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs.qzv

Command exit status:
  1

Command output:
  Saved FeatureTable[Frequency] to: /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table_tmp.qza
  Saved FeatureData[Sequence] to: /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs_tmp.qza

Command error:
  INFO:    Environment variable SINGULARITYENV_TMPDIR is set, but APPTAINERENV_TMPDIR is preferred
  INFO:    Environment variable SINGULARITYENV_NXF_TASK_WORKDIR is set, but APPTAINERENV_NXF_TASK_WORKDIR is preferred
  Saved FeatureTable[Frequency] to: /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/table_tmp.qza
  Saved FeatureData[Sequence] to: /crex/proj/naiss2023-22-866/MetONTIIME/Output/derepSeq/rep-seqs_tmp.qza
  Plugin error from vsearch:
  
    Command '['vsearch', '--cluster_size', '/scratch/45791123/tmpdshj596n', '--id', '0.97', '--centroids', '/scratch/45791123/q2-DNAFASTAFormat-f7_dz6ic', '--uc', '/scratch/45791123/tmp51augys8', '--qmask', 'none', '--xsize', '--threads', '4', '--minseqlength', '1', '--fasta_width', '0']' died with <Signals.SIGKILL: 9>.
  
  Debug info has been saved to /scratch/45791123/qiime2-q2cli-err-wbdnvoaw.log

Work dir:
  /crex/proj/naiss2023-22-866/MetONTIIME/work/e8/d56d53011680ffda3716df06d9e74c

Tip: view the complete command output by changing to the process work dir and entering the command `cat .command.out`

 -- Check '.nextflow.log' file for details

```

The text `died with <Signals.SIGKILL: 9>.` is the hint.


```
[richel@rackham4 ticket_ida]$ cat metontiime_18mar_2.err

[...]

slurmstepd: error: Detected 1 oom_kill event in StepId=45791123.batch. Some of the step tasks have been OOM Killed.
```

Here `have been OOM Killed` indicates it is a memory problem.

