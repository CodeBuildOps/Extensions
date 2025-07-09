[CmdletBinding()] 
param() 
 
Trace-VstsEnteringInvocation $MyInvocation 

try { 
    # Get inputs. 
    $feedName                    = Get-VstsInput -Name 'feedName' -Require 
    $feedScoped                  = Get-VstsInput -Name 'feedScoped' -Require 
    $view                        = Get-VstsInput -Name 'view' -Require 
    $nugetPackageMappingFilePath = Get-VstsInput -Name 'nugetPackageMappingFilePath' -Require 
    
    # Call the PromoteNuGetPackages function with the inputs
    .\PromoteNuGetPackages.ps1 -feedName $feedName -feedScoped $feedScoped -view $view -nugetPackageMappingFilePath $nugetPackageMappingFilePath
} finally { 
    Trace-VstsLeavingInvocation $MyInvocation 
}