icf_df <- readr::read_csv("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\ICF.csv")
demo_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\Demo.xlsx")
dosing_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\Dosing.xlsx")
elig_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\elig.xlsx")
rand_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\rand.xlsx")

to_iso_dmy <- function(date) {
  format(lubridate::dmy(as.character(date)), "%Y-%m-%d")
}

to_iso_ymd <- function(date) {
  format(lubridate::ymd_hms(as.character(date)), "%Y-%m-%d")
}

dosing_df <- merge(icf_df[, "patid", drop = FALSE], dosing_df, by = "patid", all.x = TRUE)
dosing_df <- dosing_df[!duplicated(dosing_df$patid), ]
merged_df <- merge(demo_df, rand_df, by = "patid", all.x = TRUE)

race_col <- demo_df[, c("caucas", "black", "indian", "asian", "hawaian")]

dm <- data.frame(
  STUDYID = icf_df$study,
  DOMAIN = "DM",
  USUBJID = paste0(icf_df$study, substr(icf_df$patid, 4, nchar(icf_df$patid))),
  SUBJID = substr(icf_df$patid, 7, nchar(icf_df$patid)),
  RFSTDTC = dosing_df$infdate,
  RFENDTC = NA,
  RFXSTDTC = (dosing_df$infdate),
  RFXENDTC = NA,
  RFICDTC = to_iso_dmy(icf_df$icf_dat),
  RFPENDTC = ifelse(icf_df$resign, icf_df$icf_dat2, NA) ,
  DTHDTC = NA,
  DTHFL = NA,
  SITEID = substr(icf_df$patid, 4, 5),
  AGE = as.numeric(demo_df$ageyr),
  AGEU = "YEARS",
  SEX = dplyr::case_when(
    demo_df$gender == 1 ~ "M",
    demo_df$gender == 2 ~ "F",
    demo_df$gender == 99 ~ "U",
    demo_df$gender == 0 ~ "UNDIFFERENTIATED"
  ),
  RACE = ifelse(
    rowSums(as.data.frame(lapply(
      demo_df[, c("caucas", "black", "indian", "asian", "hawaian", "unk")], as.numeric
    ))) > 1,
    "MULTIPLE",
    ifelse(
      as.numeric(demo_df$caucas) == 1,
      "WHITE",
      ifelse(
        as.numeric(demo_df$black) == 1,
        "BLACK",
        ifelse(
          as.numeric(demo_df$indian) == 1,
          "AMERICAN INDIAN",
          ifelse(
            as.numeric(demo_df$asian) == 1,
            "ASIAN",
            ifelse(
              as.numeric(demo_df$hawaian) == 1,
              "NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER",
              ifelse(as.numeric(demo_df$unk) == 1, "UNKNOWN", NA)
            )
          )
        )
      )
    )
  ),
  ETHNIC = ifelse(
    demo_df$ethnicity == 1 ,
    "HISPANIC OR LATINO",
    "NOT HISPANIC OR LATINO"
  ),
  ARMCD = ifelse(merged_df$rand == "PLACEBO", "P","D"),
  ARM = ifelse(merged_df$rand == "PLACEBO", "PLACEBO","PEAR14"),
  ACTARMCD = NA,
  ACTARM = NA,
  ARMNRS = NA,
  ACTARMUD = NA,
  COUNTRY = substr(icf_df$patid, 1, 3)
)

View(merged_df)