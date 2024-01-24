/*

Cleaning Data in SQL Queries

*/


Select *
From portfolioproject..NashvilleHousing

--Updating the SaleDate column by removing the hr/min/sec section

Alter Table NashvilleHousing
Add SaleDateConverted date;

Update NashvilleHousing
Set SaleDateConverted = convert(date, SaleDate)


-- Popuate property adress date

Select *
From portfolioproject..NashvilleHousing
Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From portfolioproject..NashvilleHousing a
Join portfolioproject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From portfolioproject..NashvilleHousing a
Join portfolioproject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking Address into individual colume (Adress, city, state)


Select PropertyAddress
From portfolioproject..NashvilleHousing

Select
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) as Address
From portfolioproject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress))

Select *
From portfolioproject..NashvilleHousing

-- Working with the OwnerAddress

Select 
PARSENAME(REPLACE(owneraddress, ',', '.'), 3),
PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
From portfolioproject..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);


Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);


Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.'), 3)


Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)


Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',', '.'), 1)


Select *
From portfolioproject..NashvilleHousing


--Change 'Y' and 'N' to 'Yes' and 'No' respectively in the 'SoldAsVacant' field

Select Distinct SoldAsVacant, COUNT(SoldAsVacant)
From portfolioproject..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant, 
	CASE When SoldAsVacant = 'Y' THEN 'YES'
		 When SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END
From portfolioproject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
		 When SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END

Select Distinct SoldAsVacant, COUNT(SoldAsVacant)
From portfolioproject..NashvilleHousing
Group by SoldAsVacant
Order by 2


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing


-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
