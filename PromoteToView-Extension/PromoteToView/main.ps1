[CmdletBinding()] 
param() 
 
Trace-VstsEnteringInvocation $MyInvocation 

# Debugging
# [CmdletBinding()]

# param (
#     [Parameter(Mandatory = $true)][string]$feedName,
#     [Parameter(Mandatory = $true)][string]$feedScoped,
#     [Parameter(Mandatory = $true)][string]$view,
#     [Parameter(Mandatory = $true)][string]$nugetPackageMappingFilePath
# )

try { 
    # Get inputs. 
    $feedName                    = Get-VstsInput -Name 'feedName' -Require 
    $feedScoped                  = Get-VstsInput -Name 'feedScoped' -Require 
    $view                        = Get-VstsInput -Name 'view' -Require 
    $nugetPackageMappingFilePath = Get-VstsInput -Name 'nugetPackageMappingFilePath' -Require 
    
    #Debugging
    #.\main.ps1 -feedName "TestPromote" -feedScoped "Organization" -view "Release" -nugetPackageMappingFilePath "D:\Extensions\PromoteToView-Extension\NugetPackageMapping.psd1"
    
    # Call the PromoteNuGetPackages function with the inputs
    .\PromoteNuGetPackages.ps1 -feedName $feedName -feedScoped $feedScoped -view $view -nugetPackageMappingFilePath $nugetPackageMappingFilePath
} finally { 
    Trace-VstsLeavingInvocation $MyInvocation 
}