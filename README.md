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
  


