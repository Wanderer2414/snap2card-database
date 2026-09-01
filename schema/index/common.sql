CREATE    INDEX IDX_SESSION_STATUS ON SESSION (owner_id)
WHERE     final_status = 'ACTIVE';

CREATE    INDEX IDX_COMPONENT_CONTENT ON COMPONENT USING btree (component_text)
WHERE     count_words (component_text) <= 10