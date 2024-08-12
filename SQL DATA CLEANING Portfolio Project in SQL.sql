--Cleaning Data in SQL Queries


Select * from dbo.[Nashville housing Data]


---Standardize Date Format


Select SaleDateconverted, CONVERT(Date,saledate) 
FROM dbo.[Nashville housing Data]

Update [Nashville housing Data]
set SaleDate = CONVERT(Date,saledate)

Alter Table [Nashville housing Data]
Add SaleDateconverted Date;

Update [Nashville housing Data]
set SaleDateConverted = CONVERT(Date,saledate)


--Populate property Address

Select *
From dbo.[Nashville housing Data]
--Where Propertyaddress is null
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
From dbo.[Nashville housing Data] a
Join dbo.[Nashville housing Data] b
     on a.ParcelID =b.ParcelID
	 And a.[UniqueID ]<>b.[UniqueID ]
	 Where a.PropertyAddress is null


Update a 
Set PropertyAddress= ISNULL(a.propertyaddress,b.PropertyAddress)
From dbo.[Nashville housing Data] a
Join dbo.[Nashville housing Data] b
     on a.ParcelID =b.ParcelID
	 And a.[UniqueID ]<>b.[UniqueID ]
	 Where a.PropertyAddress is null


---Breaking Address where into individual columns (Adress,City,State)

Select PropertyAddress
From dbo.[Nashville housing Data]

Select 
Substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as address
--, Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1), LEN(Propertyaddress)) as address
From dbo.[Nashville housing Data]

Select 
Substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as address
, Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(Propertyaddress)) as address
From dbo.[Nashville housing Data]


Alter Table [Nashville housing Data]
Add Propertysplitaddress NVARCHAR(225);

Update [Nashville housing Data]
set Propertysplitaddress = Substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

Alter Table [Nashville housing Data]
Add Propertysplitcity NVARCHAR(225);

Update [Nashville housing Data]
set Propertysplitcity = Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(Propertyaddress))


Select *
From dbo.[Nashville housing Data]


Select OwnerAddress
From dbo.[Nashville housing Data]

Select
PARSENAME(REPLACE(Owneraddress, ',', '.') ,3)
,PARSENAME(REPLACE(Owneraddress, ',', '.') ,2)
,PARSENAME(REPLACE(Owneraddress, ',', '.') ,1)
From dbo.[Nashville housing Data]



Alter Table [Nashville housing Data]
Add Ownersplitaddress NVARCHAR(225);

Update [Nashville housing Data]
set Ownersplitaddress = PARSENAME(REPLACE(Owneraddress, ',', '.') ,3)

Alter Table [Nashville housing Data]
Add Ownersplitcity NVARCHAR(225);

Update [Nashville housing Data]
set Ownersplitcity = PARSENAME(REPLACE(Owneraddress, ',', '.') ,2)

Alter Table [Nashville housing Data]
Add Ownersplitstate NVARCHAR(225);

Update [Nashville housing Data]
set Ownersplitstate = PARSENAME(REPLACE(Owneraddress, ',', '.') ,1)


Select *
From dbo.[Nashville housing Data]




---Change Y and N to YES and NO  in soldasvacant

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From dbo.[Nashville housing Data]
Group by SoldAsVacant
order by 2



Select SoldAsVacant,
CASE When SoldAsVacant ='Y' Then 'Yes'
      When SoldAsVacant ='N'  Then 'No'
	  ELSE SoldAsVacant
	  END
From dbo.[Nashville housing Data]


Update dbo.[Nashville housing Data]
SET SoldAsVacant = CASE When SoldAsVacant ='Y' Then 'Yes'
      When SoldAsVacant ='N'  Then 'No'
	  ELSE SoldAsVacant
	  END



---REMOVE DUPLICATES
 With RowNumCTE AS (
 Select *,
        ROW_NUMBER () OVER (
		PARTITION BY ParcelID,
                     PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					 UniqueID
					 )row_num
From dbo.[Nashville housing Data]
--Order by ParcelID
)
Delete
from RowNumCTE
Where row_num > 1
--Order by PropertyAddress


 ---B


With RowNumCTE AS (
 Select *,
        ROW_NUMBER () OVER (
		PARTITION BY ParcelID,
                     PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					 UniqueID
					 )row_num
From dbo.[Nashville housing Data]
--Order by ParcelID
)
Select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress


----Deleting Unused Columns



ALTER TABLE dbo.[Nashville housing Data]
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress


ALTER TABLE dbo.[Nashville housing Data]
DROP COLUMN SaleDate
