library(phyloseq)
library(ape)
library(tidyverse)
library(picante)

#Load in Data
load("dep_rare.RData")
load("dep_final.RData")

### calculate shannon diversity for hyp_dep ###
plot_richness(dep_rare, measures = c("Shannon"))

gg_shannon <- plot_richness(dep_rare, x = "dep_hyp", measures = c("Shannon")) +
  xlab("Condition") +
  geom_boxplot()
gg_shannon

ggsave(filename = "plot_shannon_condition.png"
       , gg_shannon
       , height=4, width=6)

### calculate shannon diversity for hyp_dep_sex ###
plot_richness(dep_rare, measures = c("Shannon"))

gg_shannon_sex <- plot_richness(dep_rare, x = "dep_hyp_sex", measures = c("Shannon")) +
  xlab("Condition and Sex") +
  geom_boxplot()
gg_shannon_sex

ggsave(filename = "plot_shannon_sex.png"
       , gg_shannon_sex
       , height=4, width=6)

### calculate shannon diversity for hyp_dep_age ###
plot_richness(dep_rare, measures = c("Shannon"))

gg_shannon_age <- plot_richness(dep_rare, x = "dep_hyp_age", measures = c("Shannon")) +
  xlab("Condition and Age") +
  geom_boxplot()
gg_shannon_age

ggsave(filename = "plot_shannon_age.png"
       , gg_shannon_age
       , height=4, width=6)

### calculate Faith's phylogenetic diversity as PD for hyp_dep ###
phylo_dist <- pd(t(otu_table(dep_rare)), phy_tree(dep_rare),
                 include.root=F) 

# add PD to metadata table
sample_data(dep_rare)$PD <- phylo_dist$PD

# plot any metadata category against the PD
plot.pd <- ggplot(sample_data(dep_rare), aes(dep_hyp, PD)) + 
  geom_boxplot() +
  xlab("Condition") +
  ylab("Phylogenetic Diversity")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
plot.pd

ggsave(filename = "plot_pd_condition.png"
       , plot.pd
       , height=4, width=6)

### calculate Faith's phylogenetic diversity as PD for hyp_dep_sex ###
# plot any metadata category against the PD
plot.pd_sex <- ggplot(sample_data(dep_rare), aes(dep_hyp_sex, PD)) + 
  geom_boxplot() +
  xlab("Condition and Sex") +
  ylab("Phylogenetic Diversity")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
plot.pd_sex

ggsave(filename = "plot_pd_sex.png"
       , plot.pd_sex
       , height=4, width=6)

### calculate Faith's phylogenetic diversity as PD for hyp_dep_age ###
# plot any metadata category against the PD
plot.pd_age<- ggplot(sample_data(dep_rare), aes(dep_hyp_age, PD)) + 
  geom_boxplot() +
  xlab("Condition and Age") +
  ylab("Phylogenetic Diversity")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
plot.pd_age

ggsave(filename = "plot_pd_age.png"
       , plot.pd_age
       , height=4, width=6)

### Taxa bar plots for dep_hyp ###
# Convert to relative abundance
dep_RA <- transform_sample_counts(dep_rare, function(x) x/sum(x))

# To remove black bars, "glom" by phylum first
dep_phylum <- tax_glom(dep_RA, taxrank = "Phylum", NArm=FALSE)

gg_taxa <- plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~dep_hyp, scales = "free_x")
gg_taxa

ggsave("plot_taxonomy_condition.png"
       , gg_taxa
       , height=8, width =12)

### Taxa bar plots for dep_hyp_sex ###
gg_taxa_sex <- plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~dep_hyp_sex, scales = "free_x")
gg_taxa_sex

ggsave("plot_taxonomy_sex.png"
       , gg_taxa_sex
       , height=8, width =12)

### Taxa bar plots for dep_hyp_age ###
gg_taxa_age <- plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~dep_hyp_age, scales = "free_x")
gg_taxa_age

ggsave("plot_taxonomy_age.png"
       , gg_taxa_age
       , height=8, width =12)