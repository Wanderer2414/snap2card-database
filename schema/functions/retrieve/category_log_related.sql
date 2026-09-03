CREATE
OR        REPLACE FUNCTION FN_CATEGORY_LOG_RELATED (p_user INT, p_category_id INT) RETURNS TABLE (
          log_id INT              ,
          exam_name TYPE_NAME_EXAM,
          score INT               ,
          total_score INT         ,
          start_time TIMESTAMPTZ  ,
          end_time TIMESTAMPTZ
          ) AS $$ BEGIN
          RETURN QUERY
          SELECT EL.log_id, E.exam_name, EL.score, E.total_score, EL.start_time, EL.end_time FROM EXAM_LOG EL
          JOIN EXAM E ON E.exam_id = EL.exam_id
          JOIN EXAM_CATEGORY_RELATED ECR ON ECR.exam_id = E.exam_id AND ECR.category_id = p_category_id
          JOIN SESSION S ON S.owner_id = p_user AND EL.session_id = S.session_id;
END $$ LANGUAGE plpgsql;