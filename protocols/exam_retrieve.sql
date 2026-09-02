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
    v_id := FN_ID_EXAM(p_exam_id);
    IF (v_id IS NULL) THEN RETURN; END IF;

    RETURN QUERY
    SELECT FN_QUIZ_ID(F.quiz_id), C1.component_text, C2.component_text, (FN_GET_GMT(F.date_created)).* FROM FN_EXAM_REVIEW_RETRIEVE(v_id) AS F
    JOIN COMPONENT C1 ON C1.component_id = F.frontSide
    JOIN COMPONENT C2 ON C2.component_id = F.backSide;
END $$ LANGUAGE plpgsql;