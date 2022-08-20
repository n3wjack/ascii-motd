param ([System.ConsoleColor]$Color=[System.ConsoleColor]::Cyan)

$baseUrl = "https://www.asciiart.eu"

$categories = "animals", "art-and-design", "books", "buildings-and-places", "cartoons", "clothing-and-accessories", "comics", "computers", "electronics", "food-and-drinks", "holiday-and-events", "logos", "miscellaneous", "movies", "music", "mythology", "nature", "people", "plants", "religion", "space", "sports-and-outdoors", "television", "toys", "vehicles", "video-games", "weapons"

$category = $categories | random
# Get the category homepage.
$progressPreference = 'silentlyContinue'
$r = Invoke-WebRequest "$baseUrl/$category" -UseBasicParsing

$subcategories = $r.Links | where { $_.Href -like "/$category/*" }
$url = "$baseUrl$($subcategories.Href | random)" 
$r = Invoke-WebRequest $url
# Get all PRE tags, excluding the ones for the page header.
$element = $r.ParsedHtml.getElementsByTagName("PRE") | where { $_.className -notlike "*text-dark*" } | Get-Random

Write-Host "`n$($element.innerText)" -ForegroundColor $Color
Write-Host "`n  from: $url" -ForegroundColor DarkGray

