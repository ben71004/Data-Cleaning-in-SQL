f-- Cleaning Data in SQL Queries
select * from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- standardizing the date format
select saledate, convert(Date, saledate)
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing 
set saledate = convert(date,saledate)

alter table nashvillehousing 
add saledateconverted date 

update PortfolioProject..NashvilleHousing 
set saledateconverted = convert(date,saledate)

select saledateconverted
from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- populating prepoerty address data
select *
from PortfolioProject..NashvilleHousing
order by ParcelID

select a.parcelid, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- breaking addresses into individual columns (address, city, state)
select propertyaddress
from PortfolioProject..NashvilleHousing


select substring (propertyaddress, 1, charindex(',',PropertyAddress)-1) as address

from PortfolioProject..NashvilleHousing


alter table nashvillehousing
add Address varchar(255)

update PortfolioProject..NashvilleHousing
set Address = substring (propertyaddress, 1, charindex(',',PropertyAddress)-1)

select Address
from PortfolioProject..NashvilleHousing

alter table nashvillehousing
add city varchar(255)

update PortfolioProject..NashvilleHousing
set City = substring (propertyaddress, charindex(',',PropertyAddress)+1,len(propertyaddress))

select city from PortfolioProject..NashvilleHousing





select 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
add ownerSplitAddress varchar(255)
update PortfolioProject..NashvilleHousing
set ownerSplitAddress = parsename(replace(owneraddress,',','.'),3)


alter table PortfolioProject..NashvilleHousing
add ownerSplitCity varchar(255)
update PortfolioProject..NashvilleHousing
set ownerSplitCity = parsename(replace(owneraddress,',','.'),2)


alter table PortfolioProject..NashvilleHousing
add ownerSplitState varchar(255)
update PortfolioProject..NashvilleHousing
set ownerSplitState = parsename(replace(owneraddress,',','.'),1)


select * from PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- change y and n to yes and no in "sold as vacant" field 

update PortfolioProject..NashvilleHousing
set soldasvacant = 'No' 
where soldasvacant = 'n'

update PortfolioProject..NashvilleHousing
set soldasvacant = 'Yes' 
where soldasvacant = 'y'

select SoldAsVacant from PortfolioProject..NashvilleHousing
where SoldAsVacant = 'Y'

--select soldasvacant,
--case when soldasvacant = 'y' then 'yes'
--	 when soldasvacant = 'n' then 'no'
--	 else soldasvacant
--	 end
--from PortfolioProject..NashvilleHousing

--we can also do it this way if we want to use an if-else statement in SQL, we have to use the update statement with the conditions shown above


select distinct soldasvacant, count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- remove duplicates

with RowNumCTE AS(
select * ,
ROW_NUMBER() over (
partition by parcelid,
			 propertyaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by 
				uniqueid) row_num
from PortfolioProject..NashvilleHousing
)
select * from RowNumCTE
where row_num>1


--delete from RowNumCTE
--where row_num>1
-- the above statement was used to delete all the rows that had the duplicate values. put it in place of the select statement shown above

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- delete unused columns

select *
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject..NashvilleHousing
drop column saledate

