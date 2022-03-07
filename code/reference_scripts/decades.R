#######################################################################################
################# Pulling census data for 1990, 2000, 2010, and 2019 ##################
#######################################################################################


### Loading required packages and setting defaults
if(!require(pacman)) install.packages("pacman")
p_load(tidyr, dplyr, tigris, tidycensus, yaml, sf, stringr, fst,
       googledrive, bit64,magrittr, fs, data.table, tidyverse, spdep)
p_load_gh("keberwein/blscrapeR")
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
  #"med_age" = "B01002_001",
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
  "total_units" = "B25002_001",
  "occupied_units" = "B25002_002",
  "vacant_units" = "B25002_003",
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
  
  "hh_Black" = "B19001B_001",
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
  "hh_Asian" = "B19001D_001",
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
  "hh_WhiteNonHisp" =  "B19001H_001",
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
  "hh_Latinx" = "B19001I_001",
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
  "rent_0_100" = "B25063_003",
  "rent_100_150" = "B25063_004",
  "rent_150_200" = "B25063_005",
  "rent_200_250" = "B25063_006",
  "rent_250_300" = "B25063_007",
  "rent_300_350" = "B25063_008",
  "rent_350_400" = "B25063_009",
  "rent_400_450" = "B25063_010",
  "rent_450_500" = "B25063_011",
  "rent_500_550" = "B25063_012",
  "rent_550_600" = "B25063_013",
  "rent_600_650" = "B25063_014",
  "rent_650_700" = "B25063_015",
  "rent_700_750" = "B25063_016",
  "rent_750_800" = "B25063_017",
  "rent_800_900" = "B25063_018",
  "rent_900_1000" = "B25063_019",
  "rent_1000_1250" = "B25063_020",
  "rent_1250_1500" = "B25063_021",
  "rent_1500_2000" = "B25063_022",
  "rent_2000_2500" = "B25063_023",
  "rent_2500_3000" = "B25063_024",
  "rent_3000_3500" = "B25063_025",
  "rent_3500_more" = "B25063_026",
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
  "totpop25over" = "B15002_001",
  "below_hs_1" = "S1501_C01_007",
  "below_hs_2" = "S1501_C01_008",
  "highschool" = "S1501_C01_009",
  "ba_higher" = "S1501_C01_015",
  "ma_higher" = "S1501_C01_013",
  "totpop5over" = "B06007_001",
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
  #"med_age" = "B01002_001",
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
  "total_units" = "B25002_001",
  "occupied_units" = "B25002_002",
  "vacant_units" = "B25002_003",
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
  
  "hh_Black" = "B19001B_001",
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
  "hh_Asian" =  "B19001D_001",
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
  "hh_WhiteNonHisp" =  "B19001H_001",
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
  "hh_Latinx" =  "B19001I_001",
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
  "rent_0_100" = "B25063_003",
  "rent_100_150" = "B25063_004",
  "rent_150_200" = "B25063_005",
  "rent_200_250" = "B25063_006",
  "rent_250_300" = "B25063_007",
  "rent_300_350" = "B25063_008",
  "rent_350_400" = "B25063_009",
  "rent_400_450" = "B25063_010",
  "rent_450_500" = "B25063_011",
  "rent_500_550" = "B25063_012",
  "rent_550_600" = "B25063_013",
  "rent_600_650" = "B25063_014",
  "rent_650_700" = "B25063_015",
  "rent_700_750" = "B25063_016",
  "rent_750_800" = "B25063_017",
  "rent_800_900" = "B25063_018",
  "rent_900_1000" = "B25063_019",
  "rent_1000_1250" = "B25063_020",
  "rent_1250_1500" = "B25063_021",
  "rent_1500_2000" = "B25063_022",
  "rent_2000_more" = "B25063_023",
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
  "male_below_hs_1" = "B15002_003",
  "male_below_hs_2" = "B15002_004",
  "male_below_hs_3" = "B15002_005",
  "male_below_hs_4" = "B15002_006",
  "male_below_hs_5" = "B15002_007",
  "male_below_hs_6" = "B15002_008",
  "male_below_hs_7" = "B15002_009",
  "male_below_hs_8" = "B15002_010",
  "male_highschool" = "B15002_011",
  "male_ba" = "B15002_015",
  "male_ma" = "B15002_016", 
  "male_psd" = "B15002_017", 
  "male_phd" = "B15002_018", 
  "female_below_hs_1" = "B15002_020",
  "female_below_hs_2" = "B15002_021",
  "female_below_hs_3" = "B15002_022",
  "female_below_hs_4" = "B15002_023",
  "female_below_hs_5" = "B15002_024",
  "female_below_hs_6" = "B15002_025",
  "female_below_hs_7" = "B15002_026",
  "female_below_hs_8" = "B15002_027",
  "female_highschool" = "B15002_028",
  "female_ba" = "B15002_032",
  "female_ma" = "B15002_033", 
  "female_psd" = "B15002_034", 
  "female_phd" = "B15002_035", 
  "totpop5over" = "B06007_001",
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
  "population" = "P001001",
  "white" =  "P007003",
  "black" =  "P007004",
  "amind" =  "P007005",
  "asian" =  "P007006",
  "pacis" =  "P007007",
  "other" =  "P007008",
  "race2" =  "P007009",
  "latinx" = "P007010")

