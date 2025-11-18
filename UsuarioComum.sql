CREATE DEFINER=`root`@`localhost` PROCEDURE `UsuarioComum`()
BEGIN
SELECT 
        r.nome AS rede,

        -- CURTIDAS  formatado BR
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_curtir, 0), ',', '#'), '.', ','), '#', '.'
        ) AS curtir,

        -- COMENTÁRIOS formatado BR
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_comentario, 0), ',', '#'), '.', ','), '#', '.'
        ) AS comentario,

        -- COMPARTILHAMENTOS formatado BR
        
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_compartilhamento, 0), ',', '#'), '.', ','), '#', '.'
        ) AS compartilhamento,

        -- SEGUIR formatado BR
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_seguir, 0), ',', '#'), '.', ','), '#', '.'
        ) AS seguir,

        -- SALVAR formatado BR
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_salvar, 0), ',', '#'), '.', ','), '#', '.'
        ) AS salvar,

        -- VISUALIZAÇÕES formatado BR
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_visualizacao, 0), ',', '#'), '.', ','), '#', '.'
        ) AS visualizacao,

        -- SCORE SIMPLES (sem pesos), somando tudo e formatado BR
            REPLACE(
                REPLACE(
                    REPLACE(
                        FORMAT(
                              agg.total_curtir
                            + agg.total_comentario
                            + agg.total_compartilhamento
                            + agg.total_seguir
                            + agg.total_salvar
                            + agg.total_visualizacao
                        , 0),
                    ',', '#'),
                '.', ','),
            '#', '.'
        ) AS score_entretenimento

    FROM (
        --  SOMANDO TODAS AS LINHAS da tabela engajamento por rede
        SELECT 
            e.id_rede_social,
            SUM(e.curtir)           AS total_curtir,
            SUM(e.comentario)       AS total_comentario,
            SUM(e.compartilhamento) AS total_compartilhamento,
            SUM(e.seguir)           AS total_seguir,
            SUM(e.salvar)           AS total_salvar,
            SUM(e.visualizacao)     AS total_visualizacao
        FROM engajamento e
        GROUP BY e.id_rede_social
    ) AS agg
	
    -- JOIN da tabela "redes_sociais" com "engajamento" usando FK "id_redes_sociais"
    JOIN redes_sociais r ON r.id_redes_sociais = agg.id_rede_social
    ORDER BY score_entretenimento DESC
    LIMIT 7;
END