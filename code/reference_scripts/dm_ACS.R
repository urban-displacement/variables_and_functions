####################################################################################### Pulled from the displacement measure typlogy
###### Pulling census data for neighborhood-scale Displacement Measure variables ######
#######################################################################################


### Loading required packages and setting defaults
if(!require(pacman)) install.packages("pacman")
p_load(tidyr, dplyr, tigris, tidycensus, yaml, sf, stringr, fst,  googledrive, bit64,magrittr, fs, data.table, tidyverse, spdep)
options(tigris_use_cache = TRUE,
         tigris_class = "sf")
if(!require(lehdr)){devtools::install_github("jamgreen/lehdr")}else{library(lehdr)}
#setwd("Git/hprm")
select <- dplyr::select



# options(width = Sys.getenv('COLUMNS'))

### Set API key
census_api_key('4c26aa6ebbaef54a55d3903212eabbb506ade381') #enter your own key here

#######################################################################
###### 2019 Variables  ################################################
#######################################################################



race_vars_19 <- c(
  "population"= "DP05_0001",
  "adult_pop" = "DP05_0021",
  "med_age" = "B01002_001",
  "white" = "B03002_003",
  "black" = "B03002_004",
  "amind" = "B03002_005",
  "asian" = "B03002_006",
  "pacis" = "B03002_007",
  "other" = "B03002_008",
  "race2" = "B03002_009",
  "latinx" = "B03002_012")
  


tenure_vars_19 <-c(
  "hh_count" = "B09019_001",
  "ownerp" = "DP04_0046P",
  "owner_count" = "DP04_0046",
  "renterp" = "DP04_0047P",
  "renter_count" = "DP04_0047",
  "homeval_lower_quartile" = "B25076_001",
  "homeval_med" = "B25077_001",
  "homeval_upper_quartile" = "B25078_001",
  "totalunits" ="B25034_001",
  "built_2005_on" = "B25034_002",
  "built_2000_2004"="B25034_003",
  "built_1990_1999"="B25034_004",
  "built_1980_1989" = "B25034_005",
  "built_1970_1979" ="B25034_006" ,
  "built_1960_1969"= "B25034_007",
  "built_1950_1959"="B25034_008",
  "built_1940_1949" = "B25034_009",
  "built_1939_before" = "B25034_010",
  'ownocc_.5_less_per_room' = 'B25014_003',
  'ownocc_.5to1_per_room' = 'B25014_004',
  'ownocc_1to1.5_per_room' = 'B25014_005',
  'ownocc_1.5to2_per_room' = 'B25014_006',
  'ownocc_2more_per_room' = 'B25014_007',
  'rentocc_.5_less_per_room' = 'B25014_009',
  'rentocc_.5to1_per_room' = 'B25014_010',
  'rentocc_1to1.5_per_room' = 'B25014_011',
  'rentocc_1.5to2_per_room' = 'B25014_012',
  'rentocc_2more_per_room' = 'B25014_013')

income_vars_19 <- c(
  "medinc" = "B19013_001",
  "income_less_10k_all" =  "B19001_002",
  "income_10k_15k_all" =   "B19001_003",
  "income_15k_20k_all" =   "B19001_004",
  "income_20k_25k_all" =   "B19001_005",
  "income_25k_30k_all" =   "B19001_006",
  "income_30k_35k_all" =   "B19001_007",
  "income_35k_40k_all" =   "B19001_008",
  "income_40k_45k_all" =   "B19001_009",
  "income_45k_50k_all" =   "B19001_010",
  "income_50k_60k_all" =   "B19001_011",
  "income_60k_75k_all" =   "B19001_012",
  "income_75k_100k_all" =  "B19001_013",
  "income_100k_125k_all" = "B19001_014",
  "income_125k_150k_all" = "B19001_015",
  "income_150k_200k_all" = "B19001_016",
  "income_200k_more_all" = "B19001_017",
  "income_less_10k_Black" =  "B19001B_002",
  "income_10k_15k_Black" =   "B19001B_003",
  "income_15k_20k_Black" =   "B19001B_004",
  "income_20k_25k_Black" =   "B19001B_005",
  "income_25k_30k_Black" =   "B19001B_006",
  "income_30k_35k_Black" =   "B19001B_007",
  "income_35k_40k_Black" =   "B19001B_008",
  "income_40k_45k_Black" =   "B19001B_009",
  "income_45k_50k_Black" =   "B19001B_010",
  "income_50k_60k_Black" =   "B19001B_011",
  "income_60k_75k_Black" =   "B19001B_012",
  "income_75k_100k_Black" =  "B19001B_013",
  "income_100k_125k_Black" = "B19001B_014",
  "income_125k_150k_Black" = "B19001B_015",
  "income_150k_200k_Black" = "B19001B_016",
  "income_200k_more_Black" = "B19001B_017",
  "income_less_10k_Asian" =  "B19001D_002",
  "income_10k_15k_Asian" =   "B19001D_003",
  "income_15k_20k_Asian" =   "B19001D_004",
  "income_20k_25k_Asian" =   "B19001D_005",
  "income_25k_30k_Asian" =   "B19001D_006",
  "income_30k_35k_Asian" =   "B19001D_007",
  "income_35k_40k_Asian" =   "B19001D_008",
  "income_40k_45k_Asian" =   "B19001D_009",
  "income_45k_50k_Asian" =   "B19001D_010",
  "income_50k_60k_Asian" =   "B19001D_011",
  "income_60k_75k_Asian" =   "B19001D_012",
  "income_75k_100k_Asian" =  "B19001D_013",
  "income_100k_125k_Asian" = "B19001D_014",
  "income_125k_150k_Asian" = "B19001D_015",
  "income_150k_200k_Asian" = "B19001D_016",
  "income_200k_more_Asian" = "B19001D_017",
  "income_less_10k_WhiteNonHisp" =  "B19001H_002",
  "income_10k_15k_WhiteNonHisp" =   "B19001H_003",
  "income_15k_20k_WhiteNonHisp" =   "B19001H_004",
  "income_20k_25k_WhiteNonHisp" =   "B19001H_005",
  "income_25k_30k_WhiteNonHisp" =   "B19001H_006",
  "income_30k_35k_WhiteNonHisp" =   "B19001H_007",
  "income_35k_40k_WhiteNonHisp" =   "B19001H_008",
  "income_40k_45k_WhiteNonHisp" =   "B19001H_009",
  "income_45k_50k_WhiteNonHisp" =   "B19001H_010",
  "income_50k_60k_WhiteNonHisp" =   "B19001H_011",
  "income_60k_75k_WhiteNonHisp" =   "B19001H_012",
  "income_75k_100k_WhiteNonHisp" =  "B19001H_013",
  "income_100k_125k_WhiteNonHisp" = "B19001H_014",
  "income_125k_150k_WhiteNonHisp" = "B19001H_015",
  "income_150k_200k_WhiteNonHisp" = "B19001H_016",
  "income_200k_more_WhiteNonHisp" = "B19001H_017",
  "income_less_10k_Latinx" =  "B19001I_002",
  "income_10k_15k_Latinx" =   "B19001I_003",
  "income_15k_20k_Latinx" =   "B19001I_004",
  "income_20k_25k_Latinx" =   "B19001I_005",
  "income_25k_30k_Latinx" =   "B19001I_006",
  "income_30k_35k_Latinx" =   "B19001I_007",
  "income_35k_40k_Latinx" =   "B19001I_008",
  "income_40k_45k_Latinx" =   "B19001I_009",
  "income_45k_50k_Latinx" =   "B19001I_010",
  "income_50k_60k_Latinx" =   "B19001I_011",
  "income_60k_75k_Latinx" =   "B19001I_012",
  "income_75k_100k_Latinx" =  "B19001I_013",
  "income_100k_125k_Latinx" = "B19001I_014",
  "income_125k_150k_Latinx" = "B19001I_015",
  "income_150k_200k_Latinx" = "B19001I_016",
  "income_200k_more_Latinx" = "B19001I_017",
  "ownocc_rentburden_less20k" = "B25106_006",
  "ownocc_rentburden_20k_35k" = "B25106_010",
  "ownocc_rentburden_35k_50k" = "B25106_014",
  "ownocc_rentburden_50k_75k" = "B25106_018",
  "ownocc_rentburden_75kmore" = "B25106_022",
  "rentocc_rentburden_less20k" = "B25106_028",
  "rentocc_rentburden_20k_35k" = "B25106_032",
  "rentocc_rentburden_35k_50k" = "B25106_036",
  "rentocc_rentburden_50k_75k" = "B25106_040",
  "rentocc_rentburden_75kmore" = "B25106_044",
  "med_rent" = "B25064_001",
  "med_rent_percent_income" = "B25071_001",
  "rent_burden_1" = "B25070_007",
  "rent_burden_2" = "B25070_008",
  "rent_burden_3" = "B25070_009",
  "rent_burden_4" = "B25070_010",
  "poverty_rate" = "S1701_C03_001",
  "unemployment" = "S2301_C04_001",
  "welfare" = "B19057_002",
  "h_units_w_mortgage_30_35perc" = "B25091_008",
  "h_units_w_mortgage_35_40perc" = "B25091_009",
  "h_units_w_mortgage_40_50perc" = "B25091_010",
  "h_units_w_mortgage_50moreperc" = "B25091_011")

hh_vars_19 <- c(
  "children" = "S1101_C01_010",
  "seniors" = "S1101_C01_011",
  "avg_hh_size" = "B25010_001",
  "hh_2_person_fam" = "B11016_003",
  "hh_3_person_fam" = "B11016_004",
  "hh_4_person_fam" = "B11016_005",
  "hh_5_more_fam_1" = "B11016_007",
  "hh_5_more_fam_2" = "B11016_008",
  "hh_5_more_fam_3" = "B11016_006",
  "hh_1_person" = "B11016_010",
  "hh_2_person_nonfam" = "B11016_011",
  "hh_3_person_nonfam" = "B11016_012",
  "hh_4_more_person_nonfam_1" = "B11016_015",
  "hh_4_more_person_nonfam_2" = "B11016_016",
  "hh_4_more_person_nonfam_3" = "B11016_013",
  "hh_4_more_person_nonfam_4" = "B11016_014",
  "within_county" = "S0701_C02_001",
  "within_state" = "S0701_C03_001",
  "diff_state" = "S0701_C04_001",
  "abroad" = "S0701_C05_001",
  'total_family_hh' = 'B11001_002',
  'family_hh_married_couple' = 'B11001_003',
  'family_hh_other_family' = 'B11001_004',
  'family_hh_male_no_spouse_present' = 'B11001_005',
  'family_hh_female_no_spouse_present' = 'B11001_006',
  'total_nonfamily_hh' = 'B11001_007',
  'nonfamily_hh_living_alone' = 'B11001_008',
  'nonfamily_hh_not_living_alone' = 'B11001_009',  
  'family_hh_female_no_spouse_present_wchildren' = 'B11004_016',
  'family_hh_male_no_spouse_present_wchildren' = 'B11004_010',
  'h_units_1_detached' = 'B25024_002',
  'h_units_1_attached' = 'B25024_003',
  'h_units_2' = 'B25024_004',
  'h_units_3or4' = 'B25024_005',
  'h_units_5to9' = 'B25024_006',
  'h_units_10to19' = 'B25024_007',
  'h_units_20to49' = 'B25024_008',
  'h_units_50more' = 'B25024_009',
  'h_units_MH' = 'B25024_010',
  'h_units_BoatRV' = 'B25024_011'

  )

edu_vars_19 <- c(
  "totenrolled" = "B14001_001",
  "totpop25over" = "B15002_001",
  "enrolled_undergrad" = "B14001_008",
  "enrolled_grad" = "B14001_009", #total
  "below_hs_1"  = "S1501_C02_007",
  "below_hs_2" ="S1501_C02_008",
  "highschool" = "S1501_C02_009",
  "some_college_1" = "S1501_C02_010" ,
  "some_college_2" = "S1501_C02_011",
  "ba_higher" = "S1501_C02_015",
  "ma_higher" = "S1501_C02_013", 
  "doctorate" =  'B15003_025', 
  'only_english' = 'B06007_002',
  'spanish_english_notverywell' = 'B06007_005',
  'otherlang_english_notverywell' = 'B06007_008'
  ) #percentage


varlist_19 = list(race_vars_19, 
                  tenure_vars_19, 
                  income_vars_19, 
                  hh_vars_19, 
                  edu_vars_19)



#######################################################################
###### 2009 Variables  ################################################
#######################################################################


race_vars_09 <- c(
  "population"= "DP05_0001",
  "adult_pop" = "DP05_0021",
  "med_age" = "B01002_001",
  "white" =  "B03002_003",
  "black" =  "B03002_004",
  "amind" =  "B03002_005",
  "asian" =  "B03002_006",
  "pacis" =  "B03002_007",
  "other" =  "B03002_008",
  "race2" =  "B03002_009",
  "latinx" = "B03002_012")

tenure_vars_09 <-c(
  "hh_count" = "B09016_001",
  "ownerp" = "B25003_002",
  "renterp" = "B25003_003",
  "homeval_lower_quartile" = "B25076_001",
  "homeval_med" = "B25077_001",
  "homeval_upper_quartile" = "B25078_001",
  "totalunits" = "B25034_001",
  "built_2005_on" =   "B25034_002",
  "built_2000_2004" = "B25034_003",
  "built_1990_1999" = "B25034_004",
  "built_1980_1989" = "B25034_005",
  "built_1970_1979" = "B25034_006" ,
  "built_1960_1969" = "B25034_007",
  "built_1950_1959" = "B25034_008",
  "built_1940_1949" =  "B25034_009",
  "built_1939_before" = "B25034_010"
)


