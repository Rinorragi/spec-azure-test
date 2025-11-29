using 'main.bicep'

// Required parameters
param publisherEmail = 'admin@contoso.com'
param publisherName = 'Contoso'

// Optional parameters with defaults
param environmentName = 'dev'
param baseName = 'apimfunc'
param location = 'northeurope'

param tags = {
  Environment: 'dev'
  DeployedBy: 'Bicep'
  Project: 'APIM-FunctionApp'
}
