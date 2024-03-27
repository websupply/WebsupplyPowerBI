CREATE TABLE [dbo].[Ft_Limites]
(
	[Sk_Id_Cliente] INT NOT NULL , 
    [Sk_Id_Data] INT NOT NULL, 
    [DataInclusao] DATE NULL, 
    [ValorLimiteCompra] MONEY NULL, 
    [ValorLimiteUtilizado] MONEY NULL 
)