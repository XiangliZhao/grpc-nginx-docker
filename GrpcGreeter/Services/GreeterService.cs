using System.Threading.Tasks;
using Grpc.Core;
using Microsoft.Extensions.Logging;

namespace GrpcGreeter
{
    public class GreeterService : GrpcGreeter.EchoService.EchoServiceBase
    {
        private readonly ILogger<GreeterService> _logger;
        public GreeterService(ILogger<GreeterService> logger)
        {
            _logger = logger;
        }

        public override Task<EchoResponse> Echo(EchoRequest request, ServerCallContext context)
        {
            _logger.LogInformation("client called start.");
            return Task.FromResult(new EchoResponse
            {
                Text = "Hello " + request.Text + ", I'm from .net 8"
            }) ;
        }
    }
}