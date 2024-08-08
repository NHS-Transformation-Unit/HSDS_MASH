
# Age Stats by Admission Group --------------------------------------------

table_eda_ip_demo_age_ag <- spells_demo_age_ag_stats %>%
  rename("Admission Group" = 1,
         "Lower Quartile" = 2,
         "Median" = 3,
         "Upper Quartile" = 4) %>%
  kable(format = "html", align = "lrrr") %>% 
  kable_styling() %>%
  row_spec(0, background = palette_nhse[6], color = "white")

# Dep Stats ---------------------------------------------------------------

table_eda_ip_demo_dep <- spells_demo_dep_df %>%
  select(c(1:3, 9:10)) %>%
  mutate(Prop = scales::percent(Prop, accuracy = 0.01),
         lower = scales::percent(lower, accuracy = 0.01),
         upper = scales::percent(upper, accuracy = 0.01)) %>%
  rename("IMD Decile" = 1,
         "Admissions" = 2,
         "Percentage of Admissions" = 3,
         "Lower 95% CI" = 4,
         "Upper 95% CI" = 5) %>%
  kable(format = "html", align = "lrrrr") %>%
  kable_styling() %>%
  row_spec(0, background = palette_nhse[6], color = "white")

# Comorbidity Stats -------------------------------------------------------

table_eda_ip_demo_cmb <- spells_demo_cmb_df %>%
  select(c(4,3,6)) %>%
  mutate(Prop = scales::percent(Prop, accuracy = 0.01)) %>%
  arrange(desc(Total)) %>%
  rename("Charlson Co-morbidity" = 1,
         "Admissions" = 2,
         "Percentage of Total Admissions" = 3) %>%
  kable(format = "html", align = "lrr") %>%
  kable_styling() %>%
  row_spec(0, background = palette_nhse[6], color = "white")
