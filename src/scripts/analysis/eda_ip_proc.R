
# Daycase Primary Procedures ----------------------------------------------

spells_dc <- spells_df_proc %>%
  filter(admission_group == "Daycase")

spells_dc_proc_prim <- spells_dc %>%
  group_by(OPCS_Desc) %>%
  summarise(Total = n()) %>%
  filter(Total >= 10) %>%
  mutate(OPCS_Desc = replace_na(OPCS_Desc, "No procedure code")) %>%
  arrange(desc(Total))


# All procedures ----------------------------------------------------------

spells_dc_procs_all <- spells_dc %>%
  select(c(Der_Procedure_All)) %>%
  separate_rows(Der_Procedure_All, sep = ",") %>%
  mutate(Proc_Code = gsub("\\|\\|", "", Der_Procedure_All)) %>%
  left_join(ref_opcs, by = c("Proc_Code" = "Code_Without_Decimal")) %>%
  group_by(Title) %>%
  summarise(Total = n())

         