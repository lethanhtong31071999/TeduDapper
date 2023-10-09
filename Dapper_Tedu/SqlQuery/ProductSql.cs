using System;
namespace Dapper_Tedu.Models
{
    public static class ProductSql
    {
        public static string StoreGetAll = "Get_Product_All";
        public static string StoreGetById = "Get_Product_By_Id";
        public static string StoreCreate = "Create_Product";
        public static string StoreUpdate = "Update_Product";
        public static string StoreDelete = "Delete_Product";
        public static string StoreGetByPagination = "Get_Product_By_Pagination";
    }
}

