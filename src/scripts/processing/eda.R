
# Process Spells Dataset --------------------------------------------------

spells_df_proc <- spells_df %>%
  mutate(admission_month = floor_date(Admission_Date, "month"),
         admission_group = case_when(Der_Management_Type == "DC" ~ "Daycase",
                                     Der_Management_Type == "EL" ~ "Elective Ordinary",
                                     Der_Management_Type == "EM" ~ "Non-Elective",
                                     Der_Management_Type == "NE" ~ "Non-Elective",
                                     Der_Management_Type == "RDA" ~ "Regular Day/Night",
                                     Der_Management_Type == "RNA" ~ "Regular Day/Night",
                                     Der_Management_Type == "UNK" ~ "Unknown",
                                     TRUE ~ NA),
         age_group = case_when(Age < 10 ~ "00-09",
                               Age < 20 ~ "10-19",
                               Age < 30 ~ "20-29",
                               Age < 40 ~ "30-39",
                               Age < 50 ~ "40-49",
                               Age < 60 ~ "50-59",
                               Age < 70 ~ "60-69",
                               Age < 80 ~ "70-79",
                               Age < 90 ~ "80-89",
                               TRUE ~ "90+")
  )
