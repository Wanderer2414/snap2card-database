CREATE
OR        REPLACE FUNCTION CATEGORY_LOG_RELATED (
          p_account_id TYPE_ID,
          p_category_id TYPE_ID
          ) RETURNS TABLE (
          log_id TYPE_ID         ,
          exam_name TYPE_NAME_EXAM,
          score INT               ,
          total_score INT         ,
          YEAR_START INTEGER      ,
          MONTH_START INTEGER     ,
          DAY_START INTEGER       ,
          HOUR_START INTEGER      ,
          MINUTE_START INTEGER    ,
          SECOND_START INTEGER    ,
          GMT_START CHAR(3)       ,
          YEAR_END INTEGER        ,
          MONTH_END INTEGER       ,
          DAY_END INTEGER         ,
          HOUR_END INTEGER        ,
          MINUTE_END INTEGER      ,
          SECOND_END INTEGER      ,
          GMT_END CHAR(3)
          ) AS $$ 
BEGIN
    IF p_account_id IS NULL THEN
        RAISE EXCEPTION 'account id must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_category_id IS NULL THEN
        RAISE EXCEPTION 'category id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_account_id, 1, 4) <> 'ACNT' THEN
        RAISE EXCEPTION 'invalid account id format' USING ERRCODE = '50006';
    END IF;

    IF SUBSTRING(p_category_id, 1, 4) <> 'CATE' THEN
        RAISE EXCEPTION 'invalid category id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM CATEGORY WHERE category_id = FN_ID_CATEGORY(p_category_id)) THEN
        RAISE EXCEPTION 'category not found' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY
    SELECT FN_LOG_ID(C.log_id), C.exam_name, C.score, C.total_score,
           (FN_GET_GMT(C.start_time)).YEAR,
           (FN_GET_GMT(C.start_time)).MONTH,
           (FN_GET_GMT(C.start_time)).DAY,
           (FN_GET_GMT(C.start_time)).HOUR,
           (FN_GET_GMT(C.start_time)).MINUTE,
           (FN_GET_GMT(C.start_time)).SECOND,
           (FN_GET_GMT(C.start_time)).gmt,
           (FN_GET_GMT(C.end_time)).YEAR,
           (FN_GET_GMT(C.end_time)).MONTH,
           (FN_GET_GMT(C.end_time)).DAY,
           (FN_GET_GMT(C.end_time)).HOUR,
           (FN_GET_GMT(C.end_time)).MINUTE,
           (FN_GET_GMT(C.end_time)).SECOND,
           (FN_GET_GMT(C.end_time)).gmt
    FROM FN_CATEGORY_LOG_RELATED(FN_ID_ACCOUNT(p_account_id), FN_ID_CATEGORY(p_category_id)) AS C;
END $$ LANGUAGE plpgsql;