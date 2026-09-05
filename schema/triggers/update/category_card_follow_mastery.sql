CREATE
OR        REPLACE FUNCTION FN_CATEGORY_CARD_FOLLOW_MASTERY () RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO ACCOUNT_CARD_HAVE (account_id, card_id)
    SELECT F.account_id, NR.card_id
    FROM new_rows NR
    JOIN ACCOUNT_CATEGORY_FOLLOW F ON F.category_id = NR.category_id
    ON CONFLICT (account_id, card_id) DO NOTHING;

    UPDATE ACCOUNT_CATEGORY_FOLLOW ACF
    SET mastery_score = sub.mastery
    FROM (
        SELECT F.account_id, F.category_id,
               AVG(ACH.mastery_score) AS mastery
        FROM ACCOUNT_CATEGORY_FOLLOW F
        JOIN new_rows NR ON NR.category_id = F.category_id
        LEFT JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = F.category_id
        LEFT JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = F.account_id
        GROUP BY F.account_id, F.category_id
    ) sub
    WHERE ACF.account_id = sub.account_id
      AND ACF.category_id = sub.category_id;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE TRIGGER TR_CATEGORY_CARD_FOLLOW_MASTERY
AFTER INSERT ON CATEGORY_CARD_CONTAIN
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT EXECUTE FUNCTION FN_CATEGORY_CARD_FOLLOW_MASTERY ();