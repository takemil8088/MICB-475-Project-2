#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(DESeq2)


#### Load data ####
load("dep_final.RData")

#### Load Function ####

#function to do the result + visualization so code wouldn't have to be copy+pasted
visualize <- function(c1, t, file_suffix, deseq1, phylo, col){
  #t is title for the volcano/bar plots
  #c1 is contrasts
  
  #extract results for that contrast
  res <- results(deseq1, tidy=TRUE, contrast = c1)
  #View(res1)
  
  #Volcano plot: effect size VS significance
  vol_plot <- res %>%
    
    #differentiating significant and insignificant points to be plotted
    mutate(significant = padj<0.01 & abs(log2FoldChange)>5) %>% 
    filter(padj > 0) %>% #justto get rid of rows with padj = NA
    ggplot() +
    
    #dashed lines
    geom_vline(xintercept = c(-5, 5), col = "gray", linetype = 'dashed') +
    geom_hline(yintercept = -log10(0.01), col = "gray", linetype = 'dashed') + 
    
    #adding points
    geom_point(aes(x=log2FoldChange, 
                   y=-log10(padj), 
                   col=significant)) +
    
    #changing theme
    labs(title = t, col = "") +
    theme_classic() +
    scale_color_manual(values = c("#cfcfcf", "#24b8bd"),
                       labels = c("Not Significant", "Significant")) +
    xlim(-10, 10) +
    ylim(0, 18)
  
  vol_plot
  ggsave(filename = paste("vol_plot_", file_suffix,".png", sep = ""),
         vol_plot,
         width = 5,
         height = 4)
  
  
  #Bar plot
  # To get table of results
  sigASVs <- res %>% 
    filter(padj<0.01 & abs(log2FoldChange)>5) %>%
    dplyr::rename(ASV=row)
  
  # Get only asv names
  sigASVs_vec <- sigASVs %>%
    pull(ASV)
  
  # organize information for bar plot
  sigASVs <- 
    prune_taxa(sigASVs_vec, phylo) %>% #keep just significant ASVs from phyloseq obj
    tax_table() %>% as.data.frame() %>% #get taxa table and change to dataframe format
    rownames_to_column(var="ASV") %>% 
    right_join(sigASVs) %>% #join the taxa info to the ASVs
    mutate(Taxonomy = if_else(!grepl("", Genus) | grepl("NA", Genus), Family, Genus)) %>% #if genus is NA use family to identify
    arrange(log2FoldChange) #order by log2foldchange
  
  sigASVs$Taxonomy %>%
    write(paste("ALL_", file_suffix, ".txt",sep = ""))
  
  sigASVs <- sigASVs %>%
    mutate(Taxonomy = make.unique(Taxonomy)) %>% #IDK what these 2 does
    mutate(Taxonomy = factor(Taxonomy, levels=unique(Taxonomy)))
  
  
  #make the bar plot
  bar_plot <- ggplot(sigASVs) +
    geom_bar(aes(x=Taxonomy, y=log2FoldChange), stat="identity", fill = col)+
    geom_errorbar(aes(x=Taxonomy, ymin=log2FoldChange-lfcSE, ymax=log2FoldChange+lfcSE)) +
    theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) +
    labs(title = t) +
    theme_classic() +
    ylim(-10, 10) +
    coord_flip()
  
  #save the bar plot
  ggsave(filename = paste("bar_plot_", file_suffix,".png", sep = ""), bar_plot,
         height = 11,
         width = 7)
  
}


#### DESeq ####
# make clear that it was run at ASV level, not at the genus or higher level in the results/method section. 
# deseq with unrare
# and do all groups over & under 60
# google all the taxa & families --> papers abt it
# find trends - like a group of SCFA producers was increased. If any of them have common functions
# and looking between this & literature
# and list out any contradicting results (like pro  anti inflammatory increased)
# volcano in supplimentary, bar plots take figure

#*see if the bugs are healthy or not*

# step 1: make the deseq object for dep_hyp_age
# Data transformed since there are 0 counts in OTU table
dep_plus1 <- transform_sample_counts(dep_final, function(x) x+1)

#For each comparison, single out the samples with just the two conditions of interest

