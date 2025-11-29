namespace FunctionApp

open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Mvc
open Microsoft.Azure.Functions.Worker
open Microsoft.Extensions.Logging

type HelloWorld(logger: ILogger<HelloWorld>) =

    [<Function("HelloWorld")>]
    member _.Run([<HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)>] req: HttpRequest) =
        logger.LogInformation("F# HTTP trigger function processed a request.")

        let name = 
            match req.Query.TryGetValue("name") with
            | true, values when values.Count > 0 -> Some(values.[0])
            | _ -> None

        match name with
        | Some n -> OkObjectResult($"Hello, {n}!") :> IActionResult
        | None -> OkObjectResult("Hello, World!") :> IActionResult
