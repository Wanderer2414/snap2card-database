CREATE    INDEX IDX_SESSION_STATUS ON SESSION USING hash (owner_id)
WHERE     final_status = 'ACTIVE';

CREATE    INDEX IDX_SESSION_FINAL_TIME ON SESSION USING btree (logout_time)
WHERE     final_status = 'ACTIVE';

CREATE    INDEX IDX_COMPONENT_CONTENT ON COMPONENT USING btree (component_text)
WHERE     count_words (component_text) <= 10