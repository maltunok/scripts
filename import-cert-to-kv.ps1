$pfxFilePath = "E:\xxxtechnology-wildcard.pfx"
$pwd = "password"
$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12

$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection  
$collection.Import($pfxFilePath, $pwd, $flag)

$clearBytes = $collection.Export($pkcs12ContentType)
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes)
$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force
$secretContentType = 'application/x-pkcs12'

# Replace the following <vault-name> and <key-name>.
Set-AzKeyVaultSecret -VaultName xxx -Name xxxtechnology-wildcard -SecretValue $secret -ContentType $secretContentType