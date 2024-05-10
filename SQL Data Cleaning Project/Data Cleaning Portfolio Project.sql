/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


----------

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)

-- UPDATE did not work so an alternative way to change the date would be to add another field/column and delete the SaleDate field/column

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- After checking with the query below, the alternative option (SaleDateConverted) worked

SELECT SaleDateConverted
FROM NashvilleHousing

----------


-- Populate the Property Address data

-- First analyzed data and noticed ParcelIDs had matching PropertyAddresses but UniqueIDs

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

-- Made an UPDATE based on the ISNULL statement above and executed above query again to verify the UPDATE worked

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing AS a
JOIN PortfolioProject.dbo.NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


----------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

-- After analayzing data, it was noticed that a ',' was used as a delimeter to separate Address from City
-- USE '- 1' to remove the comma from the results

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address
FROM PortfolioProject.dbo.NashvilleHousing

-- To separate the City, the ending of the Address ( + 2 to remove the comma & space) must indicate the start and
-- the end position should be the length of the PropertyAddress

SELECT SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) AS City
FROM PortfolioProject.dbo.NashvilleHousing

-- Alternatively, fields/columns can be added and updated using the above substrings

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))

-- Another way to break out Address into Individual Columns (Address, City, State) using OwnerAddress

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

-- A comma is the delimeter for Address, City and State
-- PARSENAME (replace the commas with periods first) to separate fields backwards (1 is is the State)

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitState
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


----------

-- Change Y and N to Yes and No in SoldAsVacant field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS CountSAVCategory
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY CountSAVCategory

-- After analyzing data above, it was noticed that SoldAsVacant category consisted of Y, Yes, N, and No

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM PortfolioProject.dbo.NashvilleHousing
WHERE SoldAsVacant IN ('Y','N')

-- A case statement was used to change the letters to their corresponding words
-- The statement was then used to update records

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END


----------

-- Remove Duplicates

-- Created a CTE using windows functions to find and delete duplicate values 
-- Pretend records do not have a unique identifier when using PARTITION BY

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER
	(PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) AS Row_Num
FROM PortfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
--SELECT *
DELETE
FROM RowNumCTE
WHERE Row_Num > 1
--ORDER BY PropertyAddress


----------

-- Delete Unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate,PropertyAddress, OwnerAddress, TaxDistrict;