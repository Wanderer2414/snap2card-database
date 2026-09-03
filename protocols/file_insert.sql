CREATE
OR        REPLACE FUNCTION FILE_INSERT (
          p_file_source TEXT          ,
          p_file_type TYPE_FILE_TYPE  ,
          p_owner_id TYPE_ID
          ) RETURNS TYPE_ID AS $$
DECLARE
    v_owner INT;
BEGIN
    IF p_file_source IS NULL THEN
        RAISE EXCEPTION 'file source must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_file_type IS NULL THEN
        RAISE EXCEPTION 'file type must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_owner_id IS NULL THEN
        RAISE EXCEPTION 'owner id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_owner_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_owner_id);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'owner id does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN FN_FILE_ID(FN_FILE_INSERT(p_file_source, p_file_type, v_owner));
END
$$ LANGUAGE plpgsql;