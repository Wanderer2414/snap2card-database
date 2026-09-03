CREATE
OR        REPLACE FUNCTION FILE_INSERT (
          p_file_name TEXT            ,
          p_hash_code TEXT            ,
          p_file_type TYPE_FILE_TYPE  ,
          p_owner_id TYPE_ID
          ) RETURNS TABLE (file_id TYPE_ID, file_source TEXT) AS $$
DECLARE
    v_owner INT                        ;
    v_id    INT                        ;
    v_source TEXT                      ;
    v_file  RECORD                     ;
BEGIN
    IF p_file_name IS NULL THEN
        RAISE EXCEPTION 'file name must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_hash_code IS NULL THEN
        RAISE EXCEPTION 'hash code must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_file_type IS NULL THEN
        RAISE EXCEPTION 'file type must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_owner_id IS NULL THEN
        RAISE EXCEPTION 'owner id must not be null' USING ERRCODE = '50001';
    END IF;

    IF length(p_file_name) > 60 THEN
        RAISE EXCEPTION 'file name must not exceed 60 characters' USING ERRCODE = '50002';
    END IF;

    IF length(p_hash_code) > 64 THEN
        RAISE EXCEPTION 'hash code must not exceed 64 characters' USING ERRCODE = '50002';
    END IF;

    IF SUBSTRING(p_owner_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_owner_id);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'owner id does not exist' USING ERRCODE = '50004';
    END IF;

    SELECT out_file_id, out_file_source
      INTO v_id, v_source
      FROM FN_FILE_INSERT(p_file_name::TYPE_NAME_FILE, p_hash_code::CHAR(64), p_file_type, v_owner);

    file_id     := FN_FILE_ID(v_id);
    file_source := v_source;

    RETURN NEXT;
END
$$ LANGUAGE plpgsql;