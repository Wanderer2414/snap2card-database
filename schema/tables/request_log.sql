CREATE    TABLE REQUEST_LOG (
          request_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
          endpoint_text VARCHAR(60) NOT NULL                     ,
          header_text TEXT NOT NULL                              ,
          body_text TEXT NOT NULL                                ,
          reponse_header TEXT NOT NULL                           ,
          reponse_body TEXT NOT NULL                             ,
          date_created TIMESTAMP DEFAULT NOW()
          );

-- DROP      TABLE request_log;