# 2019 uses S1903_C03_001 for med income
income_vars_09 <- c(
  "medinc" = "B19013_001",  
  "income_less_10k_all" =  "B19001_002",
  "income_10k_15k_all" =   "B19001_003",
  "income_15k_20k_all" =   "B19001_004",
  "income_20k_25k_all" =   "B19001_005",
  "income_25k_30k_all" =   "B19001_006",
  "income_30k_35k_all" =   "B19001_007",
  "income_35k_40k_all" =   "B19001_008",
  "income_40k_45k_all" =   "B19001_009",
  "income_45k_50k_all" =   "B19001_010",
  "income_50k_60k_all" =   "B19001_011",
  "income_60k_75k_all" =   "B19001_012",
  "income_75k_100k_all" =  "B19001_013",
  "income_100k_125k_all" = "B19001_014",
  "income_125k_150k_all" = "B19001_015",
  "income_150k_200k_all" = "B19001_016",
  "income_200k_more_all" = "B19001_017",
  "income_less_10k_Black" =  "B19001B_002",
  "income_10k_15k_Black" =   "B19001B_003",
  "income_15k_20k_Black" =   "B19001B_004",
  "income_20k_25k_Black" =   "B19001B_005",
  "income_25k_30k_Black" =   "B19001B_006",
  "income_30k_35k_Black" =   "B19001B_007",
  "income_35k_40k_Black" =   "B19001B_008",
  "income_40k_45k_Black" =   "B19001B_009",
  "income_45k_50k_Black" =   "B19001B_010",
  "income_50k_60k_Black" =   "B19001B_011",
  "income_60k_75k_Black" =   "B19001B_012",
  "income_75k_100k_Black" =  "B19001B_013",
  "income_100k_125k_Black" = "B19001B_014",
  "income_125k_150k_Black" = "B19001B_015",
  "income_150k_200k_Black" = "B19001B_016",
  "income_200k_more_Black" = "B19001B_017",
  "income_less_10k_Asian" =  "B19001D_002",
  "income_10k_15k_Asian" =   "B19001D_003",
  "income_15k_20k_Asian" =   "B19001D_004",
  "income_20k_25k_Asian" =   "B19001D_005",
  "income_25k_30k_Asian" =   "B19001D_006",
  "income_30k_35k_Asian" =   "B19001D_007",
  "income_35k_40k_Asian" =   "B19001D_008",
  "income_40k_45k_Asian" =   "B19001D_009",
  "income_45k_50k_Asian" =   "B19001D_010",
  "income_50k_60k_Asian" =   "B19001D_011",
  "income_60k_75k_Asian" =   "B19001D_012",
  "income_75k_100k_Asian" =  "B19001D_013",
  "income_100k_125k_Asian" = "B19001D_014",
  "income_125k_150k_Asian" = "B19001D_015",
  "income_150k_200k_Asian" = "B19001D_016",
  "income_200k_more_Asian" = "B19001D_017",
  "income_less_10k_WhiteNonHisp" =  "B19001H_002",
  "income_10k_15k_WhiteNonHisp" =   "B19001H_003",
  "income_15k_20k_WhiteNonHisp" =   "B19001H_004",
  "income_20k_25k_WhiteNonHisp" =   "B19001H_005",
  "income_25k_30k_WhiteNonHisp" =   "B19001H_006",
  "income_30k_35k_WhiteNonHisp" =   "B19001H_007",
  "income_35k_40k_WhiteNonHisp" =   "B19001H_008",
  "income_40k_45k_WhiteNonHisp" =   "B19001H_009",
  "income_45k_50k_WhiteNonHisp" =   "B19001H_010",
  "income_50k_60k_WhiteNonHisp" =   "B19001H_011",
  "income_60k_75k_WhiteNonHisp" =   "B19001H_012",
  "income_75k_100k_WhiteNonHisp" =  "B19001H_013",
  "income_100k_125k_WhiteNonHisp" = "B19001H_014",
  "income_125k_150k_WhiteNonHisp" = "B19001H_015",
  "income_150k_200k_WhiteNonHisp" = "B19001H_016",
  "income_200k_more_WhiteNonHisp" = "B19001H_017",
  "income_less_10k_Latinx" =  "B19001I_002",
  "income_10k_15k_Latinx" =   "B19001I_003",
  "income_15k_20k_Latinx" =   "B19001I_004",
  "income_20k_25k_Latinx" =   "B19001I_005",
  "income_25k_30k_Latinx" =   "B19001I_006",
  "income_30k_35k_Latinx" =   "B19001I_007",
  "income_35k_40k_Latinx" =   "B19001I_008",
  "income_40k_45k_Latinx" =   "B19001I_009",
  "income_45k_50k_Latinx" =   "B19001I_010",
  "income_50k_60k_Latinx" =   "B19001I_011",
  "income_60k_75k_Latinx" =   "B19001I_012",
  "income_75k_100k_Latinx" =  "B19001I_013",
  "income_100k_125k_Latinx" = "B19001I_014",
  "income_125k_150k_Latinx" = "B19001I_015",
  "income_150k_200k_Latinx" = "B19001I_016",
  "income_200k_more_Latinx" = "B19001I_017",
  # "ownocc_rentburden_less20k" = "B25106_006",
  # "ownocc_rentburden_20k_35k" = "B25106_010",
  # "ownocc_rentburden_35k_50k" = "B25106_014",
  # "ownocc_rentburden_50k_75k" = "B25106_018",
  # "ownocc_rentburden_75kmore" = "B25106_022",
  # "rentocc_rentburden_less20k" = "B25106_028",
  # "rentocc_rentburden_20k_35k" = "B25106_032",
  # "rentocc_rentburden_35k_50k" = "B25106_036",
  # "rentocc_rentburden_50k_75k" = "B25106_040",
  # "rentocc_rentburden_75kmore" = "B25106_044",
  "med_rent" = "B25064_001",
  "med_rent_percent_income" = "B25071_001",
  "rent_burden_1" =  "B25070_007",
  "rent_burden_2" =  "B25070_008",
  "rent_burden_3" =  "B25070_009",
  "rent_burden_4" =  "B25070_010",
  "poverty_rate"  =  "B17001_002",
  "unemployment_1" =  "B23001_008",
  "unemployment_2" =  "B23001_015",
  "unemployment_3" =  "B23001_022", 
  "unemployment_4" =  "B23001_029",
  "unemployment_5" =  "B23001_036",
  "unemployment_6" =  "B23001_043", 
  "unemployment_7" =  "B23001_050",
  "unemployment_8" =  "B23001_057",
  "unemployment_9" =  "B23001_064",
  "unemployment_10" = "B23001_071",
  "unemployment_11" = "B23001_076",
  "unemployment_12" = "B23001_081",
  "unemployment_13" = "B23001_086", 
  "unemployment_14" = "B23001_094", 
  "unemployment_15" = "B23001_101",
  "unemployment_16" = "B23001_108",
  "unemployment_17" = "B23001_115",
  "unemployment_18" = "B23001_122",
  "unemployment_19" = "B23001_129",
  "unemployment_20" = "B23001_136",
  "unemployment_21" = "B23001_143",
  "unemployment_22" = "B23001_150", 
  "unemployment_23" = "B23001_157",
  "unemployment_24" = "B23001_162", 
  "unemployment_25" = "B23001_167",
  "unemployment_26" = "B23001_172",
  "welfare" = "B19057_002"
)

hh_vars_09 <- c(
  "children" = "B11005_002",
  "seniors" = "B11006_002",
  "avg_hh_size" = "B25010_001",
  "hh_2_person_fam" = "B11016_003",
  "hh_3_person_fam" = "B11016_004",
  "hh_4_person_fam" = "B11016_005",
  "hh_5_more_fam_1" = "B11016_007",
  "hh_5_more_fam_2" = "B11016_008",
  "hh_5_more_fam_3" = "B11016_006",
  "hh_1_person" = "B11016_010",
  "hh_2_person_nonfam" = "B11016_011",
  "hh_3_person_nonfam" = "B11016_012",
  "hh_4_more_person_nonfam_1" = "B11016_015",
  "hh_4_more_person_nonfam_2" = "B11016_016",
  "hh_4_more_person_nonfam_3" = "B11016_013",
  "hh_4_more_person_nonfam_4" = "B11016_014",
  "within_county" = "B07003_007",
  "within_state" = "B07003_010",
  "diff_state" = "B07003_013",
  "abroad" = "B07003_016",
  'total_family_hh' = 'B11001_002',
  'family_hh_married_couple' = 'B11001_003',
  'family_hh_other_family' = 'B11001_004',
  'family_hh_male_no_spouse_present' = 'B11001_005',
  'family_hh_female_no_spouse_present' = 'B11001_006',
  'total_nonfamily_hh' = 'B11001_007',
  'nonfamily_hh_living_alone' = 'B11001_008',
  'nonfamily_hh_not_living_alone' = 'B11001_009',
  'family_hh_female_no_spouse_present_wchildren' = 'B11004_016',
  'family_hh_male_no_spouse_present_wchildren' = 'B11004_010',
  'h_units_w_mortgage_30_35perc' = 'B25091_008',
  'h_units_w_mortgage_35_40perc' = 'B25091_009',
  'h_units_w_mortgage_40_50perc' = 'B25091_010',
  'h_units_w_mortgage_50moreperc' = 'B25091_011', 
  'h_units_1_detached' = 'B25024_002',
  'h_units_1_attached' = 'B25024_003',
  'h_units_2' = 'B25024_004',
  'h_units_3or4' = 'B25024_005',
  'h_units_5to9' = 'B25024_006',
  'h_units_10to19' = 'B25024_007',
  'h_units_20to49' = 'B25024_008',
  'h_units_50more' = 'B25024_009',
  'h_units_MH' = 'B25024_010',
  'h_units_BoatRV' = 'B25024_011'
)

edu_vars_09 <- c(
  "totenrolled" = "B14001_001",
  "enrolled_undergrad" = "B14001_008",
  "enrolled_grad" = "B14001_009",
  "totpop25over" = "B15002_001",
  "totpop16over" = "B20001_001",
  "below_hs_1" = "B15002_003",
  "below_hs_2" = "B15002_004",
  "below_hs_3" ="B15002_005",
  "below_hs_4" ="B15002_006",
  "below_hs_5" ="B15002_007",
  "below_hs_6" ="B15002_008",
  "below_hs_7" ="B15002_009",
  "below_hs_8" ="B15002_010",
  "highschool_1" = "B15002_011",
  "highschool_2" = "B15002_028" 
  )

ma_vars_09 <-c(
  "ma_higher_1" = "B15002_016", 
  "ma_higher_2" = "B15002_017", 
  "ma_higher_3" = "B15002_018",
  "ma_higher_4" = "B15002_033", 
  "ma_higher_5" = "B15002_034",
  "ma_higher_6" = "B15002_035")

college_vars_09 <-c(
  "some_college_1" = "B15002_012",
  "some_college_2" = "B15002_013",
  "some_college_3" = "B15002_014",
  "some_college_4" = "B15002_029",
  "some_college_5" = "B15002_030", 
  "some_college_6" = "B15002_031", 
  "doctorate_1" =  "B15002_018",
  "doctorate_2" = "B15002_035")

ba_vars_09 <- c(
  "ba_higher_1" = "B15002_015",
  "ba_higher_2" ="B15002_016",
  "ba_higher_3" = "B15002_017",
  "ba_higher_4" =  "B15002_018",
  "ba_higher_5" = "B15002_032", 
  "ba_higher_6" = "B15002_033",
  "ba_higher_7" =  "B15002_034", 
  "ba_higher_8" = "B15002_035")


misc_vars_09 = c('only_english' = 'B16001_002',
'eng_notverywell_1' ='B16001_005',
'eng_notverywell_2' ='B16001_008',
'eng_notverywell_3' ='B16001_011',
'eng_notverywell_4' ='B16001_014',
'eng_notverywell_5' ='B16001_017',
'eng_notverywell_6' ='B16001_020',
'eng_notverywell_7' ='B16001_023',
'eng_notverywell_8' ='B16001_026',
'eng_notverywell_9' ='B16001_029',
'eng_notverywell_10' ='B16001_032',
'eng_notverywell_11' ='B16001_035',
'eng_notverywell_12' ='B16001_038',
'eng_notverywell_13' ='B16001_041',
'eng_notverywell_14' ='B16001_044',
'eng_notverywell_15' ='B16001_047',
'eng_notverywell_16' ='B16001_050',
'eng_notverywell_17' ='B16001_053',
'eng_notverywell_18' ='B16001_056',
'eng_notverywell_19' ='B16001_059',
'eng_notverywell_20' ='B16001_062',
'eng_notverywell_21' ='B16001_065',
'eng_notverywell_22' ='B16001_068',
'eng_notverywell_23' ='B16001_071',
'eng_notverywell_24' ='B16001_074',
'eng_notverywell_25' ='B16001_077',
'eng_notverywell_26' ='B16001_080',
'eng_notverywell_27' ='B16001_083',
'eng_notverywell_28' ='B16001_086',
'eng_notverywell_29' ='B16001_089',
'eng_notverywell_30' ='B16001_092',
'eng_notverywell_31' ='B16001_095',
'eng_notverywell_32' ='B16001_098',
'eng_notverywell_33' ='B16001_101',
'eng_notverywell_34' ='B16001_104',
'eng_notverywell_35' ='B16001_107',
'eng_notverywell_36' ='B16001_110',
'eng_notverywell_37' ='B16001_113',
'eng_notverywell_38' ='B16001_116', 
'ownocc_.5_less_per_room' = 'B25014_003',
'ownocc_.5to1_per_room' = 'B25014_004',
'ownocc_1to1.5_per_room' = 'B25014_005',
'ownocc_1.5to2_per_room' = 'B25014_006',
'ownocc_2more_per_room' = 'B25014_007',
'rentocc_.5_less_per_room' = 'B25014_009',
'rentocc_.5to1_per_room' = 'B25014_010',
'rentocc_1to1.5_per_room' = 'B25014_011',
'rentocc_1.5to2_per_room' = 'B25014_012',
'rentocc_2more_per_room' = 'B25014_013'
)

varlist_09 = list(race_vars_09, 
                  tenure_vars_09, 
                  income_vars_09, 
                  hh_vars_09, 
                  ma_vars_09, 
                  college_vars_09, 
                  edu_vars_09 ,
                  ba_vars_09,
                  misc_vars_09
)



#######################################################################
###### ACS Pulling Function  ##########################################
#######################################################################
# this code loops through counties and years supplied below. For each #
# county, the code finds the correct 5 year acs survey and pulls the  #
# correct group of variables, listed above. Then, each group of vari- #
# bles are joined by GEOID and labeled by county and survey.          #
#######################################################################

#countylist <- c(097, 095)
yearlist <- c(2019, 2014, 2009)

acs09 <- data.frame(
  GEOID = character(),
  estimate = numeric())

acs14 <- data.frame(
  GEOID = character(),
  estimate = numeric())

acs19 <- data.frame(
  GEOID = character(),
  estimate = numeric())


for(year in yearlist){
  if(year == 2019){
    for(var in varlist_19){
      acs19 <- bind_rows(acs19, get_acs(geography = "tract", 
                                          variables = var, 
                                          state = "CA",
                                          year = 2019,
                                          geometry = FALSE,
                                          cache_table = FALSE,
                                          key = CENSUS_API_KEY,
                                          survey = "acs5") %>%
                            mutate(year = year,
                                   COUNTY = substr(GEOID, 1, 5)))  
    }
  }else if(year == 2014){ 
    for(var in varlist_19){
      acs14 <- bind_rows(acs14, get_acs(geography = "tract", 
                                          variables = var, 
                                          state = "CA",
                                          year = 2014,
                                          geometry = FALSE,
                                          cache_table = FALSE,
                                          key = CENSUS_API_KEY,
                                          survey = "acs5")%>%
                           mutate(year = year,
                                  COUNTY = substr(GEOID, 1, 5))) 
    }    
  }else if (year == 2009){
    for(var in varlist_09){
      acs09 <-bind_rows(acs09, get_acs(geography = "tract", 
                                         variables = var, 
                                         state = "CA",
                                         year = 2009,
                                         geometry = FALSE,
                                         cache_table = FALSE,
                                         key = CENSUS_API_KEY,
                                         survey = "acs5")%>%
                           mutate(year = year,
                                  COUNTY = substr(GEOID, 1, 5)))
    }    
  }
  
  acs09[is.na(acs09)] <- 0
  acs14[is.na(acs14)] <- 0
  acs19[is.na(acs19)] <- 0
  print('Done')

}


