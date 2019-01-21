
select z.providerid   as providerid, z.memberid, z.caprunyear , z.caprunmonth,  d.healthplanname, c.descr as lob,
 case when z.gender is null then 'U' else z.gender end as gender, 
 z.DateOfBirth, z.amtnetpayment, z.amtgrosspayment, z.capitationamount,
case when caprunmonth = '1' then  'Jan-' + substring(convert(nvarchar(50), caprunyear),3,2) 
when caprunmonth = '2' then  'Feb-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '3' then  'Mar-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '4' then  'Apr-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '5' then  'May-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '6' then  'Jun-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '7' then  'Jul-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '8' then  'Aug-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '9' then  'Sep-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '10' then  'Oct-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '11' then  'Nov-' + substring(convert(nvarchar(50), caprunyear),3,2)
when caprunmonth = '12' then  'Dec-' + substring(convert(nvarchar(50), caprunyear),3,2)
 end as month_yr
 from (
 
   Select distinct 
  case when a.primarycareprovid is null then b.primarycareprovid else a.primarycareprovid end as providerid,
  case when a.memberid is null then  b.memberid else a.memberid end as memberid,
  case when a.caprunyear is null then  b.capyear else a.caprunyear end as caprunyear,
  case when a.caprunmonth is null then  b.capmonth else a.caprunmonth end as caprunmonth,
  case when a.HealthplanCode is null then  b.HealthplanCode else a.HealthplanCode end as HealthplanCode,
  -- d.healthplanname, c.descr as lob,
 a.gender,DateOfBirth,a.amtnetpayment, a.amtgrosspayment, b.capitationamount
 from (select primarycareprovid,memberid, caprunyear ,caprunmonth,DateOfBirth,HealthplanCode,gender,
       sum(amtnetpayment) amtnetpayment,sum(amtgrosspayment) amtgrosspayment from
	   (select  primarycareprovid,memberid, caprunyear ,caprunmonth,DateOfBirth,HealthplanCode,gender,amtnetpayment, amtgrosspayment
	    from EOBMemberMonthsHistory 
	   where CapRunYear>=2017 ) G group by primarycareprovid,memberid, caprunyear ,caprunmonth,DateOfBirth,HealthplanCode,gender   ) a
full outer join  
      ( select memberid,primarycareprovid, capmonth, capyear,sum(capitationamount) capitationamount, HealthplanCode from 
	   (select  memberid,primarycareprovid, capmonth, capyear, capitationamount, HealthplanCode from  mtb_capitationrevenue
      where capyear>=2017) H group by memberid,primarycareprovid, capmonth, capyear , HealthplanCode) b 

  on a.memberid= b.memberid and a.primarycareprovid=b.primarycareprovid and a.caprunmonth=b.capmonth and a.caprunyear=b.capyear ) z
left JOIN HealthPlans d on z.HealthplanCode=d.HealthPlanCode
left JOIN LOB_CODES c on c.CODE = d.LOBCode  
