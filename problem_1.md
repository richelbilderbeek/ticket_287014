# [Problem 1: getting it to start](problem_1.md)


This solution will get the run going,
until it runs out of memory.
See [Problem 2: out of memory](problem_2.md) for that

## How to use

On Rackham, do:

```
wget https://raw.githubusercontent.com/richelbilderbeek/ticket_287014/master/run_rackham_ida.sh
sbatch run_rackham_ida.sh
```

## What does it do?

It modifies [the original 'metontiime2.conf' file](https://raw.githubusercontent.com/MaestSi/MetONTIIME/master/metontiime2.conf)
to suit the needs of the user, in a way that is tested to work.

Changes it makes:

- Change the number of processors from 6 to 4
- Change the memory use from 10 to 7 GB
- Change the executor from pbspro to local


# Appendix

## Problem

The version of Python is changed, not by me, to something that is too old.

In a script [run_rackham.sh](run_rackham.sh),
I load some modules, activate an environment and load Python 3.12.1.
Note the Python version.

```
module load bioinfo-tools Nextflow 

module load qiime2/2018.11.0
source activate qiime2-2018.11
module load python/3.12.1
```

When I run that script, however, an error indicates Python 3.8 is active.
I never wanted that! 
How can that happen?

The full error text is below, here is the error line:

```
  /home/richel/.local/lib/python3.8/site-packages/pandas/_testing.py:24: FutureWarning: In the future `np.bool` will be defined as the corresponding NumPy scalar.
```

See subsection [How to reproduce](#how-to-reproduce) to reproduce this error
and subsection [Full error message](#full-error-message) 
for the full error message.

## How to reproduce

On an interactive node, do:

```
cd /crex/proj/staff/richel/ticket_287014
./run_rackham.sh
```

## Solution 

For us:

- No loading of Python module
- No loading of QIIME module
- Remove the `.local` folder

How a developer could have prevented this:

- Supply a Singularity container that never looks outside of itself

## Notes to arrive at solution

Don't load the Python module. 
After this, it still shows Python 3.8.
This may be caused by the Singularity image
that tries to mount a folder.


Does QIIME need to be loaded when doing all the others?
You can easily remove the QIIME import, it is in the containers.
Tested and is correct!

`which python`? Added!

Seems that within container, stuff from the home folder is used
and it is assumed that numpi is installed.

Numpi *is* found when running the container directly:

```
[richel@s141 singularity]$ singularity shell maestsi-metontiime-latest.img
Apptainer> which python
/opt/conda/envs/MetONTIIME_env/bin/python
Apptainer> which python3
/opt/conda/envs/MetONTIIME_env/bin/python3
Apptainer> python
Python 3.8.15 | packaged by conda-forge | (default, Nov 22 2022, 08:46:39) 
[GCC 10.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy
```

Theory is that the local environment is causing the trouble.
Delete it! Yes, Doug made me do this :-)

```
rm -rf /home/richel/.local/
```

Then:

```
[richel@s141 singularity]$ singularity shell maestsi-metontiime-latest.img
Apptainer> python
Python 3.8.15 | packaged by conda-forge | (default, Nov 22 2022, 08:46:39) 
[GCC 10.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy
>>> import pandas
>>> pandas.__file__
'/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/pandas/__init__.py'
```

Best practices:

- Never have a `.local` folder
- Regularly delete `.cache` and `.local`

How this would have been prevented:

- Tool developers:
  - --> the container should not look outside itself
  - never use `python scriptname.py` instead use `#!/bin/env python`
- Always use a venv
- Consider using a base venv/conda environment

## Full error message

Cleaning before:

```
cd /crex/proj/staff/richel/ticket_287014
[richel@s63 ticket_287014]$ rm -rf work/
[richel@s63 ticket_287014]$ cd ../ticket_287014_output/
[richel@s63 ticket_287014_output]$ rm -rf results_local_singularity/
[richel@s63 ticket_287014_output]$ rm -rf work_local_singularity/
```

```
[richel@s63 ticket_287014]$ ./run_rackham.sh 

Note that NXF_HOME is set to $HOME/.nextflow
Please change NXF_HOME to a place in your project directory (export NXF_HOME=yourprojectfolder)

Please use   export NXF_VER=nextflow_version    to select different version
https://www.nextflow.io/docs/latest/config.html#environment-variables

Run this to activate the qiime environment:

source activate qiime2-2018.11

Note that this module sets your locale to en_US.utf-8
python version: 
Python 3.12.1
python3 version: 
Python 3.12.1
--2024-03-07 11:38:16--  https://raw.githubusercontent.com/richelbilderbeek/MetONTIIME/master/metontiime2.nf
Resolving raw.githubusercontent.com... 185.199.108.133, 185.199.111.133, 185.199.110.133, ...
Connecting to raw.githubusercontent.com|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 27447 (27K) [text/plain]
Saving to: ‘metontiime2.nf’

metontiime2.nf         100%[===========================>]  26.80K  --.-KB/s    in 0.004s  

2024-03-07 11:38:16 (6.66 MB/s) - ‘metontiime2.nf’ saved [27447/27447]

--2024-03-07 11:38:16--  https://raw.githubusercontent.com/MaestSi/MetONTIIME/master/metontiime2.conf
Resolving raw.githubusercontent.com... 185.199.109.133, 185.199.110.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 10114 (9.9K) [text/plain]
Saving to: ‘metontiime2.conf’

metontiime2.conf       100%[===========================>]   9.88K  --.-KB/s    in 0.003s  

2024-03-07 11:38:16 (3.46 MB/s) - ‘metontiime2.conf’ saved [10114/10114]

work_dir: /crex/proj/staff/richel/ticket_287014_output/work_local_singularity
results_dir: /crex/proj/staff/richel/ticket_287014_output/results_local_singularity
db_sequence_fasta_filename: /crex/proj/naiss2023-22-866/MetONTIIME/sh_refs_qiime_ver9_dynamic_all_25.07.2023.fasta
sample_metadata_tsv_filename: /crex/proj/staff/richel/ticket_287014_output/work_local_singularity/created_sample_metadata.tsv
taxonomy_tsv_filename: /crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv
N E X T F L O W  ~  version 23.10.1
Launching `metontiime2.nf` [backstabbing_gauss] DSL2 - revision: ce81e587ac
[-        ] process > importDb              -
[-        ] process > concatenateFastq      -
[-        ] process > filterFastq           -
[-        ] process > importDb              [  0%] 0 of 1
[-        ] process > concatenateFastq      [  0%] 0 of 1
[-        ] process > filterFastq           -
executor >  local (2)
[61/5cf523] process > importDb (1)          [  0%] 0 of 1
[32/18a795] process > concatenateFastq      [  0%] 0 of 1
executor >  local (2)
[61/5cf523] process > importDb (1)          [  0%] 0 of 1
[32/18a795] process > concatenateFastq      [100%] 1 of 1 ✔
executor >  local (3)
[61/5cf523] process > importDb (1)          [  0%] 0 of 1
[32/18a795] process > concatenateFastq      [100%] 1 of 1 ✔
executor >  local (3)
[61/5cf523] process > importDb (1)          [  0%] 0 of 1
[32/18a795] process > concatenateFastq      [100%] 1 of 1 ✔
[6b/d3b1fc] process > filterFastq           [  0%] 0 of 1
[-        ] process > downsampleFastq       -
[-        ] process > importFastq           -
[-        ] process > derepSeq              -
[-        ] process > assignTaxonomy        -
[-        ] process > filterTaxa            -
[-        ] process > taxonomyVisualization -
[-        ] process > collapseTables        -
[-        ] process > dataQC                -
[-        ] process > diversityAnalyses     -
Pulling Singularity image docker://maestsi/metontiime:latest [cache /crex/proj/staff/richel/ticket_287014/work/singularity/maestsi-metontiime-latest.img]
WARN: Singularity cache directory has not been defined -- Remote image will be stored in the path: /crex/proj/staff/richel/ticket_287014/work/singularity -- Use the environment variable NXF_SINGULARITY_CACHEDIR to specify a different location
ERROR ~ Error executing process > 'importDb (1)'

Caused by:
  Process `importDb (1)` terminated with an error exit status (1)

Command executed:

  mkdir -p /crex/proj/staff/richel/ticket_287014_output/results_local_singularity/importDb
  
  qiime tools import 		--type 'FeatureData[Sequence]' 		--input-path sh_refs_qiime_ver9_dynamic_all_25.07.2023.fasta 		--output-path /crex/proj/staff/richel/ticket_287014_output/results_local_singularity/importDb/db_sequences.qza
  
  qiime tools import 		--type 'FeatureData[Taxonomy]' 		--input-path noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv 		--input-format HeaderlessTSVTaxonomyFormat 		--output-path /crex/proj/staff/richel/ticket_287014_output/results_local_singularity/importDb/db_taxonomy.qza

Command exit status:
  1

Command output:
  (empty)

Command error:
  /home/richel/.local/lib/python3.8/site-packages/pandas/_testing.py:24: FutureWarning: In the future `np.bool` will be defined as the corresponding NumPy scalar.
    import pandas._libs.testing as _testing
  Traceback (most recent call last):
    File "/opt/conda/envs/MetONTIIME_env/bin/qiime", line 11, in <module>
      sys.exit(qiime())
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1157, in __call__
      return self.main(*args, **kwargs)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1078, in main
      rv = self.invoke(ctx)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1688, in invoke
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1688, in invoke
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1434, in invoke
      return ctx.invoke(self.callback, **ctx.params)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 783, in invoke
      return __callback(*args, **kwargs)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/q2cli/builtin/tools.py", line 263, in import_data
      import qiime2.sdk
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/__init__.py", line 9, in <module>
      from qiime2.sdk import Artifact, Visualization, ResultCollection
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/sdk/__init__.py", line 9, in <module>
      from .context import Context
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/sdk/context.py", line 9, in <module>
      from qiime2.core.type.util import is_collection_type
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/__init__.py", line 10, in <module>
      from .semantic import SemanticType, Properties
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/semantic.py", line 15, in <module>
      from qiime2.core.type.util import is_semantic_type, is_qiime_type
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/util.py", line 13, in <module>
      from qiime2.core.type.primitive import Int, Float, Bool, Str
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/primitive.py", line 13, in <module>
      import qiime2.metadata as metadata
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/metadata/__init__.py", line 9, in <module>
      from .metadata import (Metadata, MetadataColumn, NumericMetadataColumn,
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/metadata/metadata.py", line 16, in <module>
      import pandas as pd
    File "/home/richel/.local/lib/python3.8/site-packages/pandas/__init__.py", line 180, in <module>
      import pandas.testing
    File "/home/richel/.local/lib/python3.8/site-packages/pandas/testing.py", line 5, in <module>
      from pandas._testing import (
    File "/home/richel/.local/lib/python3.8/site-packages/pandas/_testing.py", line 24, in executor >  local (3)
[61/5cf523] process > importDb (1)          [100%] 1 of 1, failed: 1 ✘
[32/18a795] process > concatenateFastq      [100%] 1 of 1 ✔
[-        ] process > filterFastq           -
[-        ] process > downsampleFastq       -
[-        ] process > importFastq           -
[-        ] process > derepSeq              -
[-        ] process > assignTaxonomy        -
[-        ] process > filterTaxa            -
[-        ] process > taxonomyVisualization -
[-        ] process > collapseTables        -
[-        ] process > dataQC                -
[-        ] process > diversityAnalyses     -
Pulling Singularity image docker://maestsi/metontiime:latest [cache /crex/proj/staff/richel/ticket_287014/work/singularity/maestsi-metontiime-latest.img]
WARN: Singularity cache directory has not been defined -- Remote image will be stored in the path: /crex/proj/staff/richel/ticket_287014/work/singularity -- Use the environment variable NXF_SINGULARITY_CACHEDIR to specify a different location
ERROR ~ Error executing process > 'importDb (1)'

Caused by:
  Process `importDb (1)` terminated with an error exit status (1)

Command executed:

  mkdir -p /crex/proj/staff/richel/ticket_287014_output/results_local_singularity/importDb
  
  qiime tools import 		--type 'FeatureData[Sequence]' 		--input-path sh_refs_qiime_ver9_dynamic_all_25.07.2023.fasta 		--output-path /crex/proj/staff/richel/ticket_287014_output/results_local_singularity/importDb/db_sequences.qza
  
  qiime tools import 		--type 'FeatureData[Taxonomy]' 		--input-path noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv 		--input-format HeaderlessTSVTaxonomyFormat 		--output-path /crex/proj/staff/richel/ticket_287014_output/results_local_singularity/importDb/db_taxonomy.qza

Command exit status:
  1

Command output:
  (empty)

Command error:
  /home/richel/.local/lib/python3.8/site-packages/pandas/_testing.py:24: FutureWarning: In the future `np.bool` will be defined as the corresponding NumPy scalar.
    import pandas._libs.testing as _testing
  Traceback (most recent call last):
    File "/opt/conda/envs/MetONTIIME_env/bin/qiime", line 11, in <module>
      sys.exit(qiime())
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1157, in __call__
      return self.main(*args, **kwargs)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1078, in main
      rv = self.invoke(ctx)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1688, in invoke
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1688, in invoke
      return _process_result(sub_ctx.command.invoke(sub_ctx))
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 1434, in invoke
      return ctx.invoke(self.callback, **ctx.params)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/click/core.py", line 783, in invoke
      return __callback(*args, **kwargs)
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/q2cli/builtin/tools.py", line 263, in import_data
      import qiime2.sdk
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/__init__.py", line 9, in <module>
      from qiime2.sdk import Artifact, Visualization, ResultCollection
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/sdk/__init__.py", line 9, in <module>
      from .context import Context
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/sdk/context.py", line 9, in <module>
      from qiime2.core.type.util import is_collection_type
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/__init__.py", line 10, in <module>
      from .semantic import SemanticType, Properties
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/semantic.py", line 15, in <module>
      from qiime2.core.type.util import is_semantic_type, is_qiime_type
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/util.py", line 13, in <module>
      from qiime2.core.type.primitive import Int, Float, Bool, Str
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/core/type/primitive.py", line 13, in <module>
      import qiime2.metadata as metadata
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/metadata/__init__.py", line 9, in <module>
      from .metadata import (Metadata, MetadataColumn, NumericMetadataColumn,
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/qiime2/metadata/metadata.py", line 16, in <module>
      import pandas as pd
    File "/home/richel/.local/lib/python3.8/site-packages/pandas/__init__.py", line 180, in <module>
      import pandas.testing
    File "/home/richel/.local/lib/python3.8/site-packages/pandas/testing.py", line 5, in <module>
      from pandas._testing import (
    File "/home/richel/.local/lib/python3.8/site-packages/pandas/_testing.py", line 24, in <module>
      import pandas._libs.testing as _testing
    File "pandas/_libs/testing.pyx", line 10, in init pandas._libs.testing
    File "/opt/conda/envs/MetONTIIME_env/lib/python3.8/site-packages/numpy/__init__.py", line 305, in __getattr__
      raise AttributeError(__former_attrs__[attr])
  AttributeError: module 'numpy' has no attribute 'bool'.
  `np.bool` was a deprecated alias for the builtin `bool`. To avoid this error in existing code, use `bool` by itself. Doing this will not modify any behavior and is safe. If you specifically wanted the numpy scalar type, use `np.bool_` here.
  The aliases was originally deprecated in NumPy 1.20; for more details and guidance see the original release note at:
      https://numpy.org/devdocs/release/1.20.0-notes.html#deprecations

Work dir:
  /crex/proj/staff/richel/ticket_287014/work/61/5cf523d2968da3ec8e7f539d34c23f

Tip: you can replicate the issue by changing to the process work dir and entering the command `bash .command.run`

 -- Check '.nextflow.log' file for details
```



# Other notes

The [nextflow_7march.log](nextflow_7march.log) gives this error:

```
  qiime tools import 		--type 'FeatureData[Taxonomy]' 		--input-path noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv 		--input-format HeaderlessTSVTaxonomyFormat 		--output-path /crex/proj/naiss2023-22-866/MetONTIIME/Output/importDb/db_taxonomy.qza
```

This points towards `/crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv` being invalid.

Run, on an interactive node:

```
module load uppmax bioinfo-tools Nextflow 
module load qiime2/2018.11.0
source activate qiime2-2018.11

# Note the tabs in this Nextflow line!
# qiime tools import 		--type 'FeatureData[Taxonomy]' 		--input-path /crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv 		--input-format HeaderlessTSVTaxonomyFormat 		--output-path /crex/proj/staff/richel/dump.qza
qiime tools import --type 'FeatureData[Taxonomy]' --input-path /crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv --input-format HeaderlessTSVTaxonomyFormat --output-path /crex/proj/staff/richel/dump.qza
```

Hmmm, this works:

```
(qiime2-2018.11) [richel@s141 ~]$ qiime tools import --type 'FeatureData[Taxonomy]' --input-path /crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv --input-format HeaderlessTSVTaxonomyFormat --output-path /crex/proj/staff/richel/dump.qza
Imported /crex/proj/naiss2023-22-866/MetONTIIME/noheader_taxonomy_qiime_ver9_dynamic_alleukaryotes_25.07.2023.tsv as HeaderlessTSVTaxonomyFormat to /crex/proj/staff/richel/dump.qza
```
