[CmdletBinding()]
param (
    [String]$sourceDirectory,
    [String]$assemblyVersion,
    [String]$assemblyFileVersion,
    [String]$assemblyInformationalVersion
)

Write-Host "[Debug] Update all AssemblyInfo files in this folder: $sourceDirectory"
Write-Host "[Debug] AssemblyVersion will be updated with: $assemblyVersion"
Write-Host "[Debug] AssemblyFileVersion will be updated with: $assemblyFileVersion"
Write-Host "[Debug] AssemblyInformationalVersion will be updated with: $assemblyInformationalVersion"

(Get-ChildItem -Path $sourceDirectory -Filter AssemblyInfo.cs -Recurse) |
    ForEach-Object {
        Write-Host "[Debug] Updating file name: " $_.FullName
        (Get-Content $_.FullName) |
            ForEach-Object {

              $content = [regex]::Replace($_, "AssemblyVersion.+$", {
                     if ($assemblyVersion)
                     {  
                        Write-Host "[Debug] Replace AssemblyVersion with " $assemblyVersion
                        "AssemblyVersion(`"$assemblyVersion`")]"
                     }
                     else 
                     {
                        Write-Host "[Debug] Do not replace AssemblyVersion"
                       $args[0]
                     }
                    })
                $content = [regex]::Replace($content, 'AssemblyFileVersion.+$', {
                     if ($assemblyFileVersion)
                     {  
                        Write-Host "[Debug] Replace AssemblyFileVersion with " $assemblyFileVersion
                        "AssemblyFileVersion(`"$assemblyFileVersion`")]"
                     }
                     else 
                     {
                        Write-Host "[Debug] Do not replace AssemblyVersion"
                       $args[0]
                     }
                    })
                $content = [regex]::Replace($content, 'AssemblyInformationalVersion.+$', {
                     if ($assemblyInformationalVersion)
                     {  
                        Write-Host "[Debug] Replace AssemblyInformationalVersion with " $assemblyInformationalVersion
                        "AssemblyInformationalVersion(`"$assemblyInformationalVersion`")]"
                     }
                     else 
                     {
                        Write-Host "[Debug] Do not replace AssemblyInformationalVersion"
                       $args[0]
                     }
                    })

            $content
            } |
            Out-File $_.FullName
    }