CREATE TABLE [dbo].[Dim_Produtos]
(
	[Id_Sk] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Id_Produto] INT NULL, 
    [Descricao] NVARCHAR(640) NULL, 
    [Fabricante] VARCHAR(30) NULL
)
