
--
-- INSERT INTO Achievements (name, description, condition_desc) VALUES
--     ('Achievement 1', 'Description 1', 'Condition 1'),
--     ('Achievement 2', 'Description 2', 'Condition 2');

INSERT INTO sequencedbank (name) VALUES
    ('Tipas_Bank');

INSERT INTO users (login, password, bank_id) VALUES
    ('Tipa2', 'Tupa', 1);




INSERT INTO GEN (name, description) VALUES
    ('A', 'A - Work'),
    ('B', 'B - Sleep'),
    ('C', 'C - Die'),
    ('D', 'D - Boom'),
    ('E', 'E - Eat');

INSERT INTO Genome (name) VALUES
    ('Genome 3');

SELECT COUNT(*) FROM GenInGenome WHERE genome_id = 1;

-- BEGIN;
INSERT INTO GenInGenome (genome_id, gen_id) VALUES
      (3, 1),
      (3, 1),
      (3, 1),
      (3, 1),

      (3, 1),
      (3, 1),
      (3, 1),
      (3, 1);
-- COMMIT;

