library(tidyverse)
library(dplyr)
library(phyloseq)
library(ape)
library(picante)

load("dep_final.RData")
load("dep_rare.RData")
load("metadata.RData")

#### Beta diversity #####
bc_dm <- distance(dep_rare, method="bray")
pcoa_bc <- ordinate(dep_rare, method="PCoA", distance=bc_dm)
plot_ordination(dep_rare, pcoa_bc, color = "body.site", shape="subject")

#plot 
gg_pcoa <- plot_ordination(dep_rare, pcoa_bc, color = "hypertension", shape="dep_cat") +
  labs(pch="Depression", col = "Hypertention")
gg_pcoa

#save
ggsave("plot_pcoa.png"
       , gg_pcoa
       , height=4, width=5)



#graph with elipses
gg_pcoa_split <- plot_ordination(dep_rare, pcoa_bc, color = "dep_hyp") +
  labs(pch="Sex", col = "Hypertention and Depression")+
  stat_ellipse(geom="polygon", level=0.95, aes(fill=after_scale(alpha(colour, 0.1))))
gg_pcoa_split

#, shape="sex"
#type= "euclid",


#stats for diversity








#### Taxonomy bar plots ####
# Plot bar plot of taxonomy
plot_bar(dep_rare, fill="Phylum") 

# Convert to relative abundance
dep_RA <- transform_sample_counts(dep_rare, function(x) x/sum(x))

# To remove black bars, "glom" by phylum first
dep_phylum <- tax_glom(dep_RA, taxrank = "Phylum", NArm=FALSE)

#graph separating for depression
gg_taxa_dep = plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~dep_cat, scales = "free_x")

#graph separating for hypertension
gg_taxa_hyp = plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~hypertension, scales = "free_x")

ggsave("plot_taxonomy_dep.png"
       , gg_taxa_dep
       , height=8, width =17)

ggsave("plot_taxonomy_hyp.png"
       , gg_taxa_hyp
       , height=8, width =17)