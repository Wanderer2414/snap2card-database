-- CREATE    TABLE SESSION (
--           session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY  ,
--           login_time TIMESTAMPTZ DEFAULT NOW() NOT NULL            ,
--           logout_time TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '15m') ,
--           owner_id INT NOT NULL                                    ,
--           FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
--           );
CREATE
OR        REPLACE FUNCTION ACCOUNT_LOGIN (p_email TYPE_EMAIL, p_password TYPE_PASSWORD) RETURNS TYPE_ID AS $$
BEGIN
    IF p_email IS NULL THEN
        RAISE EXCEPTION '50001: email must not be null';
    END IF;

    IF p_password IS NULL THEN
        RAISE EXCEPTION '50001: password must not be null';
    END IF;

    RETURN FN_SESSION_ID(FN_ACCOUNT_LOGIN(p_email, p_password));
END
$$ LANGUAGE plpgsql;