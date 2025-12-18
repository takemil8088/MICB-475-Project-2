# Load tidyverse
library(tidyverse)

# Read in the original manifest
manifestdat <- read.delim(file = "depression_manifest.tsv", sep="\t")

# Read in the new metadata
load("~/MICB475_Project2/metadata_final.RData")

# Left join
manifest_joined <- left_join(meta_final, manifestdat, by = c("sample_id" = "sample.id"))

# Filter for only relevant columns
manifest_final <- select(manifest_joined, "sample_id", "absolute.filepath")

# Save it as a csv
write.csv(manifest_final, file="new_manifest.csv")

