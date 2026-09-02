CREATE
OR        REPLACE PROCEDURE ACCOUNT_LOGOUT (p_account_id TYPE_ID) AS $$
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

    IF NOT EXISTS (SELECT 1 FROM SESSION WHERE owner_id = v_id AND final_status = 'ACTIVE') THEN
        RAISE EXCEPTION 'no active session found for account' USING ERRCODE = '50005';
    END IF;

    CALL PR_ACCOUNT_LOGOUT(v_id);
END
$$ LANGUAGE plpgsql;