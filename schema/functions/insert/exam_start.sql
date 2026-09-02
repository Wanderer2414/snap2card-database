-- CREATE    TABLE EXAM_LOG (
--           log_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY    ,
--           account_id INT NOT NULL REFERENCES ACCOUNT (account_id),
--           exam_id INT NOT NULL REFERENCES EXAM (exam_id)         ,
--           score INT CHECK (score > 0)                            ,
--           start_time TIMESTAMPTZ DEFAULT NOW() NOT NULL          ,
--           end_time TIMESTAMPTZ CHECK (end_time > start_time)
--           );
CREATE
OR        REPLACE FUNCTION FN_EXAM_START (p_session_id INT, p_exam_id INT) RETURNS INT AS $$
DECLARE 
    v_id INT ;
BEGIN
    INSERT INTO EXAM_LOG(session_id, exam_id) VALUES (p_session_id, p_exam_id)
    RETURNING log_id INTO v_id;
    RETURN v_id;
END $$ LANGUAGE plpgsql;