-- Create product
GO
CREATE OR ALTER PROCEDURE [dbo].[Create_Product]
	@name nvarchar(255),
	@description nvarchar(255),
	@content ntext,
	@seoDescription nvarchar(255),
	@seoAlias nvarchar(255),
	@seoTitle nvarchar(255),
	@seoKeyword nvarchar(255),
	@sku varchar(50),
	@price float,
	@isActive bit,
	@imageUrl nvarchar(255),
	@languageId varchar(5),
	@id int output
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort on;
	begin tran
	begin try
		INSERT INTO dbo.Products
		(
		    Sku,
		    Price,
		    DiscountPrice,
		    ImageUrl,
		    ImageList,
		    ViewCount,
		    CreatedAt,
		    UpdatedAt,
		    IsActive,
		    RateTotal,
		    RateCount
		)
		VALUES
		(   @sku,        -- Sku - varchar(50)
		    @price,       -- Price - float
		    0.0,       -- DiscountPrice - float
		    @imageUrl,   -- ImageUrl - nvarchar(255)
		    NULL,       -- ImageList - nvarchar(max)
		    0,         -- ViewCount - int
		    GETDATE(), -- CreatedAt - datetime
		    GETDATE(), -- UpdatedAt - datetime
		    @isActive, -- IsActive - bit
		    0,         -- RateTotal - int
		    0          -- RateCount - int
		    )
		SET @id = SCOPE_IDENTITY()

		INSERT INTO dbo.ProductTranslations
		(
		    ProductId,
		    LanguageId,
		    Content,
		    Name,
		    Description,
		    SeoDescription,
		    SeoAlias,
		    SeoTitle,
		    SeoKeyword
		)
		VALUES
		(   @id,   -- ProductId - int
		    @languageId,  -- LanguageId - varchar(50)
		    @content, -- Content - ntext
		    @name, -- Name - nvarchar(255)
		    @description, -- Description - nvarchar(255)
		    @seoDescription, -- SeoDescription - nvarchar(255)
		    @seoAlias,  -- SeoAlias - varchar(255)
		    @seoTitle, -- SeoTitle - nvarchar(255)
			@seoKeyword  -- SeoKeyword - nvarchar(255)
		)
	commit
	end try
	begin catch
		rollback
		  DECLARE @ErrorMessage VARCHAR(2000)
		  SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
		  RAISERROR(@ErrorMessage, 16, 1)
	end catch 
END;

-- Get all
GO
CREATE OR ALTER PROCEDURE [dbo].[Get_Product_All]
	@languageId varchar(5),
	@categoryId int
AS
BEGIN
	SET NOCOUNT ON;

    select 
		p.Id,
		p.Sku,
		p.Price,
		p.DiscountPrice,
		p.ImageUrl,
		p.CreatedAt,
		p.IsActive,
		p.ViewCount,
		pt.Name,
		pt.Content,
		pt.Description,
		pt.SeoAlias,
		pt.SeoDescription,
		pt.SeoKeyword,
		pt.SeoTitle,
		pt.LanguageId
	from Products p 
	left join ProductTranslations pt on p.Id = pt.ProductId and pt.LanguageId = @languageId
END;

-- Get by Id
GO
CREATE OR ALTER PROCEDURE [dbo].[Get_Product_By_Id]
@id INT,
@languageId varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    select 
		p.Id,
		p.Sku,
		p.Price,
		p.DiscountPrice,
		p.ImageUrl,
		p.CreatedAt,
		p.IsActive,
		p.ViewCount,
		pt.Name,
		pt.Content,
		pt.Description,
		pt.SeoAlias,
		pt.SeoDescription,
		pt.SeoKeyword,
		pt.SeoTitle,
		pt.LanguageId
	from Products p 
	left join ProductTranslations pt on p.Id = pt.ProductId 
	where pt.LanguageId = @languageId and p.Id = @id
END;

-- Get by pagination
GO
CREATE OR ALTER PROCEDURE [dbo].[Get_Product_By_Pagination]
	@searchTerm nvarchar(50),
	@categoryId int,
	@pageIndex int,
	@pageSize int,
	@language varchar(5),
	@totalRow int output
AS
BEGIN
	SET NOCOUNT ON;

	select @totalRow = count(*) from Products p 
	inner join ProductTranslations pt on p.Id = pt.ProductId
	WHERE  p.IsActive = 1 and (@searchTerm is null or p.Sku like @searchTerm +'%');

	select p.Id,
		p.Sku,
		p.Price,
		p.DiscountPrice,
		p.ImageUrl,
		p.CreatedAt,
		p.IsActive,
		p.ViewCount,
		pt.Name,
		pt.Content,
		pt.Description,
		pt.SeoAlias,
		pt.SeoDescription,
		pt.SeoKeyword,
		pt.SeoTitle,
		pt.LanguageId
	from Products p 
	left join ProductTranslations pt on p.Id = pt.ProductId  AND pt.LanguageId = @language
	WHERE p.IsActive = 1 AND (@searchTerm is null or p.Sku like @searchTerm +'%')
	order by p.CreatedAt desc
	offset (@pageIndex - 1) * @pageSize rows
	fetch next @pageSize row ONLY;
END;

-- Update product
GO
CREATE OR ALTER PROCEDURE [dbo].[Update_Product]
	@id int,
	@name nvarchar(255),
	@description nvarchar(255),
	@content ntext,
	@seoDescription nvarchar(255),
	@seoAlias nvarchar(255),
	@seoTitle nvarchar(255),
	@seoKeyword nvarchar(255),
	@sku varchar(50),
	@price float,
	@isActive bit,
	@imageUrl nvarchar(255),
	@languageId varchar(5)
AS
BEGIN
   SET NOCOUNT ON;
	set xact_abort on;
	begin tran
	begin try
	     update Products set Sku = @sku,Price = @price, IsActive = @isActive,ImageUrl=@imageUrl
		where Id = @id

	   update ProductTranslations 
		   set Content = @content,
		   Name = @name,
		   Description = @description,
		   SeoDescription= @seoDescription,
		   SeoAlias = @seoAlias,
		   SeoTitle = @seoTitle,
		   SeoKeyword = @seoKeyword
	   where ProductId = @id and LanguageId = @languageId
	commit
	end try
	begin catch
		rollback
		  DECLARE @ErrorMessage VARCHAR(2000)
		  SELECT @ErrorMessage = 'Error ' + ERROR_MESSAGE()
		  RAISERROR(@ErrorMessage, 16, 1)
	end catch
END;

-- Delete Product
GO 
CREATE OR ALTER PROCEDURE [dbo].[Delete_Product]
	@id int
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort ON;
	Begin tran
	begin try
			delete from Products where Id = @id
			delete from ProductTranslations where ProductId = @id
		commit
	end try
		begin catch
			rollback
			DECLARE @ErrorMessage VARCHAR(2000)
			SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
			RAISERROR(@ErrorMessage, 16, 1)
	end catch
END;