tenure_vars_00 <- c(
  #"hh_count" = "H007001",
  "hh_count" =  "P052001",
  "owner_count" = "H007002",
  "renter_count" = "H007003",
  "homeval_lower_quartile" = "H075001",
  "homeval_med" = "H076001",
  "homeval_upper_quartile" = "H077001",
  "total_units" = "H006001",
  "occupied_units" = "H006002",
  "vacant_units" = "H006003",
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
  
  "hh_Black" =  "P151B001",
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
  "hh_Asian" =  "P151D001",
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
  "hh_WhiteNonHisp" =  "P151I001",
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
  "hh_Latinx" =  "P151H001",
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
  "rent_0_100" = "H062003",
  "rent_100_150" = "H062004",
  "rent_150_200" = "H062005",
  "rent_200_250" = "H062006",
  "rent_250_300" = "H062007",
  "rent_300_350" = "H062008",
  "rent_350_400" = "H062009",
  "rent_400_450" = "H062010",
  "rent_450_500" = "H062011",
  "rent_500_550" = "H062012",
  "rent_550_600" = "H062013",
  "rent_600_650" = "H062014",
  "rent_650_700" = "H062015",
  "rent_700_750" = "H062016",
  "rent_750_800" = "H062017",
  "rent_800_900" = "H062018",
  "rent_900_1000" = "H062019",
  "rent_1000_1250" = "H062020",
  "rent_1250_1500" = "H062021",
  "rent_1500_2000" = "H062022",
  "rent_2000_more" = "H062023",
  "poverty_base"  =  "P087001",
  "poverty"  =  "P087002",
  "unemployment_base" = "P043001",
  "unemployment_1" =  "P043007",
  "unemployment_2" =  "P043014",
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
  "totpop25over" = "P037001",
  "male_below_hs_1" = "P037003",
  "male_below_hs_2" = "P037004",
  "male_below_hs_3" = "P037005",
  "male_below_hs_4" = "P037006",
  "male_below_hs_5" = "P037007",
  "male_below_hs_6" = "P037008",
  "male_below_hs_7" = "P037009",
  "male_below_hs_8" = "P037010",
  "male_ba" = "P037015",
  "male_ma" = "P037016",
  "male_psd" = "P037017",
  "male_phd" = "P037018",
  "female_below_hs_1" = "P037020",
  "female_below_hs_2" = "P037021",
  "female_below_hs_3" = "P037022",
  "female_below_hs_4" = "P037023",
  "female_below_hs_5" = "P037024",
  "female_below_hs_6" = "P037025",
  "female_below_hs_7" = "P037026",
  "female_below_hs_8" = "P037027",
  "female_ba" = "P037032",
  "female_ma" = "P037033",
  "female_psd" = "P037034",
  "female_phd" = "P037035",
  "totpop5over" = "PCT011001",
  "only_english" = "PCT011002"
)

varlist_00 = list(race_vars_00,
                  tenure_vars_00,
                  income_vars_00,
                  burden_vars_00,
                  hh_vars_00,
                  edu_vars_00
)

#######################################################################
###### 1990 Variables  ################################################
#######################################################################

race_vars_90 <- c( ##sf1
  "population"= "ET1001",
  #"med_age" = "P013001",
  "white" =  "ET2001",
  "black" =  "ET2002",
  "amind" =  "ET2003",
  "asian_pacis" =  "ET2004",
  #"pacis" =  "P004009",
  "other_race2" =  "ET2005",
  #"race2" =  "P004011",
  "latinx" = "P004002"
  )

