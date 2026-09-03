-- CREATE    TABLE EXAM_LOG_REVIEW_RESULT (
--           log_id INT REFERENCES EXAM_LOG (log_id),
--           quiz_id INT REFERENCES QUIZ (quiz_id)  ,
--           user_answer BOOLEAN                    ,
--           PRIMARY KEY (log_id, quiz_id)
--           );
CREATE
OR        REPLACE FUNCTION FN_EXAM_LOG_REVIEW_RESULT (
          p_exam_log_id INT,
          p_quiz_id INT    ,
          p_result BOOLEAN
          ) RETURNS VOID AS $$ BEGIN
    INSERT INTO EXAM_LOG_REVIEW_RESULT(log_id, quiz_id, user_answer) VALUES (p_exam_log_id, p_quiz_id, p_result);
END $$ LANGUAGE plpgsql;