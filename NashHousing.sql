USE DMK_Portfolio
GO
--Cleaning data in SQL Queries
SELECT * FROM dbo.NashvilleHousing

--Standardlize date format
SELECT SaleDate, CONVERT(DATE,SaleDate) FROM dbo.NashvilleHousing
ALTER TABLE dbo.NashvilleHousing ALTER COLUMN SaleDate DATE

--populate property address data 
SELECT * FROM dbo.NashvilleHousing ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b. PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM dbo.NashvilleHousing AS a JOIN dbo.NashvilleHousing AS b
ON a.ParcelID = b. ParcelID AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)

FROM dbo.NashvilleHousing AS a  JOIN dbo.NashvilleHousing AS b
ON a.ParcelID = b. ParcelID AND a.[UniqueID ] <> b.[UniqueID ] 
WHERE a.PropertyAddress IS NULL

--Breaking out Address into Individual Columns (address,city, State)

SELECT SUBSTRING(PropertyAddress,1,(CHARINDEX(',',PropertyAddress) - 1)) AS Address,
SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress) + 1),LEN(PropertyAddress) )

FROM dbo.NashvilleHousing

alter TABLE dbo.NashvilleHousing  ADD Street1 varchar(50)

UPDATE  dbo.NashvilleHousing  SET PropertyAddress = SUBSTRING(PropertyAddress,1,(CHARINDEX(',',PropertyAddress) - 1))
UPDATE  dbo.NashvilleHousing  SET Street1 = SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress) + 1),LEN(PropertyAddress) )

--Breaking out owner city 
SELECT OwnerAddress FROM dbo.NashvilleHousing
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
 PARSENAME(REPLACE(OwnerAddress,',','.'),2),
 PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing ADD ownerCity varchar(50)
alter TABLE dbo.NashvilleHousing ADD OwnerState varchar(50)

UPDATE dbo.NashvilleHousing SET OwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
UPDATE dbo.NashvilleHousing SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
UPDATE dbo.NashvilleHousing SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No in "Solid As Vacant" column
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) FROM dbo.NashvilleHousing GROUP BY (SoldAsVacant)


UPDATE dbo.NashvilleHousing SET SoldAsVacant = 'Yes' WHERE SoldAsVacant = 'Y'
UPDATE dbo.NashvilleHousing SET SoldAsVacant = 'No' WHERE SoldAsVacant = 'N'

--Remove unused Column
SELECT * FROM dbo.NashvilleHousing
ALTER TABLE dbo.NashvilleHousing DROP COLUMN TaxDistrict, street,







