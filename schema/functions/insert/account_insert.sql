-- CREATE    TABLE ACCOUNT (
--           account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           account_email TYPE_EMAIL UNIQUE NOT NULL               ,
--           account_name TYPE_NAME_ACCOUNT NOT NULL                ,
--           account_phone TYPE_PHONE NOT NULL                      ,
--           account_password TYPE_PASSWORD_CRYPTED NOT NULL        ,
--           date_created TIMESTAMPTZ DEFAULT NOW() NOT NULL
--           );
CREATE
OR        REPLACE FUNCTION FN_ACCOUNT_INSERT (
          p_name TYPE_NAME_ACCOUNT,
          p_email TYPE_EMAIL      ,
          p_phone TYPE_PHONE      ,
          p_password TYPE_PASSWORD
          ) RETURNS INT AS $$ 
DECLARE 
    v_id INT;
BEGIN
    IF p_name IS NULL THEN
        RAISE EXCEPTION '50001: name must not be null';
    END IF;

    IF p_email IS NULL THEN
        RAISE EXCEPTION '50001: email must not be null';
    END IF;

    IF p_phone IS NULL THEN
        RAISE EXCEPTION '50001: phone must not be null';
    END IF;

    IF p_password IS NULL THEN
        RAISE EXCEPTION '50001: password must not be null';
    END IF;

    IF length(p_name) > 60 THEN
        RAISE EXCEPTION '50002: name must not exceed 60 characters';
    END IF;

    IF length(p_password) > 100 THEN
        RAISE EXCEPTION '50002: password must not exceed 100 characters';
    END IF;

    INSERT INTO ACCOUNT(account_name, account_email, account_password, account_phone) VALUES (p_name, p_email, crypt(p_password, gen_salt('bf', 10)), p_phone)
    RETURNING account_id INTO v_id;

    RETURN v_id;
END $$ LANGUAGE plpgsql;