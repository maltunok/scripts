# Authenticate to Azure
Connect-AzAccount

# Define the source and target Key Vault names
$sourceKeyVaultName = "monster-test-kv"
$targetKeyVaultName = "monster-uat-kv"

# Get all secrets from the source Key Vault
$secrets = Get-AzKeyVaultSecret -VaultName $sourceKeyVaultName

# Loop through and transfer secrets to the target Key Vault
foreach ($secret in $secrets) {
    $secretName = $secret.Name
    $secretValue = (Get-AzKeyVaultSecret -VaultName $sourceKeyVaultName -Name $secretName).SecretValueText
    Set-AzKeyVaultSecret -VaultName $targetKeyVaultName -Name $secretName -SecretValue $secretValue
    Write-Host "Transferred secret: $secretName"
}

Write-Host "All secrets have been transferred to $targetKeyVaultName."

# Disconnect from Azure (optional)
Disconnect-AzAccount
