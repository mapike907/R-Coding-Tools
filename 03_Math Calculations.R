---
title: "03_Math Calculations"
date: "9/19/2023"
---
  
# This code will provide code for math in R - easy calculations 
  
  
# Controlling the order of operations.
  
# In R, it follows EDMAS -- Exponents, multiplication/division, addition/subtractions
# Change the order with parentheses 
  
abs(x) - takes the absolute value of x
exp(x) - retuns the exponent of x

# rounding

round(123.457, digits = 2)

# significant digits

signif(123.457, digits = 4)

# similar to rounding, three other functions always round in the same direction

floor(x)
floor(123.457) 

ceiling(x)
ceiling(-123.45) 
ceiling(123.45)

trunc(x) #rounds at the nearest integer in the direction of zero #
trunk(123.45)
trunk(-123.45)


# How to find Not Applicable ? #
is.na(x)
is.finite(x)
is.infinite(x)
is.nan(x)






  
##############################################

# End of Code #
