[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFolder,

    [Parameter(Mandatory = $true)]
    [string]$Company,

    [Parameter(Mandatory = $true)]
    [string]$Copyright,

    [Parameter(Mandatory = $true)]
    [string]$Product
)

$ErrorActionPreference = "Stop"

function Update-Or-AddLine {
    param (
        [string]$FileContent,
        [string]$AttributeName,
        [string]$NewValue
    )

    try {
        $escapedAttr = [regex]::Escape($AttributeName)
        $pattern = "\[assembly:\s*$escapedAttr\(\"".*?\""\)\]"
        $replacement = "[assembly: $AttributeName(`"$NewValue`")]"

        if ($FileContent -match $pattern) {
            return [regex]::Replace($FileContent, $pattern, $replacement)
        } else {
            return $FileContent + "`r`n$replacement"
        }
    } catch {
        Write-Error "Failed to update or add line for attribute: $AttributeName. Error: $_"
        throw
    }
}

try {
    # Locate AssemblyInfo.cs
    $assemblyFile = Get-ChildItem -Path $SourceFolder -Filter "AssemblyInfo.cs" -Recurse -ErrorAction Stop | Select-Object -First 1

    if (-not $assemblyFile) {
        throw "AssemblyInfo.cs not found under folder: $SourceFolder"
    }

    Write-Host "Company name: $Company"
    Write-Host "Copyright year: $Copyright"
    Write-Host "Product name: $Product"
    Write-Host "Product version: $env:BUILD_BUILDNUMBER"
    Write-Host "Updating file: $($assemblyFile.FullName)"


    # Read file content
    $content = Get-Content -Path $assemblyFile.FullName -Raw -ErrorAction Stop

    # Update fields
    $content = Update-Or-AddLine -FileContent $content -AttributeName "AssemblyCompany" -NewValue $Company
    $content = Update-Or-AddLine -FileContent $content -AttributeName "AssemblyCopyright" -NewValue $Copyright
    $content = Update-Or-AddLine -FileContent $content -AttributeName "AssemblyProduct" -NewValue $Product
    $content = Update-Or-AddLine -FileContent $content -AttributeName "AssemblyFileVersion" -NewValue $env:BUILD_BUILDNUMBER

    # Write back to file
    Set-Content -Path $assemblyFile.FullName -Value $content -Encoding UTF8 -ErrorAction Stop

    Write-Host "AssemblyInfo.cs updated successfully."

} catch {
    Write-Error "An error occurred during script execution: $_"
    exit 1
}