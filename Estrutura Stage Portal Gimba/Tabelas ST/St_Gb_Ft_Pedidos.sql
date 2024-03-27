CREATE TABLE [dbo].[St_Gb_Ft_Pedidos]
(
    [Id_CentroCusto] INT NULL,
	[Id_PedidoItem] INT NULL,
    [Id_Pedido] INT NULL, 
    [Id_Cliente] INT NULL, 
    [Id_Contrato] INT NULL, 
    [Id_Login] INT NULL, 
    [Id_PedidosStatus] INT NULL, 
    [Id_Produto] INT NULL, 
    [Cod_BuscaProduto] VARCHAR(20) NULL, 
    [BuscaProduto] NVARCHAR(700) NULL, 
    [TipoCatalogo] VARCHAR(50) NULL, 
    [Cidade] VARCHAR(60) NULL, 
    [Estado] VARCHAR(50) NULL, 
    [UF] CHAR(2) NULL, 
    [Localizacao] VARCHAR(200) NULL, 
    [Data_Pedido] DATE NULL, 
    [Qtde] INT NULL, 
    [PrecoUnitario] MONEY NULL, 
    [Total_Itens] MONEY NULL, 
    [Total_Custo] MONEY NULL
)
