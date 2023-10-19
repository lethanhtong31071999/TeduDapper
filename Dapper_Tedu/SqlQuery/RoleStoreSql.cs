using System;
namespace Dapper_Tedu.SqlQuery
{
    public static class RoleStoreSql
    {
        public static string CreateRole =
            @"INSERT INTO [AspNetRoles] ([Id], [Name], [NormalizeName])
			VALUES(@id, @name, @normalizedName);";

        public static string UpdateRole =
            @"UPDATE [AspNetRoles]
            SET [Name] = @name, [NormalizedName] = @normalizeName
            WHERE [Id] = @id";

        public static string FindRoleById = @"
            SELECT [Id], [Name], [NormalizedName] FROM [AspNetRoles] WHERE [Id] = @id;";

        public static string FindRoleByName = @"
            SELECT [Id], [Name], [NormalizedName] FROM [AspNetRoles] WHERE [NormalizedName] = @normalizedName;";

        public static string GetRoleName = @"
            SELECT [Name] FROM [AspNetRoles] WHERE [Id] = @id;";

        public static string GetNormalizedRoleName = @"
            SELECT [NormalizedName] FROM [AspNetRoles] WHERE [Id] = @id;";

        public static string GetRoleId = @"";

        public static string SetNormalizedName = @"
            UPDATE [AspNetRoles]
            SET [NormalizedName] = @normalizeName
            WHERE [Id] = @id";

        public static string SetName = @"
            UPDATE [AspNetRoles]
            SET [Name] = @name
            WHERE [Id] = @id";

        public static string DeleteRole = @"
            DELETE [AspNetRoles] WHERE [Id] = @id";
    }
}

