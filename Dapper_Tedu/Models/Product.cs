using System;
using System.ComponentModel.DataAnnotations;

namespace Dapper_Tedu.Models
{
    public class Product
    {
        public Product()
        {
            this.Sku = string.Empty;
            this.ImageUrl = string.Empty;
            this.IsActive = true;
            this.CreatedAt = DateTime.Now;
            this.UpdatedAt = DateTime.Now;
        }

        public int Id { get; set; }
        [Required(ErrorMessage = "SKURequiredErrorMsg")]
        [StringLength(10, ErrorMessage = "SKUMinAndMaxLengthErrorMsg", MinimumLength = 6)]
        public string Sku { get; set; }
        [Required]
        public double Price { get; set; }
        [Required]
        public string ImageUrl { get; set; }
        public bool IsActive { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public string? ImageList { get; set; }
        public double? DiscountPrice { get; set; }
        public int? ViewCount { get; set; }
        public int? RateTotal { get; set; }
        public int? RateCount { get; set; }

        // Product Translation
        public string? LanguageId { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public string? Content { get; set; }
        public string? SeoAlias { get; set; }
        public string? SeoDescription { get; set; }
        public string? SeoKeyword { get; set; }
        public string? SeoTitle { get; set; }
    }
}


