
# Create Dataset ----------------------------------------------------------

hi_spells_df <- spells_df_proc %>%
  filter(Age >= 18,
         Alcohol_Wholly_Att_Flag == 0)


# Age ---------------------------------------------------------------------

hi_spells_demo_age_stats <- quantile(hi_spells_df$Age, probs = c(0.25, 0.50, 0.75))

hi_spells_demo_age_ag_stats <- hi_spells_df %>%
  group_by(admission_group) %>%
  summarise(LQ = quantile(Age, probs = 0.25),
            Median = quantile(Age, probs = 0.50),
            UQ = quantile(Age, probs = 0.75),
            Total = n()
  )


# Deprivation -------------------------------------------------------------

# Calculate CIs using Wilson Method
wilson_ci <- function(num, den, ci_level = 0.95){
  
  result <- binom.confint(x = num, n = den, methods = "wilson", conf.level = ci_level)
  return(result)
  
}

hi_spells_demo_dep_df <- hi_spells_df %>%
  group_by(IMD_Decile) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE),
         GT = sum(Total, na.rm = TRUE)) %>%
  rowwise() %>%
  mutate(ci = list(wilson_ci(Total, GT))) %>%
  unnest(cols = ci)

hi_spells_demo_dep_nel_df <- hi_spells_df %>%
  filter(admission_group == "Non-Elective") %>%
  group_by(IMD_Decile) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total, na.rm = TRUE),
         GT = sum(Total, na.rm = TRUE)) %>%
  rowwise() %>%
  mutate(ci = list(wilson_ci(Total, GT))) %>%
  unnest(cols = ci)

hi_spells_demo_dep_nel_cm_dia <- hi_spells_df %>%
  filter(admission_group == "Non-Elective") %>%
  group_by(IMD_Decile) %>%
  summarise(Total = n(),
            DM = sum(CC_DIA_Flag, na.rm = TRUE)) %>%
  mutate(Prop = DM/Total) %>%
  rowwise() %>%
  mutate(ci = list(wilson_ci(DM, Total))) %>%
  unnest(cols = ci)
