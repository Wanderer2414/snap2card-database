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
    IF p_id IS NULL THEN
        RAISE EXCEPTION '50001: account id must not be null';
    END IF;

    UPDATE SESSION
    SET final_status = 'ENDED', logout_time = NOW()
    WHERE owner_id = p_id AND final_status = 'ACTIVE';

    IF NOT FOUND THEN
        RAISE EXCEPTION '50005: no active session found for account';
    END IF;
END
$$ LANGUAGE plpgsql;