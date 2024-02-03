# Documentation and associated blog post : https://akril.net/recuperer-les-images-de-windows-spotlight-dans-windows-10-en-powershell/
# No longer supported

$me = $env:username
$source = "C:\Users\$me\AppData\Local\Packages\
Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
$target_pc = "C:\Users\$me\Pictures\Windows_Spotlight\PC"
$target_phone = "C:\Users\$me\Pictures\Windows_Spotlight\Phone"

Write-Host "[DEBUG] - Starting importing Windows Spotlight wallpapers..."

# Testing if the folder Windows Spotlight Exists
if ((Test-Path $target_pc) -eq $false)
{
 # Creating the folder if not exist
 Write-Host "[ERROR] - Check folder creation"
 Break
}

# Get all the images in the hidden folder of Windows Spotlight
$images = Get-ChildItem $source

# For each image
foreach ($wallpaper in $images)
{
 # If the file has NOT been already imported by previous script execution
 # We will : import/copy it, then rename it by adding the jpg extension
 if ((Test-Path $target_pc\$wallpaper.jpg) -eq $false)
 {
 # Copy
 Copy-Item $source\$wallpaper -Destination $target_pc
 # Rename
 Rename-Item $target_pc\$wallpaper -NewName $target_pc\$wallpaper.jpg
 # Log
 Write-Host "$wallpaper copied and added JPG extension into $target_pc folder !"
 }

 else
 {
 Write-Host "$wallpaper has been already imported !"
 }

 # Clearing the images that are probably not true image that can be used as wallpapers
 # In fact, removing all the files under 100 000 bytes
 if ((Get-Item $target_pc\$wallpaper.jpg).Length -lt 100000)
 {
 Write-Host "$wallpaper removed (probably not wallpapers)"
 Remove-Item $target_pc\$wallpaper.jpg
 }

 # At this step, we have only true images that can be used for PC but also for Phone !
 # We will get the Height / Width details of each picture
 # Only if the image exists
 if ((Test-Path $target_pc\$wallpaper.jpg) -eq $true)
 {
 $image_details = Get-Image $target_pc\$wallpaper.jpg

 # If, Width is larger that Height therefore is landscape / paysage
 if ($image_details.Height -le $image_details.Width)
 {
 Write-Host "$wallpaper is a Landscape - We keep it in the current folder"
 }

 # Otherwise height is Larger than Width - It's for Phone
 else
 {
 Write-Host "$wallpaper is a Portrait - Moved for Phone usage"
 # File has been already move in previous import - so its removed
 if ((Test-Path $target_phone\$wallpaper.jpg) -eq $true)
 {
 Remove-Item $target_pc\$wallpaper.jpg
 }
 # New file, we move it in phone folder
 else
 {
 Move-Item -Path $target_pc\$wallpaper.jpg -Destination $target_phone
 }
 }
 }
}
# Ending script execution
Write-Host "Import of Windows Spotlight Wallpapers Done !"
Write-Host ("Number of Available Elements for PC Wallpapers : " + (Get-ChildItem $target_pc).Count)
Write-Host ("Number of Available Elements for Phone Wallpapers : " + (Get-ChildItem $target_phone).Count)
