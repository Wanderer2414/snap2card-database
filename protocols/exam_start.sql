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
    v_session := FN_ID_SESSION(p_session_id);
    v_id := FN_ID_EXAM(p_exam_id);
    IF (v_session IS NULL) OR (v_id IS NULL) THEN RETURN NULL;
    END IF;
    v_id := FN_EXAM_START(v_session, v_id);
    IF (v_id IS NULL) THEN RETURN NULL; END IF;
    RETURN FN_EXAM_ID(v_id);
END $$ LANGUAGE plpgsql;