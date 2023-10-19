using System;
namespace Dapper_Tedu.SqlQuery
{
    public static class UserStoreSql
    {
        public static string CreateUser = @"
		INSERT INTO [AspNetUsers]
                    ([Id],[UserName], [NormalizedUserName], [Email],
                    [NormalizedEmail], [EmailConfirmed], [PasswordHash],
					[PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled])
                    VALUES
                    (@id, @userName, @normalizedUserName, @email,
                    @normalizedEmail, @emailConfirmed, @passwordHash,
                    @phoneNumber, @phoneNumberConfirmed, @twoFactorEnabled);";

        public static string GetRoleIdByNormalizedName = @"
                    SELECT [Id] FROM [AspNetRoles] WHERE [NormalizedName] = @normalizedName";

        public static string AddRoleForUser = @"
                    IF NOT EXISTS(SELECT 1 FROM [AspNetUserRoles] WHERE [UserId] = @userId AND [RoleId] = @{nameof(roleId)})
                    INSERT INTO [AspNetUserRoles] ([UserId], [RoleId])
                    VALUES(@userId, @roleId)";

        public static string UpdateUser = @"UPDATE [AspNetUsers] SET
                    [UserName] = @userName,
                    [NormalizedUserName] = @normalizedUserName,
                    [Email] = email,
                    [NormalizedEmail] = normalizedEmail,
                    [EmailConfirmed] = emailConfirmed,
                    [PasswordHash] = passwordHash,
                    [PhoneNumber] = @phoneNumber,
                    [PhoneNumberConfirmed] = @phoneNumberConfirmed,
                    [TwoFactorEnabled] = @twoFactorEnabled
                    WHERE [Id] = @id";

        public static string DeleteUser = @"
                    DELETE FROM [AspNetUsers] WHERE [Id] = @id";

        public static string DeleteRoleFromUser = @"
                    DELETE FROM [AspNetUserRoles] WHERE [UserId] = @id AND [RoleId] = @roleId";
    }
}

