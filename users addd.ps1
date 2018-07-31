# Import Required Modules
Import-Module ActiveDirectory

# Call the function above so user can use a dialog box to open the desired CSV file
$filepath = Read-Host -Prompt "Please enter the path to your CSV file"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString "TESTpassw0rd!" -AsPlainText -Force

# Import the file into the variable Users
$users = Import-Csv -Delimiter "," -Path $filepath

# Loop through each row and gather information
ForEach ($user in $users) {

    # Gather the Information
    $fname = $user."First Name"
    $lname =  $user."Last Name"
    $jtitle =  $user."Job Title"
    $officephone =  $user."Office Phone"
    $emailaddress =  $user."Email Address"
    $description = $user."Description"
    $OUpath = $user.'Organizational Unit'
    

    echo " hhhhhhh Account in $OUpath"
     
    # Create AD Users for each user in CSV file
    New-ADUser -Name "$fname $lname" -GivenName $fname -Surname $lname -UserPrincipalName "$fname.$lname" -Path $OUpath -AccountPassword $securePassword -ChangePasswordAtLogon $True -OfficePhone $officephone -EmailAddress $emailaddress  -Description $description -Enabled $True

    # Echo output for each user
    echo "Account created for $fname $lname in $OUpath"
}
