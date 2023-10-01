USE [master]
GO
/****** Object:  Database [Tedu_Dapper]    Script Date: 10/1/2023 11:00:30 PM ******/
CREATE DATABASE [Tedu_Dapper]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Tedu_Dapper', FILENAME = N'/var/opt/mssql/data/Tedu_Dapper.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Tedu_Dapper_log', FILENAME = N'/var/opt/mssql/data/Tedu_Dapper_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Tedu_Dapper] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Tedu_Dapper].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Tedu_Dapper] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET ARITHABORT OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Tedu_Dapper] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Tedu_Dapper] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Tedu_Dapper] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Tedu_Dapper] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Tedu_Dapper] SET  MULTI_USER 
GO
ALTER DATABASE [Tedu_Dapper] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [Tedu_Dapper] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Tedu_Dapper] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Tedu_Dapper] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Tedu_Dapper] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Tedu_Dapper] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Tedu_Dapper', N'ON'
GO
ALTER DATABASE [Tedu_Dapper] SET QUERY_STORE = OFF
GO
USE [Tedu_Dapper]
GO
/****** Object:  Table [dbo].[AttributeOptions]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AttributeId] [int] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_AttributeOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributeOptionValues]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeOptionValues](
	[Id] [int] NOT NULL,
	[OptionId] [int] NULL,
	[Value] [nvarchar](255) NULL,
 CONSTRAINT [PK_AttributeOptionValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Attributes]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attributes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[SortOrder] [int] NULL,
	[BackendType] [varchar](50) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Attributes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributeValueDateTimes]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeValueDateTimes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [ntext] NULL,
	[AttributeId] [int] NULL,
	[ProductId] [int] NULL,
	[LanguageId] [varchar](50) NULL,
 CONSTRAINT [PK_AttributeValueDateTimes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributeValueDecimals]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeValueDecimals](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](250) NULL,
	[AttributeId] [int] NULL,
	[ProductId] [int] NULL,
	[LanguageId] [varchar](50) NULL,
 CONSTRAINT [PK_AttributeValueDecimals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributeValueInts]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeValueInts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AttributeId] [int] NULL,
	[Value] [int] NULL,
	[ProductId] [int] NULL,
	[LanguageId] [varchar](50) NULL,
 CONSTRAINT [PK_AttributeValueInts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributeValueText]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeValueText](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AttributeId] [int] NULL,
	[Value] [ntext] NULL,
	[ProductId] [int] NULL,
	[LanguageId] [varchar](50) NULL,
 CONSTRAINT [PK_AttributeValueText] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributeValueVarchars]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeValueVarchars](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](250) NULL,
	[AttributeId] [int] NULL,
	[ProductId] [int] NULL,
	[LanguageId] [varchar](50) NULL,
 CONSTRAINT [PK_AttributeValueVarchars] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[SeoAlias] [varchar](255) NULL,
	[SeoTitle] [nvarchar](255) NULL,
	[SeoKeyword] [nvarchar](255) NULL,
	[SeoDescription] [nvarchar](255) NULL,
	[ParentId] [int] NULL,
	[SortOrder] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Languages]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[Id] [varchar](50) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
	[IsDefault] [bit] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[ProductId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC,
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[CustomerAddress] [nvarchar](255) NOT NULL,
	[CustomerEmail] [nvarchar](255) NOT NULL,
	[CustomerPhone] [varchar](20) NOT NULL,
	[CustomerNote] [nvarchar](255) NOT NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductInCategories]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductInCategories](
	[ProductId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_ProductInCategories] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Sku] [varchar](50) NOT NULL,
	[Price] [float] NOT NULL,
	[DiscountPrice] [float] NULL,
	[ImageUrl] [nvarchar](255) NOT NULL,
	[ImageList] [nvarchar](max) NULL,
	[ViewCount] [int] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[RateTotal] [int] NULL,
	[RateCount] [int] NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTranslations]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTranslations](
	[ProductId] [int] NOT NULL,
	[LanguageId] [varchar](50) NOT NULL,
	[Content] [ntext] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[SeoDescription] [nvarchar](255) NULL,
	[SeoAlias] [varchar](255) NULL,
	[SeoTitle] [nvarchar](255) NULL,
	[SeoKeyword] [nvarchar](255) NULL,
 CONSTRAINT [PK_ProductTranslations] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AttributeOptions]  WITH CHECK ADD  CONSTRAINT [FK_AttributeOptions_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([Id])
GO
ALTER TABLE [dbo].[AttributeOptions] CHECK CONSTRAINT [FK_AttributeOptions_Attributes]
GO
ALTER TABLE [dbo].[AttributeOptionValues]  WITH CHECK ADD  CONSTRAINT [FK_AttributeOptionValues_AttributeOptions] FOREIGN KEY([OptionId])
REFERENCES [dbo].[AttributeOptions] ([Id])
GO
ALTER TABLE [dbo].[AttributeOptionValues] CHECK CONSTRAINT [FK_AttributeOptionValues_AttributeOptions]
GO
ALTER TABLE [dbo].[AttributeValueDateTimes]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueDateTimes_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueDateTimes] CHECK CONSTRAINT [FK_AttributeValueDateTimes_Attributes]
GO
ALTER TABLE [dbo].[AttributeValueDateTimes]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueDateTimes_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueDateTimes] CHECK CONSTRAINT [FK_AttributeValueDateTimes_Products]
GO
ALTER TABLE [dbo].[AttributeValueDecimals]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueDecimals_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueDecimals] CHECK CONSTRAINT [FK_AttributeValueDecimals_Attributes]
GO
ALTER TABLE [dbo].[AttributeValueDecimals]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueDecimals_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueDecimals] CHECK CONSTRAINT [FK_AttributeValueDecimals_Products]
GO
ALTER TABLE [dbo].[AttributeValueInts]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueInts_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueInts] CHECK CONSTRAINT [FK_AttributeValueInts_Attributes]
GO
ALTER TABLE [dbo].[AttributeValueInts]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueInts_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueInts] CHECK CONSTRAINT [FK_AttributeValueInts_Products]
GO
ALTER TABLE [dbo].[AttributeValueText]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueText_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueText] CHECK CONSTRAINT [FK_AttributeValueText_Attributes]
GO
ALTER TABLE [dbo].[AttributeValueText]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueText_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueText] CHECK CONSTRAINT [FK_AttributeValueText_Products]
GO
ALTER TABLE [dbo].[AttributeValueVarchars]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueVarchars_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueVarchars] CHECK CONSTRAINT [FK_AttributeValueVarchars_Attributes]
GO
ALTER TABLE [dbo].[AttributeValueVarchars]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValueVarchars_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[AttributeValueVarchars] CHECK CONSTRAINT [FK_AttributeValueVarchars_Products]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Products]
GO
ALTER TABLE [dbo].[ProductInCategories]  WITH CHECK ADD  CONSTRAINT [FK_ProductInCategories_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[ProductInCategories] CHECK CONSTRAINT [FK_ProductInCategories_Categories]
GO
ALTER TABLE [dbo].[ProductInCategories]  WITH CHECK ADD  CONSTRAINT [FK_ProductInCategories_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ProductInCategories] CHECK CONSTRAINT [FK_ProductInCategories_Products]
GO
ALTER TABLE [dbo].[ProductTranslations]  WITH CHECK ADD  CONSTRAINT [FK_ProductTranslations_Languages] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Languages] ([Id])
GO
ALTER TABLE [dbo].[ProductTranslations] CHECK CONSTRAINT [FK_ProductTranslations_Languages]
GO
ALTER TABLE [dbo].[ProductTranslations]  WITH CHECK ADD  CONSTRAINT [FK_ProductTranslations_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[ProductTranslations] CHECK CONSTRAINT [FK_ProductTranslations_Products]
GO
/****** Object:  StoredProcedure [dbo].[Create_Prodct]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Create_Prodct]
@sku nvarchar(50),
@price float,
@imageUrl nvarchar(225),
@isActive bit,
@id int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Products(sku, price, imageUrl, isActive, UpdatedAt, CreatedAt)
	VALUES (@sku, @price, @imageUrl, @isActive, GETDATE(), GETDATE());

	SET @id = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_Product]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Delete_Product]
@productId int
AS
BEGIN
	DELETE Products WHERE id = @productId;

END
GO
/****** Object:  StoredProcedure [dbo].[Get_Product_All]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Get_Product_All]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, Sku, Price, DiscountPrice, ImageUrl, CreatedAt, UpdatedAt FROM Products;
END
GO
/****** Object:  StoredProcedure [dbo].[Get_Product_By_Id]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Get_Product_By_Id]
@productId int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, Sku, Price, DiscountPrice, ImageUrl, CreatedAt, UpdatedAt FROM Products WHERE Id = @productId;
END
GO
/****** Object:  StoredProcedure [dbo].[Update_Product]    Script Date: 10/1/2023 11:00:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Update_Product]
@productId int,
@sku nvarchar(50),
@price float,
@imageUrl nvarchar(225),
@isActive bit
AS
BEGIN
	UPDATE Products
	SET Sku = @sku, Price = @price, ImageUrl = @imageUrl, IsActive = @isActive
	WHERE Id = @productId;
END
GO
USE [master]
GO
ALTER DATABASE [Tedu_Dapper] SET  READ_WRITE 
GO
