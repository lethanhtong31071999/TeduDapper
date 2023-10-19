using System;
using System.Data;
using System.Data.SqlClient;
using Dapper;
using Dapper_Tedu.Models;
using Dapper_Tedu.SqlQuery;
using Microsoft.AspNetCore.Identity;

namespace Dapper_Tedu.Data
{
    public class RoleStore : IRoleStore<AppRole>
    {
        private readonly string _connectionString;

        public RoleStore(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        #region Read
        public async Task<AppRole> FindByIdAsync(string roleId, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var role = await conn.QuerySingleAsync<AppRole>(RoleStoreSql.FindRoleById, new { id = roleId });
                        if (role != null) return role;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return null;
        }

        public async Task<AppRole> FindByNameAsync(string normalizedRoleName, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var role = await conn.QuerySingleAsync<AppRole>(RoleStoreSql.FindRoleByName, new { normalizedRoleName = normalizedRoleName });
                        if (role != null) return role;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return null;
        }

        public async Task<string> GetNormalizedRoleNameAsync(AppRole role, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var normalizedRoleName = await conn.QuerySingleAsync<string>(RoleStoreSql.GetNormalizedRoleName, new { id = role.Id });
                        if (!string.IsNullOrEmpty(normalizedRoleName)) return normalizedRoleName;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return null;
        }

        public async Task<string> GetRoleNameAsync(AppRole role, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var normalizedRoleName = await conn.QuerySingleAsync<string>(RoleStoreSql.GetRoleName, new { id = role.Id });
                        if (!string.IsNullOrEmpty(normalizedRoleName)) return normalizedRoleName;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return null;
        }

        public Task<string> GetRoleIdAsync(AppRole role, CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }
        #endregion Read

        #region Create
        public async Task<IdentityResult> CreateAsync(AppRole role, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var conn = new SqlConnection(_connectionString))
            {
                if (conn.State == System.Data.ConnectionState.Closed)
                {
                    await conn.OpenAsync(cancellationToken);
                    role.Id = Guid.NewGuid();
                    var parameters = new
                    {
                        id = role.Id.ToString(),
                        name = role.Name,
                        normalizeNamed = role.NormalizedName
                    };
                    var count = await conn.ExecuteAsync(RoleStoreSql.CreateRole, parameters);
                    if (count > 0)
                    {
                        return IdentityResult.Success;
                    }
                }
            }
            return IdentityResult.Failed();
        }

        public async Task SetNormalizedRoleNameAsync(AppRole role, string normalizedName, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var parameters = new
                        {
                            id = role.Id,
                            normalizeNamed = role.NormalizedName
                        };
                        await conn.ExecuteAsync(RoleStoreSql.SetNormalizedName, parameters);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task SetRoleNameAsync(AppRole role, string roleName, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var parameters = new
                        {
                            id = role.Id,
                            name = role.Name,
                        };
                        await conn.ExecuteAsync(RoleStoreSql.SetName, parameters);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        #endregion Create

        #region Update
        public async Task<IdentityResult> UpdateAsync(AppRole role, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var parameters = new
                        {
                            id = role.Id,
                            name = role.Name,
                            normalizeNamed = role.NormalizedName
                        };
                        var count = await conn.ExecuteAsync(RoleStoreSql.UpdateRole, parameters);
                        if (count > 0)
                        {
                            return IdentityResult.Success;
                        }
                    }
                }
                return IdentityResult.Failed();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        #endregion Update

        public async Task<IdentityResult> DeleteAsync(AppRole role, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var conn = new SqlConnection(_connectionString))
                {
                    if (conn.State == System.Data.ConnectionState.Closed)
                    {
                        await conn.OpenAsync(cancellationToken);
                        var count = await conn.ExecuteAsync(RoleStoreSql.DeleteRole, new { Id = role.Id });
                        if (count > 0)
                        {
                            return IdentityResult.Success;
                        }
                    }
                }
                return IdentityResult.Failed();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }
}

