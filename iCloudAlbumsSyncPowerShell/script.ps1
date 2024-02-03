cls
# Variables
$PathToAlbumsandFavorites = "C:\Users\thgibard\Desktop\iCloud\Photos iCloud Lot 1 sur 4\Albums and Favorites"
$PathAllPhotos = "C:\Users\thgibard\Desktop\iCloud\Photos iCloud Lot 1 sur 4\Photos"

# Creation des Albums / Dossiers (sous Windows)
Write-Host "[INFO] - Creation des dossiers dans Windows pour chaque Album..." -ForegroundColor Yellow
(Get-ChildItem -Path $PathToAlbumsandFavorites).Name | ForEach-Object { ($_).ToString().Replace(".csv","") | ForEach-Object { New-Item $($PathToAlbumsandFavorites + "\" + $_) -ItemType Directory -Force } }

# Récupération des infos de tous les fichiers CSV
$CSVFiles = Get-ChildItem -Path $PathToAlbumsandFavorites -Name "*.csv"

# Pour chaque fichier CSV
foreach ($item in $CSVFiles)
{
    Write-Host "[INFO] - Album en cours : " $item -ForegroundColor Red
    $Images = Import-Csv $item

    # Pour chaque image dans l'Album en cours
    foreach ($img in $Images.Images)
    {
        # Si l'image appartient à l'Album - On la déplace dans le dossier
        if (($Images.Images -contains $img) -eq "True")
        {
            Write-Host $("[MOVE] - Déplacement de : " + $($img) + " vers le dossier : " + ($item.ToString().Replace(".csv",""))) -ForegroundColor Green
            Move-Item -Path $($PathAllPhotos + "\" + $img) -Destination $($PathToAlbumsandFavorites + "\" + ($item.ToString().Replace(".csv","")))
            #Break # Debug
        }
    }
}
