
# Earliest Diag -----------------------------------------------------------

theograph_diag <- theograph_df %>%
  filter(substr(Diag,1,4) %in% c("K760", "K740")) %>%
  group_by(ID) %>%
  filter(Activity_Date == min(Activity_Date))


# Processing --------------------------------------------------------------

theograph_df <- theograph_df %>%
  mutate(Type = factor(Type, levels = c("Referral",
                                  "Outpatient",
                                  "Daycase",
                                  "Elective Ordinary",
                                  "Non-Elective")),
         Diag_Group = case_when(is.na(Diag) ~ "Missing/NA",
                                Diag == "Other" ~ "Other",
                                TRUE ~ Diag))
