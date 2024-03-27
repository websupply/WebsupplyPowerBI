

SET LANGUAGE PORTUGUESE
/*-- ===============================================================================================
Script           : S001_Cria_Dimensao_Tempo.sql
Server           : N/A
Object			 : Table and Script
----------------------------------------------------------------------------------------------------
Creation date    : 2010-09-21
Created by       : Giulianno Luiz Chareta
Definition       : Calcula os dias uteis de uma data a outra, excluindo todos os feriados
User_Name		 : N/A
----------------------------------------------------------------------------------------------------
Last Update date : 2014-07-01
Created by       : Giulianno Luiz Chareta
Definition       : Inclusão do Script que Cria a tabela Dim_Tempo e Popula ela com os dados escolhidos
----------------------------------------------------------------------------------------------------
Dependencies     : 
----------------------------------------------------------------------------------------------------
Comments         : Cria a tabela Tempo e popula com as informações 
				   Este script tem como proposito retornar a quantidade de dias úteis de um período
				   passando-se por parâmetros a data inicial a quantidade de dias de prazo. Excluirá
				   todos os feriados nacionais, inclusive os móveis.
				   Feriados:
				   ---------------------------------------------------------
				   Data:				Descrição
				   ---------------------------------------------------------
				   01-janeiro		-->	Confraternização Universal
				   à Calcular		-->	Carnaval
				   à Calcular		--> Sexta Feira Santa (Páscoa)
				   21-abril			--> Tiradentes
				   01-maio			--> Dia do Trabalho
				   à Calcular		--> Corpus Christi		
				   07-setembro		--> Independência do Brasil
				   12-outubro		--> Nossa Senhora Aparecida
				   02-novembro		--> Finados
				   15-novembro		--> Proclamação da República
				   25-dezembro		--> Natal		
				   ----------------------------------------------------------
				   Cálculo da Páscoa
				   ----------------------------------------------------------				
					A = o resto de (Ano ÷ 19)
					B = o inteiro de (Ano ÷ 100)
					C = o resto de (Ano ÷ 100)
					D = o inteiro de (B ÷ 4)
					E = o resto de (B ÷ 4)
					F = o inteiro de [(B + 8) ÷ 25]
					G = o inteiro de [(B - F + 1) ÷ 3]
					H = o resto de [(19xA + B - D - G + 15) ÷ 30]
					I = o inteiro de (C ÷ 4)
					K = o resto de (C ÷ 4)
					L = o resto de [(32 + 2xE + 2xI - H - K) ÷ 7]
					M = o inteiro de [(A + 11xH + 22xL) ÷ 451]
					P = o inteiro de [(H + L - 7xM + 114) ÷ 31]
					Q = o resto de [(H + L - 7xM + 114) ÷ 31]
					A Páscoa será no dia Q+1 do mês P.
				   ----------------------------------------------------------	
				   Fonte: http://www.ghiorzi.org/portug2.htm	
				   ----------------------------------------------------------	
				   PÁSCOA - CARNAVAL - CORPUS CHRISTI
				   ----------------------------------------------------------
					Todos os feriados eclesiásticos são calculados em função da Páscoa e esta é calculada 
					em função da Lua Cheia. Veja as explicações a seguir: 				
						--A PÁSCOA ocorre no primeiro domingo após a primeira lua cheia que se verificar a partir 
						--de 21 de março. A Sexta-Feira da Paixão é a que antecede o Domingo de Páscoa. 
						--A terça-feira de CARNAVAL ocorre 47 dias antes da Páscoa e a quinta-feira 
						--do CORPUS CHRISTI ocorre 60 dias após a Páscoa. Domingo de RAMOS é o que antecede o 
						--domingo da Páscoa, a QUARESMA são os 40 dias entre o Carnaval e o domingo de Ramos, 
						--a quinta-feira da ASCENSÃO ocorre 39 dias após a Páscoa e o domingo de PENTECOSTES 
						--vem 10 dias depois da Ascensão. 
						--Obs.: Se você confrontar os dados com o Microsoft/Office/Excel, verá disparidade 
						--no ano de 1900. O problema é do Excel, que considera 1900 um ano bissexto, incorretamente. 		
*/-- ===============================================================================================

