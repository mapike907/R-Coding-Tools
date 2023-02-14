---
Title: "Coding Cheat Sheet, Created for R learners"
author: "Melissa Pike"
date: "09/07/2022"
---

######## How To Connect to Database Servers ########

# Install all the packages you'll need - use the console window to install.packages() 
# and to get these to load one time. Once you install, you do not have to do this again, 
# unless you find a new package you need. 

install.packages("DBI")
install.packages("svDialogs")
install.packages("odbc")
install.packages("Tidyverse")
install.packages("dplyr")
install.packages("tibble")

# Library statements required at the start of all codes to link the packages #
library(DBI)
library(svDialogs)
library(odbc)
library(tidyverse)
library(dplyr) #data transformation package# 
library(tibble)
library(dbplyr)
library(ggplot2)
library(dplyr)
library(ciisr) #this one requires a github key and access to R.Severson GitHub 
library(covidr)
library(ggplot2)
library(lubridate)
library(scales)

# Cheat Sheets for R Packages: https://www.rstudio.com/resources/cheatsheets/

# Connect to servers. 
# what is in green quotes needs to match your ODBC Data Source Administrator 
# name of your server that you're connecting to. For some, "COVID19" may be 
# "DPHE144" but it could be different if you named it something else.

# server: DPHE 144 ##
COVID19 <- dbConnect(odbc::odbc(), "COVID19", timeout = 10)

# server: CEDRS, DPHE 66#
CEDRS_3_Read <- dbConnect(odbc::odbc(), "CEDRS_3_Read", timeout = 10)

# server: CDPHESQD03 #
Covid_vaccine <-  dbConnect(odbc::odbc(), "covid_vaccine", timeout = 10)

# server: DrJ, DPHE 146 #
DrJ <-  dbConnect(odbc::odbc(), "DrJ", timeout = 10)

# server: eCR, Development DPHE139 #
eCR_139 <-  dbConnect(odbc::odbc(), "eCR", timeout = 10)

# server: eCR, Production DPHE150 #
eCR_150 <-  dbConnect(odbc::odbc(), "eCR", timeout = 10)

# server: ELR, DPHE138 #
ELR_DW <-  dbConnect(odbc::odbc(), "ELR_DW", timeout = 10)



######## How To CREATE a WORKING TABLE from the Database ########

# After you have a library line and a connect to server line, pull data #

# format #
table_name <- tbl(ServerNameFromPreviousStep,dbplyr::in_schema("schema", 
                    "table_name")) %>%
              filter(var1 >= 50, var2 == 1, var3 ==0, etc.)%>%
              select(var1, var2, var3, var4, var5, var6) %>% #select only what you need#
              collect()


# examples # 
cases <- tbl(COVID19, dbplyr::in_schema("cases", 
                                        "covid19_cedrs_dashboard_constrained")) %>% 
  filter(age_at_reported >= 50, breakthrough == 1, 
         liveininstitution == 'YES', reinfection == 0) %>%
  select(profileid, eventid, age_at_reported,exposurefacilitytype,
         collectiondate) %>%
  collect()


sj_total <- tbl(conn, in_schema("cases", "covid19_cedrs_dashboard_constrained")) %>%
  filter(reporteddate >= "2022-03-31", 
         reporteddate <= "2022-04-06",
         countyassigned == "San Juan") %>%
  collect()


county_pop <- tbl(conn, in_schema("dbo", "populations")) %>% 
  filter(metric == "county",
         group == "SAN JUAN", 
         year == 2020) %>% 
  select(group, population) %>% 
  collect()
county_pop$group <- str_to_title(county_pop$group)


######## FREQUENCY TABLES ########

# format #
table_name %>% 
    group_by(variable) %>% count()

# example #
cases %>% 
  group_by(exposurefacilitytype) %>% count()


######## "OR" & "AND" Statements; Select where var1 = X or Var1 = Y ########

# USING only OR: use the same format as working table above, but replace the 
# commas with up and down line, shift and key above enter | (analogous to "OR" 
# statement in SAS)

# format #
table_name <- tbl(ServerNameFromPreviousStep,dbplyr::in_schema("schema", "table_name")) %>%
  filter(var1 == 'Categorical'| var == 'Categorical')%>%
  collect()

# example #
facility <- cases %>% 
  filter(exposurefacilitytype == 'Assisted Living' | exposurefacilitytype == 
           'Long Term Acute Care' | exposurefacilitytype == 'Rehab Facility'|
           exposurefacilitytype == 'Skilled Nursing') %>%
  collect()

# USING OR and AND in same line: use the same format as working table above, 
# but use commas (,) between variables (analogous to "AND" statement in SAS)

# format #
table_name <- tbl(ServerNameFromPreviousStep,dbplyr::in_schema("schema", "table_name")) %>%
  filter(var1 == 'Categorical'| var2 == 'Categorical', var3 >= 'date')%>%
  collect()


# Example: pulling facility type that is Assisted Living OR Rehab Facility OR Skilled
# Nursing AND collection date is on or after August 13, 2021 #

facility <- cases %>% 
  filter(exposurefacilitytype == 'Assisted Living' | exposurefacilitytype == 
           'Long Term Acute Care' | exposurefacilitytype == 'Rehab Facility'|
           exposurefacilitytype == 'Skilled Nursing', collectiondate >= '2021-08-13') %>%
  collect()


######## WHAT IS "dplyr"? ########

# It's package that is useful for data transformation. 
# Used for summarizing, grouping, manipulating (extract cases, arrange cases, add cases)
# and manipulating variables (extract, manipulate multipule variables at one times, and
# making new variables).

# Summarize cases 
# format: 
summarise(data, avg = mean(variable))

# example:
summarize(cases, avg=mean(age_at_reported)) # this tells me the avg age is 77.5 

# Group By
# format:
table_name %>%
  group_by(variable)%>%





######## WHAT IS "mutate"? ########

# It's part of the dplyr package. 
# Mutate adds new variables and preserves existing variables.
# Apply calculations on variables, like calculating case rates per 100k county population.

# New variables overwrite existing variables of the same name. Variables can be 
# removed by setting their value to NULL. 

### Create a new variable, "Rate", using MUTATE  ###
### Left Join of county_pop to cases  ###

# get county populations
county_pop <- tbl(conn, in_schema("dbo", "populations")) %>% 
  filter(metric == "county",
         year == 2020) %>% 
  select(group, population) %>% 
  collect()

# get cases 
cases <- tbl(conn, in_schema("cases", "county")) %>% 
  filter(reporteddate >= "2022-02-24",
         reporteddate <= "2022-03-02") %>% 
  select(countyassigned, n) %>% 
  collect() %>%
  group_by(countyassigned) %>% 
  summarise(cases = sum(n)) %>% 
  left_join(county_pop, by = c("countyassigned" = "group")) %>% 
  mutate(rate = round((cases/population)*100000))

# Create a new variable 
df %>%
  mutate(x = c("", "NewVariable"[(date >= "2020-03-01" & 
                                    as.character(infection) == "infectionvariableyouwant"] )

