USE [Tedu_Dapper]
GO
/****** Object:  StoredProcedure [dbo].[Create_Product]    Script Date: 10/19/2023 11:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Create_Product]
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
	@categoryIds varchar(255),
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

		INSERT INTO ProductInCategories(ProductId, CategoryId)
		SELECT @id, [value] AS CategoryId FROM string_split(@categoryIds, ',');

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
/****** Object:  StoredProcedure [dbo].[Delete_Product]    Script Date: 10/19/2023 11:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Delete_Product]
	@id int
AS
BEGIN
	SET NOCOUNT ON;
	set xact_abort ON;
	Begin tran
	begin try
			delete from Products where Id = @id;
			delete from ProductTranslations where ProductId = @id;
			delete from ProductInCategories where ProductId = @id;
		commit
	end try
		begin catch
			rollback
			DECLARE @ErrorMessage VARCHAR(2000)
			SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
			RAISERROR(@ErrorMessage, 16, 1)
	end catch
END;
GO
/****** Object:  StoredProcedure [dbo].[Get_Product_All]    Script Date: 10/19/2023 11:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Get_Product_All]
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
		pt.LanguageId,
		c.Name AS CategoryName
	from Products p 
	left join ProductTranslations pt on p.Id = pt.ProductId and pt.LanguageId = @languageId
	left join ProductInCategories pc on pc.ProductId = p.Id
	left join Categories c on c.Id = pc.CategoryId
	where @categoryId is null or @categoryId = pc.CategoryId;
END;
GO
/****** Object:  StoredProcedure [dbo].[Get_Product_By_Id]    Script Date: 10/19/2023 11:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Get_Product_By_Id]
@id INT,
@languageId varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    select TOP 1
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
	left join ProductInCategories pc on pc.ProductId = p.id
	where pt.LanguageId = @languageId and p.Id = @id
END;
GO
/****** Object:  StoredProcedure [dbo].[Get_Product_By_Pagination]    Script Date: 10/19/2023 11:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Get_Product_By_Pagination]
	@searchTerm nvarchar(50),
	@categoryId int,
	@pageIndex int,
	@pageSize int,
	@languageId varchar(5),
	@totalRow int output
AS
BEGIN
	SET NOCOUNT ON;

	select @totalRow = count(*) from Products p 
	left join ProductTranslations pt on p.Id = pt.ProductId and pt.LanguageId = @languageId
	left join ProductInCategories pc on pc.ProductId = p.Id
	left join Categories c on c.Id = pc.CategoryId
	WHERE	p.IsActive = 1 
			and (@searchTerm is null or p.Sku like @searchTerm +'%')
			and (@categoryId is null or pc.categoryId = @categoryId);

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
		pt.LanguageId,
		c.Id as CurrentCategoryId,
		c.Name as CategoryName
	from Products p 
	left join ProductTranslations pt on p.Id = pt.ProductId  AND pt.LanguageId = @languageId
	left join ProductInCategories pc on pc.ProductId = p.Id
	left join Categories c on c.Id = pc.CategoryId
	WHERE 
		p.IsActive = 1 
		AND (@searchTerm is null or p.Sku like @searchTerm +'%')
		AND (@categoryId is null or pc.categoryId = @categoryId)
	order by p.CreatedAt desc
	offset (@pageIndex - 1) * @pageSize rows
	fetch next @pageSize row ONLY;
END;
GO
/****** Object:  StoredProcedure [dbo].[Update_Product]    Script Date: 10/19/2023 11:06:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Update_Product]
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
	@categoryIds varchar(255),
	@languageId varchar(5)
AS
BEGIN
   SET NOCOUNT ON;
	set xact_abort on;
	begin tran
	begin try
	    update Products set Sku = @sku,Price = @price, IsActive = @isActive,ImageUrl=@imageUrl
		where Id = @id

		delete from ProductInCategories where ProductId = @id;
		insert into ProductInCategories(ProductId, CategoryId)
		select @id, [value] AS categoryId from string_split(@categoryIds, ',');

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
GO
