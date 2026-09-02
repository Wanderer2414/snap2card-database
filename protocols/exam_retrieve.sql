CREATE
OR        REPLACE FUNCTION EXAM_REVIEW_RETRIEVE (p_exam_id TYPE_ID) RETURNS TABLE (
          quiz_id TYPE_ID,
          frontSide TEXT ,
          backSide TEXT  ,
          YEAR INTEGER   ,
          MONTH INTEGER  ,
          DAY INTEGER    ,
          HOUR INTEGER   ,
          MINUTE INTEGER ,
          SECOND INTEGER ,
          gmt CHAR(3)
          ) AS $$ 
DECLARE 
    v_id INT;
BEGIN
    IF p_exam_id IS NULL THEN
        RAISE EXCEPTION 'exam id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_exam_id, 1, 4) <> 'EXAM' THEN
        RAISE EXCEPTION 'invalid exam id format' USING ERRCODE = '50006';
    END IF;

    v_id := FN_ID_EXAM(p_exam_id);
    IF NOT EXISTS (SELECT 1 FROM EXAM WHERE exam_id = v_id) THEN
        RAISE EXCEPTION 'exam not found' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY
    SELECT FN_QUIZ_ID(F.quiz_id), C1.component_text, C2.component_text, (FN_GET_GMT(F.date_created)).* FROM FN_EXAM_REVIEW_RETRIEVE(v_id) AS F
    JOIN COMPONENT C1 ON C1.component_id = F.frontSide
    JOIN COMPONENT C2 ON C2.component_id = F.backSide;
END $$ LANGUAGE plpgsql;