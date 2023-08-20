# ==========================================================================
# Get HUD Fair Market Rent
# Author: Alex Ramiller - 2020
# edits: tim thomas - 2022.05.31
# ==========================================================================

source("~/git/timathomas/functions/functions.r")
ipak_gh(c("jalvesaq/colorout"))

library("httr")
library("jsonlite")
library("yaml")
library("readxl")
library("stringr")
library("tidyverse")

select <- dplyr::select
hud <- 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjFiMDE2Mzk5YTUwOGVlYTg0MzZjNmViYjVmNGUzNzI2NWM0Nzg2N2U3MDM3NDQxNTE0YjYxMTk4ODgxN2NlMDk2YzEzNDdkODE4YzI5NGNjIn0.eyJhdWQiOiI2IiwianRpIjoiMWIwMTYzOTlhNTA4ZWVhODQzNmM2ZWJiNWY0ZTM3MjY1YzQ3ODY3ZTcwMzc0NDE1MTRiNjExOTg4ODE3Y2UwOTZjMTM0N2Q4MThjMjk0Y2MiLCJpYXQiOjE2NTQwMjI5ODQsIm5iZiI6MTY1NDAyMjk4NCwiZXhwIjoxOTY5NjQyMTg0LCJzdWIiOiIzNDIyMyIsInNjb3BlcyI6W119.PvMaDKLz59cV0MxSZhS7JEoQAftYdL0SPcBKc3TViNYyHuJei4biZDJLRw4Xb-VIVwbWl2pY8wq3438QZbkGtQ'
census <- '4c26aa6ebbaef54a55d3903212eabbb506ade381'

setwd("~/git/urban-displacement/edr-ut/data/fmr")

pull <- GET("https://www.huduser.gov/hudapi/public/fmr/listMetroAreas",
            config = add_headers(Authorization = paste("Bearer", hud)))
metro_areas <- as.data.frame(fromJSON(content(pull,type="text")), stringsAsFactors = FALSE)
  
pull_fmr <- function(name, metro_code){
  for(year in 2017:2023){
    pull <- GET(paste0("https://www.huduser.gov/hudapi/public/fmr/data/", metro_code, "?year=", year),
                config = add_headers(Authorization = paste("Bearer", hud)))
    fmr <- as.data.frame(fromJSON(content(pull,type="text"))$data$basicdata, stringsAsFactors = FALSE) %>%
      mutate(Metro = name,
             year = as.numeric(year)) %>%
      select(Metro, Year = year, fmr0 = Efficiency, fmr1 = One.Bedroom, fmr2 = Two.Bedroom, fmr3 = Three.Bedroom, fmr4 = Four.Bedroom)
    if(exists("output")){
      output <<- bind_rows(output, fmr)
    } else {
      output <<- fmr
    }
  }
}

pull_state_fmr <- function(name, state_code, metro_code){
  for(year in 2017:2023){
    pull <- GET(paste0("https://www.huduser.gov/hudapi/public/fmr/statedata/", state_code, "?year=", year),
                config = add_headers(Authorization = paste("Bearer", hud)))
    fmr <- as.data.frame(fromJSON(content(pull,type="text"))$data$metroareas, stringsAsFactors = FALSE) %>%
      filter(code == metro_code) %>%
      mutate(Metro = name,
             year = as.numeric(year)) %>%
      select(Metro, Year = year, fmr0 = Efficiency, fmr1 = `One-Bedroom`, fmr2 = `Two-Bedroom`, fmr3 = `Three-Bedroom`, fmr4 = `Four-Bedroom`)
    if(exists("output")){
      output <<- bind_rows(output, fmr)
    } else {
      output <<- fmr
    }
  }
}

            
#Oakland, San Francisco, Chicago, Kenosha, Gary, 
fmr2002 <- read_xls("FMR2002F.xls") %>%
  filter(str_detect(ID_AGIS2, "MSA5775|MSA7360|MSA1600|MSA3800|MSA2960|MSA1120|MSA1200|MSA4160|MSA1680|MSA7600|MSA8200")) %>%
  mutate(MSA1 = as.numeric(str_remove_all(ID_AGIS2, "MSA"))) %>%
  select(MSA1, fmr0 = FMR0BR, fmr1 = FMR1BR, fmr2 = FMR2BR, fmr3 = FMR3BR, fmr4 = FMR4BR)
