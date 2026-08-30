CREATE
OR        REPLACE FUNCTION FN_SESSION_CHECK (p_id TYPE_ID) RETURNS BOOLEAN AS $$ BEGIN
    IF p_id IS NULL THEN
        RAISE EXCEPTION '50001: session id must not be null';
    END IF;

    UPDATE SESSION
    SET logout_time = NOW() + INTERVAL '15m'
    WHERE final_status = 'ACTIVE' AND session_id = FN_ID_SESSION(p_id);

    RETURN FOUND;
END
$$ LANGUAGE plpgsql;