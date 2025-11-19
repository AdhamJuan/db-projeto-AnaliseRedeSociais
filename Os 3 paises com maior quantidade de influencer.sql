-- Seleciona o país e a contagem de pessoas que são influencers
SELECT 
    pais.nome AS pais,
    COUNT(p.id_pessoas) AS total_influencers

-- Tabela raiz do endereço
FROM pais

-- Conecta o país → estado
JOIN estado est
    ON est.id_pais = pais.id_pais

-- Conecta estado → cidade
JOIN cidade cid
    ON cid.id_estado = est.id_estado

-- Conecta cidade → bairro
JOIN bairro bai
    ON bai.id_cidade_fk = cid.id_cidade    -- IMPORTANTE: nome correto da coluna!

-- Conecta bairro → rua
JOIN rua r
    ON r.id_bairro = bai.id_bairro

-- Conecta rua → pessoas
JOIN pessoas p
    ON p.id_rua = r.id_rua

-- Conecta pessoas → categoria intermediária
JOIN categoria_pessoa_intermediaria cpi
    ON cpi.Pessoas_id_pessoas = p.id_pessoas

-- Conecta categoria → tipo de pessoa
JOIN categoria_pessoa cp
    ON cp.id_tipo_pessoa = cpi.Tipo_Pessoa_id_tipo_pessoa

-- Filtra somente pessoas que são influencers
WHERE cp.influencer = 'S'

-- Agrupa por país
GROUP BY pais.nome

-- Ordena do país com mais influencers para o menor
ORDER BY total_influencers DESC

-- Traz somente o TOP 10
LIMIT 10;
