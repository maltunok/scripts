

$loginId = "mustafa.altunok@devbase.com.tr" 
$subscriptionId = "subscriptionId"
$resourceGroupName = "resourceGroupName"
$applicationGatewayName  = "application-gateway-name"

    
###########################################################
    
Connect-AzAccount
Set-AzContext -Subscription $subscriptionId

# Stop the Application Gateway
Stop-AzApplicationGateway -ResourceGroupName $resourceGroupName -Name $applicationGatewayName

# Start the Application Gateway
Start-AzApplicationGateway -ResourceGroupName $resourceGroupName -Name $applicationGatewayName

Write-Host "Done"


# az cli
# az network application-gateway stop -n SecuritasWaf -g RG-Securitas-Infra
# az network application-gateway start -n SecuritasWaf -g RG-Securitas-Infra
# az network application-gateway list -o table
