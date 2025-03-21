CREATE PROCEDURE random_position (@id_party INT)
AS
BEGIN
    DECLARE @position_col INT, @position_row INT;
    
    -- Récupérer les dimensions de la partie
    SELECT 
        @position_col = CAST(ROUND(RAND() * (nb_cols - 1), 0) AS INT),
        @position_row = CAST(ROUND(RAND() * (nb_rows - 1), 0) AS INT)
    FROM parties
    WHERE id_party = @id_party;
    
    -- Afficher les résultats (les positions générées)
    SELECT @position_col AS position_col, @position_row AS position_row;
END;




CREATE FUNCTION random_role()
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @role_description NVARCHAR(50);
    DECLARE @random_value INT;

    -- Utilisation de NEWID() pour générer une valeur aléatoire
    SET @random_value = ABS(CHECKSUM(NEWID())) % 2;  -- Génère un nombre entre 0 et 1

    -- Si @random_value est 0, alors 'loup', sinon 'villageois'
    IF @random_value = 0
    BEGIN
        SELECT @role_description = description_role
        FROM roles
        WHERE id_role = 1;  -- Loup
    END
    ELSE
    BEGIN
        SELECT @role_description = description_role
        FROM roles
        WHERE id_role = 2;  -- Villageois
    END

    -- Retourner le rôle sélectionné
    RETURN @role_description;
END;


CREATE FUNCTION get_the_winner(@id_party INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.id_player,
        p.pseudo,
        r.description_role AS role,
        CASE 
            WHEN pip.is_alive = 1 THEN 'Vivant'
            ELSE 'Éliminé'
        END AS status
    FROM players p
    JOIN players_in_parties pip ON p.id_player = pip.id_player
    JOIN roles r ON pip.id_role = r.id_role
    WHERE pip.id_party = @id_party AND pip.is_alive = 1
  
);
