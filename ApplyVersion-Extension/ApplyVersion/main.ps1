[CmdletBinding()] 
param() 
 
Trace-VstsEnteringInvocation $MyInvocation 

try { 
    # Get inputs. 
    $SourceFolder   = Get-VstsInput -Name 'SourceFolder' -Require 
    $Company        = Get-VstsInput -Name 'Company' -Require 
    $Product        = Get-VstsInput -Name 'Product' -Require 
    $Copyright      = Get-VstsInput -Name 'Copyright' -Require 
    
    # Call the ApplyVersion function with the inputs
    .\ApplyVersion.ps1 -SourceFolder $SourceFolder -Company $Company -Product $Product -Copyright $Copyright

} finally { 
    Trace-VstsLeavingInvocation $MyInvocation 
}