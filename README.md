# SDTM Data Pipeline — Clinical Trial Data Standardization

This project was built as part of learning how to work with real clinical trial data in R. The goal was to take raw data collected during a clinical study — scattered across multiple Excel and CSV files — and turn it into clean, standardized tables that follow the SDTM format (Study Data Tabulation Model), which is a widely used standard in clinical research for organizing patient-level data.

## What the project does

The source data comes from five files: patient consent records, demographics, dosing/infusion visits, eligibility checks, and randomization assignments. Each file covers a different part of the trial and they all need to be connected through a common patient ID to make sense together.

The pipeline reads all of these files, cleans and transforms the data in R, and loads the results into a SQL Server database called `clindata`. From there, SQL queries can be used to explore and present the data.

## Files

- **DM.R** — Creates the Demographics domain. Reads ICF, Demo, Dosing, and Randomization files, joins them by patient ID, and builds a clean table with one row per patient. Handles things like splitting the patient ID into country, site, and subject number, mapping numeric gender and ethnicity codes to proper labels, and deriving race from a checklist format.

- **EX.R** — Creates the Exposure domain. Reads the Dosing file and produces one row per infusion visit. Calculates which visit number each row is for each patient, extracts the numeric dose from a text string, and computes the study day relative to each patient's first infusion.

- **push_to_db.R** — Connects to SQL Server and loads the dm and ex tables into the clindata database. Checks if the tables already exist before pushing so nothing gets overwritten by accident.

- **queries.sql** — A set of SQL queries written to answer questions about the data once it's in the database. Includes simple counts, patient profiles, and more complex questions using joins and CTEs.

## Why this is useful

Clinical trial data is almost never clean or ready to use out of the box. It comes from different sources, in different formats, with inconsistent naming and coding. This pipeline solves that by bringing everything together in one place and applying consistent rules so the output is predictable and reliable.

Having the final data in SQL also means it can be easily queried, shared, or connected to other tools without needing to re-run R every time.

## What questions it can answer

- How many patients participated and where are they from?
- What is the age and gender breakdown of the study population?
- Which patients were on placebo vs active treatment?
- How many infusion visits did each patient complete?
- Were there any dose adjustments and why?
- Which patients withdrew from the study?

## Tech used

R, RStudio, readr, readxl, dplyr, lubridate, DBI, odbc, SQL Server