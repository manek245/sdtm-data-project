icf_df <- readr::read_csv("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\raw data\\ICF.csv")
demo_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\raw data\\Demo.xlsx")
dosing_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\raw data\\Dosing.xlsx")
elig_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\raw data\\elig.xlsx")
rand_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\raw data\\rand.xlsx")

to_iso_ymd <- function(date) {
  format(lubridate::ymd(as.character(date)), "%Y-%m-%d")
}

to_iso_ymd_hms <- function(date, time) {
  paste(as.Date(date), time)
}

get_day <- function(start, end) {
  start <- as.Date(start)
  end <- as.Date(end)
  as.numeric(end - start)+1
}