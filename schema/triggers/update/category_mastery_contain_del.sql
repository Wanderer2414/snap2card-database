CREATE
OR        REPLACE FUNCTION FN_CATEGORY_MASTERY_CONTAIN_DEL () RETURNS TRIGGER AS $$
BEGIN
    UPDATE ACCOUNT_CATEGORY_FOLLOW ACF
    SET mastery_score = sub.mastery
    FROM (
        SELECT F.account_id, F.category_id,
               AVG(ACH.true_count::float / (3 * ACH.false_count)) AS mastery
        FROM (
            SELECT DISTINCT F.account_id, F.category_id
            FROM ACCOUNT_CATEGORY_FOLLOW F
            JOIN old_rows OR_ ON OR_.category_id = F.category_id
        ) F
        JOIN CATEGORY_CARD_CONTAIN CCC ON CCC.category_id = F.category_id
        LEFT JOIN ACCOUNT_CARD_HAVE ACH ON ACH.card_id = CCC.card_id AND ACH.account_id = F.account_id
        GROUP BY F.account_id, F.category_id
    ) sub
    WHERE ACF.account_id = sub.account_id
      AND ACF.category_id = sub.category_id;
    RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE
OR        REPLACE TRIGGER TR_CATEGORY_MASTERY_CONTAIN_DEL
AFTER DELETE ON CATEGORY_CARD_CONTAIN
REFERENCING OLD TABLE AS old_rows
FOR EACH STATEMENT EXECUTE FUNCTION FN_CATEGORY_MASTERY_CONTAIN_DEL ();