USE EGBPORTAL_DW
GO


DROP TABLE IF EXISTS [dbo].DIM_CALENDARIO
GO

/****** Object:  UserTable [dbo].[Dim_Tempo]    Script Date: 11/29/2010 10:15:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE 
	[dbo].DIM_CALENDARIO
	(
		TMPO_ID_TEMPO							INT NOT NULL
		,TMPO_DT_DATA							DATETIME2(7)		-- 20140401
		,TMPO_DS_DATA							VARCHAR(10)		-- 01/01/2014
		
		,TMPO_CD_DIA_SEMANA						INT				-- 20140414
		,TMPO_DS_DIA_SEMANA						VARCHAR(15)		-- 1ª Quarta
		,TMPO_NR_DIA_SEMANA						INT				-- 1 = Domingo - 2 - Segunda - 3 terça 
		--,TMPO_CD_SEMANA_MES						INT				-- 20140101
		--,TMPO_DS_SEMANA_MES						VARCHAR(20)		-- 1ª Semana Jan/2014
		--,TMPO_DS_SEMANA_MES_ANO					VARCHAR(20)		-- 01/01-05/01 de 2014 -- Caso seja de 2ª a Domingo 
		--,TMPO_CD_DIA_SEMANA_ANO_CALENDARIO		INT				-- 201401
		--,TMPO_DS_DIA_SEMANA_ANO_CALENDARIO		VARCHAR(15)		-- 1ª Semana/2014
		--,TMPO_CD_DIA_SEMANA_ANO_FISCAL			INT				-- 201327
		--,TMPO_DS_DIA_SEMANA_ANO_FISCAL			VARCHAR(15)		-- 27ª Semana/2013
		,TMPO_CD_DIA_UTIL						INT				-- 1 Dia Util - 0 Feriado ou Fim de Semana, idS dos Feriados do Pais
		,TMPO_DS_DIA_UTIL						VARCHAR(50)		-- Dia Útil, Fim de Semana, Páscoa, Natal...
		
		,TMPO_CD_FERIADO						INT				-- 1 - Ano Novo - 2 - Carnaval
		,TMPO_DS_FERIADO						VARCHAR(50)		-- Ano Novo,Carnaval
		,TMPO_CD_MES_CALENDARIO					INT				-- 201401
		,TMPO_DS_MES_CALENDARIO					VARCHAR(15)		-- Jan/2014

		,TMPO_CD_MESNUM_CALENDARIO					INT				-- 201401
		,TMPO_DS_MESNUM_CALENDARIO					VARCHAR(15)		-- 01/14

		,TMPO_CD_BIMESTRE_CALENDARIO			INT				-- 201401
		,TMPO_DS_BIMESTRE_CALENDARIO			VARCHAR(20)		-- 1ºBim/2014
		,TMPO_CD_TRIMESTRE_CALENDARIO			INT				-- 201401
		,TMPO_DS_TRIMESTRE_CALENDARIO			VARCHAR(20)		-- 1ºTri/2014
	
		,TMPO_CD_SEMESTRE_CALENDARIO			INT				-- 201401
		,TMPO_DS_SEMESTRE_CALENDARIO			VARCHAR(25)		-- 1ºSem/2014
		,TMPO_CD_ANO_CALENDARIO					INT				-- 2014
		,TMPO_DS_ANO_CALENDARIO					VARCHAR(10)		-- Ano/2014
		,CONSTRAINT PK_DIM_0003_IDC_001 PRIMARY KEY CLUSTERED (TMPO_ID_TEMPO)
		,INDEX IX_DIM_0003_IDX_002 NONCLUSTERED (TMPO_DT_DATA)
	)

GO



BEGIN
	-- =============================================================================================
	-- Inicio do Desenvolvimento
	-- =============================================================================================
		-- ============================================	
		-- Variáveis para Cálculo da Páscoa
		-- ============================================		
		DECLARE 
			@int_A								INT			--A = o resto de (Ano ÷ 19)
			,@int_B								INT			--B = o inteiro de (Ano ÷ 100)
			,@int_C								INT			--C = o resto de (Ano ÷ 100) 
			,@int_D								INT			--D = o inteiro de (B ÷ 4)
			,@int_E								INT			--E = o resto de (B ÷ 4)
			,@int_F								INT			--F = o inteiro de [(B + 8) ÷ 25]
			,@int_G								INT			--G = o inteiro de [(B - F + 1) ÷ 3]
			,@int_H								INT			--H = o resto de [(19xA + B - D - G + 15) ÷ 30]
			,@int_I								INT			--I = o inteiro de (C ÷ 4)
			,@int_K								INT			--K = o resto de (C ÷ 4)
			,@int_L								INT			--L = o resto de [(32 + 2xE + 2xI - H - K) ÷ 7]
			,@int_M								INT			--M = o inteiro de [(A + 11xH + 22xL) ÷ 451]
			,@int_P								INT			--P = o inteiro de [(H + L - 7xM + 114) ÷ 31]
			,@int_Q								INT			--Q = o resto de [(H + L - 7xM + 114) ÷ 31]
			,@int_Data_Inicial					INT	
			,@int_Ano_Data_Inicial				INT	
			,@int_Data_Final					INT
			,@Data_Inserida						DATETIME
			,@dat_Feriado_Corrente				DATETIME							
					
			,@int_Cont							INT			
			,@int_Cont_Max						INT
			,@int_Ano_Calculo					INT
			,@int_Cont_Feriado					INT	
			,@int_Cont_Loop_Feriados			INT
		-- ============================================	
		-- Variáveis para os Feriados Fixos
		-- ============================================				
		DECLARE
			@dat_Ano_Novo						DATETIME
			,@dat_Tiradentes					DATETIME
			,@dat_Dia_Trabalho					DATETIME
			,@dat_Independencia					DATETIME
			,@dat_Nossa_Senhora_Aparecida		DATETIME
			,@dat_Finados						DATETIME
			,@dat_Proclamacao_Republica			DATETIME
			,@dat_Natal							DATETIME
			,@dat_Tiradentes_Pascoa_01			DATETIME
			,@dat_Tiradentes_Pascoa_02			DATETIME
			,@dat_Seg_Carnaval					DATETIME				
			,@dat_Carnaval						DATETIME									
			,@dat_Pascoa						DATETIME			
			,@dat_Corpus_Christi				DATETIME	

			,@des_Ano_Novo						VARCHAR(25) = 'Ano Novo'
			,@des_Tiradentes					VARCHAR(25) = 'Tiradentes'
			,@des_Dia_Trabalho					VARCHAR(25) = 'Dia do Trabalho'
			,@des_Independencia					VARCHAR(25) = 'Independência do Brasil'
			,@des_Nossa_Senhora_Aparecida		VARCHAR(25) = 'Dia de Nossa Senhora'
			,@des_Finados						VARCHAR(25) = 'Finados'
			,@des_Proclamacao_Republica			VARCHAR(25) = 'Proclamação da República'
			,@des_Natal							VARCHAR(25) = 'Natal'
			,@des_Tiradentes_Pascoa_01			VARCHAR(25)
			,@des_Tiradentes_Pascoa_02			VARCHAR(25)	
			,@des_Feriado_Corrente				VARCHAR(25)
			,@des_Seg_Carnaval					VARCHAR(25) = 'Segunda Carnaval'				
			,@des_Carnaval						VARCHAR(25)	= 'Carnaval'								
			,@des_Pascoa						VARCHAR(25)			
			,@des_Corpus_Christi				VARCHAR(25) = 'Corpus Christi'
					
		-- ============================================
		-- Seta as variáveis com os valores Iniciais
		-- ============================================					
		SET	@int_Data_Inicial			= 20150101 --YEAR(@pdat_Inicial)	
		set @int_Ano_Data_Inicial		= 2015
		SET @int_Data_Final				= 20501231
		SET @int_Cont					= 0 -- Variável que determina a quantiade de loop para os Anos
		SET @int_Cont_Max				= DATEDIFF(dd,CONVERT(VARCHAR(8),@int_Ano_Data_Inicial,112),CONVERT(VARCHAR(8),@int_Data_Final,112))
		SET @int_Cont_Feriado			= 0	
	
		-- ============================================				
		-- Inicia o Calculo da Páscoa
		-- ============================================				
		WHILE @int_Cont	< @int_Cont_Max + 1
		BEGIN
			-- ============================================				
			SET @int_Cont_Loop_Feriados			= 0	
			-- ============================================		
			-- ============================================				
			SET @dat_Ano_Novo					= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '0101'
			SET @dat_Tiradentes					= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '0421'
			SET @dat_Dia_Trabalho				= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '0501'
			SET	@dat_Independencia				= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '0907'
			SET @dat_Nossa_Senhora_Aparecida	= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '1012'
			SET	@dat_Finados					= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '1102'
			SET	@dat_Proclamacao_Republica		= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '1115'
			SET	@dat_Natal						= CAST(@int_Ano_Data_Inicial AS VARCHAR(4)) + '1225'			
			-- ============================================		
			SET @int_Ano_Calculo =  @int_Ano_Data_Inicial 
			-- ============================================			
			SET @int_A  = @int_Ano_Calculo % 19									--A = o resto de (Ano ÷ 19)
			SET @int_B	= @int_Ano_Calculo / 100								--B = o inteiro de (Ano ÷ 100)
			SET @int_C	= @int_Ano_Calculo % 100								--C = o resto de (Ano ÷ 100) 
			SET @int_D	= @int_B / 4											--D = o inteiro de (B ÷ 4)
			SET @int_E	= @int_B % 4											--E = o resto de (B ÷ 4)
			SET @int_F	= (@int_B + 8)/25										--F = o inteiro de [(B + 8) ÷ 25]
			SET @int_G	= (@int_B -@int_F + 1)/ 3								--G = o inteiro de [(B - F + 1) ÷ 3]
			SET @int_H	= ((19 * @int_A) + @int_B - @int_D -@int_G + 15)%30		--H = o resto de [(19xA +B- D- G+15)÷ 30]	
			SET @int_I	= @int_C/4												--I = o inteiro de (C ÷ 4)
			SET @int_K	= @int_C%4												--K = o resto de (C ÷ 4)
			SET @int_L	= (32 + (2*@int_E)+(2*@int_I) -@int_H -@int_K)%7		--L = o resto de [(32 + 2xE + 2xI - H - K) ÷ 7]
			SET @int_M	= (@int_A + (11 * @int_H)+ (22 * @int_L))/451			--M = o inteiro de [(A + 11xH + 22xL) ÷ 451]
			SET @int_P	= (@int_H + @int_L - (7 * @int_M)+114)/31				--P = o inteiro de [(H + L - 7xM + 114) ÷ 31]
			SET @int_Q	= ((@int_H + @int_L - (7 * @int_M)+114)%31)+ 1			--Q = o resto de [(H + L - 7xM + 114) ÷ 31]
			-- ============================================
			SET @dat_Pascoa			= DATEADD(dd,-2,CONVERT(DATETIME,CAST(@int_Ano_Calculo AS VARCHAR) + RIGHT('0' + CAST(@int_P AS VARCHAR),2) + RIGHT('0' + CAST(@int_Q AS VARCHAR),2),112))
			--SET @dat_Qua_Cinza		= DATEADD(dd,-44,@dat_Pascoa) 
			SET @dat_Carnaval		= DATEADD(dd,-45,@dat_Pascoa)
			SET @dat_Seg_Carnaval	= DATEADD(dd,-46,@dat_Pascoa)
			SET @dat_Corpus_Christi	= DATEADD(dd,62,@dat_Pascoa)							
			-- ============================================				
			SET @dat_Tiradentes_Pascoa_01	= CASE WHEN @dat_Tiradentes < @dat_Pascoa THEN @dat_Tiradentes ELSE @dat_Pascoa END	
			SET @dat_Tiradentes_Pascoa_02	= CASE WHEN @dat_Tiradentes < @dat_Pascoa THEN @dat_Pascoa ELSE @dat_Tiradentes END				
			
			SET @des_Tiradentes_Pascoa_01	= CASE WHEN @dat_Tiradentes < @dat_Pascoa THEN 'Tiradentes' ELSE 'Sexta-feira Santa' END	
			SET	@des_Tiradentes_Pascoa_02	= CASE WHEN @dat_Tiradentes < @dat_Pascoa THEN 'Sexta-feira Santa' ELSE 'Tiradentes' END				
					
			-- ============================================				
			-- Determina qual feriado irá validar
			-- ============================================			
			SET @dat_Feriado_Corrente = 
				CASE @int_Cont_Loop_Feriados 
					WHEN 0  THEN @dat_Ano_Novo					-- Ano Novo
					WHEN 1  THEN @dat_Seg_Carnaval				-- Segunda de Carnaval											
					WHEN 2  THEN @dat_Carnaval					-- Carnaval						
					WHEN 3  THEN @dat_Tiradentes_Pascoa_01		-- Tiradentes/Páscoa  
					WHEN 4  THEN @dat_Tiradentes_Pascoa_02		-- Páscoa / Tiradentes
					WHEN 5  THEN @dat_Dia_Trabalho				-- Dia do Trabalho
					WHEN 6  THEN @dat_Corpus_Christi			-- Corpus Christi
					WHEN 7  THEN @dat_Independencia				-- Indepêndencia
					WHEN 8  THEN @dat_Nossa_Senhora_Aparecida	-- Nossa Senhora Aparecida
					WHEN 9  THEN @dat_Finados					-- Finados
					WHEN 10 THEN @dat_Proclamacao_Republica		-- Proclamação da República
					WHEN 11 THEN @dat_Natal						-- Natal
				END	
			
			SET @des_Feriado_Corrente = 
				CASE CAST(@int_Cont_Loop_Feriados AS VARCHAR)
					WHEN '0'  THEN @des_Ano_Novo					-- Ano Novo
					WHEN '1'  THEN @des_Seg_Carnaval				-- Segunda de Carnaval											
					WHEN '2'  THEN @des_Carnaval					-- Carnaval						
					WHEN '3'  THEN @des_Tiradentes_Pascoa_01		-- Tiradentes/Páscoa  
					WHEN '4'  THEN @des_Tiradentes_Pascoa_02		-- Páscoa / Tiradentes
					WHEN '5'  THEN @des_Dia_Trabalho				-- Dia do Trabalho
					WHEN '6'  THEN @des_Corpus_Christi			-- Corpus Christi
					WHEN '7'  THEN @des_Independencia				-- Indepêndencia
					WHEN '8'  THEN @des_Nossa_Senhora_Aparecida	-- Nossa Senhora Aparecida
					WHEN '9'  THEN @des_Finados					-- Finados
					WHEN '10' THEN @des_Proclamacao_Republica		-- Proclamação da República
					WHEN '11' THEN @des_Natal						-- Natal
				END		
				-- ============================================				
				-- Adiciona o Proximo Feriado
				-- ============================================
				SET @Data_Inserida = CONVERT(VARCHAR(8),@int_Data_Inicial,112)
			
				IF @Data_Inserida = @dat_Feriado_Corrente 
				BEGIN					
					SET @int_Cont_Loop_Feriados = @int_Cont_Loop_Feriados + 1						
				END
				ELSE
					SET @des_Feriado_Corrente = 'Não Feriado'
			-- ============================================				
			-- Insere os Dados na Dimensão Tempo
			-- ============================================	
			INSERT INTO
				DIM_CALENDARIO
				(
					TMPO_ID_TEMPO							
					,TMPO_DT_DATA							-- 20140401
					,TMPO_DS_DATA							-- 01/01/2014
					,TMPO_CD_DIA_SEMANA						-- 20140414
					,TMPO_DS_DIA_SEMANA						-- 1ª Quarta
					,TMPO_NR_DIA_SEMANA
					
					,TMPO_CD_DIA_UTIL						-- 1 Dia Util - 0 Feriado ou Fim de Semana, idS dos Feriados do Pais
					,TMPO_DS_DIA_UTIL						-- Dia Útil, Fim de Semana, Páscoa, Natal...
				

					,TMPO_CD_FERIADO						-- 1 - Ano Novo - 2 - Carnaval
					,TMPO_DS_FERIADO						-- Ano Novo,Carnaval
					,TMPO_CD_MES_CALENDARIO					-- 201401
					,TMPO_DS_MES_CALENDARIO					-- Jan/2014

					,TMPO_CD_MESNUM_CALENDARIO				-- 201401
					,TMPO_DS_MESNUM_CALENDARIO				-- 01/2014

					,TMPO_CD_BIMESTRE_CALENDARIO			-- 201401
					,TMPO_DS_BIMESTRE_CALENDARIO			-- 1ºBim/2014
					,TMPO_CD_TRIMESTRE_CALENDARIO			-- 201401
					,TMPO_DS_TRIMESTRE_CALENDARIO			-- 1ºTri/2014
		
					,TMPO_CD_SEMESTRE_CALENDARIO			-- 201401
					,TMPO_DS_SEMESTRE_CALENDARIO			-- 1ºSem/2014
					,TMPO_CD_ANO_CALENDARIO					-- 2014
					,TMPO_DS_ANO_CALENDARIO					-- Ano/2014		
				)
			SELECT
				TMPO_ID_TEMPO							=	@int_Data_Inicial	
				,TMPO_DT_DATA							=	@Data_Inserida-- 20140401
				,TMPO_DS_DATA							=	CONVERT(VARCHAR(10),@Data_Inserida,103) -- 01/01/2014				
				,TMPO_CD_DIA_SEMANA						=	CONVERT(VARCHAR(6),@Data_Inserida,112) + '0' + CAST(DATEPART(dw,@Data_Inserida) AS VARCHAR) -- 20140414
				,TMPO_DS_DIA_SEMANA						=	UPPER(DATENAME(dw,@Data_Inserida)) -- 1ª Quarta
				,TMPO_NR_DIA_SEMANA						=	DATEPART(dw,@Data_Inserida)

				,TMPO_CD_DIA_UTIL						=	CASE WHEN DATEPART(dw,@Data_Inserida) NOT IN (1,7) AND @Data_Inserida <> @dat_Feriado_Corrente  THEN 1  ELSE 0 END -- 1 Dia Util - 0 Feriado ou Fim de Semana, idS dos Feriados do Pais
				,TMPO_DS_DIA_UTIL						=	CASE WHEN DATEPART(dw,@Data_Inserida) NOT IN (1,7) AND @Data_Inserida <> @dat_Feriado_Corrente  THEN 'DIA UTIL'  ELSE CASE WHEN @Data_Inserida = @dat_Feriado_Corrente THEN 'FERIADO' ELSE 'FIM DE SEMANA' END END -- Dia Útil, Fim de Semana, Páscoa, Natal...				
				,TMPO_CD_FERIADO						=	@int_Cont_Loop_Feriados -- 1 - Ano Novo - 2 - Carnaval
				,TMPO_DS_FERIADO						=	@des_Feriado_Corrente -- Ano Novo,Carnaval
				,TMPO_CD_MES_CALENDARIO					=	CONVERT(VARCHAR(6),@Data_Inserida,112) -- 201401
				,TMPO_DS_MES_CALENDARIO					=	UPPER(LEFT(DATENAME(mm,@Data_Inserida),3)) +'/' + CAST(YEAR( @Data_Inserida) AS VARCHAR(4)) -- Jan/2014
				
				,TMPO_CD_MESNUM_CALENDARIO				=	CONVERT(VARCHAR(6),@Data_Inserida,112) -- 201401
				,TMPO_DS_MESNUM_CALENDARIO				=	CASE WHEN DATEPART(mm,@Data_Inserida) <10 THEN '0' + CAST(DATEPART(mm,@Data_Inserida) AS VARCHAR) + '/' + CAST(YEAR( @Data_Inserida) AS VARCHAR(4)) ELSE CAST(DATEPART(mm,@Data_Inserida) AS VARCHAR) + '/' + CAST(YEAR( @Data_Inserida) AS VARCHAR(4)) END
				
				,TMPO_CD_BIMESTRE_CALENDARIO			=	CASE 
																WHEN MONTH(@Data_Inserida)  IN (1,2)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '01' 
		 														WHEN MONTH(@Data_Inserida)  IN (3,4)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '02' 
																WHEN MONTH(@Data_Inserida)  IN (5,6)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '03' 
																WHEN MONTH(@Data_Inserida)  IN (7,8)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '04' 
																WHEN MONTH(@Data_Inserida)  IN (9,10)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '05' 
															ELSE
																CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '06' 	
															END
															
				,TMPO_DS_BIMESTRE_CALENDARIO			=	CASE 
																WHEN MONTH(@Data_Inserida)  IN (1,2)	THEN '1ºBIM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 
																WHEN MONTH(@Data_Inserida)  IN (3,4)	THEN '2ºBIM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4))  
																WHEN MONTH(@Data_Inserida)  IN (5,6)	THEN '3ºBIM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4))  
																WHEN MONTH(@Data_Inserida)  IN (7,8)	THEN '4ºBIM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 
																WHEN MONTH(@Data_Inserida)  IN (9,10)	THEN '5ºBIM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4))  
															ELSE
																'6ºBIM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 	
															END -- 1ºBim/2014
				,TMPO_CD_TRIMESTRE_CALENDARIO			=	CASE 
																WHEN MONTH(@Data_Inserida)  IN (1,2,3)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '01' 
																WHEN MONTH(@Data_Inserida)  IN (4,5,6)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '02' 
																WHEN MONTH(@Data_Inserida)  IN (7,8,9)	THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '03' 																 
															ELSE
																CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '04' 	
															END -- 201401
				,TMPO_DS_TRIMESTRE_CALENDARIO			= CASE 
																WHEN MONTH(@Data_Inserida)  IN (1,2,3)	THEN '1ºTRI/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 
																WHEN MONTH(@Data_Inserida)  IN (4,5,6)	THEN '2ºTRI/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 
																WHEN MONTH(@Data_Inserida)  IN (7,8,9)	THEN '3ºTRI/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4))  																 
															ELSE
																'4ºTRI/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 	
															END  -- 1ºTri/2014
			
				,TMPO_CD_SEMESTRE_CALENDARIO			=	CASE 
																WHEN MONTH(@Data_Inserida) <=6		THEN CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '01' 																
															ELSE
																CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) + '02' 	
															END -- 201401
				,TMPO_DS_SEMESTRE_CALENDARIO			=	CASE 
																WHEN MONTH(@Data_Inserida) <=6		THEN '1ºSEM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4))  																
															ELSE
																'2ºSEM/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 	
															END -- 1ºSem/2014
				,TMPO_CD_ANO_CALENDARIO					=	YEAR(@Data_Inserida)-- 2014
				,TMPO_DS_ANO_CALENDARIO					=	'ANO/' + CAST(YEAR(@Data_Inserida) AS VARCHAR(4)) 
		
			-- ============================================				
			-- Loop dos Anos
			-- ============================================				
			SET @int_Data_Inicial = CONVERT(VARCHAR(8),DATEADD(DD,1,@Data_Inserida),112)
			SET @int_Cont = @int_Cont + 1
			
		END	
		
	-- =============================================================================================
	-- Fim desenvolvimento
	-- =============================================================================================			
	SELECT * FROM DIM_CALENDARIO
END

GO
