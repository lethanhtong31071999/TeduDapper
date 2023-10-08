using System;
namespace Dapper_Tedu.Dtos
{
    public class PagedResult<T> where T : class
    {
        public int PageSize { get; set; }
        public int PageIndex { get; set; }
        public int TotalRow { get; set; }
        public IEnumerable<T>? Result { get; set; }
    }
}

