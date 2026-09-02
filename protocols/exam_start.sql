-- CREATE    TABLE EXAM_LOG (
--           log_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY    ,
--           account_id INT NOT NULL REFERENCES ACCOUNT (account_id),
--           exam_id INT NOT NULL REFERENCES EXAM (exam_id)         ,
--           score INT CHECK (score > 0)                            ,
--           start_time TIMESTAMPTZ DEFAULT NOW() NOT NULL          ,
--           end_time TIMESTAMPTZ CHECK (end_time > start_time)
--           );
CREATE
OR        REPLACE FUNCTION EXAM_START (p_session_id TYPE_ID, p_exam_id TYPE_ID) RETURNS TYPE_ID AS $$
DECLARE 
    v_session INT;
    v_id INT ;
BEGIN
    IF p_session_id IS NULL THEN
        RAISE EXCEPTION 'session id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_exam_id IS NULL THEN
        RAISE EXCEPTION 'exam id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_session_id, 1, 4) <> 'SESS' THEN
        RAISE EXCEPTION 'invalid session id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_exam_id, 1, 4) <> 'EXAM' THEN
        RAISE EXCEPTION 'invalid exam id format' USING ERRCODE = '50006';
    END IF;

    SELECT FN_SESSION_CHECK(FN_ID_SESSION(p_session_id)) INTO v_session;
    IF v_session IS NULL THEN
        RAISE EXCEPTION 'no active session found' USING ERRCODE = '50005';
    END IF;

    v_id := FN_ID_EXAM(p_exam_id);
    IF NOT EXISTS (SELECT 1 FROM EXAM WHERE exam_id = v_id) THEN
        RAISE EXCEPTION 'exam not found' USING ERRCODE = '50004';
    END IF;

    v_id := FN_EXAM_START(FN_ID_SESSION(p_session_id), v_id);
    RETURN FN_LOG_ID(v_id);
END $$ LANGUAGE plpgsql;