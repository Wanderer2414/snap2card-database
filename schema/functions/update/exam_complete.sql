CREATE
OR        REPLACE FUNCTION FN_EXAM_COMPLETED (p_log_id INT) RETURNS VOID AS $$
DECLARE
    v_score INT;
    v_account_id INT;
    v_exam_date DATE;
BEGIN
    SELECT S.owner_id, DATE(EL.start_time) INTO v_account_id, v_exam_date
    FROM EXAM_LOG EL JOIN SESSION S ON S.session_id = EL.session_id
    WHERE EL.log_id = p_log_id;

    UPDATE ACCOUNT_CARD_HAVE ACH
    SET true_count = true_count + sub.cnt,
        date_learned = v_exam_date
    FROM (
        SELECT RQ.card_id, COUNT(*) AS cnt
        FROM EXAM_LOG_REVIEW_RESULT ELR
        JOIN REVIEW_QUIZ RQ ON RQ.quiz_id = ELR.quiz_id
        WHERE ELR.log_id = p_log_id AND ELR.user_answer = TRUE
        GROUP BY RQ.card_id
    ) sub
    WHERE ACH.account_id = v_account_id AND ACH.card_id = sub.card_id;

    UPDATE ACCOUNT_CARD_HAVE ACH
    SET false_count = false_count + sub.cnt
    FROM (
        SELECT RQ.card_id, COUNT(*) AS cnt
        FROM EXAM_LOG_REVIEW_RESULT ELR
        JOIN REVIEW_QUIZ RQ ON RQ.quiz_id = ELR.quiz_id
        WHERE ELR.log_id = p_log_id AND ELR.user_answer = FALSE
        GROUP BY RQ.card_id
    ) sub
    WHERE ACH.account_id = v_account_id AND ACH.card_id = sub.card_id;

    SELECT COUNT(*) INTO v_score
    FROM EXAM_LOG_REVIEW_RESULT
    WHERE log_id = p_log_id AND user_answer = TRUE;

    UPDATE EXAM_LOG
    SET end_time = GREATEST (NOW()::TIMESTAMPTZ, start_time + INTERVAL '1 second'),
        score = v_score
    WHERE log_id = p_log_id;

    INSERT INTO DAILY_LOG (account_id, day, card_learned)
    SELECT v_account_id, v_exam_date, COUNT(*) AS cnt
    FROM ACCOUNT_CARD_HAVE ACH
    WHERE ACH.account_id = v_account_id
      AND ACH.date_learned = v_exam_date
    ON CONFLICT (account_id, day)
    DO UPDATE SET card_learned = EXCLUDED.card_learned;
END $$ LANGUAGE plpgsql;