tenure_vars_90_sf1 <- c(
  "hh_count" = "EUO001",
  "owner_count" = "ES1001",
  "renter_count" = "ES1002",
  "homeval_lower_quartile" = "ESS001",
  "homeval_med" = "EST001",
  "homeval_upper_quartile" = "ESU001",
  "total_units" = "ESA001",
  "occupied_units" = "ESN001",
  "vacant_units" = "ESN002",
  'ownocc_.5_less_per_room' = 'ESQ001',
  'ownocc_.5to1_per_room' = 'ESQ002',
  'ownocc_1to1.5_per_room' = 'ESQ003',
  'ownocc_1.5to2_per_room' = 'ESQ004',
  'ownocc_2more_per_room' = 'ESQ005',
  'rentocc_.5_less_per_room' = 'ESQ006',
  'rentocc_.5to1_per_room' = 'ESQ007',
  'rentocc_1to1.5_per_room' = 'ESQ008',
  'rentocc_1.5to2_per_room' = 'ESQ009',
  'rentocc_2more_per_room' = 'ESQ010')

tenure_vars_90_sf3 <- c(
  "built_1998_on" = "EX7001",
  "built_1985_1988" = "EX7002",
  "built_1980_1984" = "EX7003",
  "built_1970_1979" = "EX7004" ,
  "built_1960_1969" = "EX7005",
  "built_1950_1959" = "EX7006",
  "built_1940_1949" =  "EX7007",
  "built_1939_before" = "EX7008",
  "built_median" = "EX8001",
)

income_vars_90 <- c( ## sf3
  "medinc" = "E4U001",  
  "income_less_5k_all" =   "E4T001",
  "income_5k_10k_all"  =   "E4T002",
  "income_10k_12.5k_all" =   "E4T003",
  "income_12.5k_15k_all" =   "E4T004",
  "income_15k_17.5k_all" =   "E4T005",
  "income_17.5k_20k_all" =   "E4T006",
  "income_20k_22.5k_all" =   "E4T007",
  "income_22.5k_25k_all" =   "E4T008",
  "income_25k_27.5k_all" =   "E4T009",
  "income_27.5k_30k_all" =   "E4T010",
  "income_30k_32.5k_all" =   "E4T011",
  "income_32.5k_35k_all" =   "E4T012",
  "income_35k_37.5k_all" =   "E4T013",
  "income_37.5k_40k_all" =   "E4T014",
  "income_40k_42.5k_all" =   "E4T015",
  "income_42.5k_45k_all" =   "E4T016",
  "income_45k_47.5k_all" =   "E4T017",
  "income_47.5k_50k_all" =   "E4T018",
  "income_50k_55k_all" =   "E4T019",
  "income_55k_60k_all" =   "E4T020",
  "income_60k_75k_all" =   "E4T021",
  "income_75k_100k_all" =  "E4T022",
  "income_100k_125k_all" = "E4T023",
  "income_125k_150k_all" = "E4T024",
  "income_150k_more_all" = "E4T025",

  "income_less_5k_Black" =  "E4W010",
  "income_5k_10k_Black"  =  "E4W011",
  "income_10k_15k_Black" =   "E4W012",
  "income_15k_25k_Black" =   "E4W013",
  "income_25k_35k_Black" =   "E4W014",
  "income_35k_50k_Black" =   "E4W015",
  "income_50k_75k_Black" =   "E4W016",
  "income_75k_100k_Black" =  "E4W017",
  "income_100k_more_Black" = "E4W018",
  "income_less_5k_Asian" =  "E4W028",
  "income_5k_10k_Asian"  =  "E4W029",
  "income_10k_15k_Asian" =   "E4W030",
  "income_15k_25k_Asian" =   "E4W031",
  "income_25k_35k_Asian" =   "E4W032",
  "income_35k_50k_Asian" =   "E4W033",
  "income_50k_75k_Asian" =   "E4W034",
  "income_75k_100k_Asian" =  "E4W035",
  "income_100k_more_Asian" = "E4W036",
  "income_less_5k_WhiteNonHisp" =  "E4W001",
  "income_5k_10k_WhiteNonHisp"  =  "E4W002",
  "income_10k_15k_WhiteNonHisp" =   "E4W003",
  "income_15k_25k_WhiteNonHisp" =   "E4W004",
  "income_25k_35k_WhiteNonHisp" =   "E4W005",
  "income_35k_50k_WhiteNonHisp" =   "E4W006",
  "income_50k_75k_WhiteNonHisp" =   "E4W007",
  "income_75k_100k_WhiteNonHisp" =  "E4W008",
  "income_100k_more_WhiteNonHisp" = "E4W009",
  "income_less_5k_Asian" =  "E4X001",
  "income_5k_10k_Asian"  =  "E4X002",
  "income_10k_15k_Asian" =   "E4X003",
  "income_15k_25k_Asian" =   "E4X004",
  "income_25k_35k_Asian" =   "E4X005",
  "income_35k_50k_Asian" =   "E4X006",
  "income_50k_75k_Asian" =   "E4X007",
  "income_75k_100k_Asian" =  "E4X008",
  "income_100k_more_Asian" = "E4X009")

