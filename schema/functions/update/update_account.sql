CREATE
OR        REPLACE FUNCTION FN_UPDATE_ACCOUNT (
          p_id INT,
          p_name TYPE_NAME_ACCOUNT,
          p_email TYPE_EMAIL,
          p_phone TYPE_PHONE,
          p_avatar INT,
          p_daily_goal INT
          ) RETURNS INT AS $$
BEGIN
    UPDATE ACCOUNT
    SET account_name       = COALESCE(p_name, account_name)
      , account_email      = COALESCE(p_email, account_email)
      , account_phone      = COALESCE(p_phone, account_phone)
      , account_avatar     = COALESCE(p_avatar, account_avatar)
      , account_daily_goal = COALESCE(p_daily_goal, account_daily_goal)
    WHERE account_id = p_id;

    RETURN p_id;
END;
$$ LANGUAGE plpgsql;