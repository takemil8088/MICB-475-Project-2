library(phyloseq)
library(ape)
library(tidyverse)
library(picante)

#Load in Data
load("dep_rare.RData")
load("dep_final.RData")

#calculate shannon diversity
plot_richness(dep_rare, measures = c("Shannon"))

gg_richness <- plot_richness(dep_rare, x = "subject", measures = c("Shannon","Chao1")) +
  xlab("Subject ID") +
  geom_boxplot()
gg_richness
