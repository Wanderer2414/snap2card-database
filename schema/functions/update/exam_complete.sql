CREATE
OR        REPLACE FUNCTION FN_EXAM_COMPLETED (p_log_id INT) RETURNS VOID AS $$ 
DECLARE
    v_score INT;
    v_now TIMESTAMPTZ := NOW();
BEGIN
    SELECT COUNT(*) INTO v_score
    FROM EXAM_LOG_REVIEW_RESULT
    WHERE log_id = p_log_id AND user_answer = TRUE;

    UPDATE EXAM_LOG
    SET end_time = GREATEST (v_now, start_time + INTERVAL '1 second'),
        score = v_score
    WHERE log_id = p_log_id;
END $$ LANGUAGE plpgsql;