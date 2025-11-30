#!/usr/bin/env Rscript
library(tidyverse)
library(phyloseq)
library(DESeq2)


#### Load data ####
load("dep_rare.RData")
#sample_sums(dep_rare) #should all have 20000

#### DESeq ####


#*see if the bugs are healthy or not*

# step 1: make the deseq object for dep_hyp_age
# Data transformed since there are 0 counts in OTU table
dep_rare_plus1 <- transform_sample_counts(dep_rare, function(x) x+1)

#single out the samples with just the two conditions of interest

# dep_hyp_age corresnding to what
#  healthy --> "not depressed_no_hypertension_60 and older"
#  hypertension --> "not depressed_hypertension_60 and older"
#  depressed --> "depressed_no_hypertension_60 and older"
#  both --> "depressed_hypertension_60 and older"

ctrl_dep <- prune_samples(
  dep_rare_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_60 and older" |
    dep_rare_plus1@sam_data[["dep_hyp_age"]] == "depressed_no_hypertension_60 and older",
  dep_rare_plus1)

ctrl_hyp <- prune_samples(
  dep_rare_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_60 and older" |
    dep_rare_plus1@sam_data[["dep_hyp_age"]] == "not depressed_hypertension_60 and older",
  dep_rare_plus1)

ctrl_both <- prune_samples(
  dep_rare_plus1@sam_data[["dep_hyp_age"]] == "not depressed_no_hypertension_60 and older" |
    dep_rare_plus1@sam_data[["dep_hyp_age"]] == "depressed_hypertension_60 and older",
  dep_rare_plus1)


#converting & running DEseq fr each
DESEQ_ctrl_dep <- phyloseq_to_deseq2(ctrl_dep, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_hyp <- phyloseq_to_deseq2(ctrl_hyp, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_ctrl_both <- phyloseq_to_deseq2(ctrl_both, ~`dep_hyp_age`) %>% 
  DESeq()

DESEQ_test <- phyloseq_to_deseq2(test, ~`dep_hyp_age`) %>% 
  DESeq()


#step 3: VIsualizing results for the three comparisons
# which bug is richer/not richer, and only for 60 and older?

#function to do the result + visualization so code wouldn't have to be copy+pasted
visualize <- function(c1, t, file_suffix, deseq1, phylo, col){
  #t is title for the volcano/bar plots
  #c1 is contrasts
  
  #extract results for that contrast
  res <- results(deseq1, tidy=TRUE, contrast = c1)
  #View(res1)
  
  #Volcano plot: effect size VS significance
  ## Make variable to color by whether it is significant + large change
  vol_plot <- res %>%
    mutate(significant = padj<0.01 & abs(log2FoldChange)>2) %>%
    ggplot() +
    geom_point(aes(x=log2FoldChange, y=-log10(padj), col=significant)) +
    labs(
      title = t
    )
  
  vol_plot
  ggsave(filename = paste("vol_plot_", file_suffix,".png", sep = "") ,vol_plot)
  
  
  #Bar plot
  # To get table of results
  sigASVs <- res %>% 
    filter(padj<0.01 & abs(log2FoldChange)>2) %>%
    dplyr::rename(ASV=row)
  
  # Get only asv names
  sigASVs_vec <- sigASVs %>%
    pull(ASV)
  
  # organize information for bar plot
  sigASVs <- 
    prune_taxa(sigASVs_vec, test) %>% #keep just significant ASVs from phyloseq obj
    tax_table() %>% as.data.frame() %>% #get taxa table and change to dataframe format
    rownames_to_column(var="ASV") %>% 
    right_join(sigASVs) %>% #join the taxa info to the ASVs
    mutate(Taxonomy = if_else(!grepl("", Genus) | grepl("NA", Genus), Family, Genus)) %>% #if genus is NA use family to identify
    arrange(log2FoldChange) %>% #order by log2foldchange
    mutate(Taxonomy = make.unique(Taxonomy)) %>% #IDK what these 2 does
    mutate(Taxonomy = factor(Taxonomy, levels=unique(Taxonomy)))
  
  
  #make the bar plot
  bar_plot <- ggplot(sigASVs) +
    geom_bar(aes(x=Taxonomy, y=log2FoldChange), stat="identity", fill = col)+
    geom_errorbar(aes(x=Taxonomy, ymin=log2FoldChange-lfcSE, ymax=log2FoldChange+lfcSE)) +
    theme(axis.text.x = element_text(angle=90, hjust=1, vjust=0.5)) +
    labs(title = t) +
    theme_classic() +
    theme(axis.text.x=element_text(angle = -90, hjust = 0))
  
  #save the bar plot
  ggsave(filename = paste("bar_plot_", file_suffix,".png", sep = ""), bar_plot,
         height = 7,
         width = 7)
  
}

# dep_hyp_age corresnding to what
#  healthy --> "not depressed_no_hypertension_60 and older"
#  hypertension --> "not depressed_hypertension_60 and older"
#  depressed --> "depressed_no_hypertension_60 and older"
#  both --> "depressed_hypertension_60 and older"

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
