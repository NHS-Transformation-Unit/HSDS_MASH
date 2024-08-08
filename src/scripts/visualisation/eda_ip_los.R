
# NEL 1+ Day LOS Histogram ------------------------------------------------

chart_spells_nel_los_1p_histo <- spells_nel_los_1p %>%
  ggplot(aes(x = Der_Spell_LoS)) +
  geom_histogram(binwidth = 1, fill = palette_chart[5], alpha = 0.5, col = "black") +
  xlim(0,50) +
  labs(x = "Length of Stay (Days)",
       y = "Count of Spells",
       title = "Distribution of Non-Elective Length of Stay for MASH Admissions",
       subtitle = "1+ Day Length of Stay",
       caption = "Source: SUS APCS (Admitted Patient Care - Spells)") +
  selected_theme(hex_col = palette_nhse[6])