fmr2003 <- read_xls("FMR2003F_County.xls") %>%
  filter(msa %in% c(5775, 7360, 1600, 3800, 2960, 1120, 1200, 4160, 1680, 7600, 8200)) %>%
  select(MSA1 = msa, fmr0 = FMR0, fmr1 = FMR1, fmr2 = FMR2, fmr3 = FMR3, fmr4 = FMR4) %>% distinct(.keep_all = TRUE)
fmr2004 <- read_xls("FMR2004F_County.xls") %>%
  filter(msa %in% c(5775, 7360, 1600, 3800, 2960, 1120, 1200, 4160, 1680, 7600, 8200)) %>%
  select(MSA1 = msa, fmr0 = New_FMR0, fmr1 = New_FMR1, fmr2 = New_FMR2, fmr3 = New_FMR3, fmr4 = New_FMR4) %>% distinct(.keep_all = TRUE)
fmr2005 <- read_xls("Revised_FY2005_CntLevel.xls") %>%
  filter(msa %in% c(5775, 7360, 1600, 3800, 2960, 1120, 1200, 4160, 1680, 7600, 8200)) %>%
  select(MSA1 = msa, fmr0 = FMR_0Bed, fmr1 = FMR_1Bed, fmr2 = FMR_2Bed, fmr3 = FMR_3Bed, fmr4 = FMR_4Bed) %>% distinct(.keep_all = TRUE)
