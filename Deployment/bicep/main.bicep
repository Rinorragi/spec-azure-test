// ============================================================================
// Main Bicep file for deploying APIM with Function App backend
// ============================================================================

metadata description = 'Deploys Azure API Management with a Function App backend'

targetScope = 'resourceGroup'

// ============================================================================
// Parameters
// ============================================================================

@description('The Azure region for all resources')
param location string = resourceGroup().location

@description('Environment name used for resource naming')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('Base name for all resources')
param baseName string = 'apimfunc'

@description('Publisher email for APIM')
param publisherEmail string

@description('Publisher name for APIM')
param publisherName string

@description('Tags to apply to all resources')
param tags object = {
  Environment: environmentName
  DeployedBy: 'Bicep'
}

// ============================================================================
// Variables
// ============================================================================

var resourceSuffix = '${baseName}-${environmentName}'
var storageAccountName = replace('st${baseName}${environmentName}', '-', '')
var appServicePlanName = 'asp-${resourceSuffix}'
var functionAppName = 'func-${resourceSuffix}'
var apimName = 'apim-${resourceSuffix}'

// ============================================================================
// Storage Account (required for Function App)
// ============================================================================

module storageAccount 'br/public:avm/res/storage/storage-account:0.14.3' = {
  name: 'storageAccountDeployment'
  params: {
    name: storageAccountName
    location: location
    tags: tags
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// ============================================================================
// App Service Plan (Consumption plan for Function App)
// ============================================================================

module appServicePlan 'br/public:avm/res/web/serverfarm:0.3.0' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName
    location: location
    tags: tags
    kind: 'FunctionApp'
    skuName: 'Y1'
    skuCapacity: 0
  }
}

// ============================================================================
// Function App
// ============================================================================

module functionApp 'br/public:avm/res/web/site:0.12.0' = {
  name: 'functionAppDeployment'
  params: {
    name: functionAppName
    location: location
    tags: tags
    kind: 'functionapp'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      use32BitWorkerProcess: false
    }
    storageAccountResourceId: storageAccount.outputs.resourceId
    storageAccountUseIdentityAuthentication: true

    basicPublishingCredentialsPolicies: [
      {
        name: 'ftp'
        allow: false
      }
      {
        name: 'scm'
        allow: false
      }
    ]
  }
}

// ============================================================================
// API Management (Developer SKU)
// ============================================================================

module apiManagement 'br/public:avm/res/api-management/service:0.9.0' = {
  name: 'apiManagementDeployment'
  params: {
    name: apimName
    location: location
    tags: tags
    publisherEmail: publisherEmail
    publisherName: publisherName
    sku: 'Developer'
    skuCapacity: 1
    enableDeveloperPortal: true
    managedIdentities: {
      systemAssigned: true
    }
    backends: [
      {
        name: 'functionapp-backend'
        description: 'Function App Backend'
        url: 'https://${functionAppName}.azurewebsites.net/api'
        protocol: 'http'
        tls: {
          validateCertificateChain: true
          validateCertificateName: true
        }
      }
    ]
    apis: [
      {
        name: 'functions-api'
        displayName: 'Functions API'
        description: 'API for Azure Functions'
        path: 'functions'
        protocols: [
          'https'
        ]
        serviceUrl: 'https://${functionAppName}.azurewebsites.net/api'
        subscriptionRequired: false
      }
    ]
  }
  dependsOn: [
    functionApp
  ]
}

// ============================================================================
// Outputs
// ============================================================================

@description('The name of the deployed Function App')
output functionAppName string = functionApp.outputs.name

@description('The default hostname of the Function App')
output functionAppHostName string = functionApp.outputs.defaultHostname

@description('The name of the deployed API Management service')
output apimName string = apiManagement.outputs.name

@description('The resource ID of the API Management service')
output apimResourceId string = apiManagement.outputs.resourceId

@description('The name of the Storage Account')
output storageAccountName string = storageAccount.outputs.name
