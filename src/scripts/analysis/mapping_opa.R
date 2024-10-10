
# Earliest OPA DF ---------------------------------------------------------

earliest_opa <- earliest %>%
  filter(!is.na(earliest_date_op)) %>%
  inner_join(mpi_opa_summ, by = c("Der_Pseudo_NHS_Number" = "Der_Pseudo_NHS_Number",
                                  "earliest_date_op" = "Appointment_Date"))

earliest_opa_tf <- earliest_opa %>%
  group_by(Treatment_Function_Desc, First_Attendance_Desc) %>%
  summarise(Total = n()) %>%
  arrange(desc(Total))



# OPA Procedures ----------------------------------------------------------

opa_procs <- mpi_opa_summ %>%
  group_by(OPCS_Desc, PrimProc) %>%
  summarise(Total = n())

opa_procs_fib <- opa_procs %>%
  filter(PrimProc == "U364")

opa_procs_us <- opa_procs %>%
  filter(PrimProc %in% c("U082", "U092", "U216"))

opa_procs_biopsy <- opa_procs %>%
  filter(PrimProc %in% c("J141", "J132"))


# First Appointments ------------------------------------------------------

opa_first <- mpi_opa_summ %>%
  filter(substr(First_Attendance_Desc, 1, 5) == "First",
         Attendance_Status %in% c(5,6)) %>%
  group_by(Treatment_Function_Desc) %>%
  summarise(Total = n()) %>%
  mutate(TFC_Group = case_when(Treatment_Function_Desc %in% c("Hepatology Service",
                                                              "General Internal Medicine Service",
                                                              "Diagnostic Imaging Service",
                                                              "Gastroenterology Service") ~ Treatment_Function_Desc,
                               TRUE ~ "Other")) %>%
  group_by(TFC_Group) %>%
  summarise(Total = sum(Total))
