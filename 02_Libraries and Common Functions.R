---
title: "02_Libraries and Common Functions"
date: "9/12/2023"
---
  
# This code will define common libraries and functions used for epidemiological
# data wrangling and analysis.
  
  
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

#' See if an expression is not in a list: True / False Response
#'
#' This function checks if a character string is in a list
#' If it is NOT in the list, it returns TRUE
#' If it IS in the list, it returns FALSE
#' It is so convenient! Which is why it exists
#'
#' @param x The first character string
#' @param y the list to check against
#' @return TRUE or FALSE
#' @export
#'
#'format:
"%!in%" <- function(x,y)!('%in%'(x,y))



#' Convert columns to date format
#'
#' This function converts values to dates, using an ordered sequence of
#' formats and methods.
#'
#' @param x A column or dataframe or matrix of date values.
#' @return A column or dataframe or matrix of dates.
#' @export
#' format:
date.Col.Fixer <- function(x){
  df <- as.data.frame(x)
  colnames(df) <- "OrigDate"
  #Try using lubridate
  df <- df %>%
    #rowwise() %>%
    dplyr::mutate(NewDate =
                    lubridate::parse_date_time(OrigDate,orders = c("mdy","ymd","mdy HM","ymd HM","ymd HMS","mdy HMS"))) %>%
    dplyr::mutate(NewDate = as.Date(NewDate)) %>%
    #If it's NA, try a different way!
    dplyr::mutate(NewDate =
                    dplyr::case_when(
                      is.na(NewDate) ~ as.Date(as.numeric(OrigDate), origin = "1899-12-30"),
                      TRUE ~ NewDate
                    ))
  return(df$NewDate)
}



#' Calculates age
#'
#' This function calculates the age at a specific point in time, allowing various
#' formats.
#'
#' @param dob The birthdate of the person (or thing, I guess)
#' @param age.day The day you want to calculate age from. Defaults to the current
#' date.
#' @param units The unit you want age in. Defaults to "years"
#' @param floor Force whole number output (e.g. 1.5 years = 1 year?)
#' Defaults to TRUE
#' @return The age.
#' @export
#'
age <- function(dob, age.day = today(), units = "years", floor = TRUE) {
  calc.age = lubridate::interval(dob, age.day) / duration(num = 1, units = units)
  if (floor) return(as.integer(floor(calc.age)))
  return(calc.age)
}



#' Moves and maybe renames a file
#'
#' This function calculates the mode (most frequent value)
#'
#' @param from A path to a file
#' @param to The path to where you want the file to go, along with the new name
#' @export
File.Mover <- function(from, to) {
  todir <- dirname(to)
  if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
  file.rename(from = from,  to = to)
}


#' Calculate the mode of a vector
#'
#' This function calculates the mode (most frequent value)
#'
#' From https://stackoverflow.com/questions/2547402/how-to-find-the-statistical-mode
#'
#' @param x A vector of values
#' @return The mode of x.
#' @export
get.mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}



#' Convert the column classes of a dataframe to match another data frame's column
#' classes.
#'
#' This function converts the column classes of a frist dataframe to match the
#' column classes of a second dataframe. It's useful right before you do something
#' like "bind_rows" or whatever.
#'
#' @param df1 The dataframe with the column classes you want to change
#' @param df2 The dataframe whose column classes you want to match
#' @return A dataframe, df1, but with the column classes df2.
#' @export
#'
match.Col.Classes <- function(df1, df2) {
  
  sharedColNames <- names(df1)[names(df1) %in% names(df2)]
  sharedColTypes <- sapply(df1[,sharedColNames], class)
  
  for (n in sharedColNames) {
    class(df2[, n]) <- sharedColTypes[n]
  }
  
  return(df2)
}



# Takes text and makes it upper case while removing special characters
toUpperClean <- function(string){
  gsub("[^[:alnum:][:blank:]?&/\\-]", "", string) %>% 
    toupper()
}

# Source: Brian Erly
# Demo
# toUpperClean("briA^ er1y")
# toUpperClean("bríañ erl-y")


##############################################
#' REDCAP SET UP and REDCAP Codes:
#' Set up the redcap credentials to use
#' Source: Brian Erly
REDCapCredentials <- Set.REDCap.Credentials(projectURL = "https://cdphe.redcap.state.co.us/api/",
                                            #This is Brian's token, everyone should get their own!
                                            userToken = API_user_token)

#' Download all the files that haven't yet been downloaded
REDCap.Download.Files(
  directory = file.Dir("raw_uploads/"),
  credentials = REDCapCredentials,
  filesToSkip = filesToSkip,
  Overwrite = FALSE
)


# Convert downloaded files to CSV
Convert.To.CSV(
  directory = file.Dir("raw_uploads/")
)
##############################################

# End of Code #
