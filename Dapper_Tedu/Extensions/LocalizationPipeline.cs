using System;
namespace Dapper_Tedu.Extensions
{
    public class LocalizationPipeline
    {
        public void Configure(IApplicationBuilder app, RequestLocalizationOptions requestLocalizationOptions)
        {
            app.UseRequestLocalization(options: requestLocalizationOptions);
        }
    }
}

