CREATE
OR        REPLACE FUNCTION CARD_LIST (p_account_id TYPE_ID) RETURNS TABLE (card_id TYPE_ID, component_text TEXT) AS $$
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    RETURN QUERY
    SELECT FN_CARD_ID(C.card_id), C.component_text FROM FN_CARD_LIST(FN_ID_ACCOUNT(p_account_id)) AS C;
END
$$ LANGUAGE plpgsql;