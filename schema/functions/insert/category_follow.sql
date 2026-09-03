CREATE
OR        REPLACE FUNCTION FN_CATEGORY_FOLLOW (p_owner INT, p_category_id INT) RETURNS VOID AS $$
BEGIN
    INSERT INTO ACCOUNT_CATEGORY_FOLLOW (account_id, category_id)
    VALUES (p_owner, p_category_id)
    ON CONFLICT (account_id, category_id) DO NOTHING;

    INSERT INTO ACCOUNT_CARD_HAVE (account_id, card_id)
    SELECT p_owner, CCC.card_id
    FROM CATEGORY_CARD_CONTAIN CCC
    WHERE CCC.category_id = p_category_id
    ON CONFLICT (account_id, card_id) DO NOTHING;

    UPDATE ACCOUNT_CATEGORY_FOLLOW ACF
    SET mastery_score = (
        SELECT AVG(ACH.true_count::float / ACH.false_count)
        FROM ACCOUNT_CARD_HAVE ACH
        WHERE ACH.account_id = p_owner
          AND ACH.card_id IN (SELECT X.card_id FROM CATEGORY_CARD_CONTAIN X WHERE X.category_id = p_category_id)
    )
    WHERE ACF.account_id = p_owner AND ACF.category_id = p_category_id;
END
$$ LANGUAGE plpgsql;