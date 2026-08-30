-- CREATE    TABLE SESSION (
--           session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           login_time TIMESTAMP DEFAULT NOW() NOT NULL            ,
--           logout_time TIMESTAMP DEFAULT (NOW() + INTERVAL '15m') ,
--           owner_id INT NOT NULL                                  ,
--           FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
--           );
CREATE
OR        REPLACE FUNCTION FN_ACCOUNT_LOGIN (p_email TYPE_EMAIL, p_password TYPE_PASSWORD) RETURNS TYPE_ID AS $$
DECLARE
    v_id INT   ;
    v_token INT;
BEGIN
    SELECT account_id
    INTO v_id
    FROM ACCOUNT
    WHERE account_email = p_email
      AND account_password = crypt(p_password, account_password);

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;
    
    UPDATE SESSION
    SET logout_time = NOW() + INTERVAL '15m'
    WHERE owner_id = v_id AND final_status = 'ACTIVE'
    RETURNING session_id INTO v_token;

    IF NOT FOUND THEN
        INSERT INTO session(owner_id)
        VALUES (v_id)
        RETURNING session_id INTO v_token;
    END IF;

    RETURN FN_SESSION_ID(v_token);
END
$$ LANGUAGE plpgsql;