# push_to_db.R
# Connects to the clindata SQL Server database and loads the dm and ex
# domain tables. Run DM.R and EX.R first so dm and ex exist in your environment.
# Tables are only created if they do not already exist.
# -----------------------------------------------------------------------

library(DBI)
library(odbc)

# connect to clindata
con <- DBI::dbConnect(
  odbc::odbc(),
  Driver = "SQL Server",
  Server = "localhost",
  Database = "clindata",
  Trusted_Connection = "Yes"
)

# push dm
if (!DBI::dbExistsTable(con, "dm")) {
  DBI::dbWriteTable(con, "dm", dm, row.names = FALSE)
  message("dm table created and loaded.")
} else {
  message("dm already exists — skipping. Drop it in SSMS to reload.")
}

# push ex
if (!DBI::dbExistsTable(con, "ex")) {
  DBI::dbWriteTable(con, "ex", ex, row.names = FALSE)
  message("ex table created and loaded.")
} else {
  message("ex already exists — skipping. Drop it in SSMS to reload.")
}

DBI::dbDisconnect(con)
message("Done.")
