-- CREATE    TABLE REQUEST_LOG (
--           request_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           endpoint_text VARCHAR(60) NOT NULL                     ,
--           header_text TEXT NOT NULL                              ,
--           body_text TEXT NOT NULL                                ,
--           reponse_header TEXT NOT NULL                           ,
--           reponse_body TEXT NOT NULL                             ,
--           date_created TIMESTAMPTZ DEFAULT NOW()
--           );
CREATE
OR        REPLACE FUNCTION FN_REQUEST_LOG_INSERT (
          p_endpoint VARCHAR(60),
          p_header TEXT         ,
          p_body TEXT           ,
          p_reponse_header TEXT ,
          p_reponse_body TEXT
          ) RETURNS INT AS $$
DECLARE
    v_id INT;
BEGIN
    IF p_endpoint IS NULL THEN
        RAISE EXCEPTION '50001: endpoint must not be null';
    END IF;

    IF p_header IS NULL THEN
        RAISE EXCEPTION '50001: header must not be null';
    END IF;

    IF p_body IS NULL THEN
        RAISE EXCEPTION '50001: body must not be null';
    END IF;

    IF p_reponse_header IS NULL THEN
        RAISE EXCEPTION '50001: response header must not be null';
    END IF;

    IF p_reponse_body IS NULL THEN
        RAISE EXCEPTION '50001: response body must not be null';
    END IF;

    IF length(p_endpoint) > 60 THEN
        RAISE EXCEPTION '50002: endpoint must not exceed 60 characters';
    END IF;

    INSERT INTO REQUEST_LOG(endpoint_text, header_text, body_text, reponse_header, reponse_body) VALUES (p_endpoint, p_header, p_body, p_reponse_header, p_reponse_body)
    RETURNING request_id INTO v_id;

    RETURN v_id;
END ;
$$ LANGUAGE plpgsql;