CREATE
OR        REPLACE FUNCTION FN_CARD_DELETE (p_account_id INT, p_card_id INT) RETURNS VOID AS $$
DECLARE
    v_creator INT;
    v_quiz_ids INT[];
BEGIN
    DELETE FROM ACCOUNT_CARD_HAVE WHERE card_id = p_card_id AND account_id = p_account_id;
    DELETE FROM CARD WHERE card_id = p_card_id AND creator_id = p_account_id;
END
$$ LANGUAGE plpgsql;