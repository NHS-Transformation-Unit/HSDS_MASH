
# Create Time Series DataFrame --------------------------------------------

spells_ts_df <- spells_df_proc %>%
  group_by(admission_month) %>%
  summarise(Total = n())

# Create Time Series by Admission Group DataFrame -------------------------

spells_ts_ag_df <- spells_df_proc %>%
  group_by(admission_month, admission_group) %>%
  summarise(Total = n())
