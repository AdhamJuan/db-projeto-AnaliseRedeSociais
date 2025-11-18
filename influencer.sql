CREATE DEFINER=`root`@`localhost` PROCEDURE `Influencer`()
BEGIN
    SELECT 
        r.nome AS rede,

        -- CURTIDAS (somatório) formatado BR
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_curtir, 0), ',', '#'), '.', ','), '#', '.'
        ) AS curtir,
        
        -- COMENTÁRIOS (somatório)
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_comentario, 0), ',', '#'), '.', ','), '#', '.'
        ) AS comentario,

        -- COMPARTILHAMENTOS (somatório)
        
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_compartilhamento, 0), ',', '#'), '.', ','), '#', '.'
        ) AS compartilhamento,

        -- SEGUIDORES (somatório)
       
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_seguir, 0), ',', '#'), '.', ','), '#', '.'
        ) AS seguir,

        -- SALVOS (somatório)
       
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_salvar, 0), ',', '#'), '.', ','), '#', '.'
        ) AS salvar,

        -- VISUALIZAÇÕES (somatório)
       
            REPLACE(REPLACE(REPLACE(FORMAT(agg.total_visualizacao, 0), ',', '#'), '.', ','), '#', '.'
        ) AS visualizacao,

        -- SCORE BRUTO (antes do fator) – opcional pra você olhar
        ROUND(agg.raw_score, 0) AS score_bruto,

        -- SCORE AJUSTADO (com fator por plataforma), formatado BR, sem casas decimais
            REPLACE(
                REPLACE(
                    REPLACE(
                        FORMAT(agg.raw_score * 
                            CASE 
                                WHEN r.nome = 'Instagram' THEN 1.30
                                WHEN r.nome = 'TikTok'    THEN 1.25
                                WHEN r.nome = 'YouTube'   THEN 1.20
                                WHEN r.nome = 'Facebook'  THEN 1.05
                                WHEN r.nome = 'X/Twitter' THEN 1.00
                                WHEN r.nome = 'Pinterest' THEN 0.90
                                WHEN r.nome = 'LinkedIn'  THEN 0.80
                                ELSE 1.00
                            END
                        , 0),
                    ',', '#'),
                '.', ','),
            '#', '.'
        ) AS score_influencer

    FROM (
        -- SOMA TODAS AS LINHAS DE ENGAJAMENTO POR REDE
        SELECT 
            e.id_rede_social,
            SUM(e.curtir)           AS total_curtir,
            SUM(e.comentario)       AS total_comentario,
            SUM(e.compartilhamento) AS total_compartilhamento,
            SUM(e.seguir)           AS total_seguir,
            SUM(e.salvar)           AS total_salvar,
            SUM(e.visualizacao)     AS total_visualizacao,

            -- score bruto ponderado por engajamento
            (
                SUM(e.curtir)
              + SUM(e.comentario)       * 1.5
              + SUM(e.compartilhamento) * 2
              + SUM(e.seguir)           * 1.2
              + SUM(e.salvar)           * 1.3
              + SUM(e.visualizacao)     * 0.3
            ) AS raw_score
        FROM engajamento e
        GROUP BY e.id_rede_social
    ) AS agg
    JOIN redes_sociais r ON r.id_redes_sociais = agg.id_rede_social

    -- ORDENAR PELO SCORE AJUSTADO 
    ORDER BY 
        agg.raw_score * 
            CASE 
                WHEN r.nome = 'Instagram' THEN 1.30
                WHEN r.nome = 'TikTok'    THEN 1.25
                WHEN r.nome = 'YouTube'   THEN 1.20
                WHEN r.nome = 'Facebook'  THEN 1.05
                WHEN r.nome = 'X/Twitter' THEN 1.00
                WHEN r.nome = 'Pinterest' THEN 0.90
                WHEN r.nome = 'LinkedIn'  THEN 0.80
                ELSE 1.00
            END
    DESC
    LIMIT 3;
END