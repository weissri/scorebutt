CREATE TABLE passwords 
( pw_id integer PRIMARY KEY
, hash text NOT NULL
, salt text NOT NULL
);

CREATE TABLE users
( user_id serial PRIMARY KEY
, pw_id integer NOT NULL REFERENCES passwords(pw_id)
, user_name text UNIQUE NOT NULL
, user_email text UNIQUE NOT NULL
, user_join_date timestamp NOT NULL
);

CREATE TABLE teams
( team_id serial PRIMARY KEY
, team_name text NOT NULL
, team_date timestamp NOT NULL
);

-- A user can belong to multiple teams
CREATE TABLE players
( player_id serial PRIMARY KEY
, user_id integer NOT NULL REFERENCES users(user_id)
, team_id integer NOT NULL REFERENCES teams(team_id)
, CONSTRAINT unique_team_members UNIQUE (user_id, team_id)
);

-- A Played Session
CREATE TABLE games
( game_id serial PRIMARY KEY
, game_begin timestamp NOT NULL
, game_end timestamp
, game_victor integer REFERENCES teams(team_id)
);

-- Teams involved in a game
CREATE TABLE game_teams
( game_team_id serial PRIMARY KEY
, game_id integer NOT NULL REFERENCES games(game_id)
, team_id integer NOT NULL REFERENCES teams(team_id)
, team_points integer NOT NULL
, CONSTRAINT unique_game_teams UNIQUE (game_id, team_id)
);

-- An event that occurs during a game (usually awarding/penalizing some points to a team)
CREATE TABLE events
( event_id serial PRIMARY KEY
, game_team_id integer NOT NULL REFERENCES game_teams(game_team_id)
, event_time timestamp NOT NULL
, event_points integer NOT NULL
, details text NOT NULL
);