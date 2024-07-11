select jsondata -> 'location' ->> 'name' as location_name,
       jsondata -> 'location' ->> 'region' as region,
	   jsondata -> 'location' ->> 'country' as country,
	   jsondata -> 'location' ->> 'latitude' as latitude,
	   jsondata -> 'location' ->> 'lon' as longitude,
	   jsondata -> 'location' ->> 'tz_id' as timezone,
	   jsondata -> 'location' ->> 'localtime_epoch' as localtime_epoch,
	   jsondata -> 'location' ->> 'localtime' as localtime
	   
from weatherjsonload;

