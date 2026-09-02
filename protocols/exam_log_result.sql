-- CREATE    TABLE EXAM_LOG_REVIEW_RESULT (
--           log_id INT REFERENCES EXAM_LOG (log_id),
--           quiz_id INT REFERENCES QUIZ (quiz_id)  ,
--           user_answer BOOLEAN                    ,
--           PRIMARY KEY (log_id, quiz_id)
--           );
CREATE
OR        REPLACE PROCEDURE EXAM_LOG_REVIEW_RESULT (
          p_exam_log_id TYPE_ID,
          p_quiz_id TYPE_ID    ,
          p_result BOOLEAN
          ) AS $$ 
DECLARE 
    v_log_id INT;
    v_quiz_id INT;
BEGIN
    v_log_id := FN_ID_LOG(p_exam_log_id);
    v_quiz_id := FN_ID_QUIZ(p_quiz_id);

    IF (v_log_id IS NULL) OR (v_quiz_id IS NULL) THEN
        RETURN ;
    END IF;

    CALL FN_EXAM_REVIEW_RETRIEVE(v_log_id, v_quiz_id, p_result);
END $$ LANGUAGE plpgsql;