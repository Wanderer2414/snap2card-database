CREATE
OR        REPLACE FUNCTION FN_ACCOUNT_AVATAR_RETRIEVE (p_id INT) RETURNS TYPE_ID AS $$
DECLARE
    v_avatar_id INT     ;
    v_avatar TYPE_ID;
BEGIN
    SELECT account_avatar INTO v_avatar_id FROM ACCOUNT WHERE account_id = p_id;

    IF v_avatar_id IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN FN_FILE_ID(v_avatar_id);
END;
$$ LANGUAGE plpgsql;