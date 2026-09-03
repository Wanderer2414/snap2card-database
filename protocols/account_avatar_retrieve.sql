CREATE
OR        REPLACE FUNCTION ACCOUNT_AVATAR_RETRIEVE (p_account_id TYPE_ID) RETURNS TYPE_ID AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_id := FN_ID_ACCOUNT(p_account_id);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_id) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN FN_ACCOUNT_AVATAR_RETRIEVE(v_id);
END
$$ LANGUAGE plpgsql;