acs_09 = acs09
acs_14 = acs14
acs_19 = acs19

#########################################################################################
############## acs00 to 10 crosswalk ####################################################
#########################################################################################
meds <- c('med_age','med_rent',  'homeval_lower_quartile', 'homeval_med', 
          'homeval_upper_quartile', 'medinc', 'avg_hh_size', "med_rent_percent_income")

ltdb  =  read.csv('~/data/projects/displacement_measure/LTDB_weights/crosswalk_2000_2010.csv', 
                  colClasses=c(
                    "trtid00"="character", 
                    "trtid10"="character")) 


#Weighted sums for crosswalk 
temp <- ltdb %>% inner_join( 
  acs_09 %>% subset(!(variable %in% meds )), 
  by = c("trtid00"="GEOID")) %>%
  mutate(estimate = estimate*weight) %>%
  group_by(trtid10, variable) %>%
  summarise(estimate = sum(estimate)) %>%
  rename(GEOID = trtid10) %>% 
  mutate(estimate = round(estimate, digits = 2))


#Calculate adjusted weights, to create more accurate median estimates
ltdb <- ltdb %>%     
  group_by(trtid10) %>%
  mutate(sum = sum(weight)) %>%
  mutate(adjusted_weight = weight/sum) %>%
  rename(GEOID = trtid10)

# weighted averages for median values crosswalked
temp_meds <- ltdb %>% inner_join( 
  acs_09 %>% subset((variable %in% meds)), 
  by = c("trtid00"="GEOID")) %>% mutate(
    adjusted_estimate = estimate*adjusted_weight) %>%
  dplyr::group_by(GEOID, variable) %>% 
  summarise(estimate = sum(adjusted_estimate))%>% 
  mutate(estimate = round(estimate, digits = 2))


acs_09_full <- rbind(temp, temp_meds)


census_wide09 <- acs_09_full %>% 
  ungroup() %>%
  select(GEOID, variable, estimate) %>%
  spread(variable, estimate, fill = NA) %>% 
  mutate(year = 2009)
 

census_wide14 <- acs_14 %>%
  ungroup() %>%
  select(GEOID, variable, estimate) %>%
  spread(variable, estimate, fill = NA)

census_wide19 <- acs_19 %>%
  ungroup() %>%
  select(GEOID, variable, estimate) %>%
  spread(variable, estimate, fill = NA)



##########################################################################
# Inflation Adujstment 
##########################################################################

# change in rent 
# change in income
# Change in 


CPI_09_19 = 1.20
CPI_14_19 = 1.08

vars09 <-  c( 'homeval_lower_quartile', 'homeval_med', 'homeval_upper_quartile', 'medinc', 'med_rent')
vars14 <- c( 'homeval_lower_quartile', 'homeval_med', 'homeval_upper_quartile', 'medinc', 'med_rent')

acs_09 <- 
  census_wide09 %>%
  mutate(
    across(
      # select selected columns
      .cols = vars09,
      # find value of data multiplied by weight
      ~ . * CPI_09_19,
      # attach name in the following pattern
    )
  ) 


acs_14 <- 
  census_wide14 %>%
  mutate(
    across(
      # select selected Census/ACS data (defaults to everything)
      .cols = vars14,
      # find value of data multiplied by weight
      ~ . * CPI_14_19,
      # attach name in the following pattern
    )
  ) 




#######################################################################
###### Manipulating Columns  ##########################################
#######################################################################


acs_09_calc <- 
  acs_09 %>% 
  mutate(
    ba_higher = ba_higher_1 + ba_higher_2 + ba_higher_3 + ba_higher_4 + ba_higher_5 + ba_higher_6 + ba_higher_7 + ba_higher_8,
    ma_higher = ma_higher_1 + ma_higher_2 + ma_higher_3 + ma_higher_4 + ma_higher_5 + ma_higher_6,
    below_hs = below_hs_1 + below_hs_2 + below_hs_3 + below_hs_4 + below_hs_5 + below_hs_6 + below_hs_7 + below_hs_8, 
    some_college = some_college_1 + some_college_2 + some_college_3 + some_college_4 + some_college_5 + some_college_6,
    highschool = highschool_1 + highschool_2,
    hh_5_more_person_fam = hh_5_more_fam_1 + hh_5_more_fam_2 + hh_5_more_fam_3,
    hh_4_more_person_nonfam = hh_4_more_person_nonfam_1 + hh_4_more_person_nonfam_2 + hh_4_more_person_nonfam_3 + hh_4_more_person_nonfam_4,
    rent_burden = rent_burden_1 + rent_burden_2 + rent_burden_3 + rent_burden_4,
    unemployment = unemployment_1 + unemployment_2 + unemployment_3 + unemployment_4 + unemployment_5 + unemployment_6 + unemployment_7 + unemployment_8 + 
                    unemployment_9 + unemployment_10 + unemployment_10 + unemployment_11 + unemployment_12 + unemployment_13 + unemployment_14 + unemployment_15 + 
                    unemployment_16 + unemployment_17 + unemployment_18 + unemployment_19 + unemployment_20 + unemployment_21 + unemployment_22 + unemployment_23 + 
                    unemployment_24 + unemployment_25+ unemployment_25 + unemployment_26, 
    punemployment = unemployment/totpop16over,
    doctorate = doctorate_1 + doctorate_2,
    overcrowdedunits_own = ownocc_1.5to2_per_room +ownocc_1to1.5_per_room + ownocc_2more_per_room,
    overcrowdedunits_rent = rentocc_1.5to2_per_room +rentocc_1to1.5_per_room + rentocc_2more_per_room,
    otherrace = race2+ amind+ pacis +other,
    h_units_1 = h_units_1_detached + h_units_1_attached,
    h_units_2to4 = h_units_2 + h_units_3or4,
    h_units_5to19 = h_units_5to9 + h_units_10to19,
    h_units_20more = h_units_20to49 + h_units_50more,
    h_units_other = h_units_MH + h_units_BoatRV,
    h_units_mortgage_30more = h_units_w_mortgage_30_35perc + h_units_w_mortgage_35_40perc + h_units_w_mortgage_40_50perc + h_units_w_mortgage_50moreperc,
    built_1969orbefore = built_1939_before +built_1940_1949 + built_1950_1959 + built_1960_1969,
    built_1970to1999 = built_1970_1979 + built_1980_1989 + built_1990_1999,
    built_2000orafter = built_2000_2004 + built_2005_on,
    enrolled_collegeorgrad = enrolled_grad + enrolled_undergrad,
    abroad_diffstate = abroad + diff_state,
    family_hh_no_spouse_present = family_hh_male_no_spouse_present + family_hh_female_no_spouse_present, 
    income_less_10k_Other =  income_less_10k_all - ( income_less_10k_WhiteNonHisp + income_less_10k_Asian  +income_less_10k_Black + income_less_10k_Latinx) , 
    income_10k_15k_Other =  income_10k_15k_all - (   income_10k_15k_WhiteNonHisp + income_10k_15k_Asian   + income_10k_15k_Black +   income_10k_15k_Latinx) , 
    income_15k_20k_Other =  income_15k_20k_all - (   income_15k_20k_WhiteNonHisp + income_15k_20k_Asian   + income_15k_20k_Black +   income_15k_20k_Latinx) , 
    income_20k_25k_Other =  income_20k_25k_all - (   income_20k_25k_WhiteNonHisp + income_20k_25k_Asian   + income_20k_25k_Black +   income_20k_25k_Latinx) , 
    income_25k_30k_Other =  income_25k_30k_all - (   income_25k_30k_WhiteNonHisp + income_25k_30k_Asian   + income_25k_30k_Black +   income_25k_30k_Latinx) , 
    income_30k_35k_Other =  income_30k_35k_all - (   income_30k_35k_WhiteNonHisp + income_30k_35k_Asian   + income_30k_35k_Black +   income_30k_35k_Latinx) ,
    income_35k_40k_Other =  income_35k_40k_all - (   income_35k_40k_WhiteNonHisp + income_35k_40k_Asian   + income_35k_40k_Black +   income_35k_40k_Latinx) , 
    income_40k_45k_Other =  income_40k_45k_all - (   income_40k_45k_WhiteNonHisp + income_40k_45k_Asian   + income_40k_45k_Black +   income_40k_45k_Latinx) , 
    income_45k_50k_Other =  income_45k_50k_all - (   income_45k_50k_WhiteNonHisp + income_45k_50k_Asian   + income_45k_50k_Black +   income_45k_50k_Latinx) , 
    income_50k_60k_Other =  income_50k_60k_all - (   income_50k_60k_WhiteNonHisp + income_50k_60k_Asian   + income_50k_60k_Black +   income_50k_60k_Latinx) , 
    income_60k_75k_Other =  income_60k_75k_all - (   income_60k_75k_WhiteNonHisp + income_60k_75k_Asian   + income_60k_75k_Black +   income_60k_75k_Latinx) , 
    income_75k_100k_Other = income_75k_100k_all - (  income_75k_100k_WhiteNonHisp + income_75k_100k_Asian  +income_75k_100k_Black + income_75k_100k_Latinx) , 
    income_100k_125k_Other = income_100k_125k_all - (income_100k_125k_WhiteNonHisp + income_100k_125k_Asian + income_100k_125k_Black+ income_100k_125k_Latinx) ,  
    income_125k_150k_Other = income_125k_150k_all - (income_125k_150k_WhiteNonHisp + income_125k_150k_Asian + income_125k_150k_Black+ income_125k_150k_Latinx) , 
    income_150k_200k_Other = income_150k_200k_all - (income_150k_200k_WhiteNonHisp + income_150k_200k_Asian + income_150k_200k_Black+ income_150k_200k_Latinx) , 
    income_200k_more_Other = income_200k_more_all - (income_200k_more_WhiteNonHisp + income_200k_more_Asian + income_200k_more_Black+ income_200k_more_Latinx) ,
    limited_english = eng_notverywell_1 + eng_notverywell_2 + eng_notverywell_3+ eng_notverywell_4 + eng_notverywell_5 + eng_notverywell_6 + eng_notverywell_7 + 
                      eng_notverywell_8+ eng_notverywell_9+eng_notverywell_10 + eng_notverywell_11 + eng_notverywell_12 + eng_notverywell_13 + eng_notverywell_14 + 
                      eng_notverywell_15+eng_notverywell_16+eng_notverywell_17+eng_notverywell_18+eng_notverywell_19+eng_notverywell_20+eng_notverywell_21+eng_notverywell_22+
                      eng_notverywell_23+eng_notverywell_24+eng_notverywell_25+eng_notverywell_26+eng_notverywell_27+eng_notverywell_29+eng_notverywell_30+eng_notverywell_31+
                      eng_notverywell_32+eng_notverywell_33+eng_notverywell_34+eng_notverywell_35+eng_notverywell_36+eng_notverywell_37+eng_notverywell_38,
    across(c(white, asian, black, latinx, otherrace, within_state,
            within_county, abroad_diffstate, totpop25over, adult_pop, limited_english, only_english, enrolled_collegeorgrad), ~ .x/population, .names = "p{.col}" ), 
    across(c(built_1969orbefore, built_1970to1999, built_2000orafter, h_units_1, h_units_2to4,
            h_units_5to19, h_units_20more,h_units_other, h_units_mortgage_30more ), ~ .x/totalunits, .names = "p{.col}" ), 
    across(c(rent_burden, overcrowdedunits_rent), ~ .x/renterp, .names = "p{.col}" ), 
    across(c(h_units_mortgage_30more, overcrowdedunits_own), ~ .x/ownerp, .names = "p{.col}" ),
    across(c(
            # All
            income_less_10k_all, income_10k_15k_all, income_15k_20k_all, income_20k_25k_all, income_25k_30k_all, income_30k_35k_all,
            income_35k_40k_all, income_40k_45k_all, income_45k_50k_all, income_50k_60k_all, income_60k_75k_all, 
            income_75k_100k_all, income_100k_125k_all,  income_125k_150k_all, income_150k_200k_all, income_200k_more_all,
            # Black
            income_less_10k_Black, income_10k_15k_Black, income_15k_20k_Black, income_20k_25k_Black, income_25k_30k_Black, income_30k_35k_Black,
            income_35k_40k_Black, income_40k_45k_Black, income_45k_50k_Black, income_50k_60k_Black, income_60k_75k_Black, 
            income_75k_100k_Black, income_100k_125k_Black,  income_125k_150k_Black, income_150k_200k_Black, income_200k_more_Black,
            # Asian
            income_less_10k_Asian, income_10k_15k_Asian, income_15k_20k_Asian, income_20k_25k_Asian, income_25k_30k_Asian, income_30k_35k_Asian,
            income_35k_40k_Asian, income_40k_45k_Asian, income_45k_50k_Asian, income_50k_60k_Asian, income_60k_75k_Asian, 
            income_75k_100k_Asian, income_100k_125k_Asian,  income_125k_150k_Asian, income_150k_200k_Asian, income_200k_more_Asian,
            # Latinx
            income_less_10k_Latinx, income_10k_15k_Latinx, income_15k_20k_Latinx, income_20k_25k_Latinx, income_25k_30k_Latinx, income_30k_35k_Latinx,
            income_35k_40k_Latinx, income_40k_45k_Latinx, income_45k_50k_Latinx, income_50k_60k_Latinx, income_60k_75k_Latinx, 
            income_75k_100k_Latinx, income_100k_125k_Latinx,  income_125k_150k_Latinx, income_150k_200k_Latinx, income_200k_more_Latinx,
            # Non Hispanic White 
            income_less_10k_WhiteNonHisp, income_10k_15k_WhiteNonHisp, income_15k_20k_WhiteNonHisp,  income_20k_25k_WhiteNonHisp, income_25k_30k_WhiteNonHisp, income_30k_35k_WhiteNonHisp,
            income_35k_40k_WhiteNonHisp, income_40k_45k_WhiteNonHisp, income_45k_50k_WhiteNonHisp, income_50k_60k_WhiteNonHisp, income_60k_75k_WhiteNonHisp, 
            income_75k_100k_WhiteNonHisp, income_100k_125k_WhiteNonHisp,  income_125k_150k_WhiteNonHisp, income_150k_200k_WhiteNonHisp, income_200k_more_WhiteNonHisp,
            # End
            hh_2_person_fam, hh_3_person_fam, hh_4_person_fam, hh_5_more_person_fam, hh_1_person, 
            hh_2_person_nonfam, hh_3_person_nonfam, hh_4_more_person_nonfam, children, seniors, 
            total_family_hh, total_nonfamily_hh, family_hh_no_spouse_present,
            family_hh_female_no_spouse_present_wchildren, family_hh_male_no_spouse_present_wchildren, welfare, 
            family_hh_married_couple, nonfamily_hh_not_living_alone,  nonfamily_hh_living_alone, renterp, ownerp), ~ .x/hh_count, .names = "p{.col}" ),
    across(c(ba_higher, ma_higher, highschool, below_hs, some_college, doctorate), ~ .x/totpop25over, .names = "p{.col}" ),
    COUNTY = substr(GEOID, 1, 5),
    year = '2009')  %>% 
    rename( 'p_renter' = 'prenterp',
            'p_owner' = 'pownerp') %>%
    mutate("ownocc_rentburden_20k_35k" = NA,  "ownocc_rentburden_35k_50k" = NA,                                                                                                                              
    "ownocc_rentburden_50k_75k" = NA,   "ownocc_rentburden_75kmore" = NA,                                                                                                                             
    "ownocc_rentburden_less20k" = NA,   "rentocc_rentburden_20k_35k" = NA,                                                                                                                             
    "rentocc_rentburden_35k_50k" = NA,  "rentocc_rentburden_50k_75k" = NA,                                                                                                                             
    "rentocc_rentburden_75kmore" = NA,  "rentocc_rentburden_less20k" = NA,                                                                                                                             
    "prentocc_rentburden_less20k" = NA, "prentocc_rentburden_20k_35k" = NA,                                                                                                                            
    "prentocc_rentburden_35k_50k" = NA, "prentocc_rentburden_50k_75k" = NA,                                                                                                                            
    "prentocc_rentburden_75kmore" = NA, "pownocc_rentburden_less20k" = NA,                                                                                                                             
    "pownocc_rentburden_20k_35k" = NA,  "pownocc_rentburden_35k_50k" = NA,                                                                                                                             
    "pownocc_rentburden_50k_75k" = NA,  "pownocc_rentburden_75kmore" = NA) 


