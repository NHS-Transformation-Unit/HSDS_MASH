
# Extract Dates between from SQL EDA --------------------------------------

## Create function to extract dates used in the WHERE Clause
extract_dates_sql_Where <- function(query) {
  # Extract the WHERE clause
  where_clause <- sub(".*\\bWHERE\\b(.*)", "\\1", query, ignore.case = TRUE)
  
  # Regular expression to match dates in the format 'YYYY-MM-DD'
  date_pattern <- "\\b\\d{4}-\\d{2}-\\d{2}\\b"
  dates <- regmatches(where_clause, gregexpr(date_pattern, where_clause))
  
  # Filter to get only unique dates
  unique_dates <- unique(unlist(dates))
  
  # Return the dates found
  return(unique_dates)
}

eda_sql_statement <- sql_statement_test <- read_file(paste0(here(),"/src/scripts/etl/udal_extracts/mash_spells_analysis.sql"))

dates_in_where_clause <- extract_dates_sql_Where(eda_sql_statement)