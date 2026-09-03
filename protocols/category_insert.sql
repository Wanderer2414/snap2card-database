CREATE
OR        REPLACE FUNCTION CATEGORY_INSERT (p_owner TYPE_ID, p_name TEXT) RETURNS TYPE_ID AS $$
DECLARE
    v_owner INT             ;
    v_name TYPE_NAME_CATEGORY;
BEGIN
    IF p_owner IS NULL THEN
        RAISE EXCEPTION 'owner id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_name IS NULL THEN
        RAISE EXCEPTION 'name must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_owner, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_owner);
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'owner id does not exist' USING ERRCODE = '50004';
    END IF;

    IF length(p_name) > 20 THEN
        RAISE EXCEPTION 'name must not exceed 20 characters' USING ERRCODE = '50002';
    END IF;

    v_name := p_name::TYPE_NAME_CATEGORY;

    RETURN FN_CATEGORY_ID(FN_CATEGORY_INSERT(v_owner, v_name));
END
$$ LANGUAGE plpgsql;