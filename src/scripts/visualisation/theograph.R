
# Filter ------------------------------------------------------------------

selected_ID = 100008435714

theograph_selected_df <- theograph_df %>%
  filter(ID == selected_ID)

theograph_selected_diag <- theograph_diag %>%
  filter(ID == selected_ID)


# Theograph ---------------------------------------------------------------

ggplot(data = theograph_selected_df, aes(x = Days_Since_Ref, y = "",
                                         col = Diag_Group)) +
  geom_point(aes(shape = Type), size = 2) +
  geom_label_repel(aes(label = str_wrap(Label, width = 15)), nudge_y = 0.5) +
  scale_x_continuous(breaks = seq(0, 1600, 200)) +
  #geom_vline(xintercept = theograph_selected_diag$Days_Since_Ref, col = palette_tu[7]) +
  #annotate(label = "Earliest Diagnosis", geom = "text", x = theograph_selected_diag$Days_Since_Ref, y = 0.5) +
  facet_wrap(~Type, ncol = 1, strip.position = "left") +
  # scale_color_manual(values = c(palette_tu[2], palette_tu[5] ,palette_tu[4]),
  #                    name = "Diagnosis") +
  scale_color_manual(values = c(palette_tu[5] ,palette_tu[4]),
              name = "Diagnosis") +
  labs(x = "Days Since Referral",
       y = "Activity Type",
       title = "Theograph Secondary Care Activity",
       subtitle = "MASLD Pathway Example",
       caption = "Source: SUS APCS, OPA") +
  theme(text = element_text(family = "Franklin Gothic Book"),
        strip.background = element_rect(fill = palette_tu[4]),
        strip.text = element_text(colour = "#ffffff", size = 10),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(size = 11),
        plot.title = element_text(size = 16, color = palette_tu[4]),
        plot.subtitle = element_text(size = 12),
        legend.position = "bottom")
