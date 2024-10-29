
# Process OPA Dataset -----------------------------------------------------

opa_df_proc <- opa_df %>%
  mutate(appointment_month = floor_date(Appointment_Date, "month"),
         age_group = case_when(Age < 10 ~ "00-09",
                               Age < 20 ~ "10-19",
                               Age < 30 ~ "20-29",
                               Age < 40 ~ "30-39",
                               Age < 50 ~ "40-49",
                               Age < 60 ~ "50-59",
                               Age < 70 ~ "60-69",
                               Age < 80 ~ "70-79",
                               Age < 90 ~ "80-89",
                               TRUE ~ "90+"),
         IMD_Decile = factor(IMD_Decile, levels = c("1", "2", "3", "4", "5",
                                                    "6", "7", "8", "9", "10")),
         proc_rec = case_when(is.na(OPCS_Desc) ~ "No Procedure Recorded",
                               PrimProc %in% c("X621", "X622") ~ "Appointment",
                               TRUE ~ "Procedure")
  )

