CREATE
OR        REPLACE FUNCTION REQUEST_LOG_INSERT (
          p_endpoint VARCHAR(60),
          p_header TEXT         ,
          p_body TEXT           ,
          p_reponse_header TEXT ,
          p_reponse_body TEXT
          ) RETURNS INT AS $$
BEGIN
    IF p_endpoint IS NULL THEN
        RAISE EXCEPTION 'endpoint must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_header IS NULL THEN
        RAISE EXCEPTION 'header must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_body IS NULL THEN
        RAISE EXCEPTION 'body must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_reponse_header IS NULL THEN
        RAISE EXCEPTION 'response header must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_reponse_body IS NULL THEN
        RAISE EXCEPTION 'response body must not be null' USING ERRCODE = '50001';
    END IF;

    RETURN FN_REQUEST_LOG_INSERT(p_endpoint, p_header, p_body, p_reponse_header, p_reponse_body);
END
$$ LANGUAGE plpgsql;