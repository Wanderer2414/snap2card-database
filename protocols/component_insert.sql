CREATE
OR        REPLACE FUNCTION COMPONENT_INSERT (p_text TEXT, p_owner TYPE_ID) RETURNS TYPE_ID AS $$
DECLARE
    v_owner INT;
BEGIN
    IF p_text IS NULL THEN
        RAISE EXCEPTION 'text must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_owner IS NULL THEN
        RAISE EXCEPTION 'owner id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_owner, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_owner);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'owner id does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN FN_COMPONENT_ID(FN_COMPONENT_INSERT(p_text, v_owner));
END
$$ LANGUAGE plpgsql;

CREATE
OR        REPLACE FUNCTION COMPONENT_INSERT (p_text TEXT[], p_owner TYPE_ID) RETURNS TABLE (component_id TYPE_ID) AS $$
DECLARE
    v_owner INT;
BEGIN
    IF p_text IS NULL THEN
        RAISE EXCEPTION 'text must not be null' USING ERRCODE = '50001';
    END IF;

    IF array_length(p_text, 1) IS NULL THEN
        RAISE EXCEPTION 'text must not be empty' USING ERRCODE = '50001';
    END IF;

    IF p_owner IS NULL THEN
        RAISE EXCEPTION 'owner id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_owner, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    IF EXISTS (SELECT 1 FROM unnest(p_text) AS C(ctext) WHERE C.ctext IS NULL) THEN
        RAISE EXCEPTION 'text must not be null' USING ERRCODE = '50001';
    END IF;

    v_owner := FN_ID_ACCOUNT(p_owner);

    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE account_id = v_owner) THEN
        RAISE EXCEPTION 'owner id does not exist' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY
    SELECT FN_COMPONENT_ID(i.component_id) FROM FN_COMPONENT_INSERT(p_text, v_owner) AS i;
END
$$ LANGUAGE plpgsql;