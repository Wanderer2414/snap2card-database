CREATE
OR        REPLACE FUNCTION EXAM_COMPLETED (p_exam_log_id TYPE_ID) RETURNS VOID AS $$ 
BEGIN
    IF p_exam_log_id IS NULL THEN
        RAISE EXCEPTION 'exam log id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_exam_log_id, 1, 3) <> 'LOG' THEN
        RAISE EXCEPTION 'invalid log id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EXAM_LOG WHERE log_id = FN_ID_LOG(p_exam_log_id)) THEN
        RAISE EXCEPTION 'exam log not found' USING ERRCODE = '50004';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EXAM_LOG_REVIEW_RESULT WHERE log_id = FN_ID_LOG(p_exam_log_id)) THEN
        RAISE EXCEPTION 'exam log has no answered questions' USING ERRCODE = '50003';
    END IF;

    PERFORM FN_EXAM_COMPLETED(FN_ID_LOG(p_exam_log_id));
END $$ LANGUAGE plpgsql;