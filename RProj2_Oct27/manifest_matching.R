#for altering manefest file for depression dataset

#library(BiocManager)
#library(phyloseq)
library(dplyr)
library(tidyverse)
library(tibble) 
library(readr)

#load previous metadata
load("metadata_final.RData")

#load manifest file for depression dataset
dep_manifest <- read.delim("depression_manifest.tsv", sep = "\t")

#keep sample IDs in manifest (sample.id) that matches sample IDs in metadata (sample_id)
joined_manifest <- inner_join(dep_manifest, meta_final, by = join_by(sample.id == sample_id)) %>%
  #keep only the sample.id and absolute.filepath columns
  select(sample.id, absolute.filepath)

#save the new manifest file as RData if alterations are needed ...
save(joined_manifest, file = "joined_manifest.RData")

#... and as a tsv for qiime
write.table(joined_manifest, file="depression_joined_manifest.tsv", sep="\t", quote=FALSE, row.names = FALSE)
