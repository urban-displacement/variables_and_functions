#######################################################################################
################# Pulling census data for 1990, 2000, 2010, and 2019 ##################
#######################################################################################


### Loading required packages and setting defaults
if(!require(pacman)) install.packages("pacman")
p_load(tidyr, dplyr, tigris, tidycensus, yaml, sf, stringr, fst,
       googledrive, bit64,magrittr, fs, data.table, tidyverse, spdep)
options(tigris_use_cache = TRUE,
        tigris_class = "sf")
if(!require(lehdr)){devtools::install_github("jamgreen/lehdr")}else{library(lehdr)}
#setwd("Git/hprm")
select <- dplyr::select

### Set API key
census_api_key(yaml::read_yaml("~/census.yaml")) #enter your own key here

#######################################################################
###### 2019 Variables  ################################################
#######################################################################

race_vars_19 <- c(
  "population"= "DP05_0001",
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
  "hh_count" = "DP02_0001",
  "ownerp" = "DP04_0046P",
  "owner_count" = "DP04_0046",
  "renterp" = "DP04_0047P",
  "renter_count" = "DP04_0047",
  "homeval_lower_quartile" = "B25076_001",
  "homeval_med" = "B25077_001",
  "homeval_upper_quartile" = "B25078_001",
  "totalunits" ="B25034_001",
  "built_2014_on" = "B25034_002",
  "built_2010_2013"="B25034_003",
  "built_2000_2009"="B25034_004",
  "built_1990_1999"="B25034_005",
  "built_1980_1989" = "B25034_006",
  "built_1970_1979" ="B25034_007" ,
  "built_1960_1969"= "B25034_008",
  "built_1950_1959"="B25034_009",
  "built_1940_1949" = "B25034_010",
  "built_1939_before" = "B25034_011",
  
  "built_median" = "B25035_001",
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
  
  "income_less_5k_owners" =  "B25118_003",
  "income_5k_10k_owners"   =   "B25118_004",
  "income_10k_15k_owners"   =   "B25118_005",
  "income_15k_20k_owners" =   "B25118_006",
  "income_20k_25k_owners" =   "B25118_007",
  "income_25k_35k_owners" =   "B25118_008",
  "income_35k_50k_owners" =   "B25118_009",
  "income_50k_75k_owners" =   "B25118_010",
  "income_75k_100k_owners" =   "B25118_011",
  "income_100k_150k_owners" =   "B25118_012",
  "income_150k_more_owners" =   "B25118_013",
  "income_less_5k_renters" =  "B25118_015",
  "income_5k_10k_renters"   =   "B25118_016",
  "income_10k_15k_renters"   =   "B25118_017",
  "income_15k_20k_renters" =   "B25118_018",
  "income_20k_25k_renters" =   "B25118_019",
  "income_25k_35k_renters" =   "B25118_020",
  "income_35k_50k_renters" =   "B25118_021",
  "income_50k_75k_renters" =   "B25118_022",
  "income_75k_100k_renters" =   "B25118_023",
  "income_100k_150k_renters" =   "B25118_024",
  "income_150k_more_renters" =   "B25118_025",
  
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
  "rent_burden_0_10" = "B25070_002",
  "rent_burden_10_15" = "B25070_003",
  "rent_burden_15_20" = "B25070_004",
  "rent_burden_20_25" = "B25070_005",
  "rent_burden_25_30" = "B25070_006",
  "rent_burden_30_35" = "B25070_007",
  "rent_burden_35_40" = "B25070_008",
  "rent_burden_40_50" = "B25070_009",
  "rent_burden_50_more" = "B25070_010",
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
  "poverty_rate" = "S1703_C03_001",
  "unemployment" = "S2301_C04_001",
  "welfare" = "B19057_002",
  "h_units_w_mortgage_30_35perc" = "B25091_008",
  "h_units_w_mortgage_35_40perc" = "B25091_009",
  "h_units_w_mortgage_40_50perc" = "B25091_010",
  "h_units_w_mortgage_50moreperc" = "B25091_011")

