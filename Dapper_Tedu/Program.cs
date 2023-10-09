using System.Net;
using Microsoft.AspNetCore.Diagnostics;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using Dapper_Tedu.Dtos;
using Dapper_Tedu.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers().AddNewtonsoftJson(options =>
{
    options.SerializerSettings.ContractResolver = new DefaultContractResolver();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSingleton(LocalizationOption.Init());
builder.Services.AddLocalization(options =>
{
    options.ResourcesPath = "Resources";
});
builder.Services.AddMvc()
    .AddDataAnnotationsLocalization(options =>
    {
        options.DataAnnotationLocalizerProvider = (type, factory) =>
                factory.Create(typeof(SharedResouce));
    });
var app = builder.Build();

// Pipeline
app.UseExceptionHandler(options =>
{
    options.Run(async (context) =>
    {
        context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
        var ex = context.Features.Get<IExceptionHandlerFeature>()?.Error;
        if (ex == null) return;
        var error = new
        {
            message = ex.Message
        };
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Credentials", new[] { "true" });
        context.Response.Headers.Add("Access-Control-Allow-Origin", new[] { builder.Configuration["AllowedHosts"] });
        var jsonRes = JsonConvert.SerializeObject(error);
        await context.Response.WriteAsync(jsonRes);
    });
});
app.UseSwagger();
app.UseSwaggerUI();
app.UseHsts();
app.MapControllers();
app.UseRouting();
app.UseHttpsRedirection();
app.UseAuthorization();
app.UseAuthentication();
app.Run();

