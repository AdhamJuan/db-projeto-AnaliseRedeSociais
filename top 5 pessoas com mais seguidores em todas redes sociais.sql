-- Seleciona os dados do usuário e sua quantidade de seguidores
SELECT
    u.id_usuario,
    u.nome AS nome_usuario,
    u.numero_usuarios AS total_seguidores  -- Campo que representa seguidores

-- Tabela principal de usuário
FROM usuario u

-- Ordena do usuário com mais seguidores para o menor
ORDER BY u.numero_usuarios DESC

-- Traz apenas os 5 primeiros colocados
LIMIT 5;
