CREATE
OR        REPLACE FUNCTION FN_SESSION_ID (p_id INT) RETURNS TEXT AS $$ 
    SELECT CONCAT('SESS', TO_CHAR(p_id, 'FM00000000000'));
$$ LANGUAGE SQL IMMUTABLE;

CREATE
OR        REPLACE FUNCTION FN_ID_SESSION (p_session_id TYPE_ID) RETURNS INT AS $$
BEGIN
    IF p_session_id IS NULL THEN
        RAISE EXCEPTION '50001: session id must not be null';
    END IF;

    IF SUBSTRING(p_session_id, 1, 4) <> 'SESS' THEN
        RAISE EXCEPTION '50006: invalid session id format';
    END IF;

    RETURN CAST(SUBSTRING(p_session_id FROM 5) AS INT);
END;
$$ LANGUAGE plpgsql IMMUTABLE;