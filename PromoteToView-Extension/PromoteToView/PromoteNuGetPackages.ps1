[CmdletBinding()]

param (
    [Parameter(Mandatory = $true)][string]$feedName,
    [Parameter(Mandatory = $true)][string]$feedScoped,
    [Parameter(Mandatory = $true)][string]$view,
    [Parameter(Mandatory = $true)][string]$nugetPackageMappingFilePath
)

$ErrorActionPreference = "Stop"

function PromoteNuGetPackageToFeed {
    param (
        [string]$packageName,
        [string]$packageVersion
    )
    
    if ($feedScoped.ToUpper() -eq "PROJECT") {
        $devBaseUrl = "$env:devAzureOrganizationUrl/$env:SYSTEM_TEAMPROJECT"
    }
    else {
        $devBaseUrl = "$env:devAzureOrganizationUrl"
    }

    $uri = "$($devBaseUrl)/_apis/packaging/feeds/${feedName}/nuget/packages/${packageName}/versions/${packageVersion}?api-version=7.1"
    Write-Host "Constructed URI: $uri"

    $headers = @{
        "Content-Type" = "application/json"
        Authorization  = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:SYSTEM_ACCESSTOKEN"))
    }
    $body = '{ "views": { "op":"add", "path":"/views/-", "value":"' + $view + '" } }'

    try {
        Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body
        Write-Host "Package '$packageName' version '$packageVersion' promoted to '$view' view."
    }
    catch {
        Write-Error "Failed to promote the package in PromoteNuGetPackageToFeed() : $_"
    }
}

############################### Execution starts here ###############################

if (Test-Path -Path $nugetPackageMappingFilePath) {
    $nugetPackageVersionMapping = Import-PowerShellDataFile -Path $nugetPackageMappingFilePath
}
else {
    Write-Error "NugetPackageMapping.psd1 file not found in the script directory: $nugetPackageMappingFilePath"
}

foreach ($package in $nugetPackageVersionMapping.GetEnumerator()) {
    $packageName = $package.Key
    $packageVersion = $package.Value

    PromoteNuGetPackageToFeed -packageName $packageName -packageVersion $packageVersion
}
