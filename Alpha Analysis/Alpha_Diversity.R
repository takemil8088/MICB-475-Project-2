library(phyloseq)
library(ape)
library(tidyverse)
library(picante)
library(dunn.test)

#Load in Data
load("dep_rare.RData")
load("dep_final.RData")

#Set Graph colors for different study groups
my_colors <- c(
  "Both" = "#F4A7A3",          # pink/red
  "Depressed Only" = "#7FAE2B",# green
  "Hypertensive Only" = "#39B6C8", # teal
  "Control" = "#C38BFF"        # purple
)

### calculate and graph shannon diversity for hyp_dep ###
plot_richness(dep_rare, measures = c("Shannon"))

gg_shannon <- plot_richness(dep_rare, x = "dep_hyp", measures = c("Shannon")) +
  xlab("Disease State") +
  ylab("Shannon Diversity") + 
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control")) +
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot()
gg_shannon

#Save graph
ggsave(filename = "plot_shannon_condition.png"
       , gg_shannon
       , height=5, width=6)

### calculate and graph shannon diversity for hyp_dep_sex ###
gg_shannon_sex <- plot_richness(dep_rare, x = "dep_hyp", measures = c("Shannon")) +
  xlab("Disease State") +
  ylab("Shannon Diversity") + 
  facet_wrap(.~sex, scales= "free_x", strip.position="bottom") +
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control"))+
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot(aes(fill = dep_hyp))+
  scale_fill_manual(values = c(
    "depressed_hypertension" = "#F4A7A3",
    "depressed_no_hypertension" = "#7FAE2B",
    "not depressed_hypertension" = "#39B6C8",
    "not depressed_no_hypertension" = "#C38BFF"))+
  scale_fill_discrete(guide = "none")
gg_shannon_sex

#Save graph
ggsave(filename = "plot_shannon_sex.png"
       , gg_shannon_sex
       , height=5, width=6)

### calculate and graph shannon diversity for hyp_dep_age ###
gg_shannon_age <- plot_richness(dep_rare, x = "dep_hyp", measures = c("Shannon")) +
  xlab("Disease State") +
  ylab("Shannon Diversity") + 
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control")) +
  facet_wrap(.~age_cat, scales= "free_x", strip.position="bottom") +
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot(aes(fill = dep_hyp))+
  scale_fill_manual(values = c(
    "depressed_hypertension" = "#F4A7A3",
    "depressed_no_hypertension" = "#7FAE2B",
    "not depressed_hypertension" = "#39B6C8",
    "not depressed_no_hypertension" = "#C38BFF"))+
  scale_fill_discrete(guide = "none")
gg_shannon_age

#Save graph
ggsave(filename = "plot_shannon_age.png"
       , gg_shannon_age
       , height=5, width=6)

### calculate and graph observed features for dep_hyp_age ###
gg_observedf_age <- plot_richness(dep_rare, x = "dep_hyp", measures = c("Observed")) +
  xlab("Disease State") +
  ylab("Observed Features") + 
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control")) +
  facet_wrap(.~age_cat, scales= "free_x", strip.position="bottom") +
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot(aes(fill = dep_hyp))+
  scale_fill_manual(values = c(
    "depressed_hypertension" = "#F4A7A3",
    "depressed_no_hypertension" = "#7FAE2B",
    "not depressed_hypertension" = "#39B6C8",
    "not depressed_no_hypertension" = "#C38BFF"))+
  scale_fill_discrete(guide = "none")
gg_observedf_age 

#Save graph
ggsave("plot_observedf_age.png"
       , gg_observedf_age 
       , height=5, width =6)

### calculate and graph observed features for dep_hyp_sex ###
gg_observedf_sex <- plot_richness(dep_rare, x = "dep_hyp", measures = c("Observed")) +
  geom_boxplot()+
  facet_wrap(.~sex, scales= "free_x", strip.position="bottom")+
  xlab("Disease State") +
  ylab("Observed Features") + 
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control")) +
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot(aes(fill = dep_hyp))+
  scale_fill_manual(values = c(
    "depressed_hypertension" = "#F4A7A3",
    "depressed_no_hypertension" = "#7FAE2B",
    "not depressed_hypertension" = "#39B6C8",
    "not depressed_no_hypertension" = "#C38BFF"))+
  scale_fill_discrete(guide = "none")
gg_observedf_sex 


### calculate and graph Faith's phylogenetic diversity as PD for hyp_dep ###
phylo_dist <- pd(t(otu_table(dep_rare)), phy_tree(dep_rare),
                 include.root=F) 

