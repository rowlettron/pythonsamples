clear-host

$apiHost = $Env:WEATHER_HOST
$apiKey = $Env:WEATHER_KEY 

$headers=@{}
$headers.Add("x-rapidapi-key", $apiKey)
$headers.Add("x-rapidapi-host", $apiHost)
$response = Invoke-WebRequest -Uri 'https://weatherapi-com.p.rapidapi.com/forecast.json?q=London&days=&alerts=yes3' -Method GET -Headers $headers

$myJson = $response.Content | ConvertFrom-Json

$myJson.location | Format-Table 



