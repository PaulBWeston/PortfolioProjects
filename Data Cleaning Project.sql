#Cleaning Nashville Housing Dataset
#by Paul Weston
#Link to Dataset: ______
#written in MySQL

USE `PortfolioProject`;

Select *
From HousingData;

#################################################
#Standardize Date Format

Select SaleDate, str_to_date(SaleDate, '%M%d,%Y')
From HousingData;

Update HousingData
Set SaleDate = str_to_date(SaleDate, '%M%d,%Y');

################################################
#Populate Property Address Data

Select *
From HousingData
Where PropertyAddress is Null;

	#After some searching through the data we can see that some parcelIDs are duplicates
	#We will use this to populate those property addresses that are missing

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
From HousingData AS a
Join HousingData AS b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null;

Update HousingData AS a
Join HousingData AS b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = ifnull(a.PropertyAddress, b.PropertyAddress)    
Where a.PropertyAddress is null;


#############################################
#Break Out ProprtyAddress and OwnerAddress into Individual Columns

Select PropertyAddress
From HousingData;

Select Substring(PropertyAddress,1, locate(',', PropertyAddress)-1) AS StreetAddress,
Substring(PropertyAddress,locate(',', PropertyAddress) +2) AS City
From HousingData;

Alter table HousingData
Add PropertyStreetAddress varchar(200);

Update HousingData
Set PropertyStreetAddress = Substring(PropertyAddress,1, locate(',', PropertyAddress)-1);

Alter table HousingData
Add PropertyCity varchar(200);

Update HousingData
Set PropertyCity = Substring(PropertyAddress,locate(',', PropertyAddress) +2);

Select *
From HousingData;

#Now for OwnerAddress, this time using substring_index

Select OwnerAddress
FROM HousingData;

Select OwnerAddress, 
Substring_index(OwnerAddress, ',', 1) AS OwnerSplitStreetAddress,
Substring(Substring_index(OwnerAddress, ',', 2), locate(',',PropertyAddress)+2) AS OwnerSplitCityAddress,
Substring_index(OwnerAddress, ',', -1) AS OwnerSplitStateAddress
From HousingData;

Alter table HousingData
Add OwnerSplitStreetAddress varchar(200);

Update HousingData
Set OwnerSplitStreetAddress = Substring_index(OwnerAddress, ',', 1);

Alter table HousingData
Add OwnerSplitCityAddress varchar(200);

Update HousingData
Set OwnerSplitCityAddress = Substring(Substring_index(OwnerAddress, ',', 2), locate(',',PropertyAddress)+2);

Alter table HousingData
Add OwnerSplitStateAddress varchar(200);

Update HousingData
Set OwnerSplitStateAddress = Substring_index(OwnerAddress, ',', -1);

Select OwnerSplitStateAddress, Trim(OwnerSplitStateAddress)
From HousingData;

Update HousingData
Set OwnerSplitStateAddress = Trim(OwnerSplitStateAddress);

#############################################
#Changing 'Y' and 'N' in SoldAsVacant to 'Yes' and 'No'

Select SoldAsVacant, Count(SoldAsVacant)
From HousingData
Group by SoldAsVacant
Order by 2;

Select SoldAsVacant,
Case
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
END
From HousingData;

Update HousingData
Set SoldAsVacant = Case
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END;

#############################################
#Remove duplicates

WITH RowNumCTE AS (
Select *, row_number() OVER
(partition by 
	ParcelID, 
	PropertyAddress, 
    SalePrice, 
    SaleDate, 
    LegalReference
order by UniqueID) AS Row_num
From HousingData)
Select *
FROM RowNumCTE
WHERE Row_Num > 1;

	#Since CTEs are non updatable in mysql we will use a join to delete the duplicate rows

WITH RowNumCTE AS (
Select *, row_number() OVER
(partition by 
	ParcelID, 
	PropertyAddress, 
    SalePrice, 
    SaleDate, 
    LegalReference
order by UniqueID) AS Row_num
From HousingData)
DELETE
FROM HousingData 
USING HousingData
JOIN RowNumCTE
	ON RowNumCTE.UniqueID = HousingData.UniqueID
WHERE RowNumCTE.Row_Num > 1;

#############################################
#Standardize SalePrice by removing '$', '.00', and ',' and then convert to integer

Select SalePrice, Substring(SalePrice, 2)
FROM HousingData
WHERE SalePrice Like '$%';

Update HousingData
Set SalePrice = Substring(SalePrice, 2)
WHERE SalePrice Like '$%';

Select SalePrice, Substring(SalePrice,1,length(SalePrice)-3)
FROM HousingData
WHERE SalePrice LIKE '%.%' ;

Update HousingData
Set SalePrice = Substring(SalePrice,1,length(SalePrice)-3)
WHERE SalePrice LIKE '%.%' ;

Select SalePrice
From HousingData
Where SalePrice LIKE '%,%'; 

Select SalePrice, Concat(Substring_index(SalePrice, ',', 1),
Substring(Substring_index(SalePrice, ',', 2), locate(',',SalePrice)+1))
From HousingData
Where SalePrice LIKE '%,%'
AND SalePrice NOT LIKE '%,%,%';

Update HousingData
Set SalePrice = Concat(Substring_index(SalePrice, ',', 1),
Substring(Substring_index(SalePrice, ',', 2), locate(',',SalePrice)+1))
Where SalePrice LIKE '%,%'
AND SalePrice NOT LIKE '%,%,%';

Select SalePrice, 
Concat(Substring_index(SalePrice, ',', 1),
	Substring(Substring_index(SalePrice, ',', 2), 
    locate(',',SalePrice)+1),Substring_index(SalePrice, ',', -1))
From HousingData
Where SalePrice LIKE '%,%,%';

Update HousingData
Set SalePrice = Concat(Substring_index(SalePrice, ',', 1),
	Substring(Substring_index(SalePrice, ',', 2), 
    locate(',',SalePrice)+1),Substring_index(SalePrice, ',', -1))
Where SalePrice LIKE '%,%,%';

	#Now to avoid losing data, we will create a new INT column and transfer SalePrice into it
    
Alter Table HousingData 
Add SalePriceINT INT;

Select SalePrice, Convert(SalePrice, Unsigned)
FROM HousingData
ORDER BY 2;

Update HousingData
Set SalePriceINT = Convert(SalePrice, Unsigned);


#############################################
#Remove unused columns

Select *
FROM HousingData;

Alter Table HousingData
Drop Column OwnerAddress;

Alter Table HousingData
Drop Column PropertyAddress;

