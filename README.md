# MICB-475-Project-2-Team12

### Team meeting 1:
- Discussed possible metadata options; depression or cancer?
- Depression dataset has not been used before; needs more wrangling
- Cancer dataset has less variables; possibly combine data with other cancer datasets

### Team meeting 2: 
- Finalized: use the depression metadata → will need to annotate the data
- Linking depression with blood pressure
- Possibility; linking blood pressure to cancer, then to depression?
- First, must perform a Classification ( plateau → understand which category and variables are good to look at), then Filter out missing data, annotate (what's considered clinically depressed? Pick one; bdi (use this one; depressed vs non-depressed, don't use range) or poms)
- Filter for viruses and get only controls; see who has bdi of above 10
Control; original dataset is based on depression, HIV etc. → only choose co-infected data
Get the more completed metadata (look at Github)
Manifest only the variables we need (do the same filtering you did for the metadata (same data)) --> but don’t be too biased 
By October 26th; obtain the completed metadata, and classify and filter it (make sure the filtering matches the manifest data!)

### Team meeting 3
What we did from last week:
- Filtered for HIV and hcv, found number of depressed (57) and not depressed(99) within this population

Goal: 

- determine best ways to work on the files

-determine how we want to document

Questions:
- whould we be working with the dataset on the server or transferring it to our local computer
- can we move a copy of it into our data folder
- is sample size big enough
- should we remove some not depressed
- What is wrong with Veronika's file (longmeta_phyloseq_rare.RData)

Team meeting dicussions:
- We should equalize the sample number for depressed & not depressed
- The completed metadata doesn't include blood pressure results; must add and match with existing filtered out data (join data)
- 3 columns --> depression, blood pressure, & a column with both - "depression_highbp, depression_lowbp"
- Above 20 for bdi, considered depressed
- potentialy 3 categories for depression caterogization
- Filter out NAs for blood pressure result
- Must categorize blood pressure results --> make sure we still have enough sample
- Start proposal: (assignment 3 module) -  rarefraction etc. --> questions must be aided by literature with strong citations

For next week:
- divide up work for proposal
- finalize research question -

### Team meeting 4 Oct 21:

Goals:
- Discuss and finalize research questions and specific aims- "How does the microbiome functionality differ across patients with high blood pressure, clinical depression, cormorbid conditions and patients with neither condition?" 
- Divide tasks for proposal (due Oct 26, this Sunday)
- Arrange a meeting at the end of week to discuss progress and proposal draft
- Discuss aim-specific approaches
  
Questions:
Our current research question is "How does the microbiome functionality differ across patients with high blood pressure, clinical depression, cormorbid conditions and patients with neither condition?" Would like to build our project on previous research done by Bruce et al, which identified an unique bacteria taxa and altered functional pathways linked to both mood and BP control in patients diagnosed with both conditions. The researchers studied wide scale gut microbiome functional genomic differences. We plan narrowing it down and study the function of specific species differentially abundant in each cohort. But is our research gap valid or strong enough? (https://www.sciencedirect.com/science/article/pii/S0002870321001228?via%3Dihub)

Divided Tasks:
1. Sophie: 
2. Artemis:
3. Leyi:
4. Millie
5. Vera:
