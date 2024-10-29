
# Outpatient Procedures ---------------------------------------------------

opa_types <- opa_df_proc %>%
  filter(Attendance_Status %in% c('5','6')) %>%
  group_by(proc_rec) %>%
  summarise(Total = n()) %>%
  mutate(prop = Total/sum(Total))

opa_procs <- opa_df_proc %>%
  filter(Attendance_Status %in% c('5','6'),
         proc_rec == "Procedure") %>%
  group_by(OPCS_Desc) %>%
  summarise(Total = n()) %>%
  arrange(desc(Total)) %>%
  filter(Total > 10)