acs_14_calc <-
  acs_14 %>% 
  mutate(
    below_hs = below_hs_1 + below_hs_2, 
    some_college = some_college_1 + some_college_2,
    hh_5_more_person_fam = hh_5_more_fam_1 + hh_5_more_fam_2 + hh_5_more_fam_3,
    hh_4_more_person_nonfam = hh_4_more_person_nonfam_1 + hh_4_more_person_nonfam_2 + hh_4_more_person_nonfam_3 + hh_4_more_person_nonfam_4,
    rent_burden = rent_burden_1 + rent_burden_2 + rent_burden_3 + rent_burden_4,
    otherrace = race2+ amind+ pacis+other,
    h_units_1 = h_units_1_detached + h_units_1_attached,
    h_units_2to4 = h_units_2 + h_units_3or4,
    h_units_5to19 = h_units_5to9 + h_units_10to19,
    h_units_20more = h_units_20to49 + h_units_50more,
    h_units_other = h_units_MH + h_units_BoatRV,
    h_units_mortgage_30more = h_units_w_mortgage_30_35perc + h_units_w_mortgage_35_40perc + h_units_w_mortgage_40_50perc + h_units_w_mortgage_50moreperc,
    overcrowdedunits_own = ownocc_1.5to2_per_room +ownocc_1to1.5_per_room + ownocc_2more_per_room,
    overcrowdedunits_rent = rentocc_1.5to2_per_room +rentocc_1to1.5_per_room + rentocc_2more_per_room,
    built_1969orbefore = built_1939_before +built_1940_1949 + built_1950_1959 + built_1960_1969,
    built_1970to1999 = built_1970_1979 + built_1980_1989 + built_1990_1999,
    built_2000orafter = built_2000_2004 + built_2005_on,
    enrolled_collegeorgrad = enrolled_grad + enrolled_undergrad,
    abroad_diffstate = abroad + diff_state,
    limited_english = spanish_english_notverywell + otherlang_english_notverywell,
    family_hh_no_spouse_present = family_hh_male_no_spouse_present + family_hh_female_no_spouse_present,
    income_less_10k_Other =  income_less_10k_all - ( income_less_10k_WhiteNonHisp + income_less_10k_Asian  +income_less_10k_Black + income_less_10k_Latinx) , 
    income_10k_15k_Other =  income_10k_15k_all - (   income_10k_15k_WhiteNonHisp + income_10k_15k_Asian   + income_10k_15k_Black +   income_10k_15k_Latinx) , 
    income_15k_20k_Other =  income_15k_20k_all - (   income_15k_20k_WhiteNonHisp + income_15k_20k_Asian   + income_15k_20k_Black +   income_15k_20k_Latinx) ,
    income_20k_25k_Other =  income_20k_25k_all - (   income_20k_25k_WhiteNonHisp + income_20k_25k_Asian   + income_20k_25k_Black +   income_20k_25k_Latinx) , 
    income_25k_30k_Other =  income_25k_30k_all - (   income_25k_30k_WhiteNonHisp + income_25k_30k_Asian   + income_25k_30k_Black +   income_25k_30k_Latinx) , 
    income_30k_35k_Other =  income_30k_35k_all - (   income_30k_35k_WhiteNonHisp + income_30k_35k_Asian   + income_30k_35k_Black +   income_30k_35k_Latinx) ,
    income_35k_40k_Other =  income_35k_40k_all - (   income_35k_40k_WhiteNonHisp + income_35k_40k_Asian   + income_35k_40k_Black +   income_35k_40k_Latinx) , 
    income_40k_45k_Other =  income_40k_45k_all - (   income_40k_45k_WhiteNonHisp + income_40k_45k_Asian   + income_40k_45k_Black +   income_40k_45k_Latinx) , 
    income_45k_50k_Other =  income_45k_50k_all - (   income_45k_50k_WhiteNonHisp + income_45k_50k_Asian   + income_45k_50k_Black +   income_45k_50k_Latinx) , 
    income_50k_60k_Other =  income_50k_60k_all - (   income_50k_60k_WhiteNonHisp + income_50k_60k_Asian   + income_50k_60k_Black +   income_50k_60k_Latinx) , 
    income_60k_75k_Other =  income_60k_75k_all - (   income_60k_75k_WhiteNonHisp + income_60k_75k_Asian   + income_60k_75k_Black +   income_60k_75k_Latinx) , 
    income_75k_100k_Other = income_75k_100k_all - (  income_75k_100k_WhiteNonHisp + income_75k_100k_Asian  +income_75k_100k_Black + income_75k_100k_Latinx) , 
    income_100k_125k_Other = income_100k_125k_all - (income_100k_125k_WhiteNonHisp + income_100k_125k_Asian + income_100k_125k_Black+ income_100k_125k_Latinx) ,  
    income_125k_150k_Other = income_125k_150k_all - (income_125k_150k_WhiteNonHisp + income_125k_150k_Asian + income_125k_150k_Black+ income_125k_150k_Latinx) , 
    income_150k_200k_Other = income_150k_200k_all - (income_150k_200k_WhiteNonHisp + income_150k_200k_Asian + income_150k_200k_Black+ income_150k_200k_Latinx) , 
    income_200k_more_Other = income_200k_more_all - (income_200k_more_WhiteNonHisp + income_200k_more_Asian + income_200k_more_Black+ income_200k_more_Latinx) ,
    across(c(white, asian, black, latinx, otherrace, 
            totpop25over, adult_pop, limited_english, only_english, enrolled_collegeorgrad), 
           ~ .x/population, .names = "p{.col}" ), 
    across(c( within_county, within_state, children, seniors, unemployment,  ba_higher, 
             abroad_diffstate,  below_hs, some_college, ma_higher, highschool, renterp, ownerp), 
           ~ .x/100, .names = "p{.col}" ), 
    across(c(built_1969orbefore, built_1970to1999, built_2000orafter,
            h_units_1, h_units_2to4,
            h_units_5to19, h_units_20more,h_units_other),
           ~ .x/totalunits, .names = "p{.col}" ), 
    across(c(rent_burden, overcrowdedunits_rent, rentocc_rentburden_less20k, rentocc_rentburden_20k_35k, 
             rentocc_rentburden_35k_50k, rentocc_rentburden_50k_75k ,rentocc_rentburden_75kmore ),
           ~ .x/renter_count, .names = "p{.col}" ), 
    across(c(h_units_mortgage_30more, overcrowdedunits_own, ownocc_rentburden_less20k, 
             ownocc_rentburden_20k_35k ,ownocc_rentburden_35k_50k, ownocc_rentburden_50k_75k, 
             ownocc_rentburden_75kmore), 
           ~ .x/owner_count, .names = "p{.col}" ),
    across(c(# All
      income_less_10k_all, income_10k_15k_all, income_15k_20k_all, income_20k_25k_all, income_25k_30k_all, income_30k_35k_all,
      income_35k_40k_all, income_40k_45k_all, income_45k_50k_all, income_50k_60k_all, income_60k_75k_all, 
      income_75k_100k_all, income_100k_125k_all,  income_125k_150k_all, income_150k_200k_all, income_200k_more_all,
      # Black
      income_less_10k_Black, income_10k_15k_Black, income_15k_20k_Black, income_20k_25k_Black, income_25k_30k_Black, income_30k_35k_Black,
      income_35k_40k_Black, income_40k_45k_Black, income_45k_50k_Black, income_50k_60k_Black, income_60k_75k_Black, 
      income_75k_100k_Black, income_100k_125k_Black,  income_125k_150k_Black, income_150k_200k_Black, income_200k_more_Black,
      # Asian
      income_less_10k_Asian, income_10k_15k_Asian, income_15k_20k_Asian, income_20k_25k_Asian, income_25k_30k_Asian, income_30k_35k_Asian,
      income_35k_40k_Asian, income_40k_45k_Asian, income_45k_50k_Asian, income_50k_60k_Asian, income_60k_75k_Asian, 
      income_75k_100k_Asian, income_100k_125k_Asian,  income_125k_150k_Asian, income_150k_200k_Asian, income_200k_more_Asian,
      # Latinx
      income_less_10k_Latinx, income_10k_15k_Latinx, income_15k_20k_Latinx, income_20k_25k_Latinx, income_25k_30k_Latinx, income_30k_35k_Latinx,
      income_35k_40k_Latinx, income_40k_45k_Latinx, income_45k_50k_Latinx, income_50k_60k_Latinx, income_60k_75k_Latinx, 
      income_75k_100k_Latinx, income_100k_125k_Latinx,  income_125k_150k_Latinx, income_150k_200k_Latinx, income_200k_more_Latinx,
      # Non Hispanic White 
      income_less_10k_WhiteNonHisp, income_10k_15k_WhiteNonHisp, income_15k_20k_WhiteNonHisp,  income_20k_25k_WhiteNonHisp, income_25k_30k_WhiteNonHisp, income_30k_35k_WhiteNonHisp,
      income_35k_40k_WhiteNonHisp, income_40k_45k_WhiteNonHisp, income_45k_50k_WhiteNonHisp, income_50k_60k_WhiteNonHisp, income_60k_75k_WhiteNonHisp, 
      income_75k_100k_WhiteNonHisp, income_100k_125k_WhiteNonHisp,  income_125k_150k_WhiteNonHisp, income_150k_200k_WhiteNonHisp, income_200k_more_WhiteNonHisp,
      # End
      hh_2_person_fam, hh_3_person_fam, hh_4_person_fam, hh_5_more_person_fam, hh_1_person, 
      hh_2_person_nonfam, hh_3_person_nonfam, hh_4_more_person_nonfam,
      total_family_hh, total_nonfamily_hh, family_hh_no_spouse_present,
      family_hh_female_no_spouse_present_wchildren, family_hh_male_no_spouse_present_wchildren, welfare, 
      family_hh_married_couple, nonfamily_hh_not_living_alone, nonfamily_hh_living_alone), 
           ~ .x/hh_count, .names = "p{.col}" ),
    across(c(doctorate), ~ .x/totpop25over, .names = "p{.col}" ),
    COUNTY = substr(GEOID, 1, 5),
    year = '2014')  %>% 
    rename( 'p_renter' = 'prenterp',
            'p_owner' = 'pownerp')


