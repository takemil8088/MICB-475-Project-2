library(tidyverse)
library(dplyr)
library(phyloseq)
library(ape)
library(picante)
library(vegan)

load("dep_final.RData")
load("dep_rare.RData")
load("metadata.RData")

#split by age
dep_rare_old = subset_samples(dep_rare, age_cat== "60 and older")


#### Beta diversity #####
bc_dm <- distance(dep_rare, method="bray")
pcoa_bc <- ordinate(dep_rare, method="PCoA", distance=bc_dm)

bc_dm_old <- distance(dep_rare_old, method="bray")
pcoa_bc_old <- ordinate(dep_rare_old, method="PCoA", distance=bc_dm_old)

#plot - elipses for 95% confidence interval
gg_pcoa_old <- plot_ordination(dep_rare_old, pcoa_bc_old, color = "dep_hyp") +
  labs(pch="Sex", col = "Hypertention Depression")+
  stat_ellipse(geom="polygon", level=0.95, aes(fill=after_scale(alpha(colour, 0.1))))
gg_pcoa_old

# run the permanova on the above matrix for bc
?adonis2
samp_dat_wdiv <- data.frame(sample_data(dep_rare), estimate_richness(dep_rare))%>%
  filter(age_cat== "60 and older")
adonis2(bc_dm_old ~ `hypertension`*dep_cat, data=samp_dat_wdiv)

# re-plot the above PCoA with ellipses to show a significant difference 
# between body sites using ggplot2
gg_pcoa_old_stat = plot_ordination(dep_rare_old, bc_dm_old, color = "dep_hyp") +
  labs(col = "hyp and dep")+
  stat_ellipse(geom="polygon", type = "norm", aes(fill=after_scale(alpha(colour, 0.1))))
gg_pcoa_old_stat

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








