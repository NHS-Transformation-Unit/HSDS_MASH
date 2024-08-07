
# Age Groups --------------------------------------------------------------

chart_spells_demo_age_group <- spells_demo_age_df %>%
  ggplot(aes(x = age_group, y = Prop)) +
  geom_bar(stat = "identity", fill = palette_chart[5]) +
  geom_label(aes(label = scales::percent(Prop, accuracy = 0.1)),
             vjust = 0.5,
             size = 3.5) +
  scale_y_continuous(label = percent) +
  labs(x = "Age Group",
       y = "Percentage of Spells",
       title = "Admissions by 10-year Age Group",
       subtitle = "All Admission Types",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])

chart_spells_demo_age_group_ag <- spells_demo_age_ag_df %>%
  filter(admission_group != "Unknown") %>%
  ggplot(aes(x = age_group, y = Prop)) +
  geom_bar(stat = "identity", fill = palette_chart[5]) +
  scale_y_continuous(label = percent) +
  facet_wrap(~admission_group) +
  labs(x = "Age Group",
       y = "Percentage of Spells",
       title = "Admissions by 10-year Age Group",
       subtitle = "By Admission Type",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])


chart_spells_demo_age_histo <- spells_df_proc %>%
  ggplot(aes(x = Age)) +
  geom_histogram(binwidth = 2, fill = palette_chart[5], alpha = 0.5, col = "black") +
  xlim(0,100) +
  labs(x = "Age",
       y = "Count of Spells",
       title = "Distribution of Age of MASH Admissions",
       subtitle = "All Admission Types",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])

chart_spells_demo_age_ag_histo <- spells_df_proc %>%
  filter(admission_group != "Unknown") %>%
  ggplot(aes(x = Age)) +
  geom_histogram(binwidth = 2, fill = palette_chart[5], alpha = 0.5, col = "black") +
  xlim(0,100) +
  facet_wrap(~admission_group, scales = "free_y") +
  labs(x = "Age",
       y = "Count of Spells",
       title = "Distribution of Age of MASH Admissions",
       subtitle = "By Admission Group",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])