acs_19_calc <- 
  census_wide19 %>% 
  mutate(
    below_hs = below_hs_1 + below_hs_2, 
    some_college = some_college_1 + some_college_2,
    hh_5_more_person_fam = hh_5_more_fam_1 + hh_5_more_fam_2 + hh_5_more_fam_3,
    hh_4_more_person_nonfam = hh_4_more_person_nonfam_1 + hh_4_more_person_nonfam_2 + hh_4_more_person_nonfam_3 + hh_4_more_person_nonfam_4,
    rent_burden = rent_burden_1 + rent_burden_2 + rent_burden_3 + rent_burden_4,
    limited_english = spanish_english_notverywell + otherlang_english_notverywell,
    otherrace = race2+ amind+ pacis+other,
    h_units_1 = h_units_1_detached + h_units_1_attached,
    h_units_2to4 = h_units_2 + h_units_3or4,
    h_units_5to19 = h_units_5to9 + h_units_10to19,
    h_units_20more = h_units_20to49 + h_units_50more,
    h_units_other = h_units_MH + h_units_BoatRV,
    h_units_mortgage_30more = h_units_w_mortgage_30_35perc + h_units_w_mortgage_35_40perc + h_units_w_mortgage_40_50perc + h_units_w_mortgage_50moreperc,
    built_1969orbefore = built_1939_before +built_1940_1949 + built_1950_1959 + built_1960_1969,
    built_1970to1999 = built_1970_1979 + built_1980_1989 + built_1990_1999,
    built_2000orafter = built_2000_2004 + built_2005_on,
    overcrowdedunits_own = ownocc_1.5to2_per_room +ownocc_1to1.5_per_room + ownocc_2more_per_room,
    enrolled_collegeorgrad = enrolled_grad + enrolled_undergrad,
    abroad_diffstate = abroad + diff_state,
    overcrowdedunits_rent = rentocc_1.5to2_per_room +rentocc_1to1.5_per_room + rentocc_2more_per_room,
    family_hh_no_spouse_present = family_hh_male_no_spouse_present + family_hh_female_no_spouse_present,
    income_less_10k_Other =  income_less_10k_all - ( income_less_10k_WhiteNonHisp + income_less_10k_Asian  +income_less_10k_Black + income_less_10k_Latinx) , 
    income_10k_15k_Other =  income_10k_15k_all - (   income_10k_15k_WhiteNonHisp + income_10k_15k_Asian   + income_10k_15k_Black +   income_10k_15k_Latinx) , 
    income_15k_20k_Other =  income_15k_20k_all - (   income_15k_20k_WhiteNonHisp + income_15k_20k_Asian   + income_15k_20k_Black +   income_15k_20k_Latinx) , 
    income_20k_25k_Other =  income_20k_25k_all - (   income_20k_25k_WhiteNonHisp + income_20k_25k_Asian   + income_20k_25k_Black +   income_20k_25k_Latinx) , 
    income_25k_30k_Other =  income_25k_30k_all - (   income_25k_30k_WhiteNonHisp + income_25k_30k_Asian   + income_25k_30k_Black +   income_25k_30k_Latinx) , 
    income_30k_35k_Other =  income_30k_35k_all - (   income_30k_35k_WhiteNonHisp + income_30k_35k_Asian   + income_30k_35k_Black +   income_30k_35k_Latinx) ,
    income_35k_40k_Other =  income_35k_40k_all - (   income_35k_40k_WhiteNonHisp + income_35k_40k_Asian   + income_35k_40k_Black +   income_35k_40k_Latinx) , 
    income_40k_45k_Other =  income_40k_45k_all - (   income_40k_45k_WhiteNonHisp + income_40k_45k_Asian   + income_40k_45k_Black +   income_40k_45k_Latinx) , 
    income_45k_50k_Other =  income_45k_50k_all - (   income_45k_50k_WhiteNonHisp + income_45k_50k_Asian   + income_45k_50k_Black +   income_45k_50k_Latinx) , 
    income_50k_60k_Other =  income_50k_60k_all - (   income_50k_60k_WhiteNonHisp + income_50k_60k_Asian   + income_50k_60k_Black +   income_50k_60k_Latinx) , 
    income_60k_75k_Other =  income_60k_75k_all - (   income_60k_75k_WhiteNonHisp + income_60k_75k_Asian   + income_60k_75k_Black +   income_60k_75k_Latinx) , 
    income_75k_100k_Other = income_75k_100k_all - (  income_75k_100k_WhiteNonHisp + income_75k_100k_Asian  +income_75k_100k_Black + income_75k_100k_Latinx) , 
    income_100k_125k_Other = income_100k_125k_all - (income_100k_125k_WhiteNonHisp + income_100k_125k_Asian + income_100k_125k_Black+ income_100k_125k_Latinx) ,  
    income_125k_150k_Other = income_125k_150k_all - (income_125k_150k_WhiteNonHisp + income_125k_150k_Asian + income_125k_150k_Black+ income_125k_150k_Latinx) , 
    income_150k_200k_Other = income_150k_200k_all - (income_150k_200k_WhiteNonHisp + income_150k_200k_Asian + income_150k_200k_Black+ income_150k_200k_Latinx) , 
    income_200k_more_Other = income_200k_more_all - (income_200k_more_WhiteNonHisp + income_200k_more_Asian + income_200k_more_Black+ income_200k_more_Latinx) ,
    across(c(white, asian, black, latinx, otherrace, totpop25over, adult_pop, limited_english, only_english, enrolled_collegeorgrad), 
           ~ .x/population, .names = "p{.col}" ), 
    across(c(children, within_state, within_county, seniors, unemployment, 
             ba_higher, ma_higher, abroad_diffstate, highschool, below_hs, some_college, renterp, ownerp ), 
           ~ .x/100, .names = "p{.col}" ), 
    across(c(built_1969orbefore, built_1970to1999, built_2000orafter, h_units_1, h_units_2to4,
            h_units_5to19, h_units_20more, h_units_other),
          ~ .x/totalunits, .names = "p{.col}" ), 
    across(c(rent_burden, overcrowdedunits_rent, rentocc_rentburden_less20k, 
             rentocc_rentburden_20k_35k, rentocc_rentburden_35k_50k, rentocc_rentburden_50k_75k,
             rentocc_rentburden_75kmore), 
           ~ .x/renter_count, .names = "p{.col}" ), 
    across(c(h_units_mortgage_30more, overcrowdedunits_own, ownocc_rentburden_less20k, ownocc_rentburden_20k_35k, 
             ownocc_rentburden_35k_50k, ownocc_rentburden_50k_75k ,ownocc_rentburden_75kmore), 
           ~ .x/owner_count, .names = "p{.col}" ),
    across(c(# All
      income_less_10k_all, income_10k_15k_all, income_15k_20k_all, income_20k_25k_all, income_25k_30k_all, income_30k_35k_all,
      income_35k_40k_all, income_40k_45k_all, income_45k_50k_all, income_50k_60k_all, income_60k_75k_all, 
      income_75k_100k_all, income_100k_125k_all,  income_125k_150k_all, income_150k_200k_all, income_200k_more_all,
      # Black
      income_less_10k_Black, income_10k_15k_Black, income_15k_20k_Black, income_20k_25k_Black, income_25k_30k_Black, income_30k_35k_Black,
      income_35k_40k_Black, income_40k_45k_Black, income_45k_50k_Black, income_50k_60k_Black, income_60k_75k_Black, 
      income_75k_100k_Black, income_100k_125k_Black,  income_125k_150k_Black, income_150k_200k_Black, income_200k_more_Black,
      # Asian
      income_less_10k_Asian, income_10k_15k_Asian, income_15k_20k_Asian, income_20k_25k_Asian, income_25k_30k_Asian, income_30k_35k_Asian,
      income_35k_40k_Asian, income_40k_45k_Asian, income_45k_50k_Asian, income_50k_60k_Asian, income_60k_75k_Asian, 
      income_75k_100k_Asian, income_100k_125k_Asian,  income_125k_150k_Asian, income_150k_200k_Asian, income_200k_more_Asian,
      # Latinx
      income_less_10k_Latinx, income_10k_15k_Latinx, income_15k_20k_Latinx, income_20k_25k_Latinx, income_25k_30k_Latinx, income_30k_35k_Latinx,
      income_35k_40k_Latinx, income_40k_45k_Latinx, income_45k_50k_Latinx, income_50k_60k_Latinx, income_60k_75k_Latinx, 
      income_75k_100k_Latinx, income_100k_125k_Latinx,  income_125k_150k_Latinx, income_150k_200k_Latinx, income_200k_more_Latinx,
      # Non Hispanic White 
      income_less_10k_WhiteNonHisp, income_10k_15k_WhiteNonHisp, income_15k_20k_WhiteNonHisp,  income_20k_25k_WhiteNonHisp, income_25k_30k_WhiteNonHisp, income_30k_35k_WhiteNonHisp,
      income_35k_40k_WhiteNonHisp, income_40k_45k_WhiteNonHisp, income_45k_50k_WhiteNonHisp, income_50k_60k_WhiteNonHisp, income_60k_75k_WhiteNonHisp, 
      income_75k_100k_WhiteNonHisp, income_100k_125k_WhiteNonHisp,  income_125k_150k_WhiteNonHisp, income_150k_200k_WhiteNonHisp, income_200k_more_WhiteNonHisp,
      # End
      hh_2_person_fam, hh_3_person_fam, hh_4_person_fam, hh_5_more_person_fam, hh_1_person, 
      hh_2_person_nonfam, hh_3_person_nonfam, hh_4_more_person_nonfam,
      total_family_hh, total_nonfamily_hh, family_hh_no_spouse_present,
      family_hh_female_no_spouse_present_wchildren, family_hh_male_no_spouse_present_wchildren, welfare, 
      family_hh_married_couple, nonfamily_hh_not_living_alone, nonfamily_hh_living_alone), 
           ~ .x/hh_count, .names = "p{.col}" ),
    across(c( doctorate), ~ .x/totpop25over, .names = "p{.col}" ),
    COUNTY = substr(GEOID, 1, 5),
    year = '2019') %>% 
    rename( 'p_renter' = 'prenterp',
            'p_owner' = 'pownerp')

#########################################################################
### Drop component Variables ############################################
#########################################################################


drop09 <- c( "Group.1", "ma_higher_1", "cbsa10","metdiv10","ccflag10","changetype", "ma_higher_2", "ma_higher_3", 
             "ma_higher_4", "ma_higher_5", "ma_higher_6",  "totpop16over", 'ownerp', 'renterp',
             "some_college_1", "some_college_2", "some_college_3", "some_college_4", "some_college_5",
             "some_college_6", "ba_higher_1", "ba_higher_2" ,"ba_higher_3", "ba_higher_4", "ba_higher_5",
             "ba_higher_6",  "ba_higher_7", "ba_higher_8", "below_hs_1", "below_hs_2", "below_hs_3",
             "below_hs_4", "below_hs_5", "below_hs_6", "below_hs_7", "below_hs_8", "highschool_1" , 
             "highschool_2", "hh_4_more_person_nonfam_1","hh_4_more_person_nonfam_2", "hh_4_more_person_nonfam_3",
             "hh_4_more_person_nonfam_4", "hh_5_more_fam_1","hh_5_more_fam_2", "hh_5_more_fam_3", "rent_burden_1",
             "rent_burden_2" , "rent_burden_3", "rent_burden_4", "unemployment_1", "unemployment_2","unemployment_3",
             "unemployment_4" ,"unemployment_5", "unemployment_6", "unemployment_7" ,"unemployment_8","unemployment_9", "unemployment_10",
             "unemployment_11" ,"unemployment_12" ,"unemployment_13",  "unemployment_14", "unemployment_15", "unemployment_16" ,"unemployment_17",
             "unemployment_18" , "unemployment_19" ,"unemployment_20" ,"unemployment_21", "unemployment_22" , 'diff_state', "unemployment_23" , "unemployment_24",
             "unemployment_25" , "unemployment_26" , "trtid00.y"  , "trtid00.x", "weight", "placefp10" , 'doctorate_1',  'doctorate_2',
             'eng_notverywell_1', 'eng_notverywell_2','eng_notverywell_3','eng_notverywell_4','eng_notverywell_5', 'eng_notverywell_6', 'eng_notverywell_7','eng_notverywell_8', 'eng_notverywell_9',
             'eng_notverywell_10',  'eng_notverywell_11', 'eng_notverywell_12', 'eng_notverywell_13', 'eng_notverywell_14' , 'eng_notverywell_15','eng_notverywell_16','eng_notverywell_17',
             'eng_notverywell_18', 'eng_notverywell_19', 'eng_notverywell_20', 'eng_notverywell_21', 'eng_notverywell_22', 'eng_notverywell_23',
             'eng_notverywell_24', 'eng_notverywell_25', 'eng_notverywell_26', 'eng_notverywell_27', 'eng_notverywell_28', 'eng_notverywell_29','eng_notverywell_30', 'eng_notverywell_31', 
             'eng_notverywell_32','eng_notverywell_33','eng_notverywell_34','eng_notverywell_35','eng_notverywell_36','eng_notverywell_37','eng_notverywell_38',
             'h_units_1_detached' ,'h_units_1_attached' ,'h_units_2' ,'h_units_3or4' ,'h_units_5to9' ,'h_units_10to19' ,'h_units_20to49' ,'h_units_50more' ,'h_units_MH' ,'h_units_BoatRV',
             'h_units_w_mortgage_30_35perc', 'h_units_w_mortgage_35_40perc', 'h_units_w_mortgage_40_50perc', 'h_units_w_mortgage_50moreperc'
         )

    # built_1939_before +built_1940_1949 + built_1950_1959 + built_1960_1969, built_1970_1979 + built_1980_1989 + built_1990_1999, built_2000_2004 + built_2005_on,
    #          enrolled_grad + enrolled_undergrad, abroad + diff_state,  h_units_1_detached + h_units_1_attached 

acs_09_clean = acs_09_calc[,!(names(acs_09_calc) %in% drop09)]

drop14_19 <- c(  "ma_higher_1", "ma_higher_2", "ma_higher_3", "ma_higher_4", "ma_higher_5", "ma_higher_6", 
              "some_college_1", "some_college_2", "some_college_3", "some_college_4", "some_college_5",
              "some_college_6", "ba_higher_1", "ba_higher_2" ,"ba_higher_3", "ba_higher_4", "ba_higher_5",
              "ba_higher_6", "ba_higher_7", "ba_higher_8", "below_hs_1", "below_hs_2", "below_hs_3",
              "below_hs_4", "below_hs_5", "below_hs_6", "below_hs_7",  "NAM", "owner_count", "renter_count", 
              "below_hs_8", "highschool_1" , 'diff_state','ownerp', 'renterp',
              "highschool_2", "hh_4_more_person_nonfam_1","hh_4_more_person_nonfam_2", "hh_4_more_person_nonfam_3",
              "hh_4_more_person_nonfam_4", "hh_5_more_fam_1","hh_5_more_fam_2", "hh_5_more_fam_3", "rent_burden_1",
              "rent_burden_2" , "rent_burden_3", "rent_burden_4", "unemployment_1", "unemployment_2","unemployment_3",
              "unemployment_4" ,"unemployment_5", "unemployment_6", "unemployment_7" ,"unemployment_8","unemployment_9", "unemployment_10",
              "unemployment_11" ,"unemployment_12" ,"unemployment_13",  "unemployment_14", "unemployment_15", "unemployment_16" ,"unemployment_17",
              "unemployment_18" , "unemployment_19" ,"unemployment_20" ,"unemployment_21", "unemployment_22" , "unemployment_23" , "unemployment_24",
              "unemployment_25" , "unemployment_26", 'spanish_english_notverywell', 'otherlang_english_notverywell',
              'h_units_1_detached' ,'h_units_1_attached' ,'h_units_2' ,'h_units_3or4' ,'h_units_5to9' ,'h_units_10to19' ,'h_units_20to49' ,'h_units_50more' ,'h_units_MH' ,'h_units_BoatRV',
              'h_units_w_mortgage_30_35perc', 'h_units_w_mortgage_35_40perc', 'h_units_w_mortgage_40_50perc', 'h_units_w_mortgage_50moreperc'  )

acs_14_clean = acs_14_calc[,!(names(acs_14_calc) %in% drop14_19)]


acs_19_clean = acs_19_calc[,!(names(acs_19_calc) %in% drop14_19)]



#######################################################################
###### Income Interpolation  ##########################################
#######################################################################



# ==========================================================================
# Curate HH income group dataset
# ==========================================================================

#
# vector of income groups to rename values in proceeding dataframe
# --------------------------------------------------------------------------

inc_names <- c(
  'income_less_10k' = 1000, 
  'income_10k_15k' = 14999, 
  'income_15k_20k' = 19999, 
  'income_20k_25k' = 24999, 
  'income_25k_30k' = 29999, 
  'income_30k_35k' = 34999,
  'income_35k_40k' = 39999, 
  'income_40k_45k' = 44999, 
  'income_45k_50k' = 49999, 
  'income_50k_60k' = 59999,
  'income_60k_75k' = 74999,
  'income_75k_100k' = 99999,
  'income_100k_125k' = 124999,
  'income_125k_150k' = 149999,
  'income_150k_200k' = 199999,
  'income_200k_more' = 200000 
)
#
# Create income group dataframe
# --------------------------------------------------------------------------

inc_df <- data.frame(
  GEOID = character())


# rent, income, race, mvalue, prenter, pcollege, ch_pcollege, pctch_hhinc, hotmarket

# dec_00 = read.csv("C:/Users/emery/Documents/git/displacement-typologies/data/inputs/US_00_sf1_sf3.csv") %>% filter(Geo_STATE == 6)

