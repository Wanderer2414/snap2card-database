CREATE
OR        REPLACE FUNCTION ACCOUNT_INSERT (
          p_name TYPE_NAME_ACCOUNT,
          p_email TYPE_EMAIL      ,
          p_phone TYPE_PHONE      ,
          p_password TYPE_PASSWORD
          ) RETURNS TYPE_ID AS $$
BEGIN
    IF p_name IS NULL THEN
        RAISE EXCEPTION 'name must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_email IS NULL THEN
        RAISE EXCEPTION 'email must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_phone IS NULL THEN
        RAISE EXCEPTION 'phone must not be null' USING ERRCODE = '50001';
    END IF;

    IF p_password IS NULL THEN
        RAISE EXCEPTION 'password must not be null' USING ERRCODE = '50001';
    END IF;

    IF length(p_name) > 60 THEN
        RAISE EXCEPTION 'name must not exceed 60 characters' USING ERRCODE = '50002';
    END IF;

    IF length(p_password) > 100 THEN
        RAISE EXCEPTION 'password must not exceed 100 characters' USING ERRCODE = '50002';
    END IF;

    RETURN FN_ACCOUNT_ID(FN_ACCOUNT_INSERT(p_name, p_email, p_phone, p_password));
END
$$ LANGUAGE plpgsql;