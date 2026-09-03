CREATE
OR        REPLACE FUNCTION FN_FILE_INSERT (
          p_file_name TYPE_NAME_FILE,
          p_hash_code CHAR(64)      ,
          p_file_type TYPE_FILE_TYPE,
          p_owner_id INT
          ) RETURNS TABLE (out_file_id INT, out_file_source TEXT) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO FILE (file_name, hash_code, file_type, owner_id)
    VALUES (p_file_name, p_hash_code, p_file_type, p_owner_id)
    ON CONFLICT (file_name, hash_code)
    DO NOTHING
    RETURNING file_id, file_source
    INTO out_file_id, out_file_source;

    IF NOT FOUND THEN
        SELECT f.file_id, f.file_source
        INTO out_file_id, out_file_source
        FROM file AS f
        WHERE f.file_name = p_file_name
          AND f.hash_code = p_hash_code;
    END IF;

    RETURN NEXT;
END;
$$;