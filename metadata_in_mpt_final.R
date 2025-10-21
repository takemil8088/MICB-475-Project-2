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
    bdi_ii < 20 ~ "not depressed",
    bdi_ii >= 20 ~ "depressed"
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

#metadata <- do.call(rbind.data.frame, metadata_other)#turned the columns into rows ;-; 


#load the new file, used code from manual load
library(readr)
depression_metadata <- read_csv("depression_metadata.csv") 
#resulting table should have 86 columns and 1032 samples


#load tibble library
library(tibble)
# change meta_novir rownames to column used for join (dep. metadata has sample-id)
meta_novir <- rownames_to_column(meta_novir)

#merge the meta_novir with the depression metadata
meta_joined <- left_join(meta_novir, depression_metadata, by = join_by(`rowname` == `sample-id`))
#duplicate columns ended up as .x and .y, so should check that values are the same then remove the duplicate columns

#save
save(meta_joined, file = "metadata_join.RData")

#remove duplicate columns ending in .x or .y
#to do this we will get list of all column names ending in .x
xn <- names(meta_joined)[endsWith(names(meta_joined),".x")]
#remove the .x
nms <- str_replace_all(string = xn,
                   pattern = ".x",
                   replacement="") 
#create data frame with one copy of only columns ending in .x and .y ie duplicate columns and rename without the x and y
meta_dup_col = map_dfc(nms,
        ~ coalesce(meta_joined[[paste0(.,".x")]],
                   meta_joined[[paste0(.,".y")]]
        )) %>% setNames(nms) 
#remove columns ending in x or y from joined dataframe
meta_joined_no_dup = select(meta_joined, select=-ends_with(".x"), -ends_with(".y")) 
#merge the two datasets together
meta_joined_final = bind_cols(meta_joined_no_dup, meta_dup_col) 
#ngl I thought there were a lot more duplicated columns then there were prob could've just removed them manually :(

#save 
save(meta_joined_final, file = "metadata_join_final.RData")

#select only the columns we are interested in so we have a smaller metadata table to work with (I left anything vaguely related to blood pressure so we can probably remove more columns later)
meta_subset = select(meta_joined_final, sample_id = rowname, hiv_status_clean, hcv, ethnicity, race, host_age, sex, dep_cat, diastolic_bp, pulse_pressure, pulse, systolic_BP, diabetes, mch, mchc, rdw, hgb,glucose_serum, Creatinine, alt_sgpt, ast_sgot, lymphocyte_percent)

#creating a hypertension column
#create empty column called hypertension
meta_subset$hypertension = NA
#fill hypertension column with yes or no based only on systolic bp
meta_subset$hypertension = ifelse(meta_subset$systolic_BP >= 130, "hypertension", "no_hypertension")
#replace hypertension column value with yes if diastolic bp is high
meta_subset$hypertension = ifelse(meta_subset$diastolic_bp >80, "hypertension", meta_subset$hypertension)

#make column with both depression and hypertension
meta_subset = unite(meta_subset, dep_and_hyp, dep_cat, hypertension, sep = "_", remove=FALSE, na.rm = FALSE)

#save
save(meta_subset, file = "metadata_subset.RData")

#count how many have hypertension
dim(meta_subset) #156 total samples
table(meta_subset$hypertension, useNA = "always") #77 hypertension, 56 normal bp, 23 NA

#count how many have depression and hypertension together
table(meta_subset$dep_and_hyp) #31 depressed_hypertension, 18 depressed_no_hypertension, 46 not depressed_hypertension, 38 not depressed_no_hypertension, 8 depressed_NA, 15 not depressed_NA
#there are more for not depressed so it would probably be okay to decrease BDI cutoff to 10 to have more depressed and be more clinically relevant
#what do we do with the NAs for hypertension??
