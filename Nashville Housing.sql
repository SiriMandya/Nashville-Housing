-- View Entire Data
 SELECT *
 FROM [Nashville-Housing-Data-for-Data-Cleaning]

  -- Populate property address date

  SELECT PropertyAddress
 FROM [Nashville-Housing-Data-for-Data-Cleaning]
 WHERE PropertyAddress is NULL

 SELECT *
  FROM [Nashville-Housing-Data-for-Data-Cleaning]
 --WHERE PropertyAddress is NULL
 ORDER BY ParcelID

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
 FROM [Nashville-Housing-Data-for-Data-Cleaning] a
 JOIN [Nashville-Housing-Data-for-Data-Cleaning] b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM [Nashville-Housing-Data-for-Data-Cleaning] a
 JOIN [Nashville-Housing-Data-for-Data-Cleaning] b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Nashville-Housing-Data-for-Data-Cleaning] a
 JOIN [Nashville-Housing-Data-for-Data-Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Nashville-Housing-Data-for-Data-Cleaning]
--Where PropertyAddress is null
--order by ParcelID
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From [Nashville-Housing-Data-for-Data-Cleaning]

ALTER TABLE [Nashville-Housing-Data-for-Data-Cleaning]
Add PropertySplitAddress Nvarchar(255);

UPDATE [Nashville-Housing-Data-for-Data-Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [Nashville-Housing-Data-for-Data-Cleaning]
Add PropertySplitCity Nvarchar(255);

Update [Nashville-Housing-Data-for-Data-Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
 FROM [Nashville-Housing-Data-for-Data-Cleaning]

 SELECT OwnerAddress
 FROM [Nashville-Housing-Data-for-Data-Cleaning]

 SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Nashville-Housing-Data-for-Data-Cleaning]

ALTER [Nashville-Housing-Data-for-Data-Cleaning]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville-Housing-Data-for-Data-Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville-Housing-Data-for-Data-Cleaning]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville-Housing-Data-for-Data-Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [Nashville-Housing-Data-for-Data-Cleaning]
Add OwnerSplitState Nvarchar(255);

Update [Nashville-Housing-Data-for-Data-Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

 SELECT *
 FROM [Nashville-Housing-Data-for-Data-Cleaning]

 -- Change 1 and 0 to Yes and No in "Sold as Vacant" field
 SELECT DISTINCT(SoldASVacant)
 FROM [Nashville-Housing-Data-for-Data-Cleaning]

 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Nashville-Housing-Data-for-Data-Cleaning]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Nashville-Housing-Data-for-Data-Cleaning]

UPDATE [Nashville-Housing-Data-for-Data-Cleaning]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Removing duplicates

	   WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() 
	OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
		 ) row_num
From [Nashville-Housing-Data-for-Data-Cleaning] )

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From [Nashville-Housing-Data-for-Data-Cleaning]

-- Delete Unused Columns

Select *
From [Nashville-Housing-Data-for-Data-Cleaning]

ALTER TABLE [Nashville-Housing-Data-for-Data-Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate