DROP TRIGGER IF EXISTS hash_password_trigger ON Users;
DROP TRIGGER IF EXISTS genome_consistent ON GenInGenome;

CREATE OR REPLACE FUNCTION hash_user_password()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.password := md5(NEW.password);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER hash_password_trigger
    BEFORE INSERT OR UPDATE ON Users
    FOR EACH ROW
EXECUTE FUNCTION hash_user_password();


CREATE OR REPLACE FUNCTION check_genome_consistent()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) AS GE FROM GenInGenome WHERE genome_id = NEW.genome_id) <> 8 THEN
        RAISE EXCEPTION 'Genome must consist only with 8 gens.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER genome_consistent
    AFTER INSERT ON GenInGenome
    FOR EACH ROW
EXECUTE FUNCTION check_genome_consistent();


--
--
-- CREATE OR REPLACE FUNCTION get_user_saves (user_id INT)
--     RETURNS TABLE(save_id INT, name VARCHAR, create_time TIMESTAMP) AS $$
-- BEGIN
--     RETURN QUERY
--         SELECT uid, name, create_time
--         FROM Save
--         WHERE user_id = user_id;  -- Предположим, что у вас есть связь с пользователем
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE OR REPLACE FUNCTION update_cell_state (cell_id INT, new_state VARCHAR)
--     RETURNS VOID AS $$
-- BEGIN
--     UPDATE Cell
--     SET state = new_state
--     WHERE uid = cell_id;
--
--     IF NOT FOUND THEN
--         RAISE EXCEPTION 'Клетка с id % не найдена', cell_id;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE OR REPLACE FUNCTION delete_old_saves (days_old INT)
--     RETURNS VOID AS $$
-- BEGIN
--     DELETE FROM Save
--     WHERE create_time < NOW() - INTERVAL '1 day' * days_old;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- ALTER TABLE Save ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
-- CREATE OR REPLACE FUNCTION update_last_modified()
--     RETURNS TRIGGER AS $$
-- BEGIN
--     NEW.last_updated := CURRENT_TIMESTAMP;  -- Устанавливаем текущее время
--     RETURN NEW;  -- Возвращаем обновленную запись
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE TRIGGER trg_update_last_modified
--     BEFORE UPDATE ON Save
--     FOR EACH ROW EXECUTE FUNCTION update_last_modified();