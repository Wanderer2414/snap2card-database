CREATE    TABLE SESSION (
          session_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY   ,
          login_time TIMESTAMPTZ DEFAULT NOW() NOT NULL              ,
          logout_time TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '15m')   ,
          final_status TYPE_STATUS_SESSION NOT NULL DEFAULT 'ACTIVE',
          owner_id INT NOT NULL                                     ,
          FOREIGN KEY (owner_id) REFERENCES ACCOUNT (account_id)
          );

-- DROP      TABLE SESSION CASCADE;
CREATE    TABLE SESSION_EXAM_LOG (
          session_id INT REFERENCES SESSION (session_id),
          log_id INT REFERENCES EXAM_LOG (log_id)       ,
          PRIMARY KEY (session_id, log_id)
          );