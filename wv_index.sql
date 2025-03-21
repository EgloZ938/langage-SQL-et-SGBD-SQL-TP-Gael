-- Ajouter les contraintes NOT NULL
ALTER TABLE parties ALTER COLUMN id_party INT NOT NULL;
ALTER TABLE parties ALTER COLUMN title_party NVARCHAR(100) NOT NULL;

ALTER TABLE roles ALTER COLUMN id_role INT NOT NULL;
ALTER TABLE roles ALTER COLUMN description_role NVARCHAR(50) NOT NULL;

ALTER TABLE players ALTER COLUMN id_player INT NOT NULL;
ALTER TABLE players ALTER COLUMN pseudo NVARCHAR(50) NOT NULL;

ALTER TABLE players_in_parties ALTER COLUMN id_party INT NOT NULL;
ALTER TABLE players_in_parties ALTER COLUMN id_player INT NOT NULL;
ALTER TABLE players_in_parties ALTER COLUMN id_role INT NOT NULL;

ALTER TABLE turns ALTER COLUMN id_turn INT NOT NULL;
ALTER TABLE turns ALTER COLUMN id_party INT NOT NULL;
ALTER TABLE turns ALTER COLUMN start_time DATETIME NOT NULL;
ALTER TABLE turns ALTER COLUMN end_time DATETIME NULL;

ALTER TABLE players_play ALTER COLUMN id_player INT NOT NULL;
ALTER TABLE players_play ALTER COLUMN id_turn INT NOT NULL;
ALTER TABLE players_play ALTER COLUMN start_time DATETIME NOT NULL;
ALTER TABLE players_play ALTER COLUMN end_time DATETIME NULL;
ALTER TABLE players_play ALTER COLUMN action NVARCHAR(10) NULL;

ALTER TABLE players_play DROP COLUMN origin_position_col;
ALTER TABLE players_play DROP COLUMN origin_position_row;
ALTER TABLE players_play DROP COLUMN target_position_col;
ALTER TABLE players_play DROP COLUMN target_position_row;

ALTER TABLE players_play ADD origin_position_col INT NULL;
ALTER TABLE players_play ADD origin_position_row INT NULL;
ALTER TABLE players_play ADD target_position_col INT NULL;
ALTER TABLE players_play ADD target_position_row INT NULL;

-- Ajouter les colonnes pour les paramètres de jeu
ALTER TABLE parties ADD nb_rows INT NOT NULL DEFAULT 10;
ALTER TABLE parties ADD nb_cols INT NOT NULL DEFAULT 10;
ALTER TABLE parties ADD max_wait_time INT NOT NULL DEFAULT 30;
ALTER TABLE parties ADD nb_turns INT NOT NULL DEFAULT 20;
ALTER TABLE parties ADD nb_obstacles INT NOT NULL DEFAULT 5;
ALTER TABLE parties ADD max_players INT NOT NULL DEFAULT 10;
ALTER TABLE parties ADD is_completed BIT NOT NULL DEFAULT 0;

-- Ajouter les colonnes pour la position des joueurs
-- ALTER TABLE players_in_parties ALTER COLUMN is_alive BIT NOT NULL DEFAULT 1;
ALTER TABLE players_in_parties DROP column is_alive;
ALTER TABLE players_in_parties ADD is_alive BIT NOT NULL default 1;
ALTER TABLE players_in_parties ADD position_col INT NOT NULL DEFAULT 0;
ALTER TABLE players_in_parties ADD position_row INT NOT NULL DEFAULT 0;

-- Ajouter les colonnes pour les tours
ALTER TABLE turns ADD turn_number INT NOT NULL DEFAULT 1;
ALTER TABLE turns ADD is_completed BIT NOT NULL DEFAULT 0;


-- Insérer les rôles de base
IF NOT EXISTS (SELECT 1 FROM roles WHERE id_role = 1)
    INSERT INTO roles (id_role, description_role) VALUES (1, 'loup');
IF NOT EXISTS (SELECT 1 FROM roles WHERE id_role = 2)
    INSERT INTO roles (id_role, description_role) VALUES (2, 'villageois');