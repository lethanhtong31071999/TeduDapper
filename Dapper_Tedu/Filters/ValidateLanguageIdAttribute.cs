using System;
using System.Globalization;
using Dapper_Tedu.Controllers;
using Dapper_Tedu.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Localization;

namespace Dapper_Tedu.Filters
{
    public class ValidateLanguageIdAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var languageId = context.HttpContext.GetRouteValue("culture")?.ToString()?.Trim();
            if (!String.IsNullOrEmpty(languageId) && CultureInfo.CurrentCulture.Name == languageId) return;
            var controller = context.Controller as ProductController;
            if (controller != null)
            {
                context.Result = new BadRequestObjectResult(new
                {
                    message = controller.localizer["InvalidLanguage"].ToString()
                });
            }
        }
    }
}