AMI_function <- function(table, yearinput){

  df_temp <- table %>% mutate( year = as.character(year))

  #for (year in yearlist){  
    inc_df <- get_acs(geography = "county", 
                      variables = c('county_medinc' = 'B19013_001'), 
                      state = "CA",
                      year = yearinput,
                      geometry = FALSE,
                      cache_table = FALSE,
                      output = "wide",
                      key = CENSUS_API_KEY,
                      survey = "acs5") %>%
      dplyr::select(-dplyr::ends_with("M")) %>% 
      mutate(year = as.character(yearinput)
        ) 
    
    #}


  df <- df_temp %>% left_join(inc_df, by = c('COUNTY' = 'GEOID', 'year' ='year'))


  df_vli <-
    df %>% 
    select(
      GEOID,
      year, 
      COUNTY,
      county_medincE,
      income_100k_125k_all:income_less_10k_WhiteNonHisp,
      income_less_10k_Other:income_200k_more_Other,
      # income_less_10k,
      # income_10k_15k, 
      # income_15k_20k,  
      # income_20k_25k,  
      # income_25k_30k,  
      # income_30k_35k, 
      # income_35k_40k,  
      # income_40k_45k,  
      # income_45k_50k,  
      # income_50k_60k, 
      # income_60k_75k, 
      # income_75k_100k, 
      # income_100k_125k, 
      # income_125k_150k, 
      # income_150k_200k,
      # income_200k_more
      ) %>%
    group_by(COUNTY, year) %>%
    mutate(co_mhhinc = county_medincE, na.rm = TRUE,
           co_MI_val = 1.2*co_mhhinc,
           co_LI_val = .8*co_mhhinc,
           co_VLI_val = .5*co_mhhinc,
           co_ELI_val = .3*co_mhhinc) %>% 
    ungroup() %>%
    gather(medinc_cat, medinc_count, income_100k_125k_all:income_200k_more_Other) %>%
    #pivot_longer(key= medinc_cat, 
    #              values = medinc_count,  income_100k_125k_all:income_200k_more_Other) %>% 
    mutate(race = stringr::word(medinc_cat, 4, sep = "_"),
           medinc_cat = sub('_[^_]*$', '', medinc_cat),
           medinc_cat = recode(medinc_cat, !!!inc_names)) %>% 
    mutate(bottom_inccat = 
             case_when(
               medinc_cat > 0 & medinc_cat <= 49999 ~ medinc_cat - 4999,
               medinc_cat == 59999 ~ medinc_cat - 9999,
               medinc_cat == 74999 ~ medinc_cat - 14999,
               medinc_cat >= 99999 & medinc_cat <= 149999 ~ medinc_cat - 24999,
               medinc_cat == 199999 ~ medinc_cat - 49999,
               medinc_cat == 200000 ~ medinc_cat,
               # for owner and renter income
               # medinc_cat > 9999 &
               # medinc_cat <= 49999 ~ medinc_cat - 4999,
               # medinc_cat == 59999 ~ medinc_cat - 9999,
               # medinc_cat > 59999 &
               # medinc_cat <= 149999 ~ medinc_cat - 24999,
               # medinc_cat >= 199999 ~ medinc_cat - 49999,
               TRUE ~ NA_real_),
           top_inccat = medinc_cat,
           HI = case_when(
             bottom_inccat <= co_MI_val & top_inccat >= co_MI_val ~ 
               (top_inccat - co_MI_val)/(top_inccat - bottom_inccat),
             bottom_inccat >= co_MI_val ~ 1, 
             TRUE ~ 0), 
           MI = case_when(
             bottom_inccat <= co_LI_val & top_inccat >= co_LI_val ~ 
               (top_inccat - co_LI_val)/(top_inccat - bottom_inccat),
             bottom_inccat >= co_LI_val & top_inccat <= co_MI_val ~ 1, 
             bottom_inccat <= co_MI_val & top_inccat >= co_MI_val ~ 
               (co_MI_val - bottom_inccat)/(top_inccat - bottom_inccat),
             TRUE ~ 0), 
           LI = case_when(
             bottom_inccat <= co_VLI_val & top_inccat >= co_VLI_val ~ 
               (top_inccat - co_VLI_val)/(top_inccat - bottom_inccat),
             bottom_inccat >= co_VLI_val & top_inccat <= co_LI_val ~ 1, 
             bottom_inccat <= co_LI_val & top_inccat >= co_LI_val ~ 
               (co_LI_val - bottom_inccat)/(top_inccat - bottom_inccat),
             TRUE ~ 0), 
           VLI = case_when(
             bottom_inccat <= co_ELI_val & top_inccat >= co_ELI_val ~ 
               (top_inccat - co_ELI_val)/(top_inccat - bottom_inccat),
             bottom_inccat >= co_ELI_val & top_inccat <= co_VLI_val ~ 1, 
             bottom_inccat <= co_VLI_val & top_inccat >= co_VLI_val ~ 
               (co_VLI_val - bottom_inccat)/(top_inccat - bottom_inccat),
             TRUE ~ 0), 
           ELI = case_when(
             top_inccat <= co_ELI_val ~ 1, 
             bottom_inccat <= co_ELI_val & top_inccat >= co_ELI_val ~ 
               (co_ELI_val - bottom_inccat)/(top_inccat - bottom_inccat),
             TRUE ~ 0)) %>% 
    group_by(GEOID, race, year) %>%
    mutate(
      tot_hh = sum(medinc_count, na.rm = TRUE),
      High = sum(HI*medinc_count, na.rm = TRUE),
      Moderate = sum(MI*medinc_count, na.rm = TRUE),
      Low = sum(LI*medinc_count, na.rm = TRUE),
      VeryLow = sum(VLI*medinc_count, na.rm = TRUE),
      ExtremelyLow = sum(ELI*medinc_count, na.rm = TRUE)
      # tr_HI_prop = tr_HI_count/tr_totinc_count,
      # tr_MI_prop = tr_MI_count/tr_totinc_count,
      # tr_LI_prop = tr_LI_count/tr_totinc_count,
      # tr_VLI_prop = tr_VLI_count/tr_totinc_count,
      # tr_ELI_prop = tr_ELI_count/tr_totinc_count
    ) %>% 
    select(year, race, GEOID, tot_hh:ExtremelyLow) %>%
    distinct() %>% 
    gather(inc_group, num_hh, High:ExtremelyLow) %>% 
    #pivot_longer(key= inc_group, values = num_hh, High:ExtremelyLow) %>% 
    mutate(p_hh = num_hh/tot_hh) 

   fdf <- df_vli %>%
    ungroup() %>%
     select(-tot_hh) %>% 
     unite(race_inc_group, race, inc_group) %>%
    # spread(race ~ inc_group, value.var = c('num_hh', 'perc_hh'))
    # pivot_wider(names_from = inc_group, 
    #             names_glue = "{inc_group}_{.value}",
    # #             values_from =  c(num_hh, perc_hh)) %>%
     pivot_wider(names_from =  race_inc_group,
                 names_glue = "{.value}_{race_inc_group}",
                 values_from =  c(num_hh, p_hh)) %>% 
    # pivot_wider(names_from =  c(race, inc_group),
    #             names_glue = "{race}_{inc_group}_{.value}",
    #             values_from =  c(num_hh, perc_hh)) %>%
    left_join(df, by = c('GEOID' = 'GEOID', 'year' ='year')) # %>%
     # rename('p_High_hh' ="High_p_hh", 
     #        'p_Moderate_hh' = "Moderate_p_hh", 
     #        'p_Low_hh' = "Low_p_hh", 
     #        'p_VeryLow_hh' = "VeryLow_p_hh",
     #        'p_ExtremelyLow_hh' = "ExtremelyLow_p_hh"
     #      )

    return(fdf)
}


acs_09_ami <- AMI_function(acs_09_clean, 2009)
acs_14_ami <- AMI_function(acs_14_clean, 2014)
acs_19_ami <- AMI_function(acs_19_clean, 2019)



################################################################################
########### Creating change over time Variables ################################
################################################################################

lagvars =  c( "med_rent","homeval_lower_quartile" , 
               "homeval_med" ,  "homeval_upper_quartile" , 
               "medinc", "punemployment" , "pba_higher","pma_higher",
               "p_hh_all_High" ,"p_hh_Asian_High","p_hh_Black_High" ,"p_hh_Latinx_High", 
               "p_hh_WhiteNonHisp_High", "p_hh_Other_High"  ,"p_hh_all_Moderate" ,
               "p_hh_Asian_Moderate","p_hh_Black_Moderate","p_hh_Latinx_Moderate",
               "p_hh_WhiteNonHisp_Moderate", "p_hh_Other_Moderate" ,
               "p_hh_all_Low" ,"p_hh_Asian_Low" ,"p_hh_Black_Low", "p_hh_Latinx_Low", "p_hh_WhiteNonHisp_Low", "p_hh_Other_Low",
               "p_hh_all_VeryLow" ,"p_hh_Asian_VeryLow"  ,"p_hh_Black_VeryLow",
               "p_hh_Latinx_VeryLow","p_hh_WhiteNonHisp_VeryLow" ,"p_hh_Other_VeryLow" ,
               "p_hh_all_ExtremelyLow", "p_hh_Asian_ExtremelyLow",
               "p_hh_Black_ExtremelyLow" ,"p_hh_Latinx_ExtremelyLow","p_hh_WhiteNonHisp_ExtremelyLow", "p_hh_Other_ExtremelyLow",  
               "num_hh_all_High" ,"num_hh_Asian_High","num_hh_Black_High" ,"num_hh_Latinx_High", 
               "num_hh_WhiteNonHisp_High", "num_hh_Other_High"  ,"num_hh_all_Moderate" ,
               "num_hh_Asian_Moderate","num_hh_Black_Moderate","num_hh_Latinx_Moderate",
               "num_hh_WhiteNonHisp_Moderate", "num_hh_Other_Moderate" ,
               "num_hh_all_Low" ,"num_hh_Asian_Low" ,"num_hh_Black_Low", "num_hh_Latinx_Low", "num_hh_WhiteNonHisp_Low", "num_hh_Other_Low",
               "num_hh_all_VeryLow" ,"num_hh_Asian_VeryLow"  ,"num_hh_Black_VeryLow",
               "num_hh_Latinx_VeryLow","num_hh_WhiteNonHisp_VeryLow" ,"num_hh_Other_VeryLow" ,
               "num_hh_all_ExtremelyLow", "num_hh_Asian_ExtremelyLow",
               "num_hh_Black_ExtremelyLow" ,"num_hh_Latinx_ExtremelyLow","num_hh_WhiteNonHisp_ExtremelyLow", "num_hh_Other_ExtremelyLow",  
               'population','totalunits', "pwhite", "pblack" ,"pasian","platinx", 'prent_burden', 'med_age', 
               'p_renter', 'welfare', 'pchildren', 'pseniors', 'pabroad_diffstate',
               'avg_hh_size', 'family_hh_male_no_spouse_present', 'family_hh_female_no_spouse_present', 
               'pfamily_hh_female_no_spouse_present_wchildren','plimited_english',
               'GEOID')



# Select vars to calculate change over time, add year signifier suffix to numeric variables
lag09 = select(acs_09_ami, lagvars)%>%
  transmute(
    GEOID = GEOID,
    across(where(is.numeric),
      .names = "{col}_09"
    ))

lag14 = select(acs_14_ami, lagvars) %>%
  transmute(
    GEOID = GEOID,
    across(where(is.numeric),
      .names = "{col}_14"
    ))

lag19 = select(acs_19_ami, lagvars) %>%
  transmute(
    GEOID = GEOID,
    across(where(is.numeric),
      .names = "{col}_19"
    ))

# join together
lagdf <-
  lag19 %>%
  left_join(lag14, by =  "GEOID")

lagdf <-
  lagdf %>%
  left_join(lag09, by="GEOID")



# create change over time and proportion over time variables by selecting columns by suffix 
c_14_19_cols <- lagdf[, grepl("_19", colnames(lagdf))] - lagdf[, grepl("_14", colnames(lagdf))]
c_09_19_cols <- lagdf[, grepl("_19", colnames(lagdf))] - lagdf[, grepl("_09", colnames(lagdf))]
# c_prop_14_19_cols <- (lagdf[, grepl("_19", colnames(lagdf))] - lagdf[, grepl("_14", colnames(lagdf))])/ lagdf[, grepl("_14", colnames(lagdf))]
# c_prop_09_19_cols <- (lagdf[, grepl("_19", colnames(lagdf))] - lagdf[, grepl("_09", colnames(lagdf))])/ lagdf[, grepl("_09", colnames(lagdf))]


# change column names to reflect change over time and proportion change over time
colnames(c_09_19_cols) <- paste("c_09_19_",colnames(c_09_19_cols), sep = "") 
colnames(c_14_19_cols) <- paste("c_14_19_",colnames(c_14_19_cols), sep = "") 
# colnames(c_prop_09_19_cols) <- paste("c_prop_09_19_",colnames(c_prop_09_19_cols), sep = "") 
# colnames(c_prop_14_19_cols) <- paste("c_prop_14_19_",colnames(c_prop_14_19_cols), sep = "")


# remove year signifier suffices
names(c_14_19_cols) <- substring(names(c_14_19_cols), 1, nchar(names(c_14_19_cols))-3)
names(c_09_19_cols) <- substring(names(c_09_19_cols), 1, nchar(names(c_09_19_cols))-3)
# names(c_prop_09_19_cols) <- substring(names(c_prop_09_19_cols), 1, nchar(names(c_prop_09_19_cols))-3)
# names(c_prop_14_19_cols) <- substring(names(c_prop_14_19_cols), 1, nchar(names(c_prop_14_19_cols))-3)


#Bind lag df's together
lagdf_full <- cbind(c_14_19_cols, c_09_19_cols, 
                    # c_prop_09_19_cols, c_prop_14_19_cols, 
                    lagdf[, 'GEOID'])

#bind acs_df's together
acs_df <- rbind(acs_19_ami, acs_14_ami, acs_09_ami)


df <- acs_df %>% left_join(lagdf_full, by = "GEOID")


###############################################################################
###########  Create rent gap and extra local change in rent
###############################################################################

#
# Tract data
# --------------------------------------------------------------------------
# Note: Make sure to extract tracts that surround cities. For example, in 
# Memphis and Chicago, TN, MO, MS, and AL are within close proximity of 
# Memphis and IN is within close proximity of Chicago. 

### Tract data extraction function: add your state here



st<- c("CA")

tr_rent <- function( year, state){
  get_acs(
    geography = "tract",
    variables = c('medrent' = 'B25064_001'),
    state = state,
    county = NULL,
    geometry = FALSE,
    cache_table = TRUE,
    output = "tidy",
    year = year,
    keep_geo_vars = TRUE
  ) %>%
    select(-moe) %>% 
    rename(medrent = estimate) %>% 
    mutate(
      county = str_sub(GEOID, 3,5), 
      state = str_sub(GEOID, 1,2),
      year = str_sub(year, 3,4) 
    )
  }

### Loop (map) across different states
tr_rents19 <- 
  map_dfr(st, function(state){
    tr_rent(year = 2019, state) %>% 
      mutate(COUNTY = substr(GEOID, 1, 5))
  })

tr_rents14 <- 
map_dfr(st, function(state){
  tr_rent(year = 2014, state) %>% 
    mutate(COUNTY = substr(GEOID, 1, 5),
      medrent = medrent*1.08)
})

tr_rents09 <- 
  map_dfr(st, function(state){
    tr_rent(year = 2009, state) %>% 
      mutate(
        COUNTY = substr(GEOID, 1, 5),
          medrent = medrent*1.20)
  })
gc()


