using System;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Localization.Routing;
using System.Globalization;

namespace Dapper_Tedu.Dtos
{
    public static class LocalizationOption
    {
        public static RequestLocalizationOptions Init()
        {
            var supportedCultures = new[] { new CultureInfo("en-US"), new CultureInfo("vi-VN") };
            var options = new RequestLocalizationOptions() { };
            options.DefaultRequestCulture = new RequestCulture(culture: supportedCultures[0].ToString(), uiCulture: supportedCultures[0].ToString());
            options.SupportedCultures = supportedCultures;
            options.SupportedUICultures = supportedCultures;
            options.RequestCultureProviders = new[] { new RouteDataRequestCultureProvider() { Options = options } };
            return options;
        }
    }
}

