first_dose <- aggregate(infdate ~ patid, dosing_df, min)
dosing_min <- merge(dosing_df,
                    first_dose,
                    by = "patid",
                    suffixes = c("", "_first"))

ex <- data.frame(
  STUDYID = dosing_df$study,
  DOMAIN = "EX",
  USUBJID = paste0(dosing_df$study, "-", dosing_df$patid),
  EXSEQ = ave(seq_along(dosing_df$patid), dosing_df$patid, FUN = seq_along),
  EXTRT = dosing_df$rand,
  EXDOSE = as.numeric(gsub("[^0-9.]", "", dosing_df$dose)),
  EXDOSEU = ifelse(is.na(dosing_df$dose), NA, 'ml'),
  EXADJ = dosing_df$intreas,
  EXSTDTC = to_iso_ymd_hms(dosing_df$infdate, dosing_df$infsttm),
  EXENDDTC = to_iso_ymd_hms(dosing_df$infdate, dosing_df$infentm),
  EXSTDY = paste("Day",get_day(dosing_min$infdate_first, dosing_min$infdate)
  )
)
ex<- ex |> dplyr::arrange(USUBJID)

# run once
writexl::write_xlsx(ex,
                    "C:\\Users\\ManeKarapetyan\\Desktop\\sdtm-data-project\\ex.xlsx")
