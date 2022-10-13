---
title: "03_Descriptive Statistics "
date: "10/13/2023"
---
  
# This code will provide code used for epidemiological descriptive statistics.
  
  
# What are some of the libraries we might need to use?
library(tidyverse)
library(redcapAPI)
library(lubridate)
library(stringr)
library(readr)
library(readxl)
library(zoo)
library(ggthemes)
library(progress)
library(DBI)
library(glue)

# preview the data and the first observations
head(mydatafile)

# structure of the dataset
str(mydatafile)

# min and max 
min(mydataset$Variable.Length)
max(mydataset$Variable.Length)

# Barplot counts, by variable and number
counts <- table(mydata$Variable)
barplot(counts, main="Title",
        xlab="Variable")





##############################################

# End of Code #
