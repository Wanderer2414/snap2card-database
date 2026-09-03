CREATE
OR        REPLACE FUNCTION FILE_RETRIEVE (p_file_id TYPE_ID) RETURNS TABLE (
          file_source TEXT            ,
          file_name TYPE_NAME_FILE    ,
          file_type TYPE_FILE_TYPE    ,
          file_id TYPE_ID             ,
          YEAR INTEGER                ,
          MONTH INTEGER               ,
          DAY INTEGER                 ,
          HOUR INTEGER                ,
          MINUTE INTEGER              ,
          SECOND INTEGER              ,
          gmt CHAR(3)
          ) AS $$
BEGIN
    IF p_file_id IS NULL THEN
        RAISE EXCEPTION 'file id must not be null' USING ERRCODE = '50001';
    END IF;

    IF SUBSTRING(p_file_id, 1, 4) <> 'FILE' THEN
        RAISE EXCEPTION 'invalid file id format' USING ERRCODE = '50006';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM FILE F WHERE F.file_id = FN_ID_FILE(p_file_id)) THEN
        RAISE EXCEPTION 'file not found' USING ERRCODE = '50004';
    END IF;

    RETURN QUERY 
    SELECT F.file_source, F.file_name, F.file_type, FN_FILE_ID(F.file_id),
           (FN_GET_GMT(F.date_created)).YEAR,
           (FN_GET_GMT(F.date_created)).MONTH,
           (FN_GET_GMT(F.date_created)).DAY,
           (FN_GET_GMT(F.date_created)).HOUR,
           (FN_GET_GMT(F.date_created)).MINUTE,
           (FN_GET_GMT(F.date_created)).SECOND,
           (FN_GET_GMT(F.date_created)).gmt
    FROM FN_FILE_RETRIEVE(FN_ID_FILE(p_file_id)) AS F;
END
$$ LANGUAGE plpgsql;