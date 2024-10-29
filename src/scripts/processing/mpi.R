
# Obtain unique patient IDs in MPI ----------------------------------------

mpi_dpnn <- mpi %>%
  group_by(Der_Pseudo_NHS_Number) %>%
  summarise() %>%
  mutate(Der_Pseudo_NHS_Number = as.character(Der_Pseudo_NHS_Number))


# Find earliest activity dates across inpatient PODs ----------------------

mpi_spells <- mpi_spells %>%
  mutate(Der_Pseudo_NHS_Number = as.character(Der_Pseudo_NHS_Number))

mpi_spells_summ <- mpi_dpnn %>%
  inner_join(mpi_spells, by = c("Der_Pseudo_NHS_Number")) %>%
  filter(Age >= 18) %>%
  group_by(Der_Pseudo_NHS_Number, Der_Management_Type) %>%
  summarise(Total = n(),
            Date = min(Admission_Date), .groups = 'drop') %>%
  select(-Total) %>%
  pivot_wider(names_from = Der_Management_Type, values_from = Date) %>%
  rowwise() %>%
  mutate(earliest_date = min(c_across(c(2:8)), na.rm = TRUE))


mpi_spells_summ <- mpi_spells_summ %>%
  mutate(earliest_pod = names(mpi_spells_summ)[which.min(c_across(c(2:8)))+1]
  )



# Find earliest outpatient activities -------------------------------------

mpi_opa <- mpi_opa %>%
  mutate(Der_Pseudo_NHS_Number = as.character(Der_Pseudo_NHS_Number))

mpi_opa_summ <- mpi_dpnn %>%
  inner_join(mpi_opa, by = c("Der_Pseudo_NHS_Number")) %>%
  filter(Age >= 18) %>%
  mutate(proc_rec = case_when(is.na(OPCS_Desc) ~ "No Procedure Recorded",
                              PrimProc %in% c("X621", "X622") ~ "Appointment",
                              TRUE ~ "Procedure"))

mpi_opa_summ_proc <- mpi_opa_summ %>%
  filter(proc_rec == "Procedure") %>%
  group_by(Der_Pseudo_NHS_Number) %>%
  summarise(earliest_date = min(Appointment_Date))


# Create combined IP and OP earliest activities ---------------------------

combined_mpi_dpnn <- bind_rows(mpi_opa_summ_proc[1], mpi_spells_summ[1]) %>%
  distinct(Der_Pseudo_NHS_Number)

earliest <- combined_mpi_dpnn %>%
  left_join(mpi_opa_summ_proc, by = c("Der_Pseudo_NHS_Number")) %>%
  left_join(mpi_spells_summ, by = c("Der_Pseudo_NHS_Number"), suffix = c("_op", "_sp")) %>%
  select(-c(3:9))

earliest_em <- earliest %>%
  filter(earliest_pod == "EM",
         (earliest_date_sp < earliest_date_op) | is.na(earliest_date_op))

earliest_em_spells <- earliest_em %>%
  left_join(mpi_spells, by = c("Der_Pseudo_NHS_Number", "earliest_date_sp" = "Admission_Date",
                               "earliest_pod" = "Der_Management_Type"))

earliest_em_spells_procs <- earliest_em_spells %>%
  group_by(OPCS_Desc, substr(Der_Procedure_All, 3, 6)) %>%
  summarise(Total = n())


earliest_dc <- earliest %>%
  filter(earliest_pod == "DC",
         (earliest_date_sp < earliest_date_op) | is.na(earliest_date_op))

earliest_dc_spells <- earliest_dc %>%
  left_join(mpi_spells, by = c("Der_Pseudo_NHS_Number", "earliest_date_sp" = "Admission_Date",
                               "earliest_pod" = "Der_Management_Type"))

earliest_el <- earliest %>%
  filter(earliest_pod == "EL",
         (earliest_date_sp < earliest_date_op) | is.na(earliest_date_op))

earliest_el_spells <- earliest_el %>%
  left_join(mpi_spells, by = c("Der_Pseudo_NHS_Number", "earliest_date_sp" = "Admission_Date",
                               "earliest_pod" = "Der_Management_Type"))
