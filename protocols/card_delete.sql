CREATE
OR        REPLACE FUNCTION CARD_DELETE (p_account_id TYPE_ID, p_card_id TYPE_ID) RETURNS VOID AS $$
DECLARE
    v_owner INT;
    v_card INT;
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

    v_owner := FN_ID_ACCOUNT(p_account_id);
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    v_card := FN_ID_CARD(p_card_id);
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT_CARD_HAVE WHERE account_id = v_owner AND card_id = v_card) THEN
        RAISE EXCEPTION 'card not found for account' USING ERRCODE = '50004';
    END IF;

    PERFORM FN_CARD_DELETE(v_owner, v_card);
END
$$ LANGUAGE plpgsql;