SELECT *
FROM [CovidProject].[dbo].[NashvilleHousingData ]


-- Standardize Date Format

SELECT SaleDate, CONVERT(date,Saledate)
FROM [CovidProject].[dbo].[NashvilleHousingData ]

Update [CovidProject].[dbo].[NashvilleHousingData ]
SET SaleDate = CONVERT(date,Saledate)

SELECT SaleDate
FROM [CovidProject].[dbo].[NashvilleHousingData ]