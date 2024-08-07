
# Age Demographics --------------------------------------------------------

spells_demo_age_df <- spells_df_proc %>%
  group_by(age_group) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE))

spells_demo_age_stats <- quantile(spells_df_proc$Age, probs = c(0.25, 0.50, 0.75))

# Age Demographics by Admission Group -------------------------------------

spells_demo_age_ag_df <- spells_df_proc %>%
  group_by(admission_group, age_group) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE))

spells_demo_age_ag_stats <- spells_df_proc %>%
  group_by(admission_group) %>%
  summarise(LQ = quantile(Age, probs = 0.25),
            Median = quantile(Age, probs = 0.50),
            UQ = quantile(Age, probs = 0.75)
  )
