USE $(DatabaseName)
GO
SET QUOTED_IDENTIFIER ON
GO
--Creating the two Temp tables - Temp_Product_Data and Temp_Product_Data1
CREATE TABLE [dbo].[Temp_Product_Data](
	[ID] [varchar](8000) NULL,
	[UPC] [nvarchar](4000) NULL,
	[Name] [varchar](100) NULL,
	[Category] [varchar](max) NULL,
	[Subcategory] [varchar](max) NULL,
	[Manufacturer] [varchar](max) NULL,
	[Supplier] [varchar](max) NULL,
	[Brand] [varchar](max) NULL,
	[Height] [float] NULL,
	[Width] [float] NULL,
	[Depth] [float] NULL,
	[Case total number] [int] NULL,
	[Size] [float] NULL,
	[UOM] [varchar](5) NULL,
	[Price] [money] NULL,
	[UnitMovement] [float] NULL,
	[Sales] [float] NULL,
	[Profit] [float] NULL,
	[ID_column] [int] IDENTITY(1,1),
	PRIMARY KEY (ID_column)
)
GO

CREATE TABLE [dbo].[Temp_Product_Data1](
	[ID] [varchar](max) NULL,
	[UPC] [varchar](max) NULL,
	[Name] [varchar](max) NULL,
	[Category] [varchar](max) NULL,
	[Subcategory] [varchar](max) NULL,
	[Manufacturer] [varchar](max) NULL,
	[Supplier] [varchar](max) NULL,
	[Brand] [varchar](max) NULL,
	[Height] [varchar](max) NULL,
	[Width] [varchar](max) NULL,
	[Depth] [varchar](max) NULL,
	[Case total number] [varchar](max) NULL,
	[Size] [varchar](max) NULL,
	[UOM] [varchar](max) NULL,
	[Price] [varchar](max) NULL,
	[UnitMovement] [varchar](max) NULL,
	[Sales] [varchar](max) NULL,
	[Profit] [varchar](max) NULL
)
GO
--Importing data from Product Sheet to Temp_Product_Data1
BULK
INSERT [Temp_Product_Data1]
FROM 'C:\\Temp\\ExtractionToSQL\\Products Data.txt' --location with filename
WITH
(
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n',
FirstROW = 2
)
GO

--Extracting the data from Temp_Product_Data1 to final Temp_Product_Data
INSERT INTO [Temp_Product_Data] ([ID], [UPC],[Name],[Category],[Subcategory],[Manufacturer],[Supplier],
[Brand],[Height],[Width],[Depth],[Case total number],[Size],[UOM],[Price],[UnitMovement],[Sales],[Profit])
Select ID, UPC, Name, Category, Subcategory, Manufacturer, Supplier, Brand, Height, Width, Depth, [Case total number], Size, UOM, Price, UnitMovement, Sales, Profit
From [Temp_Product_Data1]
GO



--Removes redundant data if any
WITH TempTable AS
(
   SELECT *, ROW_NUMBER()OVER(PARTITION BY ID ORDER BY ID,ID_column DESC) AS RowNumber
   FROM dbo.[Temp_Product_Data]
   )
DELETE from TempTable where RowNumber > 1
Go

--Updating the extractted data to the final main database "ix_spc_product"
MERGE dbo.[ix_spc_product] As ta
USING Temp_Product_Data As s
ON (ta.[ID] = s.[ID])
WHEN MATCHED THEN 
UPDATE SET ta.[UPC] = s.[UPC],
ta.[Name] = s.[Name],
ta.[Category] = s.[Category],
ta.[Subcategory] = s.[Subcategory],
ta.[Manufacturer] = s.[Manufacturer],
ta.[Supplier] = s.[Supplier],
ta.[Desc50] = s.[Brand],
ta.[Height] = s.[Height],
ta.[Width] = s.[Width],
ta.[Depth] = s.[Depth],
ta.[CaseTotalNumber] = s.[Case total number],
ta.[Size] = s.[Size],
ta.[UOM] = s.[UOM],
ta.[Price] = s.[Price],
ta.[UnitMovement] = s.[UnitMovement],
ta.[Value49] = s.[Sales],
ta.[Value50] = s.[Profit]
WHEN NOT MATCHED BY TARGET
THEN INSERT ([ID], [UPC], [Name], [Category], [Subcategory], [Manufacturer], [Supplier], [Desc50], 
[Height], [Width], [Depth], [CaseTotalNumber], [Size], [UOM], [Price], [UnitMovement], [Value49], [Value50]) 
VALUES (s.[ID], s.[UPC],
s.[Name],
s.[Category],
s.[Subcategory],
s.[Manufacturer],
s.[Supplier],
s.[Brand],
s.[Height],
s.[Width],
s.[Depth],
s.[Case total number],
s.[Size],
s.[UOM],
s.[Price],
s.[UnitMovement],
s.[Sales],
s.[Profit]);
GO