tr_rents_total <- 
  bind_rows(tr_rents19, tr_rents14, tr_rents09) %>% 
  unite("variable", c(variable,year), sep = "") %>% 
  group_by(variable) %>% 
  spread(variable, medrent) %>% 
  group_by(COUNTY) %>%
  mutate(
    tr_medrent19 = 
      case_when(
        is.na(medrent19) ~ median(medrent19, na.rm = TRUE),
        TRUE ~ medrent19
      ),
    tr_medrent14 = 
      case_when(
        is.na(medrent14) ~ median(medrent14, na.rm = TRUE),
        TRUE ~ medrent14
      ),
    tr_medrent09 = 
      case_when(
        is.na(medrent09) ~ median(medrent09, na.rm = TRUE),
        TRUE ~ medrent09),
    tr_chrent_09_19 = tr_medrent19 - tr_medrent09,
    tr_chrent_14_19 = tr_medrent19 - tr_medrent14,
    tr_pchrent_09_19 = (tr_medrent19 - tr_medrent09)/tr_medrent09,
    tr_pchrent_14_19 = (tr_medrent19 - tr_medrent14)/tr_medrent14,
    rm_medrent19 = median(tr_medrent19, na.rm = TRUE), 
    rm_medrent14 = median(tr_medrent14, na.rm = TRUE), 
    rm_medrent09 = median(tr_medrent09, na.rm = TRUE)) %>% 
  select(-medrent09, -medrent14, -medrent19) %>% 
  distinct() %>% 
  group_by(GEOID) %>% 
  filter(row_number()==1) %>% 
  ungroup()


stsp <- 
  tracts("CA", cb = TRUE, class = 'sp')


library(sp)

stsp@data <-
  left_join(stsp@data, tr_rents_total, by = 'GEOID')

# Create neighbor matrix
# --------------------------------------------------------------------------
#-------------------------------------------------------------------------
coords <- coordinates(stsp)
IDs <- row.names(as(stsp, "data.frame"))
stsp_nb <- poly2nb(stsp) # nb
lw_bin <- nb2listw(stsp_nb, style = "W", zero.policy = TRUE)
kern1 <- knn2nb(knearneigh(coords, k = 1), row.names=IDs)
dist <- unlist(nbdists(kern1, coords)); summary(dist)
max_1nn <- max(dist)
dist_nb <- dnearneigh(coords, d1=0, d2 = .1*max_1nn, row.names = IDs)
spdep::set.ZeroPolicyOption(TRUE)
spdep::set.ZeroPolicyOption(TRUE)
dists <- nbdists(dist_nb, coordinates(stsp))
idw <- lapply(dists, function(x) 1/(x^2))
lw_dist_idwW <- nb2listw(dist_nb, glist = idw, style = "W")


# Create select lag variables
# --------------------------------------------------------------------------

stsp$tr_pchrent_09_19.lag <- lag.listw(lw_dist_idwW,stsp$tr_pchrent_09_19)
stsp$tr_pchrent_14_19.lag <- lag.listw(lw_dist_idwW,stsp$tr_pchrent_14_19)
stsp$tr_chrent_09_19.lag <- lag.listw(lw_dist_idwW,stsp$tr_chrent_09_19)
stsp$tr_chrent_14_19.lag <- lag.listw(lw_dist_idwW,stsp$tr_chrent_14_19)
stsp$tr_medrent09.lag <- lag.listw(lw_dist_idwW,stsp$tr_medrent09)
stsp$tr_medrent14.lag <- lag.listw(lw_dist_idwW,stsp$tr_medrent14)
stsp$tr_medrent19.lag <- lag.listw(lw_dist_idwW,stsp$tr_medrent19)


# ==========================================================================
# Join lag vars with df
# ==========================================================================

df_lag <-  
    left_join(
        df, 
        stsp@data %>% 
            select(GEOID, ALAND, tr_medrent19:tr_medrent19.lag)) %>%
    mutate(
        tr_rent_gap_19 = tr_medrent19.lag - tr_medrent19, 
        tr_rent_gap_14 = tr_medrent14.lag - tr_medrent14, 
        tr_rent_gap_09 = tr_medrent09.lag - tr_medrent09, 
        tr_rent_gapprop_19 = tr_rent_gap_19/((tr_medrent19 + tr_medrent19.lag)/2),
        tr_rent_gapprop_14 = tr_rent_gap_14/((tr_medrent14 + tr_medrent14.lag)/2),
        tr_rent_gapprop_09 = tr_rent_gap_09/((tr_medrent09 + tr_medrent09.lag)/2),
        c_09_19_rent_gap = tr_rent_gap_19 - tr_rent_gap_09,
        c_14_19_rent_gap = tr_rent_gap_19 - tr_rent_gap_14) %>%
      group_by(COUNTY, year) %>% 
      mutate(
        rm_rent_gap_19 = median(tr_rent_gap_19, na.rm = TRUE), 
        rm_rent_gap_14 = median(tr_rent_gap_14, na.rm = TRUE), 
        rm_rent_gap_09 = median(tr_rent_gap_09, na.rm = TRUE), 
        rm_rent_gapprop_19 = median(tr_rent_gapprop_19, na.rm = TRUE), 
        rm_rent_gapprop_14 = median(tr_rent_gapprop_14, na.rm = TRUE), 
        rm_rent_gapprop_09 = median(tr_rent_gapprop_09, na.rm = TRUE), 
        rm_pchrent_09_19 = median(tr_pchrent_09_19, na.rm = TRUE),
        rm_pchrent_14_19 = median(tr_pchrent_14_19, na.rm = TRUE),
        rm_medrent19.lag = median(tr_medrent19.lag, na.rm = TRUE), 
        rm_medrent14.lag = median(tr_medrent14.lag, na.rm = TRUE), 
        rm_medrent09.lag = median(tr_medrent09.lag, na.rm = TRUE),
        # Adding in some regional medians for gentrification measure 
        rm_c_med_rent_09_19 = median(tr_chrent_09_19, na.rm = TRUE),
        rm_c_home_value_09_19 = median(c_09_19_homeval_med, na.rm = TRUE),
        rm_c_pba_higher_09_19 =  median(c_09_19_pba_higher, na.rm = TRUE),
        rm_c_med_income_09_19 = median(c_09_19_medinc, na.rm = TRUE),
        rm_all_li = median(num_hh_all_Low + num_hh_all_VeryLow + num_hh_all_ExtremelyLow, na.rm = TRUE),
        rm_p_nonwhite = median(population - pwhite, na.rm = TRUE),
        rm_p_renter = median(p_renter, na.rm = TRUE), 
        rm_p_college = median(pba_higher, na.rm = TRUE),
        rm_medrent = median(med_rent, na.rm = TRUE),
        rm_homevalue = median(homeval_med, na.rm = TRUE),
        )



df_lag_final <- 
    df_lag %>% mutate(tr_rent_gap = case_when(
                                              year == '2009' ~ tr_rent_gap_09,
                                              year == '2014' ~ tr_rent_gap_14,
                                              year == '2019' ~ tr_rent_gap_19),
                      tr_rent_gapprop = case_when(
                                              year == '2009' ~ tr_rent_gapprop_09,
                                              year == '2014' ~ tr_rent_gapprop_14,
                                              year == '2019' ~ tr_rent_gapprop_19),
                      rm_rent_gap = case_when(
                                              year == '2009' ~ rm_rent_gap_09,
                                              year == '2014' ~ rm_rent_gap_14,
                                              year == '2019' ~ rm_rent_gap_19),
                      rm_rent_gapprop = case_when(
                                              year == '2009' ~ rm_rent_gapprop_09,
                                              year == '2014' ~ rm_rent_gapprop_14,
                                              year == '2019' ~ rm_rent_gapprop_19),
                      rm_medrent.lag = case_when(
                                              year == '2009' ~ rm_medrent09.lag,
                                              year == '2014' ~ rm_medrent14.lag,
                                              year == '2019' ~ rm_medrent19.lag), 
                      hotmarket = case_when(
                                      (c_09_19_homeval_med > rm_c_med_rent_09_19) |
                                      (tr_chrent_09_19 > rm_c_med_rent_09_19) ~ 1, TRUE ~ 0),
                      aboverm_per_all_li = case_when((num_hh_all_Low + num_hh_all_VeryLow + num_hh_all_ExtremelyLow)> rm_all_li ~ 1, TRUE ~ 0),
                      ALAND = as.numeric(ALAND)/2589988.10,
                      pop_dens = population/ALAND,
                      aboverm_per_rent = case_when(p_renter > rm_p_renter ~ 1, TRUE ~ 0),
                      aboverm_med_rent = case_when(med_rent > rm_medrent ~ 1, TRUE ~ 0),
                      aboverm_homevalue = case_when(homeval_med > rm_homevalue ~ 1, TRUE ~ 0),
                      aboverm_per_nonwhite = case_when((population - pwhite) > rm_p_nonwhite ~ 1, TRUE ~ 0 ),
                      aboverm_per_college = case_when(pba_higher>rm_p_college ~ 1, TRUE ~ 0),
                      vuln_gentrification = case_when( year  == '2009' &
                                  ((aboverm_med_rent == 0 | aboverm_homevalue == 0) &
                                  (aboverm_per_all_li + aboverm_per_nonwhite + aboverm_per_rent + (1-aboverm_per_college))> 2)
                                   ~ 1, TRUE ~ 0),
                      gentrified = case_when(
                                      (hotmarket == 1 ) &
                                      (c_09_19_pba_higher > rm_c_pba_higher_09_19) &
                                      ((c_09_19_num_hh_all_Low + c_09_19_num_hh_all_VeryLow + c_09_19_num_hh_all_ExtremelyLow) < 0) &
                                      (c_09_19_medinc > rm_c_med_income_09_19) ~ 1, TRUE ~ 0
                                      )) %>% 
                   select(-c(tr_rent_gap_09, tr_rent_gap_14, tr_rent_gap_19,
                       tr_rent_gapprop_09, tr_rent_gapprop_14, tr_rent_gapprop_19,
                       rm_rent_gap_09, rm_rent_gap_14, rm_rent_gap_19, tr_pchrent_14_19,
                       rm_rent_gapprop_09, rm_rent_gapprop_14, rm_rent_gapprop_19, rm_medrent09.lag, rm_medrent14.lag, rm_medrent19.lag,
                       tr_chrent_09_19, tr_chrent_14_19, tr_pchrent_09_19,tr_medrent09.lag, tr_medrent14.lag, tr_medrent19.lag,
                       rm_medrent09, rm_medrent14, rm_medrent19, tr_medrent19, tr_medrent14, tr_medrent09))



df_lag_final[is.na(df_lag_final)] <- 0
df_lag_final_clean <- do.call(data.frame,lapply(df_lag_final, function(x) replace(x, is.infinite(x),NA)))

df_lag_final_clean <- df_lag_final_clean %>% mutate(
                      renter_check = population*p_renter,
                      zero_renters = ifelse(renter_check == 0 | is.na(renter_check), 1, 0))

# Calculate first quartile of # of renters
# quart <- quantile(df_lag_final_clean$renter_check, prob = .25, na.rm = TRUE) # 0

################################################################################
############## write to fst ####################################################
################################################################################


write_fst(df_lag_final_clean, 
  paste0("~/data/projects/displacement_measure/acs_vars/ACS_", Sys.Date(), ".fst"),
  compress = 50, uniform_encoding = TRUE)


################################################################################

vd09 <- load_variables(2009, "acs5/profile", cache = TRUE)
v09 <- load_variables(2009, "acs5", cache = TRUE)
v14 <- load_variables(2014, "acs5", cache = TRUE)
v19 <- load_variables(2019, "acs5", cache = TRUE)
vs10 <- load_variables(2010, "acs5/subject", cache = TRUE)
vd19 <- load_variables(2019, "acs5/profile", cache = TRUE)
vd14 <- load_variables(2014, "acs5/profile", cache = TRUE)








    # rm_pchrent_09_19.lag = median(tr_pchrent_09_19.lag, na.rm = TRUE),
    # rm_pchrent_14_19.lag = median(tr_pchrent_14_19.lag, na.rm = TRUE),
    # rm_chrent_09_19.lag = median(tr_chrent_09_19.lag, na.rm = TRUE),
    # rm_chrent_14_19.lag = median(tr_chrent_14_19.lag, na.rm = TRUE),


    # pWhite = white/population,
    # pAsian = asian/population,
    # pBlack = black/population,
    # pLatinx = latinx/population,
    # pOther = (population - sum(white, asian, black, latinx, na.rm = TRUE))/population,
    # penrolled_undergrad = enrolled_undergrad/population,
    # penrolled_grad = enrolled_grad/population,
    # prent_burden =rent_burden/hh_count,
    # phh_2_person_fam = hh_2_person_fam/hh_count,
    # phh_3_person_fam = hh_3_person_fam/hh_count,
    # phh_4_person_fam = hh_4_person_fam/hh_count,
    # phh_5_more_person_fam = hh_5_more_person_fam/hh_count,
    # phh_1_person = hh_1_person/hh_count,
    # phh_2_person_nonfam = hh_2_person_nonfam/hh_count,
    # phh_3_person_nonfam = hh_3_person_nonfam/hh_count,
    # phh_4_more_person_nonfam = hh_4_more_person_nonfam/hh_count,
    # pwithin_state = within_state/population,
    # pwithin_county = within_county/population,
    # pdiff_state = diff_state/population,
    # pabroad = abroad/100,
    # pchildren = pchildren/100,
    # pseniors = pseniors/100,
    # punemployment = punemployment/100,
    # pba_higher = pba_higher/100,
    # pma_higher = pma_higher/100,
    # pbuilt_2005_on = built_2005_on/totalunits,
    # pbuilt_2000_2004 = built_2000_2004/totalunits,
    # pbuilt_1990_1999 = built_1990_1999/totalunits,
    # pbuilt_1980_1989 = built_1980_1989/totalunits,
    # pbuilt_1970_1979 = built_1970_1979/totalunits ,
    # pbuilt_1960_1969 = built_1960_1969/totalunits,
    # pbuilt_1950_1959 = built_1950_1959/totalunits,
    # pbuilt_1940_1949 = built_1940_1949/totalunits,
    # pbuilt_1939_before = built_1939_before/totalunits,
    # pincome_less_10k = income_less_10k/hh_count,
    # pincome_10k_15k = income_10k_15k/hh_count,
    # pincome_15k_20k = income_15k_20k/hh_count,
    # pincome_20k_25k = income_20k_25k/hh_count,
    # pincome_25k_30k = income_25k_30k/hh_count,
    # pincome_30k_35k = income_30k_35k/hh_count,
    # pincome_35k_40k = income_35k_40k/hh_count,
    # pincome_40k_45k = income_40k_45k/hh_count,
    # pincome_45k_50k = income_45k_50k/hh_count,
    # pincome_50k_60k = income_50k_60k/hh_count,
    # pincome_60k_75k = income_60k_75k/hh_count,
    # pincome_75k_100k = income_75k_100k/hh_count,
    # pincome_100k_125k = income_100k_125k/hh_count,
    # pincome_125k_150k = income_125k_150k/hh_count,
    # pincome_150k_200k = income_150k_200k/hh_count,
    # pincome_200k_more = income_200k_more/hh_count,
    # COUNTY = substr(GEOID, 1, 5),
    # year = '2019'

  #   pWhite = white/population,
  #   pAsian = asian/population,
  #   pBlack = black/population,
  #   pLatinx = latinx/population,
  #   pOther = (population - sum(white, asian, black, latinx, na.rm = TRUE))/population,
  #   penrolled_undergrad = enrolled_undergrad/population,
  #   penrolled_grad = enrolled_grad/population,
  #   prent_burden =rent_burden/hh_count,
  #   phh_2_person_fam = hh_2_person_fam/hh_count,
  #   phh_3_person_fam = hh_3_person_fam/hh_count,
  #   phh_4_person_fam = hh_4_person_fam/hh_count,
  #   phh_5_more_person_fam = hh_5_more_person_fam/hh_count,
  #   phh_1_person = hh_1_person/hh_count,
  #   phh_2_person_nonfam = hh_2_person_nonfam/hh_count,
  #   phh_3_person_nonfam = hh_3_person_nonfam/hh_count,
  #   phh_4_more_person_nonfam = hh_4_more_person_nonfam/hh_count,
  #   pwithin_state = within_state/population,
  #   pwithin_county = within_county/population,
  #   pdiff_state = diff_state/population,
  #   pabroad = abroad/100,
  #   pchildren = pchildren/100,
  #   pseniors = pseniors/100,
  #   punemployment = punemployment/100,
  #   pba_higher = pba_higher/100,
  #   pma_higher = pma_higher/100,
  #   pbuilt_2005_on = built_2005_on/totalunits,
  #   pbuilt_2000_2004 = built_2000_2004/totalunits,
  #   pbuilt_1990_1999 = built_1990_1999/totalunits,
  #   pbuilt_1980_1989 = built_1980_1989/totalunits,
  #   pbuilt_1970_1979 = built_1970_1979/totalunits ,
  #   pbuilt_1960_1969 = built_1960_1969/totalunits,
  #   pbuilt_1950_1959 = built_1950_1959/totalunits,
  #   pbuilt_1940_1949 = built_1940_1949/totalunits,
  #   pbuilt_1939_before = built_1939_before/totalunits,
  #   pincome_less_10k = income_less_10k/hh_count,
  #   pincome_10k_15k = income_10k_15k/hh_count,
  #   pincome_15k_20k = income_15k_20k/hh_count,
  #   pincome_20k_25k = income_20k_25k/hh_count,
  #   pincome_25k_30k = income_25k_30k/hh_count,
  #   pincome_30k_35k = income_30k_35k/hh_count,
  #   pincome_35k_40k = income_35k_40k/hh_count,
  #   pincome_40k_45k = income_40k_45k/hh_count,
  #   pincome_45k_50k = income_45k_50k/hh_count,
  #   pincome_50k_60k = income_50k_60k/hh_count,
  #   pincome_60k_75k = income_60k_75k/hh_count,
  #   pincome_75k_100k = income_75k_100k/hh_count,
  #   pincome_100k_125k = income_100k_125k/hh_count,
  #   pincome_125k_150k = income_125k_150k/hh_count,
  #   pincome_150k_200k = income_150k_200k/hh_count,
  #   pincome_200k_more = income_200k_more/hh_count,
  #   COUNTY = substr(GEOID, 1, 5),
  #   year = '2014'
  # )

