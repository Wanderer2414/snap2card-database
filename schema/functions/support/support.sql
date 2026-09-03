CREATE
OR        REPLACE FUNCTION count_words (txt TEXT) RETURNS INT AS $$
BEGIN
    RETURN cardinality(regexp_split_to_array(trim(txt), '\s+'));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE
OR        REPLACE FUNCTION GET_FILE_SOURCE (
          p_file_id INT            ,
          p_hash_code CHAR(64)     ,
          p_file_name TEXT         ,
          p_file_type TYPE_FILE_TYPE
          ) RETURNS TEXT LANGUAGE SQL IMMUTABLE AS $$
    SELECT p_file_id::text
        || md5(p_hash_code || p_file_name)
        || '.'
        || p_file_type::text;
$$;