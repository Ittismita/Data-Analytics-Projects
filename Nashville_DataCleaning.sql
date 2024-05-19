SELECT * FROM Portfolio_Project.nashvillehousing;

Select SaleDate 
from Portfolio_Project.nashvillehousing;

#converting into standard date format
update Portfolio_Project.nashvillehousing
set SaleDate=str_to_date(SaleDate,'%M %e, %Y');

#replacing the nulls in PropertyAddress column
#we have repeating ParcelID 
select ParcelID, PropertyAddress
from Portfolio_Project.nashvillehousing
where PropertyAddress is NULL;
;


update Portfolio_Project.nashvillehousing
set PropertyAddress=NULL 
where PropertyAddress='';

select A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress
from Portfolio_Project.nashvillehousing as A
join Portfolio_Project.nashvillehousing as B
    on a.ParcelID=b.ParcelID
    and a.uniqueID<>b.uniqueID
where A.PropertyAddress is NULL;
-- is NULL is used to test for empty values in a column, while = NULL is used to assign a NULL value to a variable.
    
    

-- ISNULL(a,b) wherever a is null, fill that with b, b could also be a string
update Portfolio_Project.nashvillehousing as A
join Portfolio_Project.nashvillehousing as B
    on a.ParcelID=b.ParcelID
    and a.uniqueID<>b.uniqueID
set A.PropertyAddress=COALESCE(A.PropertyAddress, B.PropertyAddress)
where A.PropertyAddress is NULL;

# splitting propert address column to adress and city
-- using LOCATE intead of CHARINDEX as MySQL isnt recognizing CHARINDEX function
select
substring(PropertyAddress,1,LOCATE(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,LOCATE(',',PropertyAddress)+1,LENGTH(PropertyAddress)) as City
from Portfolio_Project.nashvillehousing;


ALTER table Portfolio_Project.nashvillehousing
add Property_Address nvarchar(255);

update Portfolio_Project.nashvillehousing
set Property_Address=substring(PropertyAddress,1,LOCATE(',',PropertyAddress)-1);

ALTER table Portfolio_Project.nashvillehousing
add Property_City nvarchar(255);

update Portfolio_Project.nashvillehousing
set Property_City=substring(PropertyAddress,LOCATE(',',PropertyAddress)+1,LENGTH(PropertyAddress));


# splitting the OwnerAddress column into three columns
-- PARSENAME() only considers '.' as delimitter, hence reppalcing ',' with '.'
-- in mysql there is no parsename inbuilt function , so we use any of SUBSTRING_INDEX(), TRIM(), CONCAT()
-- substring_index(column_name,'delimitter',1)=returns string upto first occurence of delimitter given
-- substring_index(column_name,'delimitter',2)=returns string upto second occurence of delimitter given and so on
-- substring_index(column_name,'delimitter',-1)=returns string after last occurence of delimitter given
select 
Substring_index(OwnerAddress,',',1),
Substring_index(Substring_Index(OwnerAddress,',',2),',',-1),
Substring_index(OwnerAddress,',',-1)
from Portfolio_Project.nashvillehousing;

Alter table Portfolio_Project.nashvillehousing
add Owner_Address varchar(255),
add Owner_city varchar(255),
add Owner_state varchar(255);

update Portfolio_Project.nashvillehousing
set Owner_Address=Substring_index(OwnerAddress,',',1);

update Portfolio_Project.nashvillehousing
set Owner_city=Substring_index(Substring_Index(OwnerAddress,',',2),',',-1);
    
update Portfolio_Project.nashvillehousing    
set Owner_state=Substring_index(OwnerAddress,',',-1);


# replacing the Y and N with Yes and No respectively, in SoldAsVacant column
select distinct(SoldAsVacant),count(SoldAsVacant)
from Portfolio_Project.nashvillehousing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
	Case when SoldAsVacant='Y' then 'Yes'
		 when SoldAsVacant='N' then 'No'
         else SoldAsVacant
         end
from Portfolio_Project.nashvillehousing;

update Portfolio_Project.nashvillehousing
set SoldAsVacant=Case when SoldAsVacant='Y' then 'Yes'
		 when SoldAsVacant='N' then 'No'
         else SoldAsVacant
         end
;
         
#removing duplicate rows
-- partiton by works similar to group by clause
-- group by- It gives one row per group in result set. 
           -- For example, we get a result for each group of CustomerCity in the GROUP BY clause.
-- partition by- It gives aggregated columns with each record in the specified table.
               -- We have 15 records in the Orders table. 
               -- In the query output of SQL PARTITION BY, we also get 15 rows along with Min, Max and average values.

with dup_row_cte as(
select *,
ROW_NUMBER() over (
	partition by ParcelId,
				 PropertyAddress,
                 SaleDate,Saleprice,LegalReference
                 order by UniqueID
                 ) row_num
from Portfolio_Project.nashvillehousing

)
select *
from dup_row_cte
where row_num>2;
-- cannot delete directly from cte

DELETE FROM Portfolio_Project.nashvillehousing
WHERE UniqueID IN (
    SELECT UniqueID
    FROM dup_row_cte
    WHERE row_num > 1
)
;

#removing unwanted columns
alter table Portfolio_Project.nashvillehousing
drop column PropertyAddress,
drop column OwnerAddress,
drop column TaxDistrict;
	


