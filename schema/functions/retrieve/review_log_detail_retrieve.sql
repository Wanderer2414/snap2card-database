CREATE
OR        REPLACE FUNCTION FN_REVIEW_LOG_DETAIL_RETRIEVE (p_log_id INT) RETURNS TABLE (
          log_id INT              ,
          exam_name TYPE_NAME_EXAM,
          exam_level TYPE_LEVEL_EXAM,
          result_score INT        ,
          total_score INT         ,
          num_of_quiz INT         ,
          done_time TIMESTAMPTZ   ,
          quiz_results TYPE_QUIZ_RESULT_INTERNAL[]
          ) AS $$ BEGIN
    RETURN QUERY
    SELECT EL.log_id,
           E.exam_name,
           E.exam_level,
           EL.score,
           E.total_score,
           (SELECT COUNT(*)::INT FROM EXAM_QUIZ EQ WHERE EQ.exam_id = E.exam_id),
           EL.end_time,
           COALESCE(
               ARRAY_AGG(
                   ROW(RQ.quiz_id, C1.component_text, C2.component_text, ELR.user_answer,
                       CASE WHEN ELR.user_answer = TRUE THEN 1 ELSE 0 END, 1)::TYPE_QUIZ_RESULT_INTERNAL
                   ORDER BY RQ.quiz_id
               ),
               ARRAY[]::TYPE_QUIZ_RESULT_INTERNAL[]
           )
    FROM EXAM_LOG EL
    JOIN EXAM E ON E.exam_id = EL.exam_id
    JOIN EXAM_LOG_REVIEW_RESULT ELR ON ELR.log_id = EL.log_id
    JOIN REVIEW_QUIZ RQ ON RQ.quiz_id = ELR.quiz_id
    JOIN CARD C ON C.card_id = RQ.card_id
    JOIN COMPONENT C1 ON C1.component_id = C.frontside_id
    JOIN COMPONENT C2 ON C2.component_id = C.backside_id
    WHERE EL.log_id = p_log_id
    GROUP BY EL.log_id, E.exam_id, E.exam_name, E.exam_level, EL.score, E.total_score, EL.end_time;
END $$ LANGUAGE plpgsql;