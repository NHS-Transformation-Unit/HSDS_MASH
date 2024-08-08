
# Time Series Charts ------------------------------------------------------

chart_spells_ts <- spells_ts_df %>%
  ggplot(aes(x = as.Date(admission_month), y = Total)) +
  geom_line(col = palette_chart[5]) +
  scale_x_date(labels = date_format("%Y-%b"), date_breaks = "3 months") +
  labs(x = "Admission Month",
       y = "Number of Spells",
       title = "MASH Identified Hospital Admissions",
       subtitle = "All Admission Types",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])

chart_spells_ts_ag <- spells_ts_ag_df %>%
  filter(admission_group != "Unknown") %>%
  ggplot(aes(x = as.Date(admission_month), y = Total)) +
  geom_line(col = palette_chart[5]) +
  scale_x_date(labels = date_format("%Y-%b"), date_breaks = "6 months") +
  facet_wrap(~admission_group, scales = "free_y") +
  labs(x = "Admission Month",
       y = "Number of Spells",
       title = "MASH Identified Hospital Admissions",
       subtitle = "By Admission Type",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])
