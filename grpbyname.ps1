﻿# DEScription : Script pour ajouter des utilisteurs meme groups avec un fichier csv  
# utilisation : il est preferable de lancer le script dans envirenement windows PS ISE (X86)
#file exemple : grpbyname.csv
# creer par : SAFRI HAMZA 
# MAIL : SAFRIHAMZA.ENSASAFI@GMAIL.COM
# Import Required Modules
Import-Module ActiveDirectory




# Call the function above so user can use a dialog box to open the desired CSV file
$filepath = Read-Host -Prompt "Please enter the path to your CSV file"
# Import the file into the variable Users
$grps = Import-Csv -Delimiter "," -Path $filepath
$grpus = Read-Host -Prompt "Please enter the group name for the users"

ForEach ($grp in $grps) {
    $fname =$grp."fname"
    $lname =$grp."lname"
    $name=$fname+" "+$lname
    $group=Get-ADGroup -Filter {Name -like $grpus } |select DistinguishedName -ExpandProperty DistinguishedName
    $test=Get-ADUser -Filter {Name -like $name} |select DistinguishedName -ExpandProperty DistinguishedName
    Add-ADGroupMember -Identity $group -Members $test
    Write-Host  $name is added to  $group  -ForegroundColor Green
}