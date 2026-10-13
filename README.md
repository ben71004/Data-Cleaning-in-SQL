# Nashville Housing Data Cleaning in SQL Server

## Overview
This project cleans a raw Nashville housing sales dataset using T-SQL in SQL Server. The goal is to turn the imported data into a consistent, duplicate free table that is ready for analysis.

## Dataset
The data is a Nashville housing sales dataset imported from Excel into a database called PortfolioProject, in a table named NashvilleHousing. Each row is a property sale, with fields such as ParcelID, PropertyAddress, OwnerAddress, SaleDate, SalePrice, SoldAsVacant, and LegalReference.

**Source:** https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx

## Tools
* SQL Server Express
* SQL Server Management Studio (SSMS)

## Cleaning Steps

### 1. Standardize the date format
SaleDate included a time component that was not needed. I used CONVERT to cast it to a plain date and stored the result in a new column, SaleDateConverted.

### 2. Populate missing property addresses
Some rows had a NULL PropertyAddress. Rows with the same ParcelID refer to the same property, so I self joined the table on ParcelID (with a different UniqueID) and used ISNULL to fill each missing address from a matching row.

### 3. Split addresses into individual columns
* PropertyAddress was split into Address and City using SUBSTRING and CHARINDEX on the comma.
* OwnerAddress was split into OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState using REPLACE and PARSENAME. This is a shorter alternative to SUBSTRING when the values share a consistent delimiter.

### 4. Standardize the SoldAsVacant field
The column contained Y, N, Yes, and No. I used UPDATE statements to convert Y and N to Yes and No, then checked the result with a grouped count. A CASE statement is included as a commented alternative.

### 5. Remove duplicates
I used a CTE with ROW_NUMBER() partitioned by ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalReference, ordered by UniqueID. Any row with a row number above 1 is a duplicate. I reviewed these rows with a SELECT first, then removed them with DELETE.

### 6. Delete unused columns
After the new columns were created, I dropped OwnerAddress, TaxDistrict, PropertyAddress, and SaleDate, since they were replaced by the cleaned versions or were not needed.

## SQL Skills Demonstrated
* Data type conversion with CONVERT
* Self joins to fill in missing values
* String functions: SUBSTRING, CHARINDEX, REPLACE, PARSENAME
* Adding columns and updating them with ALTER TABLE and UPDATE
* CASE logic and conditional updates
* Removing duplicates with a CTE, ROW_NUMBER(), and PARTITION BY
* Dropping columns with ALTER TABLE

## How to Use
1. Import the Excel file into SQL Server as NashvilleHousing in a database named PortfolioProject.
2. Open the script in SSMS and run it section by section, checking each SELECT before running the changes.
3. Review the duplicate rows before running the DELETE, as it cannot be undone without a backup.

## Notes
The duplicate removal step runs before the unused columns are dropped, because it relies on PropertyAddress and SaleDate. Running the steps in a different order would break it.
