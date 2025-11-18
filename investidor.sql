CREATE DEFINER=`root`@`localhost` PROCEDURE `Investidor`()
BEGIN
SELECT 
        r.nome AS rede,

        -- Faturamento total formatado BR
        CONCAT(
			'R$ ',
			REPLACE(
				REPLACE(
					REPLACE(FORMAT(agg.total_faturamento, 2), ',', '#'),
                    '.',
                    ','
                ),
                '#',
                '.'
            )
        ) AS faturamento_total,

        -- Despesas totais formatadas BR
        CONCAT(
            'R$ ',
            REPLACE(
                REPLACE(
                    REPLACE(FORMAT(agg.total_despesas, 2), ',', '#'),
                    '.',
                    ','
                ),
                '#',
                '.'
            )
        ) AS despesas_totais,

        -- Lucro estimado total formatado BR
        CONCAT(
            'R$ ',
            REPLACE(
                REPLACE(
                    REPLACE(FORMAT(agg.total_lucro, 2), ',', '#'),
                    '.',
                    ','
                ),
                '#',
                '.'
            )
        ) AS lucro_estimado

    FROM (
        SELECT 
            f.id_redes_sociais,
            SUM(f.faturamento)              AS total_faturamento,
            SUM(f.despesas)                 AS total_despesas,
            SUM(f.faturamento - f.despesas) AS total_lucro
        FROM financas f
        GROUP BY f.id_redes_sociais
    ) AS agg
    JOIN redes_sociais r 
        ON r.id_redes_sociais = agg.id_redes_sociais
    ORDER BY agg.total_lucro DESC
    LIMIT 3;
END