SELECT *
FROM [CovidProject].[dbo].[NashvilleHousingData ]


-- Standardize Date Format

SELECT SaleDate, CONVERT(date,Saledate)
FROM [CovidProject].[dbo].[NashvilleHousingData ]

ALTER TABLE [CovidProject].[dbo].[NashvilleHousingData ]
ADD Sale_Date date;


UPDATE [CovidProject].[dbo].[NashvilleHousingData ]
SET Sale_Date = CONVERT(date,Saledate)

SELECT Sale_Date
FROM [CovidProject].[dbo].[NashvilleHousingData ]

ALTER TABLE [CovidProject].[dbo].[NashvilleHousingData ]
DROP COLUMN SaleDate; 

-- Populate Property Address data(Dealing with NULL)


SELECT PropertyAddress
FROM [CovidProject].[dbo].[NashvilleHousingData ]
WHERE PropertyAddress is null

SELECT T.ParcelID, T.PropertyAddress, Ta.ParcelID, Ta.PropertyAddress, ISNULL(T.PropertyAddress, Ta.PropertyAddress)
FROM [CovidProject].[dbo].[NashvilleHousingData ] T
JOIN [CovidProject].[dbo].[NashvilleHousingData ] Ta
	ON T.ParcelID = Ta.ParcelID
	And T.[UniqueID ] <> Ta.[UniqueID ]
WHERE T.PropertyAddress is null

Update T
SET PropertyAddress = ISNULL(T.PropertyAddress, Ta.PropertyAddress)
FROM [CovidProject].[dbo].[NashvilleHousingData ] T
JOIN [CovidProject].[dbo].[NashvilleHousingData ] Ta
	ON T.ParcelID = Ta.ParcelID
	And T.[UniqueID ] <> Ta.[UniqueID ]
--WHERE T.PropertyAddress is null

SELECT *
FROM [CovidProject].[dbo].[NashvilleHousingData ]
WHERE PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [CovidProject].[dbo].[NashvilleHousingData ]

--Lets create columns to store address and city

ALTER TABLE [CovidProject].[dbo].[NashvilleHousingData ]
ADD Property_Address nvarchar(255)

ALTER TABLE [CovidProject].[dbo].[NashvilleHousingData ]
ADD Property_City nvarchar(255)

--Breaking out address and city
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as a
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as b
FROM [CovidProject].[dbo].[NashvilleHousingData ]

Update [CovidProject].[dbo].[NashvilleHousingData ]
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

Update [CovidProject].[dbo].[NashvilleHousingData ]
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))


--Split address, city, state


SELECT OwnerAddress
FROM [CovidProject].[dbo].[NashvilleHousingData ]


SELECT 
PARSENAME(REPLACE(OwnerAddress, ', ' , '.') ,3), 
PARSENAME(REPLACE(OwnerAddress, ', ' , '.') ,2), 
PARSENAME(REPLACE(OwnerAddress, ', ' , '.') ,1)
FROM [CovidProject].[dbo].[NashvilleHousingData ]


ALTER TABLE [CovidProject].[dbo].[NashvilleHousingData ]
ADD Owner_Address nvarchar(255), 
Owner_City nvarchar(255), 
Owner_State nvarchar(255)



Update [CovidProject].[dbo].[NashvilleHousingData ]
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ', ' , '.') ,3), 
Owner_City = PARSENAME(REPLACE(OwnerAddress, ', ' , '.') ,2), 
Owner_State = PARSENAME(REPLACE(OwnerAddress, ', ' , '.') ,1)

SELECT *
FROM [CovidProject].[dbo].[NashvilleHousingData ]

--Change Y and N to Yes and No in "Sold as Vacant" field

--Lets look at distinct values of the SoldAsVacant column

Select distinct SoldAsVacant, COUNT(SoldAsVacant)
FROM [CovidProject].[dbo].[NashvilleHousingData ]
Group by SoldAsVacant
Order by 2


UPDATE [CovidProject].[dbo].[NashvilleHousingData ]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END;



	





