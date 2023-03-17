#####Stats in R 03.17.2023
##### Shelby Lineberry

### This is part of an R Users group at CDPHE. This might be helpful if 
### you're doing a project that requires some statistical analysis 


install.packages("datasets")
library(datasets)
library(ggplot2)
library(dplyr)
data("iris")


#Summary Data for Iris Data Set
summary(iris)



#Histogram
ggplot(iris, aes(x=Sepal.Width))+ geom_histogram(bins=10)

#Box Plot by Species
ggplot(iris, aes(x=Sepal.Width, y=Species))+ geom_boxplot()

#QQ Plot
ggplot(iris, aes(sample=Sepal.Width))+stat_qq()+ stat_qq_line() 
qqnorm(iris$Sepal.Width)

#Student's t Test

# t.test(x, y = NULL,
#        mu = 0, var.equal = FALSE)
# arguments:
# - x : A vector to compute the one-sample t-test
# - y: A second vector to compute the two sample t-test
# - mu: Mean of the population- var.equal: Specify if the variance of the two vectors are equal. By default, set to `FALSE`

#One Sample T Test

#Two Sided Tests
t.test(iris$Sepal.Width, mu=3)

t.test(iris$Sepal.Width, mu=2)


#One Sided Tests
t.test(iris$Sepal.Width, mu=3, alternative="less")

t.test(iris$Sepal.Width, mu=2, alternative="greater")

#Two Sample Independent Test

iris2<-iris %>% filter(Species!="setosa")

#Test of Equal Variances
var.test(Sepal.Width~Species, data=iris2)

#Tests of Normality
with(iris2, shapiro.test(Sepal.Width[Species=="versicolor"]))
with(iris2, shapiro.test(Sepal.Width[Species=="virginica"]))
shapiro.test(iris$Sepal.Width)




t.test(Sepal.Width~Species, data=iris2, var.equal=TRUE)

##end of code






