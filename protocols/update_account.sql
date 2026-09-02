CREATE
OR        REPLACE FUNCTION UPDATE_ACCOUNT (
          p_account_id TYPE_ID,
          p_name TYPE_NAME_ACCOUNT,
          p_email TYPE_EMAIL,
          p_phone TYPE_PHONE
          ) RETURNS TYPE_ID AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_name IS NULL AND p_email IS NULL AND p_phone IS NULL THEN
        RAISE EXCEPTION 'at least one field must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_name IS NOT NULL AND length(p_name) > 60 THEN
        RAISE EXCEPTION 'name must not exceed 60 characters' USING ERRCODE = '50002';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_id := FN_ID_ACCOUNT(p_account_id);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_id) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN FN_ACCOUNT_ID(FN_UPDATE_ACCOUNT(v_id, p_name, p_email, p_phone));
END
$$ LANGUAGE plpgsql;