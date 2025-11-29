namespace FunctionApp

open Microsoft.Azure.Functions.Worker
open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.Hosting

module Program =

    [<EntryPoint>]
    let main args =
        let host =
            HostBuilder()
                .ConfigureFunctionsWebApplication()
                .ConfigureServices(fun services ->
                    services.AddApplicationInsightsTelemetryWorkerService() |> ignore
                    services.ConfigureFunctionsApplicationInsights() |> ignore
                )
                .Build()

        host.Run()
        0
