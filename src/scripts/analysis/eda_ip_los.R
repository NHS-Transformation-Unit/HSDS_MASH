
# Non-Elective Zero Day ---------------------------------------------------

spells_nel_los_group <- spells_df_proc %>%
  filter(admission_group == "Non-Elective") %>%
  mutate(LOS_Group = case_when(Der_Spell_LoS == 0 ~ "0 Day",
                               TRUE ~ "1+ Day"))%>%
  group_by(LOS_Group) %>%
  summarise(Total = n()) %>%
  mutate(Prop = Total/sum(Total))

# Non-Elective 1+ Day Stats

spells_nel_los_1p <- spells_df_proc %>%
  filter(admission_group == "Non-Elective",
         Der_Spell_LoS > 0)

spells_nel_los_1p_stats <- quantile(spells_nel_los_1p$Der_Spell_LoS, probs = c(0.25, 0.50, 0.75))
