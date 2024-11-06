DROP TYPE IF EXISTS field_type_enum CASCADE;
DROP TYPE IF EXISTS cell_state_enum CASCADE;

CREATE TYPE field_type_enum AS ENUM ('square', 'cylinder', 'torus');
CREATE TYPE cell_state_enum AS ENUM ('dead', 'alive');

CREATE TABLE IF NOT EXISTS Gen (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS SequencedBank (
     uid SERIAL PRIMARY KEY,
     name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Achievements (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL ,
    description TEXT,
    condition_desc TEXT
);

CREATE TABLE IF NOT EXISTS Settings (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100),
    field_type field_type_enum NOT NULL
);


CREATE TABLE IF NOT EXISTS Users (
    uid SERIAL PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    bank_id INT REFERENCES SequencedBank(uid) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Save (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    settings_id INT REFERENCES Settings(uid) ON DELETE CASCADE,
    user_id INT REFERENCES Users(uid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Simulation (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    settings_id INT REFERENCES Settings(uid) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Genome (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS SequencedGenome (
   uid SERIAL PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   genome_id INT REFERENCES Genome(uid) ON DELETE CASCADE,
   bank_id INT REFERENCES SequencedBank(uid) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Cell (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    x_pos INT NOT NULL,
    y_pos INT NOT NULL,
    state cell_state_enum NOT NULL,
    genome_id INT REFERENCES Genome(uid) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS CellSettings (
    uid SERIAL PRIMARY KEY,
    settings_id INT REFERENCES Settings(uid) ON DELETE CASCADE,
    cell_id INT REFERENCES Cell(uid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS GenInGenome (
    uid SERIAL PRIMARY KEY,
    genome_id INT REFERENCES Genome(uid) ON DELETE CASCADE,
    gen_id INT REFERENCES Gen(uid) ON DELETE CASCADE
);

-- Таблица для хранения статистики
CREATE TABLE IF NOT EXISTS Statistics (
    uid SERIAL PRIMARY KEY,
    name VARCHAR(100),
    run_time TIMESTAMP,
    mutation_amount INT,
    average_lifetime INT,
    sim_ticks INT,
    simulation_id INT REFERENCES Simulation(uid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS GenomeStatistics (
    uid SERIAL PRIMARY KEY,
    statistics_id INT REFERENCES Statistics(uid) ON DELETE CASCADE,
    genome_id INT REFERENCES Genome(uid) ON DELETE CASCADE
);

-- CREATE INDEX IF NOT EXISTS idx_genome_gen_id ON Genome (gen_id);
-- CREATE INDEX IF NOT EXISTS idx_save_name ON Save (name);
-- CREATE INDEX IF NOT EXISTS idx_statistics_simulation_id ON Statistics (simulation_id);
-- CREATE INDEX IF NOT EXISTS idx_cell_settings_id ON Cell (genome_id);
-- CREATE INDEX IF NOT EXISTS idx_save_create_time ON Save (create_time);