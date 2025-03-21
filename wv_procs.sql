-- Procédure SEED_DATA
-- Crée autant de tours de jeu que la partie peut en accepter
CREATE PROCEDURE SEED_DATA
    @NB_PLAYERS INT, 
    @PARTY_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @nb_turns INT;
    DECLARE @current_turn INT = 1;
    DECLARE @start_time DATETIME;
    DECLARE @max_wait_time INT;
    
    -- Récupère le nombre de tours et le temps d'attente maximal pour la partie
    SELECT 
        @nb_turns = nb_turns,
        @max_wait_time = max_wait_time
    FROM 
        parties
    WHERE 
        id_party = @PARTY_ID;
    
    -- Si la partie n'existe pas, on sort
    IF @nb_turns IS NULL
    BEGIN
        RAISERROR('La partie spécifiée n''existe pas.', 16, 1);
        RETURN;
    END;
    
    -- Initialise la date de début
    SET @start_time = GETDATE();
    
    -- Crée les tours de jeu
    WHILE @current_turn <= @nb_turns
    BEGIN
        -- Insère un nouveau tour
        INSERT INTO turns (
            id_turn,
            id_party,
            start_time,
            end_time,
            turn_number,
            is_completed
        )
        VALUES (
            (SELECT ISNULL(MAX(id_turn), 0) + 1 FROM turns),
            @PARTY_ID,
            DATEADD(MINUTE, (@current_turn - 1) * @max_wait_time / 60, @start_time),
            NULL, -- end_time sera mis à jour une fois le tour terminé
            @current_turn,
            0 -- Tour non terminé
        );
        
        SET @current_turn = @current_turn + 1;
    END;
    
    -- Place aléatoirement les obstacles
    DECLARE @nb_obstacles INT;
    DECLARE @nb_rows INT;
    DECLARE @nb_cols INT;
    
    SELECT 
        @nb_obstacles = nb_obstacles,
        @nb_rows = nb_rows,
        @nb_cols = nb_cols
    FROM 
        parties
    WHERE 
        id_party = @PARTY_ID;
    
    DECLARE @obstacle_count INT = 0;
    DECLARE @col INT;
    DECLARE @row INT;
    
    -- Place les obstacles de manière aléatoire
    WHILE @obstacle_count < @nb_obstacles
    BEGIN
        SET @col = CAST(RAND() * @nb_cols AS INT);
        SET @row = CAST(RAND() * @nb_rows AS INT);
        
        -- Vérifie que la position n'est pas déjà occupée par un obstacle
        IF NOT EXISTS (
            SELECT 1 
            FROM players_in_parties 
            WHERE id_party = @PARTY_ID AND position_col = @col AND position_row = @row
        )
        BEGIN
            -- Insère l'obstacle en ajoutant un joueur spécial (joueur ID -1, rôle obstacle)
            INSERT INTO players_in_parties (
                id_party,
                id_player,
                id_role,
                is_alive,
                position_col,
                position_row
            )
            VALUES (
                @PARTY_ID,
                -1, -- ID spécial pour les obstacles
                -1, -- Rôle spécial pour les obstacles
                0,  -- Non vivant (obstacle)
                @col,
                @row
            );
            
            SET @obstacle_count = @obstacle_count + 1;
        END;
    END;
END;
GO

-- Procédure USERNAME_TO_LOWER
-- Met les noms des joueurs en minuscule
CREATE PROCEDURE USERNAME_TO_LOWER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Met à jour les pseudos des joueurs en minuscules
    UPDATE players
    SET pseudo = LOWER(pseudo)
    WHERE pseudo <> LOWER(pseudo);
END;
GO