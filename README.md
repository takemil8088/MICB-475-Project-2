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

Notes:
- Sam suggested for us to not look at what the paper we found it did, so we discussed what are other things we could look at:
  -  Medication: look at the same matrix, but then add medication to our reseach matrix, however the medication had many N/As
  -  Diabetes: are metadata also has diabetes, microbiome vs diabetes and depression or microbiome vs diabetes and hypertension
  -  blood glucose
  -  calcium and other mineral things
 
  Did the paper look at a sex difference in the literature?
  - Sam said we could look at co-variables like sex or age, 
  -  We can stratify based on co-founders
    
  Current plan:
  - Look at if there is a gap in stratifying based on co-factor for a day, then pivot if we don't find literature to validate our reasoning to go forward.
  - Additional question, does our dataset look at type 1 or type 2 diabetes. Determined it is type 2 diabetes.
 
  Next, got feedback on our code:
  - Can it be more efficient ->  .x and .y showed up after left join, however it was fine.
  - can create a for loop to make hypertension
  - our matrix of depresseion vs hypertension has enough samples (even at our low of 18 samples)
    
 However if we are adding another stratifier then we might have too few samples, so we could lower the number that is our bdi cut off to include mild depression.
 However we determined based on size of dataset we can't have a matrix comparison of depresssion vs hypertension vs diabetes.
 If we do stratifying, the way we group ages is important and would maybe affect number of samples between groups, we would maybe need to split sampeles at a single age like 50, depends on literature review.

Idea: examine different groupings of stratification, so we can also look at both age and then sex.

Code: If we want to filter the manifest the same as the metadata, we just left join the manifest.

SAM: Cite all the tools we use, denoising, any databases, when we are making figures the figure legend at bottom, title at top, qiime processing use checklist. Teaching team wants to see if someone looked at sex difference and found it's important, then we should see if it's important when both are combined, while the paper just looks at if they are important seperately.
Additional note: estrogen related to female indivduals ability too absorb vitamin D, menopause stops at around specific age, which could be a point to look at and an interesting justification.

Team meeting Oct 28:
Trimming at 150bp- to so all sequences same length, don't have to trim beginning 10bp
Filter to remove rare ASVs?
sampling depth 20000

Research aims should directly stratify age and sex and look at microbiome
What is the clinical takeaway, talk about clinical implications in the introduction.
Determine the methods and specific aims, give background on each aim- why are we looking at this? 
step 1: qiime2 processing- each step, then aim-specific 
ASM citation style: american society for microbiology- zotero
In the final paper, title should be the conclusion
