
# MASH Definition Analysis ------------------------------------------------
mash_def_packages <- c("tidyverse",
                       "readxl",
                       "here",
                       "odbc",
                       "DBI",
                       "readr")


# MASH Initial Analysis ---------------------------------------------------
mash_eda_packages <- c("tidyverse",
                       "readxl",
                       "here",
                       "odbc",
                       "DBI",
                       "readr",
                       "scales",
                       "kableExtra",
                       "binom")

# MASH OP Initial Analysis ------------------------------------------------

mash_eda_op_packages <- c("tidyverse",
                       "readxl",
                       "here",
                       "odbc",
                       "DBI",
                       "readr",
                       "scales",
                       "kableExtra",
                       "binom")


# MASH MPI Analysis -------------------------------------------------------

mash_mpi_packages <- c("tidyverse",
                       "readxl",
                       "here",
                       "odbc",
                       "DBI",
                       "readr",
                       "scales",
                       "kableExtra",
                       "binom",
                       "ggrepel")

# load_packages function --------------------------------------------------

load_packages <- function(packages){

missing_packages <- setdiff(packages, installed.packages()[,"Package"])

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

lapply(packages, function(pkg) {
  library(pkg, character.only = TRUE)
})

}
