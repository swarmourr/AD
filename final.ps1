# DEScription : Script  a muti option  
# utilisation : il est preferable de lancer le script dans envirenement windows PS ISE (X86
#  : SAFRI HAMZA 
# MAIL : SAFRIHAMZA.ENSASAFI@GMAIL.COM 0696909611
# Import Required Modules
Import-Module ActiveDirectory

echo "|------------------------------------------------------------------"
echo "|                  welcome RCAR/CNRA admin                                |"
echo "|-------------------------------------------------------------------"

Write-Host "       -------------------------------------------
       | 1 -  creer des groupe                                  
       | 2 -  OU                                
       | 3 -  ajouter un utilisateur
       | 4 -  ajouter des utilisateurs avec un  csv
       | 5 -  ajouter des groups avec un csv 
       | 6 -  grp of user with psw never expires
       | 7 -  utilisateur sans mot de passe
       | 8 -  le dernier login des utilisateur  
       | 9 -  Last Logon  inferieur a une periode donnee
       | 10 - user appetient a plusieurs groupes 
       | 11 - user sans groupe
       -------------------------------------------------"
$filepath = Read-Host -Prompt "Please enter operation number"

Write-Host  " on va effectuer l'operation $filepath"

switch($filepath){
   
 1 { add_grp }
 2 { ou }
 3 { add_user}
 4 { csv_user}
 5 { csv_grp}
 6 { never }
 7 { blank }
 8 { login }
 9 { LastLogon }
 10 { manygrp }
 11 { nogrp }

}
Function csv_user{


# Call the function above so user can use a dialog box to open the desired CSV file
$filepath = Read-Host -Prompt "Please enter the path to your CSV file"
# Import the file into the variable Users
$users = Import-Csv -Delimiter "," -Path $filepath

ForEach ($user in $users) {

    # Gather the Information
    $fname = $user."First Name"
    $lname =  $user."Last Name"
    $jtitle =  $user."Job Title"
    $officephone =  $user."Office Phone"
    $emailaddress =  $user."Email Address"
    $description = $user."Description"
    $OUpath = $user.'Organizational Unit'
    $psw = $user.'password'
    # Convert the password to a secure string
    $securePassword = ConvertTo-SecureString $psw -AsPlainText -Force
    # Create AD Users for each user in CSV file
    $name=$fname+" "+$lname
    New-ADUser -Name $name  -GivenName $fname -Surname $lname -UserPrincipalName "$fname.$lname" -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -OfficePhone $officephone -EmailAddress $emailaddress  -Description $description -Enabled $True

    # Echo output for each user
    echo "Account created for $fname $lname in $OUpath"

}

$choix = Read-Host -Prompt "you have to delete the CSV file 
                                 -1- right now 
                                 -2- manually 
enter your choice"
if($choix -eq 1){
 Remove-Item $filepath
}
if($choix -eq 2){
 Write-Host please dont forget to remove it -ForegroundColor Red
}


}
Function csv_grp{

# Call the function above so user can use a dialog box to open the desired CSV file
$grppath =  Read-Host -Prompt "Please enter the path to your CSV file"

# Convert the password to a secure string
#$securePassword = ConvertTo-SecureString "TESTpassw0rd!" -AsPlainText -Force

$grps = Import-Csv -Delimiter "," -Path $grppath
#$path =  Read-Host -Prompt "Please enter the OU exemple OU=ntnux,DC=ntnux,DC=com "

# Loop through each row and gather information
ForEach ($grp in $grps) {
    $grpname =$grp."name"
    $grpscope =$grp."Group Scope"
    $grpcat =$grp."Group Category"
    $OUpath =$grp."Organization Unite"
    echo $OUpath 
    New-ADGroup -Name $grpname -GroupScope $grpscope -GroupCategory $grpcat -Path $OUpath

     echo "group   $grpname  created in $OUpath"

    }
    }

Function add_grp{

    $grpname = $grps."Name"
    $grpscope =$grps."Group Scope"
    $grpcat = $grps."Group Category "
    $OUpath = $grps."organization unite"

    New-ADGroup -Name $grpname -GroupScope $grpscope -GroupCategory $grpcat -Path $OUpath

     echo "group   $grpname  created in $OUpath"

    }


Function add_user{

# Gather the Information
    $fname = Read-Host -Prompt "Please enter the first name "
    $lname =  Read-Host -Prompt "Please enter the last name"
    $jtitle =  Read-Host -Prompt "Please enter job title "
    $officephone =  Read-Host -Prompt "Please enter office phone number "
    $emailaddress =  Read-Host -Prompt "Please enter  mail address "
    $description = Read-Host -Prompt "Please enter the description "
    $psd = Read-Host -Prompt "Please enter the password"
    $securePassword = ConvertTo-SecureString $psd -AsPlainText -Force
    $OUpath = Read-Host -Prompt "Please enter organization unite"
     
    # Create AD Users for each user in CSV file
    New-ADUser -Name "$fname $lname" -GivenName $fname -Surname $lname -UserPrincipalName "$fname.$lname" -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -OfficePhone $officephone -EmailAddress $emailaddress  -Description $description -Enabled $True
    

    # Echo output for each user
    echo "Account created for $fname $lname in $OUpath"
    # add the user to one group

    $login= $fname+" "+$lname
    $choix = Read-Host -Prompt " do you want add $login to a group (y/n)"
    
    if($choix -eq "y"){
     
   
    $test=Get-ADUser -Filter {Name -like $login} |select DistinguishedName -ExpandProperty DistinguishedName
    $grpus = Read-Host -Prompt "Please enter the groups name for the users separeted by "," " > ss.csv 
    $grps = Get-Content  -Path ss.csv
    $grps -replace ",","`r`n" > ss.csv
    $grps1= Get-Content  -Path ss.csv
ForEach ($grp in $grps1) {
       $group=Get-ADGroup -Filter {Name -like $grp } |select DistinguishedName -ExpandProperty DistinguishedName
        if($group.count -ne 0){
       Add-ADGroupMember -Identity $group -Members $test
       Write-Host  $login is added to  $group  -ForegroundColor Green
       }
       elseif($group.count -eq 0){
    Write-Host   group not found  -ForegroundColor Red 
    exit
    }
}

Remove-Item ss.csv
   
    exit
    
    
    }
    elseif($choix -eq "n"){
    exit
    }


    }
