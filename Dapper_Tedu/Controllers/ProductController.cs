using System.Data.SqlClient;
using System.Globalization;
using Dapper;
using Dapper_Tedu.Dtos;
using Dapper_Tedu.Extensions;
using Dapper_Tedu.Filters;
using Dapper_Tedu.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;

namespace Dapper_Tedu.Controllers
{
    [Route("api/{culture}/[controller]")]
    [ApiController]
    [MiddlewareFilter(typeof(LocalizationPipeline))]
    public class ProductController : ControllerBase
    {
        private readonly string _connectionString;
        private readonly IStringLocalizer<Product> _productLocalizer;
        public readonly IStringLocalizer<SharedResouce> localizer;
        private readonly string _languageId;
        public ProductController(IConfiguration configuration, IStringLocalizer<Product> productLocalizer, IStringLocalizer<SharedResouce> localizer)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
            this.localizer = localizer;
            _productLocalizer = productLocalizer;
            _languageId = CultureInfo.CurrentCulture.Name;
        }

        [HttpGet]
        [Route("Get")]
        public async Task<IActionResult> Get()
        {
            var culture = CultureInfo.CurrentCulture.Name;
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@languageId", _languageId, dbType: System.Data.DbType.String);
                    var result = await conn.QueryAsync<Product>(ProductSql.StoreGetAll, parameters, null, null, System.Data.CommandType.StoredProcedure);
                    return Ok(result);
                }
            }
            return BadRequest();
        }

        [HttpGet("{id}", Name = "Get")]
        public async Task<IActionResult> Get([FromRoute] int id)
        {

            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@id", id, System.Data.DbType.Int64);
                    parameters.Add("@languageId", _languageId, System.Data.DbType.String);
                    var result = await conn.QueryAsync<Product>(ProductSql.StoreGetById, parameters, null, null, System.Data.CommandType.StoredProcedure);
                    return Ok(result.SingleOrDefault());
                }
            }
            return BadRequest();
        }

        [HttpGet("paging", Name = "GetPagination")]
        public async Task<PagedResult<Product>> GetPagination([FromQuery] string? searchTerm, [FromQuery] int pageIndex, [FromQuery] int PageSize, [FromQuery] int categoryId)
        {

            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@searchTerm", searchTerm, System.Data.DbType.String);
                    parameters.Add("@pageIndex", pageIndex, System.Data.DbType.Int32);
                    parameters.Add("@PageSize", PageSize, System.Data.DbType.Int32);
                    parameters.Add("@categoryId", categoryId, System.Data.DbType.Int32);
                    parameters.Add("@languageId", _languageId, System.Data.DbType.String);
                    parameters.Add("@totalRow", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);
                    var result = await conn.QueryAsync<Product>(ProductSql.StoreGetByPagination, parameters, null, null, System.Data.CommandType.StoredProcedure);
                    var totalRow = parameters.Get<int>("@totalRow");

                    return new PagedResult<Product>()
                    {
                        PageIndex = pageIndex,
                        PageSize = PageSize,
                        Result = result,
                        TotalRow = totalRow
                    };
                }
            }
            return new PagedResult<Product>();
        }

        [HttpPost]
        [ValidateModel]
        [ValidateLanguageIdAttribute]
        public async Task<IActionResult> Post([FromBody] Product product)
        {
            var newId = 0;
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@sku", product.Sku, System.Data.DbType.String);
                    parameters.Add("@price", product.Price, System.Data.DbType.Double);
                    parameters.Add("@imageUrl", product.ImageUrl, System.Data.DbType.String);
                    parameters.Add("@isActive", product.IsActive, System.Data.DbType.Boolean);
                    parameters.Add("@languageId", _languageId, System.Data.DbType.String);
                    parameters.Add("@content", product.Content, System.Data.DbType.String);
                    parameters.Add("@name", product.Name, System.Data.DbType.String);
                    parameters.Add("@description", product.Description, System.Data.DbType.String);
                    parameters.Add("@seoDescription", product.SeoDescription, System.Data.DbType.String);
                    parameters.Add("@seoAlias", product.SeoAlias, System.Data.DbType.String);
                    parameters.Add("@seoTitle", product.SeoTitle, System.Data.DbType.String);
                    parameters.Add("@seoKeyword", product.SeoKeyword, System.Data.DbType.String);
                    parameters.Add("@id", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);
                    await conn.QueryAsync<Product>(ProductSql.StoreCreate, parameters, null, null, System.Data.CommandType.StoredProcedure);
                    newId = parameters.Get<int>("@id");
                }
            }
            return Ok(newId);
        }

        [HttpPut("{id}")]
        [ValidateModel]
        [ValidateLanguageIdAttribute]
        public async Task<IActionResult> Put([FromRoute] int id, [FromBody] Product product)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@id", id, System.Data.DbType.Int32);
                    parameters.Add("@sku", product.Sku, System.Data.DbType.String);
                    parameters.Add("@price", product.Price, System.Data.DbType.Double);
                    parameters.Add("@imageUrl", product.ImageUrl, System.Data.DbType.String);
                    parameters.Add("@languageId", _languageId, System.Data.DbType.String);
                    parameters.Add("@isActive", product.IsActive, System.Data.DbType.Boolean);
                    parameters.Add("@content", product.Content, System.Data.DbType.String);
                    parameters.Add("@name", product.Name, System.Data.DbType.String);
                    parameters.Add("@description", product.Description, System.Data.DbType.String);
                    parameters.Add("@seoDescription", product.SeoDescription, System.Data.DbType.String);
                    parameters.Add("@seoAlias", product.SeoAlias, System.Data.DbType.String);
                    parameters.Add("@seoTitle", product.SeoTitle, System.Data.DbType.String);
                    parameters.Add("@seoKeyword", product.SeoKeyword, System.Data.DbType.String);
                    await conn.QueryAsync<Product>(ProductSql.StoreUpdate, parameters, null, null, System.Data.CommandType.StoredProcedure);
                }
            }
            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@productId", id);
                    await conn.QueryAsync<Product>(ProductSql.StoreDelete, parameters, null, null, System.Data.CommandType.StoredProcedure);
                }
            }
            return NoContent();
        }
    }
}
