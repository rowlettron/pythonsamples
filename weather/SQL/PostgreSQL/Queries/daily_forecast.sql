select
    l.locationid,
    arr.item_object ->> 'date' as forecast_date,
    arr.item_object ->> 'date_epoch' as forecast_date_epoch,
    arr.item_object -> 'day' ->> 'maxtemp_c' as maxtemp_c,
    arr.item_object -> 'day' ->> 'maxtemp_f' as maxtemp_f,
    arr.item_object -> 'day' ->> 'mintemp_c' as mintemp_c,
    arr.item_object -> 'day' ->> 'mintemp_f' as mintemp_f,
    arr.item_object -> 'day' ->> 'avgtemp_c' as avgtemp_c,
    arr.item_object -> 'day' ->> 'avgtemp_f' as avgtemp_f,
    arr.item_object -> 'day' ->> 'maxwind_mph' as maxwind_mph,
    arr.item_object -> 'day' ->> 'maxwind_kph' as maxwind_kph,
    arr.item_object -> 'day' ->> 'totalprecip_mm' as totalprecip_mm,
    arr.item_object -> 'day' ->> 'totalprecip_in' as totalprecip_in,
    arr.item_object -> 'day' ->> 'totalsnow_cm' as totalsnow_cm,
    arr.item_object -> 'day' ->> 'avgvis_miles' as avgvis_miles,
    arr.item_object -> 'day' ->> 'avgvis_km' as avgvis_km,
    arr.item_object -> 'day' ->> 'avghumidity' as avghumidity,
    arr.item_object -> 'day' ->> 'daily_will_it_rain' as daily_will_it_rain,
    arr.item_object -> 'day' ->> 'daily_chance_of_rain' as daily_chance_of_rain,
    arr.item_object -> 'day' ->> 'daily_will_it_snow' as daily_will_it_snow,
    arr.item_object -> 'day' ->> 'daily_chance_of_snow' as daily_chance_of_snow,
    arr.item_object -> 'day' -> 'condition' ->> 'text' as daily_conditions,
    arr.item_object -> 'day' ->> 'uv' as daily_uv,
    position
from
    public.weatherjsonload wjl
    cross join jsonb_array_elements(jsondata -> 'forecast' -> 'forecastday') with ordinality arr(item_object, position)
    inner join public.location l on wjl.jsondata -> 'location' ->> 'name' = l."name"

