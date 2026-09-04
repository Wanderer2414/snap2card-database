CREATE
OR        REPLACE FUNCTION DAILY_LEARNED_COUNT (p_account_id TYPE_ID, p_date DATE)
    RETURNS INT AS $$
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = FN_ID_ACCOUNT(p_account_id)) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN FN_DAILY_LEARNED_CARDS(FN_ID_ACCOUNT(p_account_id), p_date);
END
$$ LANGUAGE plpgsql;
