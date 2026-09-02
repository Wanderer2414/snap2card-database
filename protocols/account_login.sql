-- CREATE    TABLE SESSION (
--           session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY  ,
--           login_time TIMESTAMPTZ DEFAULT NOW() NOT NULL            ,
--           logout_time TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '15m') ,
--           owner_id INT NOT NULL                                    ,
--           FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
--           );
CREATE
OR        REPLACE FUNCTION ACCOUNT_LOGIN (p_email TYPE_EMAIL, p_password TYPE_PASSWORD) RETURNS TYPE_ID AS $$
DECLARE
    v_session INT;
BEGIN
    IF p_email IS NULL THEN
        RAISE EXCEPTION 'email must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_password IS NULL THEN
        RAISE EXCEPTION 'password must not be null' USING ERRCODE = '50001';
    END IF;

    v_session := FN_ACCOUNT_LOGIN(p_email, p_password);

    IF v_session IS NULL THEN
        RAISE EXCEPTION 'invalid email or password' USING ERRCODE = '50008';
    END IF;

    RETURN FN_SESSION_ID(v_session);
END
$$ LANGUAGE plpgsql;