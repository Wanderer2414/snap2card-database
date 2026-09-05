CREATE
OR        REPLACE FUNCTION REVIEW_LOG_DETAIL_RETRIEVE (p_exam_log_id TYPE_ID) RETURNS TABLE (
          log_id TYPE_ID                ,
          exam_name TYPE_NAME_EXAM      ,
          exam_level TEXT               ,
          result_score INT              ,
          total_score INT               ,
          num_of_quiz INT               ,
          YEAR_DONE INTEGER             ,
          MONTH_DONE INTEGER            ,
          DAY_DONE INTEGER              ,
          HOUR_DONE INTEGER             ,
          MINUTE_DONE INTEGER           ,
          SECOND_DONE INTEGER           ,
          GMT_DONE CHAR(3)              ,
          quiz_results TYPE_QUIZ_RESULT[]
          ) AS $$ 
BEGIN
    IF p_exam_log_id IS NULL THEN
        RAISE EXCEPTION 'exam log id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_exam_log_id, 1, 3) <> 'LOG' THEN
        RAISE EXCEPTION 'invalid log id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EXAM_LOG EL WHERE EL.log_id = FN_ID_LOG(p_exam_log_id)) THEN
        RAISE EXCEPTION 'exam log not found' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY
    SELECT                                  FN_LOG_ID(R.log_id),
           R.exam_name                                         ,
           R.exam_level::TEXT                                  ,
           R.result_score                                      ,
           R.total_score                                       ,
           R.num_of_quiz                                       ,
           (FN_GET_GMT(R.done_time)).YEAR                      ,
           (FN_GET_GMT(R.done_time)).MONTH                     ,
           (FN_GET_GMT(R.done_time)).DAY                       ,
           (FN_GET_GMT(R.done_time)).HOUR                      ,
           (FN_GET_GMT(R.done_time)).MINUTE                    ,
           (FN_GET_GMT(R.done_time)).SECOND                    ,
           (FN_GET_GMT(R.done_time)).gmt                       ,
           COALESCE(
               (SELECT ARRAY_AGG(
                   ROW(FN_QUIZ_ID(QR.quiz_id), QR.front_text, QR.back_text, QR.account_answer,
                       QR.result_score, QR.total_score)::TYPE_QUIZ_RESULT
                   ORDER BY QR.quiz_id)
                FROM unnest(R.quiz_results) QR),
               ARRAY[]::TYPE_QUIZ_RESULT[]
           )
    FROM FN_REVIEW_LOG_DETAIL_RETRIEVE(FN_ID_LOG(p_exam_log_id)) AS R;
END $$ LANGUAGE plpgsql;