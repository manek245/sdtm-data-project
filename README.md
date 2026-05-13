# SDTM Data Pipeline 
# Clinical Trial Data Standardization

This project was built as part of learning how to work with real clinical trial data in R and SQL. The idea was simple — take raw data collected during a clinical study, clean it up properly, and load it into a database where it can be queried and analyzed. The output follows the SDTM format (Study Data Tabulation Model), which is a standard used in clinical research to organize patient-level data in a consistent and structured way.

## Dataset

The source data comes from five files collected during a clinical trial involving 30 patients across multiple countries. The trial tested a treatment called PEAR14 against a placebo. Data was collected across different stages of the trial — consent, eligibility, randomization, demographics, and infusion visits.

| File | Contents |
|------|----------|
| ICF.csv | Patient consent dates, study ID, patient ID, withdrawal info |
| Demo.xlsx | Age, gender (numeric coded), race (checklist), ethnicity |
| Dosing.xlsx | One row per infusion visit — date, time, dose, treatment arm |
| elig.xlsx | Eligibility flag and inclusion/exclusion criteria scores |
| rand.xlsx | Assigned treatment arm and randomization date (21 patients) |

## Project Structure

```
sdtm-data-project/
├── raw data/           Raw source files (CSV and XLSX)
├── R script/           R code files, (Data cleaning, connecting and pushing the data to server)
├── sql script/         SQL database structure and queries
├── README.md           Documentation for the project
```

## Database Schema

The database is called `clindata` and contains two tables:

**dm** — one row per patient. Primary key is `USUBJID` (unique subject ID). 
Contains basic demographics, treatment arm assignment, consent and reference dates, and geographic info.

**ex** — one row per infusion visit. Primary key is `(USUBJID, EXSEQ)`. Foreign key links back to `dm` via `USUBJID`. 
Contains dose, infusion datetime, study day, and dose adjustment info.

Both tables have indexes on commonly queried columns like `COUNTRY`, `ARM`, and `USUBJID` to make queries fast.

## Pipeline

The pipeline runs in three main steps:

1. **source.R, DM.R, EX.R** — reads raw data, make the data ready for analysis by applying CDISC STDM standards for clinical data (`DM` and `EX` domains).
2. **push_to_db.R** — connects to SQL Server on localhost and loads `dm` and `ex` into the `clindata` database.
3. **queries.sql** — SQL queries running in MSSQL on our created database. They answer insightful question about the clinical research.

## How to Run

1. Open the project in RStudio by double-clicking the `.Rproj` file
2. Run `source_ds` to load all the raw files and helper functions
3. Run `schema.sql` in MSSQL to create the database and table structure
4. Run `DM.R` and `EX` in RStudio
5. Run `push_to_db.R` in RStudio to push the data into SQL Server
6. Open `queries.sql` in MSSQL and run any query on `clindata`


## Data Cleaning Summary

- Patient IDs like `BRZ02-02092` were split into country, site, and subject number
- Two different date formats across files were standardized to ISO 8601 (YYYY-MM-DD) format
- Gender and ethnicity numeric codes were mapped to text labels ready for analysis
- Race was derived from a multi-column checklist (multiple boxes checked = MULTIPLE)
- Dose values stored as strings like `100ml` were split into numeric value and unit
- Study day was calculated relative to each patient's first infusion date (Day 1 = first visit)
- Dosing has 142 rows (multiple visits per patient) while consent and demographics have 30 — 
  all joins use ICF as the anchor so DM always has exactly 30 rows (patients)

## Analytical Results Summary

- 30 patients enrolled across multiple countries; 21 were randomized
- Patients were split between PLACEBO and PEAR14 treatment arms
- Most patients completed all scheduled infusion visits; a small number had dose adjustments
- Enrollment was spread across several months, visible from the consent date trend query

## R Packages Used

- `readr`, `readxl`, `writexl`,
for data reading and writing
- `dplyr`, `lubridate`, 
for data cleaning
- `DBI`, `odbc` 
for sql server connetion and data pushing
