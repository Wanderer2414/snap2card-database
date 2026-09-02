CREATE
OR        REPLACE FUNCTION FN_SESSION_CHECK (p_id INT) RETURNS INT AS $$ 
DECLARE
    v_id INT;
BEGIN
    UPDATE SESSION
    SET logout_time = NOW() + INTERVAL '15m'
    WHERE final_status = 'ACTIVE' AND session_id = p_id
    RETURNING owner_id INTO v_id;

    RETURN v_id;
END
$$ LANGUAGE plpgsql;