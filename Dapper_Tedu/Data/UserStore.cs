using System;
using System.Data;
using System.Data.SqlClient;
using Dapper;
using Dapper_Tedu.Models;
using Dapper_Tedu.SqlQuery;
using Microsoft.AspNetCore.Identity;

namespace Dapper_Tedu.Data
{
    public class UserStore : IUserStore<AppUser>, IUserEmailStore<AppUser>, IUserPhoneNumberStore<AppUser>,
          IUserTwoFactorStore<AppUser>, IUserPasswordStore<AppUser>, IUserRoleStore<AppUser>
    {
        private readonly string _connectionString;
        public UserStore(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        #region Create
        public async Task<IdentityResult> CreateAsync(AppUser user, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var connection = new SqlConnection(_connectionString))
                {
                    await connection.OpenAsync(cancellationToken);
                    user.Id = Guid.NewGuid();
                    var parameters = new
                    {
                        id = user.Id,
                        userName = user.UserName,
                        normalizedUserName = user.NormalizedUserName,
                        email = user.Email,
                        normalizedEmail = user.NormalizedEmail,
                        emailConfirmed = user.EmailConfirmed ? 1 : 0,
                        passwordHash = user.PasswordHash,
                        phoneNumber = user.PhoneNumber,
                        phoneNumberConfirmed = user.PhoneNumberConfirmed ? 1 : 0,
                        twoFactorEnabled = user.TwoFactorEnabled ? 1 : 0
                    };
                    var count = await connection.ExecuteAsync(UserStoreSql.CreateUser);
                    if (count > 0) return IdentityResult.Success;
                }

                return IdentityResult.Success;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task AddToRoleAsync(AppUser user, string roleName, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var connection = new SqlConnection(_connectionString))
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        await connection.OpenAsync(cancellationToken);
                        var normalizedName = roleName.ToUpper();
                        // If not exist roleId -> Create the role
                        var roleId = await connection.ExecuteScalarAsync<Guid?>(UserStoreSql.GetRoleIdByNormalizedName, new { normalizedName });
                        if (!roleId.HasValue)
                        {
                            roleId = Guid.NewGuid();
                            await connection.ExecuteAsync(RoleStoreSql.CreateRole, new
                            {
                                id = roleId.ToString(),
                                name = roleName,
                                normalizeNamed = normalizedName,
                            });
                        }

                        // Add Role for User
                        await connection.ExecuteAsync(UserStoreSql.AddRoleForUser, new
                        {
                            userId = user.Id,
                            roleId
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        #endregion Create

        #region Read
        public async Task<AppUser> FindByIdAsync(string userId, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync(cancellationToken);
                return await connection.QuerySingleOrDefaultAsync<AppUser>($@"SELECT * FROM [AspNetUsers]
                    WHERE [Id] = @{nameof(userId)}", new { userId });
            }
        }

        public async Task<AppUser> FindByNameAsync(string normalizedUserName, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync(cancellationToken);
                return await connection.QuerySingleOrDefaultAsync<AppUser>($@"SELECT * FROM [AspNetUsers]
                    WHERE [NormalizedUserName] = @{nameof(normalizedUserName)}", new { normalizedUserName });
            }
        }

        public Task<string> GetNormalizedUserNameAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.NormalizedUserName);
        }

        public Task<string> GetUserIdAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Id.ToString());
        }

