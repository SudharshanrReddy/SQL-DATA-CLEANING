                                     / * Data Cleaning in SQL */

 select * 
 from Projects.dbo.NashvilleHousing;

------------------------------------------------------------------------------------------------------------

 ---Standardize Date format

 select SaleDate , convert(Date, SaleDate) 
 from Projects.dbo.NashvilleHousing;

 Alter  Table NashvilleHousing
 Add SaleDateConverted Date;

 update NashvilleHousing
 set SaleDateConverted = convert(Date, SaleDate);


 ----------------------------------------------------------------------------------------------------------

 ---Breaking out the Address into Individual Columns [Address, City, State]

 select PropertyAddress
 from Projects.dbo.NashvilleHousing;

 select 
 PARSENAME(Replace(PropertyAddress, ',', '.'), 2),
 PARSENAME(Replace(PropertyAddress, ',', '.'), 1)
 from Projects.dbo.NashvilleHousing;

 Alter table NashvilleHousing
 Add PropertySplitAddress nvarchar(255);
 
 Update  NashvilleHousing
 set PropertySplitAddress = PARSENAME(Replace(PropertyAddress, ',', '.'), 2);

 Alter table NashvilleHousing
 Add PropertySplitCity nvarchar(255);

 Update NashvilleHousing
 set PropertySplitCity =  PARSENAME(Replace(PropertyAddress, ',', '.'), 1);


 Select OwnerAddress
 from Projects.dbo.NashvilleHousing;

 select 
  PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
  PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
  PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
 from Projects.dbo.NashvilleHousing;

 Alter table NashvilleHousing
 Add OwnerSplitAddress nvarchar(255);

 Update  NashvilleHousing
 set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3); 

 Alter table NashvilleHousing
 Add OwnerSplitCity nvarchar(255);

 Update  NashvilleHousing
 set OwnerSplitcity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2);

 Alter table NashvilleHousing
 Add OwnerSplitState nvarchar(255);

 Update  NashvilleHousing
 set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1);

 select * 
 from Projects.dbo.NashvilleHousing;

 ----------------------------------------------------------------------------------------------------------

 ---Change Y and N to Yes and No in "Sold As Vacant" field

 select SoldAsVacant, count(SoldAsVacant)
 from Projects.dbo.NashvilleHousing
 Group by SoldAsVacant
 order by count(SoldAsVacant);

 select SoldAsVacant,
 CASE 
     when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
 END 
 from Projects.dbo.NashvilleHousing;

 Update NashvilleHousing
 set SoldAsVacant = CASE 
     when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
 END

 ----------------------------------------------------------------------------------------------------------

 ---Remove Duplicates

 With RowNumCTE as
 (
 select *,
 ROW_NUMBER() over (partition by  ParcelID,
                                  PropertyAddress,
								  SaleDate,
								  LegalReference
					Order by UniqueID
 ) row_num
 from Projects.dbo.NashvilleHousing)
 Delete from RowNumCTE
 where row_num > 1;

 select * 
 from Projects.dbo.NashvilleHousing;

 ----------------------------------------------------------------------------------------------------------

 ---Delete unused columns

 select * 
 from Projects.dbo.NashvilleHousing;
 
 Alter Table NashvilleHousing
 DROP column PropertyAddress, OwnerAddress, SaleDate, TaxDistrict;

 select * 
 from Projects.dbo.NashvilleHousing;