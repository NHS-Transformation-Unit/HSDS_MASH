
# All Earliest Activity NEL Spells ----------------------------------------

earliest_em_spells_adm_meth <- earliest_em_spells %>%
  group_by(Admission_Method_Desc, Admission_Method) %>%
  summarise(Total = n()) %>%
  arrange(desc(Total))

earliest_em_spells_adm_meth_groups <- earliest_em_spells_adm_meth %>%
  mutate(Admission_Group = case_when(Admission_Method %in% c("21", "2A") ~ "ED Admission",
                                     Admission_Method %in% c("22") ~ "GP Admission",
                                     TRUE ~ "Other Non-Elective")) %>%
  group_by(Admission_Group) %>%
  summarise(Total = sum(Total, na.rm = TRUE))


# NEL Procs ---------------------------------------------------------------

em_procs_e <- earliest_em_spells %>%
  mutate(PrimProc = substr(Der_Procedure_All, 3,6)) %>%
  group_by(OPCS_Desc, PrimProc) %>%
  summarise(Total = n())

em_procs_fib_e <- em_procs_e %>%
  filter(PrimProc == "U364")

em_procs_us_e <- em_procs_e %>%
  filter(PrimProc %in% c("U082", "U092", "U216"))

em_procs_biopsy_e <- em_procs_e %>%
  filter(PrimProc %in% c("J141", "J132", "J131", "J138", "J091"))
