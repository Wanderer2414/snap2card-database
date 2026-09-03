CREATE
OR        REPLACE FUNCTION UPDATE_ACCOUNT (
          p_account_id TYPE_ID,
          p_name TYPE_NAME_ACCOUNT,
          p_email TYPE_EMAIL,
          p_phone TYPE_PHONE,
          p_avatar TYPE_ID,
          p_daily_goal INT
          ) RETURNS TYPE_ID AS $$
DECLARE
    v_id INT;
    v_avatar INT;
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_name IS NULL AND p_email IS NULL AND p_phone IS NULL AND p_avatar IS NULL AND p_daily_goal IS NULL THEN
        RAISE EXCEPTION 'at least one field must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_name IS NOT NULL AND length(p_name) > 60 THEN
        RAISE EXCEPTION 'name must not exceed 60 characters' USING ERRCODE = '50002';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    IF p_avatar IS NOT NULL AND SUBSTRING(p_avatar, 1, 4) <> 'FILE' THEN
        RAISE EXCEPTION 'invalid file id format' USING ERRCODE = '50006';
    END IF;

    v_id := FN_ID_ACCOUNT(p_account_id);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_id) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    IF p_avatar IS NOT NULL THEN
        v_avatar := FN_ID_FILE(p_avatar);

        IF NOT EXISTS (SELECT 1 FROM FILE WHERE file_id = v_avatar) THEN
            RAISE EXCEPTION 'file not found' USING ERRCODE = '50004';
        END IF;
    END IF;

    RETURN FN_ACCOUNT_ID(FN_UPDATE_ACCOUNT(v_id, p_name, p_email, p_phone, v_avatar, p_daily_goal));
END
$$ LANGUAGE plpgsql;