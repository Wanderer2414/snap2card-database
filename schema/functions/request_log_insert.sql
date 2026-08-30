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
    INSERT INTO REQUEST_LOG(endpoint_text, header_text, body_text, reponse_header, reponse_body) VALUES (p_endpoint, p_header, p_body, p_reponse_header, p_reponse_body)
    RETURNING request_id INTO v_id;

    RETURN v_id;
END ;
$$ LANGUAGE plpgsql;

-- CREATE    TABLE REQUEST_LOG (
--           request_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           endpoint_text VARCHAR(60) NOT NULL                     ,
--           header_text TEXT NOT NULL                              ,
--           body_text TEXT NOT NULL                                ,
--           reponse_header TEXT NOT NULL                           ,
--           reponse_body TEXT NOT NULL                             ,
--           date_created TIME DEFAULT NOW()
--           );