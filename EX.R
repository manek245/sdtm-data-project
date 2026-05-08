ex <- data.frame(
  STUDYID = dosing_df$study,
  DOMAIN = "EX",
  USUBJID = paste0(dosing_df$study, substr(dosing_df$patid, 4, nchar(dosing_df$patid))),
  EXSEQ = ave(seq_along(dosing_df$patid), dosing_df$patid, FUN = seq_along),
  EXTRT = dosing_df$rand,
  EXDOSE = as.numeric(gsub("[^0-9.]", "", dosing_df$dose)),
  EXDOSEU = ifelse(is.na(dosing_df$dose), NA, 'ml'),
  EXSTDTC = NA,
  EXENDDTC = NA
  
)


View(ex)