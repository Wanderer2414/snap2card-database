-- CREATE    TABLE FILE (
--           file_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           file_source TEXT NOT NULL                            ,
--           owner_id INT NOT NULL                                ,
--           file_type TYPE_FILE_TYPE NOT NULL                    ,
--           date_created TIMESTAMPTZ DEFAULT NOW()               ,
--           FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
--           );
CREATE
OR        REPLACE FUNCTION FN_FILE_INSERT (p_file_source TEXT, p_file_type TYPE_FILE_TYPE, p_owner_id INT) RETURNS INT AS $$
DECLARE 
    v_id INT;
BEGIN
    INSERT INTO FILE(file_source, file_type, owner_id) VALUES (p_file_source, p_file_type, p_owner_id)
    RETURNING file_id INTO v_id;

    RETURN v_id;
END;
$$ LANGUAGE plpgsql;