
# Outpatient Procedures Table ---------------------------------------------

table_eda_op_procs <- opa_procs %>%
  rename("Procedure Description" = 1,
         "Total Procedures" = 2) %>%
  kable(format = "html", align = "lr") %>%
  kable_styling() %>%
  row_spec(0, background = palette_nhse[6], color = "white") %>%
  scroll_box(width = "100%", height = "300px")