# across(starts_with("Sepal"), mean, .names = "mean_{.col}")


#     pWhite = white/population,
#     pAsian = asian/population,
#     pBlack = black/population,
#     pLatinx = latinx/population,
#     penrolled_undergrad = enrolled_undergrad/population,
#     penrolled_grad = enrolled_grad/population,
#     pba_higher = ba_higher/totpop25over,
#     pma_higher = ma_higher/ totpop25over,
#     phighschool= highschool/totpop25over,
#     pbelow_hs = below_hs/ totpop25over,
#     psome_college = some_college/totpop25over,
#     punemployment = unemployment/totpop16over,
#     pincome_less_10k = income_less_10k/hh_count,
#     pincome_10k_15k = income_10k_15k/hh_count,
#     pincome_15k_20k = income_15k_20k/hh_count,
#     pincome_20k_25k = income_20k_25k/hh_count,
#     pincome_25k_30k = income_25k_30k/hh_count,
#     pincome_30k_35k = income_30k_35k/hh_count,
#     pincome_35k_40k = income_35k_40k/hh_count,
#     pincome_40k_45k = income_40k_45k/hh_count,
#     pincome_45k_50k = income_45k_50k/hh_count,
#     pincome_50k_60k = income_50k_60k/hh_count,
#     pincome_60k_75k = income_60k_75k/hh_count,
#     pincome_75k_100k = income_75k_100k/hh_count,
#     pincome_100k_125k = income_100k_125k/hh_count,
#     pincome_125k_150k = income_125k_150k/hh_count,
#     pincome_150k_200k = income_150k_200k/hh_count,
#     pincome_200k_more = income_200k_more/hh_count,
#     prent_burden =rent_burden/hh_count,
#     phh_2_person_fam = hh_2_person_fam/hh_count,
#     phh_3_person_fam = hh_3_person_fam/hh_count,
#     phh_4_person_fam = hh_4_person_fam/hh_count,
#     phh_5_more_person_fam = hh_5_more_person_fam/hh_count,
#     phh_1_person = hh_1_person/hh_count,
#     phh_2_person_nonfam = hh_2_person_nonfam/hh_count,
#     phh_3_person_nonfam = hh_3_person_nonfam/hh_count,
#     phh_4_more_person_nonfam = hh_4_more_person_nonfam/hh_count,
#     pwithin_state = within_state/population,
#     pwithin_county = within_county/population,
#     pdiff_state = diff_state/population,
#     pabroad = abroad/population,
#     pchildren = pchildren/hh_count,
#     pseniors = pseniors/hh_count,
#     pbuilt_2005_on = built_2005_on/totalunits,
#     pbuilt_2000_2004 = built_2000_2004/totalunits,
#     pbuilt_1990_1999 = built_1990_1999/totalunits,
#     pbuilt_1980_1989 = built_1980_1989/totalunits,
#     pbuilt_1970_1979 = built_1970_1979/totalunits ,
#     pbuilt_1960_1969 = built_1960_1969/totalunits,
#     pbuilt_1950_1959 = built_1950_1959/totalunits,
#     pbuilt_1940_1949 = built_1940_1949/totalunits,
#     pbuilt_1939_before = built_1939_before/totalunits,
    
#   )



# 
# # ==========================================================================
# # Join lag vars with df
# # ==========================================================================
# 
# lag <-  
#   left_join(
#     df, 
#     stsp@data %>% 
#       mutate(GEOID = as.numeric(GEOID)) %>%
#       select(GEOID, tr_medrent18:tr_medrent18.lag)) %>%
#   mutate(
#     tr_rent_gap = tr_medrent18.lag - tr_medrent18, 
#     tr_rent_gapprop = tr_rent_gap/((tr_medrent18 + tr_medrent18.lag)/2),
#     rm_rent_gap = median(tr_rent_gap, na.rm = TRUE), 
#     rm_rent_gapprop = median(tr_rent_gapprop, na.rm = TRUE), 
#     rm_pchrent = median(tr_pchrent, na.rm = TRUE),
#     rm_pchrent.lag = median(tr_pchrent.lag, na.rm = TRUE),
#     rm_chrent.lag = median(tr_chrent.lag, na.rm = TRUE),
#     rm_medrent17.lag = median(tr_medrent18.lag, na.rm = TRUE), 
#     dp_PChRent = case_when(tr_pchrent > 0 & 
#                              tr_pchrent > rm_pchrent ~ 1, # ∆ within tract
#                            tr_pchrent.lag > rm_pchrent.lag ~ 1, # ∆ nearby tracts
#                            TRU ~ 0),
#     dp_RentGap = case_when(tr_rent_gapprop > 0 & tr_rent_gapprop > rm_rent_gapprop ~ 1,
#                            TRU ~ 0),
#   ) 

## Creating change over time variables
# lagdf <- 
#   lagdf %>% mutate(
#     c_medrent_09_19 = med_rent_19 - med_rent_09,
#     c_medrent_14_19 = med_rent_19 - med_rent_14,
#     c_medinc_09_19 = medinc_19 - medinc_09,
#     c_medinc_14_19 = medinc_19 - medinc_14,
#     c_homeval_med_09_19 = homeval_med_19 - homeval_med_09,
#     c_homeval_med_14_19 = homeval_med_19 - homeval_med_14,
#     c_homeval_lower_quartile_09_19 = homeval_lower_quartile_19 - homeval_lower_quartile_09,
#     c_homeval_lower_quartile_14_19 = homeval_lower_quartile_19 - homeval_lower_quartile_14,
#     c_homeval_upper_quartile_09_19 = homeval_upper_quartile_19 - homeval_upper_quartile_09,
#     c_homeval_upper_quartile_14_19 = homeval_upper_quartile_19 - homeval_upper_quartile_14,
#     c_punemployment_09_19 = punemployment_19 - punemployment_09,
#     c_punemployment_14_19 = punemployment_19 - punemployment_14,
#     #education
#     c_pba_higher_09_19 = pba_higher_19 - pba_higher_09,
#     c_pba_higher_14_19 = pba_higher_19 - pba_higher_14,
#     c_pma_higher_09_19 = pma_higher_19 - pma_higher_09,
#     c_pma_higher_14_19 = pma_higher_19 - pma_higher_14,
#     c_prop_pba_higher_09_19 = (pba_higher_19 - pba_higher_09)/pba_higher_09,
#     c_prop_pba_higher_14_19 = (pba_higher_19 - pba_higher_14)/pba_higher_14,
#     c_prop_pma_higher_09_19 = (pma_higher_19 - pma_higher_09)/pma_higher_09,
#     c_prop_pma_higher_14_19 = (pma_higher_19 - pma_higher_14)/pma_higher_09,
#     #race
#     c_pop_black_09_19 = black_19 - black_09,
#     c_pop_black_14_19 = black_19 - black_14,
#     c_pop_latinx_09_19 = latinx_19 - latinx_09, 
#     c_pop_latinx_14_19 = latinx_19 - latinx_14,
#     c_pop_asian_09_19 = asian_19 - asian_09, 
#     c_pop_asian_14_19 = asian_19 - asian_14,
#     c_pop_white_09_19 = white_19 - white_09, 
#     c_pop_white_14_19 = white_19 - white_14,
#     c_PROP_black_09_19 = (black_19 - black_09)/black_09,
#     c_PROP_black_14_19 = (black_19 - black_14)/black_14,
#     c_PROP_latinx_09_19 = (latinx_19 - latinx_09)/latinx_09, 
#     c_PROP_latinx_14_19 = (latinx_19 - latinx_14)/latinx_14,
#     c_PROP_asian_09_19 = (asian_19 - asian_09)/asian_09, 
#     c_PROP_asian_14_19 = (asian_19 - asian_14)/asian_14,
#     c_PROP_white_09_19 = (white_19 - white_09)/white_09, 
#     c_PROP_white_14_19 = (white_19 - white_14)/white_14,
#     # Pop and Units
#     c_population_09_19 = population_19 - population_09,
#     c_population_14_19 = population_19 - population_14,
#     c_prop_population_09_19 = (population_19 - population_09)/population_09,
#     c_prop_population_14_19 = (population_19 - population_14)/population_14,
#     # Age
#     c_med_age_09_19 = med_age_19 - med_age_09,
#     c_med_age_14_19 = med_age_19 - med_age_14,
#     c_prop_med_age_09_19 = (med_age_19 - med_age_09)/med_age_09,
#     c_prop_med_age_14_19 = (med_age_19 - med_age_14)/med_age_14,
#     )
# # 
# #####################################################
# ##### Prepare median and average values
# ###################################################
# 
# acs_09meds <- select(census_wide09, meds)
# 
# 
# # FIPS filter from Census/ACS data
# fips_filter <-
# paste(acs_09meds %>% select(GEOID) %>% pull(), collapse = "|")
# 
# # Filter crosswalk data by relevant FIPS (reduces interpolation time)
# crosswalk_filter <-
#   ltdb %>%
#   filter(str_detect(trtid00, fips_filter))
# 
# # join to filtered crosswalk
# acs_09meds_xwalk <-
#   acs_09meds %>%
#   full_join(crosswalk_filter, by =c( "GEOID" = "trtid00" ))
#   # group by 2010 tracts
# 
# #aggregate means by new tract id
# acs_09meds_xwalk <- aggregate(acs_09meds_xwalk, list(acs_09meds_xwalk$trtid10), mean)
#   
# 
# ### Join all back together
# 
# acs_09 <-
#   acs_09meds_xwalk %>%
#   full_join(acs_090, by = c("trtid10" = "GEOID"))
# # group by 2010 tracts
# 
# #restore GEOID variable
# acs_09 <-
#   acs_09 %>% 
#     rename(
#       GEOID = trtid10) %>% 
#   mutate(
#     GEOID = as.character(GEOID),
#     GEOID = str_pad(GEOID, 11, side = "left",  pad = "0")
#         ))
#       
# 
# rm(acs_09meds_xwalk)
# rm(acs_09meds)
# rm(acs_090)

#######################################################################
###### 2010 Variables  ################################################
#######################################################################

# income_vars_10 <- c(
#   "medinc" = "B19013_001",  
#   "income_less_10k" = "S1901_C01_002",
#   "income_10k_15k" = "S1901_C01_003",
#   "income_15k_25k" = "S1901_C01_004",
#   "income_25k_35k" = "S1901_C01_005",
#   "income_35k_50k" = "S1901_C01_006",
#   "income_50k_75k" = "S1901_C01_007",
#   "income_75k_100k" = "S1901_C01_008",
#   "income_100k_150k" = "S1901_C01_009",
#   "income_150k_200k" = "S1901_C01_010",
#   "income_200k_more" = "S1901_C01_011")




# dec_li <- function(df2000)
#   left_join(
#     df_li(df2000), 
#     read_csv("~/git/hprm/data/census/crosswalk_2000_2010.csv"),
#     by = c("GEOID" = "trtid00")
#     ) %>% 
#   mutate_at(vars(starts_with("tr_")), ~.*weight) %>% 
#   rename_at(vars(MHHInc:tr_LI_count), ~ paste0(., "_", 2000)) %>% 
#   select(GEOID = trtid10, year, tr_totinc_count_2000:tr_LI_count_2000) %>% 
#   group_by(GEOID, year) %>% 
#   summarize_at(vars(tr_totinc_count_2000:tr_LI_count_2000), ~sum(., na.rm = TRUE)) %>% 
#   ungroup() %>% 
#   select(-year)

# dec_li_renters <- function(df2000)
#   left_join(
#     df_li_renters(df2000), 
#     read_csv("~/git/hprm/data/census/crosswalk_2000_2010.csv"),
#     by = c("GEOID" = "trtid00")
#     ) %>% 
#   mutate_at(vars(starts_with("tr_")), ~.*weight) %>% 
#   rename_at(vars(MHHInc:tr_LI_count), ~ paste0(., "_", 2000)) %>% 
#   select(GEOID = trtid10, year, tr_totinc_count_2000:tr_LI_count_2000) %>% 
#   group_by(GEOID, year) %>% 
#   summarize_at(vars(tr_totinc_count_2000:tr_LI_count_2000), ~sum(., na.rm = TRUE)) %>% 
#   ungroup() %>% 
#   select(-year)
