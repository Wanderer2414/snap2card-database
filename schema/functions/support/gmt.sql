CREATE
OR        REPLACE FUNCTION FN_GET_GMT (p_datetime TIMESTAMPTZ) RETURNS TABLE (
          YEAR INTEGER  ,
          MONTH INTEGER ,
          DAY INTEGER   ,
          HOUR INTEGER  ,
          MINUTE INTEGER,
          SECOND INTEGER,
          gmt CHAR(3)
          ) LANGUAGE SQL AS $$
    SELECT
        EXTRACT(YEAR   FROM p_datetime)::INTEGER,
        EXTRACT(MONTH  FROM p_datetime)::INTEGER,
        EXTRACT(DAY    FROM p_datetime)::INTEGER,
        EXTRACT(HOUR   FROM p_datetime)::INTEGER,
        EXTRACT(MINUTE FROM p_datetime)::INTEGER,
        EXTRACT(SECOND FROM p_datetime)::INTEGER,
        TO_CHAR(p_datetime, 'OF');
$$;