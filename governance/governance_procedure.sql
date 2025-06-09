USE DATABASE EDG;
USE SCHEMA EDG.ADMIN;
CREATE OR REPLACE PROCEDURE grant_edg_access_to_roles()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'main'
  EXECUTE AS CALLER
AS
$$
from snowflake.snowpark import Session
def main(session: Session) -> str:
    roles = ['EDG_ROLE']
    schemas = ['EDG.RAW', 'EDG.PREP', 'EDG.MODEL']
    for role in roles:
        # Database-level grants
        session.sql(f"GRANT USAGE ON DATABASE EDG TO ROLE {role}").collect()
        session.sql(f"GRANT USAGE ON FUTURE SCHEMAS IN DATABASE EDG TO ROLE {role}").collect()
        session.sql(f"GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN DATABASE EDG TO ROLE {role}").collect()
        session.sql(f"GRANT SELECT ON FUTURE VIEWS IN DATABASE EDG TO ROLE {role}").collect()
        session.sql(f"GRANT CREATE SCHEMA ON DATABASE EDG TO ROLE {role}").collect()
        for schema in schemas:
            # Schema-level grants
            session.sql(f"GRANT USAGE, MODIFY ON SCHEMA {schema} TO ROLE {role}").collect()
            session.sql(f"GRANT CREATE TABLE, CREATE VIEW, CREATE STAGE, CREATE FILE FORMAT, CREATE FUNCTION, CREATE PROCEDURE ON SCHEMA {schema} TO ROLE {role}").collect()
            # Current tables and views
            session.sql(f"GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA {schema} TO ROLE {role}").collect()
            session.sql(f"GRANT SELECT ON ALL VIEWS IN SCHEMA {schema} TO ROLE {role}").collect()
            # Future tables and views
            session.sql(f"GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA {schema} TO ROLE {role}").collect()
            session.sql(f"GRANT SELECT ON FUTURE VIEWS IN SCHEMA {schema} TO ROLE {role}").collect()
            # Future other object types
            session.sql(f"GRANT USAGE ON FUTURE STAGES IN SCHEMA {schema} TO ROLE {role}").collect()
            session.sql(f"GRANT USAGE ON FUTURE FILE FORMATS IN SCHEMA {schema} TO ROLE {role}").collect()
            session.sql(f"GRANT USAGE ON FUTURE FUNCTIONS IN SCHEMA {schema} TO ROLE {role}").collect()
            session.sql(f"GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA {schema} TO ROLE {role}").collect()
    return "Grants applied to EDG_ROLE"
$$;