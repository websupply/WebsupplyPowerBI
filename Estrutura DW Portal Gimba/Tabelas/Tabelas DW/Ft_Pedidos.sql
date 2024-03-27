CREATE TABLE [dbo].[Ft_Pedidos]
(
	[Id_PedidoItem] INT NULL, 
    [Id_Pedido] INT NULL, 
    [Sk_Id_Data] INT NULL,
    [Sk_Id_CentroCusto] INT NULL,
    [Sk_Id_Cliente] INT NULL, 
    [Sk_Id_Login] INT NULL, 
    [Sk_Id_PedidoStatus] INT NULL, 
    [Sk_Id_Produto] INT NULL, 
    [CodigoBuscaProduto] VARCHAR(20) NULL, 
    [BuscaProduto] NVARCHAR(700) NULL, 
    [Id_Contrato] INT NULL, 
    [TipoCatalogo] VARCHAR(50) NULL, 
    [Cidade] VARCHAR(60) NULL, 
    [Estado] VARCHAR(50) NULL, 
    [UF] CHAR(2) NULL, 
    [Localizacao] VARCHAR(200) NULL, 
    [DataPedido] DATE NULL, 
    [Qtde] INT NULL, 
    [PrecoUnitario] MONEY NULL, 
    [Total_Itens] MONEY NULL, 
    [Total_Custo] MONEY NULL 
)
