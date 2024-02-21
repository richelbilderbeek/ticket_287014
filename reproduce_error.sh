#!/bin/bash


export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Don's use older version than CI script
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Don't user newer than Java 18:
# ERROR: Cannot find Java or it's a wrong version -- please make sure that Java 8 or later (up to 18) is installed
# export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

nextflow -c metontiime_9feb.conf run metontiime2_9feb.nf