Function add_grp{

    $grpname = Read-Host -Prompt "Please enter the group name "
    $grpscope =  Read-Host -Prompt "Please enter the Group Scope"
    $grpcat =  Read-Host -Prompt "Please enter the Group Category "
    $OUpath = Read-Host -Prompt "Please enter organization unite"

    New-ADGroup -Name $grpname -GroupScope $grpscope -GroupCategory $grpcat -Path $OUpath

     echo "group   $grpname  created in $OUpath"

    }
Function ou{

Write-Host "
       1 -  creer  OU
       2 -  creer sous OU
       3 -  afficher  les  OU
       4 -  afficher les  sous OU
       "
$filepath = Read-Host -Prompt "Please enter operation number"

Write-Host  " on va effectuer l'operation $filepath"

switch($filepath){

1 {

$ouname  = Read-Host -Prompt "Please enter ou name "

    New-ADOrganizationalUnit $ouname
}

2 {

$ouname  = Read-Host -Prompt "Please enter sub ou name "
$path  = Read-Host -Prompt "Please enter path "

    New-ADOrganizationalUnit -NAME $ouname -Path $path
}

3 {

Get-ADOrganizationalUnit -Filter * | Format-Table

}


4 {
$path  = Read-Host -Prompt "Please enter path to the ou "

    Get-ADOrganizationalUnit -Filter * -SearchBase $path| Format-Table
}

}


    }
Function never{

$file += Search-ADAccount -PasswordNeverExpires |ft DistinguishedName > text.csv
echo $file

     $h=Get-Content -Path text.csv
     $long=(Get-Content -Path text.csv).Length
     $OUpath = Read-Host -Prompt "Please enter organization unit"

 #Loop through each row and gather information
for ($i=3 ; $i -lt $long ; $i++ ) {

echo $h[$i]
Add-ADGroupMember -Identity $OUpath -Members $h[$i] 



}

    }
Function blank{

 $path= Read-Host -Prompt "Please enter path "

    Get-ADUser -Filter * -SearchBase $path | ForEach {
   $_.SamAccountName
   (new-object directoryservices.directoryentry "", ("domain\" + $_.SamAccountName), "").psbase.name -ne $null
   Write-Host ""} 
    }
Function login{
$dcs = Get-ADDomainController -Filter {Name -like "*"}
$users = Get-ADUser -Filter *
$time = 0

foreach($user in $users)
{
foreach($dc in $dcs)
{ 
$hostname = $dc.HostName
$currentUser = Get-ADUser $user.SamAccountName | Get-ADObject -Server $hostname -Properties lastLogon
if($currentUser.LastLogon -gt $time) 
{
$time = $currentUser.LastLogon
}
$dt = [DateTime]::FromFileTime($time)
Write-Host $currentUser "last logged on at:" $dt
$time = 0
}
}
}
Function LastLogon{

$time = Read-Host  -Prompt "entrez la periode " 
$time1 = (Get-Date).AddDays($time)
Write-Host -ForegroundColor GREEN " filtring users ...." 
Get-ADUser -Filter { LastLogonTimeStamp -lt $time1 } -Properties Lastlogontimestamp | ft name

}
Function manygrp{
$file += Get-ADUser -Filter * -Properties memberof | Where-Object{$_.memberof.count -gt 1 } | ft DistinguishedName > test.csv
$file1 += Get-ADUser -Filter * -Properties memberof | Where-Object{$_.memberof.count -gt 1 } | ft memberof > test1.csv


     $h=Get-Content -Path test.csv
     $long=(Get-Content -Path test.csv).Length
     #$OUpath = Read-Host -Prompt "Please enter organization unit 
     $k=$h-Replace("{","")
     $fin=$k-Replace("}","")

     $h1=Get-Content -Path test1.csv
     $long1=(Get-Content -Path test1.csv).Length
     #$OUpath = Read-Host -Prompt "Please enter organization unit 
     $k1=$h1-Replace("{","")
     $fin1=$k1-Replace("}","")
     $fin2=$fin1-Replace(", ","-")

 #Loop through each row and gather information
for ($i=3 ; $i -lt $long ; $i++ ) {
 echo "<---------user--------------------------------------->"  $fin[$i] "<--------groups-------------------------------------->"  $fin2[$i].Split("{-}")  "`r`n"
 
}

 $user= Read-Host  -Prompt "copier DistinguishedName  "
 $grp= Read-Host  -Prompt "copier membreof a garde pour l utilisateur  "

 Write-Host -ForegroundColor GREEN " deleting  user from all groups ...." 
 Get-ADUser -Identity $user -Properties memberof | ForEach-Object { $_.memberof | Remove-ADGroupMember -members $_.DistinguishedName -Confirm:$false }
 Write-Host -ForegroundColor GREEN " adding the user to $grp ...." 
 Add-ADGroupMember -Identity $grp -Members $user
}
Function nogrp{
Get-ADUser -Filter * -Properties memberof | Where-Object{$_.memberof.count -eq 0} | ft name,memberof
}