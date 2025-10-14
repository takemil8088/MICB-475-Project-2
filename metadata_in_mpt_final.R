#load the packages needed to open the files
library(BiocManager)
library(phyloseq)
library(dplyr)

#load the files from the other group, they are mpt_rare and final
load("~/1_uni_data/Yr4T1/MICB 475 - data sci/project 2/longmeta_phyloseq_unrare.RData")
load("~/1_uni_data/Yr4T1/MICB 475 - data sci/project 2/longmeta_phyloseq_rare.RData")

#mpt_final has more samples corresponding to the metadata so we'll be extracting those
metadata_other <- mpt_final@sam_data
typeof(metadata_other) #outputted list

#change the type from list to dataframe for adjustments
metadata <- data.frame(matrix(unlist(metadata_other), 
                              nrow=length(metadata_other$experiment_name), 
                              byrow=FALSE,),
                       stringsAsFactors=FALSE)
#changing column names to match the old one
names(metadata) <- names(unlist(metadata_other[1]))
row.names(metadata) <- row.names(metadata_other)
#now the metadata is back in dataframe format


#classify ppl into depressed or not based on BDI scale
#since score of >=21 is moderate depression or more, cut off there
metadata_dep_cat <- metadata %>%
  mutate(dep_cat = case_when(
    bdi_ii < 21 ~ "not depressed",
    bdi_ii >= 21 ~ "depressed"
  ))

#checking to make sure all columns make sense
select(metadata_dep_cat, `bdi_ii`, `dep_cat`)

#a lot of columns lack any data on depression category, so those are removed
metadata_filtered <- filter(metadata_dep_cat, !is.na(dep_cat)) #213 are empty, 617 left
#also need to filter out those without HIV but uhhh im too lazt TODO that \/(o-o)\/

#ok for the two groups, one with and one without HIV
metadata_HIV_pos <- filter(metadata_filtered, hiv_status_clean == "HIV+") #444 samples left
metadata_HIV_neg <- filter(metadata_filtered, hiv_status_clean == "HIV-") #172 samples left

#clear for all virus
meta_novir <- filter(metadata_HIV_neg, hcv == "NO")

#and save metadata_filtered for now as RData
save(metadata_filtered, file = 'metadata_filt.RData')
save(meta_novir, file = 'metadata_novirus.RData`)

#metadata <- do.call(rbind.data.frame, metadata_other)#turned the columns into rows ;-; 


#for the old file?? not really needed
#load the new file, used code from manual load
library(readr)
depression_metadata <- read_csv("depression_metadata.csv") 
#resulting table should have 86 columns and 1032 samples


#merge the new with the old??? not really necessary cause the old one also had BDI