        public Task<string> GetUserNameAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.UserName);
        }

        public Task<string> GetEmailAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.Email);
        }

        public Task<bool> GetEmailConfirmedAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.EmailConfirmed);
        }

        public async Task<AppUser> FindByEmailAsync(string normalizedEmail, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync(cancellationToken);
                return await connection.QuerySingleOrDefaultAsync<AppUser>($@"SELECT * FROM [AspNetUsers]
                    WHERE [NormalizedEmail] = @{nameof(normalizedEmail)}", new { normalizedEmail });
            }
        }

        public Task<string> GetNormalizedEmailAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.NormalizedEmail);
        }

        public Task<string> GetPhoneNumberAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.PhoneNumber);
        }

        public Task<bool> GetPhoneNumberConfirmedAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.PhoneNumberConfirmed);
        }


        public Task<bool> GetTwoFactorEnabledAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.TwoFactorEnabled);
        }


        public Task<string> GetPasswordHashAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.PasswordHash);
        }

        public async Task<IList<string>> GetRolesAsync(AppUser user, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync(cancellationToken);
                var queryResults = await connection.QueryAsync<string>("SELECT r.[Name] FROM [AspNetRoles] r INNER JOIN [AspNetUserRoles] ur ON ur.[RoleId] = r.Id " +
                    "WHERE ur.UserId = @userId", new { userId = user.Id });

                return queryResults.ToList();
            }
        }

        public async Task<bool> IsInRoleAsync(AppUser user, string roleName, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var connection = new SqlConnection(_connectionString))
            {
                var roleId = await connection.ExecuteScalarAsync<string>("SELECT [Id] FROM [AspNetRoles] WHERE [NormalizedName] = @normalizedName", new { normalizedName = roleName.ToUpper() });
                if (string.IsNullOrEmpty(roleId)) return false;
                var matchingRoles = await connection.ExecuteScalarAsync<int>($"SELECT COUNT(*) FROM [AspNetUserRoles] WHERE [UserId] = @userId AND [RoleId] = @{nameof(roleId)}",
                    new { userId = user.Id, roleId });

                return matchingRoles > 0;
            }
        }

        public async Task<IList<AppUser>> GetUsersInRoleAsync(string roleName, CancellationToken cancellationToken)
        {
            cancellationToken.ThrowIfCancellationRequested();

            using (var connection = new SqlConnection(_connectionString))
            {
                var queryResults = await connection.QueryAsync<AppUser>("SELECT u.* FROM [AspNetUsers] u " +
                    "INNER JOIN [AspNetUserRoles] ur ON ur.[UserId] = u.[Id] INNER JOIN [AspNetRoles] r ON r.[Id] = ur.[RoleId] WHERE r.[NormalizedName] = @normalizedName",
                    new { normalizedName = roleName.ToUpper() });

                return queryResults.ToList();
            }
        }
        #endregion Read

        #region Update
        public Task SetNormalizedUserNameAsync(AppUser user, string normalizedName, CancellationToken cancellationToken)
        {
            user.NormalizedUserName = normalizedName;
            return Task.FromResult(0);
        }

        public Task SetUserNameAsync(AppUser user, string userName, CancellationToken cancellationToken)
        {
            user.UserName = userName;
            return Task.FromResult(0);
        }

        public async Task<IdentityResult> UpdateAsync(AppUser user, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var connection = new SqlConnection(_connectionString))
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        await connection.OpenAsync(cancellationToken);
                        var parameters = new
                        {
                            id = user.Id,
                            userName = user.UserName,
                            normalizedUserName = user.NormalizedUserName,
                            email = user.Email,
                            normalizedEmail = user.NormalizedEmail,
                            emailConfirmed = user.EmailConfirmed ? 1 : 0,
                            passwordHash = user.PasswordHash,
                            phoneNumber = user.PhoneNumber,
                            phoneNumberConfirmed = user.PhoneNumberConfirmed ? 1 : 0,
                            twoFactorEnabled = user.TwoFactorEnabled ? 1 : 0
                        };
                        var count = await connection.ExecuteAsync(UserStoreSql.UpdateUser, parameters);
                        if (count > 0) return IdentityResult.Success;
                        else throw new Exception("No update any rows");
                    }
                }
                return IdentityResult.Success;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public Task SetEmailAsync(AppUser user, string email, CancellationToken cancellationToken)
        {
            user.Email = email;
            return Task.FromResult(0);
        }

        public Task SetEmailConfirmedAsync(AppUser user, bool confirmed, CancellationToken cancellationToken)
        {
            user.EmailConfirmed = confirmed;
            return Task.FromResult(0);
        }

        public Task SetNormalizedEmailAsync(AppUser user, string normalizedEmail, CancellationToken cancellationToken)
        {
            user.NormalizedEmail = normalizedEmail;
            return Task.FromResult(0);
        }

        public Task SetPhoneNumberAsync(AppUser user, string phoneNumber, CancellationToken cancellationToken)
        {
            user.PhoneNumber = phoneNumber;
            return Task.FromResult(0);
        }

        public Task SetPhoneNumberConfirmedAsync(AppUser user, bool confirmed, CancellationToken cancellationToken)
        {
            user.PhoneNumberConfirmed = confirmed;
            return Task.FromResult(0);
        }

        public Task SetTwoFactorEnabledAsync(AppUser user, bool enabled, CancellationToken cancellationToken)
        {
            user.TwoFactorEnabled = enabled;
            return Task.FromResult(0);
        }

        public Task SetPasswordHashAsync(AppUser user, string passwordHash, CancellationToken cancellationToken)
        {
            user.PasswordHash = passwordHash;
            return Task.FromResult(0);
        }

        #endregion Update

        #region Delete
        public async Task<IdentityResult> DeleteAsync(AppUser user, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var connection = new SqlConnection(_connectionString))
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        await connection.OpenAsync(cancellationToken);
                        await connection.ExecuteAsync(UserStoreSql.DeleteUser, new { id = user.Id });
                    }
                }

                return IdentityResult.Success;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task RemoveFromRoleAsync(AppUser user, string roleName, CancellationToken cancellationToken)
        {
            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                using (var connection = new SqlConnection(_connectionString))
                {
                    if (connection.State == ConnectionState.Closed)
                    {
                        await connection.OpenAsync(cancellationToken);
                        var roleId = await connection.ExecuteScalarAsync<string>(RoleStoreSql.FindRoleByName, new { normalizedName = roleName.ToUpper() });
                        if (!string.IsNullOrEmpty(roleId))
                            await connection.ExecuteAsync(UserStoreSql.DeleteRoleFromUser, new { id = user.Id, roleId });
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        #endregion Delete


        public Task<bool> HasPasswordAsync(AppUser user, CancellationToken cancellationToken)
        {
            return Task.FromResult(user.PasswordHash != null);
        }

        public void Dispose()
        {
            // Nothing to dispose.
        }
    }
}