# add PD to metadata table
sample_data(dep_rare)$PD <- phylo_dist$PD

# plot any metadata category against the PD
plot.pd <- ggplot(sample_data(dep_rare), aes(dep_hyp, PD)) + 
  geom_boxplot() +
  xlab("Disease State") +
  ylab("Phylogenetic Diversity") +
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control"))+
  theme(axis.text.x = element_text(angle = 270, hjust = 0))
plot.pd

#Save graph
ggsave(filename = "plot_pd_condition.png"
       , plot.pd
       , height=6, width=6)

### calculate and graph Faith's phylogenetic diversity as PD for hyp_dep_sex ###
plot.pd_sex <- ggplot(sample_data(dep_rare), aes(dep_hyp, PD)) + 
  xlab("Disease State") +
  ylab("Phylogenetic Diversity")+
  facet_wrap(.~sex, scales="free_x", strip.position="bottom")+
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control"))+
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot(aes(fill = dep_hyp))+
  scale_fill_manual(values = c(
    "depressed_hypertension" = "#F4A7A3",
    "depressed_no_hypertension" = "#7FAE2B",
    "not depressed_hypertension" = "#39B6C8",
    "not depressed_no_hypertension" = "#C38BFF"))+
  scale_fill_discrete(guide = "none")
plot.pd_sex

#Save graph
ggsave(filename = "plot_pd_sex.png"
       , plot.pd_sex
       , height=5, width=6)

### calculate and graph Faith's phylogenetic diversity as PD for hyp_dep_age ###
plot.pd_age<- ggplot(sample_data(dep_rare), aes(dep_hyp, PD)) + 
  xlab("Disease State") +
  ylab("Phylogenetic Diversity")+
  facet_wrap(.~age_cat, scales="free_x", strip.position="bottom")+
  scale_x_discrete(labels = c("Both", "Depression", "Hypertension","Control"))+
  theme_classic()+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))+
  geom_boxplot(aes(fill = dep_hyp))+
  scale_fill_manual(values = c(
    "depressed_hypertension" = "#F4A7A3",
    "depressed_no_hypertension" = "#7FAE2B",
    "not depressed_hypertension" = "#39B6C8",
    "not depressed_no_hypertension" = "#C38BFF"))+
  scale_fill_discrete(guide = "none")
plot.pd_age

#Save graph
ggsave(filename = "plot_pd_age.png"
       , plot.pd_age
       , height=5, width=6)

### Taxa bar plots for dep_hyp_age ### 
# Merging samples of the same group
ps_group <- merge_samples(dep_rare, "dep_hyp_age")

# Convert to relative abundance
dep_RA_age <- transform_sample_counts(ps_group, function(x) x/sum(x))

# To remove black bars, "glom" by phylum first
dep_phylum_age <- tax_glom(dep_RA_age, taxrank = "Phylum", NArm=FALSE)


# Graph relative abundance at phylum level
gg_taxa_age <- plot_bar(dep_phylum_age, fill="Phylum") + 
  ylab("Mean relative abundance")+
  xlab("Disease State and Age")+
  theme_classic()+
scale_x_discrete(labels = c(
  "Both ≥60", 
  "Both <60", 
  "Depression ≥60",
  "Depression <60",
  "Hypertension ≥60", 
  "Hypertension <60",
  "Control ≥60",
  "Control <60"
))+
  theme(axis.text= element_text(size=12), axis.text.x = element_text(angle = 270, hjust = 0))
gg_taxa_age

# Save graph
ggsave("plot_taxonomy_age.png"
       , gg_taxa_age
       , height=8, width =12)

### Taxa bar plots for dep_hyp ###
# Convert to relative abundance
dep_RA <- transform_sample_counts(dep_rare, function(x) x/sum(x))

# To remove black bars, "glom" by phylum first
dep_phylum <- tax_glom(dep_RA, taxrank = "Phylum", NArm=FALSE)

# Graph relative abundance at phylum level
gg_taxa <- plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~dep_hyp, scales = "free_x")
gg_taxa

#Save graph
ggsave("plot_taxonomy_condition.png"
       , gg_taxa
       , height=8, width =12)

### Taxa bar plots for dep_hyp_sex ###
gg_taxa_sex <- plot_bar(dep_phylum, fill="Phylum") + 
  facet_wrap(.~dep_hyp_sex, scales = "free_x")
gg_taxa_sex

table(sample_data(dep_phylum)$dep_hyp_sex)

