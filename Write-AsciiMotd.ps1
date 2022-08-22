[CmdletBinding()]
param ([System.ConsoleColor]$Color=[System.ConsoleColor]::Cyan)

$baseUrl = "https://www.asciiart.eu"

$categories = "animals", "art-and-design", "books", "buildings-and-places", "cartoons", "clothing-and-accessories", "comics", "computers", "electronics", "food-and-drinks", "holiday-and-events", "logos", "miscellaneous", "movies", "music", "mythology", "nature", "people", "plants", "religion", "space", "sports-and-outdoors", "television", "toys", "vehicles", "video-games", "weapons"


# Get the category homepage.
$progressPreference = 'silentlyContinue'

function Get-AsciiArt ($category) 
{
    $result = $null
    $categories = "/$category"

    do {
        $url = "$baseUrl$categories"
        $r = Invoke-WebRequest $url

        $subcategories = $r.Links | where { $_.Href -like "$categories*" }

        if ($subcategories.Count -eq 0) {
            $result = $r.ParsedHtml.getElementsByTagName("PRE") | where { $_.className -notlike "*text-dark*" } | Get-Random
        } else {
            $categories = $subcategories.Href | Get-Random
        }
    } while (($result -eq $null) -and ($subcategories.Count -gt 0))

    if ($result -ne $null) {
        $art = $result.innerText
    } else {
        $art = ""
    }

    return $art, $url
}

$category = $categories | Get-Random
$result = Get-AsciiArt $category

Write-Host "`n$($result[0])" -ForegroundColor $Color
Write-Host "`n  from: $($result[1])" -ForegroundColor DarkGray

