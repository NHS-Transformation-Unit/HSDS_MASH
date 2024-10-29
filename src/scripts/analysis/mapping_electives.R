
# Earliest Daycase Procs -----------------------------------------------------------

dc_procs_e <- earliest_dc_spells %>%
  mutate(PrimProc = substr(Der_Procedure_All, 3,6)) %>%
  group_by(OPCS_Desc, PrimProc) %>%
  summarise(Total = n())

dc_procs_fib_e <- dc_procs_e %>%
  filter(PrimProc == "U364")

dc_procs_us_e <- dc_procs_e %>%
  filter(PrimProc %in% c("U082", "U092", "U216"))

dc_procs_biopsy_e <- dc_procs_e %>%
  filter(PrimProc %in% c("J141", "J132", "J131", "J138", "J091"))


# Daycase Procs -----------------------------------------------------------

dc_procs <- mpi_spells %>%
  filter(Age >= 18,
         Der_Management_Type == "DC") %>%
  mutate(PrimProc = substr(Der_Procedure_All, 3,6)) %>%
  group_by(OPCS_Desc, PrimProc) %>%
  summarise(Total = n())

dc_procs_fib <- dc_procs %>%
  filter(PrimProc == "U364")

dc_procs_us <- dc_procs %>%
  filter(PrimProc %in% c("U082", "U092", "U216"))

dc_procs_biopsy <- dc_procs %>%
  filter(PrimProc %in% c("J141", "J132", "J131", "J138", "J091"))

# Earliest Elective Procs -----------------------------------------------------------

el_procs_e <- earliest_el_spells %>%
  mutate(PrimProc = substr(Der_Procedure_All, 3,6)) %>%
  group_by(OPCS_Desc, PrimProc) %>%
  summarise(Total = n())

el_procs_fib_e <- el_procs_e %>%
  filter(PrimProc == "U364")

el_procs_us_e <- el_procs_e %>%
  filter(PrimProc %in% c("U082", "U092", "U216"))

el_procs_biopsy_e <- el_procs_e %>%
  filter(PrimProc %in% c("J141", "J132", "J131", "J138", "J091"))


# Elective Procs -----------------------------------------------------------

el_procs <- mpi_spells %>%
  filter(Age >= 18,
         Der_Management_Type == "EL") %>%
  mutate(PrimProc = substr(Der_Procedure_All, 3,6)) %>%
  group_by(OPCS_Desc, PrimProc) %>%
  summarise(Total = n())

el_procs_fib <- el_procs %>%
  filter(PrimProc == "U364")

el_procs_us <- el_procs %>%
  filter(PrimProc %in% c("U082", "U092", "U216"))

el_procs_biopsy <- el_procs %>%
  filter(PrimProc %in% c("J141", "J132", "J131", "J138", "J091"))
