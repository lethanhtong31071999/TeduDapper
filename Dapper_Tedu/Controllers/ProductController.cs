using System.Data.SqlClient;
using Dapper;
using Dapper_Tedu.Models;
using Microsoft.AspNetCore.Mvc;

namespace Dapper_Tedu.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly string _connectionString;
        public ProductController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        [HttpGet]
        public async Task<IEnumerable<Product>> Get()
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var result = await conn.QueryAsync<Product>(ProductSql.StoreGetProductAll, null, null, null, System.Data.CommandType.StoredProcedure);
                    return result;
                }
            }
            return null;
        }

        [HttpGet("{productId}", Name = "Get")]
        public async Task<Product> Get([FromRoute] int productId)
        {

            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@productId", productId, System.Data.DbType.Int64);
                    var result = await conn.QueryAsync<Product>(ProductSql.StoreGetProductById, parameters, null, null, System.Data.CommandType.StoredProcedure);
                    return result.SingleOrDefault();
                }
            }
            return null;
        }

        [HttpPost]
        public async Task<int> Post([FromBody] Product product)
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
                    parameters.Add("@id", dbType: System.Data.DbType.Int32, direction: System.Data.ParameterDirection.Output);
                    await conn.QueryAsync<Product>(ProductSql.StoreCreateProduct, parameters, null, null, System.Data.CommandType.StoredProcedure);
                    newId = parameters.Get<int>("@id");
                }
            }
            return newId;
        }

        [HttpPut("{productId}")]
        public async Task Put([FromRoute] int productId, [FromBody] Product product)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@productId", productId, System.Data.DbType.Int32);
                    parameters.Add("@sku", product.Sku, System.Data.DbType.String);
                    parameters.Add("@price", product.Price, System.Data.DbType.Double);
                    parameters.Add("@imageUrl", product.ImageUrl, System.Data.DbType.String);
                    parameters.Add("@isActive", product.IsActive, System.Data.DbType.Boolean);
                    await conn.QueryAsync<Product>(ProductSql.StoreUpdateProduct, parameters, null, null, System.Data.CommandType.StoredProcedure);
                }
            }
        }

        [HttpDelete("{productId}")]
        public async Task Delete([FromRoute] int productId)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    conn.Open();
                    var parameters = new DynamicParameters();
                    parameters.Add("@productId", productId);
                    await conn.QueryAsync<Product>(ProductSql.StoreDeleteProduct, parameters, null, null, System.Data.CommandType.StoredProcedure);
                }
            }
        }
    }
}
