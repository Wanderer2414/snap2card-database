-- CREATE    TABLE EXAM_LOG_REVIEW_RESULT (
--           log_id INT REFERENCES EXAM_LOG (log_id),
--           quiz_id INT REFERENCES QUIZ (quiz_id)  ,
--           user_answer BOOLEAN                    ,
--           PRIMARY KEY (log_id, quiz_id)
--           );
CREATE
OR        REPLACE FUNCTION EXAM_LOG_REVIEW_RESULT (
          p_exam_log_id TYPE_ID,
          p_quiz_id TYPE_ID    ,
          p_result BOOLEAN
          ) RETURNS VOID AS $$ 
BEGIN
    IF p_exam_log_id IS NULL THEN
        RAISE EXCEPTION 'exam log id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_quiz_id IS NULL THEN
        RAISE EXCEPTION 'quiz id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_result IS NULL THEN
        RAISE EXCEPTION 'result must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_exam_log_id, 1, 3) <> 'LOG' THEN
        RAISE EXCEPTION 'invalid log id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_quiz_id, 1, 4) <> 'QUIZ' THEN
        RAISE EXCEPTION 'invalid quiz id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EXAM_LOG WHERE log_id = FN_ID_LOG(p_exam_log_id)) THEN
        RAISE EXCEPTION 'exam log not found' USING ERRCODE = '50004';
    END IF;

    IF EXISTS (SELECT 1 FROM EXAM_LOG WHERE log_id = FN_ID_LOG(p_exam_log_id) AND end_time IS NOT NULL) THEN
        RAISE EXCEPTION 'exam log is already completed' USING ERRCODE = '50003';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM QUIZ WHERE quiz_id = FN_ID_QUIZ(p_quiz_id)) THEN
        RAISE EXCEPTION 'quiz not found' USING ERRCODE = '50004';
    END IF;

    PERFORM FN_EXAM_LOG_REVIEW_RESULT(FN_ID_LOG(p_exam_log_id), FN_ID_QUIZ(p_quiz_id), p_result);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'result for this quiz is already recorded' USING ERRCODE = '50003';
END $$ LANGUAGE plpgsql;