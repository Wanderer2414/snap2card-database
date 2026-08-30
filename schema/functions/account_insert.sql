-- CREATE    TABLE ACCOUNT (
--           account_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
--           account_email TYPE_EMAIL NOT NULL                      ,
--           account_name TYPE_NAME_ACCOUNT NOT NULL                ,
--           account_password TYPE_PASSWORD_CRYPTED NOT NULL        ,
--           date_created TIMESTAMP DEFAULT NOW() NOT NULL
--           );
CREATE
OR        REPLACE FUNCTION FN_ACCOUNT_INSERT (
          p_name TYPE_NAME_ACCOUNT,
          p_email TYPE_EMAIL      ,
          p_password TYPE_PASSWORD
          ) RETURNS INT AS $$ 
DECLARE 
    v_id INT;
BEGIN
    INSERT INTO ACCOUNT(account_name, account_email, account_password) VALUES (p_name, p_email, crypt(p_password, gen_salt('bf', 10)))
    RETURNING account_id INTO v_id;

    RETURN v_id;
END $$ LANGUAGE plpgsql;