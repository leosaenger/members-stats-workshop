# r supplemental bootcamp materials
# stats supplement
# leo saenger feb 6 2021 for HODP

library(tidyverse)
library(ggplot2)
library(estimatr)

# set it to wherever you have it 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# let's take some data - 3044 firms in Cambridge/Somerville w/ less than 150k in PPP loans (really, grants)
# about PPP: https://www.sba.gov/funding-programs/loans/coronavirus-relief-options/paycheck-protection-program/ppp-loan-forgiveness
df <- readRDS('ppp_dataset.RDS')

# i've gone ahead and cleaned the data for you already and flagged a
# few harvard organizations that applied for loans. 

# let's start by getting some key metrics:
df %>% summarize(avg = mean(current_approval_amount, na.rm = T), n = n()) # average loan size

# how about for harvard student orgs?
df %>% filter(harvard_org == TRUE) %>% summarize(avg = mean(current_approval_amount, na.rm = T), n = n()) # average loan size
df %>% filter(harvard_org == FALSE) %>% summarize(avg = mean(current_approval_amount, na.rm = T), n = n()) # for contrast

# that seems high, but it's hard to say - we want to condition on a few things

# let's get the conditional means: we could do a t test:
# eg via: t.test(x ~ y, data = df)

# but regression makes our job simple 
# eg via lm_robust( , data = df) # how does this compare?

# let's add some covariates

# now try for harvard student-founded orgs
# or, look at avg payroll, or try something entirely different!