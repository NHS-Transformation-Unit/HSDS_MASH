
# Create Time Series DataFrame --------------------------------------------

spells_ts_df <- spells_df_proc %>%
  group_by(admission_month) %>%
  summarise(Total = n())

# Create Time Series by Admission Group DataFrame -------------------------

spells_ts_ag_df <- spells_df_proc %>%
  group_by(admission_month, admission_group) %>%
  summarise(Total = n())


# # Percentage of Admissions by Group -------------------------------------

spells_ag <- spells_ts_ag_df %>%
  group_by(admission_group) %>%
  summarise(Total = sum(Total, na.rm = TRUE)) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE))

spells_ag_recent <- spells_ts_ag_df %>%
  filter(admission_month >= "2022-04-01") %>%
  group_by(admission_group) %>%
  summarise(Total = sum(Total, na.rm = TRUE)) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE))
