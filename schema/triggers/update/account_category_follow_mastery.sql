CREATE
OR        REPLACE FUNCTION FN_ACCOUNT_CATEGORY_FOLLOW_MASTERY () RETURNS TRIGGER AS $$
BEGIN
    UPDATE ACCOUNT_CATEGORY_FOLLOW ACF
    SET mastery_score = CS.mastery
    FROM (
        SELECT F.account_id, F.category_id,
               AVG(ACH.mastery_score) AS mastery
        FROM (
            SELECT DISTINCT F.account_id, F.category_id
            FROM ACCOUNT_CATEGORY_FOLLOW F
            JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = F.category_id
            JOIN new_rows NR ON NR.account_id = F.account_id AND NR.card_id = CCC.card_id
        ) F
        JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = F.category_id
        JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = F.account_id
        GROUP BY F.account_id, F.category_id
    ) CS
    WHERE ACF.account_id = CS.account_id
      AND ACF.category_id = CS.category_id;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE TRIGGER TR_ACCOUNT_CATEGORY_FOLLOW_MASTERY
AFTER UPDATE ON ACCOUNT_CARD_HAVE
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT EXECUTE FUNCTION FN_ACCOUNT_CATEGORY_FOLLOW_MASTERY ();