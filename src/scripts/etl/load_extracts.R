
# load_ncdr_extracts function ---------------------------------------------

load_ncdr_extracts <- function(file_name){
  
  read_excel(path = paste0(here(), "/data/raw/ncdr_extracts/", file_name))
  
}
