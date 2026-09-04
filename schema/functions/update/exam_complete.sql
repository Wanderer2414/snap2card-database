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
    SET true_count = true_count + sub.cnt
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

    WITH learned_all AS (
        SELECT COUNT(DISTINCT RQ.card_id) AS cnt
        FROM EXAM_LOG EL2
        JOIN SESSION S2 ON S2.session_id = EL2.session_id
        JOIN EXAM_QUIZ EQ2 ON EQ2.exam_id = EL2.exam_id
        JOIN REVIEW_QUIZ RQ ON RQ.quiz_id = EQ2.quiz_id
        JOIN EXAM_LOG_REVIEW_RESULT ELR ON ELR.log_id = EL2.log_id AND ELR.quiz_id = RQ.quiz_id
        JOIN ACCOUNT_CARD_HAVE ACH ON ACH.account_id = v_account_id AND ACH.card_id = RQ.card_id
        WHERE S2.owner_id = v_account_id
          AND DATE(EL2.start_time) = v_exam_date
          AND ELR.user_answer = TRUE
          AND (
              ACH.true_count - COALESCE((
                  SELECT COUNT(*) FROM EXAM_LOG_REVIEW_RESULT ELR2
                  WHERE ELR2.log_id = EL2.log_id AND ELR2.quiz_id = RQ.quiz_id AND ELR2.user_answer = TRUE
              ), 0)
          )::float / (
              3 * (ACH.false_count - COALESCE((
                  SELECT COUNT(*) FROM EXAM_LOG_REVIEW_RESULT ELR3
                  WHERE ELR3.log_id = EL2.log_id AND ELR3.quiz_id = RQ.quiz_id AND ELR3.user_answer = FALSE
              ), 0))
          ) < 1
    )
    INSERT INTO DAILY_LOG (account_id, day, card_learned)
    VALUES (v_account_id, v_exam_date, (SELECT cnt FROM learned_all))
    ON CONFLICT (account_id, day)
    DO UPDATE SET card_learned = EXCLUDED.card_learned;
END $$ LANGUAGE plpgsql;
