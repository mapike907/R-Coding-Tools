---
title: "03_Descriptive Statistics "
date: "10/13/2023"
---
  
# This code will provide code used for epidemiological descriptive statistics.
  

# preview the data and the first observations
head(mydatafile)

# structure of the dataset
str(mydatafile)

# min and max 
min(mydataset$Variable.Length)
max(mydataset$Variable.Length)

# range 
max(mydataset$Variable.Length) - min(mydataset$Variable.Length)

# mean
mean(mydataset$Variable.Length)

# median / quartile
median(mydataset$Variable.Length)
quartile(mydataset$Variable.Length)

# first and third quartile
quantile(mydataset$Variable.Length, 0.25) # first quartile
quantile(mydataset$Variable.Length, 0.75) # third quartile

# 98th percentile
quantile(mydataset$Variable.Length, 0.98) 

# interquartile range
IQR(mydataset$Variable.Length) 

# standard deviation and variance
sd(mydataset$Variable.Length) # standard deviation
var(mydataset$Variable.Length) # variance 

# In R, the standard deviation and the variance are computed as if 
# the data represent a sample (so the denominator is n − 1, where n is the 
# number of observations). To my knowledge, there is no function by default in 
# R that computes the standard deviation or variance for a population.
# Ref: https://statsandr.com/blog/descriptive-statistics-in-r/#minimum-and-maximum

# for multiple variables, use lapply()
lappy(dat[, 1:4], sd)

# Barplot
barplot(table(dat$size)) # table() is mandatory

# Barplot counts, by variable and number
counts <- table(mydata$Variable)
barplot(counts, main="Title",
        xlab="Variable")





##############################################

# End of Code #
