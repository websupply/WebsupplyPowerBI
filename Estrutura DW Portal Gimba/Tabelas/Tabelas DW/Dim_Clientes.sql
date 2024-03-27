CREATE TABLE [dbo].[Dim_Clientes]
(
	[Id_Sk] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Id_Cliente] INT NULL, 
    [Nome] VARCHAR(50) NULL, 
    [CNPJ_CPF] VARCHAR(45) NULL, 
    [Tipo] VARCHAR(1) NULL
)
