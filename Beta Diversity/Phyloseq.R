library(tidyverse)
library(dplyr)
library(phyloseq)
library(ape)
library(vegan)

#read in files
otu <- read_delim(file = "feature-table.txt", delim="\t", skip=1)
tax = read_delim(file = "taxonomy.tsv", delim="\t")
meta = read_delim(file = "metadata_final_amb.tsv", delim="\t")
phylotree = read.tree("tree.nwk")

#### Format OTU table ####
otu_mat <- as.matrix(otu[,-1])
rownames(otu_mat) <- otu$`#OTU ID`
OTU <- otu_table(otu_mat, taxa_are_rows = TRUE) 
class(OTU)

#### Format sample metadata ####
samp_df <- as.data.frame(meta[,-1])
rownames(samp_df)<- meta$'sample-id'
SAMP <- sample_data(samp_df)
class(SAMP)

#### Formatting taxonomy ####
tax_mat <- tax %>% select(-Confidence)%>%
  separate(col=Taxon, sep="; "
           , into = c("Domain","Phylum","Class","Order","Family","Genus","Species")) %>%
  as.matrix() 
tax_mat <- tax_mat[,-1]
rownames(tax_mat) <- tax$`Feature ID`
TAX <- tax_table(tax_mat)
class(TAX)

#### Create phyloseq object ####
# Merge all into a phyloseq object
dep_phyloseq <- phyloseq(OTU, SAMP, TAX, phylotree)

######### ANALYZE ##########
# Remove non-bacterial sequences, if any
dep_filt <- subset_taxa(dep_phyloseq,  Domain == "d__Bacteria" & Class!="c__Chloroplast" & Family !="f__Mitochondria")
# Remove ASVs that have less than 5 counts total
dep_filt_nolow <- filter_taxa(dep_filt, function(x) sum(x)>5, prune = TRUE)
# Remove samples with less than 100 reads
dep_final <- prune_samples(sample_sums(dep_filt_nolow)>100, dep_filt_nolow)

# Rarefy samples
rarecurve(t(as.data.frame(otu_table(dep_final))), cex=0.1)
dep_rare <- rarefy_even_depth(dep_final, rngseed = 1, sample.size = 20000)

##### Saving #####
save(dep_final, file="dep_final.RData")
save(dep_rare, file="dep_rare.RData")
