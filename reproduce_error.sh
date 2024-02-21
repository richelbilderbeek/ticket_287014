#!/bin/bash

# export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
nextflow -c metontiime_9feb.conf run metontiime2_9feb.nf
