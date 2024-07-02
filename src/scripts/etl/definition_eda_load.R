
# Source load extract function --------------------------------------------

source(paste0(here(), "/src/scripts/etl/load_extracts.R"))

# Load Spells data --------------------------------------------------------

spells_df <- load_ncdr_extracts(file_name = "mash_spells.xlsx")
