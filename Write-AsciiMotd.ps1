<#
.SYNOPSIS
    Write some awesome ASCII art to the console.	
    
    https://github.com/n3wjack/ascii-motd

.DESCRIPTION
	Gets random ASCII art from the asciiart.eu site and prints it out in the console. You can specify the output color using the 'Color' parameter.
.PARAMETER Color
	The color to use to write the ASCII art.
.EXAMPLE
	.\Write-AsciiMotd.ps1 -Color Green
#>

[CmdletBinding()]
param ([System.ConsoleColor]$Color=[System.ConsoleColor]::Cyan, [string]$Category)

$baseUrl = "https://www.asciiart.eu"
$categories = "animals", "art-and-design", "books", "buildings-and-places", "cartoons", "clothing-and-accessories", "comics", "computers", "electronics", "food-and-drinks", "holiday-and-events", "logos", "miscellaneous", "movies", "music", "mythology", "nature", "people", "plants", "religion", "space", "sports-and-outdoors", "television", "toys", "vehicles", "video-games", "weapons"

$progressPreference = 'silentlyContinue'

function Get-AsciiArt ($category) 
{
    $result = $null
    $categories = "/$category"

    do {
        $url = "$baseUrl$categories"
        # Use basic parsing, to avoid security warning in PS on Win 11.
        $r = Invoke-WebRequest $url -TimeoutSec 4 -UseBasicParsing

        $subcategories = $r.Links | where { $_.Href -like "$categories/*" }
        Write-Verbose "Found $($subcategories.Count) subcategories: $($subcategories.Href)"

        if ($subcategories.Count -eq 0) {
            # Get ASCII art element from HTML, without using unsafe methods on the Html object.
            $parts = $r.Content -split '<div class="art-card__ascii">'
            $asciiArt = $parts[1..$parts.length] | % { ($_ -split '</div>')[0] }
            Write-Verbose "Found $($asciiArt.Count) ASCII art elements."
            $result = $asciiArt | Get-Random
        } else {
            $categories = $subcategories.Href | Get-Random
            Write-Verbose "Categories set to '$categories'."
        }
    } while (($result -eq $null) -and ($subcategories.Count -gt 0))

    if ($result -ne $null) {
        $art = [System.Net.WebUtility]::HtmlDecode($result)
    } else {
        $art = ""
    }

    return $art, $url
}

if ($Category -eq "") {
    $Category = $categories | Get-Random
}

$result = Get-AsciiArt $Category

Write-Host "`n$($result[0])" -ForegroundColor $Color
Write-Host "`n  from: $($result[1])" -ForegroundColor DarkGray

