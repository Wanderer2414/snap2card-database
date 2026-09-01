CREATE
OR        REPLACE FUNCTION FN_SESSION_CHECK (p_id TYPE_ID) RETURNS INT AS $$ 
DECLARE
    v_id INT;
BEGIN
    IF p_id IS NULL THEN
        RAISE EXCEPTION '50001: session id must not be null';
    END IF;

    UPDATE SESSION
    SET logout_time = NOW() + INTERVAL '15m'
    WHERE final_status = 'ACTIVE' AND session_id = FN_ID_SESSION(p_id)
    RETURNING owner_id INTO v_id;

    RETURN v_id;
END
$$ LANGUAGE plpgsql;