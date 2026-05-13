# library(DBI)
# library(odbc)

# connect to clindata
con <- DBI::dbConnect(
  odbc::odbc(),
  Driver = "SQL Server",
  Server = "INV-03516\\SQLEXPRESS",
  Database = "clindata",
  Trusted_Connection = "Yes"
)

# push dm
dbWriteTable(con, "dm", dm, append = TRUE, row.names = FALSE)

# push ex
dbWriteTable(con, "ex", ex, append = TRUE, row.names = FALSE)

DBI::dbDisconnect(con)
message("Done.")
