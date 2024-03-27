CREATE TABLE [dbo].[Dim_Usuarios]
(
	[Id_Cliente] INT NOT NULL , 
    [email] VARCHAR(60) NULL, 
    [nome] VARCHAR(45) NULL, 
    [ativo] CHAR(1) NULL, 
    [idcontrato] INT NULL
)
