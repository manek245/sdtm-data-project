icf_df <- readr::read_csv("raw data/ICF.csv")
demo_df <- readxl::read_excel("raw data/Demo.xlsx")
dosing_df <- readxl::read_excel("raw data/Dosing.xlsx")
elig_df <- readxl::read_excel("raw data/elig.xlsx")
rand_df <- readxl::read_excel("raw data/rand.xlsx")

#include iso package ISOcodes
to_iso_country <- function(code) {
  map <- c(
    "BRZ" = "BRA",
    "CAN" = "CAN",
    "CHA" = "CHN",
    "CRO" = "HRV",
    "CZE" = "CZE",
    "DAN" = "DNK",
    "EGP" = "EGY",
    "ESP" = "ESP",
    "EST" = "EST",
    "FRA" = "FRA",
    "ISR" = "ISR",
    "ITL" = "ITA",
    "JAP" = "JPN",
    "KOR" = "KOR",
    "NOR" = "NOR",
    "POR" = "PRT",
    "SLO" = "SVN"
  )
  unname(map[code])
} 

to_iso_ymd <- function(date) {
  format(lubridate::ymd(as.character(date)), "%Y-%m-%d")
}

to_iso_ymd_hms <- function(date, time) {
  ifelse(is.na(time),
         as.character(as.Date(date)),
         paste0(as.Date(date), "T", time))
}

get_day <- function(start, end) {
  start <- as.Date(start)
  end <- as.Date(end)
  as.numeric(end - start)+1
}

