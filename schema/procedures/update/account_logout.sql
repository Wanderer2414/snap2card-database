-- CREATE    TABLE SESSION (
--           session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY    ,
--           login_time TIMESTAMPTZ DEFAULT NOW() NOT NULL              ,
--           logout_time TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '15m')   ,
--           final_status TYPE_STATUS_SESSION NOT NULL DEFAULT 'ACTIVE' ,
--           owner_id INT NOT NULL                                      ,
--           FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
--           );
CREATE
OR        REPLACE PROCEDURE PR_ACCOUNT_LOGOUT (p_id INT) AS $$ BEGIN
    UPDATE SESSION
    SET final_status = 'ENDED', logout_time = NOW()
    WHERE owner_id = p_id AND final_status = 'ACTIVE';
END
$$ LANGUAGE plpgsql;