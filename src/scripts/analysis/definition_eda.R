
# Source spells data load -------------------------------------------------

source(paste0(here(), "/src/scripts/etl/definition_eda_load.R"))


# Dataset details ---------------------------------------------------------

spells_total <- nrow(spells_df)
spells_alcohol_df <- spells_df %>%
  filter(Alcohol_Wholly_Att_Flag == 1)
spells_alcohol <- nrow(spells_alcohol_df)

admission_date_start <- min(spells_df$Admission_Date)
admission_date_end <- max(spells_df$Admission_Date)


# First Episode Identified ------------------------------------------------

spells_first_df <- spells_df %>%
  filter(substr(Der_Diagnosis_All,3,6) %in% c("K740", "K760"))

spells_first <- nrow(spells_first_df)         
