
# Load Connection ---------------------------------------------------------

source(paste0(here(), "/src/config/connection.R"))

# Process MPI and Load --------------------------------------------------------

DBI::dbExecute(con, statement = read_file(paste0(here(),"/src/scripts/etl/udal_extracts/create_mpi.sql")), immediate = TRUE)

mpi <- dbGetQuery(con, statement = "SELECT * FROM #mpi_initial")
mpi_spells <- dbGetQuery(con, statement = "SELECT * FROM #Adm")
mpi_opa <- dbGetQuery(con, statement = "SELECT * FROM #OPA")


# Drop all temps ----------------------------------------------------------

DBI::dbExecute(con, statement = read_file(paste0(here(), "/src/scripts/etl/udal_extracts/create_mpi_drop_temps.sql")), immediate = TRUE)
