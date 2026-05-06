icf_df <- readr::read_csv("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\ICF.csv")
demo_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\Demo.xlsx")
dosing_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\Dosing.xlsx")
elig_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\elif.xlsx")
rand_df <- readxl::read_excel("C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\data\\rand.xlsx")

dm <- data.frame(
  dm <- data.frame(
    STUDYID = NA,
    DOMAIN = "DM",
    USUBJID = NA,
    SUBJID = NA,
    RFSTDTC = NA,
    RFENDTC = NA,
    RFXSTDTC = NA,
    RFXENDTC = NA,
    RFPENDTC = NA,
    DTHDTC = NA,
    DTHFL = NA,
    SITEID = NA,
    AGE = NA,
    AGEU = NA,
    SEX = NA,
    RACE = NA,
    ARMCD = NA,
    ARM = NA,
    ACTARMCD = NA,
    ACTARM = NA,
    ARMNRS = NA,
    ACTARMUD = NA,
    COUNTRY = NA
  )
)