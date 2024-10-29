
# Load Connection ---------------------------------------------------------

source(paste0(here(), "/src/config/connection.R"))

# Load OPA data -----------------------------------------------------------

opa_df <- DBI::dbGetQuery(con, statement = read_file(paste0(here(),"/src/scripts/etl/udal_extracts/mash_opa_analysis.sql")))