# dep_hyp_age corresnding to what
#  healthy --> "not depressed_no_hypertension_60 and older"
#  hypertension --> "not depressed_hypertension_60 and older"
#  depressed --> "depressed_no_hypertension_60 and older"
#  both --> "depressed_hypertension_60 and older"

ctrl_dep <- prune_samples(
  dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_60 and older" |
    dep_plus1@sam_data[["dep_hyp_age"]] == "depressed_no_hypertension_60 and older",
  dep_plus1)

ctrl_hyp <- prune_samples(
  dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_60 and older" |
    dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_hypertension_60 and older",
  dep_plus1)

ctrl_both <- prune_samples(
  dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_60 and older" |
    dep_plus1@sam_data[["dep_hyp_age"]] == "depressed_hypertension_60 and older",
  dep_plus1)

#same thing but with under 60 samples
ctrl_dep_60 <- prune_samples(
  dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_under 60" |
    dep_plus1@sam_data[["dep_hyp_age"]] == "depressed_no_hypertension_under 60",
  dep_plus1)

ctrl_hyp_60 <- prune_samples(
  dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_under 60" |
    dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_hypertension_under 60",
  dep_plus1)

ctrl_both_60 <- prune_samples(
  dep_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_under 60" |
    dep_plus1@sam_data[["dep_hyp_age"]] == "depressed_hypertension_under 60",
  dep_plus1)


#converting & running DESeq for each comparison
DESEQ_ctrl_dep <- phyloseq_to_deseq2(ctrl_dep, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_hyp <- phyloseq_to_deseq2(ctrl_hyp, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_both <- phyloseq_to_deseq2(ctrl_both, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_dep_60 <- phyloseq_to_deseq2(ctrl_dep_60, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_hyp_60 <- phyloseq_to_deseq2(ctrl_hyp_60, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_both_60 <- phyloseq_to_deseq2(ctrl_both_60, ~`dep_hyp_age`) %>% 
  DESeq()

#step 3: Visualizing results for the three comparisons
# which bug is richer/not richer, and only for 60 and older?

#Reference group should be third in vector for contrast
#control vs hypertension
visualize(c1 = c("dep_hyp_age",
                   "not depressed_hypertension_60 and older",
                   "not depressed_no_hypertension_60 and older"),
          t = "Control VS Hypertension", 
          file_suffix = "ctrl_hyp",
          deseq1 = DESEQ_ctrl_hyp,
          phylo = ctrl_hyp,
          col = "#00bfc4")

#control vs depression
visualize(c1 = c("dep_hyp_age",
                 "depressed_no_hypertension_60 and older",
                 "not depressed_no_hypertension_60 and older"),
          t = "Control VS Depression", 
          file_suffix = "ctrl_dep",
          deseq1 = DESEQ_ctrl_dep,
          phylo = ctrl_dep,
          col = "#7cae00")

#control vs both
visualize(c1 = c("dep_hyp_age",
                 "depressed_hypertension_60 and older",
                 "not depressed_no_hypertension_60 and older"),
          t = "Control VS Both", 
          file_suffix = "ctrl_both",
          deseq1 = DESEQ_ctrl_both,
          phylo = ctrl_both,
          col = "#f8766d")


visualize(c1 = c("dep_hyp_age",
                 "not depressed_hypertension_under 60",
                 "not depressed_no_hypertension_under 60"),
          t = "Control VS Hypertension", 
          file_suffix = "ctrl_hyp_60",
          deseq1 = DESEQ_ctrl_hyp_60,
          phylo = ctrl_hyp,
          col = "#00bfc4")

#control vs depression
visualize(c1 = c("dep_hyp_age",
                 "depressed_no_hypertension_under 60",
                 "not depressed_no_hypertension_under 60"),
          t = "Control VS Depression", 
          file_suffix = "ctrl_dep_60",
          deseq1 = DESEQ_ctrl_dep_60,
          phylo = ctrl_dep,
          col = "#7cae00")

#control vs both
visualize(c1 = c("dep_hyp_age",
                 "depressed_hypertension_under 60",
                 "not depressed_no_hypertension_under 60"),
          t = "Control VS Both", 
          file_suffix = "ctrl_both_60",
          deseq1 = DESEQ_ctrl_both_60,
          phylo = ctrl_both,
          col = "#f8766d")

