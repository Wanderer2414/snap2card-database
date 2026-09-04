CREATE
OR        REPLACE FUNCTION CATEGORY_NOT_HAVE_CARD (p_account_id TYPE_ID, p_card_id TYPE_ID)
    RETURNS TABLE (category_id TYPE_ID, category_name TYPE_NAME_CATEGORY) AS $$
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_card_id IS NULL THEN
        RAISE EXCEPTION 'card id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_card_id, 1, 4) <> 'CARD' THEN
        RAISE EXCEPTION 'invalid card id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = FN_ID_ACCOUNT(p_account_id)) THEN
        RAISE EXCEPTION 'account id does not exist' USING ERRCODE = '50004';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM CARD WHERE card_id = FN_ID_CARD(p_card_id)) THEN
        RAISE EXCEPTION 'card id does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY
    SELECT FN_CATEGORY_ID(C.category_id), C.category_name
    FROM FN_CATEGORY_NOT_HAVE_CARD(FN_ID_ACCOUNT(p_account_id), FN_ID_CARD(p_card_id)) AS C;
END
$$ LANGUAGE plpgsql;