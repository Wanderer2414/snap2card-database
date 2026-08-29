CREATE
OR        REPLACE FUNCTION count_words (txt TEXT) RETURNS INT AS $$
BEGIN
    RETURN cardinality(regexp_split_to_array(trim(txt), '\s+'));
END;
$$ LANGUAGE plpgsql IMMUTABLE;