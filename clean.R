# r supplemental bootcamp materials
# stats supplement
# leo saenger feb 6 2021 for HODP

library(tidyverse)
library(janitor)

df <- read.csv('public_up_to_150k_3.csv') 

clean_df <- df %>%
  filter(BorrowerState == 'MA') %>%
  clean_names() %>%
  filter(grepl('cambridge|somerville', borrower_city, ignore.case = T))
rm(df)
# two organizations are founded by harvard students, 
# registered at a harvard mail center, and have only one employee 
# let's include these separately 

small_df <- clean_df %>%
  select(borrower_name, borrower_address, borrower_zip, initial_approval_amount, current_approval_amount, undisbursed_amount, business_age_description,
         jobs_reported, naics_code, utilities_proceed, payroll_proceed, mortgage_interest_proceed, business_type, non_profit) %>%
  mutate(harvard_org = if_else(grepl('hsa|harvard student|harvard debate|fly club|HARVARD CRIMSON', borrower_name, ignore.case = T),
                               T, F)) %>%
  mutate(borrower_name = replace(borrower_name, borrower_name == 'HARVARD STUDENT AGENCIES', 'HSA CORPORATION')) %>%
  mutate(harvard_student = if_else(grepl('pinwheel|dpc ventures', borrower_name, ignore.case = T),
                                   T, F)) %>%
  group_by(borrower_name) %>%
  summarize(borrower_address = first(borrower_address),
            borrower_zip = first(borrower_zip),
            initial_approval_amount = sum(initial_approval_amount, na.rm = T),
            current_approval_amount = sum(current_approval_amount, na.rm = T),
            undisbursed_amount = sum(undisbursed_amount, na.rm = T),
            business_age_description = first(business_age_description),
            jobs_reported = mean(jobs_reported, na.rm = T),
            naics_code = first(naics_code), 
            utilities_proceed = sum(utilities_proceed, na.rm = T),
            payroll_proceed = sum(payroll_proceed, na.rm = T),
            mortgage_interest_proceed = sum(mortgage_interest_proceed, na.rm = T),
            business_type = first(business_type),
            harvard_org = first(harvard_org),
            harvard_student = first(harvard_student)
  ) %>%
  mutate(avg_payroll = payroll_proceed / jobs_reported)

saveRDS(small_df, file = 'ppp_dataset.RDS')