#Save graph
ggsave("plot_taxonomy_sex.png"
       , gg_taxa_sex
       , height=8, width =12)

### Statistical Significance for shannon ###
alphadiv <- estimate_richness(dep_rare)
samp_dat <- sample_data(dep_rare)
samp_dat_wdiv <- data.frame(samp_dat, alphadiv)

#dep_hyp 
kruskal.test(Shannon ~ dep_hyp, data=samp_dat_wdiv)
result_s_con <- dunn.test(samp_dat_wdiv$Shannon, samp_dat_wdiv$dep_hyp, kw = TRUE)
results_table_s_con = tibble(Z=result_s_con$Z,
                           P=result_s_con$P,
                           Padj=result_s_con$P.adjusted,
                           comparison=result_s_con$comparisons)

#dep_hyp_sex 
kruskal.test(Shannon ~ dep_hyp_sex, data=samp_dat_wdiv)
result_s_sex <- dunn.test(samp_dat_wdiv$Shannon, samp_dat_wdiv$dep_hyp_sex, kw = TRUE)
results_table_s_sex = tibble(Z=result_s_sex$Z,
                             P=result_s_sex$P,
                             Padj=result_s_sex$P.adjusted,
                             comparison=result_s_sex$comparisons)
#dep_hyp_age 
kruskal.test(Shannon ~ dep_hyp_age, data=samp_dat_wdiv)
result_s_age <- dunn.test(samp_dat_wdiv$Shannon, samp_dat_wdiv$dep_hyp_age, kw = TRUE)
results_table_s_age = tibble(Z=result_s_age$Z,
                             P=result_s_age$P,
                             Padj=result_s_age$P.adjusted,
                             comparison=result_s_age$comparisons)


### Statistical Significance for PD ###
metadata_recalled <- sample_data(dep_rare)

#dep_hyp 
PD_data_only_con <- data.frame(metadata_recalled$PD, metadata_recalled$dep_hyp)
kruskal.test(metadata_recalled.PD ~ metadata_recalled.dep_hyp, data= PD_data_only_con)
result_con <- dunn.test(PD_data_only$metadata_recalled.PD, PD_data_only$metadata_recalled.dep_hyp, kw = TRUE)
results_table_con= tibble(Z=result_con$Z,
                           P=result_con$P,
                           Padj=result_con$P.adjusted,
                           comparison=result_con$comparisons)

#dep_hyp_age 
PD_data_only_age <- data.frame(metadata_recalled$PD, metadata_recalled$dep_hyp_age)
kruskal.test(metadata_recalled.PD ~ metadata_recalled.dep_hyp_age, data= PD_data_only_age)
result_age <- dunn.test(PD_data_only_age$metadata_recalled.PD, PD_data_only_age$metadata_recalled.dep_hyp_age, kw = TRUE)
results_table_age = tibble(Z=result_age$Z,
                           P=result_age$P,
                           Padj=result_age$P.adjusted,
                           comparison=result_age$comparisons)

#dep_hyp_sex 
PD_data_only_sex <- data.frame(metadata_recalled$PD, metadata_recalled$dep_hyp_sex)
kruskal.test(metadata_recalled.PD ~ metadata_recalled.dep_hyp_sex, data= PD_data_only_sex)
result_sex <- dunn.test(PD_data_only_sex$metadata_recalled.PD, PD_data_only_sex$metadata_recalled.dep_hyp_sex, kw = TRUE)
results_table_sex = tibble(Z=result_sex$Z,
                           P=result_sex$P,
                           Padj=result_sex$P.adjusted,
                           comparison=result_sex$comparisons)

### Statistical significance for observed features ###
# dep_hyp_age
kruskal.test(Observed ~ dep_hyp_age, data=samp_dat_wdiv)
result_o_age <- dunn.test(samp_dat_wdiv$Observed, samp_dat_wdiv$dep_hyp_age, kw = TRUE)
results_table_o_age = tibble(Z=result_o_age$Z,
                             P=result_o_age$P,
                             Padj=result_o_age$P.adjusted,
                             comparison=result_o_age$comparisons)

# dep_hyp_sex
kruskal.test(Observed ~ dep_hyp_sex, data=samp_dat_wdiv)
result_o_sex <- dunn.test(samp_dat_wdiv$Observed, samp_dat_wdiv$dep_hyp_sex, kw = TRUE)
results_table_o_sex = tibble(Z=result_o_sex$Z,
                               P=result_o_sex$P,
                               Padj=result_o_sex$P.adjusted,
                               comparison=result_o_sex$comparisons)


  
  
  
 










