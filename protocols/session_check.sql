CREATE
OR        REPLACE FUNCTION SESSION_CHECK (p_session_id TYPE_ID) RETURNS TYPE_ID AS $$
DECLARE 
    v_id INT;
BEGIN
    IF p_session_id IS NULL THEN
        RETURN NULL;
    END IF;

    IF SUBSTRING(p_session_id, 1, 4) <> 'SESS' THEN
        RAISE EXCEPTION 'invalid session id format' USING ERRCODE = '50006';
    END IF;

    SELECT FN_SESSION_CHECK(FN_ID_SESSION(p_session_id)) INTO v_id;
    IF v_id IS NULL THEN RETURN NULL; END IF;

    RETURN FN_ACCOUNT_ID(v_id);
END;
$$ LANGUAGE plpgsql;