burden_vars_90 <- c(
  "rent_burden_0_10" = "H069002",
  "rent_burden_10_15" = "H069003",
  "rent_burden_15_20" = "H069004",
  "rent_burden_20_25" = "H069005",
  "rent_burden_25_30" = "H069006",
  "rent_burden_30_35" = "H069007",
  "rent_burden_35_40" = "H069008",
  "rent_burden_40_50" = "H069009",
  "rent_burden_50_more" = "H069010",
  
  "rentocc_rentburden_less10k_1" = "EY2004",
  "rentocc_rentburden_less10k_2" = "EY2005",
  "rentocc_rentburden_10k_20k_1" = "EY2010",
  "rentocc_rentburden_10k_20k_2" = "EY2011",
  "rentocc_rentburden_20k_35k_1" = "EY2016",
  "rentocc_rentburden_20k_35k_2" = "EY2017",
  "rentocc_rentburden_35k_50k_1" = "EY2022",
  "rentocc_rentburden_35k_50k_2" = "EY2023",
  "rentocc_rentburden_50k_more_1" = "EY2028",
  "rentocc_rentburden_50k_more_2" = "EY2029",
  "med_rent" = "EYU001",
  "med_rent_percent_income" = "H070001",
  "rent_0_100" = "EYT001",
  "rent_100_150" = "EYT002",
  "rent_150_200" = "EYT003",
  "rent_200_250" = "EYT004",
  "rent_250_300" = "EYT005",
  "rent_300_350" = "EYT006",
  "rent_350_400" = "EYT007",
  "rent_400_450" = "EYT008",
  "rent_450_500" = "EYT009",
  "rent_500_550" = "EYT010",
  "rent_550_600" = "EYT011",
  "rent_600_650" = "EYT012",
  "rent_650_700" = "EYT013",
  "rent_700_750" = "EYT014",
  "rent_750_1000" = "EYT015",
  "rent_1000_more" = "EYT016",
  "poverty_base"  =  "P087001",
  "poverty_1"  =  "E1C001",
  "poverty_2"  =  "E1C002",
  "poverty_3"  =  "E1C003",
  "unemployment_base" = "P043001",
  "unemployment_1" =  "E4I003",
  "unemployment_2" =  "E4I007",
  "welfare" = "E5A001",
  "h_units_w_mortgage_30_35perc" = "EZC004",
  "h_units_w_mortgage_35moreperc" = "EZC005",
)

hh_vars_90 <- c( 
  #"avg_hh_size" = "H018001",
  'h_units_1_detached' = 'ETH001',
  'h_units_1_attached' = 'ETH002',
  'h_units_2' = 'ETH003',
  'h_units_3or4' = 'ETH004',
  'h_units_5to9' = 'ETH005',
  'h_units_10to19' = 'ETH006',
  'h_units_20to49' = 'ETH007',
  'h_units_50more' = 'ETH008',
  'h_units_MH' = 'ETH009',
  'h_units_BoatRV' = 'ETH010'
)

