CREATE
OR        REPLACE FUNCTION FN_FILE_RETRIEVE (p_id INT) RETURNS TABLE (
          file_source TEXT            ,
          file_name TYPE_NAME_FILE    ,
          file_type TYPE_FILE_TYPE    ,
          file_id INT                 ,
          date_created TIMESTAMPTZ
          ) AS $$
BEGIN
    RETURN QUERY 
    SELECT F.file_source, F.file_name, F.file_type, F.file_id, F.date_created FROM FILE F WHERE F.file_id = p_id;
END;
$$ LANGUAGE plpgsql;