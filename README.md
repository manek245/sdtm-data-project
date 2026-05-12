# SDTM Data Pipeline — Clinical Trial Data Standardization

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
├── data/               Raw source files (CSV and XLSX)
├── DM.R                Creates the Demographics domain
├── EX.R                Creates the Exposure domain
├── push_to_db.R        Loads dm and ex into SQL Server
├── schema.sql          Creates the clindata database and table structure
├── queries.sql         SQL queries for data analysis
├── README.md
└── renv.lock           Package version snapshot
```

## Database Schema

The database is called `clindata` and contains two tables:

**dm** — one row per patient. Primary key is `USUBJID` (unique subject ID). Contains demographics, treatment arm assignment, consent and reference dates, and geographic info.

**ex** — one row per infusion visit. Primary key is `(USUBJID, EXSEQ)`. Foreign key links back to `dm` via `USUBJID`. Contains dose, infusion datetime, study day, and dose adjustment info.

Both tables have indexes on commonly queried columns like `COUNTRY`, `ARM`, and `USUBJID` to keep queries fast.

## Pipeline

The pipeline runs in four steps:

1. **DM.R** — reads ICF, Demo, Dosing, and Randomization files, joins them by patient ID, applies all cleaning and transformation, and produces the `dm` data frame (30 rows, one per patient)
2. **EX.R** — reads the Dosing file, calculates visit sequences and study days, extracts numeric dose values, and produces the `ex` data frame (142 rows, one per infusion visit)
3. **push_to_db.R** — connects to SQL Server on localhost and loads `dm` and `ex` into the `clindata` database. Skips tables that already exist to avoid accidental overwrites
4. **queries.sql** — run in SSMS to explore and analyze the loaded data

## How to Run

1. Open the project in RStudio by double-clicking the `.Rproj` file
2. Run `renv::restore()` to install all required packages
3. Run `schema.sql` in SSMS to create the database and table structure
4. Run `DM.R` in RStudio
5. Run `EX.R` in RStudio
6. Run `push_to_db.R` in RStudio to load the data into SQL Server
7. Open `queries.sql` in SSMS and run any query against `clindata`

To reload the data after changes, drop the `dm` and `ex` tables in SSMS, then re-run steps 4–6.

## Data Cleaning Summary

- Patient IDs like `BRZ02-02092` were split into country, site, and subject number
- Two different date formats across files were standardized to ISO 8601 (YYYY-MM-DD)
- Gender and ethnicity numeric codes were mapped to text labels
- Race was derived from a multi-column checklist (multiple boxes checked = MULTIPLE)
- Dose values stored as strings like `100ml` were split into numeric value and unit
- Study day was calculated relative to each patient's first infusion date (Day 1 = first visit)
- Dosing has 142 rows (multiple visits per patient) while consent and demographics have 30 — all joins use ICF as the anchor so DM always has exactly 30 rows

## Analytical Results Summary

- 30 patients enrolled across multiple countries; 21 were randomized
- Patients were split between PLACEBO and PEAR14 treatment arms
- Average age across the study was in the mid-40s range
- Most patients completed all scheduled infusion visits; a small number had dose adjustments
- Enrollment was spread across several months, visible from the consent date trend query
- Dose adjustments were more frequent in later visits than earlier ones

## Packages Used

`readr`, `readxl`, `dplyr`, `lubridate`, `DBI`, `odbc`, `writexl`
