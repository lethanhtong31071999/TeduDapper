using System;
namespace Dapper_Tedu.Models
{
    public class Product
    {
        public Product()
        {
            this.Sku = "";
            this.ImageUrl = "";
            this.IsActive = true;
            this.CreatedAt = DateTime.Now;
        }

        public int Id { get; set; }
        public string Sku { get; set; }
        public double Price { get; set; }
        public double? DiscountPrice { get; set; }
        public string ImageUrl { get; set; }
        public string? ImageList { get; set; }
        public int? ViewCount { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public bool IsActive { get; set; }
        public int? RateTotal { get; set; }
        public int? RateCount { get; set; }
    }
}


