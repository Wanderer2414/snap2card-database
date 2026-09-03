-- CREATE    TABLE ACCOUNT (
--           account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           account_email TYPE_EMAIL UNIQUE NOT NULL               ,
--           account_name TYPE_NAME_ACCOUNT NOT NULL                ,
--           account_phone TYPE_PHONE NOT NULL                      ,
--           account_password TYPE_PASSWORD_CRYPTED NOT NULL        ,
--           account_avatar INT DEFAULT NULL                        ,
--           account_daily_goal INT CHECK (account_daily_goal > 0)  ,
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
    INSERT INTO ACCOUNT(account_name, account_email, account_password, account_phone) VALUES (p_name, p_email, crypt(p_password, gen_salt('bf', 10)), p_phone)
    RETURNING account_id INTO v_id;

    RETURN v_id;
END $$ LANGUAGE plpgsql;