edu_vars_90 <- c(
  "totpop25over" = "P148C001",
  "below_hs_1" = "E33001",
  "below_hs_2" = "E33002",
  "ba" = "E33006",
  "ma" = "E33007",
  "only_english" = "PCT011002"
)

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
for(var in varlist_00){
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
  mutate(below_hs = below_hs_1 + below_hs_2,
         rent_2000_more = rent_2000_2500 + rent_2500_3000 + rent_3000_3500 + rent_3500_more) %>%
  select(-below_hs_1, -below_hs_2,
         -rent_2000_2500, -rent_2500_3000, -rent_3000_3500, -rent_3500_more) %>%
  pivot_longer(cols = !GEOID, names_to = "variable", values_to = "estimate") %>%
  ungroup()

acs10 <- acs10 %>% select(-moe, -NAME) %>%
  group_by(GEOID) %>%
  pivot_wider(names_from = variable, values_from = estimate) %>%
  mutate(poverty_rate = 100*poverty/poverty_base,
         built_2000_2009 = built_2000_2004 + built_2005_on,
         below_hs = male_below_hs_1 + male_below_hs_2 + male_below_hs_3 + male_below_hs_4 +
           male_below_hs_5 + male_below_hs_6 + male_below_hs_7 + male_below_hs_8 +
           female_below_hs_1 + female_below_hs_2 + female_below_hs_3 + female_below_hs_4 +
           female_below_hs_5 + female_below_hs_6 + female_below_hs_7 + female_below_hs_8,
         highschool = totpop25over - below_hs,
         ba_higher = male_ba + male_ma + male_psd + male_phd + female_ba + female_ma + female_psd + female_phd,
         ma_higher = male_ma + male_psd + male_phd + female_ma + female_psd + female_phd) %>%
  select(-poverty, -poverty_base,
         -matches("male_"),
         -built_2000_2004, -built_2005_on) %>%
  pivot_longer(cols = !GEOID, names_to = "variable", values_to = "estimate") %>%
  ungroup()

census00 <- census00 %>% select(-NAME) %>%
  group_by(GEOID) %>%
  pivot_wider(names_from = variable, values_from = value) %>%
  mutate(poverty_rate = 100*poverty/poverty_base,
         renterp = 100*renter_count/hh_count,
         ownerp = 100*owner_count/hh_count,
         built_1990_1999 = built_1990_1994 + built_1995_1998 + built_1999_2000,
         below_hs = male_below_hs_1 + male_below_hs_2 + male_below_hs_3 + male_below_hs_4 +
                       male_below_hs_5 + male_below_hs_6 + male_below_hs_7 + male_below_hs_8 +
                       female_below_hs_1 + female_below_hs_2 + female_below_hs_3 + female_below_hs_4 +
                       female_below_hs_5 + female_below_hs_6 + female_below_hs_7 + female_below_hs_8,
         highschool = totpop25over - below_hs,
         ba_higher = male_ba + male_ma + male_psd + male_phd + female_ba + female_ma + female_psd + female_phd,
         ma_higher = male_ma + male_psd + male_phd + female_ma + female_psd + female_phd,
         unemployment = 100*(unemployment_1 + unemployment_2)/unemployment_base,
         rentocc_rentburden_less20k = rentocc_rentburden_less20k_1 + rentocc_rentburden_less20k_2,
         rentocc_rentburden_20k_35k = rentocc_rentburden_20k_35k_1 + rentocc_rentburden_20k_35k_2,
         rentocc_rentburden_35k_50k = rentocc_rentburden_35k_50k_1 + rentocc_rentburden_35k_50k_2,
         rentocc_rentburden_50k_75k = rentocc_rentburden_50k_75k_1 + rentocc_rentburden_50k_75k_2,
         rentocc_rentburden_75kmore = rentocc_rentburden_75k_100k_1 + rentocc_rentburden_75k_100k_2 +
           rentocc_rentburden_100kmore_1 + rentocc_rentburden_100kmore_2) %>%
  select(-poverty, -poverty_base, -matches("unemployment_"),
         -matches("male_"),
         -built_1990_1994, -built_1995_1998, -built_1999_2000,
         -matches("rentocc_rentburden_less20k_"), -matches("rentocc_rentburden_20k_35k_"),
         -matches("rentocc_rentburden_35k_50k_"), -matches("rentocc_rentburden_50k_75k_"),
         -matches("rentocc_rentburden_75k_100k"), -matches("rentocc_rentburden_100kmore")) %>%
  pivot_longer(cols = !GEOID, names_to = "variable", values_to = "value") %>%
  ungroup()

ltdb  =  read.csv('~/Git/displacement-measure/data/raw/crosswalk_2000_2010.csv', 
                  colClasses=c(
                    "trtid00"="character", 
                    "trtid10"="character")) 

meds <- c("built_median", "homeval_med", "med_rent", "medinc",
          "avg_hh_size", "homeval_lower_quartile", "homeval_upper_quartile")
pcts <- c("renterp", "ownerp", "med_rent_percent_income", "poverty_rate")

#Weighted sums for crosswalk 
temp <- ltdb %>% inner_join( 
  census00 %>% filter(!(variable %in% meds) & !(variable %in% pcts)), 
  by = c("trtid00" = "GEOID")) %>%
  mutate(estimate = value*weight) %>%
  group_by(trtid10, variable) %>%
  summarise(estimate = sum(estimate)) %>%
  rename(GEOID = trtid10)

temp_pct <- ltdb %>% inner_join(
  census00 %>% filter(variable %in% pcts), 
  by = c("trtid00" = "GEOID")) %>%
  group_by(trtid10, variable) %>%
  summarize(estimate = weighted.mean(value, weight, na.rm = TRUE)) %>%
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

census00_ltdb <- rbind(temp, temp_pct, temp_meds)

full <- acs19 %>%
  select(GEOID, variable, `2019` = estimate) %>%
  full_join(
    acs10 %>%
      select(GEOID, variable, `2010` = estimate)) %>%
  full_join(
    census00_ltdb %>%
      select(GEOID, variable, `2000` = estimate)) %>%
  distinct(.keep_all = TRUE) %>%
  arrange(GEOID, variable)

full <- full %>%
  mutate(`2010` = ifelse(variable %in% c("homeval_lower_quartile", "homeval_med", "homeval_upper_quartile", "med_rent", "medinc"),
                         1.16164*`2010`, `2010`),
         `2000` = ifelse(variable %in% c("homeval_lower_quartile", "homeval_med", "homeval_upper_quartile", "med_rent", "medinc"),
                         1.49118*`2000`, `2000`))

closest <- function(x, limits) {
  unlist(sapply(x, function(x, limits) limits[which.min(abs(limits - x))], limits))
}
incomes <- c(10000, 15000, 20000, 25000, 30000, 35000, 40000, 45000,
             50000, 60000, 75000, 100000, 125000, 150000, 200000, Inf)
rents <- c(100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 
           700, 750, 800, 900, 1000, 1250, 1500, 2000, Inf)

county_mhi <- bind_rows(
  get_acs(geography = "county", state = state, variables = "B19013_001", year = 2019) %>% mutate(YEAR = 2019),
  get_acs(geography = "county", state = state, variables = "B19013_001", year = 2010) %>% mutate(YEAR = 2010),
  get_decennial(geography = "county", state = state, variables = "P053001", year = 2000) %>% mutate(YEAR = 2000) %>% rename(estimate = value)
) %>% filter(str_detect(NAME, county)) %>%
  select(NAME, YEAR, AMI = estimate) %>%
  mutate(AMI80 = 0.8*AMI,
         AMI120 = 1.2*AMI,
         RENT80 = 0.3*AMI80/12,
         RENT120 = 0.3*AMI120/12) %>%
  mutate(AMI_LI = ifelse(!is.na(AMI80), closest(AMI80, incomes), NA),
         AMI_HI = ifelse(!is.na(AMI120), closest(AMI120, incomes), NA),
         RENT_LI = ifelse(!is.na(RENT80), closest(RENT80, rents), NA),
         RENT_HI = ifelse(!is.na(RENT120), closest(RENT120, rents), NA))

tract_mhi <- full %>% filter(str_detect(variable, "income_")) %>%
  separate(variable, c("var", "lower", "upper", "type"), remove = FALSE) %>%
  mutate_at(vars(lower, upper), function(x) str_replace(x, "k", "000")) %>%
  mutate_at(vars(lower, upper), function(x) ifelse(x == "less", "0", x)) %>%
  mutate_at(vars(lower, upper), function(x) ifelse(x == "more", "Inf", x)) %>%
  mutate_at(vars(lower, upper), as.numeric) %>%
  mutate(income2019 = case_when(
    upper <= county_mhi$AMI_LI[county_mhi$YEAR == 2019] ~ "LI",
    upper <= county_mhi$AMI_HI[county_mhi$YEAR == 2019] ~ "MI",
    upper > county_mhi$AMI_HI[county_mhi$YEAR == 2019] ~ "HI",
  )) %>%
  mutate(income2010 = case_when(
    upper <= county_mhi$AMI_LI[county_mhi$YEAR == 2010] ~ "LI",
    upper <= county_mhi$AMI_HI[county_mhi$YEAR == 2010] ~ "MI",
    upper > county_mhi$AMI_HI[county_mhi$YEAR == 2010] ~ "HI",
  )) %>%
  mutate(income2000 = case_when(
    upper <= county_mhi$AMI_LI[county_mhi$YEAR == 2000] ~ "LI",
    upper <= county_mhi$AMI_HI[county_mhi$YEAR == 2000] ~ "MI",
    upper > county_mhi$AMI_HI[county_mhi$YEAR == 2000] ~ "HI",
  ))

tract_rent <- full %>% filter(str_detect(variable, "rent_[0-9]")) %>%
  separate(variable, c("var", "lower", "upper"), remove = FALSE) %>%
  mutate_at(vars(lower, upper), function(x) ifelse(x == "more", "Inf", x)) %>%
  mutate_at(vars(lower, upper), as.numeric) %>%
  mutate(rent2019 = case_when(
    upper <= county_mhi$RENT_LI[county_mhi$YEAR == 2019] ~ "LI",
    upper <= county_mhi$RENT_HI[county_mhi$YEAR == 2019] ~ "MI",
    upper > county_mhi$RENT_HI[county_mhi$YEAR == 2019] ~ "HI",
  )) %>%
  mutate(rent2010 = case_when(
    upper <= county_mhi$RENT_LI[county_mhi$YEAR == 2010] ~ "LI",
    upper <= county_mhi$RENT_HI[county_mhi$YEAR == 2010] ~ "MI",
    upper > county_mhi$RENT_HI[county_mhi$YEAR == 2010] ~ "HI",
  )) %>%
  mutate(rent2000 = case_when(
    upper <= county_mhi$RENT_LI[county_mhi$YEAR == 2000] ~ "LI",
    upper <= county_mhi$RENT_HI[county_mhi$YEAR == 2000] ~ "MI",
    upper > county_mhi$RENT_HI[county_mhi$YEAR == 2000] ~ "HI",
  ))

full <- bind_rows(full,
                  tract_mhi %>% mutate(variable = paste(var, income2019, type, sep = "_")) %>%
                    group_by(GEOID, variable) %>% summarize(`2019` = sum(`2019`, na.rm = TRUE)) %>%
                    left_join(
                      tract_mhi %>% mutate(variable = paste(var, income2019, type, sep = "_")) %>%
                        group_by(GEOID, variable) %>% summarize(`2010` = sum(`2010`, na.rm = TRUE))
                    ) %>%
                    left_join(
                      tract_mhi %>% mutate(variable = paste(var, income2000, type, sep = "_")) %>%
                        group_by(GEOID, variable) %>% summarize(`2000` = sum(`2000`, na.rm = TRUE))
                    ),
                  tract_rent %>% mutate(variable = paste(var, rent2019, sep = "_")) %>%
                    group_by(GEOID, variable) %>% summarize(`2019` = sum(`2019`, na.rm = TRUE)) %>%
                    left_join(
                      tract_rent %>% mutate(variable = paste(var, rent2010, sep = "_")) %>%
                        group_by(GEOID, variable) %>% summarize(`2010` = sum(`2010`, na.rm = TRUE))
                    ) %>%
                    left_join(
                      tract_rent %>% mutate(variable = paste(var, rent2000, sep = "_")) %>%
                        group_by(GEOID, variable) %>% summarize(`2000` = sum(`2000`, na.rm = TRUE))
                    )
)

full_percent <- full %>% select(GEOID, variable, `2019`) %>%
    pivot_wider(names_from = "variable", values_from = "2019") %>%
    mutate_at(vars(amind, asian, black, latinx, other, white, pacis, race2, white), ~100*./population) %>%
    mutate_at(vars(matches("built"), -built_median, matches("h_units"), -matches("h_units_w_")), ~100*./total_units) %>%
    mutate_at(vars(matches("w_mortgage")), ~100*./owner_count) %>%
    mutate_at(vars(matches("income_") & matches("_Asian")), ~100*./hh_Asian) %>%
    mutate_at(vars(matches("income_") & matches("_Black")), ~100*./hh_Black) %>%
    mutate_at(vars(matches("income_") & matches("_WhiteNonHisp")), ~100*./hh_WhiteNonHisp) %>%
    mutate_at(vars(matches("income_") & matches("_Latinx")), ~100*./hh_Latinx) %>%
    mutate_at(vars(matches("income_") & matches("_all"), welfare), ~100*./hh_count) %>%
    mutate_at(vars(matches("income_") & matches("_owners")), ~100*./owner_count) %>%
    mutate_at(vars(matches("income_") & matches("_renters")), ~100*./renter_count) %>%
    mutate_at(vars(matches("rent_"), matches("rentocc_"), -med_rent_percent_income), ~100*./renter_count) %>%
    mutate_at(vars(matches("ownocc_")), ~100*./owner_count) %>%
    mutate_at(vars(below_hs, highschool, ba_higher, ma_higher), ~100*./totpop25over) %>%
    mutate(vacant_units = 100*vacant_units/total_units,
           only_english = 100*only_english/totpop5over) %>%
    pivot_longer(cols = !GEOID, names_to = "variable", values_to = "2019") %>%
  left_join(
    full %>% select(GEOID, variable, `2010`) %>%
      pivot_wider(names_from = "variable", values_from = "2010") %>%
      mutate_at(vars(amind, asian, black, latinx, other, white, pacis, race2, white), ~100*./population) %>%
      mutate_at(vars(matches("built"), -built_median, matches("h_units"), -matches("h_units_w_")), ~100*./total_units) %>%
      mutate_at(vars(matches("w_mortgage")), ~100*./owner_count) %>%
      mutate_at(vars(matches("income_") & matches("_Asian")), ~100*./hh_Asian) %>%
      mutate_at(vars(matches("income_") & matches("_Black")), ~100*./hh_Black) %>%
      mutate_at(vars(matches("income_") & matches("_WhiteNonHisp")), ~100*./hh_WhiteNonHisp) %>%
      mutate_at(vars(matches("income_") & matches("_Latinx")), ~100*./hh_Latinx) %>%
      mutate_at(vars(matches("income_") & matches("_all"), welfare), ~100*./hh_count) %>%
      mutate_at(vars(matches("income_") & matches("_owners")), ~100*./owner_count) %>%
      mutate_at(vars(matches("income_") & matches("_renters")), ~100*./renter_count) %>%
      mutate_at(vars(matches("rent_"), matches("rentocc_"), -med_rent_percent_income), ~100*./renter_count) %>%
      mutate_at(vars(matches("ownocc_")), ~100*./owner_count) %>%
      mutate_at(vars(below_hs, highschool, ba_higher, ma_higher), ~100*./totpop25over) %>%
      mutate(vacant_units = 100*vacant_units/total_units,
             only_english = 100*only_english/totpop5over) %>%
      pivot_longer(cols = !GEOID, names_to = "variable", values_to = "2010")
  ) %>% left_join(
    full %>% select(GEOID, variable, `2000`) %>%
      pivot_wider(names_from = "variable", values_from = "2000") %>%
      mutate_at(vars(amind, asian, black, latinx, other, white, pacis, race2, white), ~100*./population) %>%
      mutate_at(vars(matches("built"), -built_median, matches("h_units"), -matches("h_units_w_")), ~100*./total_units) %>%
      mutate_at(vars(matches("w_mortgage")), ~100*./owner_count) %>%
      mutate_at(vars(matches("income_") & matches("_Asian")), ~100*./hh_Asian) %>%
      mutate_at(vars(matches("income_") & matches("_Black")), ~100*./hh_Black) %>%
      mutate_at(vars(matches("income_") & matches("_WhiteNonHisp")), ~100*./hh_WhiteNonHisp) %>%
      mutate_at(vars(matches("income_") & matches("_Latinx")), ~100*./hh_Latinx) %>%
      mutate_at(vars(matches("income_") & matches("_all"), welfare), ~100*./hh_count) %>%
      mutate_at(vars(matches("income_") & matches("_owners")), ~100*./owner_count) %>%
      mutate_at(vars(matches("income_") & matches("_renters")), ~100*./renter_count) %>%
      mutate_at(vars(matches("rent_"), matches("rentocc_"), -med_rent_percent_income), ~100*./renter_count) %>%
      mutate_at(vars(matches("ownocc_")), ~100*./owner_count) %>%
      mutate_at(vars(below_hs, highschool, ba_higher, ma_higher), ~100*./totpop25over) %>%
      mutate(vacant_units = 100*vacant_units/total_units,
             only_english = 100*only_english/totpop5over) %>%
      pivot_longer(cols = !GEOID, names_to = "variable", values_to = "2000")
  )

## Check for missing values (should only be variables for structures built post-survey)
full %>% filter(!(variable %in% (full %>% filter(!is.na(`2019`)) %>% pull(variable) %>% unique()))) %>% pull(variable) %>% unique()
full %>% filter(!(variable %in% (full %>% filter(!is.na(`2010`)) %>% pull(variable) %>% unique()))) %>% pull(variable) %>% unique()
full %>% filter(!(variable %in% (full %>% filter(!is.na(`2000`)) %>% pull(variable) %>% unique()))) %>% pull(variable) %>% unique()

write_rds(full, "~/Git/variables_and_functions/data/output/decades.rds")
write_rds(full_percent, "~/Git/variables_and_functions/data/output/decades_percent.rds")