fmr2006 <- read_xls("FY2006_County_Town.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2007 <- read_xls("FY2007F_County_Town.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2008 <- read_xls("FMR_county_fy2008r_rdds.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2009 <- read_xls("FY2009_4050_Rev_Final.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2010 <- read_xls("FY2010_4050_Final_PostRDDs.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2011 <- read_xls("FY2011_4050_Final.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2012 <- read_xls("FY2012_4050_Final.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2013 <- read_xls("FY2013_4050_Final.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2014 <- read_xls("FY2014_4050_RevFinal.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2015 <- read_xls("FY2015_4050_RevFinal.xls") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)
fmr2016 <- read_xlsx("FY2016F_4050_Final.xlsx") %>%
  filter(Metro_code %in% c("METRO41860MM5775", "METRO41860MM7360", "METRO16980M16980", "METRO16980MM3800", "METRO16980MM2960", "METRO14460MM1120", "METRO14460MM1200", "METRO14460MM4160", "METRO17460M17460", "METRO42660MM7600", "METRO42660MM8200")) %>%
  select(MSA2 = Metro_code, fmr0, fmr1, fmr2, fmr3, fmr4) %>% distinct(.keep_all = TRUE)

output <- bind_rows(fmr2002, fmr2003, fmr2004, fmr2005, fmr2006, fmr2007, fmr2008, fmr2009, fmr2010, fmr2011, fmr2012, fmr2013, fmr2014, fmr2015, fmr2016)
output$Metro <- case_when(
  output$MSA2 == "METRO41860MM5775" | output$MSA1 == 5775 ~ "Oakland",
  output$MSA2 == "METRO41860MM7360" | output$MSA1 == 7360 ~ "San Francisco",
  output$MSA2 == "METRO16980M16980" | output$MSA1 == 1600 ~ "Chicago",
  output$MSA2 == "METRO16980MM3800" | output$MSA1 == 3800 ~ "Kenosha",
  output$MSA2 == "METRO16980MM2960" | output$MSA1 == 2960 ~ "Gary",
  output$MSA2 == "METRO14460MM1120" | output$MSA1 == 1120 ~ "Boston",
  output$MSA2 == "METRO14460MM1200" | output$MSA1 == 1200 ~ "Brockton",
  output$MSA2 == "METRO14460MM4160" | output$MSA1 == 4160 ~ "Lawrence",
  output$MSA2 == "METRO17460M17460" | output$MSA1 == 1680 ~ "Cleveland",
  output$MSA2 == "METRO42660MM7600" | output$MSA1 == 7600 ~ "Seattle",
  output$MSA2 == "METRO42660MM8200" | output$MSA1 == 8200 ~ "Tacoma"
)
output$Year <- rep(2002:2016, each = 11)

output <- output %>% select(Metro, Year, fmr0, fmr1, fmr2, fmr3, fmr4)

pull_fmr("Oakland", "METRO41860MM5775")
pull_fmr("San Francisco", "METRO41860MM7360")

pull_state_fmr("Chicago", "IL", "METRO16980M16980")
pull_fmr("Kenosha", "METRO16980MM3800")
pull_state_fmr("Gary", "IN", "METRO16980MM2960")

pull_fmr("Boston", "METRO14460MM1120")
pull_fmr("Brockton", "METRO14460MM1200")
pull_fmr("Lawrence", "METRO14460MM4160")

pull_fmr("Cleveland", "METRO17460M17460")

pull_fmr("Seattle", "METRO42660MM7600")
pull_fmr("Tacoma", "METRO42660MM8200")

output <- output %>% arrange(Metro)

acs2018 <- 
  get_acs(
    geography = "metropolitan statistical area/micropolitan statistical area",
    variables = c("B25042_010", "B25042_011", "B25042_012", "B25042_013", "B25042_014", "B25042_015"),
    output = "tidy",
    year = 2018,
    geometry = FALSE,
    cache_table = TRUE,
    key = census
    ) %>%
  #mutate(variable = ifelse(variable == "B25042_015", "B25024_014", variable)) %>%
  #group_by(NAME, variable) %>%
  #summarize(estimate = sum(estimate)) %>%
  filter(str_detect(NAME, "San Francisco|Chicago|Boston|Cleveland|Seattle") &
           variable != "B25042_015") %>%
  filter(!str_detect(NAME, "Cleveland, ")) %>%
  select(-GEOID, -moe) %>%
  spread(variable, estimate) %>%
  arrange(NAME)

acs2018 <- bind_rows(acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018, acs2018 ,acs2018, acs2018) %>% arrange(NAME)

acs <- as.data.frame(rep(acs2018[1,], each = 19))

output$Metro <- factor(output$Metro,
                       levels = c("Boston", "Brockton", "Lawrence", "Chicago", "Gary", "Kenosha", "Cleveland", "San Francisco", "Oakland", "Seattle", "Tacoma"))
  
ggplot(data = output) +
    theme_minimal() +
    geom_line(aes(x = Year, y = fmr2, group = Metro, color = Metro)) +
    scale_color_manual(values = c("blue", "blue", "blue", "red", "red", "red", "green", "orange", "orange", "purple", "purple")) +
    scale_y_continuous("Fair Market Rent (2BR)", labels = scales::dollar) +
    scale_x_continuous(breaks=c(2002:2023)) +
  ggtitle("2BR Fair Market Rents") +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x = element_text(angle = -45, hjust = 0),
          panel.grid.minor.x = element_blank())

plot_metro <- function(metro){
  ggplot(data = output %>% 
         gather("Size", "Rent", fmr0, fmr1, fmr2, fmr3, fmr4) %>% 
         filter(Metro == metro)) +
  theme_minimal() +
  geom_line(aes(x = Year, y = Rent, group = Size, color = Size)) +
  scale_color_discrete(labels = c("Studio", "One Bedroom", "Two Bedroom", "Three Bedroom", "Four Bedroom")) +
  scale_y_continuous("Fair Market Rent", labels = scales::dollar) +
  scale_x_continuous(breaks=c(2002:2023)) +
    ggtitle(paste(metro, "FMR Area")) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = -45, hjust = 0.5),
        axis.text.y = element_text(hjust = 0.5),
        panel.grid.minor.x = element_blank())
}

plot_metro("San Francisco")
plot_metro("Oakland")
plot_metro("Seattle")
plot_metro("Tacoma")
plot_metro("Cleveland")
plot_metro("Chicago")
plot_metro("Kenosha")
plot_metro("Gary")
plot_metro("Boston")
plot_metro("Brockton")
plot_metro("Lawrence")
#+
    #annotate("text",
    #         x = 2023,
    #         y = output %>%
    #           filter(year == 2023) %>%
    #           pull(fmr2) * .98,
    #         label = paste0(output %>%
    #                          filter(year == 2023) %>%
    #                          pull(rb30_prop), "%")) +
    ##annotate("text",
    #         x = 2007,
    #         y = co_rbhh_df %>%
    #           filter(NAME == county,
    #                  year == 2007) %>%
    #           pull(rb30_total) * .98,
    #         label = paste0(co_rbhh_df %>%
    #                          filter(NAME == county,
    #                                 year == 2007) %>%
    #                          pull(rb30_prop), "%")) +
    #labs(title = paste0("The number of households facing rent burden in ",county),
    #     subtitle = "rent burden = 30% of household income going to rent",
    #     y = "Households",
    #     x = "Year",
    #     caption = "Data source: HUD Fair Market Rent data, the Bureau of Labor Statistics\nConsumer Price Index, & US Census American Community Survey")



Metro <- rep("Alameda", 16)
Year <- 2000:2015
Efficiency <- c(607, 761, 819, 905, 936, 945, 865)
One.Bedroom <- c(734, 921, 991, 1095, 1132, 1132, 1045)
Two.Bedroom <- c(921, 1155, 1243, 1374, 1420, 1342, 1238)
Three.Bedroom <- c(1263, 1583, 1704, 1883, 1947, 1870, 1679)
Four.Bedroom <- c(1509, 1891, 2035, 2249, 2325, 2293, 2079)
Alameda <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

Metro <- rep("San Francisco", 16)
Year <- 2000:2015
Efficiency <- c(832, 891, 1067, 1185, 1084, 1000, 998)
One.Bedroom <- c(1077, 1154, 1382, 1535, 1405, 1229, 1227)
Two.Bedroom <- c(1362, 1459, 1747, 1940, 1775, 1539, 1536)
Three.Bedroom <- c(1868, 2001, 2396, 2661, 2435, 2055, 2051)
Four.Bedroom <- c(1976, 2118, 2536, 2816, 2577, 2172, 2167)
SF <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

###

Metro <- rep("Cook", 16)
Year <- 2000:2015
Efficiency <- c(533, 593, 623, 649, 665, 693, 701)
One.Bedroom <- c(640, 711, 747, 778, 797, 803, 802)
Two.Bedroom <- c(762, 848, 891, 928, 951, 906, 901)
Three.Bedroom <- c(953, 1060, 1114, 1160, 1189, 1100, 1102)
Four.Bedroom <- c(1066, 1186, 1247, 1298, 1330, 1266, 1244)
Cook <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

Metro <- rep("Kenosha", 16)
Year <- 2000:2015
Efficiency <- c(391, 403, 427, 443, 452, 559, 572)
One.Bedroom <- c(485, 500, 530, 549, 560, 582, 596)
Two.Bedroom <- c(595, 614, 650, 674, 688, 722, 739)
Three.Bedroom <- c(819, 844, 894, 926, 945, 993, 1016)
Four.Bedroom <- c(921, 950, 1006, 1043, 1064, 1142, 1169)
Kenosha <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

Metro <- rep("Lake", 16)
Year <- 2000:2015
Efficiency <- c(389, 400, 427, 440, 447, 470, 478)
One.Bedroom <- c(511, 526, 561, 579, 588, 586, 596)
Two.Bedroom <- c(638, 656, 700, 721, 732, 716, 727)
Three.Bedroom <- c(801, 824, 879, 907, 921, 857, 869)
Four.Bedroom <- c(895, 920, 982, 1012, 1028, 883, 896)
Lake <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

###

Metro <- rep("Boston", 16)
Year <- 2000:2015
Efficiency <- c(669, 695, 887, 953, 1007, 1025, 1063)
One.Bedroom <- c(752, 782, 999, 1074, 1135, 1077, 1128)
Two.Bedroom <- c(942, 979, 1250, 1343, 1419, 1266, 1324)
Three.Bedroom <- c(1177, 1223, 1563, 1680, 1775, 1513, 1584)
Four.Bedroom <- c(1382, 1437, 1835, 1972, 2084, 1676, 1740)
Boston <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

Metro <- rep("Brockton", 16)
Year <- 2000:2015
Efficiency <- c(447, 464, 499, 614, 647, 827, 842)
One.Bedroom <- c(589, 611, 657, 809, 853, 862, 876)
Two.Bedroom <- c(722, 750, 806, 993, 1046, 1086, 1103)
Three.Bedroom <- c(898, 932, 1002, 1234, 1300, 1297, 1319)
Four.Bedroom <- c(1024, 1063, 1143, 1407, 1483, 1498, 1653)
Brockton <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

Metro <- rep("Lawrence", 16)
Year <- 2000:2015
Efficiency <- c(484, 502, 540, 607, 639, 656, 677)
One.Bedroom <- c(584, 606, 652, 733, 771, 834, 862)
Two.Bedroom <- c(735, 763, 821, 923, 971, 1009, 1042)
Three.Bedroom <- c(919, 953, 1025, 1153, 1214, 1205, 1244)
Four.Bedroom <- c(1130, 1172, 1261, 1418, 1492, 1242, 1283)
Lawrence <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

###

Metro <- rep("Cuyahoga", 16)
Year <- 2000:2015
Efficiency <- c(398, 442, 467, 481, 483, 508, 488)
One.Bedroom <- c(500, 555, 587, 603, 606, 578, 566)
Two.Bedroom <- c(619, 687, 726, 748, 752, 703, 682)
Three.Bedroom <- c(787, 874, 924, 951, 956, 916, 874)
Four.Bedroom <- c(887, 984, 1040, 1070, 1075, 980, 929)
Cuyahoga <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

###
Metro <- rep("King", 16)
Year <- 2000:2015
Efficiency <- c(501, 525, 548, 584, 599, 610, 612)
One.Bedroom <- c(610, 639, 667, 710, 729, 693, 698)
Two.Bedroom <- c(772, 809, 845, 899, 923, 834, 840)
Three.Bedroom <- c(1071, 1123, 1173, 1249, 1282, 1175, 1187)
Four.Bedroom <- c(1266, 1327, 1386, 1476, 1515, 1429, 1450)
King <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

Metro <- rep("Pierce", 16)
Year <- 2000:2015
Efficiency <- c(386, 404, 423, 451, 463, 502, 532)
One.Bedroom <- c(461, 482, 504, 539, 553, 573, 621)
Two.Bedroom <- c(613, 642, 672, 717, 736, 736, 774)
Three.Bedroom <- c(853, 893, 934, 997, 1023, 1072, 1128)
Four.Bedroom <- c(964, 1009, 1059, 1127, 1156, 1177, 1269)
Pierce <- data.frame(Metro, Year, Efficiency, One.Bedroom, Two.Bedroom, Three.Bedroom, Four.Bedroom)

###

