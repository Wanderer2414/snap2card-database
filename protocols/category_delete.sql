CREATE
OR        REPLACE FUNCTION CATEGORY_DELETE (p_account_id TYPE_ID, p_category_id TYPE_ID) RETURNS VOID AS $$
DECLARE
    v_owner INT;
    v_category INT;
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_category_id IS NULL THEN
        RAISE EXCEPTION 'category id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_category_id, 1, 4) <> 'CATE' THEN
        RAISE EXCEPTION 'invalid category id format' USING ERRCODE = '50006';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_account_id);
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'account does not exist' USING ERRCODE = '50004';
    END IF;

    v_category := FN_ID_CATEGORY(p_category_id);
    IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = v_category) THEN
        RAISE EXCEPTION 'category does not exist' USING ERRCODE = '50004';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM CATEGORY C
        LEFT JOIN ACCOUNT_CATEGORY_FOLLOW F
          ON F.category_id = C.category_id AND F.account_id = v_owner
        WHERE C.category_id = v_category
          AND (C.owner_id IS NOT DISTINCT FROM v_owner OR F.account_id IS NOT NULL)
    ) THEN
        RAISE EXCEPTION 'category not found for account' USING ERRCODE = '50004';
    END IF;

    PERFORM FN_CATEGORY_DELETE(v_owner, v_category);
END
$$ LANGUAGE plpgsql;