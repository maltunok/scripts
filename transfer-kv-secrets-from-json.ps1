# Authenticate to Azure
Connect-AzAccount

# Define the target Key Vault name
$targetKeyVaultName = "monster-uat-kv"

# Read the secrets from the text file
$secrets = Get-Content -Path ".\test-secrets.json"

# Loop through and import secrets to the target Key Vault
foreach ($secret in $secrets) {
    $secretName = [System.IO.Path]::GetFileNameWithoutExtension($secret)
    $secretValue = Get-Content -Path $secret
    Set-AzKeyVaultSecret -VaultName $targetKeyVaultName -Name $secretName -SecretValue $secretValue
    Write-Host "Imported secret: $secretName"
}

Write-Host "All secrets have been imported to $targetKeyVaultName."

# Disconnect from Azure (optional)
Disconnect-AzAccount