--Removing data from the temperory product data table
DROP Table Temp_Product_Data1
GO

DROP Table Temp_Product_Data
GO

--Creating the two Temp tables - Temp_Store_Data and Temp_Store_Data1
CREATE TABLE [dbo].[Temp_Store_Data](
	[STORE ID] [float] NULL,
	[STORE NAME] [varchar](100) NULL,
	[CITY] [varchar](50) NULL,
	[STATE ID] [varchar](50) NULL,
	[DISTRICT] [varchar](50) NULL,
	[REGION] [varchar](50) NULL,
	[TYPE] [varchar](50) NULL,
	[LATITUDE] [float] NULL,
	[LONGITUDE] [float] NULL,
	[COUNTRY] [varchar](50) NULL,
	[STORE FORMAT] [varchar](50) NULL,
	[STORE SIZE] [float] NULL,
	[ID_column] [int] IDENTITY(1,1),
	PRIMARY KEY (ID_column)
)
GO

CREATE TABLE [dbo].[Temp_Store_Data1](
	[STORE ID] [varchar](max) NULL,
	[STORE NAME] [varchar](max) NULL,
	[CITY] [varchar](max) NULL,
	[STATE ID] [varchar](max) NULL,
	[DISTRICT] [varchar](max) NULL,
	[REGION] [varchar](max) NULL,
	[TYPE] [varchar](max) NULL,
	[LATITUDE] [varchar](max) NULL,
	[LONGITUDE] [varchar](max) NULL,
	[COUNTRY] [varchar](max) NULL,
	[STORE FORMAT] [varchar](max) NULL,
	[STORE SIZE] [varchar](max) NULL
)
GO

--Importing data from Store Data Sheet to Temp_Store_Data1
BULK
INSERT [Temp_Store_Data1]
FROM 'C:\\Temp\\ExtractionToSQL\\Store Data.txt' --location with filename
WITH
(
FIELDTERMINATOR = '\t',
ROWTERMINATOR = '\n',
FirstROW = 2
)
GO


--Extracting the data from Temp_Store_Data1 to final Temp_Store_Data
Insert into Temp_Store_Data ([STORE ID], [STORE NAME], [CITY], [STATE ID], [DISTRICT], [REGION], [TYPE], [LATITUDE], [LONGITUDE],
[COUNTRY], [STORE FORMAT], [STORE SIZE])
Select [STORE ID], [STORE NAME], [CITY], [STATE ID], [DISTRICT], [REGION],[TYPE], [LATITUDE], [LONGITUDE],
[COUNTRY], [STORE FORMAT], [STORE SIZE]
From [Temp_Store_Data1]
GO

--Removes redundant data if any
WITH TempTable AS
(
   SELECT *, ROW_NUMBER()OVER(PARTITION BY [STORE ID] ORDER BY [STORE ID],ID_column DESC) AS RowNumber
   FROM dbo.[Temp_Store_Data]
   )
DELETE from TempTable where RowNumber > 1
Go

--Updating the extracted data to the final main database "ix_str_store"
MERGE dbo.[ix_str_store] As t
USING dbo.[Temp_Store_Data] As s
ON (t.[StoreNumber] = s.[STORE ID]) 
WHEN MATCHED THEN 
UPDATE SET t.[Name] = s.[STORE NAME],
t.[AddressCity] = s.[CITY],
t.[AddressState]=s.[STATE ID],
t.[Address2]=s.[DISTRICT],
t.[Region]=s.[REGION],
t.[Desc49]=s.[TYPE],
t.[Value48]=s.[LATITUDE],
t.[Value49]=s.[LONGITUDE],
t.[AddressCountry]=s.[COUNTRY],
t.[DESC50]=s.[STORE FORMAT],
t.[Value50]=s.[STORE SIZE]
WHEN NOT MATCHED BY TARGET
THEN INSERT ([StoreNumber], [Name], [AddressCity], [AddressState], [Address2], [Region], 
[Desc49], [Value48], [Value49], [AddressCountry], [DESC50], [Value50]) 
VALUES (s.[STORE ID], s.[STORE NAME],
s.[CITY],
s.[STATE ID],
s.[DISTRICT],
s.[REGION],
s.[TYPE],
s.[LATITUDE],
s.[LONGITUDE],
s.[COUNTRY],
s.[STORE FORMAT],
s.[STORE SIZE]);
GO

--Removing data from the temperory storedata table
DROP Table Temp_Store_Data1
GO

DROP Table Temp_Store_Data
GO