hh_vars_19 <- c(
  "avg_hh_size" = "B25010_001",
  #"within_county" = "S0701_C02_001",
  #"within_state" = "S0701_C03_001",
  #"diff_state" = "S0701_C04_001",
  #"abroad" = "S0701_C05_001",
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
  "totpop25over" = "S1501_C02_006",
  "below_hs_1" = "S1501_C02_007",
  "below_hs_2" = "S1501_C02_008",
  "highschool" = "S1501_C02_009",
  "ba_higher" = "S1501_C02_015",
  "ma_higher" = "S1501_C02_013", 
  'only_english' = 'B06007_002'
) #percentage

varlist_19 = list(race_vars_19, 
                  tenure_vars_19, 
                  income_vars_19, 
                  hh_vars_19, 
                  edu_vars_19)

#######################################################################
###### 2010 Variables  ################################################
#######################################################################

race_vars_10 <- c(
  "population"= "DP05_0001",
  "med_age" = "B01002_001",
  "white" = "B03002_003",
  "black" = "B03002_004",
  "amind" = "B03002_005",
  "asian" = "B03002_006",
  "pacis" = "B03002_007",
  "other" = "B03002_008",
  "race2" = "B03002_009",
  "latinx" = "B03002_012")

tenure_vars_10 <-c(
  "hh_count" = "DP02_0001",
  "ownerp" = "DP04_0045P",
  "owner_count" = "DP04_0045",
  "renterp" = "DP04_0046P",
  "renter_count" = "DP04_0046",
  "homeval_lower_quartile" = "B25076_001",
  "homeval_med" = "B25077_001",
  "homeval_upper_quartile" = "B25078_001",
  "totalunits" ="B25034_001",
  "built_2005_on" = "B25034_002",
  "built_2000_2004" = "B25034_003",
  "built_1990_1999"="B25034_004",
  "built_1980_1989" = "B25034_005",
  "built_1970_1979" ="B25034_006" ,
  "built_1960_1969"= "B25034_007",
  "built_1950_1959"="B25034_008",
  "built_1940_1949" = "B25034_009",
  "built_1939_before" = "B25034_010",
  "built_median" = "B25035_001",
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


# 2019 uses S1903_C03_001 for med income
income_vars_10 <- c(
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
  
  "income_less_5k_owners" =  "B25118_003",
  "income_5k_10k_owners"   =   "B25118_004",
  "income_10k_15k_owners"   =   "B25118_005",
  "income_15k_20k_owners" =   "B25118_006",
  "income_20k_25k_owners" =   "B25118_007",
  "income_25k_35k_owners" =   "B25118_008",
  "income_35k_50k_owners" =   "B25118_009",
  "income_50k_75k_owners" =   "B25118_010",
  "income_75k_100k_owners" =   "B25118_011",
  "income_100k_150k_owners" =   "B25118_012",
  "income_150k_more_owners" =   "B25118_013",
  "income_less_5k_renters" =  "B25118_015",
  "income_5k_10k_renters"   =   "B25118_016",
  "income_10k_15k_renters"   =   "B25118_017",
  "income_15k_20k_renters" =   "B25118_018",
  "income_20k_25k_renters" =   "B25118_019",
  "income_25k_35k_renters" =   "B25118_020",
  "income_35k_50k_renters" =   "B25118_021",
  "income_50k_75k_renters" =   "B25118_022",
  "income_75k_100k_renters" =   "B25118_023",
  "income_100k_150k_renters" =   "B25118_024",
  "income_150k_more_renters" =   "B25118_025",
  
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
  "rent_burden_0_10" = "B25070_002",
  "rent_burden_10_15" = "B25070_003",
  "rent_burden_15_20" = "B25070_004",
  "rent_burden_20_25" = "B25070_005",
  "rent_burden_25_30" = "B25070_006",
  "rent_burden_30_35" = "B25070_007",
  "rent_burden_35_40" = "B25070_008",
  "rent_burden_40_50" = "B25070_009",
  "rent_burden_50_more" = "B25070_010",
  #"ownocc_rentburden_less20k" = "B25106_006",
  #"ownocc_rentburden_20k_35k" = "B25106_010",
  #"ownocc_rentburden_35k_50k" = "B25106_014",
  #"ownocc_rentburden_50k_75k" = "B25106_018",
  #"ownocc_rentburden_75kmore" = "B25106_022",
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
  "poverty_base" = "B06012_001",
  "poverty" = "B06012_002",
  "unemployment" = "S2301_C04_001",
  "welfare" = "B19057_002",
  "h_units_w_mortgage_30_35perc" = "B25091_008",
  "h_units_w_mortgage_35_40perc" = "B25091_009",
  "h_units_w_mortgage_40_50perc" = "B25091_010",
  "h_units_w_mortgage_50moreperc" = "B25091_011")

hh_vars_10 <- c(
  "avg_hh_size" = "B25010_001",
  #"within_county" = "S0701_C02_001",
  #"within_state" = "S0701_C03_001",
  #"diff_state" = "S0701_C04_001",
  #"abroad" = "S0701_C05_001",
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

edu_vars_10 <- c(
  "totpop25over" = "S1501_C01_006",
  "below_hs_1" = "S1501_C01_007",
  "below_hs_2" = "S1501_C01_008",
  "highschool" = "S1501_C01_009",
  "ba_higher" = "S1501_C01_015",
  "ma_higher" = "S1501_C01_013", 
  'only_english' = 'B06007_002'#,
  #'spanish_english_notverywell' = 'B06007_005',
  #'otherlang_english_notverywell' = 'B06007_008'
)

varlist_10 = list(race_vars_10, 
                  tenure_vars_10, 
                  income_vars_10, 
                  hh_vars_10, 
                  edu_vars_10
)

#######################################################################
###### 2000 Variables  ################################################
#######################################################################

race_vars_00 <- c( ##sf1
  "population"= "P004001",
  "med_age" = "P013001",
  "white" =  "P004005",
  "black" =  "P004006",
  "amind" =  "P004007",
  "asian" =  "P004008",
  "pacis" =  "P004009",
  "other" =  "P004010",
  "race2" =  "P004011",
  "latinx" = "P004002")

tenure_vars_00_sf1 <- c(
  "hh_count" = "H004001",
  "owner_count" = "H004002",
  "renter_count" = "H004003")

tenure_vars_00_sf3 <- c(
  "homeval_lower_quartile" = "H075001",
  "homeval_med" = "H076001",
  "homeval_upper_quartile" = "H077001",
  "totalunits" = "H001001",
  "built_1999_2000" = "H034002",
  "built_1995_1998" = "H034003",
  "built_1990_1994" = "H034004",
  "built_1980_1989" = "H034005",
  "built_1970_1979" = "H034006" ,
  "built_1960_1969" = "H034007",
  "built_1950_1959" = "H034008",
  "built_1940_1949" =  "H034009",
  "built_1939_before" = "H034010",
  "built_median" = "H035001",
  'ownocc_.5_less_per_room' = 'H020003',
  'ownocc_.5to1_per_room' = 'H020004',
  'ownocc_1to1.5_per_room' = 'H020005',
  'ownocc_1.5to2_per_room' = 'H020006',
  'ownocc_2more_per_room' = 'H020007',
  'rentocc_.5_less_per_room' = 'H020009',
  'rentocc_.5to1_per_room' = 'H020010',
  'rentocc_1to1.5_per_room' = 'H020011',
  'rentocc_1.5to2_per_room' = 'H020012',
  'rentocc_2more_per_room' = 'H020013'
)

income_vars_00 <- c( ## sf3
  "medinc" = "P053001",  
  "income_less_10k_all" =  "P052002",
  "income_10k_15k_all" =   "P052003",
  "income_15k_20k_all" =   "P052004",
  "income_20k_25k_all" =   "P052005",
  "income_25k_30k_all" =   "P052006",
  "income_30k_35k_all" =   "P052007",
  "income_35k_40k_all" =   "P052008",
  "income_40k_45k_all" =   "P052009",
  "income_45k_50k_all" =   "P052010",
  "income_50k_60k_all" =   "P052011",
  "income_60k_75k_all" =   "P052012",
  "income_75k_100k_all" =  "P052013",
  "income_100k_125k_all" = "P052014",
  "income_125k_150k_all" = "P052015",
  "income_150k_200k_all" = "P052016",
  "income_200k_more_all" = "P052017",
  
  "income_less_5k_owners" =  "HCT011003",
  "income_5k_10k_owners"   =   "HCT011004",
  "income_10k_15k_owners"   =   "HCT011005",
  "income_15k_20k_owners" =   "HCT011006",
  "income_20k_25k_owners" =   "HCT011007",
  "income_25k_35k_owners" =   "HCT011008",
  "income_35k_50k_owners" =   "HCT011009",
  "income_50k_75k_owners" =   "HCT011010",
  "income_75k_100k_owners" =   "HCT011011",
  "income_100k_150k_owners" =   "HCT011012",
  "income_150k_more_owners" =   "HCT011013",
  "income_less_5k_renters" =  "HCT011015",
  "income_5k_10k_renters"   =   "HCT011016",
  "income_10k_15k_renters"   =   "HCT011017",
  "income_15k_20k_renters" =   "HCT011018",
  "income_20k_25k_renters" =   "HCT011019",
  "income_25k_35k_renters" =   "HCT011020",
  "income_35k_50k_renters" =   "HCT011021",
  "income_50k_75k_renters" =   "HCT011022",
  "income_75k_100k_renters" =   "HCT011023",
  "income_100k_150k_renters" =   "HCT011024",
  "income_150k_more_renters" =   "HCT011025",
  
  "income_less_10k_Black" =  "P151B002",
  "income_10k_15k_Black" =   "P151B003",
  "income_15k_20k_Black" =   "P151B004",
  "income_20k_25k_Black" =   "P151B005",
  "income_25k_30k_Black" =   "P151B006",
  "income_30k_35k_Black" =   "P151B007",
  "income_35k_40k_Black" =   "P151B008",
  "income_40k_45k_Black" =   "P151B009",
  "income_45k_50k_Black" =   "P151B010",
  "income_50k_60k_Black" =   "P151B011",
  "income_60k_75k_Black" =   "P151B012",
  "income_75k_100k_Black" =  "P151B013",
  "income_100k_125k_Black" = "P151B014",
  "income_125k_150k_Black" = "P151B015",
  "income_150k_200k_Black" = "P151B016",
  "income_200k_more_Black" = "P151B017",
  "income_less_10k_Asian" =  "P151D002",
  "income_10k_15k_Asian" =   "P151D003",
  "income_15k_20k_Asian" =   "P151D004",
  "income_20k_25k_Asian" =   "P151D005",
  "income_25k_30k_Asian" =   "P151D006",
  "income_30k_35k_Asian" =   "P151D007",
  "income_35k_40k_Asian" =   "P151D008",
  "income_40k_45k_Asian" =   "P151D009",
  "income_45k_50k_Asian" =   "P151D010",
  "income_50k_60k_Asian" =   "P151D011",
  "income_60k_75k_Asian" =   "P151D012",
  "income_75k_100k_Asian" =  "P151D013",
  "income_100k_125k_Asian" = "P151D014",
  "income_125k_150k_Asian" = "P151D015",
  "income_150k_200k_Asian" = "P151D016",
  "income_200k_more_Asian" = "P151D017",
  "income_less_10k_WhiteNonHisp" =  "P151I002",
  "income_10k_15k_WhiteNonHisp" =   "P151I003",
  "income_15k_20k_WhiteNonHisp" =   "P151I004",
  "income_20k_25k_WhiteNonHisp" =   "P151I005",
  "income_25k_30k_WhiteNonHisp" =   "P151I006",
  "income_30k_35k_WhiteNonHisp" =   "P151I007",
  "income_35k_40k_WhiteNonHisp" =   "P151I008",
  "income_40k_45k_WhiteNonHisp" =   "P151I009",
  "income_45k_50k_WhiteNonHisp" =   "P151I010",
  "income_50k_60k_WhiteNonHisp" =   "P151I011",
  "income_60k_75k_WhiteNonHisp" =   "P151I012",
  "income_75k_100k_WhiteNonHisp" =  "P151I013",
  "income_100k_125k_WhiteNonHisp" = "P151I014",
  "income_125k_150k_WhiteNonHisp" = "P151I015",
  "income_150k_200k_WhiteNonHisp" = "P151I016",
  "income_200k_more_WhiteNonHisp" = "P151I017",
  "income_less_10k_Latinx" =  "P151H002",
  "income_10k_15k_Latinx" =   "P151H003",
  "income_15k_20k_Latinx" =   "P151H004",
  "income_20k_25k_Latinx" =   "P151H005",
  "income_25k_30k_Latinx" =   "P151H006",
  "income_30k_35k_Latinx" =   "P151H007",
  "income_35k_40k_Latinx" =   "P151H008",
  "income_40k_45k_Latinx" =   "P151H009",
  "income_45k_50k_Latinx" =   "P151H010",
  "income_50k_60k_Latinx" =   "P151H011",
  "income_60k_75k_Latinx" =   "P151H012",
  "income_75k_100k_Latinx" =  "P151H013",
  "income_100k_125k_Latinx" = "P151H014",
  "income_125k_150k_Latinx" = "P151H015",
  "income_150k_200k_Latinx" = "P151H016",
  "income_200k_more_Latinx" = "P151H017")

burden_vars_00 <- c(
  "rent_burden_0_10" = "H069002",
  "rent_burden_10_15" = "H069003",
  "rent_burden_15_20" = "H069004",
  "rent_burden_20_25" = "H069005",
  "rent_burden_25_30" = "H069006",
  "rent_burden_30_35" = "H069007",
  "rent_burden_35_40" = "H069008",
  "rent_burden_40_50" = "H069009",
  "rent_burden_50_more" = "H069010",
  
  "rentocc_rentburden_less20k_1" = "H073006",
  "rentocc_rentburden_less20k_2" = "H073007",
  "rentocc_rentburden_20k_35k_1" = "H073013",
  "rentocc_rentburden_20k_35k_2" = "H073014",
  "rentocc_rentburden_35k_50k_1" = "H073027",
  "rentocc_rentburden_35k_50k_2" = "H073028",
  "rentocc_rentburden_50k_75k_1" = "H073034",
  "rentocc_rentburden_50k_75k_2" = "H073035",
  "rentocc_rentburden_75k_100k_1" = "H073041",
  "rentocc_rentburden_75k_100k_2" = "H073042",
  "rentocc_rentburden_100kmore_1" = "H073048",
  "rentocc_rentburden_100kmore_2" = "H073049",
  "med_rent" = "H060001",
  "med_rent_percent_income" = "H070001",
  "poverty_base"  =  "P087001",
  "poverty"  =  "P087002",
  "unemployment_base" = "PCT035001",
  "unemployment_1" =  "PCT035008",
  "unemployment_2" =  "PCT035015",
  "unemployment_3" =  "PCT035022", 
  "unemployment_4" =  "PCT035029",
  "unemployment_5" =  "PCT035036",
  "unemployment_6" =  "PCT035043", 
  "unemployment_7" =  "PCT035050",
  "unemployment_8" =  "PCT035057",
  "unemployment_9" =  "PCT035064",
  "unemployment_10" = "PCT035071",
  "unemployment_11" = "PCT035078",
  "unemployment_12" = "PCT035085",
  "unemployment_13" = "PCT035092", 
  "unemployment_14" = "PCT035100", 
  "unemployment_15" = "PCT035107",
  "unemployment_16" = "PCT035114",
  "unemployment_17" = "PCT035121",
  "unemployment_18" = "PCT035128",
  "unemployment_19" = "PCT035135",
  "unemployment_20" = "PCT035142",
  "unemployment_21" = "PCT035149",
  "unemployment_22" = "PCT035156", 
  "unemployment_23" = "PCT035163",
  "unemployment_24" = "PCT035170", 
  "unemployment_25" = "PCT035177",
  "unemployment_26" = "PCT035184",
  "welfare" = "P064002",
  "h_units_w_mortgage_30_35perc" = "HCT047C008",
  "h_units_w_mortgage_35_40perc" = "HCT047C009",
  "h_units_w_mortgage_40_50perc" = "HCT047C010",
  "h_units_w_mortgage_50moreperc" = "HCT047C011"
)

hh_vars_00 <- c( 
  "avg_hh_size" = "H018001",
  'h_units_1_detached' = 'H030002',
  'h_units_1_attached' = 'H030003',
  'h_units_2' = 'H030004',
  'h_units_3or4' = 'H030005',
  'h_units_5to9' = 'H030006',
  'h_units_10to19' = 'H030007',
  'h_units_20to49' = 'H030008',
  'h_units_50more' = 'H030009',
  'h_units_MH' = 'H030010',
  'h_units_BoatRV' = 'H030011'
)

edu_vars_00 <- c(
  "totpop25over" = "P148C001",
  "male_below_hs_1" = "P148C003",
  "male_below_hs_2" = "P148C004",
  "male_ba" = "P148C008",
  "male_ma" = "P148C009",
  "female_below_hs_1" = "P148C011",
  "female_below_hs_2" = "P148C012",
  "female_ba" = "P148C016",
  "female_ma" = "P148C017",
  "only_english" = "PCT011002"
)

varlist_00_sf1 = list(race_vars_00,
                      tenure_vars_00_sf1)
varlist_00_sf3 = list(tenure_vars_00_sf3,
                      income_vars_00,
                      burden_vars_00,
                      hh_vars_00,
                      edu_vars_00
)

#######################################################################
###### 1990 Variables  ################################################
#######################################################################



#######################################################################
###### Dataset Creation ###############################################
#######################################################################

state = "IL"
county = "Cook"

acs19 <- data.frame(
  GEOID = character(),
  estimate = numeric())

acs10 <- data.frame(
  GEOID = character(),
  estimate = numeric())

census00 <- data.frame(
  GEOID = character(),
  value = numeric())

census90 <- data.frame(
  GEOID = character(),
  value = numeric())

for(var in varlist_19){
  acs19 <- bind_rows(acs19, get_acs(geography = "tract", 
                                    variables = var, 
                                    state = state,
                                    county = county,
                                    year = 2019,
                                    geometry = FALSE,
                                    cache_table = FALSE,
                                    key = CENSUS_API_KEY,
                                    survey = "acs5"))
}
#acs19[is.na(acs19)] <- 0
for(var in varlist_10){
  acs10 <- bind_rows(acs10, get_acs(geography = "tract", 
                                    variables = var, 
                                    state = state,
                                    county = county,
                                    year = 2010,
                                    geometry = FALSE,
                                    cache_table = FALSE,
                                    survey = "acs5"))
}   
#acs10[is.na(acs10)] <- 0
for(var in varlist_00_sf1){
  census00 <- bind_rows(census00, get_decennial(geography = "tract", 
                                                variables = var, 
                                                state = state,
                                                county = county,
                                                year = 2000,
                                                geometry = FALSE,
                                                cache_table = FALSE,
                                                sumfile = "sf1"))
}
for(var in varlist_00_sf3){
  census00 <- bind_rows(census00, get_decennial(geography = "tract", 
                                                variables = var, 
                                                state = state,
                                                county = county,
                                                year = 2000,
                                                geometry = FALSE,
                                                cache_table = FALSE,
                                                sumfile = "sf3"))
}
#census00[is.na(census00)] <- 0

acs19 <- acs19 %>% select(-moe, -NAME) %>%
  group_by(GEOID) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>%
  mutate(below_hs = below_hs_1 + below_hs_2) %>%
  select(-below_hs_1, -below_hs_2) %>%
  pivot_longer(cols = !GEOID, names_to = "variable", values_to = "estimate") %>%
  ungroup()

acs10 <- acs10 %>% select(-moe, -NAME) %>%
  group_by(GEOID) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>%
  mutate(poverty_rate = poverty/poverty_base,
         built_2000_2009 = built_2000_2004 + built_2005_on,
         below_hs = below_hs_1 + below_hs_2) %>%
  select(-poverty, -poverty_base,
         -built_2000_2004, -built_2005_on,
         -below_hs_1, -below_hs_2) %>%
  pivot_longer(cols = !GEOID, names_to = "variable", values_to = "estimate") %>%
  ungroup()

census00 <- census00 %>% select(-NAME) %>%
  group_by(GEOID) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(poverty_rate = poverty/poverty_base,
         renterp = renter_count/hh_count,
         ownerp = owner_count/hh_count,
         built_1990_1999 = built_1990_1994 + built_1995_1998 + built_1999_2000,
         below_hs = (male_below_hs_1 + male_below_hs_2 + female_below_hs_1 + female_below_hs_2),
         highschool = totpop25over - below_hs,
         ba_higher = male_ba + male_ma + female_ba + female_ma,
         ma_higher = male_ma + female_ma,
         unemployment = 100*(unemployment_1 + unemployment_2 + unemployment_3 + unemployment_4 + 
           unemployment_5 + unemployment_6 + unemployment_7 + unemployment_8 + 
           unemployment_9 + unemployment_10 + unemployment_11 + unemployment_12 + 
           unemployment_13 + unemployment_14 + unemployment_15 + unemployment_16 + 
           unemployment_17 + unemployment_18 + unemployment_19 + unemployment_20 +
           unemployment_21 + unemployment_22 + unemployment_23 + unemployment_24 + 
           unemployment_25 + unemployment_26)/unemployment_base,
         rentocc_rentburden_less20k = rentocc_rentburden_less20k_1 + rentocc_rentburden_less20k_2,
         rentocc_rentburden_20k_35k = rentocc_rentburden_20k_35k_1 + rentocc_rentburden_20k_35k_2,
         rentocc_rentburden_35k_50k = rentocc_rentburden_35k_50k_1 + rentocc_rentburden_35k_50k_2,
         rentocc_rentburden_50k_75k = rentocc_rentburden_50k_75k_1 + rentocc_rentburden_50k_75k_2,
         rentocc_rentburden_75kmore = rentocc_rentburden_75k_100k_1 + rentocc_rentburden_75k_100k_2 +
           rentocc_rentburden_100kmore_1 + rentocc_rentburden_100kmore_2) %>%
  select(-poverty, -poverty_base, -matches("unemployment_"),
         -male_below_hs_1, -male_below_hs_2, -female_below_hs_1, -female_below_hs_2,
         -male_ba, -male_ma, -female_ba, -female_ma,
         -built_1990_1994, -built_1995_1998, -built_1999_2000,
         -matches("rentocc_rentburden_less20k_"), -matches("rentocc_rentburden_20k_35k_"),
         -matches("rentocc_rentburden_35k_50k_"), -matches("rentocc_rentburden_50k_75k_"),
         -matches("rentocc_rentburden_75k_100k"), -matches("rentocc_rentburden_100kmore")) %>%
  mutate_at(vars(below_hs, highschool, ba_higher, ma_higher), ~ 100*./totpop25over) %>%
  pivot_longer(cols = !GEOID, names_to = "variable", values_to = "value") %>%
  ungroup()

ltdb  =  read.csv('~/Git/displacement-measure/data/raw/crosswalk_2000_2010.csv', 
                  colClasses=c(
                    "trtid00"="character", 
                    "trtid10"="character")) 

meds <- c("built_median", "homeval_med", "med_age", "med_rent", "medinc")

#Weighted sums for crosswalk 
temp <- ltdb %>% inner_join( 
  census00 %>% filter(!(variable %in% meds)), 
  by = c("trtid00" = "GEOID")) %>%
  mutate(estimate = value*weight) %>%
  group_by(trtid10, variable) %>%
  summarise(estimate = sum(estimate)) %>%
  rename(GEOID = trtid10)

#Calculate adjusted weights, to create more accurate median estimates
ltdb2 <- ltdb %>%     
  group_by(trtid10) %>%
  mutate(sum = sum(weight)) %>%
  mutate(adjusted_weight = weight/sum) %>%
  rename(GEOID = trtid10)

# weighted averages for median values crosswalked
temp_meds <- ltdb2 %>% inner_join( 
  census00 %>% subset((variable %in% meds)), 
  by = c("trtid00"="GEOID")) %>% mutate(
    adjusted_estimate = value*adjusted_weight) %>%
  dplyr::group_by(GEOID, variable) %>% 
  summarise(estimate = sum(adjusted_estimate))%>% 
  mutate(estimate = round(estimate, digits = 2))

census00_ltdb <- rbind(temp, temp_meds)

full <- acs19 %>%
  select(GEOID, variable, est2019 = estimate) %>%
  full_join(
    acs10 %>%
      select(GEOID, variable, est2010 = estimate)) %>%
  full_join(
    census00_ltdb %>%
      select(GEOID, variable, est2000 = estimate)) %>%
  distinct(.keep_all = TRUE) %>%
  arrange(GEOID, variable)

fwrite(full, "~/Git/variables_and_functions/data/output/vars.csv")
