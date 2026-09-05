CREATE
OR        REPLACE FUNCTION FN_CATEGORY_MASTERY_HAVE_DEL () RETURNS TRIGGER AS $$
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
            JOIN old_rows OR_ ON OR_.account_id = F.account_id AND OR_.card_id = CCC.card_id
        ) F
        JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = F.category_id
        LEFT JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = F.account_id
        GROUP BY F.account_id, F.category_id
    ) CS
    WHERE ACF.account_id = CS.account_id
      AND ACF.category_id = CS.category_id;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE TRIGGER TR_CATEGORY_MASTERY_HAVE_DEL
AFTER DELETE ON ACCOUNT_CARD_HAVE
REFERENCING OLD TABLE AS old_rows
FOR EACH STATEMENT EXECUTE FUNCTION FN_CATEGORY_MASTERY_HAVE_DEL ();